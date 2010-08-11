Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0HKHlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:41:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab0HKHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:41:13 -0400
Date: Wed, 11 Aug 2010 07:40:55 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Move annotate browser to util/ui/browsers/
Message-ID: <tip-211ef12771e759a08e10c3c606e6a8b1663519e7@git.kernel.org>
Git-Commit-ID: 211ef12771e759a08e10c3c606e6a8b1663519e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:40:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  211ef12771e759a08e10c3c606e6a8b1663519e7
Gitweb:     http://git.kernel.org/tip/211ef12771e759a08e10c3c606e6a8b1663519e7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Aug 2010 14:54:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:09:41 -0300

perf ui: Move annotate browser to util/ui/browsers/

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |    7 ++-
 tools/perf/util/debug.h                |    1 +
 tools/perf/util/newt.c                 |  132 +-------------------------------
 tools/perf/util/ui/browser.h           |    1 +
 tools/perf/util/ui/browsers/annotate.c |  114 +++++++++++++++++++++++++++
 tools/perf/util/ui/libslang.h          |   27 +++++++
 6 files changed, 151 insertions(+), 131 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 528c914..ae443b6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -158,7 +158,7 @@ all::
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
 $(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui,scripting-engines}/' 2> /dev/null)
+$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
 $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
@@ -569,10 +569,12 @@ else
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)util/newt.o
 		LIB_OBJS += $(OUTPUT)util/ui/browser.o
+		LIB_OBJS += $(OUTPUT)util/ui/browsers/annotate.o
 		LIB_OBJS += $(OUTPUT)util/ui/helpline.o
 		LIB_OBJS += $(OUTPUT)util/ui/progress.o
 		LIB_H += util/ui/browser.h
 		LIB_H += util/ui/helpline.h
+		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
 	endif
 endif
@@ -977,6 +979,9 @@ $(OUTPUT)util/newt.o: util/newt.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
+$(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index a929b06..ba4892e 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -30,6 +30,7 @@ static inline void ui_progress__update(struct ui_progress *self __used,
 
 static inline void ui_progress__delete(struct ui_progress *self __used) {}
 #else
+extern char browser__last_msg[];
 int browser__show_help(const char *format, va_list ap);
 #include "ui/progress.h"
 #endif
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index c0986d3..f188258 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1,16 +1,7 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #undef _GNU_SOURCE
-/*
- * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
- * the build if it isn't defined. Use the equivalent one that glibc
- * has on features.h.
- */
-#include <features.h>
-#ifndef HAVE_LONG_LONG
-#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
-#endif
-#include <slang.h>
+#include "ui/libslang.h"
 #include <signal.h>
 #include <stdlib.h>
 #include <elf.h>
@@ -26,17 +17,6 @@
 #include "ui/browser.h"
 #include "ui/helpline.h"
 
-#if SLANG_VERSION < 20104
-#define slsmg_printf(msg, args...) SLsmg_printf((char *)msg, ##args)
-#define slsmg_write_nstring(msg, len) SLsmg_write_nstring((char *)msg, len)
-#define sltt_set_color(obj, name, fg, bg) SLtt_set_color(obj,(char *)name,\
-							 (char *)fg, (char *)bg)
-#else
-#define slsmg_printf SLsmg_printf
-#define slsmg_write_nstring SLsmg_write_nstring
-#define sltt_set_color SLtt_set_color
-#endif
-
 newtComponent newt_form__new(void);
 
 static int ui_entry__read(const char *title, char *bf, size_t size, int width)
@@ -72,7 +52,7 @@ out_free_form:
 	return 0;
 }
 
