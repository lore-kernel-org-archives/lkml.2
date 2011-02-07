Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1BGAoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:44:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1BGAn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:43:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/6] perf annotate: Move annotate functions to util/
Date: Sun,  6 Feb 2011 22:42:13 -0200
Message-Id: <1297039337-6690-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

They will be used by perf top, so that we have just one set of routines
to do annotation.

Rename "struct sym_priv" to "struct annotation", etc, to clarify this
code a bit.

Rename "struct sym_ext" to "struct source_line", to give it a meaningful
name, that clarifies that it is a the result of an addr2line call, that
is sorted by percentage one particular source code line appeared in the
annotation.

And since we're moving things around also rename 'sym_hist->ip' to
'sym_hist->addr' as we want to do data structure annotation at some
point.

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
 tools/perf/Makefile                    |    2 +
 tools/perf/builtin-annotate.c          |  255 +-----------------
 tools/perf/builtin-report.c            |    3 +-
 tools/perf/util/annotate.c             |  467 ++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h             |   65 +++++
 tools/perf/util/hist.c                 |  219 +---------------
 tools/perf/util/hist.h                 |   27 --
 tools/perf/util/ui/browsers/annotate.c |   43 ++--
 8 files changed, 578 insertions(+), 503 deletions(-)
 create mode 100644 tools/perf/util/annotate.c
 create mode 100644 tools/perf/util/annotate.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4c9499c..be3eb1d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -401,6 +401,7 @@ LIB_H += util/include/dwarf-regs.h
 LIB_H += util/include/asm/dwarf2.h
 LIB_H += util/include/asm/cpufeature.h
 LIB_H += perf.h
+LIB_H += util/annotate.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
@@ -444,6 +445,7 @@ LIB_H += $(ARCH_INCLUDE)
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
+LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index cd9dec4..9072ef4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -9,6 +9,7 @@
 
 #include "util/util.h"
 
+#include "util/util.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
@@ -18,6 +19,7 @@
 #include "perf.h"
 #include "util/debug.h"
 
+#include "util/annotate.h"
 #include "util/event.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -79,245 +81,10 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
