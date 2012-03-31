Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab2CaRHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 13:07:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44663 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2CaRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 13:07:44 -0400
Date: Sat, 31 Mar 2012 19:07:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20120331170739.GA17080@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: e3831edd59edf57ca11fc289f08961b20baf5146 sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()

 Thanks,

	Ingo

------------------>
Catalin Marinas (1):
      sched/arch: Introduce the finish_arch_post_lock_switch() scheduler callback

Srivatsa S. Bhat (1):
      sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()

Stephen Boyd (1):
      sched: Fix __schedule_bug() output when called from an interrupt


 kernel/sched/core.c  |   13 ++++---------
 kernel/sched/sched.h |    3 +++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c1629c..8773176 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1268,7 +1268,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_mask(dest_cpu, *nodemask) {
+	for_each_cpu(dest_cpu, nodemask) {
 		if (!cpu_online(dest_cpu))
 			continue;
 		if (!cpu_active(dest_cpu))
@@ -1279,7 +1279,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	for (;;) {
 		/* Any allowed, online CPU? */
-		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
 			if (!cpu_online(dest_cpu))
 				continue;
 			if (!cpu_active(dest_cpu))
@@ -1962,6 +1962,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	finish_arch_post_lock_switch();
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -3099,8 +3100,6 @@ EXPORT_SYMBOL(sub_preempt_count);
  */
 static noinline void __schedule_bug(struct task_struct *prev)
 {
-	struct pt_regs *regs = get_irq_regs();
-
 	if (oops_in_progress)
 		return;
 
@@ -3111,11 +3110,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
-
-	if (regs)
-		show_regs(regs);
-	else
-		dump_stack();
+	dump_stack();
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 753bdd5..2f7a723 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -681,6 +681,9 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #ifndef finish_arch_switch
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
+#ifndef finish_arch_post_lock_switch
+# define finish_arch_post_lock_switch()	do { } while (0)
+#endif
 
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
