Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0HCCJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:09:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0HCCJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:09:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: Don't keep unreferenced maps when unmaps are detected
Date: Mon,  2 Aug 2010 23:09:12 -0300
Message-Id: <1280801352-4630-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280801352-4630-1-git-send-email-acme@infradead.org>
References: <1280801352-4630-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For a file with:

[root@emilia linux-2.6-tip]# perf report -D -fi allmodconfig-j32.perf.data | grep events:
     TOTAL events:      36933
      MMAP events:       9056
      LOST events:          0
      COMM events:       1702
      EXIT events:       1887
  THROTTLE events:          8
UNTHROTTLE events:          8
      FORK events:       1894
      READ events:          0
    SAMPLE events:      22378
      ATTR events:          0
EVENT_TYPE events:          0
TRACING_DATA events:          0
  BUILD_ID events:          0
[root@emilia linux-2.6-tip]#

Testing with valgrind and making perf_session__delete() a nop, so that
we can notice how many maps were actually deleted due to not having any
samples on it:

==== HEAP SUMMARY:

Before:

==10339==     in use at exit: 8,909,997 bytes in 68,690 blocks
==10339==   total heap usage: 78,696 allocs, 10,007 frees, 11,925,853 bytes allocated

After:

==10506==     in use at exit: 8,902,605 bytes in 68,606 blocks
==10506==   total heap usage: 78,696 allocs, 10,091 frees, 11,925,853 bytes allocated

I.e. just 84 detected unmaps with no hits out of 9056 for this workload,
not much, but in some other long running workload this may save more
bytes.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    2 ++
 tools/perf/util/map.c  |   31 +++++++++++++++++++++----------
 tools/perf/util/map.h  |    3 ++-
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a6cea28..e7263d4 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -93,6 +93,8 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	if (self != NULL) {
 		*self = *template;
 		self->nr_events = 1;
+		if (self->ms.map)
+			self->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
 			callchain_init(self->callchain);
 	}
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 801e696..3a7eb6e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -29,6 +29,7 @@ void map__init(struct map *self, enum map_type type,
 	self->unmap_ip = map__unmap_ip;
 	RB_CLEAR_NODE(&self->rb_node);
 	self->groups   = NULL;
+	self->referenced = false;
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
@@ -387,6 +388,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
+	int err = 0;
 
 	while (next) {
 		struct map *pos = rb_entry(next, struct map, rb_node);
@@ -403,20 +405,16 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 
 		rb_erase(&pos->rb_node, root);
 		/*
-		 * We may have references to this map, for instance in some
-		 * hist_entry instances, so just move them to a separate
-		 * list.
-		 */
-		list_add_tail(&pos->node, &self->removed_maps[map->type]);
-		/*
 		 * Now check if we need to create new maps for areas not
 		 * overlapped by the new map:
 		 */
 		if (map->start > pos->start) {
 			struct map *before = map__clone(pos);
 
-			if (before == NULL)
-				return -ENOMEM;
+			if (before == NULL) {
+				err = -ENOMEM;
+				goto move_map;
+			}
 
 			before->end = map->start - 1;
 			map_groups__insert(self, before);
@@ -427,14 +425,27 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 		if (map->end < pos->end) {
 			struct map *after = map__clone(pos);
 
-			if (after == NULL)
-				return -ENOMEM;
+			if (after == NULL) {
+				err = -ENOMEM;
+				goto move_map;
+			}
 
 			after->start = map->end + 1;
 			map_groups__insert(self, after);
 			if (verbose >= 2)
 				map__fprintf(after, fp);
 		}
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
 	}
 
 	return 0;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 5b51bbd..7857579 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -29,7 +29,8 @@ struct map {
 	};
 	u64			start;
 	u64			end;
-	enum map_type		type;
+	u8 /* enum map_type */	type;
+	bool			referenced;
 	u32			priv;
 	u64			pgoff;
 
-- 
1.6.2.5

