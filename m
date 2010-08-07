Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0HGBeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:34:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0HGBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:34:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf ui: Start breaking down newt.c into multiple files
Date: Fri,  6 Aug 2010 22:34:09 -0300
Message-Id: <1281144849-22896-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281144849-22896-1-git-send-email-acme@infradead.org>
References: <1281144849-22896-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As new TUI features get added the newt.c file is growing a lot and its
name is growing misleading as an effort is being made to reduce the
coupling with libnewt.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |   10 +-
 tools/perf/util/newt.c       |  306 +----------------------------------------
 tools/perf/util/ui/browser.c |  313 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/browser.h |   43 ++++++
 4 files changed, 368 insertions(+), 304 deletions(-)
 create mode 100644 tools/perf/util/ui/browser.c
 create mode 100644 tools/perf/util/ui/browser.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 26f626d..d5bce76 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,9 +157,8 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/perl/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui,scripting-engines}/' 2> /dev/null)
 $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
@@ -569,6 +568,8 @@ else
 		BASIC_CFLAGS += -I/usr/include/slang
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)util/newt.o
+		LIB_OBJS += $(OUTPUT)util/ui/browser.o
+		LIB_H += util/ui/browser.h
 	endif
 endif
 
@@ -969,6 +970,9 @@ $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/newt.o: util/newt.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 37fe8eb..266a9e0 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -23,6 +23,7 @@
 #include "session.h"
 #include "sort.h"
 #include "symbol.h"
+#include "ui/browser.h"
 
 #if SLANG_VERSION < 20104
 #define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
@@ -35,6 +36,8 @@
 #define sltt_set_color SLtt_set_color
 #endif
 
+newtComponent newt_form__new(void);
+
 struct ui_progress {
 	newtComponent form, scale;
 };
@@ -190,7 +193,7 @@ static void newt_form__set_exit_keys(newtComponent self)
 	newtFormAddHotKey(self, CTRL('c'));
 }
 
-static newtComponent newt_form__new(void)
+newtComponent newt_form__new(void)
 {
 	newtComponent self = newtForm(NULL, NULL, 0);
 	if (self)
@@ -290,172 +293,6 @@ static void ui__error_window(const char *fmt, ...)
 	va_end(ap);
 }
 
