pageextension 50203 ItemListExt extends "Item List"
{
    actions
    {
        addfirst(processing)
        {
            action(BulkUpdateItemDescription)
            {
                ApplicationArea = All;
                Caption = 'Bulk update Item Description';
                Promoted = true;
                PromotedCategory = Process;
                Image = Open;
                trigger OnAction()
                var
                    UpdateItemDescriptionDialog: Page "Update Item Description Dialog";
                    Item: Record Item;
                    ItemFilter: Code[250];
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                begin
                    Item.Reset();
                    CurrPage.SetSelectionFilter(Item);
                    if not Item.IsEmpty then
                        ItemFilter := SelectionFilterManagement.GetSelectionFilterForItem(Item);
                    UpdateItemDescriptionDialog.GetSelectionFilter(ItemFilter);
                    if UpdateItemDescriptionDialog.RunModal() = Action::OK then
                        UpdateItemDescriptionDialog.UpdateItemDescription();
                end;
            }
        }
    }
}
page 50200 "Update Item Description Dialog"
{
    PageType = StandardDialog;
    Caption = 'Update Item Description Dialog';
    layout
    {
        area(content)
        {
            field(ItemFilter; ItemFilter)
            {
                ApplicationArea = All;
                Caption = 'Item Filter';
                Editable = false;
            }
            field(NewItemDescription; NewItemDescription)
            {
                ApplicationArea = All;
                Caption = 'New Item Description';
            }
        }
    }
    var
        ItemFilter: Code[250];
        NewItemDescription: Text[100];

    procedure GetSelectionFilter(ItemPageFilter: Code[250])
    begin
        ItemFilter := '';
        ItemFilter := ItemPageFilter;
    end;

    procedure UpdateItemDescription()
    var
        Item: Record Item;
    begin
        Item.Reset();
        Item.SetFilter("No.", ItemFilter);
        if Item.FindSet() then
            repeat
                Item.Validate(Description, NewItemDescription);
                Item.Modify(true);
            until Item.Next() = 0;
    end;
}
