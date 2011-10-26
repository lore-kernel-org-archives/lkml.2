Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab1JZRsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:48:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:54957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933702Ab1JZRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/11] perf ui: Reimplement ui__popup_menu using ui__browser
Date: Wed, 26 Oct 2011 15:48:28 -0200
Message-Id: <1319651314-29404-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now let it work just like the other browsers: in full screen, at
the top left corner. If people complain we can revisit, I found it OK
and the laziest/quickest approach at reusing the ui_browser ;-)

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4bgeqizcxh04q0sk24cw43gk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c |   41 +++++++++++++++++++++
 tools/perf/util/ui/browser.h |    3 ++
 tools/perf/util/ui/util.c    |   81 +++++++++++++++++++++++++++---------------
 3 files changed, 96 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 370c470..29c68ae 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -488,6 +488,47 @@ static int ui_browser__color_config(const char *var, const char *value,
 	return -1;
 }
 
+void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence)
+{
+	switch (whence) {
+	case SEEK_SET:
+		browser->top = browser->entries;
+		break;
+	case SEEK_CUR:
+		browser->top = browser->top + browser->top_idx + offset;
+		break;
+	case SEEK_END:
+		browser->top = browser->top + browser->nr_entries + offset;
+		break;
+	default:
+		return;
+	}
+}
+
+unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
+{
+	unsigned int row = 0, idx = browser->top_idx;
+	char **pos;
+
+	if (browser->top == NULL)
+		browser->top = browser->entries;
+
+	pos = (char **)browser->top;
+	while (idx < browser->nr_entries) {
+		if (!browser->filter || !browser->filter(browser, *pos)) {
+			ui_browser__gotorc(browser, row, 0);
+			browser->write(browser, pos, row);
+			if (++row == browser->height)
+				break;
+		}
+
+		++idx;
+		++pos;
+	}
+
+	return row;
+}
+
 void ui_browser__init(void)
 {
 	int i = 0;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index a2c707d..81a8d2a 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -44,6 +44,9 @@ int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 
+void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
+unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
+
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
 
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index fdf1fc8..37e6fe0 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -8,10 +8,54 @@
 #include "../cache.h"
 #include "../debug.h"
 #include "browser.h"
+#include "keysyms.h"
 #include "helpline.h"
 #include "ui.h"
 #include "util.h"
 
+static void ui_browser__argv_write(struct ui_browser *browser,
+				   void *entry, int row)
+{
+	char **arg = entry;
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+	slsmg_write_nstring(*arg, browser->width);
+}
+
+static int popup_menu__run(struct ui_browser *menu)
+{
+	int key;
+
+	if (ui_browser__show(menu, " ", "ESC: exit, ENTER|->: Select option") < 0)
+		return -1;
+
+	while (1) {
+		key = ui_browser__run(menu, 0);
+
+		switch (key) {
+		case K_RIGHT:
+		case K_ENTER:
+			key = menu->index;
+			break;
+		case K_LEFT:
+		case K_ESC:
+		case 'q':
+		case CTRL('c'):
+			key = -1;
+			break;
+		default:
+			continue;
+		}
+
+		break;
+	}
+
+	ui_browser__hide(menu);
+	return key;
+}
+
 static void newt_form__set_exit_keys(newtComponent self)
 {
 	newtFormAddHotKey(self, NEWT_KEY_LEFT);
@@ -31,36 +75,15 @@ static newtComponent newt_form__new(void)
 
 int ui__popup_menu(int argc, char * const argv[])
 {
-	struct newtExitStruct es;
-	int i, rc = -1, max_len = 5;
-	newtComponent listbox, form = newt_form__new();
-
-	if (form == NULL)
-		return -1;
-
-	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
-	if (listbox == NULL)
-		goto out_destroy_form;
-
-	newtFormAddComponent(form, listbox);
-
-	for (i = 0; i < argc; ++i) {
-		int len = strlen(argv[i]);
-		if (len > max_len)
-			max_len = len;
-		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
-			goto out_destroy_form;
-	}
-
-	newtCenteredWindow(max_len, argc, NULL);
-	newtFormRun(form, &es);
-	rc = newtListboxGetCurrent(listbox) - NULL;
-	if (es.reason == NEWT_EXIT_HOTKEY)
-		rc = -1;
-	newtPopWindow();
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
+	struct ui_browser menu = {
+		.entries    = (void *)argv,
+		.refresh    = ui_browser__argv_refresh,
+		.seek	    = ui_browser__argv_seek,
+		.write	    = ui_browser__argv_write,
+		.nr_entries = argc,
+	};
+
+	return popup_menu__run(&menu);
 }
 
 int ui__help_window(const char *text)
-- 
1.6.2.5

