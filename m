Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0HBBJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0HBBJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 18/19] perf tools: Release thread resources on PERF_RECORD_EXIT
Date: Sun,  1 Aug 2010 22:08:53 -0300
Message-Id: <1280711334-30000-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For long running sessions with many threads with short lifetimes the
amount of memory that the buildid process takes is too much.

Since we don't have hist_entries that may be pointing to them, we can
just release the resources associated with each thread when the exit
(PERF_RECORD_EXIT) event is received.

For normal processing we need to annotate maps with hits, and thus
hist_entries pointing to it and drop the ones that had none. Will be
done in a followup patch.

Cc: David S. Miller <davem@davemloft.net>
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
 tools/perf/util/build-id.c |   18 ++++++++++++++++++
 tools/perf/util/map.c      |   33 +++++++++++++++++++++++++++++++++
 tools/perf/util/map.h      |    1 +
 tools/perf/util/thread.c   |    7 +++++++
 tools/perf/util/thread.h   |    2 ++
 5 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5c26e2d..e437edb 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -12,6 +12,7 @@
 #include "event.h"
 #include "symbol.h"
 #include <linux/kernel.h>
+#include "debug.h"
 
 static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
 {
@@ -34,10 +35,27 @@ static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
 	return 0;
 }
 
+static int event__exit_del_thread(event_t *self, struct perf_session *session)
+{
+	struct thread *thread = perf_session__findnew(session, self->fork.tid);
+
+	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
+		    self->fork.ppid, self->fork.ptid);
+
+	if (thread) {
+		rb_erase(&thread->rb_node, &session->threads);
+		session->last_match = NULL;
+		thread__delete(thread);
+	}
+
+	return 0;
+}
+
 struct perf_event_ops build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= event__process_mmap,
 	.fork	= event__process_task,
+	.exit	= event__exit_del_thread,
 };
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 37cab90..2ddbae3 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -228,6 +228,39 @@ void map_groups__init(struct map_groups *self)
 	self->machine = NULL;
 }
 
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
 void map_groups__flush(struct map_groups *self)
 {
 	int type;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 3b2f706..20eba42 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -127,6 +127,7 @@ size_t __map_groups__fprintf_maps(struct map_groups *self,
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 void map_groups__init(struct map_groups *self);
+void map_groups__exit(struct map_groups *self);
 int map_groups__clone(struct map_groups *self,
 		      struct map_groups *parent, enum map_type type);
 size_t map_groups__fprintf(struct map_groups *self, int verbose, FILE *fp);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9a448b4..8c72d88 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -62,6 +62,13 @@ static struct thread *thread__new(pid_t pid)
 	return self;
 }
 
+void thread__delete(struct thread *self)
+{
+	map_groups__exit(&self->mg);
+	free(self->comm);
+	free(self);
+}
+
 int thread__set_comm(struct thread *self, const char *comm)
 {
 	int err;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index ee6bbcf..688500f 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -20,6 +20,8 @@ struct thread {
 
 struct perf_session;
 
+void thread__delete(struct thread *self);
+
 int find_all_tid(int pid, pid_t ** all_tid);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
-- 
1.6.2.5

