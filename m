Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab0FQUhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:37:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:42954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab0FQUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:37:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf session: Remove threads from tree on PERF_RECORD_EXIT
Date: Thu, 17 Jun 2010 17:36:52 -0300
Message-Id: <1276807013-21626-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807013-21626-1-git-send-email-acme@infradead.org>
References: <1276807013-21626-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Move them to a session->dead_threads list just like we do with maps that
are replaced, because we may have hist_entries pointing to them.

This fixes a bug when inserting maps for a new thread that reused the
TID, mixing maps for two different threads, causing an endless loop.

The code for insering maps should be made more robust but for .35 this
is the minimalistic patch.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   |    4 +++-
 tools/perf/util/session.c |   11 +++++++++++
 tools/perf/util/session.h |    2 ++
 tools/perf/util/thread.h  |    5 ++++-
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1f08f00..2fbf6a4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -538,8 +538,10 @@ int event__process_task(event_t *self, struct perf_session *session)
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
 
-	if (self->header.type == PERF_RECORD_EXIT)
+	if (self->header.type == PERF_RECORD_EXIT) {
+		perf_session__remove_thread(session, thread);
 		return 0;
+	}
 
 	if (thread == NULL || parent == NULL ||
 	    thread__fork(thread, parent) < 0) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8f83a18..c422cd6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -90,6 +90,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
+	INIT_LIST_HEAD(&self->dead_threads);
 	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
@@ -131,6 +132,16 @@ void perf_session__delete(struct perf_session *self)
 	free(self);
 }
 
+void perf_session__remove_thread(struct perf_session *self, struct thread *th)
+{
+	rb_erase(&th->rb_node, &self->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &self->dead_threads);
+}
+
 static bool symbol__match_parent_regex(struct symbol *sym)
 {
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 55c6881..9fa0fc2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -26,6 +26,7 @@ struct perf_session {
 	unsigned long		size;
 	unsigned long		mmap_window;
 	struct rb_root		threads;
+	struct list_head	dead_threads;
 	struct thread		*last_match;
 	struct machine		host_machine;
 	struct rb_root		machines;
@@ -99,6 +100,7 @@ int perf_session__create_kernel_maps(struct perf_session *self);
 
 int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
+void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1dfd9ff..ee6bbcf 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -6,7 +6,10 @@
 #include "symbol.h"
 
 struct thread {
-	struct rb_node		rb_node;
+	union {
+		struct rb_node	 rb_node;
+		struct list_head node;
+	};
 	struct map_groups	mg;
 	pid_t			pid;
 	char			shortname[3];
-- 
1.6.2.5

