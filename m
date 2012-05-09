Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2EIOkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:40:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2EIOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:40:09 -0400
Date: Wed, 9 May 2012 07:39:52 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-o56ajxp1edwqg6x9d31wb805@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] sched, perf:
  Use a single callback into the scheduler
Git-Commit-ID: cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:39:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e
Gitweb:     http://git.kernel.org/tip/cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 8 May 2012 18:56:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:17 +0200

sched, perf: Use a single callback into the scheduler

We can easily use a single callback for both sched-in and sched-out. This
reduces the code footprint in the scheduler path as well as removes
the PMU black spot otherwise present between the out and in callback.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-o56ajxp1edwqg6x9d31wb805@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |   24 ++++++------------------
 kernel/events/core.c       |   14 ++++++++++----
 kernel/sched/core.c        |    9 +--------
 3 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..8adf70e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1084,10 +1084,8 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
-extern void __perf_event_task_sched_in(struct task_struct *prev,
-				       struct task_struct *task);
-extern void __perf_event_task_sched_out(struct task_struct *prev,
-					struct task_struct *next);
+extern void __perf_event_task_sched(struct task_struct *prev,
+				    struct task_struct *next);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1207,20 +1205,13 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 
 extern struct static_key_deferred perf_sched_events;
 
-static inline void perf_event_task_sched_in(struct task_struct *prev,
+static inline void perf_event_task_sched(struct task_struct *prev,
 					    struct task_struct *task)
 {
-	if (static_key_false(&perf_sched_events.key))
-		__perf_event_task_sched_in(prev, task);
-}
-
-static inline void perf_event_task_sched_out(struct task_struct *prev,
-					     struct task_struct *next)
-{
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
 	if (static_key_false(&perf_sched_events.key))
-		__perf_event_task_sched_out(prev, next);
+		__perf_event_task_sched(prev, task);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
@@ -1295,11 +1286,8 @@ extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
 #else
 static inline void
-perf_event_task_sched_in(struct task_struct *prev,
-			 struct task_struct *task)			{ }
-static inline void
-perf_event_task_sched_out(struct task_struct *prev,
-			  struct task_struct *next)			{ }
+perf_event_task_sched(struct task_struct *prev,
+		      struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 00c58df..e82c7a1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2039,8 +2039,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void __perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next)
+static void __perf_event_task_sched_out(struct task_struct *task,
+					struct task_struct *next)
 {
 	int ctxn;
 
@@ -2279,8 +2279,8 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void __perf_event_task_sched_in(struct task_struct *prev,
-				struct task_struct *task)
+static void __perf_event_task_sched_in(struct task_struct *prev,
+				       struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2305,6 +2305,12 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 		perf_branch_stack_sched_in(prev, task);
 }
 
+void __perf_event_task_sched(struct task_struct *prev, struct task_struct *next)
+{
+	__perf_event_task_sched_out(prev, next);
+	__perf_event_task_sched_in(prev, next);
+}
+
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..5c692a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1913,7 +1913,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_info_switch(prev, next);
-	perf_event_task_sched_out(prev, next);
+	perf_event_task_sched(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -1956,13 +1956,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_disable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-	perf_event_task_sched_in(prev, current);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
