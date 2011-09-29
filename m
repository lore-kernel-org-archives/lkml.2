Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1I2WsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab1I2WsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/16] perf symbols: Stop using 'self' in map_groups__ methods
Date: Thu, 29 Sep 2011 19:47:55 -0300
Message-Id: <1317336490-19437-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Stop using this python/OOP convention, doesn't really helps. Will do
more from time to time till we get it cleaned up in all of /perf.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rl9e690y60vnuyng05yp1zd3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |   74 ++++++++++++++++++++++++------------------------
 tools/perf/util/map.h |   42 ++++++++++++++--------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index a16ecab..aa2f9fd 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -220,55 +220,55 @@ u64 map__objdump_2ip(struct map *map, u64 addr)
 	return ip;
 }
 
-void map_groups__init(struct map_groups *self)
+void map_groups__init(struct map_groups *mg)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		self->maps[i] = RB_ROOT;
-		INIT_LIST_HEAD(&self->removed_maps[i]);
+		mg->maps[i] = RB_ROOT;
+		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
-	self->machine = NULL;
+	mg->machine = NULL;
 }
 
-static void maps__delete(struct rb_root *self)
+static void maps__delete(struct rb_root *maps)
 {
-	struct rb_node *next = rb_first(self);
+	struct rb_node *next = rb_first(maps);
 
 	while (next) {
 		struct map *pos = rb_entry(next, struct map, rb_node);
 
 		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, self);
+		rb_erase(&pos->rb_node, maps);
 		map__delete(pos);
 	}
 }
 
-static void maps__delete_removed(struct list_head *self)
+static void maps__delete_removed(struct list_head *maps)
 {
 	struct map *pos, *n;
 
-	list_for_each_entry_safe(pos, n, self, node) {
+	list_for_each_entry_safe(pos, n, maps, node) {
 		list_del(&pos->node);
 		map__delete(pos);
 	}
 }
 
-void map_groups__exit(struct map_groups *self)
+void map_groups__exit(struct map_groups *mg)
 {
 	int i;
 
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
-		maps__delete(&self->maps[i]);
-		maps__delete_removed(&self->removed_maps[i]);
+		maps__delete(&mg->maps[i]);
+		maps__delete_removed(&mg->removed_maps[i]);
 	}
 }
 
-void map_groups__flush(struct map_groups *self)
+void map_groups__flush(struct map_groups *mg)
 {
 	int type;
 
 	for (type = 0; type < MAP__NR_TYPES; type++) {
-		struct rb_root *root = &self->maps[type];
+		struct rb_root *root = &mg->maps[type];
 		struct rb_node *next = rb_first(root);
 
 		while (next) {
@@ -280,17 +280,17 @@ void map_groups__flush(struct map_groups *self)
 			 * instance in some hist_entry instances, so
 			 * just move them to a separate list.
 			 */
-			list_add_tail(&pos->node, &self->removed_maps[pos->type]);
+			list_add_tail(&pos->node, &mg->removed_maps[pos->type]);
 		}
 	}
 }
 
