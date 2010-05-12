Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0ELCaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:30:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:33154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0ELC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:29:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf report: Librarize the annotation code and use it in the newt browser
Date: Tue, 11 May 2010 23:29:32 -0300
Message-Id: <1273631372-8206-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273631372-8206-1-git-send-email-acme@infradead.org>
References: <1273631372-8206-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now we don't anymore use popen to run 'perf annotate' for the selected
symbol, instead we collect per address samplings when processing samples
in 'perf report' if we're using the newt browser, then we use this data
directly to do annotation.

Done this way we can actually traverse the objdump_line objects
directly, matching the addresses to the collected samples and colouring
them appropriately using lower level slang routines.

The new ui_browser class will be reused for the main, callchain aware,
histogram browser, when it will be made generic and don't assume that
the objects are always instances of the objdump_line class maintained
using list_heads.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           |    5 +
 tools/perf/builtin-annotate.c |  198 +-----------------------
 tools/perf/builtin-report.c   |   19 ++-
 tools/perf/util/hist.c        |  184 +++++++++++++++++++++
 tools/perf/util/hist.h        |   29 ++++
 tools/perf/util/newt.c        |  352 +++++++++++++++++++++++++++++++++++------
 tools/perf/util/sort.h        |    6 -
 7 files changed, 544 insertions(+), 249 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0797786..9c4dc30 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -560,6 +560,8 @@ ifneq ($(shell sh -c "(echo '\#include <newt.h>'; echo 'int main(void) { newtIni
 	msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
+	# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
+	BASIC_CFLAGS += -I/usr/include/slang
 	EXTLIBS += -lnewt
 	LIB_OBJS += $(OUTPUT)util/newt.o
 endif
@@ -948,6 +950,9 @@ $(OUTPUT)builtin-init-db.o: builtin-init-db.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/newt.o: util/newt.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 3940964..fd1b786 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -34,68 +34,8 @@ static bool		full_paths;
 
 static bool		print_line;
 
-struct sym_hist {
-	u64		sum;
-	u64		ip[0];
-};
-
-struct sym_ext {
-	struct rb_node	node;
-	double		percent;
-	char		*path;
-};
-
-struct sym_priv {
-	struct sym_hist	*hist;
-	struct sym_ext	*ext;
-};
-
 static const char *sym_hist_filter;
 
-static int sym__alloc_hist(struct symbol *self)
-{
-	struct sym_priv *priv = symbol__priv(self);
-	const int size = (sizeof(*priv->hist) +
-			  (self->end - self->start) * sizeof(u64));
-
-	priv->hist = zalloc(size);
-	return priv->hist == NULL ? -1 : 0;
-}
-
-/*
- * collect histogram counts
- */
-static int annotate__hist_hit(struct hist_entry *he, u64 ip)
-{
-	unsigned int sym_size, offset;
-	struct symbol *sym = he->ms.sym;
-	struct sym_priv *priv;
-	struct sym_hist *h;
-
-	if (!sym || !he->ms.map)
-		return 0;
-
-	priv = symbol__priv(sym);
-	if (priv->hist == NULL && sym__alloc_hist(sym) < 0)
-		return -ENOMEM;
-
-	sym_size = sym->end - sym->start;
-	offset = ip - sym->start;
-
-	pr_debug3("%s: ip=%#Lx\n", __func__, he->ms.map->unmap_ip(he->ms.map, ip));
-
-	if (offset >= sym_size)
-		return 0;
-
-	h = priv->hist;
-	h->sum++;
-	h->ip[offset]++;
-
-	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", he->ms.sym->start,
-		  he->ms.sym->name, ip, ip - he->ms.sym->start, h->ip[offset]);
-	return 0;
-}
-
 static int hists__add_entry(struct hists *self, struct addr_location *al)
 {
 	struct hist_entry *he;
@@ -115,7 +55,7 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 	if (he == NULL)
 		return -ENOMEM;
 
-	return annotate__hist_hit(he, al->addr);
+	return hist_entry__inc_addr_samples(he, al->addr);
 }
 
 static int process_sample_event(event_t *event, struct perf_session *session)
@@ -140,101 +80,6 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-struct objdump_line {
-	struct list_head node;
-	s64		 offset;
-	char		 *line;
-};
-
-static struct objdump_line *objdump_line__new(s64 offset, char *line)
-{
-	struct objdump_line *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->offset = offset;
-		self->line = line;
-	}
-
-	return self;
-}
-
-static void objdump_line__free(struct objdump_line *self)
-{
-	free(self->line);
-	free(self);
-}
-
-static void objdump__add_line(struct list_head *head, struct objdump_line *line)
-{
-	list_add_tail(&line->node, head);
-}
-
-static struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
-						      struct objdump_line *pos)
-{
-	list_for_each_entry_continue(pos, head, node)
-		if (pos->offset >= 0)
-			return pos;
-
-	return NULL;
-}
-
-static int parse_line(FILE *file, struct hist_entry *he,
-		      struct list_head *head)
-{
-	struct symbol *sym = he->ms.sym;
-	struct objdump_line *objdump_line;
-	char *line = NULL, *tmp, *tmp2;
-	size_t line_len;
-	s64 line_ip, offset = -1;
-	char *c;
-
-	if (getline(&line, &line_len, file) < 0)
-		return -1;
-
-	if (!line)
-		return -1;
-
-	c = strchr(line, '\n');
-	if (c)
-		*c = 0;
-
-	line_ip = -1;
-
-	/*
-	 * Strip leading spaces:
-	 */
-	tmp = line;
-	while (*tmp) {
-		if (*tmp != ' ')
-			break;
-		tmp++;
-	}
-
-	if (*tmp) {
-		/*
-		 * Parse hexa addresses followed by ':'
-		 */
-		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':')
-			line_ip = -1;
-	}
-
-	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(he->ms.map, sym->start);
-		offset = line_ip - start;
-	}
-
-	objdump_line = objdump_line__new(offset, line);
-	if (objdump_line == NULL) {
-		free(line);
-		return -1;
-	}
-	objdump__add_line(head, objdump_line);
-
-	return 0;
-}
-
 static int objdump_line__print(struct objdump_line *self,
 			       struct list_head *head,
 			       struct hist_entry *he, u64 len)
