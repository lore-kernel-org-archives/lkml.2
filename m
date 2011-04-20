Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1DTQYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:24:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1DTQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/6] perf symbols: Give more useful names to 'self' parameters
Date: Wed, 20 Apr 2011 13:23:51 -0300
Message-Id: <1303316636-11923-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

One more installment on an area that is mostly dormant.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |  629 +++++++++++++++++++++++-----------------------
 tools/perf/util/symbol.h |   78 +++---
 2 files changed, 361 insertions(+), 346 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f06c10f..516876d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -31,13 +31,13 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
+static bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
 static int elf_read_build_id(Elf *elf, void *bf, size_t size);
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 			symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
@@ -49,27 +49,27 @@ struct symbol_conf symbol_conf = {
 	.symfs            = "",
 };
 
-int dso__name_len(const struct dso *self)
+int dso__name_len(const struct dso *dso)
 {
 	if (verbose)
-		return self->long_name_len;
+		return dso->long_name_len;
 
-	return self->short_name_len;
+	return dso->short_name_len;
 }
 
-bool dso__loaded(const struct dso *self, enum map_type type)
+bool dso__loaded(const struct dso *dso, enum map_type type)
 {
-	return self->loaded & (1 << type);
+	return dso->loaded & (1 << type);
 }
 
-bool dso__sorted_by_name(const struct dso *self, enum map_type type)
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type)
 {
-	return self->sorted_by_name & (1 << type);
+	return dso->sorted_by_name & (1 << type);
 }
 
-static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
+static void dso__set_sorted_by_name(struct dso *dso, enum map_type type)
 {
-	self->sorted_by_name |= (1 << type);
+	dso->sorted_by_name |= (1 << type);
 }
 
 bool symbol_type__is_a(char symbol_type, enum map_type map_type)
@@ -84,9 +84,9 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 	}
 }
 
-static void symbols__fixup_end(struct rb_root *self)
+static void symbols__fixup_end(struct rb_root *symbols)
 {
-	struct rb_node *nd, *prevnd = rb_first(self);
+	struct rb_node *nd, *prevnd = rb_first(symbols);
 	struct symbol *curr, *prev;
 
 	if (prevnd == NULL)
@@ -107,10 +107,10 @@ static void symbols__fixup_end(struct rb_root *self)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
+static void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 {
 	struct map *prev, *curr;
-	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
+	struct rb_node *nd, *prevnd = rb_first(&mg->maps[type]);
 
 	if (prevnd == NULL)
 		return;
@@ -130,128 +130,128 @@ static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
 	curr->end = ~0ULL;
 }
 
-static void map_groups__fixup_end(struct map_groups *self)
+static void map_groups__fixup_end(struct map_groups *mg)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__map_groups__fixup_end(self, i);
+		__map_groups__fixup_end(mg, i);
 }
 
 static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
 				  const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = calloc(1, (symbol_conf.priv_size +
-					 sizeof(*self) + namelen));
-	if (self == NULL)
+	struct symbol *sym = calloc(1, (symbol_conf.priv_size +
+					sizeof(*sym) + namelen));
+	if (sym == NULL)
 		return NULL;
 
 	if (symbol_conf.priv_size)
-		self = ((void *)self) + symbol_conf.priv_size;
-
-	self->start   = start;
-	self->end     = len ? start + len - 1 : start;
-	self->binding = binding;
-	self->namelen = namelen - 1;
+		sym = ((void *)sym) + symbol_conf.priv_size;
 
-	pr_debug4("%s: %s %#" PRIx64 "-%#" PRIx64 "\n", __func__, name, start, self->end);
+	sym->start   = start;
+	sym->end     = len ? start + len - 1 : start;
+	sym->binding = binding;
+	sym->namelen = namelen - 1;
 
-	memcpy(self->name, name, namelen);
+	pr_debug4("%s: %s %#" PRIx64 "-%#" PRIx64 "\n",
+		  __func__, name, start, sym->end);
+	memcpy(sym->name, name, namelen);
 
-	return self;
+	return sym;
 }
 
-void symbol__delete(struct symbol *self)
+void symbol__delete(struct symbol *sym)
 {
-	free(((void *)self) - symbol_conf.priv_size);
+	free(((void *)sym) - symbol_conf.priv_size);
 }
 
-static size_t symbol__fprintf(struct symbol *self, FILE *fp)
+static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 {
 	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %c %s\n",
-		       self->start, self->end,
-		       self->binding == STB_GLOBAL ? 'g' :
-		       self->binding == STB_LOCAL  ? 'l' : 'w',
-		       self->name);
+		       sym->start, sym->end,
+		       sym->binding == STB_GLOBAL ? 'g' :
+		       sym->binding == STB_LOCAL  ? 'l' : 'w',
+		       sym->name);
 }
 
-void dso__set_long_name(struct dso *self, char *name)
+void dso__set_long_name(struct dso *dso, char *name)
 {
 	if (name == NULL)
 		return;
-	self->long_name = name;
-	self->long_name_len = strlen(name);
+	dso->long_name = name;
+	dso->long_name_len = strlen(name);
 }
 
-static void dso__set_short_name(struct dso *self, const char *name)
+static void dso__set_short_name(struct dso *dso, const char *name)
 {
 	if (name == NULL)
 		return;
-	self->short_name = name;
-	self->short_name_len = strlen(name);
+	dso->short_name = name;
+	dso->short_name_len = strlen(name);
 }
 