-#define HE_COLORSET_TOP		50
-#define HE_COLORSET_MEDIUM	51
-#define HE_COLORSET_NORMAL	52
-#define HE_COLORSET_SELECTED	53
-#define HE_COLORSET_CODE	54
-
-static int ui_browser__percent_color(double percent, bool current)
-{
-	if (current)
-		return HE_COLORSET_SELECTED;
-	if (percent >= MIN_RED)
-		return HE_COLORSET_TOP;
-	if (percent >= MIN_GREEN)
-		return HE_COLORSET_MEDIUM;
-	return HE_COLORSET_NORMAL;
-}
-
-struct ui_browser {
-	newtComponent	form, sb;
-	u64		index, first_visible_entry_idx;
-	void		*first_visible_entry, *entries;
-	u16		top, left, width, height;
-	void		*priv;
-	unsigned int	(*refresh)(struct ui_browser *self);
-	void		(*write)(struct ui_browser *self, void *entry, int row);
-	void		(*seek)(struct ui_browser *self,
-				off_t offset, int whence);
-	u32		nr_entries;
-};
-
-static void ui_browser__list_head_seek(struct ui_browser *self,
-				       off_t offset, int whence)
-{
-	struct list_head *head = self->entries;
-	struct list_head *pos;
-
-	switch (whence) {
-	case SEEK_SET:
-		pos = head->next;
-		break;
-	case SEEK_CUR:
-		pos = self->first_visible_entry;
-		break;
-	case SEEK_END:
-		pos = head->prev;
-		break;
-	default:
-		return;
-	}
-
-	if (offset > 0) {
-		while (offset-- != 0)
-			pos = pos->next;
-	} else {
-		while (offset++ != 0)
-			pos = pos->prev;
-	}
-
-	self->first_visible_entry = pos;
-}
-
-static void ui_browser__rb_tree_seek(struct ui_browser *self,
-				     off_t offset, int whence)
-{
-	struct rb_root *root = self->entries;
-	struct rb_node *nd;
-
-	switch (whence) {
-	case SEEK_SET:
-		nd = rb_first(root);
-		break;
-	case SEEK_CUR:
-		nd = self->first_visible_entry;
-		break;
-	case SEEK_END:
-		nd = rb_last(root);
-		break;
-	default:
-		return;
-	}
-
-	if (offset > 0) {
-		while (offset-- != 0)
-			nd = rb_next(nd);
-	} else {
-		while (offset++ != 0)
-			nd = rb_prev(nd);
-	}
-
-	self->first_visible_entry = nd;
-}
-
-static unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
-{
-	struct rb_node *nd;
-	int row = 0;
-
-	if (self->first_visible_entry == NULL)
-                self->first_visible_entry = rb_first(self->entries);
-
-	nd = self->first_visible_entry;
-
-	while (nd != NULL) {
-		SLsmg_gotorc(self->top + row, self->left);
-		self->write(self, nd, row);
-		if (++row == self->height)
-			break;
-		nd = rb_next(nd);
-	}
-
-	return row;
-}
-
-static bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
-{
-	return (self->first_visible_entry_idx + row) == self->index;
-}
-
-static void ui_browser__refresh_dimensions(struct ui_browser *self)
-{
-	int cols, rows;
-	newtGetScreenSize(&cols, &rows);
-
-	if (self->width > cols - 4)
-		self->width = cols - 4;
-	self->height = rows - 5;
-	if (self->height > self->nr_entries)
-		self->height = self->nr_entries;
-	self->top  = (rows - self->height) / 2;
-	self->left = (cols - self->width) / 2;
-}
-
-static void ui_browser__reset_index(struct ui_browser *self)
-{
-	self->index = self->first_visible_entry_idx = 0;
-	self->seek(self, 0, SEEK_SET);
-}
-
-static int ui_browser__show(struct ui_browser *self, const char *title)
-{
-	if (self->form != NULL) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	ui_browser__refresh_dimensions(self);
-	newtCenteredWindow(self->width, self->height, title);
-	self->form = newt_form__new();
-	if (self->form == NULL)
-		return -1;
-
-	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
-					 HE_COLORSET_NORMAL,
-					 HE_COLORSET_SELECTED);
-	if (self->sb == NULL)
-		return -1;
-
-	newtFormAddHotKey(self->form, NEWT_KEY_UP);
-	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
-	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
-	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
-	newtFormAddHotKey(self->form, NEWT_KEY_END);
-	newtFormAddComponent(self->form, self->sb);
-	return 0;
-}
-
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
 	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
@@ -507,98 +344,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(ol->line, width - 18);
 }
 
-static int ui_browser__refresh(struct ui_browser *self)
-{
-	int row;
-
-	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
-	row = self->refresh(self);
-	SLsmg_set_color(HE_COLORSET_NORMAL);
-	SLsmg_fill_region(self->top + row, self->left,
-			  self->height - row, self->width, ' ');
-
-	return 0;
-}
-
-static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
-{
-	if (ui_browser__refresh(self) < 0)
-		return -1;
-
-	while (1) {
-		off_t offset;
-
-		newtFormRun(self->form, es);
-
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		if (is_exit_key(es->u.key))
-			return es->u.key;
-		switch (es->u.key) {
-		case NEWT_KEY_DOWN:
-			if (self->index == self->nr_entries - 1)
-				break;
-			++self->index;
-			if (self->index == self->first_visible_entry_idx + self->height) {
-				++self->first_visible_entry_idx;
-				self->seek(self, +1, SEEK_CUR);
-			}
-			break;
-		case NEWT_KEY_UP:
-			if (self->index == 0)
-				break;
-			--self->index;
-			if (self->index < self->first_visible_entry_idx) {
-				--self->first_visible_entry_idx;
-				self->seek(self, -1, SEEK_CUR);
-			}
-			break;
-		case NEWT_KEY_PGDN:
-		case ' ':
-			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
-				break;
-
-			offset = self->height;
-			if (self->index + offset > self->nr_entries - 1)
-				offset = self->nr_entries - 1 - self->index;
-			self->index += offset;
-			self->first_visible_entry_idx += offset;
-			self->seek(self, +offset, SEEK_CUR);
-			break;
-		case NEWT_KEY_PGUP:
-			if (self->first_visible_entry_idx == 0)
-				break;
-
-			if (self->first_visible_entry_idx < self->height)
-				offset = self->first_visible_entry_idx;
-			else
-				offset = self->height;
-
-			self->index -= offset;
-			self->first_visible_entry_idx -= offset;
-			self->seek(self, -offset, SEEK_CUR);
-			break;
-		case NEWT_KEY_HOME:
-			ui_browser__reset_index(self);
-			break;
-		case NEWT_KEY_END:
-			offset = self->height - 1;
-			if (offset >= self->nr_entries)
-				offset = self->nr_entries - 1;
-
-			self->index = self->nr_entries - 1;
-			self->first_visible_entry_idx = self->index - offset;
-			self->seek(self, -offset, SEEK_END);
-			break;
-		default:
-			return es->u.key;
-		}
-		if (ui_browser__refresh(self) < 0)
-			return -1;
-	}
-	return 0;
-}
-
 static char *callchain_list__sym_name(struct callchain_list *self,
 				      char *bf, size_t bfsize)
 {
@@ -609,27 +354,6 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	return bf;
 }
 