-static int objdump_line__print(struct objdump_line *self,
-			       struct list_head *head,
-			       struct hist_entry *he, u64 len)
-{
-	struct symbol *sym = he->ms.sym;
-	static const char *prev_line;
-	static const char *prev_color;
-
-	if (self->offset != -1) {
-		const char *path = NULL;
-		unsigned int hits = 0;
-		double percent = 0.0;
-		const char *color;
-		struct sym_priv *priv = symbol__priv(sym);
-		struct sym_ext *sym_ext = priv->ext;
-		struct sym_hist *h = priv->hist;
-		s64 offset = self->offset;
-		struct objdump_line *next = objdump__get_next_ip_line(head, self);
-
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (sym_ext) {
-				if (path == NULL)
-					path = sym_ext[offset].path;
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
-		color = get_percent_color(percent);
-
-		/*
-		 * Also color the filename and line if needed, with
-		 * the same color than the percentage. Don't print it
-		 * twice for close colored ip with the same filename:line
-		 */
-		if (path) {
-			if (!prev_line || strcmp(prev_line, path)
-				       || color != prev_color) {
-				color_fprintf(stdout, color, " %s", path);
-				prev_line = path;
-				prev_color = color;
-			}
-		}
-
-		color_fprintf(stdout, color, " %7.2f", percent);
-		printf(" :	");
-		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", self->line);
-	} else {
-		if (!*self->line)
-			printf("         :\n");
-		else
-			printf("         :	%s\n", self->line);
-	}
-
-	return 0;
-}
-
-static struct rb_root root_sym_ext;
-
-static void insert_source_line(struct sym_ext *sym_ext)
-{
-	struct sym_ext *iter;
-	struct rb_node **p = &root_sym_ext.rb_node;
-	struct rb_node *parent = NULL;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct sym_ext, node);
-
-		if (sym_ext->percent > iter->percent)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&sym_ext->node, parent, p);
-	rb_insert_color(&sym_ext->node, &root_sym_ext);
-}
-
-static void free_source_line(struct hist_entry *he, int len)
-{
-	struct sym_priv *priv = symbol__priv(he->ms.sym);
-	struct sym_ext *sym_ext = priv->ext;
-	int i;
-
-	if (!sym_ext)
-		return;
-
-	for (i = 0; i < len; i++)
-		free(sym_ext[i].path);
-	free(sym_ext);
-
-	priv->ext = NULL;
-	root_sym_ext = RB_ROOT;
-}
-
-/* Get the filename:line for the colored entries */
-static void
-get_source_line(struct hist_entry *he, int len, const char *filename)
-{
-	struct symbol *sym = he->ms.sym;
-	u64 start;
-	int i;
-	char cmd[PATH_MAX * 2];
-	struct sym_ext *sym_ext;
-	struct sym_priv *priv = symbol__priv(sym);
-	struct sym_hist *h = priv->hist;
-
-	if (!h->sum)
-		return;
-
-	sym_ext = priv->ext = calloc(len, sizeof(struct sym_ext));
-	if (!priv->ext)
-		return;
-
-	start = he->ms.map->unmap_ip(he->ms.map, sym->start);
-
-	for (i = 0; i < len; i++) {
-		char *path = NULL;
-		size_t line_len;
-		u64 offset;
-		FILE *fp;
-
-		sym_ext[i].percent = 100.0 * h->ip[i] / h->sum;
-		if (sym_ext[i].percent <= 0.5)
-			continue;
-
-		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
-		fp = popen(cmd, "r");
-		if (!fp)
-			continue;
-
-		if (getline(&path, &line_len, fp) < 0 || !line_len)
-			goto next;
-
-		sym_ext[i].path = malloc(sizeof(char) * line_len + 1);
-		if (!sym_ext[i].path)
-			goto next;
-
-		strcpy(sym_ext[i].path, path);
-		insert_source_line(&sym_ext[i]);
-
-	next:
-		pclose(fp);
-	}
-}
-
-static void print_summary(const char *filename)
-{
-	struct sym_ext *sym_ext;
-	struct rb_node *node;
-
-	printf("\nSorted summary for file %s\n", filename);
-	printf("----------------------------------------------\n\n");
-
-	if (RB_EMPTY_ROOT(&root_sym_ext)) {
-		printf(" Nothing higher than %1.1f%%\n", MIN_GREEN);
-		return;
-	}
-
-	node = rb_first(&root_sym_ext);
-	while (node) {
-		double percent;
-		const char *color;
-		char *path;
-
-		sym_ext = rb_entry(node, struct sym_ext, node);
-		percent = sym_ext->percent;
-		color = get_percent_color(percent);
-		path = sym_ext->path;
-
-		color_fprintf(stdout, color, " %7.2f %s", percent, path);
-		node = rb_next(node);
-	}
-}
-
-static void hist_entry__print_hits(struct hist_entry *self)
-{
-	struct symbol *sym = self->ms.sym;
-	struct sym_priv *priv = symbol__priv(sym);
-	struct sym_hist *h = priv->hist;
-	u64 len = sym->end - sym->start, offset;
-
-	for (offset = 0; offset < len; ++offset)
-		if (h->ip[offset] != 0)
-			printf("%*" PRIx64 ": %" PRIu64 "\n", BITS_PER_LONG / 2,
-			       sym->start + offset, h->ip[offset]);
-	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
-}
-
 static int hist_entry__tty_annotate(struct hist_entry *he)
 {
-	struct map *map = he->ms.map;
-	struct dso *dso = map->dso;
-	struct symbol *sym = he->ms.sym;
-	const char *filename = dso->long_name, *d_filename;
-	u64 len;
-	LIST_HEAD(head);
-	struct objdump_line *pos, *n;
-
-	if (hist_entry__annotate(he, &head, 0) < 0)
-		return -1;
-
-	if (full_paths)
-		d_filename = filename;
-	else
-		d_filename = basename(filename);
-
-	len = sym->end - sym->start;
-
-	if (print_line) {
-		get_source_line(he, len, filename);
-		print_summary(filename);
-	}
-
-	printf("\n\n------------------------------------------------\n");
-	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
-	printf("------------------------------------------------\n");
-
-	if (verbose)
-		hist_entry__print_hits(he);
-
-	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, he, len);
-		list_del(&pos->node);
-		objdump_line__free(pos);
-	}
-
-	if (print_line)
-		free_source_line(he, len);
-
-	return 0;
+	return symbol__tty_annotate(he->ms.sym, he->ms.map,
+				    print_line, full_paths);
 }
 
 static void hists__find_annotations(struct hists *self)
