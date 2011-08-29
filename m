Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1H2O5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:57:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:34564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1H2O5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:57:19 -0400
Date: Mon, 29 Aug 2011 14:56:48 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-a8d757ef076f0f95f13a918808824058de25b3eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110825135803.GA4697@quad>
References: <20110825135803.GA4697@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: Fix slow and broken cgroup context switch code
Git-Commit-ID: a8d757ef076f0f95f13a918808824058de25b3eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 29 Aug 2011 14:57:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8d757ef076f0f95f13a918808824058de25b3eb
Gitweb:     http://git.kernel.org/tip/a8d757ef076f0f95f13a918808824058de25b3eb
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 25 Aug 2011 15:58:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Aug 2011 12:28:33 +0200

perf events: Fix slow and broken cgroup context switch code

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110825135803.GA4697@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   24 ++++++++++------
 kernel/events/core.c       |   63 +++++++++++++++++++++++++++++++++++++-------
 kernel/sched.c             |    2 +-
 3 files changed, 69 insertions(+), 20 deletions(-)

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
index b8785e2..45847fb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -399,14 +399,54 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
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
@@ -518,11 +558,13 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx)
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
 
@@ -1988,7 +2030,7 @@ void __perf_event_task_sched_out(struct task_struct *task,
 	 * cgroup event are system-wide mode only
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
-		perf_cgroup_sched_out(task);
+		perf_cgroup_sched_out(task, next);
 }
 
 static void task_ctx_sched_out(struct perf_event_context *ctx)
@@ -2153,7 +2195,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void __perf_event_task_sched_in(struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *prev,
+				struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2171,7 +2214,7 @@ void __perf_event_task_sched_in(struct task_struct *task)
 	 * cgroup event are system-wide mode only
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
-		perf_cgroup_sched_in(task);
+		perf_cgroup_sched_in(prev, task);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -2427,7 +2470,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * ctxswin cgroup events which are already scheduled
 	 * in.
 	 */
-	perf_cgroup_sched_out(current);
+	perf_cgroup_sched_out(current, NULL);
 
 	raw_spin_lock(&ctx->lock);
 	task_ctx_sched_out(ctx);
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..0408cdc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3065,7 +3065,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_disable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-	perf_event_task_sched_in(current);
+	perf_event_task_sched_in(prev, current);
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
