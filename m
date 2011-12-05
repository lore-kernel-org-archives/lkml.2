Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1LEMvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:51:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1LEMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:51:05 -0500
Date: Mon, 5 Dec 2011 04:50:03 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mdg7sm6j3va09vtgj49gbsrp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Move threads to struct machine
Git-Commit-ID: b424eba27160dd19577896d4520b8eebabed919f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:50:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b424eba27160dd19577896d4520b8eebabed919f
Gitweb:     http://git.kernel.org/tip/b424eba27160dd19577896d4520b8eebabed919f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 9 Nov 2011 13:24:25 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:35:31 -0200

perf session: Move threads to struct machine

The 'machine' abstraction was introduced with 'perf kvm' where we could
have samples for the host and multiple guests, but at the time we ended
up keeping the list of all machines threads all in
session->host_machine.

Move the threads rb_tree to struct machine to separate the namespaces.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mdg7sm6j3va09vtgj49gbsrp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/build-id.c |    4 +-
 tools/perf/util/map.c      |    4 +++
 tools/perf/util/map.h      |    9 ++++++++
 tools/perf/util/session.c  |   47 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/session.h  |    3 --
 tools/perf/util/thread.c   |    6 ++--
 6 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index a91cd99..f2fe6ec 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -48,8 +48,8 @@ static int perf_event__exit_del_thread(union perf_event *event,
 		    event->fork.ppid, event->fork.ptid);
 
 	if (thread) {
-		rb_erase(&thread->rb_node, &session->threads);
-		session->last_match = NULL;
+		rb_erase(&thread->rb_node, &session->host_machine.threads);
+		session->host_machine.last_match = NULL;
 		thread__delete(thread);
 	}
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 78284b1..316aa0a 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -562,6 +562,10 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid)
 	INIT_LIST_HEAD(&self->user_dsos);
 	INIT_LIST_HEAD(&self->kernel_dsos);
 
+	self->threads = RB_ROOT;
+	INIT_LIST_HEAD(&self->dead_threads);
+	self->last_match = NULL;
+
 	self->kmaps.machine = self;
 	self->pid	    = pid;
 	self->root_dir      = strdup(root_dir);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 890d855..bde6835 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -62,6 +62,9 @@ struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
 	char		  *root_dir;
+	struct rb_root	  threads;
+	struct list_head  dead_threads;
+	struct thread	  *last_match;
 	struct list_head  user_dsos;
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
@@ -190,6 +193,12 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
+
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
+void machine__remove_thread(struct machine *machine, struct thread *th);
+
+size_t machine__fprintf(struct machine *machine, FILE *fp);
+
 static inline
 struct symbol *machine__find_kernel_symbol(struct machine *self,
 					   enum map_type type, u64 addr,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..a76666f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -139,9 +139,6 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 		goto out;
 
 	memcpy(self->filename, filename, len);
-	self->threads = RB_ROOT;
-	INIT_LIST_HEAD(&self->dead_threads);
-	self->last_match = NULL;
 	/*
 	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
 	 * slices. On 32bit we use 32MB.
@@ -184,17 +181,22 @@ out_delete:
 	return NULL;
 }
 
-static void perf_session__delete_dead_threads(struct perf_session *self)
+static void machine__delete_dead_threads(struct machine *machine)
 {
 	struct thread *n, *t;
 
-	list_for_each_entry_safe(t, n, &self->dead_threads, node) {
+	list_for_each_entry_safe(t, n, &machine->dead_threads, node) {
 		list_del(&t->node);
 		thread__delete(t);
 	}
 }
 
-static void perf_session__delete_threads(struct perf_session *self)
+static void perf_session__delete_dead_threads(struct perf_session *session)
+{
+	machine__delete_dead_threads(&session->host_machine);
+}
+
+static void machine__delete_threads(struct machine *self)
 {
 	struct rb_node *nd = rb_first(&self->threads);
 
@@ -207,6 +209,11 @@ static void perf_session__delete_threads(struct perf_session *self)
 	}
 }
 
+static void perf_session__delete_threads(struct perf_session *session)
+{
+	machine__delete_threads(&session->host_machine);
+}
+
 void perf_session__delete(struct perf_session *self)
 {
 	perf_session__destroy_kernel_maps(self);
@@ -217,7 +224,7 @@ void perf_session__delete(struct perf_session *self)
 	free(self);
 }
 
-void perf_session__remove_thread(struct perf_session *self, struct thread *th)
+void machine__remove_thread(struct machine *self, struct thread *th)
 {
 	self->last_match = NULL;
 	rb_erase(&th->rb_node, &self->threads);
@@ -884,6 +891,11 @@ void perf_event_header__bswap(struct perf_event_header *self)
 	self->size = bswap_16(self->size);
 }
 
+struct thread *perf_session__findnew(struct perf_session *session, pid_t pid)
+{
+	return machine__findnew_thread(&session->host_machine, pid);
+}
+
 static struct thread *perf_session__register_idle_thread(struct perf_session *self)
 {
 	struct thread *thread = perf_session__findnew(self, 0);
@@ -1224,6 +1236,27 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	return ret;
 }
 
+size_t perf_session__fprintf(struct perf_session *session, FILE *fp)
+{
+	/*
+	 * FIXME: Here we have to actually print all the machines in this
+	 * session, not just the host...
+	 */
+	return machine__fprintf(&session->host_machine, fp);
+}
+
+void perf_session__remove_thread(struct perf_session *session,
+				 struct thread *th)
+{
+	/*
+	 * FIXME: This one makes no sense, we need to remove the thread from
+	 * the machine it belongs to, perf_session can have many machines, so
+	 * doing it always on ->host_machine is wrong.  Fix when auditing all
+	 * the 'perf kvm' code.
+	 */
+	machine__remove_thread(&session->host_machine, th);
+}
+
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					      unsigned int type)
 {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6e393c9..76d462d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,9 +30,6 @@ struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
 	unsigned long		mmap_window;
-	struct rb_root		threads;
-	struct list_head	dead_threads;
-	struct thread		*last_match;
 	struct machine		host_machine;
 	struct rb_root		machines;
 	struct perf_evlist	*evlist;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index d5d3b22..fb4b7ea 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -61,7 +61,7 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	       map_groups__fprintf(&self->mg, verbose, fp);
 }
 
-struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
+struct thread *machine__findnew_thread(struct machine *self, pid_t pid)
 {
 	struct rb_node **p = &self->threads.rb_node;
 	struct rb_node *parent = NULL;
@@ -125,12 +125,12 @@ int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
+size_t machine__fprintf(struct machine *machine, FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->threads); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
 		struct thread *pos = rb_entry(nd, struct thread, rb_node);
 
 		ret += thread__fprintf(pos, fp);
