Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab1KQMtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:49:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:55491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1KQMtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:49:50 -0500
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Nov 2011 13:49:19 +0100
In-Reply-To: <20111117123029.GB16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321534159.27735.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 14:30 +0200, Gleb Natapov wrote:
> jump_lable patching is very expensive operation that involves pausing all
> cpus. The patching of perf_sched_events jump_label is easily controllable
> from userspace by unprivileged user. When user runs loop like this
> "while true; do perf stat -e cycles true; done" the performance of my
> test application that just increments a counter for one second drops by
> 4%. This is on a 16 cpu box with my test application using only one of
> them. An impact on a real server doing real work will be much worse.
> Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
> record" since KVM PMU implementation creates and destroys perf event
> frequently.

Ideally we'd fix text_poke to not use stop_machine() we know how to, but
we haven't had the green light from Intel/AMD yet.

Rostedt was going to implement it anyway and see if anything breaks.

Also, virt might be able to pull something smart on text_poke() dunno.

That said, I'd much rather throttle this particular jump label than
remove it altogether, some people really don't like all this scheduler
hot path crap.

Something I've pondered for a while but never actually tried yet (and it
hasn't even seen a compiler) is something like the below, I don't think
there's any reason to have two scheduler hooks.

It wouldn't solve your problem, but having only one hooks does make it
easier to play around with throttling stuff.

---
 include/linux/perf_event.h |   19 +++++--------------
 kernel/events/core.c       |   14 ++++++++++----
 kernel/sched.c             |    9 +--------
 3 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..f1f621a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -947,10 +947,8 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
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
@@ -1064,20 +1062,13 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 
 extern struct jump_label_key perf_sched_events;
 
-static inline void perf_event_task_sched_in(struct task_struct *prev,
-					    struct task_struct *task)
-{
-	if (static_branch(&perf_sched_events))
-		__perf_event_task_sched_in(prev, task);
-}
-
-static inline void perf_event_task_sched_out(struct task_struct *prev,
-					     struct task_struct *next)
+static inline void perf_event_task_sched(struct task_struct *prev,
+					 struct task_struct *next)
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
 	if (static_branch(&perf_sched_events))
-		__perf_event_task_sched_out(prev, next);
+		__perf_event_task_sched(prev, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2e41c8e..bf9bccb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2019,8 +2019,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void __perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next)
+static void 
+__perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
 	int ctxn;
 
@@ -2199,8 +2199,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void __perf_event_task_sched_in(struct task_struct *prev,
-				struct task_struct *task)
+static void
+__perf_event_task_sched_in(struct task_struct *prev, struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2221,6 +2221,12 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 		perf_cgroup_sched_in(prev, task);
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
diff --git a/kernel/sched.c b/kernel/sched.c
index c9e3ab6..657bbc1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3183,7 +3183,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_info_switch(prev, next);
-	perf_event_task_sched_out(prev, next);
+	perf_event_task_sched(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -3226,13 +3226,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
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
 
 	fire_sched_in_preempt_notifiers(current);

