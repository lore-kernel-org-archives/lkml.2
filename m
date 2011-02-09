Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1BIQmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:42:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1BIQmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:42:16 -0500
Date: Wed, 9 Feb 2011 14:41:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
	regression
Message-ID: <20110209164154.GA15607@ghostprotocols.net>
References: <new-submission> <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org> <1297224378.8035.7.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1297224378.8035.7.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Wed, Feb 09, 2011 at 05:06:18AM +0100, Mike Galbraith escreveu:
> On Wed, 2011-02-09 at 00:43 +0000, tip-bot for Arnaldo Carvalho de Melo wrote
> > Gitweb:     http://git.kernel.org/tip/d5e3d747007fdb541e57ed72e020ff0b94db3470
> > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > perf annotate: Fix annotate context lines regression
> > 
> > The live annotation done in 'perf top' needs to limit the context before
> > lines that aren't filtered out by the min percent filter, if we don't do
> > that, the screen in a tty often is not enough for showing what is
> > interesting: lines with hits and a few source code lines before it.
> 
> Looks to me like this went from regress a bit while waiting for tui
> thing to progress a bit immediately :)

:-) Can you please apply the two patches and give 'perf top --tui' live
annotation a shot? Just press enter or -> (right key) on a symbol you
want to annotate.

I'm still polishing it a bit, want to avoid trying the notes->lock on
each time record_precise_ip is called, for that I need to share the
current symbol being annotated (sym_filter_entry) with the annotate
browser, the timer should not always run, etc, but just so that I can
get some feedback on how it is shaping up, please try it and report your
impressions :-)

Also when enter is pressed and one is monitoring multiple events, a
popup menu with the event names should be presented, etc.

- Arnaldo

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-ui-Serialize-screen-updates.patch"

>From c11a24e210b10543a29258f1b86918bb3f15092f Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Wed, 9 Feb 2011 11:38:43 -0200
Subject: [PATCH 1/1] perf ui: Serialize screen updates

The ui operations so far were used by just one thread, but 'perf top
--tui' now has two threads updating the screen, so we need to use a
mutex to avoid garbling the screen.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    1 +
 tools/perf/util/ui/browser.c  |    7 +++++++
 tools/perf/util/ui/helpline.c |    5 ++++-
 tools/perf/util/ui/libslang.h |    1 +
 tools/perf/util/ui/setup.c    |    3 +++
 tools/perf/util/ui/ui.h       |    8 ++++++++
 6 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/util/ui/ui.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 94f73ab..9852f60 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -635,6 +635,7 @@ else
 		LIB_H += util/ui/libslang.h
 		LIB_H += util/ui/progress.h
 		LIB_H += util/ui/util.h
+		LIB_H += util/ui/ui.h
 	endif
 endif
 
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 8bc010e..60d6c81 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,4 +1,5 @@
 #include "libslang.h"
+#include "ui.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -178,6 +179,7 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	if (self->sb == NULL)
 		return -1;
 
+	pthread_mutex_lock(&ui__lock);
 	SLsmg_gotorc(0, 0);
 	ui_browser__set_color(self, NEWT_COLORSET_ROOT);
 	slsmg_write_nstring(title, self->width);
@@ -188,25 +190,30 @@ int ui_browser__show(struct ui_browser *self, const char *title,
 	va_start(ap, helpline);
 	ui_helpline__vpush(helpline, ap);
 	va_end(ap);
+	pthread_mutex_unlock(&ui__lock);
 	return 0;
 }
 
 void ui_browser__hide(struct ui_browser *self)
 {
+	pthread_mutex_lock(&ui__lock);
 	newtFormDestroy(self->form);
 	self->form = NULL;
 	ui_helpline__pop();
+	pthread_mutex_unlock(&ui__lock);
 }
 
 int ui_browser__refresh(struct ui_browser *self)
 {
 	int row;
 
+	pthread_mutex_lock(&ui__lock);
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
 	row = self->refresh(self);
 	ui_browser__set_color(self, HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->y + row, self->x,
 			  self->height - row, self->width, ' ');
+	pthread_mutex_unlock(&ui__lock);
 
 	return 0;
 }
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 8d79daa..f36d2ff 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -5,6 +5,7 @@
 
 #include "../debug.h"
 #include "helpline.h"
