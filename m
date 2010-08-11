Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab0HKHnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:43:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:48486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab0HKHnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:43:02 -0400
Date: Wed, 11 Aug 2010 07:42:38 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Sort by hottest lines in the TUI
Message-ID: <tip-92221162875ec48913d3f9710046e48d599c9cf2@git.kernel.org>
Git-Commit-ID: 92221162875ec48913d3f9710046e48d599c9cf2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 07:42:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92221162875ec48913d3f9710046e48d599c9cf2
Gitweb:     http://git.kernel.org/tip/92221162875ec48913d3f9710046e48d599c9cf2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 9 Aug 2010 15:30:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Aug 2010 16:11:42 -0300

perf annotate: Sort by hottest lines in the TUI

Right now it will just sort and position at the hottest line, i.e.
the one where more samples were taken.

It will be at the center of the screen and later TAB/shift-TAB will
cycle thru the hottest lines.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/util/hist.c                 |   13 ++--
 tools/perf/util/hist.h                 |    3 +-
 tools/perf/util/ui/browsers/annotate.c |  153 ++++++++++++++++++++++++--------
 4 files changed, 125 insertions(+), 46 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index fd20670..1478dc6 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -285,7 +285,7 @@ static int hist_entry__tty_annotate(struct hist_entry *he)
 	LIST_HEAD(head);
 	struct objdump_line *pos, *n;
 
-	if (hist_entry__annotate(he, &head) < 0)
+	if (hist_entry__annotate(he, &head, 0) < 0)
 		return -1;
 
 	if (full_paths)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 62ec9b0..be22ae6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -983,9 +983,9 @@ int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
 	return 0;
 }
 
-static struct objdump_line *objdump_line__new(s64 offset, char *line)
+static struct objdump_line *objdump_line__new(s64 offset, char *line, size_t privsize)
 {
-	struct objdump_line *self = malloc(sizeof(*self));
+	struct objdump_line *self = malloc(sizeof(*self) + privsize);
 
 	if (self != NULL) {
 		self->offset = offset;
@@ -1017,7 +1017,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 }
 
 static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
-					  struct list_head *head)
+					  struct list_head *head, size_t privsize)
 {
 	struct symbol *sym = self->ms.sym;
 	struct objdump_line *objdump_line;
@@ -1068,7 +1068,7 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 			offset = -1;
 	}
 
-	objdump_line = objdump_line__new(offset, line);
+	objdump_line = objdump_line__new(offset, line, privsize);
 	if (objdump_line == NULL) {
 		free(line);
 		return -1;
@@ -1078,7 +1078,8 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 	return 0;
 }
 
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
+			 size_t privsize)
 {
 	struct symbol *sym = self->ms.sym;
 	struct map *map = self->ms.map;
@@ -1143,7 +1144,7 @@ fallback:
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (hist_entry__parse_objdump_line(self, file, head) < 0)
+		if (hist_entry__parse_objdump_line(self, file, head, privsize) < 0)
 			break;
 
 	pclose(file);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 65a48db..587d375 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -101,7 +101,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
 int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
+			 size_t privsize);
 
 void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 5b01df6..763592b 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -14,6 +14,23 @@ static void ui__error_window(const char *fmt, ...)
 	va_end(ap);
 }
 
+struct annotate_browser {
+	struct ui_browser b;
+	struct rb_root	  entries;
+};
+
+struct objdump_line_rb_node {
+	struct rb_node	rb_node;
+	double		percent;
+	u32		idx;
+};
+
+static inline
+struct objdump_line_rb_node *objdump_line__rb(struct objdump_line *self)
+{
+	return (struct objdump_line_rb_node *)(self + 1);
+}
+
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
 	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
