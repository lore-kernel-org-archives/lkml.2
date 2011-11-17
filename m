Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1KQMaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:30:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1KQMay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:30:54 -0500
Date: Thu, 17 Nov 2011 14:30:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111117123029.GB16853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jump_lable patching is very expensive operation that involves pausing all
cpus. The patching of perf_sched_events jump_label is easily controllable
from userspace by unprivileged user. When user runs loop like this
"while true; do perf stat -e cycles true; done" the performance of my
test application that just increments a counter for one second drops by
4%. This is on a 16 cpu box with my test application using only one of
them. An impact on a real server doing real work will be much worse.
Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
record" since KVM PMU implementation creates and destroys perf event
frequently.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..afac189 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1062,12 +1063,12 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	}
 }
 
-extern struct jump_label_key perf_sched_events;
+extern atomic_t perf_sched_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_branch(&perf_sched_events))
+	if (atomic_read(&perf_sched_events))
 		__perf_event_task_sched_in(prev, task);
 }
 
@@ -1076,7 +1077,7 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	if (static_branch(&perf_sched_events))
+	if (atomic_read(&perf_sched_events))
 		__perf_event_task_sched_out(prev, next);
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bdcd413..8033600 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -128,7 +128,7 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-struct jump_label_key perf_sched_events __read_mostly;
+atomic_t perf_sched_events;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -2943,7 +2963,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_sched_events);
+			atomic_dec(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2954,7 +2974,7 @@ static void free_event(struct perf_event *event)
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec(&perf_sched_events);
+			atomic_dec(&perf_sched_events);
 		}
 	}
 
@@ -5897,7 +5917,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events);
+			atomic_inc(&perf_sched_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6133,7 +6153,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
+		atomic_inc(&perf_sched_events);
 	}
 
 	/*
--
			Gleb.