-static void dso__set_basename(struct dso *self)
+static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(self, basename(self->long_name));
+	dso__set_short_name(dso, basename(dso->long_name));
 }
 
 struct dso *dso__new(const char *name)
 {
-	struct dso *self = calloc(1, sizeof(*self) + strlen(name) + 1);
+	struct dso *dso = calloc(1, sizeof(*dso) + strlen(name) + 1);
 
-	if (self != NULL) {
+	if (dso != NULL) {
 		int i;
-		strcpy(self->name, name);
-		dso__set_long_name(self, self->name);
-		dso__set_short_name(self, self->name);
+		strcpy(dso->name, name);
+		dso__set_long_name(dso, dso->name);
+		dso__set_short_name(dso, dso->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
-			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->symtab_type = SYMTAB__NOT_FOUND;
-		self->loaded = 0;
-		self->sorted_by_name = 0;
-		self->has_build_id = 0;
-		self->kernel = DSO_TYPE_USER;
-		INIT_LIST_HEAD(&self->node);
+			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
+		dso->symtab_type = SYMTAB__NOT_FOUND;
+		dso->loaded = 0;
+		dso->sorted_by_name = 0;
+		dso->has_build_id = 0;
+		dso->kernel = DSO_TYPE_USER;
+		INIT_LIST_HEAD(&dso->node);
 	}
 
-	return self;
+	return dso;
 }
 
-static void symbols__delete(struct rb_root *self)
+static void symbols__delete(struct rb_root *symbols)
 {
 	struct symbol *pos;
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(symbols);
 
 	while (next) {
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, symbols);
 		symbol__delete(pos);
 	}
 }
 
-void dso__delete(struct dso *self)
+void dso__delete(struct dso *dso)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		symbols__delete(&self->symbols[i]);
-	if (self->sname_alloc)
-		free((char *)self->short_name);
-	if (self->lname_alloc)
-		free(self->long_name);
-	free(self);
+		symbols__delete(&dso->symbols[i]);
+	if (dso->sname_alloc)
+		free((char *)dso->short_name);
+	if (dso->lname_alloc)
+		free(dso->long_name);
+	free(dso);
 }
 
-void dso__set_build_id(struct dso *self, void *build_id)
+void dso__set_build_id(struct dso *dso, void *build_id)
 {
-	memcpy(self->build_id, build_id, sizeof(self->build_id));
-	self->has_build_id = 1;
+	memcpy(dso->build_id, build_id, sizeof(dso->build_id));
+	dso->has_build_id = 1;
 }
 
-static void symbols__insert(struct rb_root *self, struct symbol *sym)
+static void symbols__insert(struct rb_root *symbols, struct symbol *sym)
 {
-	struct rb_node **p = &self->rb_node;
+	struct rb_node **p = &symbols->rb_node;
 	struct rb_node *parent = NULL;
 	const u64 ip = sym->start;
 	struct symbol *s;
@@ -265,17 +265,17 @@ static void symbols__insert(struct rb_root *self, struct symbol *sym)
 			p = &(*p)->rb_right;
 	}
 	rb_link_node(&sym->rb_node, parent, p);
-	rb_insert_color(&sym->rb_node, self);
+	rb_insert_color(&sym->rb_node, symbols);
 }
 
-static struct symbol *symbols__find(struct rb_root *self, u64 ip)
+static struct symbol *symbols__find(struct rb_root *symbols, u64 ip)
 {
 	struct rb_node *n;
 
-	if (self == NULL)
+	if (symbols == NULL)
 		return NULL;
 
-	n = self->rb_node;
+	n = symbols->rb_node;
 
 	while (n) {
 		struct symbol *s = rb_entry(n, struct symbol, rb_node);
@@ -296,9 +296,9 @@ struct symbol_name_rb_node {
 	struct symbol	sym;
 };
 
-static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
+static void symbols__insert_by_name(struct rb_root *symbols, struct symbol *sym)
 {
-	struct rb_node **p = &self->rb_node;
+	struct rb_node **p = &symbols->rb_node;
 	struct rb_node *parent = NULL;
 	struct symbol_name_rb_node *symn, *s;
 
@@ -313,27 +313,29 @@ static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
 			p = &(*p)->rb_right;
 	}
 	rb_link_node(&symn->rb_node, parent, p);
-	rb_insert_color(&symn->rb_node, self);
+	rb_insert_color(&symn->rb_node, symbols);
 }
 
-static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
+static void symbols__sort_by_name(struct rb_root *symbols,
+				  struct rb_root *source)
 {
 	struct rb_node *nd;
 
 	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		symbols__insert_by_name(self, pos);
+		symbols__insert_by_name(symbols, pos);
 	}
 }
 
-static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
+static struct symbol *symbols__find_by_name(struct rb_root *symbols,
+					    const char *name)
 {
 	struct rb_node *n;
 
-	if (self == NULL)
+	if (symbols == NULL)
 		return NULL;
 
-	n = self->rb_node;
+	n = symbols->rb_node;
 
 	while (n) {
 		struct symbol_name_rb_node *s;
@@ -353,29 +355,29 @@ static struct symbol *symbols__find_by_name(struct rb_root *self, const char *na
 	return NULL;
 }
 
-struct symbol *dso__find_symbol(struct dso *self,
+struct symbol *dso__find_symbol(struct dso *dso,
 				enum map_type type, u64 addr)
 {
-	return symbols__find(&self->symbols[type], addr);
+	return symbols__find(&dso->symbols[type], addr);
 }
 
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name)
 {
-	return symbols__find_by_name(&self->symbol_names[type], name);
+	return symbols__find_by_name(&dso->symbol_names[type], name);
 }
 
-void dso__sort_by_name(struct dso *self, enum map_type type)
+void dso__sort_by_name(struct dso *dso, enum map_type type)
 {
-	dso__set_sorted_by_name(self, type);
-	return symbols__sort_by_name(&self->symbol_names[type],
-				     &self->symbols[type]);
+	dso__set_sorted_by_name(dso, type);
+	return symbols__sort_by_name(&dso->symbol_names[type],
+				     &dso->symbols[type]);
 }
 
-int build_id__sprintf(const u8 *self, int len, char *bf)
+int build_id__sprintf(const u8 *build_id, int len, char *bf)
 {
 	char *bid = bf;
-	const u8 *raw = self;
+	const u8 *raw = build_id;
 	int i;
 
 	for (i = 0; i < len; ++i) {
@@ -384,24 +386,25 @@ int build_id__sprintf(const u8 *self, int len, char *bf)
 		bid += 2;
 	}
 
-	return raw - self;
+	return raw - build_id;
 }
 
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp)
 {
 	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
-	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
 	return fprintf(fp, "%s", sbuild_id);
 }
 
-size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp)
+size_t dso__fprintf_symbols_by_name(struct dso *dso,
+				    enum map_type type, FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 	struct symbol_name_rb_node *pos;
 
-	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&dso->symbol_names[type]); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
 		fprintf(fp, "%s\n", pos->sym.name);
 	}
