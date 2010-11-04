Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0KDPlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:41:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42035 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KDPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:58 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 16/20] perf: Export map.ch and symbol.ch
Date: Thu,  4 Nov 2010 16:36:52 +0100
Message-Id: <1288885016-18295-17-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those suck in a bunch of other stuff. Put objects shared between
perf/util/ and lib/perf/ in lib/perf/config.ch for now, will go in
lib/perf/shared.ch later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/util.h                    |    2 +
 tools/lib/perf/Makefile                |    4 +
 tools/lib/perf/config.c                |    3 +
 tools/lib/perf/config.h                |    1 +
 tools/lib/perf/map.c                   |  682 +++++++++
 tools/lib/perf/map.h                   |  229 +++
 tools/lib/perf/symbol.c                | 2466 ++++++++++++++++++++++++++++++++
 tools/lib/perf/symbol.h                |  233 +++
 tools/perf/Makefile                    |    4 -
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-buildid-cache.c     |    3 +-
 tools/perf/builtin-buildid-list.c      |    2 +-
 tools/perf/builtin-diff.c              |    2 +-
 tools/perf/builtin-inject.c            |    2 +-
 tools/perf/builtin-kmem.c              |    2 +-
 tools/perf/builtin-kvm.c               |    2 +-
 tools/perf/builtin-lock.c              |    2 +-
 tools/perf/builtin-probe.c             |    3 +-
 tools/perf/builtin-record.c            |    2 +-
 tools/perf/builtin-report.c            |    2 +-
 tools/perf/builtin-sched.c             |    2 +-
 tools/perf/builtin-stat.c              |    1 +
 tools/perf/builtin-test.c              |    2 +-
 tools/perf/builtin-timechart.c         |    2 +-
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/builtin-trace.c             |    2 +-
 tools/perf/util/build-id.c             |    2 +-
 tools/perf/util/build-id.h             |    2 -
 tools/perf/util/callchain.h            |    2 +-
 tools/perf/util/debug.c                |    2 +-
 tools/perf/util/debug.h                |    1 -
 tools/perf/util/event.h                |    2 +-
 tools/perf/util/header.c               |    2 +-
 tools/perf/util/hist.h                 |    1 +
 tools/perf/util/map.c                  |  682 ---------
 tools/perf/util/map.h                  |  229 ---
 tools/perf/util/parse-events.c         |    2 +-
 tools/perf/util/probe-event.c          |    2 +-
 tools/perf/util/probe-finder.c         |    2 +-
 tools/perf/util/session.h              |    2 +-
 tools/perf/util/sort.h                 |    2 +-
 tools/perf/util/symbol.c               | 2459 -------------------------------
 tools/perf/util/symbol.h               |  231 ---
 tools/perf/util/thread.c               |    1 +
 tools/perf/util/thread.h               |    2 +-
 tools/perf/util/ui/browsers/annotate.c |    2 +-
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 tools/perf/util/ui/browsers/map.c      |    4 +-
 48 files changed, 3656 insertions(+), 3639 deletions(-)
 create mode 100644 tools/lib/perf/map.c
 create mode 100644 tools/lib/perf/map.h
 create mode 100644 tools/lib/perf/symbol.c
 create mode 100644 tools/lib/perf/symbol.h
 delete mode 100644 tools/perf/util/map.c
 delete mode 100644 tools/perf/util/map.h
 delete mode 100644 tools/perf/util/symbol.c
 delete mode 100644 tools/perf/util/symbol.h

diff --git a/tools/lib/lk/util.h b/tools/lib/lk/util.h
index f380fed..23f3e61 100644
--- a/tools/lib/lk/util.h
+++ b/tools/lib/lk/util.h
@@ -40,7 +40,9 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE 1
+#endif
 #define _BSD_SOURCE 1
 #define HAS_BOOL
 
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 7709a46..8b4d9c0 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -8,11 +8,15 @@ LIB_H += mmap.h
 LIB_H += util.h
 LIB_H += color.h
 LIB_H += config.h
+LIB_H += map.h
+LIB_H += symbol.h
 
 LIB_OBJS += mmap.o
 LIB_OBJS += color.o
 LIB_OBJS += config.o
 LIB_OBJS += path.o
+LIB_OBJS += map.o
+LIB_OBJS += symbol.o
 
 LIBFILE = $(LIB_OUTPUT)lkperflib.a
 
diff --git a/tools/lib/perf/config.c b/tools/lib/perf/config.c
index bb72a55..f56646f 100644
--- a/tools/lib/perf/config.c
+++ b/tools/lib/perf/config.c
@@ -18,6 +18,9 @@ int pager_use_color = 1;
 
 char buildid_dir[MAXPATHLEN]; /* root dir for buildid, binary cache */
 
+/* debug.c */
+int verbose = 0;
+
 static FILE *config_file;
 static const char *config_file_name;
 static int config_linenr;
diff --git a/tools/lib/perf/config.h b/tools/lib/perf/config.h
index 5ef9c1d..edcb8ee 100644
--- a/tools/lib/perf/config.h
+++ b/tools/lib/perf/config.h
@@ -7,6 +7,7 @@
 #include <lk/util.h>
 
 extern int spawned_pager;
+extern int verbose;
 
 typedef int (*config_fn_t)(const char *, const char *, void *);
 extern int perf_default_config(const char *, const char *, void *);