@@ -327,13 +94,13 @@ static void hists__find_annotations(struct hists *self)
 
 	while (nd) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
-		struct sym_priv *priv;
+		struct annotation *notes;
 
 		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned)
 			goto find_next;
 
-		priv = symbol__priv(he->ms.sym);
-		if (priv->hist == NULL) {
+		notes = symbol__annotation(he->ms.sym);
+		if (notes->histogram == NULL) {
 find_next:
 			if (key == KEY_LEFT)
 				nd = rb_prev(nd);
@@ -362,11 +129,11 @@ find_next:
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
-			 * symbol, free he->ms.sym->hist to signal we already
+			 * symbol, free he->ms.sym->histogram to signal we already
 			 * processed this symbol.
 			 */
-			free(priv->hist);
-			priv->hist = NULL;
+			free(notes->histogram);
+			notes->histogram = NULL;
 		}
 	}
 }
@@ -454,7 +221,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(true);
 
-	symbol_conf.priv_size = sizeof(struct sym_priv);
+	symbol_conf.priv_size = sizeof(struct annotation);
 	symbol_conf.try_vmlinux_path = true;
 
 	if (symbol__init() < 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 080937c..91e4cdb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -9,6 +9,7 @@
 
 #include "util/util.h"
 
+#include "util/annotate.h"
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
@@ -508,7 +509,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 * implementation.
 	 */
 	if (use_browser > 0) {
-		symbol_conf.priv_size = sizeof(struct sym_priv);
+		symbol_conf.priv_size = sizeof(struct annotation);
 		/*
  		 * For searching by name on the "Browse map details".
  		 * providing it only in verbose mode not to bloat too
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
new file mode 100644
index 0000000..9b25575
--- /dev/null
+++ b/tools/perf/util/annotate.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (C) 2011, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Parts came from builtin-annotate.c, see those files for further
+ * copyright notes.
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+
+#include "util.h"
+#include "build-id.h"
+#include "color.h"
+#include "cache.h"
+#include "symbol.h"
+#include "debug.h"
+#include "annotate.h"
+
+static int symbol__alloc_hist(struct symbol *sym)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	const int size = (sizeof(*notes->histogram) +
+			  (sym->end - sym->start) * sizeof(u64));
+
+	notes->histogram = zalloc(size);
+	return notes->histogram == NULL ? -1 : 0;
+}
+
+int symbol__inc_addr_samples(struct symbol *sym, struct map *map, u64 addr)
+{
+	unsigned int sym_size, offset;
+	struct annotation *notes;
+	struct sym_hist *h;
+
+	if (!sym || !map)
+		return 0;
+
+	notes = symbol__annotation(sym);
+	if (notes->histogram == NULL && symbol__alloc_hist(sym) < 0)
+		return -ENOMEM;
+
+	sym_size = sym->end - sym->start;
+	offset = addr - sym->start;
+
+	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
+
+	if (offset >= sym_size)
+		return 0;
+
+	h = notes->histogram;
+	h->sum++;
+	h->addr[offset]++;
+
+	pr_debug3("%#" PRIx64 " %s: period++ [addr: %#" PRIx64 ", %#" PRIx64
+		  "] => %" PRIu64 "\n", sym->start, sym->name,
+		  addr, addr - sym->start, h->addr[offset]);
+	return 0;
+}
+
+static struct objdump_line *objdump_line__new(s64 offset, char *line, size_t privsize)
+{
+	struct objdump_line *self = malloc(sizeof(*self) + privsize);
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
+static void objdump_line__print(struct objdump_line *oline,
+				struct list_head *head,
+				struct symbol *sym, u64 len)
+{
+	static const char *prev_line;
+	static const char *prev_color;
+
+	if (oline->offset != -1) {
+		const char *path = NULL;
+		unsigned int hits = 0;
+		double percent = 0.0;
+		const char *color;
+		struct annotation *notes = symbol__annotation(sym);
+		struct source_line *src_line = notes->src_line;
+		struct sym_hist *h = notes->histogram;
+		s64 offset = oline->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(head, oline);
+
+		while (offset < (s64)len &&
+		       (next == NULL || offset < next->offset)) {
+			if (src_line) {
+				if (path == NULL)
+					path = src_line[offset].path;
+				percent += src_line[offset].percent;
+			} else
+				hits += h->addr[offset];
+
+			++offset;
+		}
+
+		if (src_line == NULL && h->sum)
+			percent = 100.0 * hits / h->sum;
+
+		color = get_percent_color(percent);
+
+		/*
+		 * Also color the filename and line if needed, with
+		 * the same color than the percentage. Don't print it
+		 * twice for close colored addr with the same filename:line
+		 */
+		if (path) {
+			if (!prev_line || strcmp(prev_line, path)
+				       || color != prev_color) {
+				color_fprintf(stdout, color, " %s", path);
+				prev_line = path;
+				prev_color = color;
+			}
+		}
+
+		color_fprintf(stdout, color, " %7.2f", percent);
+		printf(" :	");
+		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", oline->line);
+	} else {
+		if (!*oline->line)
+			printf("         :\n");
+		else
+			printf("         :	%s\n", oline->line);
+	}
+}
+
+static int symbol__parse_objdump_line(struct symbol *sym, struct map *map, FILE *file,
+				      struct list_head *head, size_t privsize)
+{
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
+		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
+			line_ip = -1;
+	}
+
+	if (line_ip != -1) {
+		u64 start = map__rip_2objdump(map, sym->start),
+		    end = map__rip_2objdump(map, sym->end);
+
+		offset = line_ip - start;
+		if (offset < 0 || (u64)line_ip > end)
+			offset = -1;
+	}
+
+	objdump_line = objdump_line__new(offset, line, privsize);
+	if (objdump_line == NULL) {
+		free(line);
+		return -1;
+	}
+	objdump__add_line(head, objdump_line);
+
+	return 0;
+}
+
+int symbol__annotate(struct symbol *sym, struct map *map,
+		     struct list_head *head, size_t privsize)
+{
+	struct dso *dso = map->dso;
+	char *filename = dso__build_id_filename(dso, NULL, 0);
+	bool free_filename = true;
+	char command[PATH_MAX * 2];
+	FILE *file;
+	int err = 0;
+	u64 len;
+	char symfs_filename[PATH_MAX];
+
+	if (filename) {
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+			 symbol_conf.symfs, filename);
+	}
+
+	if (filename == NULL) {
+		if (dso->has_build_id) {
+			pr_err("Can't annotate %s: not enough memory\n",
+			       sym->name);
+			return -ENOMEM;
+		}
+		goto fallback;
+	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
+		   strstr(command, "[kernel.kallsyms]") ||
+		   access(symfs_filename, R_OK)) {
+		free(filename);
+fallback:
+		/*
+		 * If we don't have build-ids or the build-id file isn't in the
+		 * cache, or is just a kallsyms file, well, lets hope that this
+		 * DSO is the same as when 'perf record' ran.
+		 */
+		filename = dso->long_name;
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+			 symbol_conf.symfs, filename);
+		free_filename = false;
+	}
+
+	if (dso->origin == DSO__ORIG_KERNEL) {
+		if (dso->annotate_warned)
+			goto out_free_filename;
+		err = -ENOENT;
+		dso->annotate_warned = 1;
+		pr_err("Can't annotate %s: No vmlinux file was found in the "
+		       "path\n", sym->name);
+		goto out_free_filename;
+	}
+
+	pr_debug("%s: filename=%s, sym=%s, start=%#" PRIx64 ", end=%#" PRIx64 "\n", __func__,
+		 filename, sym->name, map->unmap_ip(map, sym->start),
+		 map->unmap_ip(map, sym->end));
+
+	len = sym->end - sym->start;
+
+	pr_debug("annotating [%p] %30s : [%p] %30s\n",
+		 dso, dso->long_name, sym, sym->name);
+
+	snprintf(command, sizeof(command),
+		 "objdump --start-address=0x%016" PRIx64
+		 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
+		 map__rip_2objdump(map, sym->start),
+		 map__rip_2objdump(map, sym->end),
+		 symfs_filename, filename);
+
+	pr_debug("Executing: %s\n", command);
+
+	file = popen(command, "r");
+	if (!file)
+		goto out_free_filename;
+
+	while (!feof(file))
+		if (symbol__parse_objdump_line(sym, map, file, head, privsize) < 0)
+			break;
+
+	pclose(file);
+out_free_filename:
+	if (free_filename)
+		free(filename);
+	return err;
+}
+
+static void insert_source_line(struct rb_root *root, struct source_line *src_line)
+{
+	struct source_line *iter;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct source_line, node);
+
+		if (src_line->percent > iter->percent)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&src_line->node, parent, p);
+	rb_insert_color(&src_line->node, root);
+}
+
+static void symbol__free_source_line(struct symbol *sym, int len)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct source_line *src_line = notes->src_line;
+	int i;
+
+	for (i = 0; i < len; i++)
+		free(src_line[i].path);
+
+	free(src_line);
+	notes->src_line = NULL;
+}
+
+/* Get the filename:line for the colored entries */
+static int symbol__get_source_line(struct symbol *sym, struct map *map,
+				   struct rb_root *root, int len,
+				   const char *filename)
+{
+	u64 start;
+	int i;
+	char cmd[PATH_MAX * 2];
+	struct source_line *src_line;
+	struct annotation *notes = symbol__annotation(sym);
+	struct sym_hist *h = notes->histogram;
+
+	if (!h->sum)
+		return 0;
+
+	src_line = notes->src_line = calloc(len, sizeof(struct source_line));
+	if (!notes->src_line)
+		return -1;
+
+	start = map->unmap_ip(map, sym->start);
+
+	for (i = 0; i < len; i++) {
+		char *path = NULL;
+		size_t line_len;
+		u64 offset;
+		FILE *fp;
+
+		src_line[i].percent = 100.0 * h->addr[i] / h->sum;
+		if (src_line[i].percent <= 0.5)
+			continue;
+
+		offset = start + i;
+		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
+		fp = popen(cmd, "r");
+		if (!fp)
+			continue;
+
+		if (getline(&path, &line_len, fp) < 0 || !line_len)
+			goto next;
+
+		src_line[i].path = malloc(sizeof(char) * line_len + 1);
+		if (!src_line[i].path)
+			goto next;
+
+		strcpy(src_line[i].path, path);
+		insert_source_line(root, &src_line[i]);
+
+	next:
+		pclose(fp);
+	}
+
+	return 0;
+}
+
+static void print_summary(struct rb_root *root, const char *filename)
+{
+	struct source_line *src_line;
+	struct rb_node *node;
+
+	printf("\nSorted summary for file %s\n", filename);
+	printf("----------------------------------------------\n\n");
+
+	if (RB_EMPTY_ROOT(root)) {
+		printf(" Nothing higher than %1.1f%%\n", MIN_GREEN);
+		return;
+	}
+
+	node = rb_first(root);
+	while (node) {
+		double percent;
+		const char *color;
+		char *path;
+
+		src_line = rb_entry(node, struct source_line, node);
+		percent = src_line->percent;
+		color = get_percent_color(percent);
+		path = src_line->path;
+
+		color_fprintf(stdout, color, " %7.2f %s", percent, path);
+		node = rb_next(node);
+	}
+}
+
+static void symbol__annotate_hits(struct symbol *sym)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct sym_hist *h = notes->histogram;
+	u64 len = sym->end - sym->start, offset;
+
+	for (offset = 0; offset < len; ++offset)
+		if (h->addr[offset] != 0)
+			printf("%*" PRIx64 ": %" PRIu64 "\n", BITS_PER_LONG / 2,
+			       sym->start + offset, h->addr[offset]);
+	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
+}
+
+int symbol__tty_annotate(struct symbol *sym, struct map *map, bool print_lines,
+			 bool full_paths)
+{
+	struct dso *dso = map->dso;
+	const char *filename = dso->long_name, *d_filename;
+	struct rb_root source_line = RB_ROOT;
+	struct objdump_line *pos, *n;
+	LIST_HEAD(head);
+	u64 len;
+
+	if (symbol__annotate(sym, map, &head, 0) < 0)
+		return -1;
+
+	if (full_paths)
+		d_filename = filename;
+	else
+		d_filename = basename(filename);
+
+	len = sym->end - sym->start;
+
+	if (print_lines) {
+		symbol__get_source_line(sym, map, &source_line, len, filename);
+		print_summary(&source_line, filename);
+	}
+
+	printf("\n\n------------------------------------------------\n");
+	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
+	printf("------------------------------------------------\n");
+
+	if (verbose)
+		symbol__annotate_hits(sym);
+
+	list_for_each_entry_safe(pos, n, &head, node) {
+		objdump_line__print(pos, &head, sym, len);
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+
+	if (print_lines)
+		symbol__free_source_line(sym, len);
+
+	return 0;
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
new file mode 100644
index 0000000..6e2fbc2
--- /dev/null
+++ b/tools/perf/util/annotate.h
@@ -0,0 +1,65 @@
+#ifndef __PERF_ANNOTATE_H
+#define __PERF_ANNOTATE_H
+
+#include <stdbool.h>
+#include "types.h"
+#include "symbol.h"
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
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
+	u64		addr[0];
+};
+
+struct source_line {
+	struct rb_node	node;
+	double		percent;
+	char		*path;
+};
+
+struct annotation {
+	struct sym_hist	   *histogram;
+	struct source_line *src_line;
+};
+
+struct sannotation {
+	struct annotation annotation;
+	struct symbol	  symbol;
+};
+
+static inline struct annotation *symbol__annotation(struct symbol *sym)
+{
+	struct sannotation *a = container_of(sym, struct sannotation, symbol);
+	return &a->annotation;
+}
+
+int symbol__inc_addr_samples(struct symbol *sym, struct map *map, u64 addr);
+
+int symbol__annotate(struct symbol *sym, struct map *map,
+		     struct list_head *head, size_t privsize);
+
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 bool print_lines, bool full_paths);
+
+#ifdef NO_NEWT_SUPPORT
+static inline int symbol__tui_annotate(symbol *sym __used,
+				       struct map *map __used)
+{
+	return 0;
+}
+#else
+int symbol__tui_annotate(struct symbol *sym, struct map *map);
+#endif
+
+#endif	/* __PERF_ANNOTATE_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9588780..6d9c92c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,3 +1,4 @@
+#include "annotate.h"
 #include "util.h"
 #include "build-id.h"
 #include "hist.h"