@@ -21,17 +38,41 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	int width = self->width;
 
 	if (ol->offset != -1) {
-		struct hist_entry *he = self->priv;
-		struct symbol *sym = he->ms.sym;
-		int len = he->ms.sym->end - he->ms.sym->start;
+		struct objdump_line_rb_node *olrb = objdump_line__rb(ol);
+		int color = ui_browser__percent_color(olrb->percent, current_entry);
+		SLsmg_set_color(color);
+		slsmg_printf(" %7.2f ", olrb->percent);
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
+static double objdump_line__calc_percent(struct objdump_line *self,
+					 struct list_head *head,
+					 struct symbol *sym)
+{
+	double percent = 0.0;
+
+	if (self->offset != -1) {
+		int len = sym->end - sym->start;
 		unsigned int hits = 0;
-		double percent = 0.0;
-		int color;
 		struct sym_priv *priv = symbol__priv(sym);
 		struct sym_ext *sym_ext = priv->ext;
 		struct sym_hist *h = priv->hist;
-		s64 offset = ol->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(self->entries, ol);
+		s64 offset = self->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(head, self);
+
 
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
@@ -45,37 +86,45 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 		if (sym_ext == NULL && h->sum)
 			percent = 100.0 * hits / h->sum;
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
 	}
 
-	SLsmg_write_char(':');
-	slsmg_write_nstring(" ", 8);
-	if (!*ol->line)
-		slsmg_write_nstring(" ", width - 18);
-	else
-		slsmg_write_nstring(ol->line, width - 18);
+	return percent;
+}
+
+static void objdump__insert_line(struct rb_root *self,
+				 struct objdump_line_rb_node *line)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct objdump_line_rb_node *l;
+
+	while (*p != NULL) {
+		parent = *p;
+		l = rb_entry(parent, struct objdump_line_rb_node, rb_node);
+		if (line->percent < l->percent)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&line->rb_node, parent, p);
+	rb_insert_color(&line->rb_node, self);
 }
 
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct newtExitStruct es;
 	struct objdump_line *pos, *n;
+	struct objdump_line_rb_node *rbpos;
+	struct rb_node *nd;
 	LIST_HEAD(head);
-	struct ui_browser browser = {
-		.entries = &head,
-		.refresh = ui_browser__list_head_refresh,
-		.seek	 = ui_browser__list_head_seek,
-		.write	 = annotate_browser__write,
-		.priv	 = self,
+	struct annotate_browser browser = {
+		.b = {
+			.entries = &head,
+			.refresh = ui_browser__list_head_refresh,
+			.seek	 = ui_browser__list_head_seek,
+			.write	 = annotate_browser__write,
+			.priv	 = self,
+		},
 	};
 	int ret;
 
@@ -85,7 +134,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	if (self->ms.map->dso->annotate_warned)
 		return -1;
 
-	if (hist_entry__annotate(self, &head) < 0) {
+	if (hist_entry__annotate(self, &head, sizeof(*rbpos)) < 0) {
 		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
@@ -94,16 +143,44 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	list_for_each_entry(pos, &head, node) {
 		size_t line_len = strlen(pos->line);
-		if (browser.width < line_len)
-			browser.width = line_len;
-		++browser.nr_entries;
+		if (browser.b.width < line_len)
+			browser.b.width = line_len;
+		rbpos = objdump_line__rb(pos);
+		rbpos->idx = browser.b.nr_entries++;
+		rbpos->percent = objdump_line__calc_percent(pos, &head, self->ms.sym);
+		if (rbpos->percent < 0.01)
+			continue;
+		objdump__insert_line(&browser.entries, rbpos);
+	}
+
+	/*
+	 * Position the browser at the hottest line.
+	 */
+	nd = rb_last(&browser.entries);
+	if (nd != NULL) {
+		unsigned back;
+
+		ui_browser__refresh_dimensions(&browser.b);
+		back = browser.b.height / 2;
+		rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
+		pos = ((struct objdump_line *)rbpos) - 1;
+		browser.b.top_idx = browser.b.index = rbpos->idx;
+
+		while (browser.b.top_idx != 0 && back != 0) {
+			pos = list_entry(pos->node.prev, struct objdump_line, node);
+
+			--browser.b.top_idx;
+			--back;
+		}
+
+		browser.b.top = pos;
 	}
 
-	browser.width += 18; /* Percentage */
-	ui_browser__show(&browser, self->ms.sym->name);
-	newtFormAddHotKey(browser.form, ' ');
-	ret = ui_browser__run(&browser, &es);
-	newtFormDestroy(browser.form);
+	browser.b.width += 18; /* Percentage */
+	ui_browser__show(&browser.b, self->ms.sym->name);
+	newtFormAddHotKey(browser.b.form, ' ');
+	ret = ui_browser__run(&browser.b, &es);
+	newtFormDestroy(browser.b.form);
 	newtPopWindow();
 	list_for_each_entry_safe(pos, n, &head, node) {
 		list_del(&pos->node);