diff --git a/tools/lib/perf/map.c b/tools/lib/perf/map.c
new file mode 100644
index 0000000..3a7eb6e
--- /dev/null
+++ b/tools/lib/perf/map.c
@@ -0,0 +1,682 @@
+#include "symbol.h"
+#include <errno.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+#include "map.h"
+
+const char *map_type__name[MAP__NR_TYPES] = {
+	[MAP__FUNCTION] = "Functions",
+	[MAP__VARIABLE] = "Variables",
+};
+
+static inline int is_anon_memory(const char *filename)
+{
+	return strcmp(filename, "//anon") == 0;
+}
+
+void map__init(struct map *self, enum map_type type,
+	       u64 start, u64 end, u64 pgoff, struct dso *dso)
+{
+	self->type     = type;
+	self->start    = start;
+	self->end      = end;
+	self->pgoff    = pgoff;
+	self->dso      = dso;
+	self->map_ip   = map__map_ip;
+	self->unmap_ip = map__unmap_ip;
+	RB_CLEAR_NODE(&self->rb_node);
+	self->groups   = NULL;
+	self->referenced = false;
+}
+
+struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+		     u64 pgoff, u32 pid, char *filename,
+		     enum map_type type)
+{
+	struct map *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		char newfilename[PATH_MAX];
+		struct dso *dso;
+		int anon;
+
+		anon = is_anon_memory(filename);
+
+		if (anon) {
+			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
+			filename = newfilename;
+		}
+
+		dso = __dsos__findnew(dsos__list, filename);
+		if (dso == NULL)
+			goto out_delete;
+
+		map__init(self, type, start, start + len, pgoff, dso);
+
+		if (anon) {
+set_identity:
+			self->map_ip = self->unmap_ip = identity__map_ip;
+		} else if (strcmp(filename, "[vdso]") == 0) {
+			dso__set_loaded(dso, self->type);
+			goto set_identity;
+		}
+	}
+	return self;
+out_delete:
+	free(self);
+	return NULL;
+}
+
+void map__delete(struct map *self)
+{
+	free(self);
+}
+
+void map__fixup_start(struct map *self)
+{
+	struct rb_root *symbols = &self->dso->symbols[self->type];
+	struct rb_node *nd = rb_first(symbols);
+	if (nd != NULL) {
+		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		self->start = sym->start;
+	}
+}
+
+void map__fixup_end(struct map *self)
+{
+	struct rb_root *symbols = &self->dso->symbols[self->type];
+	struct rb_node *nd = rb_last(symbols);
+	if (nd != NULL) {
+		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
+		self->end = sym->end;
+	}
+}
+
+#define DSO__DELETED "(deleted)"
+
+int map__load(struct map *self, symbol_filter_t filter)
+{
+	const char *name = self->dso->long_name;
+	int nr;
+
+	if (dso__loaded(self->dso, self->type))
+		return 0;
+
+	nr = dso__load(self->dso, self, filter);
+	if (nr < 0) {
+		if (self->dso->has_build_id) {
+			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+			build_id__sprintf(self->dso->build_id,
+					  sizeof(self->dso->build_id),
+					  sbuild_id);
+			pr_warning("%s with build id %s not found",
+				   name, sbuild_id);
+		} else
+			pr_warning("Failed to open %s", name);
+
+		pr_warning(", continuing without symbols\n");
+		return -1;
+	} else if (nr == 0) {
+		const size_t len = strlen(name);
+		const size_t real_len = len - sizeof(DSO__DELETED);
+
+		if (len > sizeof(DSO__DELETED) &&
+		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
+			pr_warning("%.*s was updated, restart the long "
+				   "running apps that use it!\n",
+				   (int)real_len, name);
+		} else {
+			pr_warning("no symbols found in %s, maybe install "
+				   "a debug package?\n", name);
+		}
+
+		return -1;
+	}
+	/*
+	 * Only applies to the kernel, as its symtabs aren't relative like the
+	 * module ones.
+	 */
+	if (self->dso->kernel)
+		map__reloc_vmlinux(self);
+
+	return 0;
+}
+
+struct symbol *map__find_symbol(struct map *self, u64 addr,
+				symbol_filter_t filter)
+{
+	if (map__load(self, filter) < 0)
+		return NULL;
+
+	return dso__find_symbol(self->dso, self->type, addr);
+}
+
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter)
+{
+	if (map__load(self, filter) < 0)
+		return NULL;
+
+	if (!dso__sorted_by_name(self->dso, self->type))
+		dso__sort_by_name(self->dso, self->type);
+
+	return dso__find_symbol_by_name(self->dso, self->type, name);
+}
+
+struct map *map__clone(struct map *self)
+{
+	struct map *map = malloc(sizeof(*self));
+
+	if (!map)
+		return NULL;
+
+	memcpy(map, self, sizeof(*self));
+
+	return map;
+}
+
+int map__overlap(struct map *l, struct map *r)
+{
+	if (l->start > r->start) {
+		struct map *t = l;
+		l = r;
+		r = t;
+	}
+
+	if (l->end > r->start)
+		return 1;
+
+	return 0;
+}
+
+size_t map__fprintf(struct map *self, FILE *fp)
+{
+	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
+		       self->start, self->end, self->pgoff, self->dso->name);
+}
+
+/*
+ * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
+ * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
+ */
+u64 map__rip_2objdump(struct map *map, u64 rip)
+{
+	u64 addr = map->dso->adjust_symbols ?
+			map->unmap_ip(map, rip) :	/* RIP -> IP */
+			rip;
+	return addr;
+}
+
+u64 map__objdump_2ip(struct map *map, u64 addr)
+{
+	u64 ip = map->dso->adjust_symbols ?
+			addr :
+			map->unmap_ip(map, addr);	/* RIP -> IP */
+	return ip;
+}
+
+void map_groups__init(struct map_groups *self)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		self->maps[i] = RB_ROOT;
+		INIT_LIST_HEAD(&self->removed_maps[i]);
+	}
+	self->machine = NULL;
+}
+
+static void maps__delete(struct rb_root *self)
+{
+	struct rb_node *next = rb_first(self);
+
+	while (next) {
+		struct map *pos = rb_entry(next, struct map, rb_node);
+
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, self);
+		map__delete(pos);
+	}
+}
+
+static void maps__delete_removed(struct list_head *self)
+{
+	struct map *pos, *n;
+
+	list_for_each_entry_safe(pos, n, self, node) {
+		list_del(&pos->node);
+		map__delete(pos);
+	}
+}
+
+void map_groups__exit(struct map_groups *self)
+{
+	int i;
+
+	for (i = 0; i < MAP__NR_TYPES; ++i) {
+		maps__delete(&self->maps[i]);
+		maps__delete_removed(&self->removed_maps[i]);
+	}
+}
+
+void map_groups__flush(struct map_groups *self)
+{
+	int type;
+
+	for (type = 0; type < MAP__NR_TYPES; type++) {
+		struct rb_root *root = &self->maps[type];
+		struct rb_node *next = rb_first(root);
+
+		while (next) {
+			struct map *pos = rb_entry(next, struct map, rb_node);
+			next = rb_next(&pos->rb_node);
+			rb_erase(&pos->rb_node, root);
+			/*
+			 * We may have references to this map, for
+			 * instance in some hist_entry instances, so
+			 * just move them to a separate list.
+			 */
+			list_add_tail(&pos->node, &self->removed_maps[pos->type]);
+		}
+	}
+}
+
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       struct map **mapp,
+				       symbol_filter_t filter)
+{
+	struct map *map = map_groups__find(self, type, addr);
+
+	if (map != NULL) {
+		if (mapp != NULL)
+			*mapp = map;
+		return map__find_symbol(map, map->map_ip(map, addr), filter);
+	}
+
+	return NULL;
+}
+
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+					       enum map_type type,
+					       const char *name,
+					       struct map **mapp,
+					       symbol_filter_t filter)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
+
+		if (sym == NULL)
+			continue;
+		if (mapp != NULL)
+			*mapp = pos;
+		return sym;
+	}
+
+	return NULL;
+}
+
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, int verbose, FILE *fp)
+{
+	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+		printed += fprintf(fp, "Map:");
+		printed += map__fprintf(pos, fp);
+		if (verbose > 2) {
+			printed += dso__fprintf(pos->dso, type, fp);
+			printed += fprintf(fp, "--\n");
+		}
+	}
+
+	return printed;
+}
+
+size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp)
+{
+	size_t printed = 0, i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		printed += __map_groups__fprintf_maps(self, i, verbose, fp);
+	return printed;
+}
+
+static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
+						 enum map_type type,
+						 int verbose, FILE *fp)
+{
+	struct map *pos;
+	size_t printed = 0;
+
+	list_for_each_entry(pos, &self->removed_maps[type], node) {
+		printed += fprintf(fp, "Map:");
+		printed += map__fprintf(pos, fp);
+		if (verbose > 1) {
+			printed += dso__fprintf(pos->dso, type, fp);
+			printed += fprintf(fp, "--\n");
+		}
+	}
+	return printed;
+}
+
+static size_t map_groups__fprintf_removed_maps(struct map_groups *self,
+					       int verbose, FILE *fp)
+{
+	size_t printed = 0, i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		printed += __map_groups__fprintf_removed_maps(self, i, verbose, fp);
+	return printed;
+}
+
+size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp)
+{
+	size_t printed = map_groups__fprintf_maps(self, verbose, fp);
+	printed += fprintf(fp, "Removed maps:\n");
+	return printed + map_groups__fprintf_removed_maps(self, verbose, fp);
+}
+
+int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+				   int verbose, FILE *fp)
+{
+	struct rb_root *root = &self->maps[map->type];
+	struct rb_node *next = rb_first(root);
+	int err = 0;
+
+	while (next) {
+		struct map *pos = rb_entry(next, struct map, rb_node);
+		next = rb_next(&pos->rb_node);
+
+		if (!map__overlap(pos, map))
+			continue;
+
+		if (verbose >= 2) {
+			fputs("overlapping maps:\n", fp);
+			map__fprintf(map, fp);
+			map__fprintf(pos, fp);
+		}
+
+		rb_erase(&pos->rb_node, root);
+		/*
+		 * Now check if we need to create new maps for areas not
+		 * overlapped by the new map:
+		 */
+		if (map->start > pos->start) {
+			struct map *before = map__clone(pos);
+
+			if (before == NULL) {
+				err = -ENOMEM;
+				goto move_map;
+			}
+
+			before->end = map->start - 1;
+			map_groups__insert(self, before);
+			if (verbose >= 2)
+				map__fprintf(before, fp);
+		}
+
+		if (map->end < pos->end) {
+			struct map *after = map__clone(pos);
+
+			if (after == NULL) {
+				err = -ENOMEM;
+				goto move_map;
+			}
+
+			after->start = map->end + 1;
+			map_groups__insert(self, after);
+			if (verbose >= 2)
+				map__fprintf(after, fp);
+		}
+move_map:
+		/*
+		 * If we have references, just move them to a separate list.
+		 */
+		if (pos->referenced)
+			list_add_tail(&pos->node, &self->removed_maps[map->type]);
+		else
+			map__delete(pos);
+
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/*
+ * XXX This should not really _copy_ te maps, but refcount them.
+ */
+int map_groups__clone(struct map_groups *self,
+		      struct map_groups *parent, enum map_type type)
+{
+	struct rb_node *nd;
+	for (nd = rb_first(&parent->maps[type]); nd; nd = rb_next(nd)) {
+		struct map *map = rb_entry(nd, struct map, rb_node);
+		struct map *new = map__clone(map);
+		if (new == NULL)
+			return -ENOMEM;
+		map_groups__insert(self, new);
+	}
+	return 0;
+}
+
+static u64 map__reloc_map_ip(struct map *map, u64 ip)
+{
+	return ip + (s64)map->pgoff;
+}
+
+static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
+{
+	return ip - (s64)map->pgoff;
+}
+
+void map__reloc_vmlinux(struct map *self)
+{
+	struct kmap *kmap = map__kmap(self);
+	s64 reloc;
+
+	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->unrelocated_addr)
+		return;
+
+	reloc = (kmap->ref_reloc_sym->unrelocated_addr -
+		 kmap->ref_reloc_sym->addr);
+
+	if (!reloc)
+		return;
+
+	self->map_ip   = map__reloc_map_ip;
+	self->unmap_ip = map__reloc_unmap_ip;
+	self->pgoff    = reloc;
+}
+
+void maps__insert(struct rb_root *maps, struct map *map)
+{
+	struct rb_node **p = &maps->rb_node;
+	struct rb_node *parent = NULL;
+	const u64 ip = map->start;
+	struct map *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct map, rb_node);
+		if (ip < m->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&map->rb_node, parent, p);
+	rb_insert_color(&map->rb_node, maps);
+}
+
+void maps__remove(struct rb_root *self, struct map *map)
+{
+	rb_erase(&map->rb_node, self);
+}
+
+struct map *maps__find(struct rb_root *maps, u64 ip)
+{
+	struct rb_node **p = &maps->rb_node;
+	struct rb_node *parent = NULL;
+	struct map *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct map, rb_node);
+		if (ip < m->start)
+			p = &(*p)->rb_left;
+		else if (ip > m->end)
+			p = &(*p)->rb_right;
+		else
+			return m;
+	}
+
+	return NULL;
+}
+
+int machine__init(struct machine *self, const char *root_dir, pid_t pid)
+{
+	map_groups__init(&self->kmaps);
+	RB_CLEAR_NODE(&self->rb_node);
+	INIT_LIST_HEAD(&self->user_dsos);
+	INIT_LIST_HEAD(&self->kernel_dsos);
+
+	self->kmaps.machine = self;
+	self->pid	    = pid;
+	self->root_dir      = strdup(root_dir);
+	return self->root_dir == NULL ? -ENOMEM : 0;
+}
+
+static void dsos__delete(struct list_head *self)
+{
+	struct dso *pos, *n;
+
+	list_for_each_entry_safe(pos, n, self, node) {
+		list_del(&pos->node);
+		dso__delete(pos);
+	}
+}
+
+void machine__exit(struct machine *self)
+{
+	map_groups__exit(&self->kmaps);
+	dsos__delete(&self->user_dsos);
+	dsos__delete(&self->kernel_dsos);
+	free(self->root_dir);
+	self->root_dir = NULL;
+}
+
+void machine__delete(struct machine *self)
+{
+	machine__exit(self);
+	free(self);
+}
+
+struct machine *machines__add(struct rb_root *self, pid_t pid,
+			      const char *root_dir)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct machine *pos, *machine = malloc(sizeof(*machine));
+
+	if (!machine)
+		return NULL;
+
+	if (machine__init(machine, root_dir, pid) != 0) {
+		free(machine);
+		return NULL;
+	}
+
+	while (*p != NULL) {
+		parent = *p;
+		pos = rb_entry(parent, struct machine, rb_node);
+		if (pid < pos->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&machine->rb_node, parent, p);
+	rb_insert_color(&machine->rb_node, self);
+
+	return machine;
+}
+
+struct machine *machines__find(struct rb_root *self, pid_t pid)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct machine *machine;
+	struct machine *default_machine = NULL;
+
+	while (*p != NULL) {
+		parent = *p;
+		machine = rb_entry(parent, struct machine, rb_node);
+		if (pid < machine->pid)
+			p = &(*p)->rb_left;
+		else if (pid > machine->pid)
+			p = &(*p)->rb_right;
+		else
+			return machine;
+		if (!machine->pid)
+			default_machine = machine;
+	}
+
+	return default_machine;
+}
+
+struct machine *machines__findnew(struct rb_root *self, pid_t pid)
+{
+	char path[PATH_MAX];
+	const char *root_dir;
+	struct machine *machine = machines__find(self, pid);
+
+	if (!machine || machine->pid != pid) {
+		if (pid == HOST_KERNEL_ID || pid == DEFAULT_GUEST_KERNEL_ID)
+			root_dir = "";
+		else {
+			if (!symbol_conf.guestmount)
+				goto out;
+			sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+			if (access(path, R_OK)) {
+				pr_err("Can't access file %s\n", path);
+				goto out;
+			}
+			root_dir = path;
+		}
+		machine = machines__add(self, pid, root_dir);
+	}
+
+out:
+	return machine;
+}
+
+void machines__process(struct rb_root *self, machine__process_t process, void *data)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		process(pos, data);
+	}
+}
+
+char *machine__mmap_name(struct machine *self, char *bf, size_t size)
+{
+	if (machine__is_host(self))
+		snprintf(bf, size, "[%s]", "kernel.kallsyms");
+	else if (machine__is_default_guest(self))
+		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
+	else
+		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
+
+	return bf;
+}
diff --git a/tools/lib/perf/map.h b/tools/lib/perf/map.h
new file mode 100644
index 0000000..efbff5b
--- /dev/null
+++ b/tools/lib/perf/map.h
@@ -0,0 +1,229 @@
+#ifndef __PERF_MAP_H
+#define __PERF_MAP_H
+
+#include <lk/compiler.h>
+#include <linux/list.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <lk/types.h>
+#include <lk/rbtree.h>
+#include <lk/kernel.h>
+
+enum map_type {
+	MAP__FUNCTION = 0,
+	MAP__VARIABLE,
+};
+
+#define MAP__NR_TYPES (MAP__VARIABLE + 1)
+
+extern const char *map_type__name[MAP__NR_TYPES];
+
+struct dso;
+struct ref_reloc_sym;
+struct map_groups;
+struct machine;
+
+struct map {
+	union {
+		struct rb_node	rb_node;
+		struct list_head node;
+	};
+	u64			start;
+	u64			end;
+	u8 /* enum map_type */	type;
+	bool			referenced;
+	u32			priv;
+	u64			pgoff;
+
+	/* ip -> dso rip */
+	u64			(*map_ip)(struct map *, u64);
+	/* dso rip -> ip */
+	u64			(*unmap_ip)(struct map *, u64);
+
+	struct dso		*dso;
+	struct map_groups	*groups;
+};
+
+struct kmap {
+	struct ref_reloc_sym	*ref_reloc_sym;
+	struct map_groups	*kmaps;
+};
+
+struct map_groups {
+	struct rb_root	 maps[MAP__NR_TYPES];
+	struct list_head removed_maps[MAP__NR_TYPES];
+	struct machine	 *machine;
+};
+
+/* Native host kernel uses -1 as pid index in machine */
+#define	HOST_KERNEL_ID			(-1)
+#define	DEFAULT_GUEST_KERNEL_ID		(0)
+
+struct machine {
+	struct rb_node	  rb_node;
+	pid_t		  pid;
+	char		  *root_dir;
+	struct list_head  user_dsos;
+	struct list_head  kernel_dsos;
+	struct map_groups kmaps;
+	struct map	  *vmlinux_maps[MAP__NR_TYPES];
+};
+
+static inline
+struct map *machine__kernel_map(struct machine *self, enum map_type type)
+{
+	return self->vmlinux_maps[type];
+}
+
+static inline struct kmap *map__kmap(struct map *self)
+{
+	return (struct kmap *)(self + 1);
+}
+
+static inline u64 map__map_ip(struct map *map, u64 ip)
+{
+	return ip - map->start + map->pgoff;
+}
+
+static inline u64 map__unmap_ip(struct map *map, u64 ip)
+{
+	return ip + map->start - map->pgoff;
+}
+
+static inline u64 identity__map_ip(struct map *map __used, u64 ip)
+{
+	return ip;
+}
+
+
+/* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
+u64 map__rip_2objdump(struct map *map, u64 rip);
+u64 map__objdump_2ip(struct map *map, u64 addr);
+
+struct symbol;
+
+typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
+
+void map__init(struct map *self, enum map_type type,
+	       u64 start, u64 end, u64 pgoff, struct dso *dso);
+struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
+		     u64 pgoff, u32 pid, char *filename,
+		     enum map_type type);
+void map__delete(struct map *self);
+struct map *map__clone(struct map *self);
+int map__overlap(struct map *l, struct map *r);
+size_t map__fprintf(struct map *self, FILE *fp);
+
+int map__load(struct map *self, symbol_filter_t filter);
+struct symbol *map__find_symbol(struct map *self,
+				u64 addr, symbol_filter_t filter);
+struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					symbol_filter_t filter);
+void map__fixup_start(struct map *self);
+void map__fixup_end(struct map *self);
+
+void map__reloc_vmlinux(struct map *self);
+
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, int verbose, FILE *fp);
+void maps__insert(struct rb_root *maps, struct map *map);
+void maps__remove(struct rb_root *self, struct map *map);
+struct map *maps__find(struct rb_root *maps, u64 addr);
+void map_groups__init(struct map_groups *self);
+void map_groups__exit(struct map_groups *self);
+int map_groups__clone(struct map_groups *self,
+		      struct map_groups *parent, enum map_type type);
+size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp);
+size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp);
+
+typedef void (*machine__process_t)(struct machine *self, void *data);
+
+void machines__process(struct rb_root *self, machine__process_t process, void *data);
+struct machine *machines__add(struct rb_root *self, pid_t pid,
+			      const char *root_dir);
+struct machine *machines__find_host(struct rb_root *self);
+struct machine *machines__find(struct rb_root *self, pid_t pid);
+struct machine *machines__findnew(struct rb_root *self, pid_t pid);
+char *machine__mmap_name(struct machine *self, char *bf, size_t size);
+int machine__init(struct machine *self, const char *root_dir, pid_t pid);
+void machine__exit(struct machine *self);
+void machine__delete(struct machine *self);
+
+/*
+ * Default guest kernel is defined by parameter --guestkallsyms
+ * and --guestmodules
+ */
+static inline bool machine__is_default_guest(struct machine *self)
+{
+	return self ? self->pid == DEFAULT_GUEST_KERNEL_ID : false;
+}
+
+static inline bool machine__is_host(struct machine *self)
+{
+	return self ? self->pid == HOST_KERNEL_ID : false;
+}
+
+static inline void map_groups__insert(struct map_groups *self, struct map *map)
+{
+	maps__insert(&self->maps[map->type], map);
+	map->groups = self;
+}
+
+static inline void map_groups__remove(struct map_groups *self, struct map *map)
+{
+	maps__remove(&self->maps[map->type], map);
+}
+
+static inline struct map *map_groups__find(struct map_groups *self,
+					   enum map_type type, u64 addr)
+{
+	return maps__find(&self->maps[type], addr);
+}
+
+struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       enum map_type type, u64 addr,
+				       struct map **mapp,
+				       symbol_filter_t filter);
+
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+					       enum map_type type,
+					       const char *name,
+					       struct map **mapp,
+					       symbol_filter_t filter);
+
+static inline
+struct symbol *machine__find_kernel_symbol(struct machine *self,
+					   enum map_type type, u64 addr,
+					   struct map **mapp,
+					   symbol_filter_t filter)
+{
+	return map_groups__find_symbol(&self->kmaps, type, addr, mapp, filter);
+}
+
+static inline
+struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
+					     struct map **mapp,
+					     symbol_filter_t filter)
+{
+	return machine__find_kernel_symbol(self, MAP__FUNCTION, addr, mapp, filter);
+}
+
+static inline
+struct symbol *map_groups__find_function_by_name(struct map_groups *self,
+						 const char *name, struct map **mapp,
+						 symbol_filter_t filter)
+{
+	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
+}
+
+int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+				   int verbose, FILE *fp);
+
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name);
+struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
+
+void map_groups__flush(struct map_groups *self);
+
+#endif /* __PERF_MAP_H */
diff --git a/tools/lib/perf/symbol.c b/tools/lib/perf/symbol.c
new file mode 100644
index 0000000..e47d086
--- /dev/null
+++ b/tools/lib/perf/symbol.c
@@ -0,0 +1,2466 @@
+#define _GNU_SOURCE
+#include <ctype.h>
+#include <dirent.h>
+#include <errno.h>
+#include <libgen.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/param.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include "symbol.h"
+#include <lk/strlist.h>
+#include <perf/config.h>
+#include <trace/parse-events.h>
+
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+#include <limits.h>
+#include <sys/utsname.h>
+
+#ifndef NT_GNU_BUILD_ID
+#define NT_GNU_BUILD_ID 3
+#endif
+
+static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
+static int elf_read_build_id(Elf *elf, void *bf, size_t size);
+static void dsos__add(struct list_head *head, struct dso *dso);
+static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
+static int dso__load_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter);
+static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+			symbol_filter_t filter);
+static int vmlinux_path__nr_entries;
+static char **vmlinux_path;
+
+struct symbol_conf symbol_conf = {
+	.exclude_other	  = true,
+	.use_modules	  = true,
+	.try_vmlinux_path = true,
+};
+
+int dso__name_len(const struct dso *self)
+{
+	if (verbose)
+		return self->long_name_len;
+
+	return self->short_name_len;
+}
+
+bool dso__loaded(const struct dso *self, enum map_type type)
+{
+	return self->loaded & (1 << type);
+}
+
+bool dso__sorted_by_name(const struct dso *self, enum map_type type)
+{
+	return self->sorted_by_name & (1 << type);
+}
+
+static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
+{
+	self->sorted_by_name |= (1 << type);
+}
+
+bool symbol_type__is_a(char symbol_type, enum map_type map_type)
+{
+	switch (map_type) {
+	case MAP__FUNCTION:
+		return symbol_type == 'T' || symbol_type == 'W';
+	case MAP__VARIABLE:
+		return symbol_type == 'D' || symbol_type == 'd';
+	default:
+		return false;
+	}
+}
+
+static void symbols__fixup_end(struct rb_root *self)
+{
+	struct rb_node *nd, *prevnd = rb_first(self);
+	struct symbol *curr, *prev;
+
+	if (prevnd == NULL)
+		return;
+
+	curr = rb_entry(prevnd, struct symbol, rb_node);
+
+	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
+		prev = curr;
+		curr = rb_entry(nd, struct symbol, rb_node);
+
+		if (prev->end == prev->start)
+			prev->end = curr->start - 1;
+	}
+
+	/* Last entry */
+	if (curr->end == curr->start)
+		curr->end = roundup(curr->start, 4096);
+}
+
+static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
+{
+	struct map *prev, *curr;
+	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
+
+	if (prevnd == NULL)
+		return;
+
+	curr = rb_entry(prevnd, struct map, rb_node);
+
+	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
+		prev = curr;
+		curr = rb_entry(nd, struct map, rb_node);
+		prev->end = curr->start - 1;
+	}
+
+	/*
+	 * We still haven't the actual symbols, so guess the
+	 * last map final address.
+	 */
+	curr->end = ~0UL;
+}
+
+static void map_groups__fixup_end(struct map_groups *self)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		__map_groups__fixup_end(self, i);
+}
+
+static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
+				  const char *name)
+{
+	size_t namelen = strlen(name) + 1;
+	struct symbol *self = calloc(1, (symbol_conf.priv_size +
+					 sizeof(*self) + namelen));
+	if (self == NULL)
+		return NULL;
+
+	if (symbol_conf.priv_size)
+		self = ((void *)self) + symbol_conf.priv_size;
+
+	self->start   = start;
+	self->end     = len ? start + len - 1 : start;
+	self->binding = binding;
+	self->namelen = namelen - 1;
+
+	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
+
+	memcpy(self->name, name, namelen);
+
+	return self;
+}
+
+void symbol__delete(struct symbol *self)
+{
+	free(((void *)self) - symbol_conf.priv_size);
+}
+
+static size_t symbol__fprintf(struct symbol *self, FILE *fp)
+{
+	return fprintf(fp, " %llx-%llx %c %s\n",
+		       self->start, self->end,
+		       self->binding == STB_GLOBAL ? 'g' :
+		       self->binding == STB_LOCAL  ? 'l' : 'w',
+		       self->name);
+}
+
+void dso__set_long_name(struct dso *self, char *name)
+{
+	if (name == NULL)
+		return;
+	self->long_name = name;
+	self->long_name_len = strlen(name);
+}
+
+static void dso__set_short_name(struct dso *self, const char *name)
+{
+	if (name == NULL)
+		return;
+	self->short_name = name;
+	self->short_name_len = strlen(name);
+}
+
+static void dso__set_basename(struct dso *self)
+{
+	dso__set_short_name(self, basename(self->long_name));
+}
+
+struct dso *dso__new(const char *name)
+{
+	struct dso *self = calloc(1, sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		int i;
+		strcpy(self->name, name);
+		dso__set_long_name(self, self->name);
+		dso__set_short_name(self, self->name);
+		for (i = 0; i < MAP__NR_TYPES; ++i)
+			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
+		self->slen_calculated = 0;
+		self->origin = DSO__ORIG_NOT_FOUND;
+		self->loaded = 0;
+		self->sorted_by_name = 0;
+		self->has_build_id = 0;
+		self->kernel = DSO_TYPE_USER;
+		INIT_LIST_HEAD(&self->node);
+	}
+
+	return self;
+}
+
+static void symbols__delete(struct rb_root *self)
+{
+	struct symbol *pos;
+	struct rb_node *next = rb_first(self);
+
+	while (next) {
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, self);
+		symbol__delete(pos);
+	}
+}
+
+void dso__delete(struct dso *self)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		symbols__delete(&self->symbols[i]);
+	if (self->sname_alloc)
+		free((char *)self->short_name);
+	if (self->lname_alloc)
+		free(self->long_name);
+	free(self);
+}
+
+void dso__set_build_id(struct dso *self, void *build_id)
+{
+	memcpy(self->build_id, build_id, sizeof(self->build_id));
+	self->has_build_id = 1;
+}
+
+static void symbols__insert(struct rb_root *self, struct symbol *sym)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	const u64 ip = sym->start;
+	struct symbol *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol, rb_node);
+		if (ip < s->start)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&sym->rb_node, parent, p);
+	rb_insert_color(&sym->rb_node, self);
+}
+
+static struct symbol *symbols__find(struct rb_root *self, u64 ip)
+{
+	struct rb_node *n;
+
+	if (self == NULL)
+		return NULL;
+
+	n = self->rb_node;
+
+	while (n) {
+		struct symbol *s = rb_entry(n, struct symbol, rb_node);
+
+		if (ip < s->start)
+			n = n->rb_left;
+		else if (ip > s->end)
+			n = n->rb_right;
+		else
+			return s;
+	}
+
+	return NULL;
+}
+
+struct symbol_name_rb_node {
+	struct rb_node	rb_node;
+	struct symbol	sym;
+};
+
+static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
+{
+	struct rb_node **p = &self->rb_node;
+	struct rb_node *parent = NULL;
+	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct symbol_name_rb_node, rb_node);
+		if (strcmp(sym->name, s->sym.name) < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&symn->rb_node, parent, p);
+	rb_insert_color(&symn->rb_node, self);
+}
+
+static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		symbols__insert_by_name(self, pos);
+	}
+}
+
+static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
+{
+	struct rb_node *n;
+
+	if (self == NULL)
+		return NULL;
+
+	n = self->rb_node;
+
+	while (n) {
+		struct symbol_name_rb_node *s;
+		int cmp;
+
+		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		cmp = strcmp(name, s->sym.name);
+
+		if (cmp < 0)
+			n = n->rb_left;
+		else if (cmp > 0)
+			n = n->rb_right;
+		else
+			return &s->sym;
+	}
+
+	return NULL;
+}
+
+struct symbol *dso__find_symbol(struct dso *self,
+				enum map_type type, u64 addr)
+{
+	return symbols__find(&self->symbols[type], addr);
+}
+
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name)
+{
+	return symbols__find_by_name(&self->symbol_names[type], name);
+}
+
+void dso__sort_by_name(struct dso *self, enum map_type type)
+{
+	dso__set_sorted_by_name(self, type);
+	return symbols__sort_by_name(&self->symbol_names[type],
+				     &self->symbols[type]);
+}
+
+int build_id__sprintf(const u8 *self, int len, char *bf)
+{
+	char *bid = bf;
+	const u8 *raw = self;
+	int i;
+
+	for (i = 0; i < len; ++i) {
+		sprintf(bid, "%02x", *raw);
+		++raw;
+		bid += 2;
+	}
+
+	return raw - self;
+}
+
+size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+	return fprintf(fp, "%s", sbuild_id);
+}
+
+size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
+
+	if (self->short_name != self->long_name)
+		ret += fprintf(fp, "%s, ", self->long_name);
+	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
+		       self->loaded ? "" : "NOT ");
+	ret += dso__fprintf_buildid(self, fp);
+	ret += fprintf(fp, ")\n");
+	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		ret += symbol__fprintf(pos, fp);
+	}
+
+	return ret;
+}
+
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
+						     char type, u64 start))
+{
+	char *line = NULL;
+	size_t n;
+	int err = 0;
+	FILE *file = fopen(filename, "r");
+
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		u64 start;
+		int line_len, len;
+		char symbol_type;
+		char *symbol_name;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		line[--line_len] = '\0'; /* \n */
+
+		len = hex2u64(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		symbol_type = toupper(line[len]);
+		symbol_name = line + len + 2;
+
+		err = process_symbol(arg, symbol_name, symbol_type, start);
+		if (err)
+			break;
+	}
+
+	free(line);
+	fclose(file);
+	return err;
+
+out_failure:
+	return -1;
+}
+
+struct process_kallsyms_args {
+	struct map *map;
+	struct dso *dso;
+};
+
+static u8 kallsyms2elf_type(char type)
+{
+	if (type == 'W')
+		return STB_WEAK;
+
+	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
+}
+
+static int map__process_kallsym_symbol(void *arg, const char *name,
+				       char type, u64 start)
+{
+	struct symbol *sym;
+	struct process_kallsyms_args *a = arg;
+	struct rb_root *root = &a->dso->symbols[a->map->type];
+
+	if (!symbol_type__is_a(type, a->map->type))
+		return 0;
+
+	/*
+	 * Will fix up the end later, when we have all symbols sorted.
+	 */
+	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
+
+	if (sym == NULL)
+		return -ENOMEM;
+	/*
+	 * We will pass the symbols to the filter later, in
+	 * map__split_kallsyms, when we have split the maps per module
+	 */
+	symbols__insert(root, sym);
+
+	return 0;
+}
+
+/*
+ * Loads the function entries in /proc/kallsyms into kernel_map->dso,
+ * so that we can in the next step set the symbol ->end address and then
+ * call kernel_maps__split_kallsyms.
+ */
+static int dso__load_all_kallsyms(struct dso *self, const char *filename,
+				  struct map *map)
+{
+	struct process_kallsyms_args args = { .map = map, .dso = self, };
+	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
+}
+
+/*
+ * Split the symbols into maps, making sure there are no overlaps, i.e. the
+ * kernel range is broken in several maps, named [kernel].N, as we don't have
+ * the original ELF section names vmlinux have.
+ */
+static int dso__split_kallsyms(struct dso *self, struct map *map,
+			       symbol_filter_t filter)
+{
+	struct map_groups *kmaps = map__kmap(map)->kmaps;
+	struct machine *machine = kmaps->machine;
+	struct map *curr_map = map;
+	struct symbol *pos;
+	int count = 0;
+	struct rb_root *root = &self->symbols[map->type];
+	struct rb_node *next = rb_first(root);
+	int kernel_range = 0;
+
+	while (next) {
+		char *module;
+
+		pos = rb_entry(next, struct symbol, rb_node);
+		next = rb_next(&pos->rb_node);
+
+		module = strchr(pos->name, '\t');
+		if (module) {
+			if (!symbol_conf.use_modules)
+				goto discard_symbol;
+
+			*module++ = '\0';
+
+			if (strcmp(curr_map->dso->short_name, module)) {
+				if (curr_map != map &&
+				    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+				    machine__is_default_guest(machine)) {
+					/*
+					 * We assume all symbols of a module are
+					 * continuous in * kallsyms, so curr_map
+					 * points to a module and all its
+					 * symbols are in its kmap. Mark it as
+					 * loaded.
+					 */
+					dso__set_loaded(curr_map->dso,
+							curr_map->type);
+				}
+
+				curr_map = map_groups__find_by_name(kmaps,
+							map->type, module);
+				if (curr_map == NULL) {
+					pr_debug("%s/proc/{kallsyms,modules} "
+					         "inconsistency while looking "
+						 "for \"%s\" module!\n",
+						 machine->root_dir, module);
+					curr_map = map;
+					goto discard_symbol;
+				}
+
+				if (curr_map->dso->loaded &&
+				    !machine__is_default_guest(machine))
+					goto discard_symbol;
+			}
+			/*
+			 * So that we look just like we get from .ko files,
+			 * i.e. not prelinked, relative to map->start.
+			 */
+			pos->start = curr_map->map_ip(curr_map, pos->start);
+			pos->end   = curr_map->map_ip(curr_map, pos->end);
+		} else if (curr_map != map) {
+			char dso_name[PATH_MAX];
+			struct dso *dso;
+
+			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+				snprintf(dso_name, sizeof(dso_name),
+					"[guest.kernel].%d",
+					kernel_range++);
+			else
+				snprintf(dso_name, sizeof(dso_name),
+					"[kernel].%d",
+					kernel_range++);
+
+			dso = dso__new(dso_name);
+			if (dso == NULL)
+				return -1;
+
+			dso->kernel = self->kernel;
+
+			curr_map = map__new2(pos->start, dso, map->type);
+			if (curr_map == NULL) {
+				dso__delete(dso);
+				return -1;
+			}
+
+			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
+			map_groups__insert(kmaps, curr_map);
+			++kernel_range;
+		}
+
+		if (filter && filter(curr_map, pos)) {
+discard_symbol:		rb_erase(&pos->rb_node, root);
+			symbol__delete(pos);
+		} else {
+			if (curr_map != map) {
+				rb_erase(&pos->rb_node, root);
+				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
+			}
+			count++;
+		}
+	}
+
+	if (curr_map != map &&
+	    self->kernel == DSO_TYPE_GUEST_KERNEL &&
+	    machine__is_default_guest(kmaps->machine)) {
+		dso__set_loaded(curr_map->dso, curr_map->type);
+	}
+
+	return count;
+}
+
+int dso__load_kallsyms(struct dso *self, const char *filename,
+		       struct map *map, symbol_filter_t filter)
+{
+	if (dso__load_all_kallsyms(self, filename, map) < 0)
+		return -1;
+
+	symbols__fixup_end(&self->symbols[map->type]);
+	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+		self->origin = DSO__ORIG_GUEST_KERNEL;
+	else
+		self->origin = DSO__ORIG_KERNEL;
+
+	return dso__split_kallsyms(self, map, filter);
+}
+
+static int dso__load_perf_map(struct dso *self, struct map *map,
+			      symbol_filter_t filter)
+{
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	int nr_syms = 0;
+
+	file = fopen(self->long_name, "r");
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		u64 start, size;
+		struct symbol *sym;
+		int line_len, len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		len = hex2u64(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		len += hex2u64(line + len, &size);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		sym = symbol__new(start, size, STB_GLOBAL, line + len);
+
+		if (sym == NULL)
+			goto out_delete_line;
+
+		if (filter && filter(map, sym))
+			symbol__delete(sym);
+		else {
+			symbols__insert(&self->symbols[map->type], sym);
+			nr_syms++;
+		}
+	}
+
+	free(line);
+	fclose(file);
+
+	return nr_syms;
+
+out_delete_line:
+	free(line);
+out_failure:
+	return -1;
+}
+
+/**
+ * elf_symtab__for_each_symbol - iterate thru all the symbols
+ *
+ * @self: struct elf_symtab instance to iterate
+ * @idx: uint32_t idx
+ * @sym: GElf_Sym iterator
+ */
+#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
+	for (idx = 0, gelf_getsym(syms, idx, &sym);\
+	     idx < nr_syms; \
+	     idx++, gelf_getsym(syms, idx, &sym))
+
+static inline uint8_t elf_sym__type(const GElf_Sym *sym)
+{
+	return GELF_ST_TYPE(sym->st_info);
+}
+
+static inline int elf_sym__is_function(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_FUNC &&
+	       sym->st_name != 0 &&
+	       sym->st_shndx != SHN_UNDEF;
+}
+
+static inline bool elf_sym__is_object(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_OBJECT &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF;
+}
+
+static inline int elf_sym__is_label(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_NOTYPE &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF &&
+		sym->st_shndx != SHN_ABS;
+}
+
+static inline const char *elf_sec__name(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return secstrs->d_buf + shdr->sh_name;
+}
+
+static inline int elf_sec__is_text(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
+}
+
+static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
+				    const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
+}
+
+static inline const char *elf_sym__name(const GElf_Sym *sym,
+					const Elf_Data *symstrs)
+{
+	return symstrs->d_buf + sym->st_name;
+}
+
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name,
+				    size_t *idx)
+{
+	Elf_Scn *sec = NULL;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str)) {
+			if (idx)
+				*idx = cnt;
+			break;
+		}
+		++cnt;
+	}
+
+	return sec;
+}
+
+#define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrel(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrel(reldata, idx, &pos_mem))
+
+#define elf_section__for_each_rela(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrela(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
+
+/*
+ * We need to check if we have a .dynsym, so that we can handle the
+ * .plt, synthesizing its symbols, that aren't on the symtabs (be it
+ * .dynsym or .symtab).
+ * And always look at the original dso, not at debuginfo packages, that
+ * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
+ */
+static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
+				       symbol_filter_t filter)
+{
+	uint32_t nr_rel_entries, idx;
+	GElf_Sym sym;
+	u64 plt_offset;
+	GElf_Shdr shdr_plt;
+	struct symbol *f;
+	GElf_Shdr shdr_rel_plt, shdr_dynsym;
+	Elf_Data *reldata, *syms, *symstrs;
+	Elf_Scn *scn_plt_rel, *scn_symstrs, *scn_dynsym;
+	size_t dynsym_idx;
+	GElf_Ehdr ehdr;
+	char sympltname[1024];
+	Elf *elf;
+	int nr = 0, symidx, fd, err = 0;
+
+	fd = open(self->long_name, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		goto out_close;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out_elf_end;
+
+	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
+					 ".dynsym", &dynsym_idx);
+	if (scn_dynsym == NULL)
+		goto out_elf_end;
+
+	scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
+					  ".rela.plt", NULL);
+	if (scn_plt_rel == NULL) {
+		scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
+						  ".rel.plt", NULL);
+		if (scn_plt_rel == NULL)
+			goto out_elf_end;
+	}
+
+	err = -1;
+
+	if (shdr_rel_plt.sh_link != dynsym_idx)
+		goto out_elf_end;
+
+	if (elf_section_by_name(elf, &ehdr, &shdr_plt, ".plt", NULL) == NULL)
+		goto out_elf_end;
+
+	/*
+	 * Fetch the relocation section to find the idxes to the GOT
+	 * and the symbols in the .dynsym they refer to.
+	 */
+	reldata = elf_getdata(scn_plt_rel, NULL);
+	if (reldata == NULL)
+		goto out_elf_end;
+
+	syms = elf_getdata(scn_dynsym, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	scn_symstrs = elf_getscn(elf, shdr_dynsym.sh_link);
+	if (scn_symstrs == NULL)
+		goto out_elf_end;
+
+	symstrs = elf_getdata(scn_symstrs, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
+	plt_offset = shdr_plt.sh_offset;
+
+	if (shdr_rel_plt.sh_type == SHT_RELA) {
+		GElf_Rela pos_mem, *pos;
+
+		elf_section__for_each_rela(reldata, pos, pos_mem, idx,
+					   nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					STB_GLOBAL, sympltname);
+			if (!f)
+				goto out_elf_end;
+
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				symbols__insert(&self->symbols[map->type], f);
+				++nr;
+			}
+		}
+	} else if (shdr_rel_plt.sh_type == SHT_REL) {
+		GElf_Rel pos_mem, *pos;
+		elf_section__for_each_rel(reldata, pos, pos_mem, idx,
+					  nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					STB_GLOBAL, sympltname);
+			if (!f)
+				goto out_elf_end;
+
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				symbols__insert(&self->symbols[map->type], f);
+				++nr;
+			}
+		}
+	}
+
+	err = 0;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+
+	if (err == 0)
+		return nr;
+out:
+	pr_debug("%s: problems reading %s PLT info.\n",
+		 __func__, self->long_name);
+	return 0;
+}
+
+static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sym__is_function(self);
+	case MAP__VARIABLE:
+		return elf_sym__is_object(self);
+	default:
+		return false;
+	}
+}
+
+static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sec__is_text(self, secstrs);
+	case MAP__VARIABLE:
+		return elf_sec__is_data(self, secstrs);
+	default:
+		return false;
+	}
+}
+
+static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
+{
+	Elf_Scn *sec = NULL;
+	GElf_Shdr shdr;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		gelf_getshdr(sec, &shdr);
+
+		if ((addr >= shdr.sh_addr) &&
+		    (addr < (shdr.sh_addr + shdr.sh_size)))
+			return cnt;
+
+		++cnt;
+	}
+
+	return -1;
+}
+
+static int dso__load_sym(struct dso *self, struct map *map, const char *name,
+			 int fd, symbol_filter_t filter, int kmodule,
+			 int want_symtab)
+{
+	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
+	struct map *curr_map = map;
+	struct dso *curr_dso = self;
+	Elf_Data *symstrs, *secstrs;
+	uint32_t nr_syms;
+	int err = -1;
+	uint32_t idx;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr, opdshdr;
+	Elf_Data *syms, *opddata = NULL;
+	GElf_Sym sym;
+	Elf_Scn *sec, *sec_strndx, *opdsec;
+	Elf *elf;
+	int nr = 0;
+	size_t opdidx = 0;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
+		goto out_close;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		pr_debug("%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	/* Always reject images with a mismatched build-id: */
+	if (self->has_build_id) {
+		u8 build_id[BUILD_ID_SIZE];
+
+		if (elf_read_build_id(elf, build_id,
+				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
+			goto out_elf_end;
+
+		if (!dso__build_id_equal(self, build_id))
+			goto out_elf_end;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	if (sec == NULL) {
+		if (want_symtab)
+			goto out_elf_end;
+
+		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+		if (sec == NULL)
+			goto out_elf_end;
+	}
+
+	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdsec)
+		opddata = elf_rawdata(opdsec, NULL);
+
+	syms = elf_getdata(sec, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	sec = elf_getscn(elf, shdr.sh_link);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	symstrs = elf_getdata(sec, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	if (sec_strndx == NULL)
+		goto out_elf_end;
+
+	secstrs = elf_getdata(sec_strndx, NULL);
+	if (secstrs == NULL)
+		goto out_elf_end;
+
+	nr_syms = shdr.sh_size / shdr.sh_entsize;
+
+	memset(&sym, 0, sizeof(sym));
+	if (self->kernel == DSO_TYPE_USER) {
+		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				elf_section_by_name(elf, &ehdr, &shdr,
+						     ".gnu.prelink_undo",
+						     NULL) != NULL);
+	} else self->adjust_symbols = 0;
+
+	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
+		struct symbol *f;
+		const char *elf_name = elf_sym__name(&sym, symstrs);
+		char *demangled = NULL;
+		int is_label = elf_sym__is_label(&sym);
+		const char *section_name;
+
+		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
+		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
+			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
+
+		if (!is_label && !elf_sym__is_a(&sym, map->type))
+			continue;
+
+		/* Reject ARM ELF "mapping symbols": these aren't unique and
+		 * don't identify functions, so will confuse the profile
+		 * output: */
+		if (ehdr.e_machine == EM_ARM) {
+			if (!strcmp(elf_name, "$a") ||
+			    !strcmp(elf_name, "$d") ||
+			    !strcmp(elf_name, "$t"))
+				continue;
+		}
+
+		if (opdsec && sym.st_shndx == opdidx) {
+			u32 offset = sym.st_value - opdshdr.sh_addr;
+			u64 *opd = opddata->d_buf + offset;
+			sym.st_value = *opd;
+			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
+		}
+
+		sec = elf_getscn(elf, sym.st_shndx);
+		if (!sec)
+			goto out_elf_end;
+
+		gelf_getshdr(sec, &shdr);
+
+		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
+			continue;
+
+		section_name = elf_sec__name(&shdr, secstrs);
+
+		if (self->kernel != DSO_TYPE_USER || kmodule) {
+			char dso_name[PATH_MAX];
+
+			if (strcmp(section_name,
+				   (curr_dso->short_name +
+				    self->short_name_len)) == 0)
+				goto new_symbol;
+
+			if (strcmp(section_name, ".text") == 0) {
+				curr_map = map;
+				curr_dso = self;
+				goto new_symbol;
+			}
+
+			snprintf(dso_name, sizeof(dso_name),
+				 "%s%s", self->short_name, section_name);
+
+			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
+			if (curr_map == NULL) {
+				u64 start = sym.st_value;
+
+				if (kmodule)
+					start += map->start + shdr.sh_offset;
+
+				curr_dso = dso__new(dso_name);
+				if (curr_dso == NULL)
+					goto out_elf_end;
+				curr_dso->kernel = self->kernel;
+				curr_map = map__new2(start, curr_dso,
+						     map->type);
+				if (curr_map == NULL) {
+					dso__delete(curr_dso);
+					goto out_elf_end;
+				}
+				curr_map->map_ip = identity__map_ip;
+				curr_map->unmap_ip = identity__map_ip;
+				curr_dso->origin = self->origin;
+				map_groups__insert(kmap->kmaps, curr_map);
+				dsos__add(&self->node, curr_dso);
+				dso__set_loaded(curr_dso, map->type);
+			} else
+				curr_dso = curr_map->dso;
+
+			goto new_symbol;
+		}
+
+		if (curr_dso->adjust_symbols) {
+			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
+				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
+				  (u64)sym.st_value, (u64)shdr.sh_addr,
+				  (u64)shdr.sh_offset);
+			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+		}
+		/*
+		 * We need to figure out if the object was created from C++ sources
+		 * DWARF DW_compile_unit has this, but we don't always have access
+		 * to it...
+		 */
+		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
+		if (demangled != NULL)
+			elf_name = demangled;
+new_symbol:
+		f = symbol__new(sym.st_value, sym.st_size,
+				GELF_ST_BIND(sym.st_info), elf_name);
+		free(demangled);
+		if (!f)
+			goto out_elf_end;
+
+		if (filter && filter(curr_map, f))
+			symbol__delete(f);
+		else {
+			symbols__insert(&curr_dso->symbols[curr_map->type], f);
+			nr++;
+		}
+	}
+
+	/*
+	 * For misannotated, zeroed, ASM function sizes.
+	 */
+	if (nr > 0) {
+		symbols__fixup_end(&self->symbols[map->type]);
+		if (kmap) {
+			/*
+			 * We need to fixup this here too because we create new
+			 * maps here, for things like vsyscall sections.
+			 */
+			__map_groups__fixup_end(kmap->kmaps, map->type);
+		}
+	}
+	err = nr;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	return err;
+}
+
+static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
+{
+	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
+}
+
+bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
+{
+	bool have_build_id = false;
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
+		if (pos->has_build_id) {
+			have_build_id = true;
+			continue;
+		}
+		if (filename__read_build_id(pos->long_name, pos->build_id,
+					    sizeof(pos->build_id)) > 0) {
+			have_build_id	  = true;
+			pos->has_build_id = true;
+		}
+	}
+
+	return have_build_id;
+}
+
+/*
+ * Align offset to 4 bytes as needed for note name and descriptor data.
+ */
+#define NOTE_ALIGN(n) (((n) + 3) & -4U)
+
+static int elf_read_build_id(Elf *elf, void *bf, size_t size)
+{
+	int err = -1;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *data;
+	Elf_Scn *sec;
+	Elf_Kind ek;
+	void *ptr;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		pr_err("%s: cannot get elf header.\n", __func__);
+		goto out;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr,
+				  ".note.gnu.build-id", NULL);
+	if (sec == NULL) {
+		sec = elf_section_by_name(elf, &ehdr, &shdr,
+					  ".notes", NULL);
+		if (sec == NULL)
+			goto out;
+	}
+
+	data = elf_getdata(sec, NULL);
+	if (data == NULL)
+		goto out;
+
+	ptr = data->d_buf;
+	while (ptr < (data->d_buf + data->d_size)) {
+		GElf_Nhdr *nhdr = ptr;
+		int namesz = NOTE_ALIGN(nhdr->n_namesz),
+		    descsz = NOTE_ALIGN(nhdr->n_descsz);
+		const char *name;
+
+		ptr += sizeof(*nhdr);
+		name = ptr;
+		ptr += namesz;
+		if (nhdr->n_type == NT_GNU_BUILD_ID &&
+		    nhdr->n_namesz == sizeof("GNU")) {
+			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
+				memcpy(bf, ptr, BUILD_ID_SIZE);
+				err = BUILD_ID_SIZE;
+				break;
+			}
+		}
+		ptr += descsz;
+	}
+
+out:
+	return err;
+}
+
+int filename__read_build_id(const char *filename, void *bf, size_t size)
+{
+	int fd, err = -1;
+	Elf *elf;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
+		goto out_close;
+	}
+
+	err = elf_read_build_id(elf, bf, size);
+
+	elf_end(elf);
+out_close:
+	close(fd);
+out:
+	return err;
+}
+
+int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
+{
+	int fd, err = -1;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	while (1) {
+		char bf[BUFSIZ];
+		GElf_Nhdr nhdr;
+		int namesz, descsz;
+
+		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
+			break;
+
+		namesz = NOTE_ALIGN(nhdr.n_namesz);
+		descsz = NOTE_ALIGN(nhdr.n_descsz);
+		if (nhdr.n_type == NT_GNU_BUILD_ID &&
+		    nhdr.n_namesz == sizeof("GNU")) {
+			if (read(fd, bf, namesz) != namesz)
+				break;
+			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
+				if (read(fd, build_id,
+				    BUILD_ID_SIZE) == BUILD_ID_SIZE) {
+					err = 0;
+					break;
+				}
+			} else if (read(fd, bf, descsz) != descsz)
+				break;
+		} else {
+			int n = namesz + descsz;
+			if (read(fd, bf, n) != n)
+				break;
+		}
+	}
+	close(fd);
+out:
+	return err;
+}
+
+char dso__symtab_origin(const struct dso *self)
+{
+	static const char origin[] = {
+		[DSO__ORIG_KERNEL] =   'k',
+		[DSO__ORIG_JAVA_JIT] = 'j',
+		[DSO__ORIG_BUILD_ID_CACHE] = 'B',
+		[DSO__ORIG_FEDORA] =   'f',
+		[DSO__ORIG_UBUNTU] =   'u',
+		[DSO__ORIG_BUILDID] =  'b',
+		[DSO__ORIG_DSO] =      'd',
+		[DSO__ORIG_KMODULE] =  'K',
+		[DSO__ORIG_GUEST_KERNEL] =  'g',
+		[DSO__ORIG_GUEST_KMODULE] =  'G',
+	};
+
+	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
+		return '!';
+	return origin[self->origin];
+}
+
+/* overridden by perf/util/build-id.c */
+char * __weak dso__build_id_filename(struct dso *self __unused,
+				     char *bf __unused, size_t size __unused)
+{
+	return NULL;
+}
+
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
+{
+	int size = PATH_MAX;
+	char *name;
+	int ret = -1;
+	int fd;
+	struct machine *machine;
+	const char *root_dir;
+	int want_symtab;
+
+	dso__set_loaded(self, map->type);
+
+	if (self->kernel == DSO_TYPE_KERNEL)
+		return dso__load_kernel_sym(self, map, filter);
+	else if (self->kernel == DSO_TYPE_GUEST_KERNEL)
+		return dso__load_guest_kernel_sym(self, map, filter);
+
+	if (map->groups && map->groups->machine)
+		machine = map->groups->machine;
+	else
+		machine = NULL;
+
+	name = malloc(size);
+	if (!name)
+		return -1;
+
+	self->adjust_symbols = 0;
+
+	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
+		ret = dso__load_perf_map(self, map, filter);
+		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
+					 DSO__ORIG_NOT_FOUND;
+		return ret;
+	}
+
+	/* Iterate over candidate debug images.
+	 * On the first pass, only load images if they have a full symtab.
+	 * Failing that, do a second pass where we accept .dynsym also
+	 */
+	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
+	     self->origin != DSO__ORIG_NOT_FOUND;
+	     self->origin++) {
+		switch (self->origin) {
+		case DSO__ORIG_BUILD_ID_CACHE:
+			if (dso__build_id_filename(self, name, size) == NULL)
+				continue;
+			break;
+		case DSO__ORIG_FEDORA:
+			snprintf(name, size, "/usr/lib/debug%s.debug",
+				 self->long_name);
+			break;
+		case DSO__ORIG_UBUNTU:
+			snprintf(name, size, "/usr/lib/debug%s",
+				 self->long_name);
+			break;
+		case DSO__ORIG_BUILDID: {
+			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+
+			if (!self->has_build_id)
+				continue;
+
+			build_id__sprintf(self->build_id,
+					  sizeof(self->build_id),
+					  build_id_hex);
+			snprintf(name, size,
+				 "/usr/lib/debug/.build-id/%.2s/%s.debug",
+				 build_id_hex, build_id_hex + 2);
+			}
+			break;
+		case DSO__ORIG_DSO:
+			snprintf(name, size, "%s", self->long_name);
+			break;
+		case DSO__ORIG_GUEST_KMODULE:
+			if (map->groups && map->groups->machine)
+				root_dir = map->groups->machine->root_dir;
+			else
+				root_dir = "";
+			snprintf(name, size, "%s%s", root_dir, self->long_name);
+			break;
+
+		default:
+			/*
+			 * If we wanted a full symtab but no image had one,
+			 * relax our requirements and repeat the search.
+			 */
+			if (want_symtab) {
+				want_symtab = 0;
+				self->origin = DSO__ORIG_BUILD_ID_CACHE;
+			} else
+				continue;
+		}
+
+		/* Name is now the name of the next image to try */
+		fd = open(name, O_RDONLY);
+		if (fd < 0)
+			continue;
+
+		ret = dso__load_sym(self, map, name, fd, filter, 0,
+				    want_symtab);
+		close(fd);
+
+		/*
+		 * Some people seem to have debuginfo files _WITHOUT_ debug
+		 * info!?!?
+		 */
+		if (!ret)
+			continue;
+
+		if (ret > 0) {
+			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
+			if (nr_plt > 0)
+				ret += nr_plt;
+			break;
+		}
+	}
+
+	free(name);
+	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+		return 0;
+	return ret;
+}
+
+struct map *map_groups__find_by_name(struct map_groups *self,
+				     enum map_type type, const char *name)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+		struct map *map = rb_entry(nd, struct map, rb_node);
+
+		if (map->dso && strcmp(map->dso->short_name, name) == 0)
+			return map;
+	}
+
+	return NULL;
+}
+
+static int dso__kernel_module_get_build_id(struct dso *self,
+				const char *root_dir)
+{
+	char filename[PATH_MAX];
+	/*
+	 * kernel module short names are of the form "[module]" and
+	 * we need just "module" here.
+	 */
+	const char *name = self->short_name + 1;
+
+	snprintf(filename, sizeof(filename),
+		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
+		 root_dir, (int)strlen(name) - 1, name);
+
+	if (sysfs__read_build_id(filename, self->build_id,
+				 sizeof(self->build_id)) == 0)
+		self->has_build_id = true;
+
+	return 0;
+}
+
+static int map_groups__set_modules_path_dir(struct map_groups *self,
+				const char *dir_name)
+{
+	struct dirent *dent;
+	DIR *dir = opendir(dir_name);
+	int ret = 0;
+
+	if (!dir) {
+		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
+		return -1;
+	}
+
+	while ((dent = readdir(dir)) != NULL) {
+		char path[PATH_MAX];
+		struct stat st;
+
+		/*sshfs might return bad dent->d_type, so we have to stat*/
+		sprintf(path, "%s/%s", dir_name, dent->d_name);
+		if (stat(path, &st))
+			continue;
+
+		if (S_ISDIR(st.st_mode)) {
+			if (!strcmp(dent->d_name, ".") ||
+			    !strcmp(dent->d_name, ".."))
+				continue;
+
+			snprintf(path, sizeof(path), "%s/%s",
+				 dir_name, dent->d_name);
+			ret = map_groups__set_modules_path_dir(self, path);
+			if (ret < 0)
+				goto out;
+		} else {
+			char *dot = strrchr(dent->d_name, '.'),
+			     dso_name[PATH_MAX];
+			struct map *map;
+			char *long_name;
+
+			if (dot == NULL || strcmp(dot, ".ko"))
+				continue;
+			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
+				 (int)(dot - dent->d_name), dent->d_name);
+
+			strxfrchar(dso_name, '-', '_');
+			map = map_groups__find_by_name(self, MAP__FUNCTION, dso_name);
+			if (map == NULL)
+				continue;
+
+			snprintf(path, sizeof(path), "%s/%s",
+				 dir_name, dent->d_name);
+
+			long_name = strdup(path);
+			if (long_name == NULL) {
+				ret = -1;
+				goto out;
+			}
+			dso__set_long_name(map->dso, long_name);
+			map->dso->lname_alloc = 1;
+			dso__kernel_module_get_build_id(map->dso, "");
+		}
+	}
+
+out:
+	closedir(dir);
+	return ret;
+}
+
+static char *get_kernel_version(const char *root_dir)
+{
+	char version[PATH_MAX];
+	FILE *file;
+	char *name, *tmp;
+	const char *prefix = "Linux version ";
+
+	sprintf(version, "%s/proc/version", root_dir);
+	file = fopen(version, "r");
+	if (!file)
+		return NULL;
+
+	version[0] = '\0';
+	tmp = fgets(version, sizeof(version), file);
+	fclose(file);
+
+	name = strstr(version, prefix);
+	if (!name)
+		return NULL;
+	name += strlen(prefix);
+	tmp = strchr(name, ' ');
+	if (tmp)
+		*tmp = '\0';
+
+	return strdup(name);
+}
+
+static int machine__set_modules_path(struct machine *self)
+{
+	char *version;
+	char modules_path[PATH_MAX];
+
+	version = get_kernel_version(self->root_dir);
+	if (!version)
+		return -1;
+
+	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
+		 self->root_dir, version);
+	free(version);
+
+	return map_groups__set_modules_path_dir(&self->kmaps, modules_path);
+}
+
+/*
+ * Constructor variant for modules (where we know from /proc/modules where
+ * they are loaded) and for vmlinux, where only after we load all the
+ * symbols we'll know where it starts and ends.
+ */
+static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
+{
+	struct map *self = calloc(1, (sizeof(*self) +
+				      (dso->kernel ? sizeof(struct kmap) : 0)));
+	if (self != NULL) {
+		/*
+		 * ->end will be filled after we load all the symbols
+		 */
+		map__init(self, type, start, 0, 0, dso);
+	}
+
+	return self;
+}
+
+struct map *machine__new_module(struct machine *self, u64 start,
+				const char *filename)
+{
+	struct map *map;
+	struct dso *dso = __dsos__findnew(&self->kernel_dsos, filename);
+
+	if (dso == NULL)
+		return NULL;
+
+	map = map__new2(start, dso, MAP__FUNCTION);
+	if (map == NULL)
+		return NULL;
+
+	if (machine__is_host(self))
+		dso->origin = DSO__ORIG_KMODULE;
+	else
+		dso->origin = DSO__ORIG_GUEST_KMODULE;
+	map_groups__insert(&self->kmaps, map);
+	return map;
+}
+
+static int machine__create_modules(struct machine *self)
+{
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	struct map *map;
+	const char *modules;
+	char path[PATH_MAX];
+
+	if (machine__is_default_guest(self))
+		modules = symbol_conf.default_guest_modules;
+	else {
+		sprintf(path, "%s/proc/modules", self->root_dir);
+		modules = path;
+	}
+
+	file = fopen(modules, "r");
+	if (file == NULL)
+		return -1;
+
+	while (!feof(file)) {
+		char name[PATH_MAX];
+		u64 start;
+		char *sep;
+		int line_len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		sep = strrchr(line, 'x');
+		if (sep == NULL)
+			continue;
+
+		hex2u64(sep + 1, &start);
+
+		sep = strchr(line, ' ');
+		if (sep == NULL)
+			continue;
+
+		*sep = '\0';
+
+		snprintf(name, sizeof(name), "[%s]", line);
+		map = machine__new_module(self, start, name);
+		if (map == NULL)
+			goto out_delete_line;
+		dso__kernel_module_get_build_id(map->dso, self->root_dir);
+	}
+
+	free(line);
+	fclose(file);
+
+	return machine__set_modules_path(self);
+
+out_delete_line:
+	free(line);
+out_failure:
+	return -1;
+}
+
+static int dso__load_vmlinux(struct dso *self, struct map *map,
+			     const char *vmlinux, symbol_filter_t filter)
+{
+	int err = -1, fd;
+
+	fd = open(vmlinux, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	dso__set_loaded(self, map->type);
+	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
+	close(fd);
+
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", vmlinux);
+
+	return err;
+}
+
+int dso__load_vmlinux_path(struct dso *self, struct map *map,
+			   symbol_filter_t filter)
+{
+	int i, err = 0;
+	char *filename;
+
+	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
+		 vmlinux_path__nr_entries + 1);
+
+	filename = dso__build_id_filename(self, NULL, 0);
+	if (filename != NULL) {
+		err = dso__load_vmlinux(self, map, filename, filter);
+		if (err > 0) {
+			dso__set_long_name(self, filename);
+			goto out;
+		}
+		free(filename);
+	}
+
+	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
+		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
+		if (err > 0) {
+			dso__set_long_name(self, strdup(vmlinux_path[i]));
+			break;
+		}
+	}
+out:
+	return err;
+}
+
+static int dso__load_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter)
+{
+	int err;
+	const char *kallsyms_filename = NULL;
+	char *kallsyms_allocated_filename = NULL;
+	/*
+	 * Step 1: if the user specified a vmlinux filename, use it and only
+	 * it, reporting errors to the user if it cannot be used.
+	 *
+	 * For instance, try to analyse an ARM perf.data file _without_ a
+	 * build-id, or if the user specifies the wrong path to the right
+	 * vmlinux file, obviously we can't fallback to another vmlinux (a
+	 * x86_86 one, on the machine where analysis is being performed, say),
+	 * or worse, /proc/kallsyms.
+	 *
+	 * If the specified file _has_ a build-id and there is a build-id
+	 * section in the perf.data file, we will still do the expected
+	 * validation in dso__load_vmlinux and will bail out if they don't
+	 * match.
+	 */
+	if (symbol_conf.vmlinux_name != NULL) {
+		err = dso__load_vmlinux(self, map,
+					symbol_conf.vmlinux_name, filter);
+		if (err > 0) {
+			dso__set_long_name(self,
+					   strdup(symbol_conf.vmlinux_name));
+			goto out_fixup;
+		}
+		return err;
+	}
+
+	if (vmlinux_path != NULL) {
+		err = dso__load_vmlinux_path(self, map, filter);
+		if (err > 0)
+			goto out_fixup;
+	}
+
+	/*
+	 * Say the kernel DSO was created when processing the build-id header table,
+	 * we have a build-id, so check if it is the same as the running kernel,
+	 * using it if it is.
+	 */
+	if (self->has_build_id) {
+		u8 kallsyms_build_id[BUILD_ID_SIZE];
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
+					 sizeof(kallsyms_build_id)) == 0) {
+			if (dso__build_id_equal(self, kallsyms_build_id)) {
+				kallsyms_filename = "/proc/kallsyms";
+				goto do_kallsyms;
+			}
+		}
+		/*
+		 * Now look if we have it on the build-id cache in
+		 * $HOME/.debug/[kernel.kallsyms].
+		 */
+		build_id__sprintf(self->build_id, sizeof(self->build_id),
+				  sbuild_id);
+
+		if (asprintf(&kallsyms_allocated_filename,
+			     "%s/.debug/[kernel.kallsyms]/%s",
+			     getenv("HOME"), sbuild_id) == -1) {
+			pr_err("Not enough memory for kallsyms file lookup\n");
+			return -1;
+		}
+
+		kallsyms_filename = kallsyms_allocated_filename;
+
+		if (access(kallsyms_filename, F_OK)) {
+			pr_err("No kallsyms or vmlinux with build-id %s "
+			       "was found\n", sbuild_id);
+			free(kallsyms_allocated_filename);
+			return -1;
+		}
+	} else {
+		/*
+		 * Last resort, if we don't have a build-id and couldn't find
+		 * any vmlinux file, try the running kernel kallsyms table.
+		 */
+		kallsyms_filename = "/proc/kallsyms";
+	}
+
+do_kallsyms:
+	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", kallsyms_filename);
+	free(kallsyms_allocated_filename);
+
+	if (err > 0) {
+out_fixup:
+		if (kallsyms_filename != NULL)
+			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
+		map__fixup_start(map);
+		map__fixup_end(map);
+	}
+
+	return err;
+}
+
+static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
+				symbol_filter_t filter)
+{
+	int err;
+	const char *kallsyms_filename = NULL;
+	struct machine *machine;
+	char path[PATH_MAX];
+
+	if (!map->groups) {
+		pr_debug("Guest kernel map hasn't the point to groups\n");
+		return -1;
+	}
+	machine = map->groups->machine;
+
+	if (machine__is_default_guest(machine)) {
+		/*
+		 * if the user specified a vmlinux filename, use it and only
+		 * it, reporting errors to the user if it cannot be used.
+		 * Or use file guest_kallsyms inputted by user on commandline
+		 */
+		if (symbol_conf.default_guest_vmlinux_name != NULL) {
+			err = dso__load_vmlinux(self, map,
+				symbol_conf.default_guest_vmlinux_name, filter);
+			goto out_try_fixup;
+		}
+
+		kallsyms_filename = symbol_conf.default_guest_kallsyms;
+		if (!kallsyms_filename)
+			return -1;
+	} else {
+		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		kallsyms_filename = path;
+	}
+
+	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
+	if (err > 0)
+		pr_debug("Using %s for symbols\n", kallsyms_filename);
+
+out_try_fixup:
+	if (err > 0) {
+		if (kallsyms_filename != NULL) {
+			machine__mmap_name(machine, path, sizeof(path));
+			dso__set_long_name(self, strdup(path));
+		}
+		map__fixup_start(map);
+		map__fixup_end(map);
+	}
+
+	return err;
+}
+
+static void dsos__add(struct list_head *head, struct dso *dso)
+{
+	list_add_tail(&dso->node, head);
+}
+
+static struct dso *dsos__find(struct list_head *head, const char *name)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		if (strcmp(pos->long_name, name) == 0)
+			return pos;
+	return NULL;
+}
+
+struct dso *__dsos__findnew(struct list_head *head, const char *name)
+{
+	struct dso *dso = dsos__find(head, name);
+
+	if (!dso) {
+		dso = dso__new(name);
+		if (dso != NULL) {
+			dsos__add(head, dso);
+			dso__set_basename(dso);
+		}
+	}
+
+	return dso;
+}
+
+size_t __dsos__fprintf(struct list_head *head, FILE *fp)
+{
+	struct dso *pos;
+	size_t ret = 0;
+
+	list_for_each_entry(pos, head, node) {
+		int i;
+		for (i = 0; i < MAP__NR_TYPES; ++i)
+			ret += dso__fprintf(pos, i, fp);
+	}
+
+	return ret;
+}
+
+size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = 0;
+
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
+		ret += __dsos__fprintf(&pos->user_dsos, fp);
+	}
+
+	return ret;
+}
+
+static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+				      bool with_hits)
+{
+	struct dso *pos;
+	size_t ret = 0;
+
+	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
+		ret += dso__fprintf_buildid(pos, fp);
+		ret += fprintf(fp, " %s\n", pos->long_name);
+	}
+	return ret;
+}
+
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
+{
+	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
+	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
+}
+
+size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
+{
+	struct rb_node *nd;
+	size_t ret = 0;
+
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
+	}
+	return ret;
+}
+
+struct dso *dso__new_kernel(const char *name)
+{
+	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
+
+	if (self != NULL) {
+		dso__set_short_name(self, "[kernel]");
+		self->kernel = DSO_TYPE_KERNEL;
+	}
+
+	return self;
+}
+
+static struct dso *dso__new_guest_kernel(struct machine *machine,
+					const char *name)
+{
+	char bf[PATH_MAX];
+	struct dso *self = dso__new(name ?: machine__mmap_name(machine, bf, sizeof(bf)));
+
+	if (self != NULL) {
+		dso__set_short_name(self, "[guest.kernel]");
+		self->kernel = DSO_TYPE_GUEST_KERNEL;
+	}
+
+	return self;
+}
+
+void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine)
+{
+	char path[PATH_MAX];
+
+	if (machine__is_default_guest(machine))
+		return;
+	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
+	if (sysfs__read_build_id(path, self->build_id,
+				 sizeof(self->build_id)) == 0)
+		self->has_build_id = true;
+}
+
+static struct dso *machine__create_kernel(struct machine *self)
+{
+	const char *vmlinux_name = NULL;
+	struct dso *kernel;
+
+	if (machine__is_host(self)) {
+		vmlinux_name = symbol_conf.vmlinux_name;
+		kernel = dso__new_kernel(vmlinux_name);
+	} else {
+		if (machine__is_default_guest(self))
+			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
+		kernel = dso__new_guest_kernel(self, vmlinux_name);
+	}
+
+	if (kernel != NULL) {
+		dso__read_running_kernel_build_id(kernel, self);
+		dsos__add(&self->kernel_dsos, kernel);
+	}
+	return kernel;
+}
+
+int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
+{
+	enum map_type type;
+
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct kmap *kmap;
+
+		self->vmlinux_maps[type] = map__new2(0, kernel, type);
+		if (self->vmlinux_maps[type] == NULL)
+			return -1;
+
+		self->vmlinux_maps[type]->map_ip =
+			self->vmlinux_maps[type]->unmap_ip = identity__map_ip;
+
+		kmap = map__kmap(self->vmlinux_maps[type]);
+		kmap->kmaps = &self->kmaps;
+		map_groups__insert(&self->kmaps, self->vmlinux_maps[type]);
+	}
+
+	return 0;
+}
+
+void machine__destroy_kernel_maps(struct machine *self)
+{
+	enum map_type type;
+
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct kmap *kmap;
+
+		if (self->vmlinux_maps[type] == NULL)
+			continue;
+
+		kmap = map__kmap(self->vmlinux_maps[type]);
+		map_groups__remove(&self->kmaps, self->vmlinux_maps[type]);
+		if (kmap->ref_reloc_sym) {
+			/*
+			 * ref_reloc_sym is shared among all maps, so free just
+			 * on one of them.
+			 */
+			if (type == MAP__FUNCTION) {
+				free((char *)kmap->ref_reloc_sym->name);
+				kmap->ref_reloc_sym->name = NULL;
+				free(kmap->ref_reloc_sym);
+			}
+			kmap->ref_reloc_sym = NULL;
+		}
+
+		map__delete(self->vmlinux_maps[type]);
+		self->vmlinux_maps[type] = NULL;
+	}
+}
+
+int machine__create_kernel_maps(struct machine *self)
+{
+	struct dso *kernel = machine__create_kernel(self);
+
+	if (kernel == NULL ||
+	    __machine__create_kernel_maps(self, kernel) < 0)
+		return -1;
+
+	if (symbol_conf.use_modules && machine__create_modules(self) < 0)
+		pr_debug("Problems creating module maps, continuing anyway...\n");
+	/*
+	 * Now that we have all the maps created, just set the ->end of them:
+	 */
+	map_groups__fixup_end(&self->kmaps);
+	return 0;
+}
+
+static void vmlinux_path__exit(void)
+{
+	while (--vmlinux_path__nr_entries >= 0) {
+		free(vmlinux_path[vmlinux_path__nr_entries]);
+		vmlinux_path[vmlinux_path__nr_entries] = NULL;
+	}
+
+	free(vmlinux_path);
+	vmlinux_path = NULL;
+}
+
+static int vmlinux_path__init(void)
+{
+	struct utsname uts;
+	char bf[PATH_MAX];
+
+	if (uname(&uts) < 0)
+		return -1;
+
+	vmlinux_path = malloc(sizeof(char *) * 5);
+	if (vmlinux_path == NULL)
+		return -1;
+
+	vmlinux_path[vmlinux_path__nr_entries] = strdup("vmlinux");
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	vmlinux_path[vmlinux_path__nr_entries] = strdup("/boot/vmlinux");
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
+		 uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+
+	return 0;
+
+out_fail:
+	vmlinux_path__exit();
+	return -1;
+}
+
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
+{
+	int i;
+	size_t printed = 0;
+	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
+
+	if (kdso->has_build_id) {
+		char filename[PATH_MAX];
+		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
+			printed += fprintf(fp, "[0] %s\n", filename);
+	}
+
+	for (i = 0; i < vmlinux_path__nr_entries; ++i)
+		printed += fprintf(fp, "[%d] %s\n",
+				   i + kdso->has_build_id, vmlinux_path[i]);
+
+	return printed;
+}
+
+static int setup_list(struct strlist **list, const char *list_str,
+		      const char *list_name)
+{
+	if (list_str == NULL)
+		return 0;
+
+	*list = strlist__new(true, list_str);
+	if (!*list) {
+		pr_err("problems parsing %s list\n", list_name);
+		return -1;
+	}
+	return 0;
+}
+
+int symbol__init(void)
+{
+	if (symbol_conf.initialized)
+		return 0;
+
+	elf_version(EV_CURRENT);
+	if (symbol_conf.sort_by_name)
+		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
+					  sizeof(struct symbol));
+
+	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
+		return -1;
+
+	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
+		pr_err("'.' is the only non valid --field-separator argument\n");
+		return -1;
+	}
+
+	if (setup_list(&symbol_conf.dso_list,
+		       symbol_conf.dso_list_str, "dso") < 0)
+		return -1;
+
+	if (setup_list(&symbol_conf.comm_list,
+		       symbol_conf.comm_list_str, "comm") < 0)
+		goto out_free_dso_list;
+
+	if (setup_list(&symbol_conf.sym_list,
+		       symbol_conf.sym_list_str, "symbol") < 0)
+		goto out_free_comm_list;
+
+	symbol_conf.initialized = true;
+	return 0;
+
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
+out_free_comm_list:
+	strlist__delete(symbol_conf.comm_list);
+	return -1;
+}
+
+void symbol__exit(void)
+{
+	if (!symbol_conf.initialized)
+		return;
+	strlist__delete(symbol_conf.sym_list);
+	strlist__delete(symbol_conf.dso_list);
+	strlist__delete(symbol_conf.comm_list);
+	vmlinux_path__exit();
+	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
+	symbol_conf.initialized = false;
+}
+
+int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
+{
+	struct machine *machine = machines__findnew(self, pid);
+
+	if (machine == NULL)
+		return -1;
+
+	return machine__create_kernel_maps(machine);
+}
+
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2u64(const char *ptr, u64 *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
+
+char *strxfrchar(char *s, char from, char to)
+{
+	char *p = s;
+
+	while ((p = strchr(p, from)) != NULL)
+		*p++ = to;
+
+	return s;
+}
+
+int machines__create_guest_kernel_maps(struct rb_root *self)
+{
+	int ret = 0;
+	struct dirent **namelist = NULL;
+	int i, items = 0;
+	char path[PATH_MAX];
+	pid_t pid;
+
+	if (symbol_conf.default_guest_vmlinux_name ||
+	    symbol_conf.default_guest_modules ||
+	    symbol_conf.default_guest_kallsyms) {
+		machines__create_kernel_maps(self, DEFAULT_GUEST_KERNEL_ID);
+	}
+
+	if (symbol_conf.guestmount) {
+		items = scandir(symbol_conf.guestmount, &namelist, NULL, NULL);
+		if (items <= 0)
+			return -ENOENT;
+		for (i = 0; i < items; i++) {
+			if (!isdigit(namelist[i]->d_name[0])) {
+				/* Filter out . and .. */
+				continue;
+			}
+			pid = atoi(namelist[i]->d_name);
+			sprintf(path, "%s/%s/proc/kallsyms",
+				symbol_conf.guestmount,
+				namelist[i]->d_name);
+			ret = access(path, R_OK);
+			if (ret) {
+				pr_debug("Can't access file %s\n", path);
+				goto failure;
+			}
+			machines__create_kernel_maps(self, pid);
+		}
+failure:
+		free(namelist);
+	}
+
+	return ret;
+}
+
+void machines__destroy_guest_kernel_maps(struct rb_root *self)
+{
+	struct rb_node *next = rb_first(self);
+
+	while (next) {
+		struct machine *pos = rb_entry(next, struct machine, rb_node);
+
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, self);
+		machine__delete(pos);
+	}
+}
+
+int machine__load_kallsyms(struct machine *self, const char *filename,
+			   enum map_type type, symbol_filter_t filter)
+{
+	struct map *map = self->vmlinux_maps[type];
+	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		/*
+		 * Since /proc/kallsyms will have multiple sessions for the
+		 * kernel, with modules between them, fixup the end of all
+		 * sections.
+		 */
+		__map_groups__fixup_end(&self->kmaps, type);
+	}
+
+	return ret;
+}
+
+int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+			       symbol_filter_t filter)
+{
+	struct map *map = self->vmlinux_maps[type];
+	int ret = dso__load_vmlinux_path(map->dso, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		map__reloc_vmlinux(map);
+	}
+
+	return ret;
+}
diff --git a/tools/lib/perf/symbol.h b/tools/lib/perf/symbol.h
new file mode 100644
index 0000000..c8cf8c6
--- /dev/null
+++ b/tools/lib/perf/symbol.h
@@ -0,0 +1,233 @@
+#ifndef __PERF_SYMBOL_H
+#define __PERF_SYMBOL_H
+
+#include <linux/types.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include "map.h"
+#include <linux/list.h>
+#include <lk/rbtree.h>
+#include <stdio.h>
+
+#ifdef HAVE_CPLUS_DEMANGLE
+extern char *cplus_demangle(const char *, int);
+
+static inline char *bfd_demangle(void __used *v, const char *c, int i)
+{
+	return cplus_demangle(c, i);
+}
+#else
+#ifdef NO_DEMANGLE
+static inline char *bfd_demangle(void __used *v, const char __used *c,
+				 int __used i)
+{
+	return NULL;
+}
+#else
+#include <bfd.h>
+#endif
+#endif
+
+int hex2u64(const char *ptr, u64 *val);
+char *strxfrchar(char *s, char from, char to);
+
+/*
+ * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
+ * for newer versions we can use mmap to reduce memory usage:
+ */
+#ifdef LIBELF_NO_MMAP
+# define PERF_ELF_C_READ_MMAP ELF_C_READ
+#else
+# define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
+#endif
+
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS      (1 << 0)       /* Include function args */
+#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
+#endif
+
+#define BUILD_ID_SIZE 20
+
+struct symbol {
+	struct rb_node	rb_node;
+	u64		start;
+	u64		end;
+	u16		namelen;
+	u8		binding;
+	char		name[0];
+};
+
+void symbol__delete(struct symbol *self);
+
+struct strlist;
+
+struct symbol_conf {
+	unsigned short	priv_size;
+	bool		try_vmlinux_path,
+			use_modules,
+			sort_by_name,
+			show_nr_samples,
+			use_callchain,
+			exclude_other,
+			show_cpu_utilization,
+			initialized;
+	const char	*vmlinux_name,
+			*source_prefix,
+			*field_sep;
+	const char	*default_guest_vmlinux_name,
+			*default_guest_kallsyms,
+			*default_guest_modules;
+	const char	*guestmount;
+	const char	*dso_list_str,
+			*comm_list_str,
+			*sym_list_str,
+			*col_width_list_str;
+       struct strlist	*dso_list,
+			*comm_list,
+			*sym_list;
+};
+
+extern struct symbol_conf symbol_conf;
+
+static inline void *symbol__priv(struct symbol *self)
+{
+	return ((void *)self) - symbol_conf.priv_size;
+}
+
+struct ref_reloc_sym {
+	const char	*name;
+	u64		addr;
+	u64		unrelocated_addr;
+};
+
+struct map_symbol {
+	struct map    *map;
+	struct symbol *sym;
+	bool	      unfolded;
+	bool	      has_children;
+};
+
+struct addr_location {
+	struct thread *thread;
+	struct map    *map;
+	struct symbol *sym;
+	u64	      addr;
+	char	      level;
+	bool	      filtered;
+	u8	      cpumode;
+	s32	      cpu;
+};
+
+enum dso_kernel_type {
+	DSO_TYPE_USER = 0,
+	DSO_TYPE_KERNEL,
+	DSO_TYPE_GUEST_KERNEL
+};
+
+struct dso {
+	struct list_head node;
+	struct rb_root	 symbols[MAP__NR_TYPES];
+	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	enum dso_kernel_type	kernel;
+	u8		 adjust_symbols:1;
+	u8		 slen_calculated:1;
+	u8		 has_build_id:1;
+	u8		 hit:1;
+	u8		 annotate_warned:1;
+	u8		 sname_alloc:1;
+	u8		 lname_alloc:1;
+	unsigned char	 origin;
+	u8		 sorted_by_name;
+	u8		 loaded;
+	u8		 build_id[BUILD_ID_SIZE];
+	const char	 *short_name;
+	char	 	 *long_name;
+	u16		 long_name_len;
+	u16		 short_name_len;
+	char		 name[0];
+};
+
+struct dso *dso__new(const char *name);
+struct dso *dso__new_kernel(const char *name);
+void dso__delete(struct dso *self);
+
+int dso__name_len(const struct dso *self);
+
+bool dso__loaded(const struct dso *self, enum map_type type);
+bool dso__sorted_by_name(const struct dso *self, enum map_type type);
+
+static inline void dso__set_loaded(struct dso *self, enum map_type type)
+{
+	self->loaded |= (1 << type);
+}
+
+void dso__sort_by_name(struct dso *self, enum map_type type);
+
+struct dso *__dsos__findnew(struct list_head *head, const char *name);
+
+int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
+int dso__load_vmlinux_path(struct dso *self, struct map *map,
+			   symbol_filter_t filter);
+int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
+		       symbol_filter_t filter);
+int machine__load_kallsyms(struct machine *self, const char *filename,
+			   enum map_type type, symbol_filter_t filter);
+int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+			       symbol_filter_t filter);
+
+size_t __dsos__fprintf(struct list_head *head, FILE *fp);
+
+size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
+
+size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
+size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
+
+enum dso_origin {
+	DSO__ORIG_KERNEL = 0,
+	DSO__ORIG_GUEST_KERNEL,
+	DSO__ORIG_JAVA_JIT,
+	DSO__ORIG_BUILD_ID_CACHE,
+	DSO__ORIG_FEDORA,
+	DSO__ORIG_UBUNTU,
+	DSO__ORIG_BUILDID,
+	DSO__ORIG_DSO,
+	DSO__ORIG_GUEST_KMODULE,
+	DSO__ORIG_KMODULE,
+	DSO__ORIG_NOT_FOUND,
+};
+
+char dso__symtab_origin(const struct dso *self);
+void dso__set_long_name(struct dso *self, char *name);
+void dso__set_build_id(struct dso *self, void *build_id);
+void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
+struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
+struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
+					const char *name);
+
+int filename__read_build_id(const char *filename, void *bf, size_t size);
+int sysfs__read_build_id(const char *filename, void *bf, size_t size);
+bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
+int build_id__sprintf(const u8 *self, int len, char *bf);
+int kallsyms__parse(const char *filename, void *arg,
+		    int (*process_symbol)(void *arg, const char *name,
+					  char type, u64 start));
+
+void machine__destroy_kernel_maps(struct machine *self);
+int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
+int machine__create_kernel_maps(struct machine *self);
+
+int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
+int machines__create_guest_kernel_maps(struct rb_root *self);
+void machines__destroy_guest_kernel_maps(struct rb_root *self);
+
+int symbol__init(void);
+void symbol__exit(void);
+bool symbol_type__is_a(char symbol_type, enum map_type map_type);
+
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
+
+char * __weak dso__build_id_filename(struct dso *self, char *bf, size_t size);
+
+#endif /* __PERF_SYMBOL_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 66fd9c2..98cdd20 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -356,7 +356,6 @@ LIB_H += util/debug.h
 LIB_H += util/event.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
-LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
@@ -367,7 +366,6 @@ LIB_H += util/strbuf.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
-LIB_H += util/symbol.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
@@ -393,13 +391,11 @@ LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
-LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
 LIB_OBJS += $(OUTPUT)util/callchain.o
 LIB_OBJS += $(OUTPUT)util/values.o
 LIB_OBJS += $(OUTPUT)util/debug.o
-LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c246b57..774a6c4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -13,7 +13,7 @@
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
-#include "util/symbol.h"
+#include <perf/config.h>
 
 #include "perf.h"
 #include "util/debug.h"
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 43e4faa..96b84f7 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -13,7 +13,8 @@
 #include "util/header.h"
 #include "util/parse-options.h"
 #include <lk/strlist.h>
-#include "util/symbol.h"
+#include <perf/symbol.h>
+#include <perf/config.h>
 
 static char const *add_name_list_str, *remove_name_list_str;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..d2bcbfb 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -13,7 +13,7 @@
 #include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/session.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 
 static char const *input_name = "perf.data";
 static bool force;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 83c0a89..939f52d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -11,7 +11,7 @@
 #include "util/hist.h"
 #include "util/session.h"
 #include "util/sort.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include <lk/util.h>
 
 #include <stdlib.h>
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8e3e47b..0de5e1a 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -10,8 +10,8 @@
 #include "perf.h"
 #include "util/session.h"
 #include "util/debug.h"