+#include "ui.h"
 
 void ui_helpline__pop(void)
 {
@@ -55,7 +56,8 @@ int ui_helpline__show_help(const char *format, va_list ap)
 	int ret;
 	static int backlog;
 
-        ret = vsnprintf(ui_helpline__last_msg + backlog,
+	pthread_mutex_lock(&ui__lock);
+	ret = vsnprintf(ui_helpline__last_msg + backlog,
 			sizeof(ui_helpline__last_msg) - backlog, format, ap);
 	backlog += ret;
 
@@ -64,6 +66,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 		newtRefresh();
 		backlog = 0;
 	}
+	pthread_mutex_unlock(&ui__lock);
 
 	return ret;
 }
diff --git a/tools/perf/util/ui/libslang.h b/tools/perf/util/ui/libslang.h
index 2b63e1c..93d5f5c 100644
--- a/tools/perf/util/ui/libslang.h
+++ b/tools/perf/util/ui/libslang.h
@@ -1,5 +1,6 @@
 #ifndef _PERF_UI_SLANG_H_
 #define _PERF_UI_SLANG_H_ 1
+
 /*
  * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
  * the build if it isn't defined. Use the equivalent one that glibc
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index fbf1a14..ee46d67 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -6,6 +6,9 @@
 #include "../debug.h"
 #include "browser.h"
 #include "helpline.h"
+#include "ui.h"
+
+pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
 static void newt_suspend(void *d __used)
 {
diff --git a/tools/perf/util/ui/ui.h b/tools/perf/util/ui/ui.h
new file mode 100644
index 0000000..d264e05
--- /dev/null
+++ b/tools/perf/util/ui/ui.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_UI_H_
+#define _PERF_UI_H_ 1
+
+#include <pthread.h>
+
+extern pthread_mutex_t ui__lock;
+
+#endif /* _PERF_UI_H_ */
-- 
1.7.1


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-live_tui_annotate.patch"

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 210c736..8a039a0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -195,18 +195,17 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 	struct annotation *notes;
 	struct symbol *sym;
 
-	if (syme != sym_filter_entry)
-		return;
-
 	sym = sym_entry__symbol(syme);
 	notes = symbol__annotation(sym);
 
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
+	if (notes->src == NULL)
+		goto out_unlock;
 	ip = syme->map->map_ip(syme->map, ip);
 	symbol__inc_addr_samples(sym, syme->map, counter, ip);
-
+out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 1aa3965..9eccd88 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -6,6 +6,7 @@
 #include "../../sort.h"
 #include "../../symbol.h"
 #include "../../annotate.h"
+#include <pthread.h>
 
 static void ui__error_window(const char *fmt, ...)
 {
@@ -44,8 +45,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		struct objdump_line_rb_node *olrb = objdump_line__rb(ol);
 		ui_browser__set_percent_color(self, olrb->percent, current_entry);
 		slsmg_printf(" %7.2f ", olrb->percent);
-		if (!current_entry)
-			ui_browser__set_color(self, HE_COLORSET_CODE);
 	} else {
 		ui_browser__set_percent_color(self, 0, current_entry);
 		slsmg_write_nstring(" ", 9);
@@ -57,6 +56,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(" ", width - 18);
 	else
 		slsmg_write_nstring(ol->line, width - 18);
+
+	if (!current_entry)
+		ui_browser__set_color(self, HE_COLORSET_CODE);
 }
 
 static double objdump_line__calc_percent(struct objdump_line *self,
@@ -137,10 +139,35 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 	self->curr_hot = nd;
 }
 
