Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2DQApr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:45:47 -0400
Received: from moh2-ve2.go2.pl ([193.17.41.200]:54105 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab2DQApo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:45:44 -0400
X-Greylist: delayed 818 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 20:45:43 EDT
Date: Tue, 17 Apr 2012 02:31:55 +0200
From: =?utf-8?B?UmFmYcWCIE11xbx5xYJv?= <galtgendo@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: [RFC] updating gconfig (patch against kernel 3.2.1)
Message-ID: <20120417003155.GA2454@blackspire>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-O2-Trust: 2, 61
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Awhile ago, I've been wondering if anybody would be interested in bumping
gtk version requirement for gconfig, in order to drop libglade
dependency.

That, in turn, would make it possible for building it against gtk 3,
with a few tweaks.

Attached patch is more of an idea, than anything complete. AFAICT, it
seems to be working correctly (for the most part) with gtk 2 and is also
partially working with gtk3.

There's quite a bit of cruft there, as I still haven't figured out how
to correctly initialize the initial interface choice
(full/split/single).

Also, with gtk 3, something isn't working correctly in single/full
(split seems fine) and there are odd gtk warnings upon closing - I'll
need to look into that.

gconf.glade is attached as a new file, as it's a gtkbuilder file now.
IIRC, GDK_<> -> GDK_KEY_<> would require at least gtk 2.22, but that
could be dealt with a couple #ifdef, other than that, at most 2.14 would
be needed.

So, if there's any interest, comments are welcome.


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="gconf-no-glade.patch"

--- scripts/kconfig/gconf.c	2012-01-05 00:55:44.000000000 +0100
+++ scripts/kconfig/gconf.c	2012-04-17 01:41:52.145427498 +0200
@@ -13,7 +13,6 @@
 #include "lkc.h"
 #include "images.c"
 
-#include <glade/glade.h>
 #include <gtk/gtk.h>
 #include <glib.h>
 #include <gdk/gdkkeysyms.h>
@@ -41,15 +40,14 @@ static gboolean show_value = TRUE;
 static gboolean resizeable = FALSE;
 static int opt_mode = OPT_NORMAL;
 
-GtkWidget *main_wnd = NULL;
+GObject *main_wnd = NULL;
 GtkWidget *tree1_w = NULL;	// left  frame
 GtkWidget *tree2_w = NULL;	// right frame
-GtkWidget *text_w = NULL;
-GtkWidget *hpaned = NULL;
-GtkWidget *vpaned = NULL;
+GObject *text_w = NULL;
+GObject *hpaned = NULL;
+GObject *vpaned = NULL;
 GtkWidget *back_btn = NULL;
-GtkWidget *save_btn = NULL;
-GtkWidget *save_menu_item = NULL;
+GObject *save_action = NULL;
 
 GtkTextTag *tag1, *tag2;
 GdkColor color;
@@ -109,20 +107,17 @@ const char *dbg_sym_flags(int val)
 	return buf;
 }
 
-void replace_button_icon(GladeXML * xml, GdkDrawable * window,
-			 GtkStyle * style, gchar * btn_name, gchar ** xpm)
+void replace_button_icon(GtkBuilder * xml,
+			 gchar * btn_name, gchar ** xpm)
 {
-	GdkPixmap *pixmap;
-	GdkBitmap *mask;
+	GdkPixbuf *pixmap;
 	GtkToolButton *button;
 	GtkWidget *image;
 
-	pixmap = gdk_pixmap_create_from_xpm_d(window, &mask,
-					      &style->bg[GTK_STATE_NORMAL],
-					      xpm);
+	pixmap = gdk_pixbuf_new_from_xpm_data((const char**)xpm);
 
-	button = GTK_TOOL_BUTTON(glade_xml_get_widget(xml, btn_name));
-	image = gtk_image_new_from_pixmap(pixmap, mask);
+	button = GTK_TOOL_BUTTON(gtk_builder_get_object(xml, btn_name));
+	image = gtk_image_new_from_pixbuf(pixmap);
 	gtk_widget_show(image);
 	gtk_tool_button_set_icon_widget(button, image);
 }