@@ -949,225 +950,15 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 	}
 }
 
-static int symbol__alloc_hist(struct symbol *self)
+int hist_entry__inc_addr_samples(struct hist_entry *he, u64 ip)
 {
-	struct sym_priv *priv = symbol__priv(self);
-	const int size = (sizeof(*priv->hist) +
-			  (self->end - self->start) * sizeof(u64));
-
-	priv->hist = zalloc(size);
-	return priv->hist == NULL ? -1 : 0;
-}
-
-int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
-{
-	unsigned int sym_size, offset;
-	struct symbol *sym = self->ms.sym;
-	struct sym_priv *priv;
-	struct sym_hist *h;
-
-	if (!sym || !self->ms.map)
-		return 0;
-
-	priv = symbol__priv(sym);
-	if (priv->hist == NULL && symbol__alloc_hist(sym) < 0)
-		return -ENOMEM;
-
-	sym_size = sym->end - sym->start;
-	offset = ip - sym->start;
-
-	pr_debug3("%s: ip=%#" PRIx64 "\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
-
-	if (offset >= sym_size)
-		return 0;
-
-	h = priv->hist;
-	h->sum++;
-	h->ip[offset]++;
-
-	pr_debug3("%#" PRIx64 " %s: period++ [ip: %#" PRIx64 ", %#" PRIx64
-		  "] => %" PRIu64 "\n", self->ms.sym->start, self->ms.sym->name,
-		  ip, ip - self->ms.sym->start, h->ip[offset]);
-	return 0;
-}
-
-static struct objdump_line *objdump_line__new(s64 offset, char *line, size_t privsize)
-{
-	struct objdump_line *self = malloc(sizeof(*self) + privsize);
-
-	if (self != NULL) {
-		self->offset = offset;
-		self->line = line;
-	}
-
-	return self;
-}
-
-void objdump_line__free(struct objdump_line *self)
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
-struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
-					       struct objdump_line *pos)
-{
-	list_for_each_entry_continue(pos, head, node)
-		if (pos->offset >= 0)
-			return pos;
-
-	return NULL;
+	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, ip);
 }
 