@@ -439,27 +284,11 @@ static void annotate_sym(struct hist_entry *he)
 	struct symbol *sym = he->ms.sym;
 	const char *filename = dso->long_name, *d_filename;
 	u64 len;
-	char command[PATH_MAX*2];
-	FILE *file;
 	LIST_HEAD(head);
 	struct objdump_line *pos, *n;
 
-	if (!filename)
-		return;
-
-	if (dso->origin == DSO__ORIG_KERNEL) {
-		if (dso->annotate_warned)
-			return;
-		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path:\n", sym->name);
-		vmlinux_path__fprintf(stderr);
+	if (hist_entry__annotate(he, &head) < 0)
 		return;
-	}
-
-	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
-		 filename, sym->name, map->unmap_ip(map, sym->start),
-		 map->unmap_ip(map, sym->end));
 
 	if (full_paths)
 		d_filename = filename;
@@ -477,29 +306,6 @@ static void annotate_sym(struct hist_entry *he)
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
-	if (verbose >= 2)
-		printf("annotating [%p] %30s : [%p] %30s\n",
-		       dso, dso->long_name, sym, sym->name);
-
-	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
-		map__rip_2objdump(map, sym->start),
-		map__rip_2objdump(map, sym->end),
-		filename, filename);
-
-	if (verbose >= 3)
-		printf("doing: %s\n", command);
-
-	file = popen(command, "r");
-	if (!file)
-		return;
-
-	while (!feof(file)) {
-		if (parse_line(file, he, &head) < 0)
-			break;
-	}
-
-	pclose(file);
-
 	if (verbose)
 		hist_entry__print_hits(he);
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3d67d6b..04de338 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -106,8 +106,18 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	if (he == NULL)
 		goto out_free_syms;
 	err = 0;
-	if (symbol_conf.use_callchain)
+	if (symbol_conf.use_callchain) {
 		err = append_chain(he->callchain, data->callchain, syms);
+		if (err)
+			goto out_free_syms;
+	}
+	/*
+	 * Only in the newt browser we are doing integrated annotation,
+	 * so we don't allocated the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	if (use_browser)
+		err = hist_entry__inc_addr_samples(he, al->addr);
 out_free_syms:
 	free(syms);
 	return err;
@@ -458,6 +468,13 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	if (strcmp(input_name, "-") != 0)
 		setup_browser();
+	/*
+	 * Only in the newt browser we are doing integrated annotation,
+	 * so don't allocate extra space that won't be used in the stdio
+	 * implementation.
+	 */
+	if (use_browser)
+		symbol_conf.priv_size = sizeof(struct sym_priv);
 
 	if (symbol__init() < 0)
 		return -1;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index baa55be..451d2e4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -843,3 +843,187 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 		}
 	}
 }
