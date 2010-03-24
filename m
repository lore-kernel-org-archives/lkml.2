Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0CXTlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:41:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0CXTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:40:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 4/6] perf tools: Introduce struct map_symbol
Date: Wed, 24 Mar 2010 16:40:17 -0300
Message-Id: <1269459619-982-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269459619-982-1-git-send-email-acme@infradead.org>
References: <1269459619-982-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That will be in both struct hist_entry and struct callchain_list, so
that the TUI can store a pointer to the pair (map, symbol) in the trees
where hist_entries and callchain_lists are present, to allow precise
annotation instead of looking for the first symbol with the selected
name.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   34 +++++++++++++++++-----------------
 tools/perf/util/hist.c        |    8 +++++---
 tools/perf/util/newt.c        |    4 ++--
 tools/perf/util/sort.c        |   22 +++++++++++-----------
 tools/perf/util/sort.h        |    3 +--
 tools/perf/util/symbol.h      |    5 +++++
 6 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index ce9b1ef..887e8e0 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -69,13 +69,13 @@ static int sym__alloc_hist(struct symbol *self)
 static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
-	struct symbol *sym = he->sym;
+	struct symbol *sym = he->ms.sym;
 	struct sym_priv *priv;
 	struct sym_hist *h;
 
 	he->count++;
 
-	if (!sym || !he->map)
+	if (!sym || !he->ms.map)
 		return 0;
 
 	priv = symbol__priv(sym);
@@ -85,7 +85,7 @@ static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 	sym_size = sym->end - sym->start;
 	offset = ip - sym->start;
 
-	pr_debug3("%s: ip=%#Lx\n", __func__, he->map->unmap_ip(he->map, ip));
+	pr_debug3("%s: ip=%#Lx\n", __func__, he->ms.map->unmap_ip(he->ms.map, ip));
 
 	if (offset >= sym_size)
 		return 0;
@@ -94,8 +94,8 @@ static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 	h->sum++;
 	h->ip[offset]++;
 
-	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", he->sym->start,
-		  he->sym->name, ip, ip - he->sym->start, h->ip[offset]);
+	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", he->ms.sym->start,
+		  he->ms.sym->name, ip, ip - he->ms.sym->start, h->ip[offset]);
 	return 0;
 }
 
@@ -187,7 +187,7 @@ static struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 static int parse_line(FILE *file, struct hist_entry *he,
 		      struct list_head *head)
 {
-	struct symbol *sym = he->sym;
+	struct symbol *sym = he->ms.sym;
 	struct objdump_line *objdump_line;
 	char *line = NULL, *tmp, *tmp2;
 	size_t line_len;
@@ -226,7 +226,7 @@ static int parse_line(FILE *file, struct hist_entry *he,
 	}
 
 	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(he->map, sym->start);
+		u64 start = map__rip_2objdump(he->ms.map, sym->start);
 		offset = line_ip - start;
 	}
 