@@ -409,18 +412,18 @@ size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *
 	return ret;
 }
 
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
 {
 	struct rb_node *nd;
-	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
+	size_t ret = fprintf(fp, "dso: %s (", dso->short_name);
 
-	if (self->short_name != self->long_name)
-		ret += fprintf(fp, "%s, ", self->long_name);
+	if (dso->short_name != dso->long_name)
+		ret += fprintf(fp, "%s, ", dso->long_name);
 	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       self->loaded ? "" : "NOT ");
-	ret += dso__fprintf_buildid(self, fp);
+		       dso->loaded ? "" : "NOT ");
+	ret += dso__fprintf_buildid(dso, fp);
 	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 		ret += symbol__fprintf(pos, fp);
 	}
@@ -543,10 +546,10 @@ static int map__process_kallsym_symbol(void *arg, const char *name,
  * so that we can in the next step set the symbol ->end address and then
  * call kernel_maps__split_kallsyms.
  */
-static int dso__load_all_kallsyms(struct dso *self, const char *filename,
+static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
 				  struct map *map)
 {
-	struct process_kallsyms_args args = { .map = map, .dso = self, };
+	struct process_kallsyms_args args = { .map = map, .dso = dso, };
 	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
 }
 
@@ -555,7 +558,7 @@ static int dso__load_all_kallsyms(struct dso *self, const char *filename,
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *self, struct map *map,
+static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			       symbol_filter_t filter)
 {
 	struct map_groups *kmaps = map__kmap(map)->kmaps;
@@ -563,7 +566,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct map *curr_map = map;
 	struct symbol *pos;
 	int count = 0, moved = 0;	
-	struct rb_root *root = &self->symbols[map->type];
+	struct rb_root *root = &dso->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
 
@@ -582,7 +585,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 			if (strcmp(curr_map->dso->short_name, module)) {
 				if (curr_map != map &&
-				    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+				    dso->kernel == DSO_TYPE_GUEST_KERNEL &&
 				    machine__is_default_guest(machine)) {
 					/*
 					 * We assume all symbols of a module are
@@ -618,14 +621,14 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			pos->end   = curr_map->map_ip(curr_map, pos->end);
 		} else if (curr_map != map) {
 			char dso_name[PATH_MAX];
-			struct dso *dso;
+			struct dso *ndso;
 
 			if (count == 0) {
 				curr_map = map;
 				goto filter_symbol;
 			}
 
-			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+			if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
 					kernel_range++);
@@ -634,15 +637,15 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 					"[kernel].%d",
 					kernel_range++);
 
-			dso = dso__new(dso_name);
-			if (dso == NULL)
+			ndso = dso__new(dso_name);
+			if (ndso == NULL)
 				return -1;
 
-			dso->kernel = self->kernel;
+			ndso->kernel = dso->kernel;
 
-			curr_map = map__new2(pos->start, dso, map->type);
+			curr_map = map__new2(pos->start, ndso, map->type);
 			if (curr_map == NULL) {
-				dso__delete(dso);
+				dso__delete(ndso);
 				return -1;
 			}
 
@@ -665,7 +668,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	}
 
 	if (curr_map != map &&
-	    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+	    dso->kernel == DSO_TYPE_GUEST_KERNEL &&
 	    machine__is_default_guest(kmaps->machine)) {
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
@@ -673,21 +676,21 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count + moved;
 }
 
-int dso__load_kallsyms(struct dso *self, const char *filename,
+int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
-	if (dso__load_all_kallsyms(self, filename, map) < 0)
+	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
-	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		self->symtab_type = SYMTAB__GUEST_KALLSYMS;
+	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		dso->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else
-		self->symtab_type = SYMTAB__KALLSYMS;
+		dso->symtab_type = SYMTAB__KALLSYMS;
 
-	return dso__split_kallsyms(self, map, filter);
+	return dso__split_kallsyms(dso, map, filter);
 }
 
-static int dso__load_perf_map(struct dso *self, struct map *map,
+static int dso__load_perf_map(struct dso *dso, struct map *map,
 			      symbol_filter_t filter)
 {
 	char *line = NULL;
@@ -695,7 +698,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 	FILE *file;
 	int nr_syms = 0;
 
-	file = fopen(self->long_name, "r");
+	file = fopen(dso->long_name, "r");
 	if (file == NULL)
 		goto out_failure;
 
@@ -733,7 +736,7 @@ static int dso__load_perf_map(struct dso *self, struct map *map,
 		if (filter && filter(map, sym))
 			symbol__delete(sym);
 		else {
-			symbols__insert(&self->symbols[map->type], sym);
+			symbols__insert(&dso->symbols[map->type], sym);
 			nr_syms++;
 		}
 	}
@@ -752,7 +755,7 @@ out_failure:
 /**
  * elf_symtab__for_each_symbol - iterate thru all the symbols
  *
- * @self: struct elf_symtab instance to iterate
+ * @syms: struct elf_symtab instance to iterate
  * @idx: uint32_t idx
  * @sym: GElf_Sym iterator
  */
@@ -852,7 +855,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
+static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 				       symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
@@ -871,7 +874,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 	char name[PATH_MAX];
 
 	snprintf(name, sizeof(name), "%s%s",
-		 symbol_conf.symfs, self->long_name);
+		 symbol_conf.symfs, dso->long_name);
 	fd = open(name, O_RDONLY);
 	if (fd < 0)
 		goto out;
@@ -947,7 +950,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->symbols[map->type], f);
+				symbols__insert(&dso->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -969,7 +972,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 			if (filter && filter(map, f))
 				symbol__delete(f);
 			else {
-				symbols__insert(&self->symbols[map->type], f);
+				symbols__insert(&dso->symbols[map->type], f);
 				++nr;
 			}
 		}
@@ -985,29 +988,30 @@ out_close:
 		return nr;
 out:
 	pr_debug("%s: problems reading %s PLT info.\n",
-		 __func__, self->long_name);
+		 __func__, dso->long_name);
 	return 0;
 }
 