-static char browser__last_msg[1024];
+char browser__last_msg[1024];
 
 int browser__show_help(const char *format, va_list ap)
 {
@@ -192,66 +172,6 @@ static bool dialog_yesno(const char *msg)
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
 
-static void ui__error_window(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
-	va_end(ap);
-}
-
-static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
-{
-	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
-	bool current_entry = ui_browser__is_current_entry(self, row);
-	int width = self->width;
-
-	if (ol->offset != -1) {
-		struct hist_entry *he = self->priv;
-		struct symbol *sym = he->ms.sym;
-		int len = he->ms.sym->end - he->ms.sym->start;
-		unsigned int hits = 0;
-		double percent = 0.0;
-		int color;
-		struct sym_priv *priv = symbol__priv(sym);
-		struct sym_ext *sym_ext = priv->ext;
-		struct sym_hist *h = priv->hist;
-		s64 offset = ol->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(self->entries, ol);
-
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (sym_ext) {
-				percent += sym_ext[offset].percent;
-			} else
-				hits += h->ip[offset];
-
-			++offset;
-		}
-
-		if (sym_ext == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-
-		color = ui_browser__percent_color(percent, current_entry);
-		SLsmg_set_color(color);
-		slsmg_printf(" %7.2f ", percent);
-		if (!current_entry)
-			SLsmg_set_color(HE_COLORSET_CODE);
-	} else {
-		int color = ui_browser__percent_color(0, current_entry);
-		SLsmg_set_color(color);
-		slsmg_write_nstring(" ", 9);
-	}
-
-	SLsmg_write_char(':');
-	slsmg_write_nstring(" ", 8);
-	if (!*ol->line)
-		slsmg_write_nstring(" ", width - 18);
-	else
-		slsmg_write_nstring(ol->line, width - 18);
-}
-
 static char *callchain_list__sym_name(struct callchain_list *self,
 				      char *bf, size_t bfsize)
 {
@@ -262,54 +182,6 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	return bf;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *self)
-{
-	struct newtExitStruct es;
-	struct objdump_line *pos, *n;
-	LIST_HEAD(head);
-	struct ui_browser browser = {
-		.entries = &head,
-		.refresh = ui_browser__list_head_refresh,
-		.seek	 = ui_browser__list_head_seek,
-		.write	 = annotate_browser__write,
-		.priv	 = self,
-	};
-	int ret;
-
-	if (self->ms.sym == NULL)
-		return -1;
-
-	if (self->ms.map->dso->annotate_warned)
-		return -1;
-
-	if (hist_entry__annotate(self, &head) < 0) {
-		ui__error_window(browser__last_msg);
-		return -1;
-	}
-
-	ui_helpline__push("Press <- or ESC to exit");
-
-	list_for_each_entry(pos, &head, node) {
-		size_t line_len = strlen(pos->line);
-		if (browser.width < line_len)
-			browser.width = line_len;
-		++browser.nr_entries;
-	}
-
-	browser.width += 18; /* Percentage */
-	ui_browser__show(&browser, self->ms.sym->name);
-	newtFormAddHotKey(browser.form, ' ');
-	ret = ui_browser__run(&browser, &es);
-	newtFormDestroy(browser.form);
-	newtPopWindow();
-	list_for_each_entry_safe(pos, n, &head, node) {
-		list_del(&pos->node);
-		objdump_line__free(pos);
-	}
-	ui_helpline__pop();
-	return ret;
-}
-
 /* -------------------------------------------------------------------- */
 
 struct map_browser {
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 8eed24c..856e343 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include <newt.h>
+#include <sys/types.h>
 #include "../types.h"
 
 #define HE_COLORSET_TOP		50
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
new file mode 100644
index 0000000..783d277
--- /dev/null
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -0,0 +1,114 @@
+#include "../browser.h"
+#include "../helpline.h"
+#include "../libslang.h"
+#include "../../hist.h"
+#include "../../sort.h"
+#include "../../symbol.h"
+
+static void ui__error_window(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
+	va_end(ap);
+}
+
+static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
+{
+	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
+	bool current_entry = ui_browser__is_current_entry(self, row);
+	int width = self->width;
+
+	if (ol->offset != -1) {
+		struct hist_entry *he = self->priv;
+		struct symbol *sym = he->ms.sym;
+		int len = he->ms.sym->end - he->ms.sym->start;
+		unsigned int hits = 0;
+		double percent = 0.0;
+		int color;
+		struct sym_priv *priv = symbol__priv(sym);
+		struct sym_ext *sym_ext = priv->ext;
+		struct sym_hist *h = priv->hist;
+		s64 offset = ol->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(self->entries, ol);
+
+		while (offset < (s64)len &&
+		       (next == NULL || offset < next->offset)) {
+			if (sym_ext) {
+				percent += sym_ext[offset].percent;
+			} else
+				hits += h->ip[offset];
+
+			++offset;
+		}
+
+		if (sym_ext == NULL && h->sum)
+			percent = 100.0 * hits / h->sum;
+
+		color = ui_browser__percent_color(percent, current_entry);
+		SLsmg_set_color(color);
+		slsmg_printf(" %7.2f ", percent);
+		if (!current_entry)
+			SLsmg_set_color(HE_COLORSET_CODE);
+	} else {
+		int color = ui_browser__percent_color(0, current_entry);
+		SLsmg_set_color(color);
+		slsmg_write_nstring(" ", 9);
+	}
+
+	SLsmg_write_char(':');
+	slsmg_write_nstring(" ", 8);
+	if (!*ol->line)
+		slsmg_write_nstring(" ", width - 18);
+	else
+		slsmg_write_nstring(ol->line, width - 18);
+}
+
+int hist_entry__tui_annotate(struct hist_entry *self)
+{
+	struct newtExitStruct es;
+	struct objdump_line *pos, *n;
+	LIST_HEAD(head);
+	struct ui_browser browser = {
+		.entries = &head,
+		.refresh = ui_browser__list_head_refresh,
+		.seek	 = ui_browser__list_head_seek,
+		.write	 = annotate_browser__write,
+		.priv	 = self,
+	};
+	int ret;
+
+	if (self->ms.sym == NULL)
+		return -1;
+
+	if (self->ms.map->dso->annotate_warned)
+		return -1;
+
+	if (hist_entry__annotate(self, &head) < 0) {
+		ui__error_window(browser__last_msg);
+		return -1;
+	}
+
+	ui_helpline__push("Press <- or ESC to exit");
+
+	list_for_each_entry(pos, &head, node) {
+		size_t line_len = strlen(pos->line);
+		if (browser.width < line_len)
+			browser.width = line_len;
+		++browser.nr_entries;
+	}
+
+	browser.width += 18; /* Percentage */
+	ui_browser__show(&browser, self->ms.sym->name);
+	newtFormAddHotKey(browser.form, ' ');
+	ret = ui_browser__run(&browser, &es);
+	newtFormDestroy(browser.form);
+	newtPopWindow();
+	list_for_each_entry_safe(pos, n, &head, node) {
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+	ui_helpline__pop();
+	return ret;
+}
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/util/ui/libslang.h
new file mode 100644
index 0000000..5623da8
--- /dev/null
+++ b/tools/perf/util/ui/libslang.h
@@ -0,0 +1,27 @@
+#ifndef _PERF_UI_SLANG_H_
+#define _PERF_UI_SLANG_H_ 1
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
+
+#if SLANG_VERSION < 20104
+#define slsmg_printf(msg, args...) \
+	SLsmg_printf((char *)msg, ##args)
+#define slsmg_write_nstring(msg, len) \
+	SLsmg_write_nstring((char *)msg, len)
+#define sltt_set_color(obj, name, fg, bg) \
+	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
+#else
+#define slsmg_printf SLsmg_printf
+#define slsmg_write_nstring SLsmg_write_nstring
+#define sltt_set_color SLtt_set_color
+#endif
+
+#endif /* _PERF_UI_SLANG_H_ */
