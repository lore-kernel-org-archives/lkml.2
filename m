Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1IARxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:53:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43927 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab1IARxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:53:21 -0400
From: crquan@gmail.com
To: linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        c.rq541@comcast.net
Subject: [PATCH V3 3/5] scripts/kconfig/nconf: dynamically alloc dialog_input_result
Date: Thu,  1 Sep 2011 10:52:20 -0700
Message-Id: <1314899542-5848-3-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314899542-5848-2-git-send-email-crquan@gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
 <1314899542-5848-1-git-send-email-crquan@gmail.com>
 <1314899542-5848-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

To support unlimited length string config items;

No check for realloc return value keeps code simple, and to be
consistent with other existing unchecked malloc in kconfig.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.c     |   21 ++++++++++-----------
 scripts/kconfig/nconf.gui.c |   20 +++++++++++++++-----
 scripts/kconfig/nconf.h     |    2 +-
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 39ca1f1..4248759 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -280,6 +280,9 @@ static int global_exit;
 /* the currently selected button */
 const char *current_instructions = menu_instructions;
 
+static char *dialog_input_result;
+static int dialog_input_result_len;
+
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
 static void conf_string(struct menu *menu);
@@ -695,7 +698,6 @@ static void search_conf(void)
 {
 	struct symbol **sym_arr;
 	struct gstr res;
-	char dialog_input_result[100];
 	char *dialog_input;
 	int dres;
 again:
@@ -703,7 +705,7 @@ again:
 			_("Search Configuration Parameter"),
 			_("Enter " CONFIG_ " (sub)string to search for "
 				"(with or without \"" CONFIG_ "\")"),
-			"", dialog_input_result, 99);
+			"", &dialog_input_result, &dialog_input_result_len);
 	switch (dres) {
 	case 0:
 		break;
@@ -1348,7 +1350,6 @@ static void conf_choice(struct menu *menu)
 static void conf_string(struct menu *menu)
 {
 	const char *prompt = menu_get_prompt(menu);
-	char dialog_input_result[256];
 
 	while (1) {
 		int res;
@@ -1371,8 +1372,8 @@ static void conf_string(struct menu *menu)
 				prompt ? _(prompt) : _("Main Menu"),
 				heading,
 				sym_get_string_value(menu->sym),
-				dialog_input_result,
-				sizeof(dialog_input_result));
+				&dialog_input_result,
+				&dialog_input_result_len);
 		switch (res) {
 		case 0:
 			if (sym_set_string_value(menu->sym,
@@ -1392,14 +1393,13 @@ static void conf_string(struct menu *menu)
 
 static void conf_load(void)
 {
-	char dialog_input_result[256];
 	while (1) {
 		int res;
 		res = dialog_inputbox(main_window,
 				NULL, load_config_text,
 				filename,
-				dialog_input_result,
-				sizeof(dialog_input_result));
+				&dialog_input_result,
+				&dialog_input_result_len);
 		switch (res) {
 		case 0:
 			if (!dialog_input_result[0])
@@ -1424,14 +1424,13 @@ static void conf_load(void)
 
 static void conf_save(void)
 {
-	char dialog_input_result[256];
 	while (1) {
 		int res;
 		res = dialog_inputbox(main_window,
 				NULL, save_config_text,
 				filename,
-				dialog_input_result,
-				sizeof(dialog_input_result));
+				&dialog_input_result,
+				&dialog_input_result_len);
 		switch (res) {
 		case 0:
 			if (!dialog_input_result[0])
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 3ce2a7c..d64bc1c 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -356,7 +356,7 @@ int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...)
 
 int dialog_inputbox(WINDOW *main_window,
 		const char *title, const char *prompt,
-		const char *init, char *result, int result_len)
+		const char *init, char **resultp, int *result_len)
 {
 	int prompt_lines = 0;
 	int prompt_width = 0;
@@ -367,7 +367,12 @@ int dialog_inputbox(WINDOW *main_window,
 	int i, x, y;
 	int res = -1;
 	int cursor_position = strlen(init);
+	char *result = *resultp;
 
+	if (strlen(init)+1 > *result_len) {
+		*result_len = strlen(init)+1;
+		*resultp = result = realloc(result, *result_len);
+	}
 
 	/* find the widest line of msg: */
 	prompt_lines = get_line_no(prompt);
@@ -384,7 +389,7 @@ int dialog_inputbox(WINDOW *main_window,
 	y = (LINES-(prompt_lines+4))/2;
 	x = (COLS-(prompt_width+4))/2;
 
-	strncpy(result, init, result_len);
+	strncpy(result, init, *result_len);
 
 	/* create the windows */
 	win = newwin(prompt_lines+6, prompt_width+7, y, x);
@@ -443,7 +448,7 @@ int dialog_inputbox(WINDOW *main_window,
 		case KEY_UP:
 		case KEY_RIGHT:
 			if (cursor_position < len &&
-			    cursor_position < min(result_len, prompt_width))
+			    cursor_position < min(*result_len, prompt_width))
 				cursor_position++;
 			break;
 		case KEY_DOWN:
@@ -452,8 +457,13 @@ int dialog_inputbox(WINDOW *main_window,
 				cursor_position--;
 			break;
 		default:
-			if ((isgraph(res) || isspace(res)) &&
-					len-2 < result_len) {
+			if ((isgraph(res) || isspace(res))) {
+				/* one for new char, one for '\0' */
+				if (len+2 > *result_len) {
+					*result_len = len+2;
+					*resultp = result = realloc(result,
+								*result_len);
+				}
 				/* insert the char at the proper position */
 				memmove(&result[cursor_position+1],
 						&result[cursor_position],
diff --git a/scripts/kconfig/nconf.h b/scripts/kconfig/nconf.h
index 58fbda8..0d52617 100644
--- a/scripts/kconfig/nconf.h
+++ b/scripts/kconfig/nconf.h
@@ -89,7 +89,7 @@ void fill_window(WINDOW *win, const char *text);
 int btn_dialog(WINDOW *main_window, const char *msg, int btn_num, ...);
 int dialog_inputbox(WINDOW *main_window,
 		const char *title, const char *prompt,
-		const char *init, char *result, int result_len);
+		const char *init, char **resultp, int *result_len);
 void refresh_all_windows(WINDOW *main_window);
 void show_scroll_win(WINDOW *main_window,
 		const char *title,
-- 
1.7.6