@@ -130,72 +125,97 @@ void replace_button_icon(GladeXML * xml,
 /* Main Window Initialization */
 void init_main_window(const gchar * glade_file)
 {
-	GladeXML *xml;
-	GtkWidget *widget;
+	GtkBuilder *xml;
+	GObject *widget;
 	GtkTextBuffer *txtbuf;
+	/*
 	GtkStyle *style;
+	GtkUIManager *ui_manager;
+	GtkActionGroup *action_group;
+	GtkAccelGroup *accel_group;
+	*/
+#if 0
+	const gchar * objects[] = {
+		"window1",
+		"textbuffer1",
+		"quit",
+		"save-as",
+		"open",
+		"save",
+		/* "gconfig-actions", */
+		"gconfig-radio-actions",
+		"image43",
+		"image44",
+		"image45"
+		};
+#endif
+	GError *error = NULL;
 
-	xml = glade_xml_new(glade_file, "window1", NULL);
-	if (!xml)
-		g_error(_("GUI loading failed !\n"));
-	glade_xml_signal_autoconnect(xml);
-
-	main_wnd = glade_xml_get_widget(xml, "window1");
-	hpaned = glade_xml_get_widget(xml, "hpaned1");
-	vpaned = glade_xml_get_widget(xml, "vpaned1");
-	tree1_w = glade_xml_get_widget(xml, "treeview1");
-	tree2_w = glade_xml_get_widget(xml, "treeview2");
-	text_w = glade_xml_get_widget(xml, "textview3");
+	xml = gtk_builder_new();
+	//gtk_builder_add_objects_from_file(xml, glade_file, objects, &error);
+	gtk_builder_add_from_file(xml, glade_file, &error);
+	if (error)
+		g_error(_("GUI loading failed ! %s\n"), error->message);
+	gtk_builder_connect_signals(xml, NULL);
+
+/*
+	ui_manager = gtk_ui_manager_new();
+	action_group = (GtkActionGroup*)
+		gtk_builder_get_object(xml, "gconfig-actions");
+	gtk_ui_manager_insert_action_group(ui_manager, action_group, NULL);
+	accel_group = gtk_ui_manager_get_accel_group(ui_manager);
+	gtk_window_add_accel_group(GTK_WINDOW(main_wnd), accel_group);
+*/
+
+	main_wnd = gtk_builder_get_object(xml, "window1");
+	hpaned = gtk_builder_get_object(xml, "hpaned1");
+	vpaned = gtk_builder_get_object(xml, "vpaned1");
+	tree1_w = GTK_WIDGET(gtk_builder_get_object(xml, "treeview1"));
+	tree2_w = GTK_WIDGET(gtk_builder_get_object(xml, "treeview2"));
+	text_w = gtk_builder_get_object(xml, "textview3");
 
-	back_btn = glade_xml_get_widget(xml, "button1");
+	back_btn = GTK_WIDGET(gtk_builder_get_object(xml, "button1"));
 	gtk_widget_set_sensitive(back_btn, FALSE);
 
-	widget = glade_xml_get_widget(xml, "show_name1");
+	widget = gtk_builder_get_object(xml, "show_name1");
 	gtk_check_menu_item_set_active((GtkCheckMenuItem *) widget,
 				       show_name);
 
-	widget = glade_xml_get_widget(xml, "show_range1");
+	widget = gtk_builder_get_object(xml, "show_range1");
 	gtk_check_menu_item_set_active((GtkCheckMenuItem *) widget,
 				       show_range);
 
-	widget = glade_xml_get_widget(xml, "show_data1");
+	widget = gtk_builder_get_object(xml, "show_data1");
 	gtk_check_menu_item_set_active((GtkCheckMenuItem *) widget,
 				       show_value);
 
-	save_btn = glade_xml_get_widget(xml, "button3");
-	save_menu_item = glade_xml_get_widget(xml, "save1");
+	save_action = gtk_builder_get_object(xml, "save");
 	conf_set_changed_callback(conf_changed);
 
-	style = gtk_widget_get_style(main_wnd);
-	widget = glade_xml_get_widget(xml, "toolbar1");
+	/* style = gtk_widget_get_style(main_wnd); */
+	widget = gtk_builder_get_object(xml, "toolbar1");
 
 #if 0	/* Use stock Gtk icons instead */
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button1", (gchar **) xpm_back);
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button2", (gchar **) xpm_load);
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button3", (gchar **) xpm_save);
+	replace_button_icon(xml, "button1", (gchar **) xpm_back);
+	replace_button_icon(xml, "button2", (gchar **) xpm_load);
+	replace_button_icon(xml, "button3", (gchar **) xpm_save);
 #endif
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button4", (gchar **) xpm_single_view);
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button5", (gchar **) xpm_split_view);
-	replace_button_icon(xml, main_wnd->window, style,
-			    "button6", (gchar **) xpm_tree_view);
+	replace_button_icon(xml, "button4", (gchar **) xpm_single_view);
+	replace_button_icon(xml, "button5", (gchar **) xpm_split_view);
+	replace_button_icon(xml, "button6", (gchar **) xpm_tree_view);
 
 #if 0
 	switch (view_mode) {
 	case SINGLE_VIEW:
-		widget = glade_xml_get_widget(xml, "button4");
+		widget = gtk_builder_get_object(xml, "button4");
 		g_signal_emit_by_name(widget, "clicked");
 		break;
 	case SPLIT_VIEW:
-		widget = glade_xml_get_widget(xml, "button5");
+		widget = gtk_builder_get_object(xml, "button5");
 		g_signal_emit_by_name(widget, "clicked");
 		break;
 	case FULL_VIEW:
-		widget = glade_xml_get_widget(xml, "button6");
+		widget = gtk_builder_get_object(xml, "button6");
 		g_signal_emit_by_name(widget, "clicked");
 		break;
 	}
@@ -211,7 +231,7 @@ void init_main_window(const gchar * glad
 
 	gtk_window_set_title(GTK_WINDOW(main_wnd), rootmenu.prompt->text);
 
-	gtk_widget_show(main_wnd);
+	gtk_widget_show(GTK_WIDGET(main_wnd));
 }
 
 void init_tree_model(void)
@@ -222,7 +242,7 @@ void init_tree_model(void)
 					  G_TYPE_STRING, G_TYPE_STRING,
 					  G_TYPE_STRING, G_TYPE_STRING,
 					  G_TYPE_STRING, G_TYPE_STRING,
-					  G_TYPE_POINTER, GDK_TYPE_COLOR,
+					  G_TYPE_POINTER, G_TYPE_STRING,
 					  G_TYPE_BOOLEAN, GDK_TYPE_PIXBUF,
 					  G_TYPE_BOOLEAN, G_TYPE_BOOLEAN,
 					  G_TYPE_BOOLEAN, G_TYPE_BOOLEAN,
@@ -236,7 +256,7 @@ void init_tree_model(void)
 				   G_TYPE_STRING, G_TYPE_STRING,
 				   G_TYPE_STRING, G_TYPE_STRING,
 				   G_TYPE_STRING, G_TYPE_STRING,
-				   G_TYPE_POINTER, GDK_TYPE_COLOR,
+				   G_TYPE_POINTER, G_TYPE_STRING,
 				   G_TYPE_BOOLEAN, GDK_TYPE_PIXBUF,
 				   G_TYPE_BOOLEAN, G_TYPE_BOOLEAN,
 				   G_TYPE_BOOLEAN, G_TYPE_BOOLEAN,
@@ -274,7 +294,7 @@ void init_left_tree(void)
 	gtk_tree_view_column_set_attributes(GTK_TREE_VIEW_COLUMN(column),
 					    renderer,
 					    "text", COL_OPTION,
-					    "foreground-gdk",
+					    "foreground",
 					    COL_COLOR, NULL);
 
 	sel = gtk_tree_view_get_selection(view);
@@ -324,32 +344,32 @@ void init_right_tree(void)
 	gtk_tree_view_column_set_attributes(GTK_TREE_VIEW_COLUMN(column),
 					    renderer,
 					    "text", COL_OPTION,
-					    "foreground-gdk",
+					    "foreground",
 					    COL_COLOR, NULL);
 
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_insert_column_with_attributes(view, -1,
 						    _("Name"), renderer,
 						    "text", COL_NAME,
-						    "foreground-gdk",
+						    "foreground",
 						    COL_COLOR, NULL);
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_insert_column_with_attributes(view, -1,
 						    "N", renderer,
 						    "text", COL_NO,
-						    "foreground-gdk",
+						    "foreground",
 						    COL_COLOR, NULL);
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_insert_column_with_attributes(view, -1,
 						    "M", renderer,
 						    "text", COL_MOD,
-						    "foreground-gdk",
+						    "foreground",
 						    COL_COLOR, NULL);
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_insert_column_with_attributes(view, -1,
 						    "Y", renderer,
 						    "text", COL_YES,
-						    "foreground-gdk",
+						    "foreground",
 						    COL_COLOR, NULL);
 	renderer = gtk_cell_renderer_text_new();
 	gtk_tree_view_insert_column_with_attributes(view, -1,
@@ -357,7 +377,7 @@ void init_right_tree(void)
 						    "text", COL_VALUE,
 						    "editable",
 						    COL_EDIT,
-						    "foreground-gdk",
+						    "foreground",
 						    COL_COLOR, NULL);
 	g_signal_connect(G_OBJECT(renderer), "edited",
 			 G_CALLBACK(renderer_edited), NULL);
@@ -436,7 +456,7 @@ static void text_insert_msg(const char *
 
 /* Main Windows Callbacks */
 
-void on_save_activate(GtkMenuItem * menuitem, gpointer user_data);
+void on_save_activate(GtkAction * menuitem, gpointer user_data);
 gboolean on_window1_delete_event(GtkWidget * widget, GdkEvent * event,
 				 gpointer user_data)
 {
@@ -461,7 +481,8 @@ gboolean on_window1_delete_event(GtkWidg
 					GTK_RESPONSE_CANCEL);
 
 	label = gtk_label_new(_("\nSave configuration ?\n"));
-	gtk_container_add(GTK_CONTAINER(GTK_DIALOG(dialog)->vbox), label);
+	gtk_container_add(GTK_CONTAINER(
+		gtk_dialog_get_content_area(GTK_DIALOG(dialog))), label);
 	gtk_widget_show(label);
 
 	result = gtk_dialog_run(GTK_DIALOG(dialog));
@@ -482,7 +503,7 @@ gboolean on_window1_delete_event(GtkWidg
 }
 
 
-void on_window1_destroy(GtkObject * object, gpointer user_data)
+void on_window1_destroy(GtkWidget * object, gpointer user_data)
 {
 	gtk_main_quit();
 }
@@ -490,15 +511,12 @@ void on_window1_destroy(GtkObject * obje
 
 void
 on_window1_size_request(GtkWidget * widget,
-			GtkRequisition * requisition, gpointer user_data)
+			GdkRectangle * allocation, gpointer user_data)
 {
-	static gint old_h;
-	gint w, h;
+	static gint old_h = -1;
+	gint h;
 
-	if (widget->window == NULL)
-		gtk_window_get_default_size(GTK_WINDOW(main_wnd), &w, &h);
-	else
-		gdk_window_get_size(widget->window, &w, &h);
+	h = allocation->height;
 
 	if (h == old_h)
 		return;
@@ -512,40 +530,41 @@ on_window1_size_request(GtkWidget * widg
 
 
 static void
-load_filename(GtkFileSelection * file_selector, gpointer user_data)
+load_filename(GtkWidget * file_selector, gint response, gpointer user_data)
 {
 	const gchar *fn;
 
-	fn = gtk_file_selection_get_filename(GTK_FILE_SELECTION
-					     (user_data));
+	if (response == GTK_RESPONSE_ACCEPT) {
+	fn = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER
+					     (file_selector));
 
 	if (conf_read(fn))
 		text_insert_msg(_("Error"), _("Unable to load configuration !"));
 	else
 		display_tree(&rootmenu);
+	}
+
+	gtk_widget_destroy(file_selector);
 }
 
-void on_load1_activate(GtkMenuItem * menuitem, gpointer user_data)
+void on_load1_activate(GtkAction * menuitem, gpointer user_data)
 {
 	GtkWidget *fs;
 
-	fs = gtk_file_selection_new(_("Load file..."));
-	g_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(fs)->ok_button),
-			 "clicked",
-			 G_CALLBACK(load_filename), (gpointer) fs);
-	g_signal_connect_swapped(GTK_OBJECT
-				 (GTK_FILE_SELECTION(fs)->ok_button),
-				 "clicked", G_CALLBACK(gtk_widget_destroy),
-				 (gpointer) fs);
-	g_signal_connect_swapped(GTK_OBJECT
-				 (GTK_FILE_SELECTION(fs)->cancel_button),
-				 "clicked", G_CALLBACK(gtk_widget_destroy),
-				 (gpointer) fs);
+	fs = gtk_file_chooser_dialog_new(_("Load file..."),
+		GTK_WINDOW(main_wnd),
+		GTK_FILE_CHOOSER_ACTION_OPEN,
+		GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
+		GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
+		NULL);
+	g_signal_connect(G_OBJECT(fs),
+			 "response",
+			 G_CALLBACK(load_filename), NULL);
 	gtk_widget_show(fs);
 }
 
 
-void on_save_activate(GtkMenuItem * menuitem, gpointer user_data)
+void on_save_activate(GtkAction * menuitem, gpointer user_data)
 {
 	if (conf_write(NULL))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
@@ -553,40 +572,39 @@ void on_save_activate(GtkMenuItem * menu
 
 
 static void
-store_filename(GtkFileSelection * file_selector, gpointer user_data)
+store_filename(GtkWidget * file_selector, gint response, gpointer user_data)
 {
 	const gchar *fn;
+	if (response == GTK_RESPONSE_ACCEPT) {
 
-	fn = gtk_file_selection_get_filename(GTK_FILE_SELECTION
-					     (user_data));
+	fn = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER
+					     (file_selector));
 
 	if (conf_write(fn))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
+	}
 
-	gtk_widget_destroy(GTK_WIDGET(user_data));
+	gtk_widget_destroy(user_data);
 }
 
-void on_save_as1_activate(GtkMenuItem * menuitem, gpointer user_data)
+void on_save_as1_activate(GtkAction * menuitem, gpointer user_data)
 {
 	GtkWidget *fs;
 
-	fs = gtk_file_selection_new(_("Save file as..."));
-	g_signal_connect(GTK_OBJECT(GTK_FILE_SELECTION(fs)->ok_button),
-			 "clicked",
-			 G_CALLBACK(store_filename), (gpointer) fs);
-	g_signal_connect_swapped(GTK_OBJECT
-				 (GTK_FILE_SELECTION(fs)->ok_button),
-				 "clicked", G_CALLBACK(gtk_widget_destroy),
-				 (gpointer) fs);
-	g_signal_connect_swapped(GTK_OBJECT
-				 (GTK_FILE_SELECTION(fs)->cancel_button),
-				 "clicked", G_CALLBACK(gtk_widget_destroy),
-				 (gpointer) fs);
+	fs = gtk_file_chooser_dialog_new(_("Save file as..."),
+		GTK_WINDOW(main_wnd),
+		GTK_FILE_CHOOSER_ACTION_SAVE,
+		GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
+		GTK_STOCK_SAVE, GTK_RESPONSE_ACCEPT,
+		NULL);
+	g_signal_connect(G_OBJECT(fs),
+			 "response",
+			 G_CALLBACK(store_filename), NULL);
 	gtk_widget_show(fs);
 }
 
 
-void on_quit1_activate(GtkMenuItem * menuitem, gpointer user_data)
+void on_quit1_activate(GtkAction * menuitem, gpointer user_data)
 {
 	if (!on_window1_delete_event(NULL, NULL, NULL))
 		gtk_widget_destroy(GTK_WIDGET(main_wnd));
@@ -597,7 +615,8 @@ void on_show_name1_activate(GtkMenuItem
 {
 	GtkTreeViewColumn *col;
 
-	show_name = GTK_CHECK_MENU_ITEM(menuitem)->active;
+	show_name = gtk_check_menu_item_get_active(
+		GTK_CHECK_MENU_ITEM(menuitem));
 	col = gtk_tree_view_get_column(GTK_TREE_VIEW(tree2_w), COL_NAME);
 	if (col)
 		gtk_tree_view_column_set_visible(col, show_name);
@@ -608,7 +627,8 @@ void on_show_range1_activate(GtkMenuItem
 {
 	GtkTreeViewColumn *col;
 
-	show_range = GTK_CHECK_MENU_ITEM(menuitem)->active;
+	show_range = gtk_check_menu_item_get_active(
+		GTK_CHECK_MENU_ITEM(menuitem));
 	col = gtk_tree_view_get_column(GTK_TREE_VIEW(tree2_w), COL_NO);
 	if (col)
 		gtk_tree_view_column_set_visible(col, show_range);
@@ -626,7 +646,8 @@ void on_show_data1_activate(GtkMenuItem
 {
 	GtkTreeViewColumn *col;
 
-	show_value = GTK_CHECK_MENU_ITEM(menuitem)->active;
+	show_value = gtk_check_menu_item_get_active(
+		GTK_CHECK_MENU_ITEM(menuitem));
 	col = gtk_tree_view_get_column(GTK_TREE_VIEW(tree2_w), COL_VALUE);
 	if (col)
 		gtk_tree_view_column_set_visible(col, show_value);
@@ -683,10 +704,10 @@ void on_introduction1_activate(GtkMenuIt
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, intro_text);
-	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
+					GTK_BUTTONS_CLOSE, "%s", intro_text);
+	g_signal_connect_swapped(G_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
-				 GTK_OBJECT(dialog));
+				 G_OBJECT(dialog));
 	gtk_widget_show_all(dialog);
 }
 
@@ -701,10 +722,10 @@ void on_about1_activate(GtkMenuItem * me
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, about_text);
-	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
+					GTK_BUTTONS_CLOSE, "%s", about_text);
+	g_signal_connect_swapped(G_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
-				 GTK_OBJECT(dialog));
+				 G_OBJECT(dialog));
 	gtk_widget_show_all(dialog);
 }
 
@@ -720,10 +741,10 @@ void on_license1_activate(GtkMenuItem *
 	dialog = gtk_message_dialog_new(GTK_WINDOW(main_wnd),
 					GTK_DIALOG_DESTROY_WITH_PARENT,
 					GTK_MESSAGE_INFO,
-					GTK_BUTTONS_CLOSE, license_text);
-	g_signal_connect_swapped(GTK_OBJECT(dialog), "response",
+					GTK_BUTTONS_CLOSE, "%s", license_text);
+	g_signal_connect_swapped(G_OBJECT(dialog), "response",
 				 G_CALLBACK(gtk_widget_destroy),
-				 GTK_OBJECT(dialog));
+				 G_OBJECT(dialog));
 	gtk_widget_show_all(dialog);
 }
 
@@ -743,13 +764,7 @@ void on_back_clicked(GtkButton * button,
 }
 
 
-void on_load_clicked(GtkButton * button, gpointer user_data)
-{
-	on_load1_activate(NULL, user_data);
-}
-
-
-void on_single_clicked(GtkButton * button, gpointer user_data)
+void on_single_clicked(GtkAction * button, gpointer user_data)
 {
 	view_mode = SINGLE_VIEW;
 	gtk_widget_hide(tree1_w);
@@ -758,7 +773,7 @@ void on_single_clicked(GtkButton * butto
 }
 
 
-void on_split_clicked(GtkButton * button, gpointer user_data)
+void on_split_clicked(GtkAction * button, gpointer user_data)
 {
 	gint w, h;
 	view_mode = SPLIT_VIEW;
@@ -774,7 +789,7 @@ void on_split_clicked(GtkButton * button
 }
 
 
-void on_full_clicked(GtkButton * button, gpointer user_data)
+void on_full_clicked(GtkAction * button, gpointer user_data)
 {
 	view_mode = FULL_VIEW;
 	gtk_widget_hide(tree1_w);
@@ -973,14 +988,14 @@ on_treeview2_key_press_event(GtkWidget *
 	if (path == NULL)
 		return FALSE;
 
-	if (event->keyval == GDK_space) {
+	if (event->keyval == GDK_KEY_space) {
 		if (gtk_tree_view_row_expanded(view, path))
 			gtk_tree_view_collapse_row(view, path);
 		else
 			gtk_tree_view_expand_row(view, path, FALSE);
 		return TRUE;
 	}
-	if (event->keyval == GDK_KP_Enter) {
+	if (event->keyval == GDK_KEY_KP_Enter) {
 	}
 	if (widget == tree1_w)
 		return FALSE;
@@ -1186,17 +1201,11 @@ static gchar **fill_row(struct menu *men
 /* Set the node content with a row of strings */
 static void set_node(GtkTreeIter * node, struct menu *menu, gchar ** row)
 {
-	GdkColor color;
-	gboolean success;
 	GdkPixbuf *pix;
 
 	pix = gdk_pixbuf_new_from_xpm_data((const char **)
 					   row[COL_PIXBUF]);
 
-	gdk_color_parse(row[COL_COLOR], &color);
-	gdk_colormap_alloc_colors(gdk_colormap_get_system(), &color, 1,
-				  FALSE, FALSE, &success);
-
 	gtk_tree_store_set(tree, node,
 			   COL_OPTION, row[COL_OPTION],
 			   COL_NAME, row[COL_NAME],
@@ -1205,7 +1214,7 @@ static void set_node(GtkTreeIter * node,
 			   COL_YES, row[COL_YES],
 			   COL_VALUE, row[COL_VALUE],
 			   COL_MENU, (gpointer) menu,
-			   COL_COLOR, &color,
+			   COL_COLOR, row[COL_COLOR],
 			   COL_EDIT, GPOINTER_TO_INT(row[COL_EDIT]),
 			   COL_PIXBUF, pix,
 			   COL_PIXVIS, GPOINTER_TO_INT(row[COL_PIXVIS]),
@@ -1479,9 +1488,8 @@ int main(int ac, char *av[])
 	textdomain(PACKAGE);
 
 	/* GTK stuffs */
-	gtk_set_locale();
+	setlocale(LC_ALL, "");
 	gtk_init(&ac, &av);
-	glade_init();
 
 	//add_pixmap_directory (PACKAGE_DATA_DIR "/" PACKAGE "/pixmaps");
 	//add_pixmap_directory (PACKAGE_SOURCE_DIR "/pixmaps");
@@ -1540,6 +1548,5 @@ int main(int ac, char *av[])
 static void conf_changed(void)
 {
 	bool changed = conf_get_changed();
-	gtk_widget_set_sensitive(save_btn, changed);
-	gtk_widget_set_sensitive(save_menu_item, changed);
+	gtk_action_set_sensitive((GtkAction*)save_action, changed);
 }

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="gconf.glade"
Content-Transfer-Encoding: 8bit

<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <requires lib="gtk+" version="2.16"/>
  <!-- interface-naming-policy project-wide -->
  <object class="GtkAccelGroup" id="accelgroup1"/>
  <object class="GtkActionGroup" id="gconfig-actions"/>
  <object class="GtkAction" id="open">
  <!--
    <property name="label" translatable="yes">_Otwórz</property>
    <property name="short_label" translatable="yes">_Otwórz</property>
  -->
    <property name="tooltip" translatable="yes">Load a config file</property>
    <property name="stock_id">gtk-open</property>
    <signal name="activate" handler="on_load1_activate" swapped="no"/>
  </object>
  <object class="GtkAction" id="quit">
  <!--
    <property name="label" translatable="yes">Za_kończ</property>
    <property name="short_label" translatable="yes">Za_kończ</property>
  -->
    <property name="stock_id">gtk-quit</property>
    <signal name="activate" handler="on_quit1_activate" swapped="no"/>
  </object>
  <object class="GtkActionGroup" id="gconfig-radio-actions">
    <child>
      <object class="GtkRadioAction" id="radioaction3">
        <property name="label" translatable="yes">Full</property>
        <property name="tooltip" translatable="yes">Full view</property>
        <property name="active">True</property>
        <signal name="activate" handler="on_full_clicked" swapped="no"/>
      </object>
    </child>
    <child>
      <object class="GtkRadioAction" id="radioaction2">
        <property name="label" translatable="yes">Split</property>
        <property name="tooltip" translatable="yes">Split view</property>
        <property name="group">radioaction3</property>
        <signal name="activate" handler="on_split_clicked" swapped="no"/>
      </object>
    </child>
    <child>
      <object class="GtkRadioAction" id="radioaction1">
        <property name="label" translatable="yes">Single</property>
        <property name="tooltip" translatable="yes">Single view</property>
        <property name="group">radioaction3</property>
        <signal name="activate" handler="on_single_clicked" swapped="no"/>
      </object>
    </child>
  </object>
  <object class="GtkAction" id="save">
  <!--
    <property name="label" translatable="yes">_Zapisz</property>
    <property name="short_label" translatable="yes">_Zapisz</property>
  -->
    <property name="tooltip" translatable="yes">Save the config in .config</property>
    <property name="stock_id">gtk-save</property>
    <property name="sensitive">False</property>
    <signal name="activate" handler="on_save_activate" swapped="no"/>
  </object>
  <object class="GtkAction" id="save-as">
  <!--
    <property name="label" translatable="yes">Zapi_sz jako</property>
    <property name="short_label" translatable="yes">Zapi_sz jako</property>
  -->
    <property name="tooltip" translatable="yes">Save the config in a file</property>
    <property name="stock_id">gtk-save-as</property>
    <signal name="activate" handler="on_save_as1_activate" swapped="no"/>
  </object>
  <object class="GtkImage" id="image43">
    <property name="visible">True</property>
    <property name="can_focus">False</property>
    <property name="stock">gtk-dialog-question</property>
    <property name="icon-size">1</property>
  </object>
  <object class="GtkImage" id="image44">
    <property name="visible">True</property>
    <property name="can_focus">False</property>
    <property name="stock">gtk-properties</property>
    <property name="icon-size">1</property>
  </object>
  <object class="GtkImage" id="image45">
    <property name="visible">True</property>
    <property name="can_focus">False</property>
    <property name="stock">gtk-justify-fill</property>
    <property name="icon-size">1</property>
  </object>
  <object class="GtkTextBuffer" id="textbuffer1">
    <property name="text" translatable="yes">Sorry, no help available for this option yet.</property>
  </object>
  <object class="GtkWindow" id="window1">
    <property name="visible">True</property>
    <property name="can_focus">False</property>
    <property name="title" translatable="yes">Gtk Kernel Configurator</property>
    <property name="default_width">640</property>
    <property name="default_height">480</property>
    <accel-groups>
      <group name="accelgroup1"/>
    </accel-groups>
    <signal name="destroy" handler="on_window1_destroy" object="window1" swapped="yes"/>
    <signal name="delete-event" handler="on_window1_delete_event" object="window1" swapped="yes"/>
    <signal name="size-allocate" handler="on_window1_size_request" after="yes" swapped="no"/>
    <child>
      <object class="GtkVBox" id="vbox1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <child>
          <object class="GtkMenuBar" id="menubar1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkMenuItem" id="file1">
                <property name="use_action_appearance">False</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_File</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="file1_menu">
                    <property name="can_focus">False</property>
                    <property name="accel_group">accelgroup1</property>
                    <child>
                      <object class="GtkImageMenuItem" id="load1">
                        <property name="related_action">open</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Load a config file</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                        <accelerator key="l" signal="activate" modifiers="GDK_CONTROL_MASK"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="save1">
                        <property name="related_action">save</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Save the config in .config</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                        <accelerator key="s" signal="activate" modifiers="GDK_CONTROL_MASK"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="save_as1">
                        <property name="related_action">save-as</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Save the config in a file</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkSeparatorMenuItem" id="separator1">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="quit1">
                        <property name="related_action">quit</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="use_stock">True</property>
                        <accelerator key="q" signal="activate" modifiers="GDK_CONTROL_MASK"/>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
            <child>
              <object class="GtkMenuItem" id="options1">
                <property name="use_action_appearance">False</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_Options</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="options1_menu">
                    <property name="can_focus">False</property>
                    <child>
                      <object class="GtkCheckMenuItem" id="show_name1">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show name</property>
                        <property name="label" translatable="yes">Show _name</property>
                        <property name="use_underline">True</property>
                        <signal name="activate" handler="on_show_name1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkCheckMenuItem" id="show_range1">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show range (Y/M/N)</property>
                        <property name="label" translatable="yes">Show _range</property>
                        <property name="use_underline">True</property>
                        <signal name="activate" handler="on_show_range1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkCheckMenuItem" id="show_data1">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show value of the option</property>
                        <property name="label" translatable="yes">Show _data</property>
                        <property name="use_underline">True</property>
                        <signal name="activate" handler="on_show_data1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkSeparatorMenuItem" id="separator2">
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkRadioMenuItem" id="set_option_mode1">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show normal options</property>
                        <property name="label" translatable="yes">Show normal options</property>
                        <property name="use_underline">True</property>
                        <property name="active">True</property>
                        <signal name="activate" handler="on_set_option_mode1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkRadioMenuItem" id="set_option_mode2">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show all options</property>
                        <property name="label" translatable="yes">Show all _options</property>
                        <property name="use_underline">True</property>
                        <property name="group">set_option_mode1</property>
                        <signal name="activate" handler="on_set_option_mode2_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkRadioMenuItem" id="set_option_mode3">
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="tooltip_text" translatable="yes">Show all options with prompts</property>
                        <property name="label" translatable="yes">Show all prompt options</property>
                        <property name="use_underline">True</property>
                        <property name="group">set_option_mode1</property>
                        <signal name="activate" handler="on_set_option_mode3_activate" swapped="no"/>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
            <child>
              <object class="GtkMenuItem" id="help1">
                <property name="use_action_appearance">False</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="label" translatable="yes">_Help</property>
                <property name="use_underline">True</property>
                <child type="submenu">
                  <object class="GtkMenu" id="help1_menu">
                    <property name="can_focus">False</property>
                    <child>
                      <object class="GtkImageMenuItem" id="introduction1">
                        <property name="label" translatable="yes">_Introduction</property>
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="image">image43</property>
                        <property name="use_stock">False</property>
                        <accelerator key="I" signal="activate" modifiers="GDK_CONTROL_MASK"/>
                        <signal name="activate" handler="on_introduction1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="about1">
                        <property name="label" translatable="yes">_About</property>
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="image">image44</property>
                        <property name="use_stock">False</property>
                        <accelerator key="A" signal="activate" modifiers="GDK_CONTROL_MASK"/>
                        <signal name="activate" handler="on_about1_activate" swapped="no"/>
                      </object>
                    </child>
                    <child>
                      <object class="GtkImageMenuItem" id="license1">
                        <property name="label" translatable="yes">_License</property>
                        <property name="use_action_appearance">False</property>
                        <property name="visible">True</property>
                        <property name="can_focus">False</property>
                        <property name="use_underline">True</property>
                        <property name="image">image45</property>
                        <property name="use_stock">False</property>
                        <signal name="activate" handler="on_license1_activate" swapped="no"/>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">False</property>
            <property name="position">0</property>
          </packing>
        </child>
        <child>
          <object class="GtkHandleBox" id="handlebox1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkToolbar" id="toolbar1">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="toolbar_style">both</property>
                <child>
                  <object class="GtkToolButton" id="button1">
                    <property name="use_action_appearance">False</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="tooltip_text" translatable="yes">Goes up of one level (single view)</property>
                    <property name="label" translatable="yes">Back</property>
                    <property name="use_underline">True</property>
                    <property name="stock_id">gtk-undo</property>
                    <signal name="clicked" handler="on_back_clicked" swapped="no"/>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkSeparatorToolItem" id="toolitem1">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkToolButton" id="button2">
                    <property name="related_action">open</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="tooltip_text" translatable="yes">Load a config file</property>
                    <property name="label" translatable="yes">Load</property>
                    <property name="use_underline">True</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkToolButton" id="button3">
                    <property name="related_action">save</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="tooltip_text" translatable="yes">Save a config file</property>
                    <property name="label" translatable="yes">Save</property>
                    <property name="use_underline">True</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkSeparatorToolItem" id="toolitem2">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkRadioToolButton" id="button4">
                    <property name="related_action">radioaction1</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="has_tooltip">True</property>
                    <property name="tooltip_text" translatable="yes">Single view</property>
                    <property name="label" translatable="yes">Single</property>
                    <property name="group">button6</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkRadioToolButton" id="button5">
                    <property name="related_action">radioaction2</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="has_tooltip">True</property>
                    <property name="tooltip_text" translatable="yes">Split view</property>
                    <property name="label" translatable="yes">Split</property>
                    <property name="group">button6</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkRadioToolButton" id="button6">
                    <property name="related_action">radioaction3</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="has_tooltip">True</property>
                    <property name="tooltip_text" translatable="yes">Full view</property>
                    <property name="label" translatable="yes">Full</property>
                    <property name="active">True</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkSeparatorToolItem" id="toolitem3">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkToolButton" id="button7">
                    <property name="use_action_appearance">False</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="tooltip_text" translatable="yes">Collapse the whole tree in the right frame</property>
                    <property name="label" translatable="yes">Collapse</property>
                    <property name="use_underline">True</property>
                    <property name="stock_id">gtk-remove</property>
                    <signal name="clicked" handler="on_collapse_clicked" swapped="no"/>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkToolButton" id="button8">
                    <property name="use_action_appearance">False</property>
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="tooltip_text" translatable="yes">Expand the whole tree in the right frame</property>
                    <property name="label" translatable="yes">Expand</property>
                    <property name="use_underline">True</property>
                    <property name="stock_id">gtk-add</property>
                    <signal name="clicked" handler="on_expand_clicked" swapped="no"/>
                  </object>
                  <packing>
                    <property name="expand">False</property>
                    <property name="homogeneous">True</property>
                  </packing>
                </child>
              </object>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">False</property>
            <property name="position">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkHPaned" id="hpaned1">
            <property name="width_request">1</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <child>
              <object class="GtkScrolledWindow" id="scrolledwindow1">
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="hscrollbar_policy">automatic</property>
                <property name="vscrollbar_policy">automatic</property>
                <property name="shadow_type">in</property>
                <child>
                  <object class="GtkTreeView" id="treeview1">
                    <property name="visible">True</property>
                    <property name="can_focus">True</property>
                    <property name="enable_search">False</property>
                    <signal name="button-press-event" handler="on_treeview1_button_press_event" swapped="no"/>
                    <signal name="cursor-changed" handler="on_treeview2_cursor_changed" swapped="no"/>
                    <signal name="key-press-event" handler="on_treeview2_key_press_event" swapped="no"/>
                  </object>
                </child>
              </object>
              <packing>
                <property name="resize">False</property>
                <property name="shrink">True</property>
              </packing>
            </child>
            <child>
              <object class="GtkVPaned" id="vpaned1">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <child>
                  <object class="GtkScrolledWindow" id="scrolledwindow2">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="hscrollbar_policy">automatic</property>
                    <property name="vscrollbar_policy">automatic</property>
                    <property name="shadow_type">in</property>
                    <child>
                      <object class="GtkTreeView" id="treeview2">
                        <property name="visible">True</property>
                        <property name="can_focus">True</property>
                        <property name="has_focus">True</property>
                        <property name="enable_search">False</property>
                        <signal name="button-press-event" handler="on_treeview2_button_press_event" swapped="no"/>
                        <signal name="cursor-changed" handler="on_treeview2_cursor_changed" swapped="no"/>
                        <signal name="key-press-event" handler="on_treeview2_key_press_event" swapped="no"/>
                      </object>
                    </child>
                  </object>
                  <packing>
                    <property name="resize">False</property>
                    <property name="shrink">True</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkScrolledWindow" id="scrolledwindow3">
                    <property name="visible">True</property>
                    <property name="can_focus">False</property>
                    <property name="hscrollbar_policy">never</property>
                    <property name="vscrollbar_policy">automatic</property>
                    <property name="shadow_type">in</property>
                    <child>
                      <object class="GtkTextView" id="textview3">
                        <property name="visible">True</property>
                        <property name="can_focus">True</property>
                        <property name="editable">False</property>
                        <property name="wrap_mode">word</property>
                        <property name="buffer">textbuffer1</property>
                      </object>
                    </child>
                  </object>
                  <packing>
                    <property name="resize">True</property>
                    <property name="shrink">True</property>
                  </packing>
                </child>
              </object>
              <packing>
                <property name="resize">True</property>
                <property name="shrink">True</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">True</property>
            <property name="fill">True</property>
            <property name="position">2</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
</interface>

--5mCyUwZo2JvN/JJP--
