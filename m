Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0HKHlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:41:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:48412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0HKHlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:41:35 -0400
Date: Wed, 11 Aug 2010 07:41:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Move map browser to util/ui/browsers/
Message-ID: <tip-b1b0267336b1b74eeb8884bac4be96296b719e67@git.kernel.org>
Git-Commit-ID: b1b0267336b1b74eeb8884bac4be96296b719e67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:41:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1b0267336b1b74eeb8884bac4be96296b719e67
Gitweb:     http://git.kernel.org/tip/b1b0267336b1b74eeb8884bac4be96296b719e67
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Aug 2010 15:37:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:10:09 -0300

perf ui: Move map browser to util/ui/browsers/

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile               |    5 +
 tools/perf/util/newt.c            |  156 +-----------------------------------
 tools/perf/util/ui/browsers/map.c |  163 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/ui/browsers/map.h |    6 ++
 4 files changed, 175 insertions(+), 155 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ae443b6..d118020 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -570,9 +570,11 @@ else
 		LIB_OBJS += $(OUTPUT)util/newt.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
 		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/map.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_H += util/ui/browser.h
+		LIB_H += util/ui/browsers/map.h
 		LIB_H += util/ui/helpline.h
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
@@ -982,6 +984,9 @@ $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index f188258..b596926 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -16,42 +16,10 @@
 #include "symbol.h"
 #include "ui/browser.h"
 #include "ui/helpline.h"
+#include "ui/browsers/map.h"
 
 newtComponent newt_form__new(void);
 
-static int ui_entry__read(const char *title, char *bf, size_t size, int width)
-{
-	struct newtExitStruct es;
-	newtComponent form, entry;
-	const char *result;
-	int err = -1;
-
-	newtCenteredWindow(width, 1, title);
-	form = newtForm(NULL, NULL, 0);
-	if (form == NULL)
-		return -1;
-
-	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
-	if (entry == NULL)
-		goto out_free_form;
-
-	newtFormAddComponent(form, entry);
-	newtFormAddHotKey(form, NEWT_KEY_ENTER);
-	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(form, CTRL('c'));
-	newtFormRun(form, &es);
-
-	if (result != NULL) {
-		strncpy(bf, result, size);
-		err = 0;
-	}
-out_free_form:
-	newtPopWindow();
-	newtFormDestroy(form);
-	return 0;
-}
-
 char browser__last_msg[1024];
 
 int browser__show_help(const char *format, va_list ap)
@@ -182,128 +150,6 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	return bf;
 }
 
