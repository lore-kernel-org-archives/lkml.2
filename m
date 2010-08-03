Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0HCFzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:45642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0HCFzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:55:06 -0400
Date: Tue, 3 Aug 2010 05:54:40 GMT
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
Subject: [tip:perf/core] perf session: Free the ref_reloc_sym memory at the right place
Message-ID: <tip-076c6e45215aea0de1ed34d3d5079fabeaabf5e1@git.kernel.org>
Git-Commit-ID: 076c6e45215aea0de1ed34d3d5079fabeaabf5e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 05:54:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  076c6e45215aea0de1ed34d3d5079fabeaabf5e1
Gitweb:     http://git.kernel.org/tip/076c6e45215aea0de1ed34d3d5079fabeaabf5e1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Aug 2010 18:18:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Aug 2010 18:18:28 -0300

perf session: Free the ref_reloc_sym memory at the right place

Which is at perf_session__destroy_kernel_maps, counterpart to the
perf_session__create_kernel_maps where the kmap structure is located, just
after the vmlinux_maps.

Make it also check if the kernel maps were actually created, which may not
be the case if, for instance, perf_session__new can't complete due to
permission problems in, for instance, a 'perf report' case, when a
segfault will take place, that is how this was noticed.

The problem was introduced in d65a458, thus post .35.

This also adds code to release guest machines as them are also created
in perf_session__create_kernel_maps, so should be deleted on this newly
introduced counterpart, perf_session__destroy_kernel_maps.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c     |   18 +++++++++++-------
 tools/perf/util/map.h     |    7 +++++++
 tools/perf/util/session.c |    7 +++++++
 tools/perf/util/symbol.c  |   43 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h  |    2 ++
 5 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 15d6a6d..801e696 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -506,6 +506,11 @@ void maps__insert(struct rb_root *maps, struct map *map)
 	rb_insert_color(&map->rb_node, maps);
 }
 
+void maps__remove(struct rb_root *self, struct map *map)
+{
+	rb_erase(&map->rb_node, self);
+}
+
 struct map *maps__find(struct rb_root *maps, u64 ip)
 {
 	struct rb_node **p = &maps->rb_node;
@@ -551,13 +556,6 @@ static void dsos__delete(struct list_head *self)
 
 void machine__exit(struct machine *self)
 {
-	struct kmap *kmap = map__kmap(self->vmlinux_maps[MAP__FUNCTION]);
-
-	if (kmap->ref_reloc_sym) {
-		free((char *)kmap->ref_reloc_sym->name);
-		free(kmap->ref_reloc_sym);
-	}
-
 	map_groups__exit(&self->kmaps);
 	dsos__delete(&self->user_dsos);
 	dsos__delete(&self->kernel_dsos);
@@ -565,6 +563,12 @@ void machine__exit(struct machine *self)
 	self->root_dir = NULL;
 }
 
+void machine__delete(struct machine *self)
+{
+	machine__exit(self);
+	free(self);
+}
+
 struct machine *machines__add(struct rb_root *self, pid_t pid,
 			      const char *root_dir)
 {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 0e0984e..5b51bbd 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -125,6 +125,7 @@ void map__reloc_vmlinux(struct map *self);
 size_t __map_groups__fprintf_maps(struct map_groups *self,
 				  enum map_type type, int verbose, FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
+void maps__remove(struct rb_root *self, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 void map_groups__init(struct map_groups *self);
 void map_groups__exit(struct map_groups *self);
@@ -144,6 +145,7 @@ struct machine *machines__findnew(struct rb_root *self, pid_t pid);
 char *machine__mmap_name(struct machine *self, char *bf, size_t size);
 int machine__init(struct machine *self, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *self);
+void machine__delete(struct machine *self);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
@@ -165,6 +167,11 @@ static inline void map_groups__insert(struct map_groups *self, struct map *map)
 	map->groups = self;
 }
 
+static inline void map_groups__remove(struct map_groups *self, struct map *map)
+{
+	maps__remove(&self->maps[map->type], map);
+}
+
 static inline struct map *map_groups__find(struct map_groups *self,
 					   enum map_type type, u64 addr)
 {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 04a3b3d..5d2fd52 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -79,6 +79,12 @@ int perf_session__create_kernel_maps(struct perf_session *self)
 	return ret;
 }
 
+static void perf_session__destroy_kernel_maps(struct perf_session *self)
+{
+	machine__destroy_kernel_maps(&self->host_machine);
+	machines__destroy_guest_kernel_maps(&self->machines);
+}
+
 struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
@@ -150,6 +156,7 @@ static void perf_session__delete_threads(struct perf_session *self)
 void perf_session__delete(struct perf_session *self)
 {
 	perf_header__exit(&self->header);
+	perf_session__destroy_kernel_maps(self);
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
 	machine__exit(&self->host_machine);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3b8c005..6f0dd90 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2107,6 +2107,36 @@ int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 	return 0;
 }
 
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
 int machine__create_kernel_maps(struct machine *self)
 {
 	struct dso *kernel = machine__create_kernel(self);
@@ -2351,6 +2381,19 @@ failure:
 	return ret;
 }
 
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
 int machine__load_kallsyms(struct machine *self, const char *filename,
 			   enum map_type type, symbol_filter_t filter)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 33d53ce..906be20 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -212,11 +212,13 @@ int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
 
+void machine__destroy_kernel_maps(struct machine *self);
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
 int machine__create_kernel_maps(struct machine *self);
 
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
 int machines__create_guest_kernel_maps(struct rb_root *self);
+void machines__destroy_guest_kernel_maps(struct rb_root *self);
 
 int symbol__init(void);
 void symbol__exit(void);