+
+static int symbol__alloc_hist(struct symbol *self)
+{
+	struct sym_priv *priv = symbol__priv(self);
+	const int size = (sizeof(*priv->hist) +
+			  (self->end - self->start) * sizeof(u64));
+
+	priv->hist = zalloc(size);
+	return priv->hist == NULL ? -1 : 0;
+}
+
+int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
+{
+	unsigned int sym_size, offset;
+	struct symbol *sym = self->ms.sym;
+	struct sym_priv *priv;
+	struct sym_hist *h;
+
+	if (!sym || !self->ms.map)
+		return 0;
+
+	priv = symbol__priv(sym);
+	if (priv->hist == NULL && symbol__alloc_hist(sym) < 0)
+		return -ENOMEM;
+
+	sym_size = sym->end - sym->start;
+	offset = ip - sym->start;
+
+	pr_debug3("%s: ip=%#Lx\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
+
+	if (offset >= sym_size)
+		return 0;
+
+	h = priv->hist;
+	h->sum++;
+	h->ip[offset]++;
+
+	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
+		  self->ms.sym->name, ip, ip - self->ms.sym->start, h->ip[offset]);
+	return 0;
+}
+
+static struct objdump_line *objdump_line__new(s64 offset, char *line)
+{
+	struct objdump_line *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->offset = offset;
+		self->line = line;
+	}
+
+	return self;
+}
+
+void objdump_line__free(struct objdump_line *self)
+{
+	free(self->line);
+	free(self);
+}
+
+static void objdump__add_line(struct list_head *head, struct objdump_line *line)
+{
+	list_add_tail(&line->node, head);
+}
+
+struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
+					       struct objdump_line *pos)
+{
+	list_for_each_entry_continue(pos, head, node)
+		if (pos->offset >= 0)
+			return pos;
+
+	return NULL;
+}
+
+static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
+					  struct list_head *head)
+{
+	struct symbol *sym = self->ms.sym;
+	struct objdump_line *objdump_line;
+	char *line = NULL, *tmp, *tmp2, *c;
+	size_t line_len;
+	s64 line_ip, offset = -1;
+
+	if (getline(&line, &line_len, file) < 0)
+		return -1;
+
+	if (!line)
+		return -1;
+
+	while (line_len != 0 && isspace(line[line_len - 1]))
+		line[--line_len] = '\0';
+
+	c = strchr(line, '\n');
+	if (c)
+		*c = 0;
+
+	line_ip = -1;
+
+	/*
+	 * Strip leading spaces:
+	 */
+	tmp = line;
+	while (*tmp) {
+		if (*tmp != ' ')
+			break;
+		tmp++;
+	}
+
+	if (*tmp) {
+		/*
+		 * Parse hexa addresses followed by ':'
+		 */
+		line_ip = strtoull(tmp, &tmp2, 16);
+		if (*tmp2 != ':')
+			line_ip = -1;
+	}
+
+	if (line_ip != -1) {
+		u64 start = map__rip_2objdump(self->ms.map, sym->start);
+		offset = line_ip - start;
+	}
+
+	objdump_line = objdump_line__new(offset, line);
+	if (objdump_line == NULL) {
+		free(line);
+		return -1;
+	}
+	objdump__add_line(head, objdump_line);
+
+	return 0;
+}
+
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
+{
+	struct symbol *sym = self->ms.sym;
+	struct map *map = self->ms.map;
+	struct dso *dso = map->dso;
+	const char *filename = dso->long_name;
+	char command[PATH_MAX * 2];
+	FILE *file;
+	u64 len;
+
+	if (!filename)
+		return -1;
+
+	if (dso->origin == DSO__ORIG_KERNEL) {
+		if (dso->annotate_warned)
+			return 0;
+		dso->annotate_warned = 1;
+		pr_err("Can't annotate %s: No vmlinux file was found in the "
+		       "path:\n", sym->name);
+		vmlinux_path__fprintf(stderr);
+		return -1;
+	}
+
+	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
+		 filename, sym->name, map->unmap_ip(map, sym->start),
+		 map->unmap_ip(map, sym->end));
+
+	len = sym->end - sym->start;
+
+	pr_debug("annotating [%p] %30s : [%p] %30s\n",
+		 dso, dso->long_name, sym, sym->name);
+
+	snprintf(command, sizeof(command),
+		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s|expand",
+		 map__rip_2objdump(map, sym->start),
+		 map__rip_2objdump(map, sym->end),
+		 filename, filename);
+
+	pr_debug("Executing: %s\n", command);
+
+	file = popen(command, "r");
+	if (!file)
+		return -1;
+
+	while (!feof(file))
+		if (hist_entry__parse_objdump_line(self, file, head) < 0)
+			break;
+
+	pclose(file);
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1c5f93a..ed9c067 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -11,6 +11,32 @@ struct addr_location;
 struct symbol;
 struct rb_root;
 