-/* -------------------------------------------------------------------- */
-
-struct map_browser {
-	struct ui_browser b;
-	struct map	  *map;
-	u16		  namelen;
-	u8		  addrlen;
-};
-
-static void map_browser__write(struct ui_browser *self, void *nd, int row)
-{
-	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-	struct map_browser *mb = container_of(self, struct map_browser, b);
-	bool current_entry = ui_browser__is_current_entry(self, row);
-	int color = ui_browser__percent_color(0, current_entry);
-
-	SLsmg_set_color(color);
-	slsmg_printf("%*llx %*llx %c ",
-		     mb->addrlen, sym->start, mb->addrlen, sym->end,
-		     sym->binding == STB_GLOBAL ? 'g' :
-		     sym->binding == STB_LOCAL  ? 'l' : 'w');
-	slsmg_write_nstring(sym->name, mb->namelen);
-}
-
-/* FIXME uber-kludgy, see comment on cmd_report... */
-static u32 *symbol__browser_index(struct symbol *self)
-{
-	return ((void *)self) - sizeof(struct rb_node) - sizeof(u32);
-}
-
-static int map_browser__search(struct map_browser *self)
-{
-	char target[512];
-	struct symbol *sym;
-	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
-
-	if (err)
-		return err;
-
-	if (target[0] == '0' && tolower(target[1]) == 'x') {
-		u64 addr = strtoull(target, NULL, 16);
-		sym = map__find_symbol(self->map, addr, NULL);
-	} else
-		sym = map__find_symbol_by_name(self->map, target, NULL);
-
-	if (sym != NULL) {
-		u32 *idx = symbol__browser_index(sym);
-			
-		self->b.top = &sym->rb_node;
-		self->b.index = self->b.top_idx = *idx;
-	} else
-		ui_helpline__fpush("%s not found!", target);
-
-	return 0;
-}
-
-static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
-{
-	if (ui_browser__show(&self->b, self->map->dso->long_name) < 0)
-		return -1;
-
-	ui_helpline__fpush("Press <- or ESC to exit, %s / to search",
-			   verbose ? "" : "restart with -v to use");
-	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
-	if (verbose)
-		newtFormAddHotKey(self->b.form, '/');
-
-	while (1) {
-		ui_browser__run(&self->b, es);
-
-		if (es->reason != NEWT_EXIT_HOTKEY)
-			break;
-		if (verbose && es->u.key == '/')
-			map_browser__search(self);
-		else
-			break;
-	}
-
-	newtFormDestroy(self->b.form);
-	newtPopWindow();
-	ui_helpline__pop();
-	return 0;
-}
-
-static int map__browse(struct map *self)
-{
-	struct map_browser mb = {
-		.b = {
-			.entries = &self->dso->symbols[self->type],
-			.refresh = ui_browser__rb_tree_refresh,
-			.seek	 = ui_browser__rb_tree_seek,
-			.write	 = map_browser__write,
-		},
-		.map = self,
-	};
-	struct newtExitStruct es;
-	struct rb_node *nd;
-	char tmp[BITS_PER_LONG / 4];
-	u64 maxaddr = 0;
-
-	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-
-		if (mb.namelen < pos->namelen)
-			mb.namelen = pos->namelen;
-		if (maxaddr < pos->end)
-			maxaddr = pos->end;
-		if (verbose) {
-			u32 *idx = symbol__browser_index(pos);
-			*idx = mb.b.nr_entries;
-		}
-		++mb.b.nr_entries;
-	}
-
-	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
-	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
-	return map_browser__run(&mb, &es);
-}
-
-/* -------------------------------------------------------------------- */
-
 struct hist_browser {
 	struct ui_browser   b;
 	struct hists	    *hists;
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
new file mode 100644
index 0000000..b79f0c9
--- /dev/null
+++ b/tools/perf/util/ui/browsers/map.c
@@ -0,0 +1,163 @@
+#include "../libslang.h"
+#include <elf.h>
+#include <newt.h>
+#include <sys/ttydefaults.h>
+#include <ctype.h>
+#include <string.h>
+#include <linux/bitops.h>
+#include "../../debug.h"
+#include "../../symbol.h"
+#include "../browser.h"
+#include "../helpline.h"
+#include "map.h"
+
+static int ui_entry__read(const char *title, char *bf, size_t size, int width)
+{
+	struct newtExitStruct es;
+	newtComponent form, entry;
+	const char *result;
+	int err = -1;
+
+	newtCenteredWindow(width, 1, title);
+	form = newtForm(NULL, NULL, 0);
+	if (form == NULL)
+		return -1;
+
+	entry = newtEntry(0, 0, "0x", width, &result, NEWT_FLAG_SCROLL);
+	if (entry == NULL)
+		goto out_free_form;
+
+	newtFormAddComponent(form, entry);
+	newtFormAddHotKey(form, NEWT_KEY_ENTER);
+	newtFormAddHotKey(form, NEWT_KEY_ESCAPE);
+	newtFormAddHotKey(form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(form, CTRL('c'));
+	newtFormRun(form, &es);
+
+	if (result != NULL) {
+		strncpy(bf, result, size);
+		err = 0;
+	}
+out_free_form:
+	newtPopWindow();
+	newtFormDestroy(form);
+	return 0;
+}
+
+struct map_browser {
+	struct ui_browser b;
+	struct map	  *map;
+	u16		  namelen;
+	u8		  addrlen;
+};
+
+static void map_browser__write(struct ui_browser *self, void *nd, int row)
+{
+	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+	struct map_browser *mb = container_of(self, struct map_browser, b);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int color = ui_browser__percent_color(0, current_entry);
+
+	SLsmg_set_color(color);
+	slsmg_printf("%*llx %*llx %c ",
+		     mb->addrlen, sym->start, mb->addrlen, sym->end,
+		     sym->binding == STB_GLOBAL ? 'g' :
+		     sym->binding == STB_LOCAL  ? 'l' : 'w');
+	slsmg_write_nstring(sym->name, mb->namelen);
+}
+
+/* FIXME uber-kludgy, see comment on cmd_report... */
+static u32 *symbol__browser_index(struct symbol *self)
+{
+	return ((void *)self) - sizeof(struct rb_node) - sizeof(u32);
+}
+
+static int map_browser__search(struct map_browser *self)
+{
+	char target[512];
+	struct symbol *sym;
+	int err = ui_entry__read("Search by name/addr", target, sizeof(target), 40);
+
+	if (err)
+		return err;
+
+	if (target[0] == '0' && tolower(target[1]) == 'x') {
+		u64 addr = strtoull(target, NULL, 16);
+		sym = map__find_symbol(self->map, addr, NULL);
+	} else
+		sym = map__find_symbol_by_name(self->map, target, NULL);
+
+	if (sym != NULL) {
+		u32 *idx = symbol__browser_index(sym);
+
+		self->b.top = &sym->rb_node;
+		self->b.index = self->b.top_idx = *idx;
+	} else
+		ui_helpline__fpush("%s not found!", target);
+
+	return 0;
+}
+
+static int map_browser__run(struct map_browser *self, struct newtExitStruct *es)
+{
+	if (ui_browser__show(&self->b, self->map->dso->long_name) < 0)
+		return -1;
+
+	ui_helpline__fpush("Press <- or ESC to exit, %s / to search",
+			   verbose ? "" : "restart with -v to use");
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+	if (verbose)
+		newtFormAddHotKey(self->b.form, '/');
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		if (verbose && es->u.key == '/')
+			map_browser__search(self);
+		else
+			break;
+	}
+
+	newtFormDestroy(self->b.form);
+	newtPopWindow();
+	ui_helpline__pop();
+	return 0;
+}
+
+int map__browse(struct map *self)
+{
+	struct map_browser mb = {
+		.b = {
+			.entries = &self->dso->symbols[self->type],
+			.refresh = ui_browser__rb_tree_refresh,
+			.seek	 = ui_browser__rb_tree_seek,
+			.write	 = map_browser__write,
+		},
+		.map = self,
+	};
+	struct newtExitStruct es;
+	struct rb_node *nd;
+	char tmp[BITS_PER_LONG / 4];
+	u64 maxaddr = 0;
+
+	for (nd = rb_first(mb.b.entries); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+
+		if (mb.namelen < pos->namelen)
+			mb.namelen = pos->namelen;
+		if (maxaddr < pos->end)
+			maxaddr = pos->end;
+		if (verbose) {
+			u32 *idx = symbol__browser_index(pos);
+			*idx = mb.b.nr_entries;
+		}
+		++mb.b.nr_entries;
+	}
+
+	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
+	mb.b.width += mb.addrlen * 2 + 4 + mb.namelen;
+	return map_browser__run(&mb, &es);
+}
diff --git a/tools/perf/util/ui/browsers/map.h b/tools/perf/util/ui/browsers/map.h
new file mode 100644
index 0000000..df8581a
--- /dev/null
+++ b/tools/perf/util/ui/browsers/map.h
@@ -0,0 +1,6 @@
+#ifndef _PERF_UI_MAP_BROWSER_H_
+#define _PERF_UI_MAP_BROWSER_H_ 1
+struct map;
+
+int map__browse(struct map *self);
+#endif /* _PERF_UI_MAP_BROWSER_H_ */