-static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
-					  struct list_head *head, size_t privsize)
-{
-	struct symbol *sym = self->ms.sym;
-	struct objdump_line *objdump_line;
-	char *line = NULL, *tmp, *tmp2, *c;
-	size_t line_len;
-	s64 line_ip, offset = -1;
-
-	if (getline(&line, &line_len, file) < 0)
-		return -1;
-
-	if (!line)
-		return -1;
-
-	while (line_len != 0 && isspace(line[line_len - 1]))
-		line[--line_len] = '\0';
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
-		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
-			line_ip = -1;
-	}
-
-	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(self->ms.map, sym->start),
-		    end = map__rip_2objdump(self->ms.map, sym->end);
-
-		offset = line_ip - start;
-		if (offset < 0 || (u64)line_ip > end)
-			offset = -1;
-	}
-
-	objdump_line = objdump_line__new(offset, line, privsize);
-	if (objdump_line == NULL) {
-		free(line);
-		return -1;
-	}
-	objdump__add_line(head, objdump_line);
-
-	return 0;
-}
-
-int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
+int hist_entry__annotate(struct hist_entry *he, struct list_head *head,
 			 size_t privsize)
 {
-	struct symbol *sym = self->ms.sym;
-	struct map *map = self->ms.map;
-	struct dso *dso = map->dso;
-	char *filename = dso__build_id_filename(dso, NULL, 0);
-	bool free_filename = true;
-	char command[PATH_MAX * 2];
-	FILE *file;
-	int err = 0;
-	u64 len;
-	char symfs_filename[PATH_MAX];
-
-	if (filename) {
-		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
-			 symbol_conf.symfs, filename);
-	}
-
-	if (filename == NULL) {
-		if (dso->has_build_id) {
-			pr_err("Can't annotate %s: not enough memory\n",
-			       sym->name);
-			return -ENOMEM;
-		}
-		goto fallback;
-	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
-		   strstr(command, "[kernel.kallsyms]") ||
-		   access(symfs_filename, R_OK)) {
-		free(filename);
-fallback:
-		/*
-		 * If we don't have build-ids or the build-id file isn't in the
-		 * cache, or is just a kallsyms file, well, lets hope that this
-		 * DSO is the same as when 'perf record' ran.
-		 */
-		filename = dso->long_name;
-		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
-			 symbol_conf.symfs, filename);
-		free_filename = false;
-	}
-
-	if (dso->origin == DSO__ORIG_KERNEL) {
-		if (dso->annotate_warned)
-			goto out_free_filename;
-		err = -ENOENT;
-		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file was found in the "
-		       "path\n", sym->name);
-		goto out_free_filename;
-	}
-
-	pr_debug("%s: filename=%s, sym=%s, start=%#" PRIx64 ", end=%#" PRIx64 "\n", __func__,
-		 filename, sym->name, map->unmap_ip(map, sym->start),
-		 map->unmap_ip(map, sym->end));
-
-	len = sym->end - sym->start;
-
-	pr_debug("annotating [%p] %30s : [%p] %30s\n",
-		 dso, dso->long_name, sym, sym->name);
-
-	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016" PRIx64 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
-		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end),
-		 symfs_filename, filename);
-
-	pr_debug("Executing: %s\n", command);
-
-	file = popen(command, "r");
-	if (!file)
-		goto out_free_filename;
-
-	while (!feof(file))
-		if (hist_entry__parse_objdump_line(self, file, head, privsize) < 0)
-			break;
-
-	pclose(file);
-out_free_filename:
-	if (free_filename)
-		free(filename);
-	return err;
+	return symbol__annotate(he->ms.sym, he->ms.map, head, privsize);
 }
 
 void hists__inc_nr_events(struct hists *self, u32 type)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 889559b..8a201f7 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -9,33 +9,6 @@ extern struct callchain_param callchain_param;
 struct hist_entry;
 struct addr_location;
 struct symbol;