-struct symbol *map_groups__find_symbol(struct map_groups *self,
+struct symbol *map_groups__find_symbol(struct map_groups *mg,
 				       enum map_type type, u64 addr,
 				       struct map **mapp,
 				       symbol_filter_t filter)
 {
-	struct map *map = map_groups__find(self, type, addr);
+	struct map *map = map_groups__find(mg, type, addr);
 
 	if (map != NULL) {
 		if (mapp != NULL)
@@ -301,7 +301,7 @@ struct symbol *map_groups__find_symbol(struct map_groups *self,
 	return NULL;
 }
 
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       enum map_type type,
 					       const char *name,
 					       struct map **mapp,
@@ -309,7 +309,7 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		struct symbol *sym = map__find_symbol_by_name(pos, name, filter);
 
@@ -323,13 +323,13 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 	return NULL;
 }
 
-size_t __map_groups__fprintf_maps(struct map_groups *self,
+size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&mg->maps[type]); nd; nd = rb_next(nd)) {
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
@@ -342,22 +342,22 @@ size_t __map_groups__fprintf_maps(struct map_groups *self,
 	return printed;
 }
 
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_maps(mg, i, verbose, fp);
 	return printed;
 }
 
-static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
+static size_t __map_groups__fprintf_removed_maps(struct map_groups *mg,
 						 enum map_type type,
 						 int verbose, FILE *fp)
 {
 	struct map *pos;
 	size_t printed = 0;
 
-	list_for_each_entry(pos, &self->removed_maps[type], node) {
+	list_for_each_entry(pos, &mg->removed_maps[type], node) {
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
 		if (verbose > 1) {
@@ -368,26 +368,26 @@ static size_t __map_groups__fprintf_removed_maps(struct map_groups *self,
 	return printed;
 }
 
-static size_t map_groups__fprintf_removed_maps(struct map_groups *self,
+static size_t map_groups__fprintf_removed_maps(struct map_groups *mg,
 					       int verbose, FILE *fp)
 {
 	size_t printed = 0, i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		printed += __map_groups__fprintf_removed_maps(self, i, verbose, fp);
+		printed += __map_groups__fprintf_removed_maps(mg, i, verbose, fp);
 	return printed;
 }
 
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp)
+size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp)
 {
-	size_t printed = map_groups__fprintf_maps(self, verbose, fp);
+	size_t printed = map_groups__fprintf_maps(mg, verbose, fp);
 	printed += fprintf(fp, "Removed maps:\n");
-	return printed + map_groups__fprintf_removed_maps(self, verbose, fp);
+	return printed + map_groups__fprintf_removed_maps(mg, verbose, fp);
 }
 
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				   int verbose, FILE *fp)
 {
-	struct rb_root *root = &self->maps[map->type];
+	struct rb_root *root = &mg->maps[map->type];
 	struct rb_node *next = rb_first(root);
 	int err = 0;
 
@@ -418,7 +418,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 			}
 
 			before->end = map->start - 1;
-			map_groups__insert(self, before);
+			map_groups__insert(mg, before);
 			if (verbose >= 2)
 				map__fprintf(before, fp);
 		}
@@ -432,7 +432,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 			}
 
 			after->start = map->end + 1;
-			map_groups__insert(self, after);
+			map_groups__insert(mg, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
 		}
@@ -441,7 +441,7 @@ move_map:
 		 * If we have references, just move them to a separate list.
 		 */
 		if (pos->referenced)
-			list_add_tail(&pos->node, &self->removed_maps[map->type]);
+			list_add_tail(&pos->node, &mg->removed_maps[map->type]);
 		else
 			map__delete(pos);
 
@@ -455,7 +455,7 @@ move_map:
 /*
  * XXX This should not really _copy_ te maps, but refcount them.
  */
-int map_groups__clone(struct map_groups *self,
+int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type)
 {
 	struct rb_node *nd;
@@ -464,7 +464,7 @@ int map_groups__clone(struct map_groups *self,
 		struct map *new = map__clone(map);
 		if (new == NULL)
 			return -ENOMEM;
-		map_groups__insert(self, new);
+		map_groups__insert(mg, new);
 	}
 	return 0;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index b397c03..890d855 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -123,17 +123,17 @@ void map__fixup_end(struct map *self);
 
 void map__reloc_vmlinux(struct map *self);
 
-size_t __map_groups__fprintf_maps(struct map_groups *self,
+size_t __map_groups__fprintf_maps(struct map_groups *mg,
 				  enum map_type type, int verbose, FILE *fp);
 void maps__insert(struct rb_root *maps, struct map *map);
-void maps__remove(struct rb_root *self, struct map *map);
+void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
-void map_groups__init(struct map_groups *self);
-void map_groups__exit(struct map_groups *self);
-int map_groups__clone(struct map_groups *self,
+void map_groups__init(struct map_groups *mg);
+void map_groups__exit(struct map_groups *mg);
+int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
-size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp);
-size_t map_groups__fprintf_maps(struct map_groups *self, int verbose, FILE *fp);
+size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
+size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
 
 typedef void (*machine__process_t)(struct machine *self, void *data);
 
@@ -162,29 +162,29 @@ static inline bool machine__is_host(struct machine *self)
 	return self ? self->pid == HOST_KERNEL_ID : false;
 }
 
-static inline void map_groups__insert(struct map_groups *self, struct map *map)
+static inline void map_groups__insert(struct map_groups *mg, struct map *map)
 {
-	maps__insert(&self->maps[map->type], map);
-	map->groups = self;
+	maps__insert(&mg->maps[map->type], map);
+	map->groups = mg;
 }
 
-static inline void map_groups__remove(struct map_groups *self, struct map *map)
+static inline void map_groups__remove(struct map_groups *mg, struct map *map)
 {
-	maps__remove(&self->maps[map->type], map);
+	maps__remove(&mg->maps[map->type], map);
 }
 
-static inline struct map *map_groups__find(struct map_groups *self,
+static inline struct map *map_groups__find(struct map_groups *mg,
 					   enum map_type type, u64 addr)
 {
-	return maps__find(&self->maps[type], addr);
+	return maps__find(&mg->maps[type], addr);
 }
 
-struct symbol *map_groups__find_symbol(struct map_groups *self,
+struct symbol *map_groups__find_symbol(struct map_groups *mg,
 				       enum map_type type, u64 addr,
 				       struct map **mapp,
 				       symbol_filter_t filter);
 
-struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
+struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       enum map_type type,
 					       const char *name,
 					       struct map **mapp,
@@ -208,11 +208,11 @@ struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
 }
 
 static inline
-struct symbol *map_groups__find_function_by_name(struct map_groups *self,
+struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
 						 symbol_filter_t filter)
 {
-	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
+	return map_groups__find_symbol_by_name(mg, MAP__FUNCTION, name, mapp, filter);
 }
 
 static inline
@@ -225,13 +225,13 @@ struct symbol *machine__find_kernel_function_by_name(struct machine *self,
 						 filter);
 }
 
-int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
+int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				   int verbose, FILE *fp);
 
-struct map *map_groups__find_by_name(struct map_groups *self,
+struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
 struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
 
-void map_groups__flush(struct map_groups *self);
+void map_groups__flush(struct map_groups *mg);
 
 #endif /* __PERF_MAP_H */
-- 
1.6.2.5