-static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
+static bool elf_sym__is_a(GElf_Sym *sym, enum map_type type)
 {
 	switch (type) {
 	case MAP__FUNCTION:
-		return elf_sym__is_function(self);
+		return elf_sym__is_function(sym);
 	case MAP__VARIABLE:
-		return elf_sym__is_object(self);
+		return elf_sym__is_object(sym);
 	default:
 		return false;
 	}
 }
 
-static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
+static bool elf_sec__is_a(GElf_Shdr *shdr, Elf_Data *secstrs,
+			  enum map_type type)
 {
 	switch (type) {
 	case MAP__FUNCTION:
-		return elf_sec__is_text(self, secstrs);
+		return elf_sec__is_text(shdr, secstrs);
 	case MAP__VARIABLE:
-		return elf_sec__is_data(self, secstrs);
+		return elf_sec__is_data(shdr, secstrs);
 	default:
 		return false;
 	}
@@ -1032,13 +1036,13 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
-static int dso__load_sym(struct dso *self, struct map *map, const char *name,
+static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule,
 			 int want_symtab)
 {
-	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
+	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
-	struct dso *curr_dso = self;
+	struct dso *curr_dso = dso;
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
@@ -1064,14 +1068,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	}
 
 	/* Always reject images with a mismatched build-id: */
-	if (self->has_build_id) {
+	if (dso->has_build_id) {
 		u8 build_id[BUILD_ID_SIZE];
 
 		if (elf_read_build_id(elf, build_id,
 				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
 			goto out_elf_end;
 
-		if (!dso__build_id_equal(self, build_id))
+		if (!dso__build_id_equal(dso, build_id))
 			goto out_elf_end;
 	}
 
@@ -1112,13 +1116,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (self->kernel == DSO_TYPE_USER) {
-		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+	if (dso->kernel == DSO_TYPE_USER) {
+		dso->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
-	} else self->adjust_symbols = 0;
-
+	} else {
+		dso->adjust_symbols = 0;
+	}
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name = elf_sym__name(&sym, symstrs);
@@ -1168,22 +1173,22 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		    (sym.st_value & 1))
 			--sym.st_value;
 
-		if (self->kernel != DSO_TYPE_USER || kmodule) {
+		if (dso->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
 				   (curr_dso->short_name +
-				    self->short_name_len)) == 0)
+				    dso->short_name_len)) == 0)
 				goto new_symbol;
 
 			if (strcmp(section_name, ".text") == 0) {
 				curr_map = map;
-				curr_dso = self;
+				curr_dso = dso;
 				goto new_symbol;
 			}
 
 			snprintf(dso_name, sizeof(dso_name),
-				 "%s%s", self->short_name, section_name);
+				 "%s%s", dso->short_name, section_name);
 
 			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
 			if (curr_map == NULL) {
@@ -1195,9 +1200,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				curr_dso = dso__new(dso_name);
 				if (curr_dso == NULL)
 					goto out_elf_end;
-				curr_dso->kernel = self->kernel;
-				curr_dso->long_name = self->long_name;
-				curr_dso->long_name_len = self->long_name_len;
+				curr_dso->kernel = dso->kernel;
+				curr_dso->long_name = dso->long_name;
+				curr_dso->long_name_len = dso->long_name_len;
 				curr_map = map__new2(start, curr_dso,
 						     map->type);
 				if (curr_map == NULL) {
@@ -1206,9 +1211,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				}
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->symtab_type = self->symtab_type;
+				curr_dso->symtab_type = dso->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&self->node, curr_dso);
+				dsos__add(&dso->node, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
@@ -1250,7 +1255,7 @@ new_symbol:
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
 	if (nr > 0) {
-		symbols__fixup_end(&self->symbols[map->type]);
+		symbols__fixup_end(&dso->symbols[map->type]);
 		if (kmap) {
 			/*
 			 * We need to fixup this here too because we create new
@@ -1266,9 +1271,9 @@ out_close:
 	return err;
 }
 
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
+static bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
 {
-	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
+	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
 }
 
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
@@ -1429,7 +1434,7 @@ out:
 	return err;
 }
 
-char dso__symtab_origin(const struct dso *self)
+char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
 		[SYMTAB__KALLSYMS]	      = 'k',
@@ -1444,12 +1449,12 @@ char dso__symtab_origin(const struct dso *self)
 		[SYMTAB__GUEST_KMODULE]	      =  'G',
 	};
 
-	if (self == NULL || self->symtab_type == SYMTAB__NOT_FOUND)
+	if (dso == NULL || dso->symtab_type == SYMTAB__NOT_FOUND)
 		return '!';
-	return origin[self->symtab_type];
+	return origin[dso->symtab_type];
 }
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
+int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
@@ -1459,12 +1464,12 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	const char *root_dir;
 	int want_symtab;
 
-	dso__set_loaded(self, map->type);
+	dso__set_loaded(dso, map->type);
 
-	if (self->kernel == DSO_TYPE_KERNEL)
-		return dso__load_kernel_sym(self, map, filter);
-	else if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		return dso__load_guest_kernel_sym(self, map, filter);
+	if (dso->kernel == DSO_TYPE_KERNEL)
+		return dso__load_kernel_sym(dso, map, filter);
+	else if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		return dso__load_guest_kernel_sym(dso, map, filter);
 
 	if (map->groups && map->groups->machine)
 		machine = map->groups->machine;
@@ -1475,11 +1480,11 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	if (!name)
 		return -1;
 
-	self->adjust_symbols = 0;
+	dso->adjust_symbols = 0;
 
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
-		ret = dso__load_perf_map(self, map, filter);
-		self->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
+	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
+		ret = dso__load_perf_map(dso, map, filter);
+		dso->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
 					      SYMTAB__NOT_FOUND;
 		return ret;
 	}
@@ -1490,33 +1495,33 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 */
 	want_symtab = 1;
 restart:
-	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE;
-	     self->symtab_type != SYMTAB__NOT_FOUND;
-	     self->symtab_type++) {
-		switch (self->symtab_type) {
+	for (dso->symtab_type = SYMTAB__BUILD_ID_CACHE;
+	     dso->symtab_type != SYMTAB__NOT_FOUND;
+	     dso->symtab_type++) {
+		switch (dso->symtab_type) {
 		case SYMTAB__BUILD_ID_CACHE:
 			/* skip the locally configured cache if a symfs is given */
 			if (symbol_conf.symfs[0] ||
-			    (dso__build_id_filename(self, name, size) == NULL)) {
+			    (dso__build_id_filename(dso, name, size) == NULL)) {
 				continue;
 			}
 			break;
 		case SYMTAB__FEDORA_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s.debug",
-				 symbol_conf.symfs, self->long_name);
+				 symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__UBUNTU_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s",
-				 symbol_conf.symfs, self->long_name);
+				 symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__BUILDID_DEBUGINFO: {
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
-			if (!self->has_build_id)
+			if (!dso->has_build_id)
 				continue;
 
-			build_id__sprintf(self->build_id,
-					  sizeof(self->build_id),
+			build_id__sprintf(dso->build_id,
+					  sizeof(dso->build_id),
 					  build_id_hex);
 			snprintf(name, size,
 				 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
@@ -1525,7 +1530,7 @@ restart:
 			break;
 		case SYMTAB__SYSTEM_PATH_DSO:
 			snprintf(name, size, "%s%s",
-			     symbol_conf.symfs, self->long_name);
+			     symbol_conf.symfs, dso->long_name);
 			break;
 		case SYMTAB__GUEST_KMODULE:
 			if (map->groups && machine)
@@ -1533,12 +1538,12 @@ restart:
 			else
 				root_dir = "";
 			snprintf(name, size, "%s%s%s", symbol_conf.symfs,
-				 root_dir, self->long_name);
+				 root_dir, dso->long_name);
 			break;
 
 		case SYMTAB__SYSTEM_PATH_KMODULE:
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
-				 self->long_name);
+				 dso->long_name);
 			break;
 		default:;
 		}
@@ -1548,7 +1553,7 @@ restart:
 		if (fd < 0)
 			continue;
 
-		ret = dso__load_sym(self, map, name, fd, filter, 0,
+		ret = dso__load_sym(dso, map, name, fd, filter, 0,
 				    want_symtab);
 		close(fd);
 
@@ -1560,7 +1565,8 @@ restart:
 			continue;
 
 		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
+			int nr_plt = dso__synthesize_plt_symbols(dso, map,
+								 filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
 			break;
@@ -1577,17 +1583,17 @@ restart:
 	}
 
 	free(name);
-	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+	if (ret < 0 && strstr(dso->name, " (deleted)") != NULL)
 		return 0;
 	return ret;
 }
 
-struct map *map_groups__find_by_name(struct map_groups *self,
+struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *map = rb_entry(nd, struct map, rb_node);
 
 		if (map->dso && strcmp(map->dso->short_name, name) == 0)
@@ -1597,28 +1603,28 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	return NULL;
 }
 
-static int dso__kernel_module_get_build_id(struct dso *self,
-				const char *root_dir)
+static int dso__kernel_module_get_build_id(struct dso *dso,
+					   const char *root_dir)
 {
 	char filename[PATH_MAX];
 	/*
 	 * kernel module short names are of the form "[module]" and
 	 * we need just "module" here.
 	 */
-	const char *name = self->short_name + 1;
+	const char *name = dso->short_name + 1;
 
 	snprintf(filename, sizeof(filename),
 		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
 		 root_dir, (int)strlen(name) - 1, name);
 
-	if (sysfs__read_build_id(filename, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
+	if (sysfs__read_build_id(filename, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
 
 	return 0;
 }
 
-static int map_groups__set_modules_path_dir(struct map_groups *self,
+static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				const char *dir_name)
 {
 	struct dirent *dent;
@@ -1646,7 +1652,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dir_name, dent->d_name);
-			ret = map_groups__set_modules_path_dir(self, path);
+			ret = map_groups__set_modules_path_dir(mg, path);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -1661,7 +1667,8 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(self, MAP__FUNCTION, dso_name);
+			map = map_groups__find_by_name(mg, MAP__FUNCTION,
+						       dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1711,20 +1718,20 @@ static char *get_kernel_version(const char *root_dir)
 	return strdup(name);
 }
 
-static int machine__set_modules_path(struct machine *self)
+static int machine__set_modules_path(struct machine *machine)
 {
 	char *version;
 	char modules_path[PATH_MAX];
 
-	version = get_kernel_version(self->root_dir);
+	version = get_kernel_version(machine->root_dir);
 	if (!version)
 		return -1;
 
 	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
-		 self->root_dir, version);
+		 machine->root_dir, version);
 	free(version);
 
-	return map_groups__set_modules_path_dir(&self->kmaps, modules_path);
+	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
 }
 
 /*
@@ -1734,23 +1741,23 @@ static int machine__set_modules_path(struct machine *self)
  */
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
-	struct map *self = calloc(1, (sizeof(*self) +
-				      (dso->kernel ? sizeof(struct kmap) : 0)));
-	if (self != NULL) {
+	struct map *map = calloc(1, (sizeof(*map) +
+				     (dso->kernel ? sizeof(struct kmap) : 0)));
+	if (map != NULL) {
 		/*
 		 * ->end will be filled after we load all the symbols
 		 */
-		map__init(self, type, start, 0, 0, dso);
+		map__init(map, type, start, 0, 0, dso);
 	}
 
-	return self;
+	return map;
 }
 
-struct map *machine__new_module(struct machine *self, u64 start,
+struct map *machine__new_module(struct machine *machine, u64 start,
 				const char *filename)
 {
 	struct map *map;
-	struct dso *dso = __dsos__findnew(&self->kernel_dsos, filename);
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
 
 	if (dso == NULL)
 		return NULL;
@@ -1759,15 +1766,15 @@ struct map *machine__new_module(struct machine *self, u64 start,
 	if (map == NULL)
 		return NULL;
 
-	if (machine__is_host(self))
+	if (machine__is_host(machine))
 		dso->symtab_type = SYMTAB__SYSTEM_PATH_KMODULE;
 	else
 		dso->symtab_type = SYMTAB__GUEST_KMODULE;
-	map_groups__insert(&self->kmaps, map);
+	map_groups__insert(&machine->kmaps, map);
 	return map;
 }
 
-static int machine__create_modules(struct machine *self)
+static int machine__create_modules(struct machine *machine)
 {
 	char *line = NULL;
 	size_t n;
@@ -1776,10 +1783,10 @@ static int machine__create_modules(struct machine *self)
 	const char *modules;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(self))
+	if (machine__is_default_guest(machine))
 		modules = symbol_conf.default_guest_modules;
 	else {
-		sprintf(path, "%s/proc/modules", self->root_dir);
+		sprintf(path, "%s/proc/modules", machine->root_dir);
 		modules = path;
 	}
 
@@ -1815,16 +1822,16 @@ static int machine__create_modules(struct machine *self)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		map = machine__new_module(self, start, name);
+		map = machine__new_module(machine, start, name);
 		if (map == NULL)
 			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, self->root_dir);
+		dso__kernel_module_get_build_id(map->dso, machine->root_dir);
 	}
 
 	free(line);
 	fclose(file);
 
-	return machine__set_modules_path(self);
+	return machine__set_modules_path(machine);
 
 out_delete_line:
 	free(line);
@@ -1832,7 +1839,7 @@ out_failure:
 	return -1;
 }
 
-int dso__load_vmlinux(struct dso *self, struct map *map,
+int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1844,9 +1851,9 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	if (fd < 0)
 		return -1;
 
-	dso__set_long_name(self, (char *)vmlinux);
-	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
+	dso__set_long_name(dso, (char *)vmlinux);
+	dso__set_loaded(dso, map->type);
+	err = dso__load_sym(dso, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
 
 	if (err > 0)
@@ -1855,7 +1862,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	return err;
 }
 
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
+int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
@@ -1864,20 +1871,20 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 		 vmlinux_path__nr_entries + 1);
 
-	filename = dso__build_id_filename(self, NULL, 0);
+	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
-		err = dso__load_vmlinux(self, map, filename, filter);
+		err = dso__load_vmlinux(dso, map, filename, filter);
 		if (err > 0) {
-			dso__set_long_name(self, filename);
+			dso__set_long_name(dso, filename);
 			goto out;
 		}
 		free(filename);
 	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
+		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
-			dso__set_long_name(self, strdup(vmlinux_path[i]));
+			dso__set_long_name(dso, strdup(vmlinux_path[i]));
 			break;
 		}
 	}
@@ -1885,7 +1892,7 @@ out:
 	return err;
 }
 
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
+static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter)
 {
 	int err;
@@ -1912,10 +1919,10 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 	if (symbol_conf.vmlinux_name != NULL) {
-		err = dso__load_vmlinux(self, map,
+		err = dso__load_vmlinux(dso, map,
 					symbol_conf.vmlinux_name, filter);
 		if (err > 0) {
-			dso__set_long_name(self,
+			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
 			goto out_fixup;
 		}
@@ -1923,7 +1930,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 	if (vmlinux_path != NULL) {
-		err = dso__load_vmlinux_path(self, map, filter);
+		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
 			goto out_fixup;
 	}
@@ -1937,13 +1944,13 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 * we have a build-id, so check if it is the same as the running kernel,
 	 * using it if it is.
 	 */
-	if (self->has_build_id) {
+	if (dso->has_build_id) {
 		u8 kallsyms_build_id[BUILD_ID_SIZE];
 		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
 		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
 					 sizeof(kallsyms_build_id)) == 0) {
-			if (dso__build_id_equal(self, kallsyms_build_id)) {
+			if (dso__build_id_equal(dso, kallsyms_build_id)) {
 				kallsyms_filename = "/proc/kallsyms";
 				goto do_kallsyms;
 			}
@@ -1952,7 +1959,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		 * Now look if we have it on the build-id cache in
 		 * $HOME/.debug/[kernel.kallsyms].
 		 */
-		build_id__sprintf(self->build_id, sizeof(self->build_id),
+		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
 				  sbuild_id);
 
 		if (asprintf(&kallsyms_allocated_filename,
@@ -1979,7 +1986,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	}
 
 do_kallsyms:
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
@@ -1987,7 +1994,7 @@ do_kallsyms:
 	if (err > 0) {
 out_fixup:
 		if (kallsyms_filename != NULL)
-			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
+			dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1995,8 +2002,8 @@ out_fixup:
 	return err;
 }
 
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter)
+static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
+				      symbol_filter_t filter)
 {
 	int err;
 	const char *kallsyms_filename = NULL;
@@ -2016,7 +2023,7 @@ static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
 		 * Or use file guest_kallsyms inputted by user on commandline
 		 */
 		if (symbol_conf.default_guest_vmlinux_name != NULL) {
-			err = dso__load_vmlinux(self, map,
+			err = dso__load_vmlinux(dso, map,
 				symbol_conf.default_guest_vmlinux_name, filter);
 			goto out_try_fixup;
 		}
@@ -2029,7 +2036,7 @@ static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
 		kallsyms_filename = path;
 	}
 
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 
@@ -2037,7 +2044,7 @@ out_try_fixup:
 	if (err > 0) {
 		if (kallsyms_filename != NULL) {
 			machine__mmap_name(machine, path, sizeof(path));
-			dso__set_long_name(self, strdup(path));
+			dso__set_long_name(dso, strdup(path));
 		}
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -2090,12 +2097,12 @@ size_t __dsos__fprintf(struct list_head *head, FILE *fp)
 	return ret;
 }
 
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp)
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
 		ret += __dsos__fprintf(&pos->user_dsos, fp);
@@ -2119,18 +2126,20 @@ static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
 	return ret;
 }
 
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
+size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
+				     bool with_hits)
 {
-	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
-	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
+	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, with_hits) +
+	       __dsos__fprintf_buildid(&machine->user_dsos, fp, with_hits);
 }
 
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
+				      FILE *fp, bool with_hits)
 {
 	struct rb_node *nd;
 	size_t ret = 0;
 
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
 		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
 	}
@@ -2139,59 +2148,59 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_
 
 struct dso *dso__new_kernel(const char *name)
 {
-	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
+	struct dso *dso = dso__new(name ?: "[kernel.kallsyms]");
 
-	if (self != NULL) {
-		dso__set_short_name(self, "[kernel]");
-		self->kernel = DSO_TYPE_KERNEL;
+	if (dso != NULL) {
+		dso__set_short_name(dso, "[kernel]");
+		dso->kernel = DSO_TYPE_KERNEL;
 	}
 
-	return self;
+	return dso;
 }
 
 static struct dso *dso__new_guest_kernel(struct machine *machine,
 					const char *name)
 {
 	char bf[PATH_MAX];
-	struct dso *self = dso__new(name ?: machine__mmap_name(machine, bf, sizeof(bf)));
-
-	if (self != NULL) {
-		dso__set_short_name(self, "[guest.kernel]");
-		self->kernel = DSO_TYPE_GUEST_KERNEL;
+	struct dso *dso = dso__new(name ?: machine__mmap_name(machine, bf,
+							      sizeof(bf)));
+	if (dso != NULL) {
+		dso__set_short_name(dso, "[guest.kernel]");
+		dso->kernel = DSO_TYPE_GUEST_KERNEL;
 	}
 
-	return self;
+	return dso;
 }
 
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine)
+void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 {
 	char path[PATH_MAX];
 
 	if (machine__is_default_guest(machine))
 		return;
 	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
-	if (sysfs__read_build_id(path, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
+	if (sysfs__read_build_id(path, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
 }
 
-static struct dso *machine__create_kernel(struct machine *self)
+static struct dso *machine__create_kernel(struct machine *machine)
 {
 	const char *vmlinux_name = NULL;
 	struct dso *kernel;
 
-	if (machine__is_host(self)) {
+	if (machine__is_host(machine)) {
 		vmlinux_name = symbol_conf.vmlinux_name;
 		kernel = dso__new_kernel(vmlinux_name);
 	} else {
-		if (machine__is_default_guest(self))
+		if (machine__is_default_guest(machine))
 			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(self, vmlinux_name);
+		kernel = dso__new_guest_kernel(machine, vmlinux_name);
 	}
 
 	if (kernel != NULL) {
-		dso__read_running_kernel_build_id(kernel, self);
-		dsos__add(&self->kernel_dsos, kernel);
+		dso__read_running_kernel_build_id(kernel, machine);
+		dsos__add(&machine->kernel_dsos, kernel);
 	}
 	return kernel;
 }
@@ -2236,41 +2245,43 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 	return args.start;
 }
 
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
 {
 	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(self);
+	u64 start = machine__get_kernel_start_addr(machine);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		self->vmlinux_maps[type] = map__new2(start, kernel, type);
-		if (self->vmlinux_maps[type] == NULL)
+		machine->vmlinux_maps[type] = map__new2(start, kernel, type);
+		if (machine->vmlinux_maps[type] == NULL)
 			return -1;
 
-		self->vmlinux_maps[type]->map_ip =
-			self->vmlinux_maps[type]->unmap_ip = identity__map_ip;
-
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		kmap->kmaps = &self->kmaps;
-		map_groups__insert(&self->kmaps, self->vmlinux_maps[type]);
+		machine->vmlinux_maps[type]->map_ip =
+			machine->vmlinux_maps[type]->unmap_ip =
+				identity__map_ip;
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		kmap->kmaps = &machine->kmaps;
+		map_groups__insert(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
 	}
 
 	return 0;
 }
 
-void machine__destroy_kernel_maps(struct machine *self)
+void machine__destroy_kernel_maps(struct machine *machine)
 {
 	enum map_type type;
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		if (self->vmlinux_maps[type] == NULL)
+		if (machine->vmlinux_maps[type] == NULL)
 			continue;
 
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		map_groups__remove(&self->kmaps, self->vmlinux_maps[type]);
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		map_groups__remove(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
 		if (kmap->ref_reloc_sym) {
 			/*
 			 * ref_reloc_sym is shared among all maps, so free just
@@ -2284,25 +2295,25 @@ void machine__destroy_kernel_maps(struct machine *self)
 			kmap->ref_reloc_sym = NULL;
 		}
 
-		map__delete(self->vmlinux_maps[type]);
-		self->vmlinux_maps[type] = NULL;
+		map__delete(machine->vmlinux_maps[type]);
+		machine->vmlinux_maps[type] = NULL;
 	}
 }
 
-int machine__create_kernel_maps(struct machine *self)
+int machine__create_kernel_maps(struct machine *machine)
 {
-	struct dso *kernel = machine__create_kernel(self);
+	struct dso *kernel = machine__create_kernel(machine);
 
 	if (kernel == NULL ||
-	    __machine__create_kernel_maps(self, kernel) < 0)
+	    __machine__create_kernel_maps(machine, kernel) < 0)
 		return -1;
 
-	if (symbol_conf.use_modules && machine__create_modules(self) < 0)
+	if (symbol_conf.use_modules && machine__create_modules(machine) < 0)
 		pr_debug("Problems creating module maps, continuing anyway...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	map_groups__fixup_end(&self->kmaps);
+	map_groups__fixup_end(&machine->kmaps);
 	return 0;
 }
 
@@ -2366,11 +2377,11 @@ out_fail:
 	return -1;
 }
 
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp)
 {
 	int i;
 	size_t printed = 0;
-	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
+	struct dso *kdso = machine->vmlinux_maps[MAP__FUNCTION]->dso;
 
 	if (kdso->has_build_id) {
 		char filename[PATH_MAX];
@@ -2467,9 +2478,9 @@ void symbol__exit(void)
 	symbol_conf.initialized = false;
 }
 
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
 {
-	struct machine *machine = machines__findnew(self, pid);
+	struct machine *machine = machines__findnew(machines, pid);
 
 	if (machine == NULL)
 		return -1;
@@ -2520,7 +2531,7 @@ char *strxfrchar(char *s, char from, char to)
 	return s;
 }
 
-int machines__create_guest_kernel_maps(struct rb_root *self)
+int machines__create_guest_kernel_maps(struct rb_root *machines)
 {
 	int ret = 0;
 	struct dirent **namelist = NULL;
@@ -2531,7 +2542,7 @@ int machines__create_guest_kernel_maps(struct rb_root *self)
 	if (symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_modules ||
 	    symbol_conf.default_guest_kallsyms) {
-		machines__create_kernel_maps(self, DEFAULT_GUEST_KERNEL_ID);
+		machines__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
 	}
 
 	if (symbol_conf.guestmount) {
@@ -2552,7 +2563,7 @@ int machines__create_guest_kernel_maps(struct rb_root *self)
 				pr_debug("Can't access file %s\n", path);
 				goto failure;
 			}
-			machines__create_kernel_maps(self, pid);
+			machines__create_kernel_maps(machines, pid);
 		}
 failure:
 		free(namelist);
@@ -2561,23 +2572,23 @@ failure:
 	return ret;
 }
 
-void machines__destroy_guest_kernel_maps(struct rb_root *self)
+void machines__destroy_guest_kernel_maps(struct rb_root *machines)
 {
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(machines);
 
 	while (next) {
 		struct machine *pos = rb_entry(next, struct machine, rb_node);
 
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, machines);
 		machine__delete(pos);
 	}
 }
 
-int machine__load_kallsyms(struct machine *self, const char *filename,
+int machine__load_kallsyms(struct machine *machine, const char *filename,
 			   enum map_type type, symbol_filter_t filter)
 {
-	struct map *map = self->vmlinux_maps[type];
+	struct map *map = machine->vmlinux_maps[type];
 	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
 
 	if (ret > 0) {
@@ -2587,16 +2598,16 @@ int machine__load_kallsyms(struct machine *self, const char *filename,
 		 * kernel, with modules between them, fixup the end of all
 		 * sections.
 		 */
-		__map_groups__fixup_end(&self->kmaps, type);
+		__map_groups__fixup_end(&machine->kmaps, type);
 	}
 
 	return ret;
 }
 
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter)
 {
-	struct map *map = self->vmlinux_maps[type];
+	struct map *map = machine->vmlinux_maps[type];
 	int ret = dso__load_vmlinux_path(map->dso, map, filter);
 
 	if (ret > 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 713b0b4..242de01 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -62,7 +62,7 @@ struct symbol {
 	char		name[0];
 };
 
-void symbol__delete(struct symbol *self);
+void symbol__delete(struct symbol *sym);
 
 struct strlist;
 
@@ -96,9 +96,9 @@ struct symbol_conf {
 
 extern struct symbol_conf symbol_conf;
 
-static inline void *symbol__priv(struct symbol *self)
+static inline void *symbol__priv(struct symbol *sym)
 {
-	return ((void *)self) - symbol_conf.priv_size;
+	return ((void *)sym) - symbol_conf.priv_size;
 }
 
 struct ref_reloc_sym {
@@ -155,43 +155,45 @@ struct dso {
 
 struct dso *dso__new(const char *name);
 struct dso *dso__new_kernel(const char *name);
-void dso__delete(struct dso *self);
+void dso__delete(struct dso *dso);
 
-int dso__name_len(const struct dso *self);
+int dso__name_len(const struct dso *dso);
 
-bool dso__loaded(const struct dso *self, enum map_type type);
-bool dso__sorted_by_name(const struct dso *self, enum map_type type);
+bool dso__loaded(const struct dso *dso, enum map_type type);
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type);
 
-static inline void dso__set_loaded(struct dso *self, enum map_type type)
+static inline void dso__set_loaded(struct dso *dso, enum map_type type)
 {
-	self->loaded |= (1 << type);
+	dso->loaded |= (1 << type);
 }
 
-void dso__sort_by_name(struct dso *self, enum map_type type);
+void dso__sort_by_name(struct dso *dso, enum map_type type);
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
-int dso__load_vmlinux(struct dso *self, struct map *map,
+int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
+int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter);
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
+int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter);
-int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
+int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
 		       symbol_filter_t filter);
-int machine__load_kallsyms(struct machine *self, const char *filename,
+int machine__load_kallsyms(struct machine *machine, const char *filename,
 			   enum map_type type, symbol_filter_t filter);
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter);
 
 size_t __dsos__fprintf(struct list_head *head, FILE *fp);
 
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
-
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
-size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp);
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
+size_t machine__fprintf_dsos_buildid(struct machine *machine,
+				     FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
+				      FILE *fp, bool with_hits);
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
+size_t dso__fprintf_symbols_by_name(struct dso *dso,
+				    enum map_type type, FILE *fp);
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
 
 enum symtab_type {
 	SYMTAB__KALLSYMS = 0,
@@ -207,34 +209,36 @@ enum symtab_type {
 	SYMTAB__NOT_FOUND,
 };
 
-char dso__symtab_origin(const struct dso *self);
-void dso__set_long_name(struct dso *self, char *name);
-void dso__set_build_id(struct dso *self, void *build_id);
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+char dso__symtab_origin(const struct dso *dso);
+void dso__set_long_name(struct dso *dso, char *name);
+void dso__set_build_id(struct dso *dso, void *build_id);
+void dso__read_running_kernel_build_id(struct dso *dso,
+				       struct machine *machine);
+struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
+				u64 addr);
+struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 					const char *name);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
-int build_id__sprintf(const u8 *self, int len, char *bf);
+int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start, u64 end));
 
-void machine__destroy_kernel_maps(struct machine *self);
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
-int machine__create_kernel_maps(struct machine *self);
+void machine__destroy_kernel_maps(struct machine *machine);
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
+int machine__create_kernel_maps(struct machine *machine);
 
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
-int machines__create_guest_kernel_maps(struct rb_root *self);
-void machines__destroy_guest_kernel_maps(struct rb_root *self);
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid);
+int machines__create_guest_kernel_maps(struct rb_root *machines);
+void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 
 int symbol__init(void);
 void symbol__exit(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
 #endif /* __PERF_SYMBOL */
-- 
1.6.2.5