-
 #include "util/parse-options.h"
+#include <perf/config.h>
 
 static char		const *input_name = "-";
 static bool		inject_build_ids;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f157a9c..703cc93 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -3,7 +3,7 @@
 
 #include <lk/util.h>
 #include "util/cache.h"
-#include "util/symbol.h"
+#include <perf/symbol.h>
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 3e5d0fc..b849f99e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -3,7 +3,7 @@
 
 #include <lk/util.h>
 #include "util/cache.h"
-#include "util/symbol.h"
+#include <perf/symbol.h>
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 76253d7..6257d26 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -3,7 +3,7 @@
 
 #include <lk/util.h>
 #include "util/cache.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/thread.h"
 #include "util/header.h"
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 9303cab..8099157 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -38,7 +38,8 @@
 #include "perf.h"
 #include "builtin.h"
 #include <lk/strlist.h>
-#include "util/symbol.h"
+#include <perf/symbol.h>
+#include <perf/config.h>
 #include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99a71c5..ffde577 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -16,7 +16,7 @@
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/session.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 
 #include <lk/cpumap.h>
 #include <lk/util.h>
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2fa7635..a58efba 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -13,7 +13,7 @@
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/callchain.h"
 #include <lk/strlist.h>
 #include "util/values.h"
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a9ec0c3..c881900 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3,7 +3,7 @@
 
 #include <lk/util.h>
 #include "util/cache.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1f60239..fc4841d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -47,6 +47,7 @@
 #include "util/header.h"
 #include <lk/cpumap.h>
 #include "util/thread.h"
+#include <perf/config.h>
 
 #include <sys/prctl.h>
 #include <math.h>
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 035b9fa..cda894c 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -9,7 +9,7 @@
 #include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/session.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/thread.h"
 
 static long page_size;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c0e0dab..43cfc18 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -20,7 +20,7 @@
 #include <linux/list.h>
 #include "util/cache.h"
 #include <lk/rbtree.h>
-#include "util/symbol.h"
+#include <perf/symbol.h>
 #include "util/callchain.h"
 #include <lk/strlist.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 069d53c..bbdced1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -22,7 +22,7 @@
 
 #include <perf/color.h>
 #include "util/session.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index beebd43..a6c41c6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -7,7 +7,7 @@
 #include "util/header.h"
 #include "util/parse-options.h"
 #include "util/session.h"