@@ -244,7 +244,7 @@ static int objdump_line__print(struct objdump_line *self,
 			       struct list_head *head,
 			       struct hist_entry *he, u64 len)
 {
-	struct symbol *sym = he->sym;
+	struct symbol *sym = he->ms.sym;
 	static const char *prev_line;
 	static const char *prev_color;
 
@@ -327,7 +327,7 @@ static void insert_source_line(struct sym_ext *sym_ext)
 
 static void free_source_line(struct hist_entry *he, int len)
 {
-	struct sym_priv *priv = symbol__priv(he->sym);
+	struct sym_priv *priv = symbol__priv(he->ms.sym);
 	struct sym_ext *sym_ext = priv->ext;
 	int i;
 
@@ -346,7 +346,7 @@ static void free_source_line(struct hist_entry *he, int len)
 static void
 get_source_line(struct hist_entry *he, int len, const char *filename)
 {
-	struct symbol *sym = he->sym;
+	struct symbol *sym = he->ms.sym;
 	u64 start;
 	int i;
 	char cmd[PATH_MAX * 2];
@@ -361,7 +361,7 @@ get_source_line(struct hist_entry *he, int len, const char *filename)
 	if (!priv->ext)
 		return;
 
-	start = he->map->unmap_ip(he->map, sym->start);
+	start = he->ms.map->unmap_ip(he->ms.map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
@@ -425,7 +425,7 @@ static void print_summary(const char *filename)
 
 static void hist_entry__print_hits(struct hist_entry *self)
 {
-	struct symbol *sym = self->sym;
+	struct symbol *sym = self->ms.sym;
 	struct sym_priv *priv = symbol__priv(sym);
 	struct sym_hist *h = priv->hist;
 	u64 len = sym->end - sym->start, offset;
@@ -439,9 +439,9 @@ static void hist_entry__print_hits(struct hist_entry *self)
 
 static void annotate_sym(struct hist_entry *he)
 {
-	struct map *map = he->map;
+	struct map *map = he->ms.map;
 	struct dso *dso = map->dso;
-	struct symbol *sym = he->sym;
+	struct symbol *sym = he->ms.sym;
 	const char *filename = dso->long_name, *d_filename;
 	u64 len;
 	char command[PATH_MAX*2];
@@ -526,17 +526,17 @@ static void perf_session__find_annotations(struct perf_session *self)
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
-		if (he->sym == NULL)
+		if (he->ms.sym == NULL)
 			continue;
 
-		priv = symbol__priv(he->sym);
+		priv = symbol__priv(he->ms.sym);
 		if (priv->hist == NULL)
 			continue;
 
 		annotate_sym(he);
 		/*
 		 * Since we have a hist_entry per IP for the same symbol, free
-		 * he->sym->hist to signal we already processed this symbol.
+		 * he->ms.sym->hist to signal we already processed this symbol.
 		 */
 		free(priv->hist);
 		priv->hist = NULL;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5843a9c..4eefb52 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -22,8 +22,10 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 	struct hist_entry *he;
 	struct hist_entry entry = {
 		.thread	= al->thread,
-		.map	= al->map,
-		.sym	= al->sym,
+		.ms = {
+			.map	= al->map,
+			.sym	= al->sym,
+		},
 		.ip	= al->addr,
 		.level	= al->level,
 		.count	= count,
@@ -654,7 +656,7 @@ print_entries:
 		if (symbol_conf.use_callchain)
 			ret += hist_entry__fprintf_callchain(h, fp, session_total);
 
-		if (h->map == NULL && verbose > 1) {
+		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, fp);
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index a3465a0..25cd2e1 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -287,9 +287,9 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 
 		indexes[0] = NEWT_ARG_APPEND;
 		indexes[1] = NEWT_ARG_LAST;
-		newt_checkbox_tree__add(tree, s, self->sym, indexes);
+		newt_checkbox_tree__add(tree, s, self->ms.sym, indexes);
 	} else
-		newtListboxAppendEntry(tree, s, self->sym);
+		newtListboxAppendEntry(tree, s, self->ms.sym);
 
 	return strlen(s);
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cb0f327..9b80c13 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -131,8 +131,8 @@ sort__comm_print(FILE *fp, struct hist_entry *self, unsigned int width)
 int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct dso *dso_l = left->map ? left->map->dso : NULL;
-	struct dso *dso_r = right->map ? right->map->dso : NULL;
+	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
+	struct dso *dso_r = right->ms.map ? right->ms.map->dso : NULL;
 	const char *dso_name_l, *dso_name_r;
 
 	if (!dso_l || !dso_r)
@@ -152,9 +152,9 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 size_t
 sort__dso_print(FILE *fp, struct hist_entry *self, unsigned int width)
 {
-	if (self->map && self->map->dso) {
-		const char *dso_name = !verbose ? self->map->dso->short_name :
-						  self->map->dso->long_name;
+	if (self->ms.map && self->ms.map->dso) {
+		const char *dso_name = !verbose ? self->ms.map->dso->short_name :
+						  self->ms.map->dso->long_name;
 		return repsep_fprintf(fp, "%-*s", width, dso_name);
 	}
 
@@ -168,11 +168,11 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	u64 ip_l, ip_r;
 
-	if (left->sym == right->sym)
+	if (left->ms.sym == right->ms.sym)
 		return 0;
 
-	ip_l = left->sym ? left->sym->start : left->ip;
-	ip_r = right->sym ? right->sym->start : right->ip;
+	ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
+	ip_r = right->ms.sym ? right->ms.sym->start : right->ip;
 
 	return (int64_t)(ip_r - ip_l);
 }
@@ -184,13 +184,13 @@ sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 	size_t ret = 0;
 
 	if (verbose) {
-		char o = self->map ? dso__symtab_origin(self->map->dso) : '!';
+		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
 		ret += repsep_fprintf(fp, "%#018llx %c ", (u64)self->ip, o);
 	}
 
 	ret += repsep_fprintf(fp, "[%c] ", self->level);
-	if (self->sym)
-		ret += repsep_fprintf(fp, "%s", self->sym->name);
+	if (self->ms.sym)
+		ret += repsep_fprintf(fp, "%s", self->ms.sym->name);
 	else
 		ret += repsep_fprintf(fp, "%#016llx", (u64)self->ip);
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 753f9ea..5985686 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -45,8 +45,7 @@ struct hist_entry {
 	struct rb_node		rb_node;
 	u64			count;
 	struct thread		*thread;
-	struct map		*map;
-	struct symbol		*sym;
+	struct map_symbol	ms;
 	u64			ip;
 	char			level;
 	struct symbol	  *parent;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 0da2455..a4a894b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -88,6 +88,11 @@ struct ref_reloc_sym {
 	u64		unrelocated_addr;
 };
 
+struct map_symbol {
+	struct map    *map;
+	struct symbol *sym;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
-- 
1.6.2.5

