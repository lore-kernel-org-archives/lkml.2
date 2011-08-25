Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1HYN6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:58:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1HYN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:58:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=edBeC89/CGIGDe7EQEdrNK81QVpSdX4v2nxik5dwtLX2uB3slJicPf1sdN/RJNXQ8
	q5m4UlnR0OycWNPuzbeIg==
Date: Thu, 25 Aug 2011 15:58:03 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ming.m.lin@intel.com
Subject: [PATCH] perf_event: fix slow and broken cgroup context switch code
Message-ID: <20110825135803.GA4697@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current cgroup context switch code was incorrect leading
to bogus counts. Furthermore, as soon as there was an active
cgroup event on a CPU, the context switch cost on that CPU
would increase by a significant amount as demonstrated by a
simple ping/pong example:

$ ./pong 
Both processes pinned to CPU1, running for 10s
10684.51 ctxsw/s

Now start a cgroup perf stat:
$ perf stat -e cycles,cycles -A -a -G test  -C 1 -- sleep 100

$ ./pong 
Both processes pinned to CPU1, running for 10s
6674.61 ctxsw/s

That's a 37% penalty.

Note that pong is not even in the monitored cgroup.

The results shown by perf stat are bogus:
$ perf stat -e cycles,cycles -A -a -G test  -C 1 -- sleep 100

 Performance counter stats for 'sleep 100':

CPU1 <not counted> cycles   test
CPU1 16,984,189,138 cycles  #    0.000 GHz                    

The second 'cycles' event should report a count @ CPU clock
(here 2.4GHz) as it is counting across all cgroups.

The patch below fixes the bogus accounting and bypasses any
cgroup switches in case the outgoing and incoming tasks are
in the same cgroup.

With this patch the same test now yields:
$ ./pong
Both processes pinned to CPU1, running for 10s
10775.30 ctxsw/s

Start perf stat with cgroup:

$ perf stat -e cycles,cycles -A -a -G test  -C 1 -- sleep 10

Run pong outside the cgroup:
$ /pong 
Both processes pinned to CPU1, running for 10s
10687.80 ctxsw/s

The penalty is now less than 2%.

And the results for perf stat are correct:

$ perf stat -e cycles,cycles -A -a -G test  -C 1 -- sleep 10

 Performance counter stats for 'sleep 10':

CPU1 <not counted> cycles test #    0.000 GHz                    
CPU1 23,933,981,448 cycles      #    0.000 GHz                    

Now perf stat reports the correct counts for 
for the non cgroup event.

If we run pong inside the cgroup, then we also get the
correct counts:

$ perf stat -e cycles,cycles -A -a -G test  -C 1 -- sleep 10

 Performance counter stats for 'sleep 10':

CPU1 22,297,726,205 cycles test #    0.000 GHz                    
CPU1 23,933,981,448 cycles      #    0.000 GHz                    

      10.001457237 seconds time elapsed

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 245bafd..c816075 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -944,8 +944,10 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
-extern void __perf_event_task_sched_in(struct task_struct *task);
-extern void __perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
+extern void __perf_event_task_sched_in(struct task_struct *prev,
+				       struct task_struct *task);
+extern void __perf_event_task_sched_out(struct task_struct *prev,
+					struct task_struct *next);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1059,17 +1061,20 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 
 extern struct jump_label_key perf_sched_events;
 
-static inline void perf_event_task_sched_in(struct task_struct *task)
+static inline void perf_event_task_sched_in(struct task_struct *prev,
+					    struct task_struct *task)
 {
 	if (static_branch(&perf_sched_events))
-		__perf_event_task_sched_in(task);
+		__perf_event_task_sched_in(prev, task);
 }
 