+struct objdump_line {
+	struct list_head node;
+	s64		 offset;
+	char		 *line;
+};
+
+void objdump_line__free(struct objdump_line *self);
+struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
+					       struct objdump_line *pos);
+
+struct sym_hist {
+	u64		sum;
+	u64		ip[0];
+};
+
+struct sym_ext {
+	struct rb_node	node;
+	double		percent;
+	char		*path;
+};
+
+struct sym_priv {
+	struct sym_hist	*hist;
+	struct sym_ext	*ext;
+};
+
 struct events_stats {
 	u64 total;
 	u64 lost;
@@ -45,6 +71,9 @@ void hists__collapse_resort(struct hists *self);
 size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
+int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip);
+int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
+
 void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index daa86ef..ba6acd0 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -2,6 +2,7 @@
 #include <stdio.h>
 #undef _GNU_SOURCE
 
+#include <slang.h>
 #include <stdlib.h>
 #include <newt.h>
 #include <sys/ttydefaults.h>
@@ -171,6 +172,254 @@ static bool dialog_yesno(const char *msg)
 	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
 }
 
+#define HE_COLORSET_TOP		50
+#define HE_COLORSET_MEDIUM	51
+#define HE_COLORSET_NORMAL	52
+#define HE_COLORSET_SELECTED	53
+#define HE_COLORSET_CODE	54
+
+static int ui_browser__percent_color(double percent, bool current)
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
+struct ui_browser {
+	newtComponent	form, sb;
+	u64		index, first_visible_entry_idx;
+	void		*first_visible_entry, *entries;
+	u16		top, left, width, height;
+	void		*priv;
+	u32		nr_entries;
+};
+
+static void ui_browser__refresh_dimensions(struct ui_browser *self)
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
+static void ui_browser__reset_index(struct ui_browser *self)
+{
+        self->index = self->first_visible_entry_idx = 0;
+        self->first_visible_entry = NULL;
+}
+
+static int objdump_line__show(struct objdump_line *self, struct list_head *head,
+			      int width, struct hist_entry *he, int len,
+			      bool current_entry)
+{
+	if (self->offset != -1) {
+		struct symbol *sym = he->ms.sym;
+		unsigned int hits = 0;
+		double percent = 0.0;
+		int color;
+		struct sym_priv *priv = symbol__priv(sym);
+		struct sym_ext *sym_ext = priv->ext;
+		struct sym_hist *h = priv->hist;
+		s64 offset = self->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(head, self);
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
+		SLsmg_printf(" %7.2f ", percent);
+		if (!current_entry)
+			SLsmg_set_color(HE_COLORSET_CODE);
+	} else {
+		int color = ui_browser__percent_color(0, current_entry);
+		SLsmg_set_color(color);
+		SLsmg_write_nstring(" ", 9);
+	}
+
+	SLsmg_write_char(':');
+	SLsmg_write_nstring(" ", 8);
+	if (!*self->line)
+		SLsmg_write_nstring(" ", width - 18);
+	else
+		SLsmg_write_nstring(self->line, width - 18);
+
+	return 0;
+}
+
+static int ui_browser__refresh_entries(struct ui_browser *self)
+{
+	struct objdump_line *pos;
+	struct list_head *head = self->entries;
+	struct hist_entry *he = self->priv;
+	int row = 0;
+	int len = he->ms.sym->end - he->ms.sym->start;
+
+	if (self->first_visible_entry == NULL || self->first_visible_entry == self->entries)
+                self->first_visible_entry = head->next;
+
+	pos = list_entry(self->first_visible_entry, struct objdump_line, node);
+
+	list_for_each_entry_from(pos, head, node) {
+		bool current_entry = (self->first_visible_entry_idx + row) == self->index;
+		SLsmg_gotorc(self->top + row, self->left);
+		objdump_line__show(pos, head, self->width,
+				   he, len, current_entry);
+		if (++row == self->height)
+			break;
+	}
+
+	SLsmg_set_color(HE_COLORSET_NORMAL);
+	SLsmg_fill_region(self->top + row, self->left,
+			  self->height - row, self->width, ' ');
+
+	return 0;
+}
+
+static int ui_browser__run(struct ui_browser *self, const char *title,
+			   struct newtExitStruct *es)
+{
+	if (self->form) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
+
+	ui_browser__refresh_dimensions(self);
+	newtCenteredWindow(self->width + 2, self->height, title);
+	self->form = newt_form__new();
+	if (self->form == NULL)
+		return -1;
+
+	self->sb = newtVerticalScrollbar(self->width + 1, 0, self->height,
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
+
+	if (ui_browser__refresh_entries(self) < 0)
+		return -1;
+	newtFormAddComponent(self->form, self->sb);
+
+	while (1) {
+		unsigned int offset;
+
+		newtFormRun(self->form, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		switch (es->u.key) {
+		case NEWT_KEY_DOWN:
+			if (self->index == self->nr_entries - 1)
+				break;
+			++self->index;
+			if (self->index == self->first_visible_entry_idx + self->height) {
+				struct list_head *pos = self->first_visible_entry;
+				++self->first_visible_entry_idx;
+				self->first_visible_entry = pos->next;
+			}
+			break;
+		case NEWT_KEY_UP:
+			if (self->index == 0)
+				break;
+			--self->index;
+			if (self->index < self->first_visible_entry_idx) {
+				struct list_head *pos = self->first_visible_entry;
+				--self->first_visible_entry_idx;
+				self->first_visible_entry = pos->prev;
+			}
+			break;
+		case NEWT_KEY_PGDN:
+			if (self->first_visible_entry_idx + self->height > self->nr_entries - 1)
+				break;
+
+			offset = self->height;
+			if (self->index + offset > self->nr_entries - 1)
+				offset = self->nr_entries - 1 - self->index;
+			self->index += offset;
+			self->first_visible_entry_idx += offset;
+
+			while (offset--) {
+				struct list_head *pos = self->first_visible_entry;
+				self->first_visible_entry = pos->next;
+			}
+
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
+
+			while (offset--) {
+				struct list_head *pos = self->first_visible_entry;
+				self->first_visible_entry = pos->prev;
+			}
+			break;
+		case NEWT_KEY_HOME:
+			ui_browser__reset_index(self);
+			break;
+		case NEWT_KEY_END: {
+			struct list_head *head = self->entries;
+			offset = self->height - 1;
+
+			if (offset > self->nr_entries)
+				offset = self->nr_entries;
+
+			self->index = self->first_visible_entry_idx = self->nr_entries - 1 - offset;
+			self->first_visible_entry = head->prev;
+			while (offset-- != 0) {
+				struct list_head *pos = self->first_visible_entry;
+				self->first_visible_entry = pos->prev;
+			}
+		}
+			break;
+		case NEWT_KEY_ESCAPE:
+		case CTRL('c'):
+		case 'Q':
+		case 'q':
+			return 0;
+		default:
+			continue;
+		}
+		if (ui_browser__refresh_entries(self) < 0)
+			return -1;
+	}
+	return 0;
+}
+
 /*
  * When debugging newt problems it was useful to be able to "unroll"
  * the calls to newtCheckBoxTreeAdd{Array,Item}, so that we can generate
@@ -353,62 +602,40 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 	return ret;
 }
 
-static void map_symbol__annotate_browser(const struct map_symbol *self,
-					 const char *input_name)
+static void hist_entry__annotate_browser(struct hist_entry *self)
 {
-	FILE *fp;
-	int cols, rows;
-	newtComponent form, tree;
+	struct ui_browser browser;
 	struct newtExitStruct es;
-	char *str;
-	size_t line_len, max_line_len = 0;
-	size_t max_usable_width;
-	char *line = NULL;
+	struct objdump_line *pos, *n;
+	LIST_HEAD(head);
 
-	if (self->sym == NULL)
+	if (self->ms.sym == NULL)
 		return;
 
-	if (asprintf(&str, "perf annotate -i \"%s\" -d \"%s\" %s 2>&1 | expand",
-		     input_name, self->map->dso->name, self->sym->name) < 0)
+	if (hist_entry__annotate(self, &head) < 0)
 		return;
 
-	fp = popen(str, "r");
-	if (fp == NULL)
-		goto out_free_str;
-
 	ui_helpline__push("Press ESC to exit");
-	newtGetScreenSize(&cols, &rows);
-	tree = newtListbox(0, 0, rows - 5, NEWT_FLAG_SCROLL);
-
-	while (!feof(fp)) {
-		if (getline(&line, &line_len, fp) < 0 || !line_len)
-			break;
-		while (line_len != 0 && isspace(line[line_len - 1]))
-			line[--line_len] = '\0';
 
-		if (line_len > max_line_len)
-			max_line_len = line_len;
-		newtListboxAppendEntry(tree, line, NULL);
+	memset(&browser, 0, sizeof(browser));
+	browser.entries = &head;
+	browser.priv = self;
+	list_for_each_entry(pos, &head, node) {
+		size_t line_len = strlen(pos->line);
+		if (browser.width < line_len)
+			browser.width = line_len;
+		++browser.nr_entries;
 	}
-	fclose(fp);
-	free(line);
-
-	max_usable_width = cols - 22;
-	if (max_line_len > max_usable_width)
-		max_line_len = max_usable_width;
-
-	newtListboxSetWidth(tree, max_line_len);
 
-	newtCenteredWindow(max_line_len + 2, rows - 5, self->sym->name);
-	form = newt_form__new();
-	newtFormAddComponent(form, tree);
-
-	newtFormRun(form, &es);
-	newtFormDestroy(form);
+	browser.width += 18; /* Percentage */
+	ui_browser__run(&browser, self->ms.sym->name, &es);
+	newtFormDestroy(browser.form);
 	newtPopWindow();
+	list_for_each_entry_safe(pos, n, &head, node) {
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
 	ui_helpline__pop();
-out_free_str:
-	free(str);
 }
 
 static const void *newt__symbol_tree_get_current(newtComponent self)
@@ -527,7 +754,7 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	return 0;
 }
 
-static struct thread *hist_browser__selected_thread(struct hist_browser *self)
+static struct hist_entry *hist_browser__selected_entry(struct hist_browser *self)
 {
 	int *indexes;
 
@@ -543,7 +770,13 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 	}
 	return NULL;
 out:
-	return *(struct thread **)(self->selection + 1);
+	return container_of(self->selection, struct hist_entry, ms);
+}
+
+static struct thread *hist_browser__selected_thread(struct hist_browser *self)
+{
+	struct hist_entry *he = hist_browser__selected_entry(self);
+	return he ? he->thread : NULL;
 }
 
 static int hist_browser__title(char *bf, size_t size, const char *input_name,
@@ -637,13 +870,20 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 			continue;
 do_annotate:
 		if (choice == annotate) {
+			struct hist_entry *he;
+
 			if (browser->selection->map->dso->origin == DSO__ORIG_KERNEL) {
 				ui_helpline__puts("No vmlinux file found, can't "
 						 "annotate with just a "
 						 "kallsyms file");
 				continue;
 			}
-			map_symbol__annotate_browser(browser->selection, input_name);
+
+			he = hist_browser__selected_entry(browser);
+			if (he == NULL)
+				continue;
+
+			hist_entry__annotate_browser(he);
 		} else if (choice == zoom_dso) {
 			if (dso_filter) {
 				ui_helpline__pop();
@@ -681,8 +921,23 @@ out:
 	return err;
 }
 
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
 void setup_browser(void)
 {
+	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
 	if (!isatty(1))
 		return;
 
@@ -690,6 +945,11 @@ void setup_browser(void)
 	newtInit();
 	newtCls();
 	ui_helpline__puts(" ");
+	SLtt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
+	SLtt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
+	SLtt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
+	SLtt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
+	SLtt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
 }
 
 void exit_browser(bool wait_for_ok)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b7c54ee..af301ac 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -48,12 +48,6 @@ struct hist_entry {
 	u64			count_us;
 	u64			count_guest_sys;
 	u64			count_guest_us;
-
-	/*
-	 * XXX WARNING!
-	 * thread _has_ to come after ms, see
-	 * hist_browser__selected_thread in util/newt.c
-	 */
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
-- 
1.6.2.5

