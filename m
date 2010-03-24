Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab0CXTkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:40:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab0CXTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:40:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 1/6] perf report: Add a popup menu to ask what operation is to be performed
Date: Wed, 24 Mar 2010 16:40:14 -0300
Message-Id: <1269459619-982-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now it presents a menu with these options:

 +------------------------------+
 | Annotate CURRENT_SYMBOL_NAME |
 | Exit                         |
 +------------------------------+

If the highlighted (current) symbol is not annotatable only the "Exit"
option will appear.

Also add a confirmation dialog when ESC is pressed on the top level to
avoid exiting the application by pressing one too many ESC key.

To get to the menu just press the -> (Right navigation key), to exit
just press ESC.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   96 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 12b229b..a3465a0 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -28,6 +28,47 @@ static newtComponent newt_form__new(void)
 	return self;
 }
 
+static int popup_menu(int argc, const char *argv[])
+{
+	struct newtExitStruct es;
+	int i, rc = -1, max_len = 5;
+	newtComponent listbox, form = newt_form__new();
+
+	if (form == NULL)
+		return -1;
+
+	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
+	if (listbox == NULL)
+		goto out_destroy_form;
+
+	newtFormAddComponents(form, listbox, NULL);
+
+	for (i = 0; i < argc; ++i) {
+		int len = strlen(argv[i]);
+		if (len > max_len)
+			max_len = len;
+		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
+			goto out_destroy_form;
+	}
+
+	newtCenteredWindow(max_len, argc, NULL);
+	newtFormRun(form, &es);
+	rc = newtListboxGetCurrent(listbox) - NULL;
+	if (es.reason == NEWT_EXIT_HOTKEY)
+		rc = -1;
+	newtPopWindow();
+out_destroy_form:
+	newtFormDestroy(form);
+	return rc;
+}
+
+static bool dialog_yesno(const char *msg)
+{
+	/* newtWinChoice should really be accepting const char pointers... */
+	char yes[] = "Yes", no[] = "No";
+	return newtWinChoice(NULL, no, yes, (char *)msg) == 2;
+}
+
 /*
  * When debugging newt problems it was useful to be able to "unroll"
  * the calls to newtCheckBoxTreeAdd{Array,Item}, so that we can generate
@@ -309,6 +350,19 @@ out_free_str:
 	free(str);
 }
 
+static const void *newt__symbol_tree_get_current(newtComponent self)
+{
+	if (symbol_conf.use_callchain)
+		return newtCheckboxTreeGetCurrent(self);
+	return newtListboxGetCurrent(self);
+}
+
+static void perf_session__selection(newtComponent self, void *data)
+{
+	const struct symbol **symbol_ptr = data;
+	*symbol_ptr = newt__symbol_tree_get_current(self);
+}
+
 void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 				const char *helpline)
 {
@@ -322,6 +376,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	char str[1024];
 	newtComponent form, tree;
 	struct newtExitStruct es;
+	const struct symbol *selection;
 
 	snprintf(str, sizeof(str), "Samples: %Ld", session_total);
 	newtDrawRootText(0, 0, str);
@@ -336,6 +391,8 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 		tree = newtListbox(0, 0, rows - 5, (NEWT_FLAG_SCROLL |
 						       NEWT_FLAG_RETURNEXIT));
 
+	newtComponentAddCallback(tree, perf_session__selection, &selection);
+
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
 			continue;
@@ -377,20 +434,43 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	form = newt_form__new();
 	newtFormAddHotKey(form, 'A');
 	newtFormAddHotKey(form, 'a');
+	newtFormAddHotKey(form, NEWT_KEY_RIGHT);
 	newtFormAddComponents(form, tree, NULL);
+	selection = newt__symbol_tree_get_current(tree);
 
 	while (1) {
-		const struct symbol *selection;
+		char annotate[512];
+		const char *options[2];
+		int nr_options = 0, choice;
 
 		newtFormRun(form, &es);
-		if (es.reason == NEWT_EXIT_HOTKEY &&
-		    toupper(es.u.key) != 'A')
+		if (es.reason == NEWT_EXIT_HOTKEY) {
+			if (toupper(es.u.key) == 'A') {
+				symbol__annotate_browser(selection);
+				continue;
+			}
+			if (es.u.key == NEWT_KEY_ESCAPE ||
+			    toupper(es.u.key) == 'Q' ||
+			    es.u.key == CTRL('c')) {
+				if (dialog_yesno("Do you really want to exit?"))
+					break;
+				else
+					continue;
+			}
+		}
+
+		if (selection != NULL) {
+			snprintf(annotate, sizeof(annotate),
+				 "Annotate %s", selection->name);
+			options[nr_options++] = annotate;
+		}
+
+		options[nr_options++] = "Exit";
+		choice = popup_menu(nr_options, options);
+		if (choice == nr_options - 1)
 			break;
-		if (!symbol_conf.use_callchain)
-			selection = newtListboxGetCurrent(tree);
-		else
-			selection = newtCheckboxTreeGetCurrent(tree);
-		symbol__annotate_browser(selection);
+		else if (selection != NULL && choice >= 0)
+			symbol__annotate_browser(selection);
 	}
 
 	newtFormDestroy(form);
-- 
1.6.2.5

