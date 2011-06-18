Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1FRVGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:06:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1FRVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:06:43 -0400
Date: Sat, 18 Jun 2011 21:05:44 GMT
From: tip-bot for Takao Indoh <indou.takao@jp.fujitsu.com>
Message-ID: <tip-d8ad7d1123a960cc9f276bd499f9325c6f5e1bd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        axboe@kernel.dk, a.p.zijlstra@chello.nl, miltonm@bga.com,
        vgoyal@redhat.com, indou.takao@jp.fujitsu.com,
        xiyou.wangcong@gmail.com, paulmck@linux.vnet.ibm.com,
        nhorman@tuxdriver.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, axboe@kernel.dk, miltonm@bga.com,
        indou.takao@jp.fujitsu.com, vgoyal@redhat.com,
        xiyou.wangcong@gmail.com, paulmck@linux.vnet.ibm.com,
        nhorman@tuxdriver.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
References: <D6CBEE2F420741indou.takao@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] generic-ipi: Fix kexec boot crash by initializing call_single_queue before enabling interrupts
Git-Commit-ID: d8ad7d1123a960cc9f276bd499f9325c6f5e1bd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Jun 2011 21:05:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8ad7d1123a960cc9f276bd499f9325c6f5e1bd1
Gitweb:     http://git.kernel.org/tip/d8ad7d1123a960cc9f276bd499f9325c6f5e1bd1
Author:     Takao Indoh <indou.takao@jp.fujitsu.com>
AuthorDate: Tue, 29 Mar 2011 12:35:04 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Jun 2011 10:17:12 +0200

generic-ipi: Fix kexec boot crash by initializing call_single_queue before enabling interrupts

There is a problem that kdump(2nd kernel) sometimes hangs up due
to a pending IPI from 1st kernel. Kernel panic occurs because IPI
comes before call_single_queue is initialized.

To fix the crash, rename init_call_single_data() to call_function_init()
and call it in start_kernel() so that call_single_queue can be
initialized before enabling interrupts.

The details of the crash are:

 (1) 2nd kernel boots up

 (2) A pending IPI from 1st kernel comes when irqs are first enabled
     in start_kernel().

 (3) Kernel tries to handle the interrupt, but call_single_queue
     is not initialized yet at this point. As a result, in the
     generic_smp_call_function_single_interrupt(), NULL pointer
     dereference occurs when list_replace_init() tries to access
     &q->list.next.

Therefore this patch changes the name of init_call_single_data()
to call_function_init() and calls it before local_irq_enable()
in start_kernel().

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Milton Miller <miltonm@bga.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: kexec@lists.infradead.org
Link: http://lkml.kernel.org/r/D6CBEE2F420741indou.takao@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