-struct rb_root;
-
-struct objdump_line {
-	struct list_head node;
-	s64		 offset;
-	char		 *line;
-};
-
-void objdump_line__free(struct objdump_line *self);
-struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
-					       struct objdump_line *pos);
-
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
 
 /*
  * The kernel collects the number of events it couldn't send in a stretch and
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 82b78f9..daa7138 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -1,9 +1,11 @@
 #include "../browser.h"
 #include "../helpline.h"
 #include "../libslang.h"
+#include "../../annotate.h"
 #include "../../hist.h"
 #include "../../sort.h"
 #include "../../symbol.h"
+#include "../../annotate.h"
 
 static void ui__error_window(const char *fmt, ...)
 {
@@ -66,24 +68,26 @@ static double objdump_line__calc_percent(struct objdump_line *self,
 	if (self->offset != -1) {
 		int len = sym->end - sym->start;
 		unsigned int hits = 0;
-		struct sym_priv *priv = symbol__priv(sym);
-		struct sym_ext *sym_ext = priv->ext;
-		struct sym_hist *h = priv->hist;
+		struct annotation *notes = symbol__annotation(sym);
+		struct source_line *src_line = notes->src_line;
+		struct sym_hist *h = notes->histogram;
 		s64 offset = self->offset;
 		struct objdump_line *next = objdump__get_next_ip_line(head, self);
 
-
 		while (offset < (s64)len &&
 		       (next == NULL || offset < next->offset)) {
-			if (sym_ext) {
-				percent += sym_ext[offset].percent;
+			if (src_line) {
+				percent += src_line[offset].percent;
 			} else
-				hits += h->ip[offset];
+				hits += h->addr[offset];
 
 			++offset;
 		}
-
-		if (sym_ext == NULL && h->sum)
+		/*
+ 		 * If the percentage wasn't already calculated in
+ 		 * symbol__get_source_line, do it now:
+ 		 */
+		if (src_line == NULL && h->sum)
 			percent = 100.0 * hits / h->sum;
 	}
 
