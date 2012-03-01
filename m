Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2CAMTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:19:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab2CAMTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:19:41 -0500
Date: Thu, 1 Mar 2012 04:19:06 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-gs88fvx2mdv5psnzxnv575ke@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Document scheduler related skip-resched-check sites
Git-Commit-ID: ba74c1448f127649046615ec017bded7b2a76f29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:19:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba74c1448f127649046615ec017bded7b2a76f29
Gitweb:     http://git.kernel.org/tip/ba74c1448f127649046615ec017bded7b2a76f29
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 21 Mar 2011 13:32:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:04 +0100

sched/rt: Document scheduler related skip-resched-check sites

Create a distinction between scheduler related preempt_enable_no_resched()
calls and the nearly one hundred other places in the kernel that do not
want to reschedule, for one reason or another.

This distinction matters for -rt, where the scheduler and the non-scheduler
preempt models (and checks) are different. For upstream it's purely
documentational.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-gs88fvx2mdv5psnzxnv575ke@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/idle.c     |    2 +-
 arch/sparc/kernel/process_64.c |    2 +-
 include/linux/preempt.h        |    5 ++++-
 kernel/sched/core.c            |    6 +++---
 kernel/softirq.c               |    4 ++--
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 6503514..c97fc60 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -102,7 +102,7 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		if (cpu_should_die()) {
-			preempt_enable_no_resched();
+			sched_preempt_enable_no_resched();
 			cpu_die();
 		}
 		schedule_preempt_disabled();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index ab9a292..06b5b5f 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -106,7 +106,7 @@ void cpu_idle(void)
 
 #ifdef CONFIG_HOTPLUG_CPU
 		if (cpu_is_offline(cpu)) {
-			preempt_enable_no_resched();
+			sched_preempt_enable_no_resched();
 			cpu_play_dead();
 		}
 #endif
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 58969b2..5a710b9 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -48,12 +48,14 @@ do { \
 	barrier(); \
 } while (0)
 
-#define preempt_enable_no_resched() \
+#define sched_preempt_enable_no_resched() \
 do { \
 	barrier(); \
 	dec_preempt_count(); \
 } while (0)
 
+#define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
+
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
@@ -92,6 +94,7 @@ do { \
 #else /* !CONFIG_PREEMPT_COUNT */
 
 #define preempt_disable()		do { } while (0)
+#define sched_preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7302239..643cc37 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3220,7 +3220,7 @@ need_resched:
 
 	post_schedule(rq);
 
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 	if (need_resched())
 		goto need_resched;
 }
@@ -3253,7 +3253,7 @@ EXPORT_SYMBOL(schedule);
  */
 void __sched schedule_preempt_disabled(void)
 {
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
 }
@@ -4486,7 +4486,7 @@ SYSCALL_DEFINE0(sched_yield)
 	__release(rq->lock);
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 	do_raw_spin_unlock(&rq->lock);
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 
 	schedule();
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 79b5247..f268369 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -353,7 +353,7 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 }
 
 /*
@@ -759,7 +759,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 			if (local_softirq_pending())
 				__do_softirq();
 			local_irq_enable();
-			preempt_enable_no_resched();
+			sched_preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
 			rcu_note_context_switch((long)__bind_cpu);
