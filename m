Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0EVRps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:45:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:59383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab0EVRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:45:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/3] perf annotate: Add TUI interface
Date: Sat, 22 May 2010 14:45:12 -0300
Message-Id: <1274550312-16600-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274550312-16600-1-git-send-email-acme@infradead.org>
References: <1274550312-16600-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When annotating multiple entries, for instance, when running simply as:

$ perf annotate

the right and left keys, as well as TAB can be used to cycle thru the
multiple symbols being annotated.

If one doesn't like TUI annotate, disable it by editing ~/.perfconfig
and adding:

[tui]

	annotate = off

Just like it is possible for report.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   61 ++++++++++++++++++++++++++++++-----------
 tools/perf/builtin-report.c   |    4 +--
 tools/perf/util/hist.c        |   13 +++-----
 tools/perf/util/hist.h        |   10 +++++++
 tools/perf/util/newt.c        |   56 +++++++++++++++++++++++++-------------
 tools/perf/util/util.h        |   15 +++++++++-
 6 files changed, 112 insertions(+), 47 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 77bcc9b..08278ed 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -277,7 +277,7 @@ static void hist_entry__print_hits(struct hist_entry *self)
 	printf("%*s: %Lu\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-static void annotate_sym(struct hist_entry *he)
+static int hist_entry__tty_annotate(struct hist_entry *he)
 {
 	struct map *map = he->ms.map;
 	struct dso *dso = map->dso;
@@ -288,7 +288,7 @@ static void annotate_sym(struct hist_entry *he)
 	struct objdump_line *pos, *n;
 
 	if (hist_entry__annotate(he, &head) < 0)
-		return;
+		return -1;
 
 	if (full_paths)
 		d_filename = filename;
@@ -317,30 +317,59 @@ static void annotate_sym(struct hist_entry *he)
 
 	if (print_line)
 		free_source_line(he, len);
+
+	return 0;
 }
 
 static void hists__find_annotations(struct hists *self)
 {
-	struct rb_node *nd;
+	struct rb_node *first = rb_first(&self->entries), *nd = first;
+	int key = KEY_RIGHT;
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
-		if (he->ms.sym == NULL)
-			continue;
+		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned)
+			goto find_next;
 
 		priv = symbol__priv(he->ms.sym);
-		if (priv->hist == NULL)
+		if (priv->hist == NULL) {
+find_next:
+			if (key == KEY_LEFT)
+				nd = rb_prev(nd);
+			else
+				nd = rb_next(nd);
 			continue;
+		}
 
-		annotate_sym(he);
-		/*
-		 * Since we have a hist_entry per IP for the same symbol, free
-		 * he->ms.sym->hist to signal we already processed this symbol.
-		 */
-		free(priv->hist);
-		priv->hist = NULL;
+		if (use_browser) {
+			key = hist_entry__tui_annotate(he);
+			if (is_exit_key(key))
+				break;
+			switch (key) {
+			case KEY_RIGHT:
+			case '\t':
+				nd = rb_next(nd);
+				break;
+			case KEY_LEFT:
+				if (nd == first)
+					continue;
+				nd = rb_prev(nd);
+			default:
+				break;
+			}
+		} else {
+			hist_entry__tty_annotate(he);
+			nd = rb_next(nd);
+			/*
+			 * Since we have a hist_entry per IP for the same
+			 * symbol, free he->ms.sym->hist to signal we already
+			 * processed this symbol.
+			 */
+			free(priv->hist);
+			priv->hist = NULL;
+		}
 	}
 }
 
@@ -416,6 +445,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
+	setup_browser();
+
 	symbol_conf.priv_size = sizeof(struct sym_priv);
 	symbol_conf.try_vmlinux_path = true;
 
@@ -435,8 +466,6 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		sym_hist_filter = argv[0];
 	}
 
