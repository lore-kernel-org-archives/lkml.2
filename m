Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab1FSIqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:46:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1FSIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:46:43 -0400
Date: Sun, 19 Jun 2011 10:46:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] generic IPI fix
Message-ID: <20110619084638.GA23754@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Takao Indoh (1):
      generic-ipi: Fix kexec boot crash by initializing call_single_queue before enabling interrupts


 include/linux/smp.h |    5 ++++-
 init/main.c         |    1 +
 kernel/smp.c        |    5 +----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 7ad824d..8cc38d3 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -85,12 +85,15 @@ int smp_call_function_any(const struct cpumask *mask,
  * Generic and arch helpers
  */
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
+void __init call_function_init(void);
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
 void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
+#else
+static inline void call_function_init(void) { }
 #endif
 
 /*
@@ -134,7 +137,7 @@ static inline void smp_send_reschedule(int cpu) { }
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_many(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-static inline void init_call_single_data(void) { }
+static inline void call_function_init(void) { }
 
 static inline int
 smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
diff --git a/init/main.c b/init/main.c
index cafba67..d7211fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -542,6 +542,7 @@ asmlinkage void __init start_kernel(void)
 	timekeeping_init();
 	time_init();
 	profile_init();
+	call_function_init();
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
 				 "enabled early\n");
diff --git a/kernel/smp.c b/kernel/smp.c
index 73a1951..fb67dfa 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -74,7 +74,7 @@ static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
 	.notifier_call		= hotplug_cfd,
 };
 
-static int __cpuinit init_call_single_data(void)
+void __init call_function_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int i;
@@ -88,10 +88,7 @@ static int __cpuinit init_call_single_data(void)
 
 	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
 	register_cpu_notifier(&hotplug_cfd_notifier);
-
-	return 0;
 }
-early_initcall(init_call_single_data);
 
 /*
  * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
