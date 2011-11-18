Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab1KRNr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:47:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab1KRNrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:47:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/5] perf tool: Fix session host_nachine retrieval
Date: Fri, 18 Nov 2011 14:46:41 +0100
Message-Id: <1321624005-6889-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host_machine is statically included inside perf_session struct
so it is always present.

Changing function:
'perf_session__find_host_machine' to 'perf_session__host_machine'

Removing NULL checking code after this function, since it is not needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-inject.c |    6 +-----
 tools/perf/builtin-kmem.c   |   12 +++++-------
 tools/perf/builtin-record.c |    6 +-----
 tools/perf/builtin-top.c    |    4 ++--
 tools/perf/util/event.c     |   14 +++++---------
 tools/perf/util/session.h   |    6 +++---
 6 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8dfc12b..3c5eb3a 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -111,11 +111,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 		return -1;
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (machine == NULL) {
-		pr_err("Can't find machine for session\n");
-		return -1;
-	}
+	machine = perf_session__host_machine(session);
 
 	if (self->kernel)
 		misc = PERF_RECORD_MISC_KERNEL;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 225e963..2ca8206 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -342,7 +342,6 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			   int n_lines, int is_caller)
 {
 	struct rb_node *next;
-	struct machine *machine;
 
 	printf("%.102s\n", graph_dotted_line);
 	printf(" %-34s |",  is_caller ? "Callsite": "Alloc Ptr");
@@ -351,11 +350,6 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 
 	next = rb_first(root);
 
-	machine = perf_session__find_host_machine(session);
-	if (!machine) {
-		pr_err("__print_result: couldn't find kernel information\n");
-		return;
-	}
 	while (next && n_lines--) {
 		struct alloc_stat *data = rb_entry(next, struct alloc_stat,
 						   node);
@@ -366,8 +360,12 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 
 		if (is_caller) {
 			addr = data->call_site;
-			if (!raw_ip)
+			if (!raw_ip) {
+				struct machine *machine;
+
+				machine = perf_session__host_machine(session);
 				sym = machine__find_kernel_function(machine, addr, &map, NULL);
+			}
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6ab58cc..1132e70 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -662,11 +662,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (!machine) {
-		pr_err("Couldn't find native kernel information.\n");
-		return -1;
-	}
+	machine = perf_session__host_machine(session);
 
 	err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
 						 session, machine, "_text");
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9cdedb..8e02027 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -692,13 +692,13 @@ static void perf_event__process_sample(const union perf_event *event,
 		++top.us_samples;
 		if (top.hide_user_symbols)
 			return;
-		machine = perf_session__find_host_machine(session);
+		machine = perf_session__host_machine(session);
 		break;
 	case PERF_RECORD_MISC_KERNEL:
 		++top.kernel_samples;
 		if (top.hide_kernel_symbols)
 			return;
-		machine = perf_session__find_host_machine(session);
+		machine = perf_session__host_machine(session);
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
 		++top.guest_kernel_samples;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 437f8ca..35817fa 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -589,12 +589,12 @@ int perf_event__process_mmap(union perf_event *event,
 		return 0;
 	}
 
-	machine = perf_session__find_host_machine(session);
-	if (machine == NULL)
-		goto out_problem;
 	thread = perf_session__findnew(session, event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
+
+	machine = perf_session__host_machine(session);
+
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
 			event->mmap.pid, event->mmap.filename,
@@ -672,15 +672,11 @@ void thread__find_addr_map(struct thread *self,
 
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
-		machine = perf_session__find_host_machine(session);
-		if (machine == NULL) {
-			al->map = NULL;
-			return;
-		}
+		machine = perf_session__host_machine(session);
 		mg = &machine->kmaps;
 	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
-		machine = perf_session__find_host_machine(session);
+		machine = perf_session__host_machine(session);
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		al->level = 'g';
 		machine = perf_session__find_machine(session, pid);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6e393c9..a81d666 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -121,7 +121,7 @@ void perf_session__update_sample_type(struct perf_session *self);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
-struct machine *perf_session__find_host_machine(struct perf_session *self)
+struct machine *perf_session__host_machine(struct perf_session *self)
 {
 	return &self->host_machine;
 }
@@ -130,7 +130,7 @@ static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
 {
 	if (pid == HOST_KERNEL_ID)
-		return &self->host_machine;
+		return perf_session__host_machine(self);
 	return machines__find(&self->machines, pid);
 }
 
@@ -138,7 +138,7 @@ static inline
 struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t pid)
 {
 	if (pid == HOST_KERNEL_ID)
-		return &self->host_machine;
+		return perf_session__host_machine(self);
 	return machines__findnew(&self->machines, pid);
 }
 
-- 
1.7.4

