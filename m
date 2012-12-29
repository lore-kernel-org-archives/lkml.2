Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2L2Qo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:44:26 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34498 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2L2QoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:16 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 26/27] profiling: Remove unused timer hook
Date: Sat, 29 Dec 2012 17:43:05 +0100
Message-Id: <1356799386-4212-27-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last remaining user was oprofile and its use has been removed
a while ago on commit bc078e4eab65f11bbaeed380593ab8151b30d703
"oprofile: convert oprofile from timer_hook to hrtimer".

There doesn't seem to be any upstream user of this hook
for about two years now. And I'm not even aware of any out of tree
user.

Let's remove it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/profile.h |   13 -------------
 kernel/profile.c        |   24 ------------------------
 2 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/include/linux/profile.h b/include/linux/profile.h
index a0fc322..2112390 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -82,9 +82,6 @@ int task_handoff_unregister(struct notifier_block * n);
 int profile_event_register(enum profile_type, struct notifier_block * n);
 int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
-int register_timer_hook(int (*hook)(struct pt_regs *));
-void unregister_timer_hook(int (*hook)(struct pt_regs *));
-
 struct pt_regs;
 
 #else
@@ -135,16 +132,6 @@ static inline int profile_event_unregister(enum profile_type t, struct notifier_
 #define profile_handoff_task(a) (0)
 #define profile_munmap(a) do { } while (0)
 
-static inline int register_timer_hook(int (*hook)(struct pt_regs *))
-{
-	return -ENOSYS;
-}
-
-static inline void unregister_timer_hook(int (*hook)(struct pt_regs *))
-{
-	return;
-}
-
 #endif /* CONFIG_PROFILING */
 
 #endif /* _LINUX_PROFILE_H */
diff --git a/kernel/profile.c b/kernel/profile.c
index 1f39181..dc3384e 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -37,9 +37,6 @@ struct profile_hit {
 #define NR_PROFILE_HIT		(PAGE_SIZE/sizeof(struct profile_hit))
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
-/* Oprofile timer tick hook */
-static int (*timer_hook)(struct pt_regs *) __read_mostly;
-
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
@@ -208,25 +205,6 @@ int profile_event_unregister(enum profile_type type, struct notifier_block *n)
 }
 EXPORT_SYMBOL_GPL(profile_event_unregister);
 
-int register_timer_hook(int (*hook)(struct pt_regs *))
-{
-	if (timer_hook)
-		return -EBUSY;
-	timer_hook = hook;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(register_timer_hook);
-
-void unregister_timer_hook(int (*hook)(struct pt_regs *))
-{
-	WARN_ON(hook != timer_hook);
-	timer_hook = NULL;
-	/* make sure all CPUs see the NULL hook */
-	synchronize_sched();  /* Allow ongoing interrupts to complete. */
-}
-EXPORT_SYMBOL_GPL(unregister_timer_hook);
-
-
 #ifdef CONFIG_SMP
 /*
  * Each cpu has a pair of open-addressed hashtables for pending
@@ -436,8 +414,6 @@ void profile_tick(int type)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	if (type == CPU_PROFILING && timer_hook)
-		timer_hook(regs);
 	if (!user_mode(regs) && prof_cpu_mask != NULL &&
 	    cpumask_test_cpu(smp_processor_id(), prof_cpu_mask))
 		profile_hit(type, (void *)profile_pc(regs));
-- 
1.7.5.4

