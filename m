Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2EUIG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab2EUIGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:06:53 -0400
Date: Mon, 21 May 2012 10:06:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, eranian@google.com
Subject: [RFC][BUG] Revert "sched, perf: Use a single callback into the
 scheduler"
Message-ID: <20120521080626.GA3591@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Arnaldo an I were hunting why test__PERF_RECORD stop work recently.
It seems that following commit is the culprit:

sched, perf: Use a single callback into the scheduler
commit cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue May 8 18:56:04 2012 +0200

the reason seems to be following:

  - before commit this change was introduced, the process switch worked
    like this (wrt to perf event schedule):

    schedule (prev, next)
      - schedule out all perf events for prev
      - switch to next
      - schedule in all perf events for current (next)

  - after the commit, the process switch looks like:

    schedule (prev, next)
      - schedule out all perf events for prev
      - schedule in all perf events for (next)
      - switch to next

The problem is, that after we schedule perf events in, the pmu is
enabled and we can receive events even before we make the switch
to next - so "current" still being prev process (event SAMPLE data
are filled based on the value of the "current" process).

Thats exactly what we see for test__PERF_RECORD test. We receive
SAMPLES with PID of the process that our tracee is scheduled from.
Most of the time it's parent, sometimes idle (0).

I tried to keep the current code and add a new hook from finish_task_switch
to enable related PMUs for task.. but I'm getting following warning:

WARNING: at arch/x86/kernel/cpu/perf_event.c:1054 x86_pmu_start+0x133/0x140()

which I haven't figured out yet... also I'm not sure if thats even
right thing to do ;)

thoughts? thanks,
jirka


---
This reverts commit cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e.
---
 include/linux/perf_event.h |   24 ++++++++++++++++++------
 kernel/events/core.c       |   14 ++++----------
 kernel/sched/core.c        |    9 ++++++++-
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8adf70e..f325786 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1084,8 +1084,10 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
-extern void __perf_event_task_sched(struct task_struct *prev,
-				    struct task_struct *next);
+extern void __perf_event_task_sched_in(struct task_struct *prev,
+				       struct task_struct *task);
+extern void __perf_event_task_sched_out(struct task_struct *prev,
+					struct task_struct *next);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1205,13 +1207,20 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 
 extern struct static_key_deferred perf_sched_events;
 
-static inline void perf_event_task_sched(struct task_struct *prev,
+static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
+	if (static_key_false(&perf_sched_events.key))
+		__perf_event_task_sched_in(prev, task);
+}
+
+static inline void perf_event_task_sched_out(struct task_struct *prev,
+					     struct task_struct *next)
+{
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
 	if (static_key_false(&perf_sched_events.key))
-		__perf_event_task_sched(prev, task);
+		__perf_event_task_sched_out(prev, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
@@ -1286,8 +1295,11 @@ extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
 #else
 static inline void
-perf_event_task_sched(struct task_struct *prev,
-		      struct task_struct *task)				{ }
+perf_event_task_sched_in(struct task_struct *prev,
+			 struct task_struct *task)			{ }
+static inline void
+perf_event_task_sched_out(struct task_struct *prev,
+			  struct task_struct *next)			{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91a4459..5b06cbb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2039,8 +2039,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-static void __perf_event_task_sched_out(struct task_struct *task,
-					struct task_struct *next)
+void __perf_event_task_sched_out(struct task_struct *task,
+				 struct task_struct *next)
 {
 	int ctxn;
 
@@ -2279,8 +2279,8 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-static void __perf_event_task_sched_in(struct task_struct *prev,
-				       struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *prev,
+				struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2305,12 +2305,6 @@ static void __perf_event_task_sched_in(struct task_struct *prev,
 		perf_branch_stack_sched_in(prev, task);
 }
 
-void __perf_event_task_sched(struct task_struct *prev, struct task_struct *next)
-{
-	__perf_event_task_sched_out(prev, next);
-	__perf_event_task_sched_in(prev, next);
-}
-
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 18eed17..90c2427 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1913,7 +1913,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_info_switch(prev, next);
-	perf_event_task_sched(prev, next);
+	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -1956,6 +1956,13 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_disable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+	perf_event_task_sched_in(prev, current);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
-- 
1.7.7.6