-static int annotate_browser__run(struct annotate_browser *self)
+static void annotate_browser__calc_percent(struct annotate_browser *browser,
+					   int evidx)
+{
+	struct symbol *sym = browser->b.priv;
+	struct annotation *notes = symbol__annotation(sym);
+	struct objdump_line *pos;
+
+	browser->entries = RB_ROOT;
+
+	pthread_mutex_lock(&notes->lock);
+	symbol__annotate_decay_histogram(sym, evidx);
+
+	list_for_each_entry(pos, &notes->src->source, node) {
+		struct objdump_line_rb_node *rbpos = objdump_line__rb(pos);
+		rbpos->percent = objdump_line__calc_percent(pos, sym, evidx);
+		if (rbpos->percent < 0.01)
+			continue;
+		objdump__insert_line(&browser->entries, rbpos);
+	}
+	pthread_mutex_unlock(&notes->lock);
+
+	browser->curr_hot = rb_last(&browser->entries);
+}
+
+static int annotate_browser__run(struct annotate_browser *self, int evidx)
 {
-	struct rb_node *nd;
+	struct rb_node *nd = NULL;
 	struct symbol *sym = self->b.priv;
+	int tabs[] = { NEWT_KEY_TAB, NEWT_KEY_UNTAB, NEWT_KEY_RIGHT, 0 };
 	int key;
 
 	if (ui_browser__show(&self->b, sym->name,
@@ -152,26 +179,48 @@ static int annotate_browser__run(struct annotate_browser *self)
 	 */
 	ui_browser__add_exit_key(&self->b, NEWT_KEY_RIGHT);
 
+	ui_browser__add_exit_keys(&self->b, tabs);
+	annotate_browser__calc_percent(self, evidx);
+
+	if (self->curr_hot)
+		annotate_browser__set_top(self, self->curr_hot);
+
 	nd = self->curr_hot;
-	if (nd) {
-		int tabs[] = { NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0 };
-		ui_browser__add_exit_keys(&self->b, tabs);
-	}
+
+	newtFormSetTimer(self->b.form, 2000);
 
 	while (1) {
 		key = ui_browser__run(&self->b);
 
 		switch (key) {
+                case -1:
+                        /* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+			annotate_browser__calc_percent(self, evidx);
+			break;
+
 		case NEWT_KEY_TAB:
-			nd = rb_prev(nd);
+			if (nd != NULL)
+				nd = rb_prev(nd);
+				if (nd == NULL)
+					nd = rb_last(&self->entries);
+			else
+				nd = self->curr_hot;
+
 			if (nd == NULL)
-				nd = rb_last(&self->entries);
+				break;
 			annotate_browser__set_top(self, nd);
 			break;
 		case NEWT_KEY_UNTAB:
-			nd = rb_next(nd);
+			if (nd != NULL)
+				nd = rb_next(nd);
+				if (nd == NULL)
+					nd = rb_first(&self->entries);
+			else
+				nd = self->curr_hot;
+
 			if (nd == NULL)
-				nd = rb_first(&self->entries);
+				break;
+
 			annotate_browser__set_top(self, nd);
 			break;
 		default:
@@ -191,7 +240,6 @@ int hist_entry__tui_annotate(struct hist_entry *he, int evidx)
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 {
 	struct objdump_line *pos, *n;
-	struct objdump_line_rb_node *rbpos;
 	struct annotation *notes = symbol__annotation(sym);
 	struct annotate_browser browser = {
 		.b = {
@@ -210,7 +258,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 	if (map->dso->annotate_warned)
 		return -1;
 
-	if (symbol__annotate(sym, map, sizeof(*rbpos)) < 0) {
+	if (symbol__annotate(sym, map, sizeof(struct objdump_line_rb_node)) < 0) {
 		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
@@ -221,23 +269,11 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx)
 		size_t line_len = strlen(pos->line);
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
-		rbpos = objdump_line__rb(pos);
-		rbpos->idx = browser.b.nr_entries++;
-		rbpos->percent = objdump_line__calc_percent(pos, sym, evidx);
-		if (rbpos->percent < 0.01)
-			continue;
-		objdump__insert_line(&browser.entries, rbpos);
+		browser.b.nr_entries++;
 	}
 
-	/*
-	 * Position the browser at the hottest line.
-	 */
-	browser.curr_hot = rb_last(&browser.entries);
-	if (browser.curr_hot)
-		annotate_browser__set_top(&browser, browser.curr_hot);
-
 	browser.b.width += 18; /* Percentage */
-	ret = annotate_browser__run(&browser);
+	ret = annotate_browser__run(&browser, evidx);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		objdump_line__free(pos);
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index ca60624..5b7ecaa 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -7,6 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 #include "../browser.h"
+#include "../../annotate.h"
 #include "../helpline.h"
 #include "../libslang.h"
 #include "../../evlist.h"
@@ -18,6 +19,7 @@
 struct perf_top_browser {
 	struct ui_browser b;
 	struct rb_root	  root;
+	struct sym_entry  *selection;
 	float		  sum_ksamples;
 	int		  dso_width;
 	int		  dso_short_width;
@@ -60,6 +62,9 @@ static void perf_top_browser__write(struct ui_browser *browser, void *entry, int
 	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
 				syme->map->dso->long_name :
 				syme->map->dso->short_name, width);
+
+	if (current_entry)
+		top_browser->selection = syme;
 }
 
 static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
@@ -80,12 +85,39 @@ static void perf_top_browser__update_rb_tree(struct perf_top_browser *browser)
 	browser->b.nr_entries = top->rb_entries;
 }
 
+static void perf_top_browser__annotate(struct perf_top_browser *browser)
+{
+	struct sym_entry *syme = browser->selection;
+	struct symbol *sym = sym_entry__symbol(syme);
+	struct annotation *notes = symbol__annotation(sym);
+	struct perf_top *top = browser->b.priv;
+
+	if (notes->src != NULL) {
+		pthread_mutex_lock(&notes->lock);
+		goto do_annotation;
+	}
+
+	pthread_mutex_lock(&notes->lock);
+
+	if (symbol__alloc_hist(sym, top->evlist->nr_entries) < 0) {
+		pr_err("Not enough memory for annotating '%s' symbol!\n",
+		       sym->name);
+		pthread_mutex_unlock(&notes->lock);
+		return;
+	}
+
+	pthread_mutex_unlock(&notes->lock);
+do_annotation:
+	symbol__tui_annotate(sym, syme->map, 0);
+}
+
 static int perf_top_browser__run(struct perf_top_browser *browser)
 {
 	int key;
 	char title[160];
 	struct perf_top *top = browser->b.priv;
 	int delay_msecs = top->delay_secs * 1000;
+	int exit_keys[] = { 'a', NEWT_KEY_ENTER, NEWT_KEY_RIGHT, 0, };
 
 	perf_top_browser__update_rb_tree(browser);
         perf_top__header_snprintf(top, title, sizeof(title));
@@ -95,6 +127,7 @@ static int perf_top_browser__run(struct perf_top_browser *browser)
 		return -1;
 
 	newtFormSetTimer(browser->b.form, delay_msecs);
+	ui_browser__add_exit_keys(&browser->b, exit_keys);
 
 	while (1) {
 		key = ui_browser__run(&browser->b);
@@ -109,7 +142,11 @@ static int perf_top_browser__run(struct perf_top_browser *browser)
 			SLsmg_gotorc(0, 0);
 			slsmg_write_nstring(title, browser->b.width);
 			break;
-		case NEWT_KEY_TAB:
+		case NEWT_KEY_RIGHT:
+		case NEWT_KEY_ENTER:
+			if (browser->selection)
+				perf_top_browser__annotate(browser);
+			break;
 		default:
 			goto out;
 		}

--YZ5djTAD1cGYuMQK--