-static unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
-{
-	struct list_head *pos;
-	struct list_head *head = self->entries;
-	int row = 0;
-
-	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
-                self->first_visible_entry = head->next;
-
-	pos = self->first_visible_entry;
-
-	list_for_each_from(pos, head) {
-		SLsmg_gotorc(self->top + row, self->left);
-		self->write(self, pos, row);
-		if (++row == self->height)
-			break;
-	}
-
-	return row;
-}
-
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct newtExitStruct es;
@@ -1093,20 +817,6 @@ int hists__tui_browse_tree(struct rb_root *self, const char *help)
 	return key;
 }
 
-static struct newtPercentTreeColors {
-	const char *topColorFg, *topColorBg;
-	const char *mediumColorFg, *mediumColorBg;
-	const char *normalColorFg, *normalColorBg;
-	const char *selColorFg, *selColorBg;
-	const char *codeColorFg, *codeColorBg;
-} defaultPercentTreeColors = {
-	"red",       "lightgray",
-	"green",     "lightgray",
-	"black",     "lightgray",
-	"lightgray", "magenta",
-	"blue",	     "lightgray",
-};
-
 static void newt_suspend(void *d __used)
 {
 	newtSuspend();
@@ -1116,8 +826,6 @@ static void newt_suspend(void *d __used)
 
 void setup_browser(void)
 {
-	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
-
 	if (!isatty(1) || !use_browser || dump_trace) {
 		use_browser = 0;
 		setup_pager();
@@ -1129,11 +837,7 @@ void setup_browser(void)
 	newtCls();
 	newtSetSuspendCallback(newt_suspend, NULL);
 	ui_helpline__puts(" ");
-	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
-	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
-	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
-	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
-	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
+	ui_browser__init();
 }
 
 void exit_browser(bool wait_for_ok)
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
new file mode 100644
index 0000000..0b2b930
--- /dev/null
+++ b/tools/perf/util/ui/browser.c
@@ -0,0 +1,313 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#undef _GNU_SOURCE
+/*
+ * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
+ * the build if it isn't defined. Use the equivalent one that glibc
+ * has on features.h.
+ */
+#include <features.h>
+#ifndef HAVE_LONG_LONG
+#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
+#endif
+#include <slang.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <stdlib.h>
+#include <sys/ttydefaults.h>
+#include "browser.h"
+#include "../color.h"
+#include "../util.h"
+
+#if SLANG_VERSION < 20104
+#define sltt_set_color(obj, name, fg, bg) \
+	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
+#else
+#define sltt_set_color SLtt_set_color
+#endif
+
+newtComponent newt_form__new(void);
+
+int ui_browser__percent_color(double percent, bool current)
+{
+	if (current)
+		return HE_COLORSET_SELECTED;
+	if (percent >= MIN_RED)
+		return HE_COLORSET_TOP;
+	if (percent >= MIN_GREEN)
+		return HE_COLORSET_MEDIUM;
+	return HE_COLORSET_NORMAL;
+}
+
+void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
+{
+	struct list_head *head = self->entries;
+	struct list_head *pos;
+
+	switch (whence) {
+	case SEEK_SET:
+		pos = head->next;
+		break;
+	case SEEK_CUR:
+		pos = self->first_visible_entry;
+		break;
+	case SEEK_END:
+		pos = head->prev;
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			pos = pos->next;
+	} else {
+		while (offset++ != 0)
+			pos = pos->prev;
+	}
+
+	self->first_visible_entry = pos;
+}
+
+void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
+{
+	struct rb_root *root = self->entries;
+	struct rb_node *nd;
+
+	switch (whence) {
+	case SEEK_SET:
+		nd = rb_first(root);
+		break;
+	case SEEK_CUR:
+		nd = self->first_visible_entry;
+		break;
+	case SEEK_END:
+		nd = rb_last(root);
+		break;
+	default:
+		return;
+	}
+
+	if (offset > 0) {
+		while (offset-- != 0)
+			nd = rb_next(nd);
+	} else {
+		while (offset++ != 0)
+			nd = rb_prev(nd);
+	}
+
+	self->first_visible_entry = nd;
+}
+
+unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
+{
+	struct rb_node *nd;
+	int row = 0;
+
+	if (self->first_visible_entry == NULL)
+                self->first_visible_entry = rb_first(self->entries);
+
+	nd = self->first_visible_entry;
+
+	while (nd != NULL) {
+		SLsmg_gotorc(self->top + row, self->left);
+		self->write(self, nd, row);
+		if (++row == self->height)
+			break;
+		nd = rb_next(nd);
+	}
+
+	return row;
+}
+
+bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
+{
+	return (self->first_visible_entry_idx + row) == self->index;
+}
+
+void ui_browser__refresh_dimensions(struct ui_browser *self)
+{
+	int cols, rows;
+	newtGetScreenSize(&cols, &rows);
+
+	if (self->width > cols - 4)
+		self->width = cols - 4;
+	self->height = rows - 5;
+	if (self->height > self->nr_entries)
+		self->height = self->nr_entries;
+	self->top  = (rows - self->height) / 2;
+	self->left = (cols - self->width) / 2;
+}
+
+void ui_browser__reset_index(struct ui_browser *self)
+{
+	self->index = self->first_visible_entry_idx = 0;
+	self->seek(self, 0, SEEK_SET);
+}
+
+int ui_browser__show(struct ui_browser *self, const char *title)
+{
+	if (self->form != NULL) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
+	ui_browser__refresh_dimensions(self);
+	newtCenteredWindow(self->width, self->height, title);
+	self->form = newt_form__new();
+	if (self->form == NULL)
+		return -1;
+
+	self->sb = newtVerticalScrollbar(self->width, 0, self->height,
+					 HE_COLORSET_NORMAL,
+					 HE_COLORSET_SELECTED);
+	if (self->sb == NULL)
+		return -1;
+
+	newtFormAddHotKey(self->form, NEWT_KEY_UP);
+	newtFormAddHotKey(self->form, NEWT_KEY_DOWN);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGUP);
+	newtFormAddHotKey(self->form, NEWT_KEY_PGDN);
+	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
+	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddComponent(self->form, self->sb);
+	return 0;
+}
+
+int ui_browser__refresh(struct ui_browser *self)
+{
+	int row;
+
+	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
+	row = self->refresh(self);
+	SLsmg_set_color(HE_COLORSET_NORMAL);
+	SLsmg_fill_region(self->top + row, self->left,
+			  self->height - row, self->width, ' ');
+
+	return 0;
+}
+
+int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
+{
+	if (ui_browser__refresh(self) < 0)
+		return -1;
+
+	while (1) {
+		off_t offset;
+
+		newtFormRun(self->form, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		if (is_exit_key(es->u.key))
+			return es->u.key;
+		switch (es->u.key) {
+		case NEWT_KEY_DOWN:
+			if (self->index == self->nr_entries - 1)
+				break;
+			++self->index;
+			if (self->index == self->first_visible_entry_idx + self->height) {
+				++self->first_visible_entry_idx;
+				self->seek(self, +1, SEEK_CUR);
+			}
+			break;
+		case NEWT_KEY_UP:
+			if (self->index == 0)
+				break;
+			--self->index;
+			if (self->index < self->first_visible_entry_idx) {
+				--self->first_visible_entry_idx;
+				self->seek(self, -1, SEEK_CUR);
+			}
+			break;
+		case NEWT_KEY_PGDN:
+		case ' ':
+			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
+				break;
+
+			offset = self->height;
+			if (self->index + offset > self->nr_entries - 1)
+				offset = self->nr_entries - 1 - self->index;
+			self->index += offset;
+			self->first_visible_entry_idx += offset;
+			self->seek(self, +offset, SEEK_CUR);
+			break;
+		case NEWT_KEY_PGUP:
+			if (self->first_visible_entry_idx == 0)
+				break;
+
+			if (self->first_visible_entry_idx < self->height)
+				offset = self->first_visible_entry_idx;
+			else
+				offset = self->height;
+
+			self->index -= offset;
+			self->first_visible_entry_idx -= offset;
+			self->seek(self, -offset, SEEK_CUR);
+			break;
+		case NEWT_KEY_HOME:
+			ui_browser__reset_index(self);
+			break;
+		case NEWT_KEY_END:
+			offset = self->height - 1;
+			if (offset >= self->nr_entries)
+				offset = self->nr_entries - 1;
+
+			self->index = self->nr_entries - 1;
+			self->first_visible_entry_idx = self->index - offset;
+			self->seek(self, -offset, SEEK_END);
+			break;
+		default:
+			return es->u.key;
+		}
+		if (ui_browser__refresh(self) < 0)
+			return -1;
+	}
+	return 0;
+}
+
+unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
+{
+	struct list_head *pos;
+	struct list_head *head = self->entries;
+	int row = 0;
+
+	if (self->first_visible_entry == NULL ||
+	    self->first_visible_entry == self->entries)
+                self->first_visible_entry = head->next;
+
+	pos = self->first_visible_entry;
+
+	list_for_each_from(pos, head) {
+		SLsmg_gotorc(self->top + row, self->left);
+		self->write(self, pos, row);
+		if (++row == self->height)
+			break;
+	}
+
+	return row;
+}
+
+static struct newtPercentTreeColors {
+	const char *topColorFg, *topColorBg;
+	const char *mediumColorFg, *mediumColorBg;
+	const char *normalColorFg, *normalColorBg;
+	const char *selColorFg, *selColorBg;
+	const char *codeColorFg, *codeColorBg;
+} defaultPercentTreeColors = {
+	"red",       "lightgray",
+	"green",     "lightgray",
+	"black",     "lightgray",
+	"lightgray", "magenta",
+	"blue",	     "lightgray",
+};
+
+void ui_browser__init(void)
+{
+	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
+
+	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
+	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
+	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
+	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
+	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
+}
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
new file mode 100644
index 0000000..bcc4391
--- /dev/null
+++ b/tools/perf/util/ui/browser.h
@@ -0,0 +1,43 @@
+#ifndef _PERF_UI_BROWSER_H_
+#define _PERF_UI_BROWSER_H_ 1
+
+#include <stdbool.h>
+#include <newt.h>
+#include "../types.h"
+
+#define HE_COLORSET_TOP		50
+#define HE_COLORSET_MEDIUM	51
+#define HE_COLORSET_NORMAL	52
+#define HE_COLORSET_SELECTED	53
+#define HE_COLORSET_CODE	54
+
+struct ui_browser {
+	newtComponent form, sb;
+	u64	      index, first_visible_entry_idx;
+	void	      *first_visible_entry, *entries;
+	u16	      top, left, width, height;
+	void	      *priv;
+	unsigned int  (*refresh)(struct ui_browser *self);
+	void	      (*write)(struct ui_browser *self, void *entry, int row);
+	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
+	u32	      nr_entries;
+};
+
+
+int ui_browser__percent_color(double percent, bool current);
+bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
+void ui_browser__refresh_dimensions(struct ui_browser *self);
+void ui_browser__reset_index(struct ui_browser *self);
+
+int ui_browser__show(struct ui_browser *self, const char *title);
+int ui_browser__refresh(struct ui_browser *self);
+int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es);
+
+void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
+unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
+
+void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence);
+unsigned int ui_browser__list_head_refresh(struct ui_browser *self);
+
+void ui_browser__init(void);
+#endif /* _PERF_UI_BROWSER_H_ */
-- 
1.6.2.5

