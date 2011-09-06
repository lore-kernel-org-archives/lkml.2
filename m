Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1IFS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:59:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:50714 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1IFS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:59:42 -0400
Date: Tue, 6 Sep 2011 20:59:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@tglx.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] perf fixes for 3.1
Message-ID: <alpine.LFD.2.02.1109062057490.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git perf-fixes-for-linus

top commit sha1 on my devel machine is: 20afc60f892d285f

Thanks,

	tglx

------------------>
Andrey Vagin (1):
      x86, perf: Check that current->mm is alive before getting user callchain

Eric B Munson (1):
      perf_event: Fix broken calc_timer_values()

Stephane Eranian (1):
      perf events: Fix slow and broken cgroup context switch code


 arch/x86/kernel/cpu/perf_event.c |    3 ++
 include/linux/perf_event.h       |   24 ++++++++-----
 kernel/events/core.c             |   67 +++++++++++++++++++++++++++++++-------
 kernel/sched.c                   |    2 +-
 4 files changed, 74 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..cfa62ec 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1900,6 +1900,9 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	perf_callchain_store(entry, regs->ip);
 
+	if (!current->mm)
+		return;
+
 	if (perf_callchain_user32(regs, entry))
 		return;
 
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
index b8785e2..0f85778 100644
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
@@ -3353,8 +3396,8 @@ static int perf_event_index(struct perf_event *event)
 }
 
 static void calc_timer_values(struct perf_event *event,
-				u64 *running,
-				u64 *enabled)
+				u64 *enabled,
+				u64 *running)
 {
 	u64 now, ctx_time;
 
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