-#include "util/symbol.h"
+#include <perf/config.h>
 #include "util/thread.h"
 #include "util/trace-event.h"
 #include <lk/util.h>
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index ce4c7d3..8a5d50f 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -10,7 +10,7 @@
 #include <stdio.h>
 #include "build-id.h"
 #include "event.h"
-#include "symbol.h"
+#include <perf/symbol.h>
 #include <lk/kernel.h>
 #include "debug.h"
 
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 5dafb00..1d981d6 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -5,6 +5,4 @@
 
 extern struct perf_event_ops build_id__mark_dso_hit_ops;
 
-char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
-
 #endif
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index e0d0dfb..0cd00dd 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 #include <lk/rbtree.h>
 #include "event.h"
-#include "symbol.h"
+#include <perf/symbol.h>
 
 enum chain_mode {
 	CHAIN_NONE,
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index a77dd3f..f348bf7 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -8,11 +8,11 @@
 
 #include "cache.h"
 #include <perf/color.h>
+#include <perf/config.h>
 #include "event.h"
 #include "debug.h"
 #include <lk/util.h>
 
-int verbose = 0;
 bool dump_trace = false;
 
 int eprintf(int level, const char *fmt, ...)
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 7a17ee0..40def5c 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,7 +5,6 @@
 #include <stdbool.h>
 #include "event.h"
 
-extern int verbose;
 extern bool dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 05587ce..f1e44f6 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -5,7 +5,7 @@
 #include <lk/kernel.h>
 
 #include "../perf.h"
-#include "map.h"
+#include <perf/map.h>
 
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c64df23..f233545 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -13,7 +13,7 @@
 #include "../perf.h"
 #include "trace-event.h"
 #include "session.h"
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "debug.h"
 
 static bool no_buildid_cache = false;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 587d375..8e4105b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include "callchain.h"
+#include <perf/config.h>
 
 extern struct callchain_param callchain_param;
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
deleted file mode 100644
index 3a7eb6e..0000000
--- a/tools/perf/util/map.c
+++ /dev/null
@@ -1,682 +0,0 @@
-#include "symbol.h"
-#include <errno.h>
-#include <limits.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdio.h>
-#include <unistd.h>
-#include "map.h"
-
-const char *map_type__name[MAP__NR_TYPES] = {
-	[MAP__FUNCTION] = "Functions",
-	[MAP__VARIABLE] = "Variables",
-};
-
-static inline int is_anon_memory(const char *filename)
-{
-	return strcmp(filename, "//anon") == 0;
-}
-
-void map__init(struct map *self, enum map_type type,
-	       u64 start, u64 end, u64 pgoff, struct dso *dso)
-{
-	self->type     = type;
-	self->start    = start;
-	self->end      = end;
-	self->pgoff    = pgoff;
-	self->dso      = dso;
-	self->map_ip   = map__map_ip;
-	self->unmap_ip = map__unmap_ip;
-	RB_CLEAR_NODE(&self->rb_node);
-	self->groups   = NULL;
-	self->referenced = false;
-}
-
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type)
-{
-	struct map *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		char newfilename[PATH_MAX];
-		struct dso *dso;
-		int anon;
-
-		anon = is_anon_memory(filename);
-
-		if (anon) {
-			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
-			filename = newfilename;
-		}
-
-		dso = __dsos__findnew(dsos__list, filename);
-		if (dso == NULL)
-			goto out_delete;
-
-		map__init(self, type, start, start + len, pgoff, dso);
-
-		if (anon) {
-set_identity:
-			self->map_ip = self->unmap_ip = identity__map_ip;
-		} else if (strcmp(filename, "[vdso]") == 0) {
-			dso__set_loaded(dso, self->type);
-			goto set_identity;
-		}
-	}
-	return self;
-out_delete:
-	free(self);
-	return NULL;
-}
-
-void map__delete(struct map *self)
-{
-	free(self);
-}
-
-void map__fixup_start(struct map *self)
-{
-	struct rb_root *symbols = &self->dso->symbols[self->type];
-	struct rb_node *nd = rb_first(symbols);
-	if (nd != NULL) {
-		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-		self->start = sym->start;
-	}
-}
-
-void map__fixup_end(struct map *self)
-{
-	struct rb_root *symbols = &self->dso->symbols[self->type];
-	struct rb_node *nd = rb_last(symbols);
-	if (nd != NULL) {
-		struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
-		self->end = sym->end;
-	}
-}
-
-#define DSO__DELETED "(deleted)"
-
-int map__load(struct map *self, symbol_filter_t filter)
-{
-	const char *name = self->dso->long_name;
-	int nr;
-
-	if (dso__loaded(self->dso, self->type))
-		return 0;
-
-	nr = dso__load(self->dso, self, filter);
-	if (nr < 0) {
-		if (self->dso->has_build_id) {
-			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-			build_id__sprintf(self->dso->build_id,
-					  sizeof(self->dso->build_id),
-					  sbuild_id);
-			pr_warning("%s with build id %s not found",
-				   name, sbuild_id);
-		} else
-			pr_warning("Failed to open %s", name);
-
-		pr_warning(", continuing without symbols\n");
-		return -1;
-	} else if (nr == 0) {
-		const size_t len = strlen(name);
-		const size_t real_len = len - sizeof(DSO__DELETED);
-
-		if (len > sizeof(DSO__DELETED) &&
-		    strcmp(name + real_len + 1, DSO__DELETED) == 0) {
-			pr_warning("%.*s was updated, restart the long "
-				   "running apps that use it!\n",
-				   (int)real_len, name);
-		} else {
-			pr_warning("no symbols found in %s, maybe install "
-				   "a debug package?\n", name);
-		}
-
-		return -1;
-	}
-	/*
-	 * Only applies to the kernel, as its symtabs aren't relative like the
-	 * module ones.
-	 */
-	if (self->dso->kernel)
-		map__reloc_vmlinux(self);
-
-	return 0;
-}
-
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter)
-{
-	if (map__load(self, filter) < 0)
-		return NULL;
-
-	return dso__find_symbol(self->dso, self->type, addr);
-}
-
-struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
-					symbol_filter_t filter)
-{
-	if (map__load(self, filter) < 0)
-		return NULL;
-
-	if (!dso__sorted_by_name(self->dso, self->type))
-		dso__sort_by_name(self->dso, self->type);
-
-	return dso__find_symbol_by_name(self->dso, self->type, name);
-}
-
-struct map *map__clone(struct map *self)
-{
-	struct map *map = malloc(sizeof(*self));
-
-	if (!map)
-		return NULL;
-
-	memcpy(map, self, sizeof(*self));
-
-	return map;
-}
-
-int map__overlap(struct map *l, struct map *r)
-{
-	if (l->start > r->start) {
-		struct map *t = l;
-		l = r;
-		r = t;
-	}
-
-	if (l->end > r->start)
-		return 1;
-
-	return 0;
-}
-
-size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
-/*
- * objdump wants/reports absolute IPs for ET_EXEC, and RIPs for ET_DYN.
- * map->dso->adjust_symbols==1 for ET_EXEC-like cases.
- */
-u64 map__rip_2objdump(struct map *map, u64 rip)
-{
-	u64 addr = map->dso->adjust_symbols ?
-			map->unmap_ip(map, rip) :	/* RIP -> IP */
-			rip;
-	return addr;
-}
-
-u64 map__objdump_2ip(struct map *map, u64 addr)
-{
-	u64 ip = map->dso->adjust_symbols ?
-			addr :
-			map->unmap_ip(map, addr);	/* RIP -> IP */
-	return ip;
-}
-
-void map_groups__init(struct map_groups *self)
-{
-	int i;
-	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		self->maps[i] = RB_ROOT;
-		INIT_LIST_HEAD(&self->removed_maps[i]);
-	}
-	self->machine = NULL;
-}
-
-static void maps__delete(struct rb_root *self)
-{
-	struct rb_node *next = rb_first(self);
-
-	while (next) {
-		struct map *pos = rb_entry(next, struct map, rb_node);
-
-		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
-		map__delete(pos);
-	}
-}
-
-static void maps__delete_removed(struct list_head *self)
-{
-	struct map *pos, *n;
-
-	list_for_each_entry_safe(pos, n, self, node) {
-		list_del(&pos->node);
-		map__delete(pos);
-	}
-}
-
-void map_groups__exit(struct map_groups *self)
-{
-	int i;
-
-	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		maps__delete(&self->maps[i]);
-		maps__delete_removed(&self->removed_maps[i]);
-	}
-}
-
-void map_groups__flush(struct map_groups *self)
-{
-	int type;
-
-	for (type = 0; type < MAP__NR_TYPES; type++) {
-		struct rb_root *root = &self->maps[type];
-		struct rb_node *next = rb_first(root);
-
-		while (next) {
-			struct map *pos = rb_entry(next, struct map, rb_node);
-			next = rb_next(&pos->rb_node);
-			rb_erase(&pos->rb_node, root);
-			/*
-			 * We may have references to this map, for
-			 * instance in some hist_entry instances, so
-			 * just move them to a separate list.
-			 */
-			list_add_tail(&pos->node, &self->removed_maps[pos->type]);
-		}
-	}
-}
-
-struct symbol *map_groups__find_symbol(struct map_groups *self,
-				       enum map_type type, u64 addr,
-				       struct map **mapp,
-				       symbol_filter_t filter)
-{
-	struct map *map = map_groups__find(self, type, addr);
-
-	if (map != NULL) {
-		if (mapp != NULL)
-			*mapp = map;
-		return map__find_symbol(map, map->map_ip(map, addr), filter);
-	}
-
-	return NULL;
-}
-
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
-					       enum map_type type,
-					       const char *name,
-					       struct map **mapp,
-					       symbol_filter_t filter)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node);
-		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
-
-		if (sym == NULL)
-			continue;
-		if (mapp != NULL)
-			*mapp = pos;
-		return sym;
-	}
-
-	return NULL;
-}
-
-size_t __map_groups__fprintf_maps(struct map_groups *self,
-				  enum map_type type, int verbose, FILE *fp)
-{
-	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
-		struct map *pos = rb_entry(nd, struct map, rb_node);
-		printed += fprintf(fp, "Map:");
-		printed += map__fprintf(pos, fp);
-		if (verbose > 2) {
-			printed += dso__fprintf(pos->dso, type, fp);
-			printed += fprintf(fp, "--\n");
-		}
-	}
-
-	return printed;
-}
-
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp)
-{
-	size_t printed = 0, i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(self, i, verbose, fp);
-	return printed;
-}
-
-static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
-						 enum map_type type,
-						 int verbose, FILE *fp)
-{
-	struct map *pos;
-	size_t printed = 0;
-
-	list_for_each_entry(pos, &self->removed_maps[type], node) {
-		printed += fprintf(fp, "Map:");
-		printed += map__fprintf(pos, fp);
-		if (verbose > 1) {
-			printed += dso__fprintf(pos->dso, type, fp);
-			printed += fprintf(fp, "--\n");
-		}
-	}
-	return printed;
-}
-
-static size_t map_groups__fprintf_removed_maps(struct map_groups *self,
-					       int verbose, FILE *fp)
-{
-	size_t printed = 0, i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(self, i, verbose, fp);
-	return printed;
-}
-
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp)
-{
-	size_t printed = map_groups__fprintf_maps(self, verbose, fp);
-	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(self, verbose, fp);
-}
-
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
-				   int verbose, FILE *fp)
-{
-	struct rb_root *root = &self->maps[map->type];
-	struct rb_node *next = rb_first(root);
-	int err = 0;
-
-	while (next) {
-		struct map *pos = rb_entry(next, struct map, rb_node);
-		next = rb_next(&pos->rb_node);
-
-		if (!map__overlap(pos, map))
-			continue;
-
-		if (verbose >= 2) {
-			fputs("overlapping maps:\n", fp);
-			map__fprintf(map, fp);
-			map__fprintf(pos, fp);
-		}
-
-		rb_erase(&pos->rb_node, root);
-		/*
-		 * Now check if we need to create new maps for areas not
-		 * overlapped by the new map:
-		 */
-		if (map->start > pos->start) {
-			struct map *before = map__clone(pos);
-
-			if (before == NULL) {
-				err = -ENOMEM;
-				goto move_map;
-			}
-
-			before->end = map->start - 1;
-			map_groups__insert(self, before);
-			if (verbose >= 2)
-				map__fprintf(before, fp);
-		}
-
-		if (map->end < pos->end) {
-			struct map *after = map__clone(pos);
-
-			if (after == NULL) {
-				err = -ENOMEM;
-				goto move_map;
-			}
-
-			after->start = map->end + 1;
-			map_groups__insert(self, after);
-			if (verbose >= 2)
-				map__fprintf(after, fp);
-		}
-move_map:
-		/*
-		 * If we have references, just move them to a separate list.
-		 */
-		if (pos->referenced)
-			list_add_tail(&pos->node, &self->removed_maps[map->type]);
-		else
-			map__delete(pos);
-
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/*
- * XXX This should not really _copy_ te maps, but refcount them.
- */
-int map_groups__clone(struct map_groups *self,
-		      struct map_groups *parent, enum map_type type)
-{
-	struct rb_node *nd;
-	for (nd = rb_first(&parent->maps[type]); nd; nd = rb_next(nd)) {
-		struct map *map = rb_entry(nd, struct map, rb_node);
-		struct map *new = map__clone(map);
-		if (new == NULL)
-			return -ENOMEM;
-		map_groups__insert(self, new);
-	}
-	return 0;
-}
-
-static u64 map__reloc_map_ip(struct map *map, u64 ip)
-{
-	return ip + (s64)map->pgoff;
-}
-
-static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
-{
-	return ip - (s64)map->pgoff;
-}
-
-void map__reloc_vmlinux(struct map *self)
-{
-	struct kmap *kmap = map__kmap(self);
-	s64 reloc;
-
-	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->unrelocated_addr)
-		return;
-
-	reloc = (kmap->ref_reloc_sym->unrelocated_addr -
-		 kmap->ref_reloc_sym->addr);
-
-	if (!reloc)
-		return;
-
-	self->map_ip   = map__reloc_map_ip;
-	self->unmap_ip = map__reloc_unmap_ip;
-	self->pgoff    = reloc;
-}
-
-void maps__insert(struct rb_root *maps, struct map *map)
-{
-	struct rb_node **p = &maps->rb_node;
-	struct rb_node *parent = NULL;
-	const u64 ip = map->start;
-	struct map *m;
-
-	while (*p != NULL) {
-		parent = *p;
-		m = rb_entry(parent, struct map, rb_node);
-		if (ip < m->start)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&map->rb_node, parent, p);
-	rb_insert_color(&map->rb_node, maps);
-}
-
-void maps__remove(struct rb_root *self, struct map *map)
-{
-	rb_erase(&map->rb_node, self);
-}
-
-struct map *maps__find(struct rb_root *maps, u64 ip)
-{
-	struct rb_node **p = &maps->rb_node;
-	struct rb_node *parent = NULL;
-	struct map *m;
-
-	while (*p != NULL) {
-		parent = *p;
-		m = rb_entry(parent, struct map, rb_node);
-		if (ip < m->start)
-			p = &(*p)->rb_left;
-		else if (ip > m->end)
-			p = &(*p)->rb_right;
-		else
-			return m;
-	}
-
-	return NULL;
-}
-
-int machine__init(struct machine *self, const char *root_dir, pid_t pid)
-{
-	map_groups__init(&self->kmaps);
-	RB_CLEAR_NODE(&self->rb_node);
-	INIT_LIST_HEAD(&self->user_dsos);
-	INIT_LIST_HEAD(&self->kernel_dsos);
-
-	self->kmaps.machine = self;
-	self->pid	    = pid;
-	self->root_dir      = strdup(root_dir);
-	return self->root_dir == NULL ? -ENOMEM : 0;
-}
-
-static void dsos__delete(struct list_head *self)
-{
-	struct dso *pos, *n;
-
-	list_for_each_entry_safe(pos, n, self, node) {
-		list_del(&pos->node);
-		dso__delete(pos);
-	}
-}
-
-void machine__exit(struct machine *self)
-{
-	map_groups__exit(&self->kmaps);
-	dsos__delete(&self->user_dsos);
-	dsos__delete(&self->kernel_dsos);
-	free(self->root_dir);
-	self->root_dir = NULL;
-}
-
-void machine__delete(struct machine *self)
-{
-	machine__exit(self);
-	free(self);
-}
-
-struct machine *machines__add(struct rb_root *self, pid_t pid,
-			      const char *root_dir)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct machine *pos, *machine = malloc(sizeof(*machine));
-
-	if (!machine)
-		return NULL;
-
-	if (machine__init(machine, root_dir, pid) != 0) {
-		free(machine);
-		return NULL;
-	}
-
-	while (*p != NULL) {
-		parent = *p;
-		pos = rb_entry(parent, struct machine, rb_node);
-		if (pid < pos->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&machine->rb_node, parent, p);
-	rb_insert_color(&machine->rb_node, self);
-
-	return machine;
-}
-
-struct machine *machines__find(struct rb_root *self, pid_t pid)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct machine *machine;
-	struct machine *default_machine = NULL;
-
-	while (*p != NULL) {
-		parent = *p;
-		machine = rb_entry(parent, struct machine, rb_node);
-		if (pid < machine->pid)
-			p = &(*p)->rb_left;
-		else if (pid > machine->pid)
-			p = &(*p)->rb_right;
-		else
-			return machine;
-		if (!machine->pid)
-			default_machine = machine;
-	}
-
-	return default_machine;
-}
-
-struct machine *machines__findnew(struct rb_root *self, pid_t pid)
-{
-	char path[PATH_MAX];
-	const char *root_dir;
-	struct machine *machine = machines__find(self, pid);
-
-	if (!machine || machine->pid != pid) {
-		if (pid == HOST_KERNEL_ID || pid == DEFAULT_GUEST_KERNEL_ID)
-			root_dir = "";
-		else {
-			if (!symbol_conf.guestmount)
-				goto out;
-			sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
-			if (access(path, R_OK)) {
-				pr_err("Can't access file %s\n", path);
-				goto out;
-			}
-			root_dir = path;
-		}
-		machine = machines__add(self, pid, root_dir);
-	}
-
-out:
-	return machine;
-}
-
-void machines__process(struct rb_root *self, machine__process_t process, void *data)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		process(pos, data);
-	}
-}
-
-char *machine__mmap_name(struct machine *self, char *bf, size_t size)
-{
-	if (machine__is_host(self))
-		snprintf(bf, size, "[%s]", "kernel.kallsyms");
-	else if (machine__is_default_guest(self))
-		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
-	else
-		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
-
-	return bf;
-}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
deleted file mode 100644
index efbff5b..0000000
--- a/tools/perf/util/map.h
+++ /dev/null
@@ -1,229 +0,0 @@
-#ifndef __PERF_MAP_H
-#define __PERF_MAP_H
-
-#include <lk/compiler.h>
-#include <linux/list.h>
-#include <stdio.h>
-#include <stdbool.h>
-#include <sys/types.h>
-#include <lk/types.h>
-#include <lk/rbtree.h>
-#include <lk/kernel.h>
-
-enum map_type {
-	MAP__FUNCTION = 0,
-	MAP__VARIABLE,
-};
-
-#define MAP__NR_TYPES (MAP__VARIABLE + 1)
-
-extern const char *map_type__name[MAP__NR_TYPES];
-
-struct dso;
-struct ref_reloc_sym;
-struct map_groups;
-struct machine;
-
-struct map {
-	union {
-		struct rb_node	rb_node;
-		struct list_head node;
-	};
-	u64			start;
-	u64			end;
-	u8 /* enum map_type */	type;
-	bool			referenced;
-	u32			priv;
-	u64			pgoff;
-
-	/* ip -> dso rip */
-	u64			(*map_ip)(struct map *, u64);
-	/* dso rip -> ip */
-	u64			(*unmap_ip)(struct map *, u64);
-
-	struct dso		*dso;
-	struct map_groups	*groups;
-};
-
-struct kmap {
-	struct ref_reloc_sym	*ref_reloc_sym;
-	struct map_groups	*kmaps;
-};
-
-struct map_groups {
-	struct rb_root	 maps[MAP__NR_TYPES];
-	struct list_head removed_maps[MAP__NR_TYPES];
-	struct machine	 *machine;
-};
-
-/* Native host kernel uses -1 as pid index in machine */
-#define	HOST_KERNEL_ID			(-1)
-#define	DEFAULT_GUEST_KERNEL_ID		(0)
-
-struct machine {
-	struct rb_node	  rb_node;
-	pid_t		  pid;
-	char		  *root_dir;
-	struct list_head  user_dsos;
-	struct list_head  kernel_dsos;
-	struct map_groups kmaps;
-	struct map	  *vmlinux_maps[MAP__NR_TYPES];
-};
-
-static inline
-struct map *machine__kernel_map(struct machine *self, enum map_type type)
-{
-	return self->vmlinux_maps[type];
-}
-
-static inline struct kmap *map__kmap(struct map *self)
-{
-	return (struct kmap *)(self + 1);
-}
-
-static inline u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static inline u64 map__unmap_ip(struct map *map, u64 ip)
-{
-	return ip + map->start - map->pgoff;
-}
-
-static inline u64 identity__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-
-/* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
-u64 map__rip_2objdump(struct map *map, u64 rip);
-u64 map__objdump_2ip(struct map *map, u64 addr);
-
-struct symbol;
-
-typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
-
-void map__init(struct map *self, enum map_type type,
-	       u64 start, u64 end, u64 pgoff, struct dso *dso);
-struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type);
-void map__delete(struct map *self);
-struct map *map__clone(struct map *self);
-int map__overlap(struct map *l, struct map *r);
-size_t map__fprintf(struct map *self, FILE *fp);
-
-int map__load(struct map *self, symbol_filter_t filter);
-struct symbol *map__find_symbol(struct map *self,
-				u64 addr, symbol_filter_t filter);
-struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
-					symbol_filter_t filter);
-void map__fixup_start(struct map *self);
-void map__fixup_end(struct map *self);
-
-void map__reloc_vmlinux(struct map *self);
-
-size_t __map_groups__fprintf_maps(struct map_groups *self,
-				  enum map_type type, int verbose, FILE *fp);
-void maps__insert(struct rb_root *maps, struct map *map);
-void maps__remove(struct rb_root *self, struct map *map);
-struct map *maps__find(struct rb_root *maps, u64 addr);
-void map_groups__init(struct map_groups *self);
-void map_groups__exit(struct map_groups *self);
-int map_groups__clone(struct map_groups *self,
-		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp);
-
-typedef void (*machine__process_t)(struct machine *self, void *data);
-
-void machines__process(struct rb_root *self, machine__process_t process, void *data);
-struct machine *machines__add(struct rb_root *self, pid_t pid,
-			      const char *root_dir);
-struct machine *machines__find_host(struct rb_root *self);
-struct machine *machines__find(struct rb_root *self, pid_t pid);
-struct machine *machines__findnew(struct rb_root *self, pid_t pid);
-char *machine__mmap_name(struct machine *self, char *bf, size_t size);
-int machine__init(struct machine *self, const char *root_dir, pid_t pid);
-void machine__exit(struct machine *self);
-void machine__delete(struct machine *self);
-
-/*
- * Default guest kernel is defined by parameter --guestkallsyms
- * and --guestmodules
- */
-static inline bool machine__is_default_guest(struct machine *self)
-{
-	return self ? self->pid == DEFAULT_GUEST_KERNEL_ID : false;
-}
-
-static inline bool machine__is_host(struct machine *self)
-{
-	return self ? self->pid == HOST_KERNEL_ID : false;
-}
-
-static inline void map_groups__insert(struct map_groups *self, struct map *map)
-{
-	maps__insert(&self->maps[map->type], map);
-	map->groups = self;
-}
-
-static inline void map_groups__remove(struct map_groups *self, struct map *map)
-{
-	maps__remove(&self->maps[map->type], map);
-}
-
-static inline struct map *map_groups__find(struct map_groups *self,
-					   enum map_type type, u64 addr)
-{
-	return maps__find(&self->maps[type], addr);
-}
-
-struct symbol *map_groups__find_symbol(struct map_groups *self,
-				       enum map_type type, u64 addr,
-				       struct map **mapp,
-				       symbol_filter_t filter);
-
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
-					       enum map_type type,
-					       const char *name,
-					       struct map **mapp,
-					       symbol_filter_t filter);
-
-static inline
-struct symbol *machine__find_kernel_symbol(struct machine *self,
-					   enum map_type type, u64 addr,
-					   struct map **mapp,
-					   symbol_filter_t filter)
-{
-	return map_groups__find_symbol(&self->kmaps, type, addr, mapp, filter);
-}
-
-static inline
-struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
-					     struct map **mapp,
-					     symbol_filter_t filter)
-{
-	return machine__find_kernel_symbol(self, MAP__FUNCTION, addr, mapp, filter);
-}
-
-static inline
-struct symbol *map_groups__find_function_by_name(struct map_groups *self,
-						 const char *name, struct map **mapp,
-						 symbol_filter_t filter)
-{
-	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
-}
-
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
-				   int verbose, FILE *fp);
-
-struct map *map_groups__find_by_name(struct map_groups *self,
-				     enum map_type type, const char *name);
-struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
-
-void map_groups__flush(struct map_groups *self);
-
-#endif /* __PERF_MAP_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 01686b5..ad36237 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -7,7 +7,7 @@
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "cache.h"
 #include "header.h"
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a6c8d3e..577944c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -42,7 +42,7 @@
 #include "debug.h"
 #include "cache.h"
 #include <perf/color.h>
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "thread.h"
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c7a8bdb..1c23a9d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -36,7 +36,7 @@
 #include "event.h"
 #include "debug.h"
 #include <lk/util.h>
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "probe-finder.h"
 
 /* Kprobe tracer basic type is up to u64 */
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6f2af58..950cea2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -4,7 +4,7 @@
 #include "hist.h"
 #include "event.h"
 #include "header.h"
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "thread.h"
 #include <lk/rbtree.h>
 #include "../../../include/linux/perf_event.h"
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e2fb61a..cc461d6 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include "cache.h"
 #include <lk/rbtree.h>