@@ -136,10 +140,10 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 static int annotate_browser__run(struct annotate_browser *self)
 {
 	struct rb_node *nd;
-	struct hist_entry *he = self->b.priv;
+	struct symbol *sym = self->b.priv;
 	int key;
 
-	if (ui_browser__show(&self->b, he->ms.sym->name,
+	if (ui_browser__show(&self->b, sym->name,
 			     "<-, -> or ESC: exit, TAB/shift+TAB: cycle thru samples") < 0)
 		return -1;
 	/*
@@ -179,7 +183,12 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *self)
+int hist_entry__tui_annotate(struct hist_entry *he)
+{
+	return symbol__tui_annotate(he->ms.sym, he->ms.map);
+}
+
+int symbol__tui_annotate(struct symbol *sym, struct map *map)
 {
 	struct objdump_line *pos, *n;
 	struct objdump_line_rb_node *rbpos;
@@ -190,18 +199,18 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
-			.priv	 = self,
+			.priv	 = sym,
 		},
 	};
 	int ret;
 
-	if (self->ms.sym == NULL)
+	if (sym == NULL)
 		return -1;
 
-	if (self->ms.map->dso->annotate_warned)
+	if (map->dso->annotate_warned)
 		return -1;
 
-	if (hist_entry__annotate(self, &head, sizeof(*rbpos)) < 0) {
+	if (symbol__annotate(sym, map, &head, sizeof(*rbpos)) < 0) {
 		ui__error_window(ui_helpline__last_msg);
 		return -1;
 	}
@@ -214,7 +223,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 			browser.b.width = line_len;
 		rbpos = objdump_line__rb(pos);
 		rbpos->idx = browser.b.nr_entries++;
-		rbpos->percent = objdump_line__calc_percent(pos, &head, self->ms.sym);
+		rbpos->percent = objdump_line__calc_percent(pos, &head, sym);
 		if (rbpos->percent < 0.01)
 			continue;
 		objdump__insert_line(&browser.entries, rbpos);
-- 
1.6.2.5