-	setup_pager();
-
 	if (field_sep && *field_sep == '.') {
 		pr_err("'.' is the only non valid --field-separator argument\n");
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2c39bd3..a7b8760 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -484,9 +484,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	if (dump_trace)
-		setup_pager();
-	else if (strcmp(input_name, "-") != 0)
+	if (strcmp(input_name, "-") != 0)
 		setup_browser();
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 009ad76..682a6d8 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -992,14 +992,14 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	char *filename = dso__build_id_filename(dso, NULL, 0);
 	char command[PATH_MAX * 2];
 	FILE *file;
-	int err = -1;
+	int err = 0;
 	u64 len;
 
 	if (filename == NULL) {
 		if (dso->has_build_id) {
 			pr_err("Can't annotate %s: not enough memory\n",
 			       sym->name);
-			return -1;
+			return -ENOMEM;
 		}
 		/*
 		 * If we don't have build-ids, well, lets hope that this
@@ -1009,14 +1009,12 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	}
 
 	if (dso->origin == DSO__ORIG_KERNEL) {
-		if (dso->annotate_warned) {
-			err = 0;
+		if (dso->annotate_warned)
 			goto out_free_filename;
-		}
+		err = -ENOENT;
 		dso->annotate_warned = 1;
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path:\n", sym->name);
-		vmlinux_path__fprintf(stderr);
+		       "path\n", sym->name);
 		goto out_free_filename;
 	}
 
@@ -1046,7 +1044,6 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 			break;
 
 	pclose(file);
-	err = 0;
 out_free_filename:
 	if (dso->has_build_id)
 		free(filename);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6f17dcd..2d5203f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -102,8 +102,18 @@ static inline int hists__browse(struct hists *self __used,
 {
 	return 0;
 }
+static inline int hist_entry__tui_annotate(struct hist_entry *self __used)
+{
+	return 0;
+}
+#define KEY_LEFT -1
+#define KEY_RIGHT -2
 #else
+#include <newt.h>
 int hists__browse(struct hists *self, const char *helpline,
 		  const char *input_name);
+int hist_entry__tui_annotate(struct hist_entry *self);
+#define KEY_LEFT NEWT_KEY_LEFT
+#define KEY_RIGHT NEWT_KEY_RIGHT
 #endif
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index c65838c..ffd0472 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -235,6 +235,15 @@ static bool dialog_yesno(const char *msg)
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
 
+static void ui__error_window(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
+	va_end(ap);
+}
+
 #define HE_COLORSET_TOP		50
 #define HE_COLORSET_MEDIUM	51
 #define HE_COLORSET_NORMAL	52
@@ -386,6 +395,8 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 	newtFormAddHotKey(self->form, ' ');
 	newtFormAddHotKey(self->form, NEWT_KEY_HOME);
 	newtFormAddHotKey(self->form, NEWT_KEY_END);
+	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
+	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
 
 	if (ui_browser__refresh_entries(self) < 0)
 		return -1;
@@ -398,6 +409,8 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 
 		if (es->reason != NEWT_EXIT_HOTKEY)
 			break;
+		if (is_exit_key(es->u.key))
+			return es->u.key;
 		switch (es->u.key) {
 		case NEWT_KEY_DOWN:
 			if (self->index == self->nr_entries - 1)
@@ -471,12 +484,10 @@ static int ui_browser__run(struct ui_browser *self, const char *title,
 			}
 		}
 			break;
-		case NEWT_KEY_ESCAPE:
+		case NEWT_KEY_RIGHT:
 		case NEWT_KEY_LEFT:
-		case CTRL('c'):
-		case 'Q':
-		case 'q':
-			return 0;
+		case NEWT_KEY_TAB:
+			return es->u.key;
 		default:
 			continue;
 		}
@@ -668,18 +679,24 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 	return ret;
 }
 
-static void hist_entry__annotate_browser(struct hist_entry *self)
+int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct ui_browser browser;
 	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
 	LIST_HEAD(head);
+	int ret;
 
 	if (self->ms.sym == NULL)
-		return;
+		return -1;
 
-	if (hist_entry__annotate(self, &head) < 0)
-		return;
+	if (self->ms.map->dso->annotate_warned)
+		return -1;
+
+	if (hist_entry__annotate(self, &head) < 0) {
+		ui__error_window(browser__last_msg);
+		return -1;
+	}
 
 	ui_helpline__push("Press <- or ESC to exit");
 
@@ -694,7 +711,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	}
 
 	browser.width += 18; /* Percentage */
-	ui_browser__run(&browser, self->ms.sym->name, &es);
+	ret = ui_browser__run(&browser, self->ms.sym->name, &es);
 	newtFormDestroy(browser.form);
 	newtPopWindow();
 	list_for_each_entry_safe(pos, n, &head, node) {
@@ -702,6 +719,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 		objdump_line__free(pos);
 	}
 	ui_helpline__pop();
+	return ret;
 }
 
 static const void *newt__symbol_tree_get_current(newtComponent self)
@@ -935,14 +953,14 @@ do_help:
 				continue;
 			default:;
 			}
-			if (toupper(es.u.key) == 'Q' ||
-			    es.u.key == CTRL('c'))
-				break;
-			if (es.u.key == NEWT_KEY_ESCAPE) {
-				if (dialog_yesno("Do you really want to exit?"))
+			if (is_exit_key(es.u.key)) {
+				if (es.u.key == NEWT_KEY_ESCAPE) {
+					if (dialog_yesno("Do you really want to exit?"))
+						break;
+					else
+						continue;
+				} else
 					break;
-				else
-					continue;
 			}
 
 			if (es.u.key == NEWT_KEY_LEFT) {
@@ -1006,7 +1024,7 @@ do_annotate:
 			if (he == NULL)
 				continue;
 
-			hist_entry__annotate_browser(he);
+			hist_entry__tui_annotate(he);
 		} else if (choice == zoom_dso) {
 zoom_dso:
 			if (dso_filter) {
@@ -1074,7 +1092,7 @@ void setup_browser(void)
 {
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
 
-	if (!isatty(1) || !use_browser) {
+	if (!isatty(1) || !use_browser || dump_trace) {
 		setup_pager();
 		return;
 	}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 45b9655..4e8b6b0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -81,7 +81,7 @@
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
-
+#include <sys/ttydefaults.h>
 
 #ifndef NO_ICONV
 #include <iconv.h>
@@ -263,6 +263,19 @@ bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
 unsigned long convert_unit(unsigned long value, char *unit);
 
+#ifndef ESC
+#define ESC 27
+#endif
+
+static inline bool is_exit_key(int key)
+{
+	char up;
+	if (key == CTRL('c') || key == ESC)
+		return true;
+	up = toupper(key);
+	return up == 'Q';
+}
+
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-- 
1.6.2.5