-#include "symbol.h"
+#include <perf/symbol.h>
 #include "string.h"
 #include "callchain.h"
 #include <lk/strlist.h>
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
deleted file mode 100644
index 0319325..0000000
--- a/tools/perf/util/symbol.c
+++ /dev/null
@@ -1,2459 +0,0 @@
-#define _GNU_SOURCE
-#include <ctype.h>
-#include <dirent.h>
-#include <errno.h>
-#include <libgen.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/param.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include "build-id.h"
-#include "debug.h"
-#include "symbol.h"
-#include <lk/strlist.h>
-
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
-#include <limits.h>
-#include <sys/utsname.h>
-
-#ifndef NT_GNU_BUILD_ID
-#define NT_GNU_BUILD_ID 3
-#endif
-
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
-static int elf_read_build_id(Elf *elf, void *bf, size_t size);
-static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter);
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
-			symbol_filter_t filter);
-static int vmlinux_path__nr_entries;
-static char **vmlinux_path;
-
-struct symbol_conf symbol_conf = {
-	.exclude_other	  = true,
-	.use_modules	  = true,
-	.try_vmlinux_path = true,
-};
-
-int dso__name_len(const struct dso *self)
-{
-	if (verbose)
-		return self->long_name_len;
-
-	return self->short_name_len;
-}
-
-bool dso__loaded(const struct dso *self, enum map_type type)
-{
-	return self->loaded & (1 << type);
-}
-
-bool dso__sorted_by_name(const struct dso *self, enum map_type type)
-{
-	return self->sorted_by_name & (1 << type);
-}
-
-static void dso__set_sorted_by_name(struct dso *self, enum map_type type)
-{
-	self->sorted_by_name |= (1 << type);
-}
-
-bool symbol_type__is_a(char symbol_type, enum map_type map_type)
-{
-	switch (map_type) {
-	case MAP__FUNCTION:
-		return symbol_type == 'T' || symbol_type == 'W';
-	case MAP__VARIABLE:
-		return symbol_type == 'D' || symbol_type == 'd';
-	default:
-		return false;
-	}
-}
-
-static void symbols__fixup_end(struct rb_root *self)
-{
-	struct rb_node *nd, *prevnd = rb_first(self);
-	struct symbol *curr, *prev;
-
-	if (prevnd == NULL)
-		return;
-
-	curr = rb_entry(prevnd, struct symbol, rb_node);
-
-	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
-		prev = curr;
-		curr = rb_entry(nd, struct symbol, rb_node);
-
-		if (prev->end == prev->start)
-			prev->end = curr->start - 1;
-	}
-
-	/* Last entry */
-	if (curr->end == curr->start)
-		curr->end = roundup(curr->start, 4096);
-}
-
-static void __map_groups__fixup_end(struct map_groups *self, enum map_type type)
-{
-	struct map *prev, *curr;
-	struct rb_node *nd, *prevnd = rb_first(&self->maps[type]);
-
-	if (prevnd == NULL)
-		return;
-
-	curr = rb_entry(prevnd, struct map, rb_node);
-
-	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
-		prev = curr;
-		curr = rb_entry(nd, struct map, rb_node);
-		prev->end = curr->start - 1;
-	}
-
-	/*
-	 * We still haven't the actual symbols, so guess the
-	 * last map final address.
-	 */
-	curr->end = ~0UL;
-}
-
-static void map_groups__fixup_end(struct map_groups *self)
-{
-	int i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__map_groups__fixup_end(self, i);
-}
-
-static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
-				  const char *name)
-{
-	size_t namelen = strlen(name) + 1;
-	struct symbol *self = calloc(1, (symbol_conf.priv_size +
-					 sizeof(*self) + namelen));
-	if (self == NULL)
-		return NULL;
-
-	if (symbol_conf.priv_size)
-		self = ((void *)self) + symbol_conf.priv_size;
-
-	self->start   = start;
-	self->end     = len ? start + len - 1 : start;
-	self->binding = binding;
-	self->namelen = namelen - 1;
-
-	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
-
-	memcpy(self->name, name, namelen);
-
-	return self;
-}
-
-void symbol__delete(struct symbol *self)
-{
-	free(((void *)self) - symbol_conf.priv_size);
-}
-
-static size_t symbol__fprintf(struct symbol *self, FILE *fp)
-{
-	return fprintf(fp, " %llx-%llx %c %s\n",
-		       self->start, self->end,
-		       self->binding == STB_GLOBAL ? 'g' :
-		       self->binding == STB_LOCAL  ? 'l' : 'w',
-		       self->name);
-}
-
-void dso__set_long_name(struct dso *self, char *name)
-{
-	if (name == NULL)
-		return;
-	self->long_name = name;
-	self->long_name_len = strlen(name);
-}
-
-static void dso__set_short_name(struct dso *self, const char *name)
-{
-	if (name == NULL)
-		return;
-	self->short_name = name;
-	self->short_name_len = strlen(name);
-}
-
-static void dso__set_basename(struct dso *self)
-{
-	dso__set_short_name(self, basename(self->long_name));
-}
-
-struct dso *dso__new(const char *name)
-{
-	struct dso *self = calloc(1, sizeof(*self) + strlen(name) + 1);
-
-	if (self != NULL) {
-		int i;
-		strcpy(self->name, name);
-		dso__set_long_name(self, self->name);
-		dso__set_short_name(self, self->name);
-		for (i = 0; i < MAP__NR_TYPES; ++i)
-			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->slen_calculated = 0;
-		self->origin = DSO__ORIG_NOT_FOUND;
-		self->loaded = 0;
-		self->sorted_by_name = 0;
-		self->has_build_id = 0;
-		self->kernel = DSO_TYPE_USER;
-		INIT_LIST_HEAD(&self->node);
-	}
-
-	return self;
-}
-
-static void symbols__delete(struct rb_root *self)
-{
-	struct symbol *pos;
-	struct rb_node *next = rb_first(self);
-
-	while (next) {
-		pos = rb_entry(next, struct symbol, rb_node);
-		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
-		symbol__delete(pos);
-	}
-}
-
-void dso__delete(struct dso *self)
-{
-	int i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		symbols__delete(&self->symbols[i]);
-	if (self->sname_alloc)
-		free((char *)self->short_name);
-	if (self->lname_alloc)
-		free(self->long_name);
-	free(self);
-}
-
-void dso__set_build_id(struct dso *self, void *build_id)
-{
-	memcpy(self->build_id, build_id, sizeof(self->build_id));
-	self->has_build_id = 1;
-}
-
-static void symbols__insert(struct rb_root *self, struct symbol *sym)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	const u64 ip = sym->start;
-	struct symbol *s;
-
-	while (*p != NULL) {
-		parent = *p;
-		s = rb_entry(parent, struct symbol, rb_node);
-		if (ip < s->start)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&sym->rb_node, parent, p);
-	rb_insert_color(&sym->rb_node, self);
-}
-
-static struct symbol *symbols__find(struct rb_root *self, u64 ip)
-{
-	struct rb_node *n;
-
-	if (self == NULL)
-		return NULL;
-
-	n = self->rb_node;
-
-	while (n) {
-		struct symbol *s = rb_entry(n, struct symbol, rb_node);
-
-		if (ip < s->start)
-			n = n->rb_left;
-		else if (ip > s->end)
-			n = n->rb_right;
-		else
-			return s;
-	}
-
-	return NULL;
-}
-
-struct symbol_name_rb_node {
-	struct rb_node	rb_node;
-	struct symbol	sym;
-};
-
-static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
-
-	while (*p != NULL) {
-		parent = *p;
-		s = rb_entry(parent, struct symbol_name_rb_node, rb_node);
-		if (strcmp(sym->name, s->sym.name) < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-	rb_link_node(&symn->rb_node, parent, p);
-	rb_insert_color(&symn->rb_node, self);
-}
-
-static void symbols__sort_by_name(struct rb_root *self, struct rb_root *source)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(source); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		symbols__insert_by_name(self, pos);
-	}
-}
-
-static struct symbol *symbols__find_by_name(struct rb_root *self, const char *name)
-{
-	struct rb_node *n;
-
-	if (self == NULL)
-		return NULL;
-
-	n = self->rb_node;
-
-	while (n) {
-		struct symbol_name_rb_node *s;
-		int cmp;
-
-		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
-		cmp = strcmp(name, s->sym.name);
-
-		if (cmp < 0)
-			n = n->rb_left;
-		else if (cmp > 0)
-			n = n->rb_right;
-		else
-			return &s->sym;
-	}
-
-	return NULL;
-}
-
-struct symbol *dso__find_symbol(struct dso *self,
-				enum map_type type, u64 addr)
-{
-	return symbols__find(&self->symbols[type], addr);
-}
-
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
-					const char *name)
-{
-	return symbols__find_by_name(&self->symbol_names[type], name);
-}
-
-void dso__sort_by_name(struct dso *self, enum map_type type)
-{
-	dso__set_sorted_by_name(self, type);
-	return symbols__sort_by_name(&self->symbol_names[type],
-				     &self->symbols[type]);
-}
-
-int build_id__sprintf(const u8 *self, int len, char *bf)
-{
-	char *bid = bf;
-	const u8 *raw = self;
-	int i;
-
-	for (i = 0; i < len; ++i) {
-		sprintf(bid, "%02x", *raw);
-		++raw;
-		bid += 2;
-	}
-
-	return raw - self;
-}
-
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
-{
-	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
-	return fprintf(fp, "%s", sbuild_id);
-}
-
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
-{
-	struct rb_node *nd;
-	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
-
-	if (self->short_name != self->long_name)
-		ret += fprintf(fp, "%s, ", self->long_name);
-	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       self->loaded ? "" : "NOT ");
-	ret += dso__fprintf_buildid(self, fp);
-	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		ret += symbol__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
-int kallsyms__parse(const char *filename, void *arg,
-		    int (*process_symbol)(void *arg, const char *name,
-						     char type, u64 start))
-{
-	char *line = NULL;
-	size_t n;
-	int err = 0;
-	FILE *file = fopen(filename, "r");
-
-	if (file == NULL)
-		goto out_failure;
-
-	while (!feof(file)) {
-		u64 start;
-		int line_len, len;
-		char symbol_type;
-		char *symbol_name;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0 || !line)
-			break;
-
-		line[--line_len] = '\0'; /* \n */
-
-		len = hex2u64(line, &start);
-
-		len++;
-		if (len + 2 >= line_len)
-			continue;
-
-		symbol_type = toupper(line[len]);
-		symbol_name = line + len + 2;
-
-		err = process_symbol(arg, symbol_name, symbol_type, start);
-		if (err)
-			break;
-	}
-
-	free(line);
-	fclose(file);
-	return err;
-
-out_failure:
-	return -1;
-}
-
-struct process_kallsyms_args {
-	struct map *map;
-	struct dso *dso;
-};
-
-static u8 kallsyms2elf_type(char type)
-{
-	if (type == 'W')
-		return STB_WEAK;
-
-	return isupper(type) ? STB_GLOBAL : STB_LOCAL;
-}
-
-static int map__process_kallsym_symbol(void *arg, const char *name,
-				       char type, u64 start)
-{
-	struct symbol *sym;
-	struct process_kallsyms_args *a = arg;
-	struct rb_root *root = &a->dso->symbols[a->map->type];
-
-	if (!symbol_type__is_a(type, a->map->type))
-		return 0;
-
-	/*
-	 * Will fix up the end later, when we have all symbols sorted.
-	 */
-	sym = symbol__new(start, 0, kallsyms2elf_type(type), name);
-
-	if (sym == NULL)
-		return -ENOMEM;
-	/*
-	 * We will pass the symbols to the filter later, in
-	 * map__split_kallsyms, when we have split the maps per module
-	 */
-	symbols__insert(root, sym);
-
-	return 0;
-}
-
-/*
- * Loads the function entries in /proc/kallsyms into kernel_map->dso,
- * so that we can in the next step set the symbol ->end address and then
- * call kernel_maps__split_kallsyms.
- */
-static int dso__load_all_kallsyms(struct dso *self, const char *filename,
-				  struct map *map)
-{
-	struct process_kallsyms_args args = { .map = map, .dso = self, };
-	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
-}
-
-/*
- * Split the symbols into maps, making sure there are no overlaps, i.e. the
- * kernel range is broken in several maps, named [kernel].N, as we don't have
- * the original ELF section names vmlinux have.
- */
-static int dso__split_kallsyms(struct dso *self, struct map *map,
-			       symbol_filter_t filter)
-{
-	struct map_groups *kmaps = map__kmap(map)->kmaps;
-	struct machine *machine = kmaps->machine;
-	struct map *curr_map = map;
-	struct symbol *pos;
-	int count = 0;
-	struct rb_root *root = &self->symbols[map->type];
-	struct rb_node *next = rb_first(root);
-	int kernel_range = 0;
-
-	while (next) {
-		char *module;
-
-		pos = rb_entry(next, struct symbol, rb_node);
-		next = rb_next(&pos->rb_node);
-
-		module = strchr(pos->name, '\t');
-		if (module) {
-			if (!symbol_conf.use_modules)
-				goto discard_symbol;
-
-			*module++ = '\0';
-
-			if (strcmp(curr_map->dso->short_name, module)) {
-				if (curr_map != map &&
-				    self->kernel == DSO_TYPE_GUEST_KERNEL &&
-				    machine__is_default_guest(machine)) {
-					/*
-					 * We assume all symbols of a module are
-					 * continuous in * kallsyms, so curr_map
-					 * points to a module and all its
-					 * symbols are in its kmap. Mark it as
-					 * loaded.
-					 */
-					dso__set_loaded(curr_map->dso,
-							curr_map->type);
-				}
-
-				curr_map = map_groups__find_by_name(kmaps,
-							map->type, module);
-				if (curr_map == NULL) {
-					pr_debug("%s/proc/{kallsyms,modules} "
-					         "inconsistency while looking "
-						 "for \"%s\" module!\n",
-						 machine->root_dir, module);
-					curr_map = map;
-					goto discard_symbol;
-				}
-
-				if (curr_map->dso->loaded &&
-				    !machine__is_default_guest(machine))
-					goto discard_symbol;
-			}
-			/*
-			 * So that we look just like we get from .ko files,
-			 * i.e. not prelinked, relative to map->start.
-			 */
-			pos->start = curr_map->map_ip(curr_map, pos->start);
-			pos->end   = curr_map->map_ip(curr_map, pos->end);
-		} else if (curr_map != map) {
-			char dso_name[PATH_MAX];
-			struct dso *dso;
-
-			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-				snprintf(dso_name, sizeof(dso_name),
-					"[guest.kernel].%d",
-					kernel_range++);
-			else
-				snprintf(dso_name, sizeof(dso_name),
-					"[kernel].%d",
-					kernel_range++);
-
-			dso = dso__new(dso_name);
-			if (dso == NULL)
-				return -1;
-
-			dso->kernel = self->kernel;
-
-			curr_map = map__new2(pos->start, dso, map->type);
-			if (curr_map == NULL) {
-				dso__delete(dso);
-				return -1;
-			}
-
-			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			map_groups__insert(kmaps, curr_map);
-			++kernel_range;
-		}
-
-		if (filter && filter(curr_map, pos)) {
-discard_symbol:		rb_erase(&pos->rb_node, root);
-			symbol__delete(pos);
-		} else {
-			if (curr_map != map) {
-				rb_erase(&pos->rb_node, root);
-				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
-			}
-			count++;
-		}
-	}
-
-	if (curr_map != map &&
-	    self->kernel == DSO_TYPE_GUEST_KERNEL &&
-	    machine__is_default_guest(kmaps->machine)) {
-		dso__set_loaded(curr_map->dso, curr_map->type);
-	}
-
-	return count;
-}
-
-int dso__load_kallsyms(struct dso *self, const char *filename,
-		       struct map *map, symbol_filter_t filter)
-{
-	if (dso__load_all_kallsyms(self, filename, map) < 0)
-		return -1;
-
-	symbols__fixup_end(&self->symbols[map->type]);
-	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		self->origin = DSO__ORIG_GUEST_KERNEL;
-	else
-		self->origin = DSO__ORIG_KERNEL;
-
-	return dso__split_kallsyms(self, map, filter);
-}
-
-static int dso__load_perf_map(struct dso *self, struct map *map,
-			      symbol_filter_t filter)
-{
-	char *line = NULL;
-	size_t n;
-	FILE *file;
-	int nr_syms = 0;
-
-	file = fopen(self->long_name, "r");
-	if (file == NULL)
-		goto out_failure;
-
-	while (!feof(file)) {
-		u64 start, size;
-		struct symbol *sym;
-		int line_len, len;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0)
-			break;
-
-		if (!line)
-			goto out_failure;
-
-		line[--line_len] = '\0'; /* \n */
-
-		len = hex2u64(line, &start);
-
-		len++;
-		if (len + 2 >= line_len)
-			continue;
-
-		len += hex2u64(line + len, &size);
-
-		len++;
-		if (len + 2 >= line_len)
-			continue;
-
-		sym = symbol__new(start, size, STB_GLOBAL, line + len);
-
-		if (sym == NULL)
-			goto out_delete_line;
-
-		if (filter && filter(map, sym))
-			symbol__delete(sym);
-		else {
-			symbols__insert(&self->symbols[map->type], sym);
-			nr_syms++;
-		}
-	}
-
-	free(line);
-	fclose(file);
-
-	return nr_syms;
-
-out_delete_line:
-	free(line);
-out_failure:
-	return -1;
-}
-
-/**
- * elf_symtab__for_each_symbol - iterate thru all the symbols
- *
- * @self: struct elf_symtab instance to iterate
- * @idx: uint32_t idx
- * @sym: GElf_Sym iterator
- */
-#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
-	for (idx = 0, gelf_getsym(syms, idx, &sym);\
-	     idx < nr_syms; \
-	     idx++, gelf_getsym(syms, idx, &sym))
-
-static inline uint8_t elf_sym__type(const GElf_Sym *sym)
-{
-	return GELF_ST_TYPE(sym->st_info);
-}
-
-static inline int elf_sym__is_function(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_FUNC &&
-	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF;
-}
-
-static inline bool elf_sym__is_object(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_OBJECT &&
-		sym->st_name != 0 &&
-		sym->st_shndx != SHN_UNDEF;
-}
-
-static inline int elf_sym__is_label(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_NOTYPE &&
-		sym->st_name != 0 &&
-		sym->st_shndx != SHN_UNDEF &&
-		sym->st_shndx != SHN_ABS;
-}
-
-static inline const char *elf_sec__name(const GElf_Shdr *shdr,
-					const Elf_Data *secstrs)
-{
-	return secstrs->d_buf + shdr->sh_name;
-}
-
-static inline int elf_sec__is_text(const GElf_Shdr *shdr,
-					const Elf_Data *secstrs)
-{
-	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
-}
-
-static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
-				    const Elf_Data *secstrs)
-{
-	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
-}
-
-static inline const char *elf_sym__name(const GElf_Sym *sym,
-					const Elf_Data *symstrs)
-{
-	return symstrs->d_buf + sym->st_name;
-}
-
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name,
-				    size_t *idx)
-{
-	Elf_Scn *sec = NULL;
-	size_t cnt = 1;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		char *str;
-
-		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
-			if (idx)
-				*idx = cnt;
-			break;
-		}
-		++cnt;
-	}
-
-	return sec;
-}
-
-#define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
-	for (idx = 0, pos = gelf_getrel(reldata, 0, &pos_mem); \
-	     idx < nr_entries; \
-	     ++idx, pos = gelf_getrel(reldata, idx, &pos_mem))
-
-#define elf_section__for_each_rela(reldata, pos, pos_mem, idx, nr_entries) \
-	for (idx = 0, pos = gelf_getrela(reldata, 0, &pos_mem); \
-	     idx < nr_entries; \
-	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
-
-/*
- * We need to check if we have a .dynsym, so that we can handle the
- * .plt, synthesizing its symbols, that aren't on the symtabs (be it
- * .dynsym or .symtab).
- * And always look at the original dso, not at debuginfo packages, that
- * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
- */
-static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
-				       symbol_filter_t filter)
-{
-	uint32_t nr_rel_entries, idx;
-	GElf_Sym sym;
-	u64 plt_offset;
-	GElf_Shdr shdr_plt;
-	struct symbol *f;
-	GElf_Shdr shdr_rel_plt, shdr_dynsym;
-	Elf_Data *reldata, *syms, *symstrs;
-	Elf_Scn *scn_plt_rel, *scn_symstrs, *scn_dynsym;
-	size_t dynsym_idx;
-	GElf_Ehdr ehdr;
-	char sympltname[1024];
-	Elf *elf;
-	int nr = 0, symidx, fd, err = 0;
-
-	fd = open(self->long_name, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL)
-		goto out_close;
-
-	if (gelf_getehdr(elf, &ehdr) == NULL)
-		goto out_elf_end;
-
-	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
-					 ".dynsym", &dynsym_idx);
-	if (scn_dynsym == NULL)
-		goto out_elf_end;
-
-	scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
-					  ".rela.plt", NULL);
-	if (scn_plt_rel == NULL) {
-		scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
-						  ".rel.plt", NULL);
-		if (scn_plt_rel == NULL)
-			goto out_elf_end;
-	}
-
-	err = -1;
-
-	if (shdr_rel_plt.sh_link != dynsym_idx)
-		goto out_elf_end;
-
-	if (elf_section_by_name(elf, &ehdr, &shdr_plt, ".plt", NULL) == NULL)
-		goto out_elf_end;
-
-	/*
-	 * Fetch the relocation section to find the idxes to the GOT
-	 * and the symbols in the .dynsym they refer to.
-	 */
-	reldata = elf_getdata(scn_plt_rel, NULL);
-	if (reldata == NULL)
-		goto out_elf_end;
-
-	syms = elf_getdata(scn_dynsym, NULL);
-	if (syms == NULL)
-		goto out_elf_end;
-
-	scn_symstrs = elf_getscn(elf, shdr_dynsym.sh_link);
-	if (scn_symstrs == NULL)
-		goto out_elf_end;
-
-	symstrs = elf_getdata(scn_symstrs, NULL);
-	if (symstrs == NULL)
-		goto out_elf_end;
-
-	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
-	plt_offset = shdr_plt.sh_offset;
-
-	if (shdr_rel_plt.sh_type == SHT_RELA) {
-		GElf_Rela pos_mem, *pos;
-
-		elf_section__for_each_rela(reldata, pos, pos_mem, idx,
-					   nr_rel_entries) {
-			symidx = GELF_R_SYM(pos->r_info);
-			plt_offset += shdr_plt.sh_entsize;
-			gelf_getsym(syms, symidx, &sym);
-			snprintf(sympltname, sizeof(sympltname),
-				 "%s@plt", elf_sym__name(&sym, symstrs));
-
-			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					STB_GLOBAL, sympltname);
-			if (!f)
-				goto out_elf_end;
-
-			if (filter && filter(map, f))
-				symbol__delete(f);
-			else {
-				symbols__insert(&self->symbols[map->type], f);
-				++nr;
-			}
-		}
-	} else if (shdr_rel_plt.sh_type == SHT_REL) {
-		GElf_Rel pos_mem, *pos;
-		elf_section__for_each_rel(reldata, pos, pos_mem, idx,
-					  nr_rel_entries) {
-			symidx = GELF_R_SYM(pos->r_info);
-			plt_offset += shdr_plt.sh_entsize;
-			gelf_getsym(syms, symidx, &sym);
-			snprintf(sympltname, sizeof(sympltname),
-				 "%s@plt", elf_sym__name(&sym, symstrs));
-
-			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					STB_GLOBAL, sympltname);
-			if (!f)
-				goto out_elf_end;
-
-			if (filter && filter(map, f))
-				symbol__delete(f);
-			else {
-				symbols__insert(&self->symbols[map->type], f);
-				++nr;
-			}
-		}
-	}
-
-	err = 0;
-out_elf_end:
-	elf_end(elf);
-out_close:
-	close(fd);
-
-	if (err == 0)
-		return nr;
-out:
-	pr_debug("%s: problems reading %s PLT info.\n",
-		 __func__, self->long_name);
-	return 0;
-}
-
-static bool elf_sym__is_a(GElf_Sym *self, enum map_type type)
-{
-	switch (type) {
-	case MAP__FUNCTION:
-		return elf_sym__is_function(self);
-	case MAP__VARIABLE:
-		return elf_sym__is_object(self);
-	default:
-		return false;
-	}
-}
-
-static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type)
-{
-	switch (type) {
-	case MAP__FUNCTION:
-		return elf_sec__is_text(self, secstrs);
-	case MAP__VARIABLE:
-		return elf_sec__is_data(self, secstrs);
-	default:
-		return false;
-	}
-}
-
-static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
-{
-	Elf_Scn *sec = NULL;
-	GElf_Shdr shdr;
-	size_t cnt = 1;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		gelf_getshdr(sec, &shdr);
-
-		if ((addr >= shdr.sh_addr) &&
-		    (addr < (shdr.sh_addr + shdr.sh_size)))
-			return cnt;
-
-		++cnt;
-	}
-
-	return -1;
-}
-
-static int dso__load_sym(struct dso *self, struct map *map, const char *name,
-			 int fd, symbol_filter_t filter, int kmodule,
-			 int want_symtab)
-{
-	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
-	struct map *curr_map = map;
-	struct dso *curr_dso = self;
-	Elf_Data *symstrs, *secstrs;
-	uint32_t nr_syms;
-	int err = -1;
-	uint32_t idx;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr, opdshdr;
-	Elf_Data *syms, *opddata = NULL;
-	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx, *opdsec;
-	Elf *elf;
-	int nr = 0;
-	size_t opdidx = 0;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
-		goto out_close;
-	}
-
-	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		pr_debug("%s: cannot get elf header.\n", __func__);
-		goto out_elf_end;
-	}
-
-	/* Always reject images with a mismatched build-id: */
-	if (self->has_build_id) {
-		u8 build_id[BUILD_ID_SIZE];
-
-		if (elf_read_build_id(elf, build_id,
-				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
-			goto out_elf_end;
-
-		if (!dso__build_id_equal(self, build_id))
-			goto out_elf_end;
-	}
-
-	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
-	if (sec == NULL) {
-		if (want_symtab)
-			goto out_elf_end;
-
-		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
-		if (sec == NULL)
-			goto out_elf_end;
-	}
-
-	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
-	if (opdsec)
-		opddata = elf_rawdata(opdsec, NULL);
-
-	syms = elf_getdata(sec, NULL);
-	if (syms == NULL)
-		goto out_elf_end;
-
-	sec = elf_getscn(elf, shdr.sh_link);
-	if (sec == NULL)
-		goto out_elf_end;
-
-	symstrs = elf_getdata(sec, NULL);
-	if (symstrs == NULL)
-		goto out_elf_end;
-
-	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
-	if (sec_strndx == NULL)
-		goto out_elf_end;
-
-	secstrs = elf_getdata(sec_strndx, NULL);
-	if (secstrs == NULL)
-		goto out_elf_end;
-
-	nr_syms = shdr.sh_size / shdr.sh_entsize;
-
-	memset(&sym, 0, sizeof(sym));
-	if (self->kernel == DSO_TYPE_USER) {
-		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
-				elf_section_by_name(elf, &ehdr, &shdr,
-						     ".gnu.prelink_undo",
-						     NULL) != NULL);
-	} else self->adjust_symbols = 0;
-
-	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
-		struct symbol *f;
-		const char *elf_name = elf_sym__name(&sym, symstrs);
-		char *demangled = NULL;
-		int is_label = elf_sym__is_label(&sym);
-		const char *section_name;
-
-		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
-		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
-			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
-
-		if (!is_label && !elf_sym__is_a(&sym, map->type))
-			continue;
-
-		/* Reject ARM ELF "mapping symbols": these aren't unique and
-		 * don't identify functions, so will confuse the profile
-		 * output: */
-		if (ehdr.e_machine == EM_ARM) {
-			if (!strcmp(elf_name, "$a") ||
-			    !strcmp(elf_name, "$d") ||
-			    !strcmp(elf_name, "$t"))
-				continue;
-		}
-
-		if (opdsec && sym.st_shndx == opdidx) {
-			u32 offset = sym.st_value - opdshdr.sh_addr;
-			u64 *opd = opddata->d_buf + offset;
-			sym.st_value = *opd;
-			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
-		}
-
-		sec = elf_getscn(elf, sym.st_shndx);
-		if (!sec)
-			goto out_elf_end;
-
-		gelf_getshdr(sec, &shdr);
-
-		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
-			continue;
-
-		section_name = elf_sec__name(&shdr, secstrs);
-
-		if (self->kernel != DSO_TYPE_USER || kmodule) {
-			char dso_name[PATH_MAX];
-
-			if (strcmp(section_name,
-				   (curr_dso->short_name +
-				    self->short_name_len)) == 0)
-				goto new_symbol;
-
-			if (strcmp(section_name, ".text") == 0) {
-				curr_map = map;
-				curr_dso = self;
-				goto new_symbol;
-			}
-
-			snprintf(dso_name, sizeof(dso_name),
-				 "%s%s", self->short_name, section_name);
-
-			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
-			if (curr_map == NULL) {
-				u64 start = sym.st_value;
-
-				if (kmodule)
-					start += map->start + shdr.sh_offset;
-
-				curr_dso = dso__new(dso_name);
-				if (curr_dso == NULL)
-					goto out_elf_end;
-				curr_dso->kernel = self->kernel;
-				curr_map = map__new2(start, curr_dso,
-						     map->type);
-				if (curr_map == NULL) {
-					dso__delete(curr_dso);
-					goto out_elf_end;
-				}
-				curr_map->map_ip = identity__map_ip;
-				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->origin = self->origin;
-				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&self->node, curr_dso);
-				dso__set_loaded(curr_dso, map->type);
-			} else
-				curr_dso = curr_map->dso;
-
-			goto new_symbol;
-		}
-
-		if (curr_dso->adjust_symbols) {
-			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
-				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
-		}
-		/*
-		 * We need to figure out if the object was created from C++ sources
-		 * DWARF DW_compile_unit has this, but we don't always have access
-		 * to it...
-		 */
-		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
-		if (demangled != NULL)
-			elf_name = demangled;
-new_symbol:
-		f = symbol__new(sym.st_value, sym.st_size,
-				GELF_ST_BIND(sym.st_info), elf_name);
-		free(demangled);
-		if (!f)
-			goto out_elf_end;
-
-		if (filter && filter(curr_map, f))
-			symbol__delete(f);
-		else {
-			symbols__insert(&curr_dso->symbols[curr_map->type], f);
-			nr++;
-		}
-	}
-
-	/*
-	 * For misannotated, zeroed, ASM function sizes.
-	 */
-	if (nr > 0) {
-		symbols__fixup_end(&self->symbols[map->type]);
-		if (kmap) {
-			/*
-			 * We need to fixup this here too because we create new
-			 * maps here, for things like vsyscall sections.
-			 */
-			__map_groups__fixup_end(kmap->kmaps, map->type);
-		}
-	}
-	err = nr;
-out_elf_end:
-	elf_end(elf);
-out_close:
-	return err;
-}
-
-static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
-{
-	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
-}
-
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
-{
-	bool have_build_id = false;
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node) {
-		if (with_hits && !pos->hit)
-			continue;
-		if (pos->has_build_id) {
-			have_build_id = true;
-			continue;
-		}
-		if (filename__read_build_id(pos->long_name, pos->build_id,
-					    sizeof(pos->build_id)) > 0) {
-			have_build_id	  = true;
-			pos->has_build_id = true;
-		}
-	}
-
-	return have_build_id;
-}
-
-/*
- * Align offset to 4 bytes as needed for note name and descriptor data.
- */
-#define NOTE_ALIGN(n) (((n) + 3) & -4U)
-
-static int elf_read_build_id(Elf *elf, void *bf, size_t size)
-{
-	int err = -1;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr;
-	Elf_Data *data;
-	Elf_Scn *sec;
-	Elf_Kind ek;
-	void *ptr;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	ek = elf_kind(elf);
-	if (ek != ELF_K_ELF)
-		goto out;
-
-	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		pr_err("%s: cannot get elf header.\n", __func__);
-		goto out;
-	}
-
-	sec = elf_section_by_name(elf, &ehdr, &shdr,
-				  ".note.gnu.build-id", NULL);
-	if (sec == NULL) {
-		sec = elf_section_by_name(elf, &ehdr, &shdr,
-					  ".notes", NULL);
-		if (sec == NULL)
-			goto out;
-	}
-
-	data = elf_getdata(sec, NULL);
-	if (data == NULL)
-		goto out;
-
-	ptr = data->d_buf;
-	while (ptr < (data->d_buf + data->d_size)) {
-		GElf_Nhdr *nhdr = ptr;
-		int namesz = NOTE_ALIGN(nhdr->n_namesz),
-		    descsz = NOTE_ALIGN(nhdr->n_descsz);
-		const char *name;
-
-		ptr += sizeof(*nhdr);
-		name = ptr;
-		ptr += namesz;
-		if (nhdr->n_type == NT_GNU_BUILD_ID &&
-		    nhdr->n_namesz == sizeof("GNU")) {
-			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
-				memcpy(bf, ptr, BUILD_ID_SIZE);
-				err = BUILD_ID_SIZE;
-				break;
-			}
-		}
-		ptr += descsz;
-	}
-
-out:
-	return err;
-}
-
-int filename__read_build_id(const char *filename, void *bf, size_t size)
-{
-	int fd, err = -1;
-	Elf *elf;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
-		goto out_close;
-	}
-
-	err = elf_read_build_id(elf, bf, size);
-
-	elf_end(elf);
-out_close:
-	close(fd);
-out:
-	return err;
-}
-
-int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
-{
-	int fd, err = -1;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	while (1) {
-		char bf[BUFSIZ];
-		GElf_Nhdr nhdr;
-		int namesz, descsz;
-
-		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
-			break;
-
-		namesz = NOTE_ALIGN(nhdr.n_namesz);
-		descsz = NOTE_ALIGN(nhdr.n_descsz);
-		if (nhdr.n_type == NT_GNU_BUILD_ID &&
-		    nhdr.n_namesz == sizeof("GNU")) {
-			if (read(fd, bf, namesz) != namesz)
-				break;
-			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
-				if (read(fd, build_id,
-				    BUILD_ID_SIZE) == BUILD_ID_SIZE) {
-					err = 0;
-					break;
-				}
-			} else if (read(fd, bf, descsz) != descsz)
-				break;
-		} else {
-			int n = namesz + descsz;
-			if (read(fd, bf, n) != n)
-				break;
-		}
-	}
-	close(fd);
-out:
-	return err;
-}
-
-char dso__symtab_origin(const struct dso *self)
-{
-	static const char origin[] = {
-		[DSO__ORIG_KERNEL] =   'k',
-		[DSO__ORIG_JAVA_JIT] = 'j',
-		[DSO__ORIG_BUILD_ID_CACHE] = 'B',
-		[DSO__ORIG_FEDORA] =   'f',
-		[DSO__ORIG_UBUNTU] =   'u',
-		[DSO__ORIG_BUILDID] =  'b',
-		[DSO__ORIG_DSO] =      'd',
-		[DSO__ORIG_KMODULE] =  'K',
-		[DSO__ORIG_GUEST_KERNEL] =  'g',
-		[DSO__ORIG_GUEST_KMODULE] =  'G',
-	};
-
-	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
-		return '!';
-	return origin[self->origin];
-}
-
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
-{
-	int size = PATH_MAX;
-	char *name;
-	int ret = -1;
-	int fd;
-	struct machine *machine;
-	const char *root_dir;
-	int want_symtab;
-
-	dso__set_loaded(self, map->type);
-
-	if (self->kernel == DSO_TYPE_KERNEL)
-		return dso__load_kernel_sym(self, map, filter);
-	else if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		return dso__load_guest_kernel_sym(self, map, filter);
-
-	if (map->groups && map->groups->machine)
-		machine = map->groups->machine;
-	else
-		machine = NULL;
-
-	name = malloc(size);
-	if (!name)
-		return -1;
-
-	self->adjust_symbols = 0;
-
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
-		ret = dso__load_perf_map(self, map, filter);
-		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
-					 DSO__ORIG_NOT_FOUND;
-		return ret;
-	}
-
-	/* Iterate over candidate debug images.
-	 * On the first pass, only load images if they have a full symtab.
-	 * Failing that, do a second pass where we accept .dynsym also
-	 */
-	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
-	     self->origin != DSO__ORIG_NOT_FOUND;
-	     self->origin++) {
-		switch (self->origin) {
-		case DSO__ORIG_BUILD_ID_CACHE:
-			if (dso__build_id_filename(self, name, size) == NULL)
-				continue;
-			break;
-		case DSO__ORIG_FEDORA:
-			snprintf(name, size, "/usr/lib/debug%s.debug",
-				 self->long_name);
-			break;
-		case DSO__ORIG_UBUNTU:
-			snprintf(name, size, "/usr/lib/debug%s",
-				 self->long_name);
-			break;
-		case DSO__ORIG_BUILDID: {
-			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-
-			if (!self->has_build_id)
-				continue;
-
-			build_id__sprintf(self->build_id,
-					  sizeof(self->build_id),
-					  build_id_hex);
-			snprintf(name, size,
-				 "/usr/lib/debug/.build-id/%.2s/%s.debug",
-				 build_id_hex, build_id_hex + 2);
-			}
-			break;
-		case DSO__ORIG_DSO:
-			snprintf(name, size, "%s", self->long_name);
-			break;
-		case DSO__ORIG_GUEST_KMODULE:
-			if (map->groups && map->groups->machine)
-				root_dir = map->groups->machine->root_dir;
-			else
-				root_dir = "";
-			snprintf(name, size, "%s%s", root_dir, self->long_name);
-			break;
-
-		default:
-			/*
-			 * If we wanted a full symtab but no image had one,
-			 * relax our requirements and repeat the search.
-			 */
-			if (want_symtab) {
-				want_symtab = 0;
-				self->origin = DSO__ORIG_BUILD_ID_CACHE;
-			} else
-				continue;
-		}
-
-		/* Name is now the name of the next image to try */
-		fd = open(name, O_RDONLY);
-		if (fd < 0)
-			continue;
-
-		ret = dso__load_sym(self, map, name, fd, filter, 0,
-				    want_symtab);
-		close(fd);
-
-		/*
-		 * Some people seem to have debuginfo files _WITHOUT_ debug
-		 * info!?!?
-		 */
-		if (!ret)
-			continue;
-
-		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
-			if (nr_plt > 0)
-				ret += nr_plt;
-			break;
-		}
-	}
-
-	free(name);
-	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
-		return 0;
-	return ret;
-}
-
-struct map *map_groups__find_by_name(struct map_groups *self,
-				     enum map_type type, const char *name)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
-		struct map *map = rb_entry(nd, struct map, rb_node);
-
-		if (map->dso && strcmp(map->dso->short_name, name) == 0)
-			return map;
-	}
-
-	return NULL;
-}
-
-static int dso__kernel_module_get_build_id(struct dso *self,
-				const char *root_dir)
-{
-	char filename[PATH_MAX];
-	/*
-	 * kernel module short names are of the form "[module]" and
-	 * we need just "module" here.
-	 */
-	const char *name = self->short_name + 1;
-
-	snprintf(filename, sizeof(filename),
-		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
-		 root_dir, (int)strlen(name) - 1, name);
-
-	if (sysfs__read_build_id(filename, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
-
-	return 0;
-}
-
-static int map_groups__set_modules_path_dir(struct map_groups *self,
-				const char *dir_name)
-{
-	struct dirent *dent;
-	DIR *dir = opendir(dir_name);
-	int ret = 0;
-
-	if (!dir) {
-		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
-		return -1;
-	}
-
-	while ((dent = readdir(dir)) != NULL) {
-		char path[PATH_MAX];
-		struct stat st;
-
-		/*sshfs might return bad dent->d_type, so we have to stat*/
-		sprintf(path, "%s/%s", dir_name, dent->d_name);
-		if (stat(path, &st))
-			continue;
-
-		if (S_ISDIR(st.st_mode)) {
-			if (!strcmp(dent->d_name, ".") ||
-			    !strcmp(dent->d_name, ".."))
-				continue;
-
-			snprintf(path, sizeof(path), "%s/%s",
-				 dir_name, dent->d_name);
-			ret = map_groups__set_modules_path_dir(self, path);
-			if (ret < 0)
-				goto out;
-		} else {
-			char *dot = strrchr(dent->d_name, '.'),
-			     dso_name[PATH_MAX];
-			struct map *map;
-			char *long_name;
-
-			if (dot == NULL || strcmp(dot, ".ko"))
-				continue;
-			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
-				 (int)(dot - dent->d_name), dent->d_name);
-
-			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(self, MAP__FUNCTION, dso_name);
-			if (map == NULL)
-				continue;
-
-			snprintf(path, sizeof(path), "%s/%s",
-				 dir_name, dent->d_name);
-
-			long_name = strdup(path);
-			if (long_name == NULL) {
-				ret = -1;
-				goto out;
-			}
-			dso__set_long_name(map->dso, long_name);
-			map->dso->lname_alloc = 1;
-			dso__kernel_module_get_build_id(map->dso, "");
-		}
-	}
-
-out:
-	closedir(dir);
-	return ret;
-}
-
-static char *get_kernel_version(const char *root_dir)
-{
-	char version[PATH_MAX];
-	FILE *file;
-	char *name, *tmp;
-	const char *prefix = "Linux version ";
-
-	sprintf(version, "%s/proc/version", root_dir);
-	file = fopen(version, "r");
-	if (!file)
-		return NULL;
-
-	version[0] = '\0';
-	tmp = fgets(version, sizeof(version), file);
-	fclose(file);
-
-	name = strstr(version, prefix);
-	if (!name)
-		return NULL;
-	name += strlen(prefix);
-	tmp = strchr(name, ' ');
-	if (tmp)
-		*tmp = '\0';
-
-	return strdup(name);
-}
-
-static int machine__set_modules_path(struct machine *self)
-{
-	char *version;
-	char modules_path[PATH_MAX];
-
-	version = get_kernel_version(self->root_dir);
-	if (!version)
-		return -1;
-
-	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
-		 self->root_dir, version);
-	free(version);
-
-	return map_groups__set_modules_path_dir(&self->kmaps, modules_path);
-}
-
-/*
- * Constructor variant for modules (where we know from /proc/modules where
- * they are loaded) and for vmlinux, where only after we load all the
- * symbols we'll know where it starts and ends.
- */
-static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
-{
-	struct map *self = calloc(1, (sizeof(*self) +
-				      (dso->kernel ? sizeof(struct kmap) : 0)));
-	if (self != NULL) {
-		/*
-		 * ->end will be filled after we load all the symbols
-		 */
-		map__init(self, type, start, 0, 0, dso);
-	}
-
-	return self;
-}
-
-struct map *machine__new_module(struct machine *self, u64 start,
-				const char *filename)
-{
-	struct map *map;
-	struct dso *dso = __dsos__findnew(&self->kernel_dsos, filename);
-
-	if (dso == NULL)
-		return NULL;
-
-	map = map__new2(start, dso, MAP__FUNCTION);
-	if (map == NULL)
-		return NULL;
-
-	if (machine__is_host(self))
-		dso->origin = DSO__ORIG_KMODULE;
-	else
-		dso->origin = DSO__ORIG_GUEST_KMODULE;
-	map_groups__insert(&self->kmaps, map);
-	return map;
-}
-
-static int machine__create_modules(struct machine *self)
-{
-	char *line = NULL;
-	size_t n;
-	FILE *file;
-	struct map *map;
-	const char *modules;
-	char path[PATH_MAX];
-
-	if (machine__is_default_guest(self))
-		modules = symbol_conf.default_guest_modules;
-	else {
-		sprintf(path, "%s/proc/modules", self->root_dir);
-		modules = path;
-	}
-
-	file = fopen(modules, "r");
-	if (file == NULL)
-		return -1;
-
-	while (!feof(file)) {
-		char name[PATH_MAX];
-		u64 start;
-		char *sep;
-		int line_len;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0)
-			break;
-
-		if (!line)
-			goto out_failure;
-
-		line[--line_len] = '\0'; /* \n */
-
-		sep = strrchr(line, 'x');
-		if (sep == NULL)
-			continue;
-
-		hex2u64(sep + 1, &start);
-
-		sep = strchr(line, ' ');
-		if (sep == NULL)
-			continue;
-
-		*sep = '\0';
-
-		snprintf(name, sizeof(name), "[%s]", line);
-		map = machine__new_module(self, start, name);
-		if (map == NULL)
-			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, self->root_dir);
-	}
-
-	free(line);
-	fclose(file);
-
-	return machine__set_modules_path(self);
-
-out_delete_line:
-	free(line);
-out_failure:
-	return -1;
-}
-
-static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     const char *vmlinux, symbol_filter_t filter)
-{
-	int err = -1, fd;
-
-	fd = open(vmlinux, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
-	close(fd);
-
-	if (err > 0)
-		pr_debug("Using %s for symbols\n", vmlinux);
-
-	return err;
-}
-
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
-			   symbol_filter_t filter)
-{
-	int i, err = 0;
-	char *filename;
-
-	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-		 vmlinux_path__nr_entries + 1);
-
-	filename = dso__build_id_filename(self, NULL, 0);
-	if (filename != NULL) {
-		err = dso__load_vmlinux(self, map, filename, filter);
-		if (err > 0) {
-			dso__set_long_name(self, filename);
-			goto out;
-		}
-		free(filename);
-	}
-
-	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
-		if (err > 0) {
-			dso__set_long_name(self, strdup(vmlinux_path[i]));
-			break;
-		}
-	}
-out:
-	return err;
-}
-
-static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter)
-{
-	int err;
-	const char *kallsyms_filename = NULL;
-	char *kallsyms_allocated_filename = NULL;
-	/*
-	 * Step 1: if the user specified a vmlinux filename, use it and only
-	 * it, reporting errors to the user if it cannot be used.
-	 *
-	 * For instance, try to analyse an ARM perf.data file _without_ a
-	 * build-id, or if the user specifies the wrong path to the right
-	 * vmlinux file, obviously we can't fallback to another vmlinux (a
-	 * x86_86 one, on the machine where analysis is being performed, say),
-	 * or worse, /proc/kallsyms.
-	 *
-	 * If the specified file _has_ a build-id and there is a build-id
-	 * section in the perf.data file, we will still do the expected
-	 * validation in dso__load_vmlinux and will bail out if they don't
-	 * match.
-	 */
-	if (symbol_conf.vmlinux_name != NULL) {
-		err = dso__load_vmlinux(self, map,
-					symbol_conf.vmlinux_name, filter);
-		if (err > 0) {
-			dso__set_long_name(self,
-					   strdup(symbol_conf.vmlinux_name));
-			goto out_fixup;
-		}
-		return err;
-	}
-
-	if (vmlinux_path != NULL) {
-		err = dso__load_vmlinux_path(self, map, filter);
-		if (err > 0)
-			goto out_fixup;
-	}
-
-	/*
-	 * Say the kernel DSO was created when processing the build-id header table,
-	 * we have a build-id, so check if it is the same as the running kernel,
-	 * using it if it is.
-	 */
-	if (self->has_build_id) {
-		u8 kallsyms_build_id[BUILD_ID_SIZE];
-		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
-					 sizeof(kallsyms_build_id)) == 0) {
-			if (dso__build_id_equal(self, kallsyms_build_id)) {
-				kallsyms_filename = "/proc/kallsyms";
-				goto do_kallsyms;
-			}
-		}
-		/*
-		 * Now look if we have it on the build-id cache in
-		 * $HOME/.debug/[kernel.kallsyms].
-		 */
-		build_id__sprintf(self->build_id, sizeof(self->build_id),
-				  sbuild_id);
-
-		if (asprintf(&kallsyms_allocated_filename,
-			     "%s/.debug/[kernel.kallsyms]/%s",
-			     getenv("HOME"), sbuild_id) == -1) {
-			pr_err("Not enough memory for kallsyms file lookup\n");
-			return -1;
-		}
-
-		kallsyms_filename = kallsyms_allocated_filename;
-
-		if (access(kallsyms_filename, F_OK)) {
-			pr_err("No kallsyms or vmlinux with build-id %s "
-			       "was found\n", sbuild_id);
-			free(kallsyms_allocated_filename);
-			return -1;
-		}
-	} else {
-		/*
-		 * Last resort, if we don't have a build-id and couldn't find
-		 * any vmlinux file, try the running kernel kallsyms table.
-		 */
-		kallsyms_filename = "/proc/kallsyms";
-	}
-
-do_kallsyms:
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
-	if (err > 0)
-		pr_debug("Using %s for symbols\n", kallsyms_filename);
-	free(kallsyms_allocated_filename);
-
-	if (err > 0) {
-out_fixup:
-		if (kallsyms_filename != NULL)
-			dso__set_long_name(self, strdup("[kernel.kallsyms]"));
-		map__fixup_start(map);
-		map__fixup_end(map);
-	}
-
-	return err;
-}
-
-static int dso__load_guest_kernel_sym(struct dso *self, struct map *map,
-				symbol_filter_t filter)
-{
-	int err;
-	const char *kallsyms_filename = NULL;
-	struct machine *machine;
-	char path[PATH_MAX];
-
-	if (!map->groups) {
-		pr_debug("Guest kernel map hasn't the point to groups\n");
-		return -1;
-	}
-	machine = map->groups->machine;
-
-	if (machine__is_default_guest(machine)) {
-		/*
-		 * if the user specified a vmlinux filename, use it and only
-		 * it, reporting errors to the user if it cannot be used.
-		 * Or use file guest_kallsyms inputted by user on commandline
-		 */
-		if (symbol_conf.default_guest_vmlinux_name != NULL) {
-			err = dso__load_vmlinux(self, map,
-				symbol_conf.default_guest_vmlinux_name, filter);
-			goto out_try_fixup;
-		}
-
-		kallsyms_filename = symbol_conf.default_guest_kallsyms;
-		if (!kallsyms_filename)
-			return -1;
-	} else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-		kallsyms_filename = path;
-	}
-
-	err = dso__load_kallsyms(self, kallsyms_filename, map, filter);
-	if (err > 0)
-		pr_debug("Using %s for symbols\n", kallsyms_filename);
-
-out_try_fixup:
-	if (err > 0) {
-		if (kallsyms_filename != NULL) {
-			machine__mmap_name(machine, path, sizeof(path));
-			dso__set_long_name(self, strdup(path));
-		}
-		map__fixup_start(map);
-		map__fixup_end(map);
-	}
-
-	return err;
-}
-
-static void dsos__add(struct list_head *head, struct dso *dso)
-{
-	list_add_tail(&dso->node, head);
-}
-
-static struct dso *dsos__find(struct list_head *head, const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node)
-		if (strcmp(pos->long_name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-struct dso *__dsos__findnew(struct list_head *head, const char *name)
-{
-	struct dso *dso = dsos__find(head, name);
-
-	if (!dso) {
-		dso = dso__new(name);
-		if (dso != NULL) {
-			dsos__add(head, dso);
-			dso__set_basename(dso);
-		}
-	}
-
-	return dso;
-}
-
-size_t __dsos__fprintf(struct list_head *head, FILE *fp)
-{
-	struct dso *pos;
-	size_t ret = 0;
-
-	list_for_each_entry(pos, head, node) {
-		int i;
-		for (i = 0; i < MAP__NR_TYPES; ++i)
-			ret += dso__fprintf(pos, i, fp);
-	}
-
-	return ret;
-}
-
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp)
-{
-	struct rb_node *nd;
-	size_t ret = 0;
-
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
-		ret += __dsos__fprintf(&pos->user_dsos, fp);
-	}
-
-	return ret;
-}
-
-static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
-				      bool with_hits)
-{
-	struct dso *pos;
-	size_t ret = 0;
-
-	list_for_each_entry(pos, head, node) {
-		if (with_hits && !pos->hit)
-			continue;
-		ret += dso__fprintf_buildid(pos, fp);
-		ret += fprintf(fp, " %s\n", pos->long_name);
-	}
-	return ret;
-}
-
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits)
-{
-	return __dsos__fprintf_buildid(&self->kernel_dsos, fp, with_hits) +
-	       __dsos__fprintf_buildid(&self->user_dsos, fp, with_hits);
-}
-
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits)
-{
-	struct rb_node *nd;
-	size_t ret = 0;
-
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += machine__fprintf_dsos_buildid(pos, fp, with_hits);
-	}
-	return ret;
-}
-
-struct dso *dso__new_kernel(const char *name)
-{
-	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
-
-	if (self != NULL) {
-		dso__set_short_name(self, "[kernel]");
-		self->kernel = DSO_TYPE_KERNEL;
-	}
-
-	return self;
-}
-
-static struct dso *dso__new_guest_kernel(struct machine *machine,
-					const char *name)
-{
-	char bf[PATH_MAX];
-	struct dso *self = dso__new(name ?: machine__mmap_name(machine, bf, sizeof(bf)));
-
-	if (self != NULL) {
-		dso__set_short_name(self, "[guest.kernel]");
-		self->kernel = DSO_TYPE_GUEST_KERNEL;
-	}
-
-	return self;
-}
-
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine)
-{
-	char path[PATH_MAX];
-
-	if (machine__is_default_guest(machine))
-		return;
-	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
-	if (sysfs__read_build_id(path, self->build_id,
-				 sizeof(self->build_id)) == 0)
-		self->has_build_id = true;
-}
-
-static struct dso *machine__create_kernel(struct machine *self)
-{
-	const char *vmlinux_name = NULL;
-	struct dso *kernel;
-
-	if (machine__is_host(self)) {
-		vmlinux_name = symbol_conf.vmlinux_name;
-		kernel = dso__new_kernel(vmlinux_name);
-	} else {
-		if (machine__is_default_guest(self))
-			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(self, vmlinux_name);
-	}
-
-	if (kernel != NULL) {
-		dso__read_running_kernel_build_id(kernel, self);
-		dsos__add(&self->kernel_dsos, kernel);
-	}
-	return kernel;
-}
-
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
-{
-	enum map_type type;
-
-	for (type = 0; type < MAP__NR_TYPES; ++type) {
-		struct kmap *kmap;
-
-		self->vmlinux_maps[type] = map__new2(0, kernel, type);
-		if (self->vmlinux_maps[type] == NULL)
-			return -1;
-
-		self->vmlinux_maps[type]->map_ip =
-			self->vmlinux_maps[type]->unmap_ip = identity__map_ip;
-
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		kmap->kmaps = &self->kmaps;
-		map_groups__insert(&self->kmaps, self->vmlinux_maps[type]);
-	}
-
-	return 0;
-}
-
-void machine__destroy_kernel_maps(struct machine *self)
-{
-	enum map_type type;
-
-	for (type = 0; type < MAP__NR_TYPES; ++type) {
-		struct kmap *kmap;
-
-		if (self->vmlinux_maps[type] == NULL)
-			continue;
-
-		kmap = map__kmap(self->vmlinux_maps[type]);
-		map_groups__remove(&self->kmaps, self->vmlinux_maps[type]);
-		if (kmap->ref_reloc_sym) {
-			/*
-			 * ref_reloc_sym is shared among all maps, so free just
-			 * on one of them.
-			 */
-			if (type == MAP__FUNCTION) {
-				free((char *)kmap->ref_reloc_sym->name);
-				kmap->ref_reloc_sym->name = NULL;
-				free(kmap->ref_reloc_sym);
-			}
-			kmap->ref_reloc_sym = NULL;
-		}
-
-		map__delete(self->vmlinux_maps[type]);
-		self->vmlinux_maps[type] = NULL;
-	}
-}
-
-int machine__create_kernel_maps(struct machine *self)
-{
-	struct dso *kernel = machine__create_kernel(self);
-
-	if (kernel == NULL ||
-	    __machine__create_kernel_maps(self, kernel) < 0)
-		return -1;
-
-	if (symbol_conf.use_modules && machine__create_modules(self) < 0)
-		pr_debug("Problems creating module maps, continuing anyway...\n");
-	/*
-	 * Now that we have all the maps created, just set the ->end of them:
-	 */
-	map_groups__fixup_end(&self->kmaps);
-	return 0;
-}
-
-static void vmlinux_path__exit(void)
-{
-	while (--vmlinux_path__nr_entries >= 0) {
-		free(vmlinux_path[vmlinux_path__nr_entries]);
-		vmlinux_path[vmlinux_path__nr_entries] = NULL;
-	}
-
-	free(vmlinux_path);
-	vmlinux_path = NULL;
-}
-
-static int vmlinux_path__init(void)
-{
-	struct utsname uts;
-	char bf[PATH_MAX];
-
-	if (uname(&uts) < 0)
-		return -1;
-
-	vmlinux_path = malloc(sizeof(char *) * 5);
-	if (vmlinux_path == NULL)
-		return -1;
-
-	vmlinux_path[vmlinux_path__nr_entries] = strdup("vmlinux");
-	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-		goto out_fail;
-	++vmlinux_path__nr_entries;
-	vmlinux_path[vmlinux_path__nr_entries] = strdup("/boot/vmlinux");
-	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-		goto out_fail;
-	++vmlinux_path__nr_entries;
-	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
-	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
-	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-		goto out_fail;
-	++vmlinux_path__nr_entries;
-	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
-	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
-	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-		goto out_fail;
-	++vmlinux_path__nr_entries;
-	snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
-		 uts.release);
-	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
-	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-		goto out_fail;
-	++vmlinux_path__nr_entries;
-
-	return 0;
-
-out_fail:
-	vmlinux_path__exit();
-	return -1;
-}
-
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
-{
-	int i;
-	size_t printed = 0;
-	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
-
-	if (kdso->has_build_id) {
-		char filename[PATH_MAX];
-		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
-			printed += fprintf(fp, "[0] %s\n", filename);
-	}
-
-	for (i = 0; i < vmlinux_path__nr_entries; ++i)
-		printed += fprintf(fp, "[%d] %s\n",
-				   i + kdso->has_build_id, vmlinux_path[i]);
-
-	return printed;
-}
-
-static int setup_list(struct strlist **list, const char *list_str,
-		      const char *list_name)
-{
-	if (list_str == NULL)
-		return 0;
-
-	*list = strlist__new(true, list_str);
-	if (!*list) {
-		pr_err("problems parsing %s list\n", list_name);
-		return -1;
-	}
-	return 0;
-}
-
-int symbol__init(void)
-{
-	if (symbol_conf.initialized)
-		return 0;
-
-	elf_version(EV_CURRENT);
-	if (symbol_conf.sort_by_name)
-		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
-					  sizeof(struct symbol));
-
-	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
-		return -1;
-
-	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
-		pr_err("'.' is the only non valid --field-separator argument\n");
-		return -1;
-	}
-
-	if (setup_list(&symbol_conf.dso_list,
-		       symbol_conf.dso_list_str, "dso") < 0)
-		return -1;
-
-	if (setup_list(&symbol_conf.comm_list,
-		       symbol_conf.comm_list_str, "comm") < 0)
-		goto out_free_dso_list;
-
-	if (setup_list(&symbol_conf.sym_list,
-		       symbol_conf.sym_list_str, "symbol") < 0)
-		goto out_free_comm_list;
-
-	symbol_conf.initialized = true;
-	return 0;
-
-out_free_dso_list:
-	strlist__delete(symbol_conf.dso_list);
-out_free_comm_list:
-	strlist__delete(symbol_conf.comm_list);
-	return -1;
-}
-
-void symbol__exit(void)
-{
-	if (!symbol_conf.initialized)
-		return;
-	strlist__delete(symbol_conf.sym_list);
-	strlist__delete(symbol_conf.dso_list);
-	strlist__delete(symbol_conf.comm_list);
-	vmlinux_path__exit();
-	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
-	symbol_conf.initialized = false;
-}
-
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
-{
-	struct machine *machine = machines__findnew(self, pid);
-
-	if (machine == NULL)
-		return -1;
-
-	return machine__create_kernel_maps(machine);
-}
-
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-int hex2u64(const char *ptr, u64 *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
-char *strxfrchar(char *s, char from, char to)
-{
-	char *p = s;
-
-	while ((p = strchr(p, from)) != NULL)
-		*p++ = to;
-
-	return s;
-}
-
-int machines__create_guest_kernel_maps(struct rb_root *self)
-{
-	int ret = 0;
-	struct dirent **namelist = NULL;
-	int i, items = 0;
-	char path[PATH_MAX];
-	pid_t pid;
-
-	if (symbol_conf.default_guest_vmlinux_name ||
-	    symbol_conf.default_guest_modules ||
-	    symbol_conf.default_guest_kallsyms) {
-		machines__create_kernel_maps(self, DEFAULT_GUEST_KERNEL_ID);
-	}
-
-	if (symbol_conf.guestmount) {
-		items = scandir(symbol_conf.guestmount, &namelist, NULL, NULL);
-		if (items <= 0)
-			return -ENOENT;
-		for (i = 0; i < items; i++) {
-			if (!isdigit(namelist[i]->d_name[0])) {
-				/* Filter out . and .. */
-				continue;
-			}
-			pid = atoi(namelist[i]->d_name);
-			sprintf(path, "%s/%s/proc/kallsyms",
-				symbol_conf.guestmount,
-				namelist[i]->d_name);
-			ret = access(path, R_OK);
-			if (ret) {
-				pr_debug("Can't access file %s\n", path);
-				goto failure;
-			}
-			machines__create_kernel_maps(self, pid);
-		}
-failure:
-		free(namelist);
-	}
-
-	return ret;
-}
-
-void machines__destroy_guest_kernel_maps(struct rb_root *self)
-{
-	struct rb_node *next = rb_first(self);
-
-	while (next) {
-		struct machine *pos = rb_entry(next, struct machine, rb_node);
-
-		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
-		machine__delete(pos);
-	}
-}
-
-int machine__load_kallsyms(struct machine *self, const char *filename,
-			   enum map_type type, symbol_filter_t filter)
-{
-	struct map *map = self->vmlinux_maps[type];
-	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
-
-	if (ret > 0) {
-		dso__set_loaded(map->dso, type);
-		/*
-		 * Since /proc/kallsyms will have multiple sessions for the
-		 * kernel, with modules between them, fixup the end of all
-		 * sections.
-		 */
-		__map_groups__fixup_end(&self->kmaps, type);
-	}
-
-	return ret;
-}
-
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
-			       symbol_filter_t filter)
-{
-	struct map *map = self->vmlinux_maps[type];
-	int ret = dso__load_vmlinux_path(map->dso, map, filter);
-
-	if (ret > 0) {
-		dso__set_loaded(map->dso, type);
-		map__reloc_vmlinux(map);
-	}
-
-	return ret;
-}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
deleted file mode 100644
index adc7211..0000000
--- a/tools/perf/util/symbol.h
+++ /dev/null
@@ -1,231 +0,0 @@
-#ifndef __PERF_SYMBOL
-#define __PERF_SYMBOL 1
-
-#include <linux/types.h>
-#include <stdbool.h>
-#include <stdint.h>
-#include "map.h"
-#include <linux/list.h>
-#include <lk/rbtree.h>
-#include <stdio.h>
-
-#ifdef HAVE_CPLUS_DEMANGLE
-extern char *cplus_demangle(const char *, int);
-
-static inline char *bfd_demangle(void __used *v, const char *c, int i)
-{
-	return cplus_demangle(c, i);
-}
-#else
-#ifdef NO_DEMANGLE
-static inline char *bfd_demangle(void __used *v, const char __used *c,
-				 int __used i)
-{
-	return NULL;
-}
-#else
-#include <bfd.h>
-#endif
-#endif
-
-int hex2u64(const char *ptr, u64 *val);
-char *strxfrchar(char *s, char from, char to);
-
-/*
- * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
- * for newer versions we can use mmap to reduce memory usage:
- */
-#ifdef LIBELF_NO_MMAP
-# define PERF_ELF_C_READ_MMAP ELF_C_READ
-#else
-# define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
-#endif
-
-#ifndef DMGL_PARAMS
-#define DMGL_PARAMS      (1 << 0)       /* Include function args */
-#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
-#endif
-
-#define BUILD_ID_SIZE 20
-
-struct symbol {
-	struct rb_node	rb_node;
-	u64		start;
-	u64		end;
-	u16		namelen;
-	u8		binding;
-	char		name[0];
-};
-
-void symbol__delete(struct symbol *self);
-
-struct strlist;
-
-struct symbol_conf {
-	unsigned short	priv_size;
-	bool		try_vmlinux_path,
-			use_modules,
-			sort_by_name,
-			show_nr_samples,
-			use_callchain,
-			exclude_other,
-			show_cpu_utilization,
-			initialized;
-	const char	*vmlinux_name,
-			*source_prefix,
-			*field_sep;
-	const char	*default_guest_vmlinux_name,
-			*default_guest_kallsyms,
-			*default_guest_modules;
-	const char	*guestmount;
-	const char	*dso_list_str,
-			*comm_list_str,
-			*sym_list_str,
-			*col_width_list_str;
-       struct strlist	*dso_list,
-			*comm_list,
-			*sym_list;
-};
-
-extern struct symbol_conf symbol_conf;
-
-static inline void *symbol__priv(struct symbol *self)
-{
-	return ((void *)self) - symbol_conf.priv_size;
-}
-
-struct ref_reloc_sym {
-	const char	*name;
-	u64		addr;
-	u64		unrelocated_addr;
-};
-
-struct map_symbol {
-	struct map    *map;
-	struct symbol *sym;
-	bool	      unfolded;
-	bool	      has_children;
-};
-
-struct addr_location {
-	struct thread *thread;
-	struct map    *map;
-	struct symbol *sym;
-	u64	      addr;
-	char	      level;
-	bool	      filtered;
-	u8	      cpumode;
-	s32	      cpu;
-};
-
-enum dso_kernel_type {
-	DSO_TYPE_USER = 0,
-	DSO_TYPE_KERNEL,
-	DSO_TYPE_GUEST_KERNEL
-};
-
-struct dso {
-	struct list_head node;
-	struct rb_root	 symbols[MAP__NR_TYPES];
-	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	enum dso_kernel_type	kernel;
-	u8		 adjust_symbols:1;
-	u8		 slen_calculated:1;
-	u8		 has_build_id:1;
-	u8		 hit:1;
-	u8		 annotate_warned:1;
-	u8		 sname_alloc:1;
-	u8		 lname_alloc:1;
-	unsigned char	 origin;
-	u8		 sorted_by_name;
-	u8		 loaded;
-	u8		 build_id[BUILD_ID_SIZE];
-	const char	 *short_name;
-	char	 	 *long_name;
-	u16		 long_name_len;
-	u16		 short_name_len;
-	char		 name[0];
-};
-
-struct dso *dso__new(const char *name);
-struct dso *dso__new_kernel(const char *name);
-void dso__delete(struct dso *self);
-
-int dso__name_len(const struct dso *self);
-
-bool dso__loaded(const struct dso *self, enum map_type type);
-bool dso__sorted_by_name(const struct dso *self, enum map_type type);
-
-static inline void dso__set_loaded(struct dso *self, enum map_type type)
-{
-	self->loaded |= (1 << type);
-}
-
-void dso__sort_by_name(struct dso *self, enum map_type type);
-
-struct dso *__dsos__findnew(struct list_head *head, const char *name);
-
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
-int dso__load_vmlinux_path(struct dso *self, struct map *map,
-			   symbol_filter_t filter);
-int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
-		       symbol_filter_t filter);
-int machine__load_kallsyms(struct machine *self, const char *filename,
-			   enum map_type type, symbol_filter_t filter);
-int machine__load_vmlinux_path(struct machine *self, enum map_type type,
-			       symbol_filter_t filter);
-
-size_t __dsos__fprintf(struct list_head *head, FILE *fp);
-
-size_t machine__fprintf_dsos_buildid(struct machine *self, FILE *fp, bool with_hits);
-size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
-
-size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
-size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
-
-enum dso_origin {
-	DSO__ORIG_KERNEL = 0,
-	DSO__ORIG_GUEST_KERNEL,
-	DSO__ORIG_JAVA_JIT,
-	DSO__ORIG_BUILD_ID_CACHE,
-	DSO__ORIG_FEDORA,
-	DSO__ORIG_UBUNTU,
-	DSO__ORIG_BUILDID,
-	DSO__ORIG_DSO,
-	DSO__ORIG_GUEST_KMODULE,
-	DSO__ORIG_KMODULE,
-	DSO__ORIG_NOT_FOUND,
-};
-
-char dso__symtab_origin(const struct dso *self);
-void dso__set_long_name(struct dso *self, char *name);
-void dso__set_build_id(struct dso *self, void *build_id);
-void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
-struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
-struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
-					const char *name);
-
-int filename__read_build_id(const char *filename, void *bf, size_t size);
-int sysfs__read_build_id(const char *filename, void *bf, size_t size);
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
-int build_id__sprintf(const u8 *self, int len, char *bf);
-int kallsyms__parse(const char *filename, void *arg,
-		    int (*process_symbol)(void *arg, const char *name,
-					  char type, u64 start));
-
-void machine__destroy_kernel_maps(struct machine *self);
-int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
-int machine__create_kernel_maps(struct machine *self);
-
-int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
-int machines__create_guest_kernel_maps(struct rb_root *self);
-void machines__destroy_guest_kernel_maps(struct rb_root *self);
-
-int symbol__init(void);
-void symbol__exit(void);
-bool symbol_type__is_a(char symbol_type, enum map_type map_type);
-
-size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
-
-#endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8ab6e09..c36be4b 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -5,6 +5,7 @@
 #include "session.h"
 #include "thread.h"
 #include <lk/util.h>