-static inline void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+static inline void perf_event_task_sched_out(struct task_struct *prev,
+					     struct task_struct *next)
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
-	__perf_event_task_sched_out(task, next);
+	if (static_branch(&perf_sched_events))
+		__perf_event_task_sched_out(prev, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
@@ -1139,10 +1144,11 @@ extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
 #else
 static inline void
-perf_event_task_sched_in(struct task_struct *task)			{ }
+perf_event_task_sched_in(struct task_struct *prev,
+			 struct task_struct *task)			{ }
 static inline void
-perf_event_task_sched_out(struct task_struct *task,
-			    struct task_struct *next)			{ }
+perf_event_task_sched_out(struct task_struct *prev,
+			  struct task_struct *next)			{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index adc3ef3..439e315 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -400,14 +400,54 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 	local_irq_restore(flags);
 }
 
-static inline void perf_cgroup_sched_out(struct task_struct *task)
+static inline void perf_cgroup_sched_out(struct task_struct *task,
+					 struct task_struct *next)
 {
-	perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
+	struct perf_cgroup *cgrp1;
+	struct perf_cgroup *cgrp2 = NULL;
+
+	/*
+	 * we come here when we know perf_cgroup_events > 0
+	 */
+	cgrp1 = perf_cgroup_from_task(task);
+
+	/*
+	 * next is NULL when called from perf_event_enable_on_exec()
+	 * that will systematically cause a cgroup_switch()
+	 */
+	if (next)
+		cgrp2 = perf_cgroup_from_task(next);
+
+	/*
+	 * only schedule out current cgroup events if we know
+	 * that we are switching to a different cgroup. Otherwise,
+	 * do no touch the cgroup events.
+	 */
+	if (cgrp1 != cgrp2)
+		perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
 }
 
-static inline void perf_cgroup_sched_in(struct task_struct *task)
+static inline void perf_cgroup_sched_in(struct task_struct *prev,
+					struct task_struct *task)
 {
-	perf_cgroup_switch(task, PERF_CGROUP_SWIN);
+	struct perf_cgroup *cgrp1;
+	struct perf_cgroup *cgrp2 = NULL;
+
+	/*
+	 * we come here when we know perf_cgroup_events > 0
+	 */
+	cgrp1 = perf_cgroup_from_task(task);
+
+	/* prev can never be NULL */
+	cgrp2 = perf_cgroup_from_task(prev);
+
+	/*
+	 * only need to schedule in cgroup events if we are changing
+	 * cgroup during ctxsw. Cgroup events were not scheduled
+	 * out of ctxsw out if that was not the case.
+	 */
+	if (cgrp1 != cgrp2)
+		perf_cgroup_switch(task, PERF_CGROUP_SWIN);
 }
 
 static inline int perf_cgroup_connect(int fd, struct perf_event *event,
@@ -519,11 +559,13 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
 {
 }
 
-static inline void perf_cgroup_sched_out(struct task_struct *task)
+static inline void perf_cgroup_sched_out(struct task_struct *task,
+					 struct task_struct *next)
 {
 }
 
-static inline void perf_cgroup_sched_in(struct task_struct *task)
+static inline void perf_cgroup_sched_in(struct task_struct *prev,
+					struct task_struct *task)
 {
 }
 
@@ -1989,7 +2031,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
 	 * cgroup event are system-wide mode only
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
-		perf_cgroup_sched_out(task);
+		perf_cgroup_sched_out(task, next);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx)
@@ -2154,7 +2196,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void __perf_event_task_sched_in(struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *prev,
+				struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2172,7 +2215,7 @@ void __perf_event_task_sched_in(struct task_struct *task)
 	 * cgroup event are system-wide mode only
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
-		perf_cgroup_sched_in(task);
+		perf_cgroup_sched_in(prev, task);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -2428,7 +2471,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * ctxswin cgroup events which are already scheduled
 	 * in.
 	 */
-	perf_cgroup_sched_out(current);
+	perf_cgroup_sched_out(current, NULL);
 
 	raw_spin_lock(&ctx->lock);
 	task_ctx_sched_out(ctx);
diff --git a/kernel/sched.c b/kernel/sched.c
index 6baade0..f42fa78 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3206,7 +3206,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_disable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-	perf_event_task_sched_in(current);
+	perf_event_task_sched_in(prev, current);
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