+#include <perf/config.h>
 #include "debug.h"
 
 /* Skip "." and ".." directories */
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1a70f60..0b1d79a 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -3,7 +3,7 @@
 
 #include <lk/rbtree.h>
 #include <unistd.h>
-#include "symbol.h"
+#include <perf/symbol.h>
 
 struct thread {
 	union {
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a90273e..689317a 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -3,7 +3,7 @@
 #include "../libslang.h"
 #include "../../hist.h"
 #include "../../sort.h"
-#include "../../symbol.h"
+#include <perf/symbol.h>
 
 static void ui__error_window(const char *fmt, ...)
 {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 1d4ee98..4af0b95 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -15,7 +15,7 @@
 #include "../browser.h"
 #include "../helpline.h"
 #include "../util.h"
-#include "map.h"
+#include <perf/map.h>
 
 struct hist_browser {
 	struct ui_browser   b;
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 142b825..663e0b0 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -6,10 +6,10 @@
 #include <string.h>
 #include <linux/bitops.h>
 #include "../../debug.h"
-#include "../../symbol.h"
+#include <perf/symbol.h>
 #include "../browser.h"
 #include "../helpline.h"
-#include "map.h"
+#include <perf/map.h>
 
 static int ui_entry__read(const char *title, char *bf, size_t size, int width)
 {
-- 
1.7.3.1

