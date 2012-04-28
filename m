Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2D1JIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:08:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2D1JIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:08:42 -0400
Date: Sat, 28 Apr 2012 02:08:23 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-13583bf15eb1e890e03d46b6f2753e4b64af21c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tony.luck@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, tony.luck@intel.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120420124557.380965133@linutronix.de>
References: <20120420124557.380965133@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] ia64: Use generic idle thread allocation
Git-Commit-ID: 13583bf15eb1e890e03d46b6f2753e4b64af21c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:08:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13583bf15eb1e890e03d46b6f2753e4b64af21c9
Gitweb:     http://git.kernel.org/tip/13583bf15eb1e890e03d46b6f2753e4b64af21c9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:10 +0200

ia64: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20120420124557.380965133@linutronix.de
---
 arch/ia64/Kconfig          |    1 +
 arch/ia64/kernel/smpboot.c |   61 ++-----------------------------------------
 2 files changed, 4 insertions(+), 58 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index bd72669..1197547 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -33,6 +33,7 @@ config IA64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 03e4ef3..1113b8a 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -75,13 +75,6 @@
 #endif
 
 /*
- * Store all idle threads, this can be reused instead of creating
- * a new thread. Also avoids complicated thread destroy functionality
- * for idle threads.
- */
-struct task_struct *idle_thread_array[NR_CPUS];
-
-/*
  * Global array allocated for NR_CPUS at boot time
  */
 struct sal_to_os_boot sal_boot_rendez_state[NR_CPUS];
@@ -94,13 +87,7 @@ struct sal_to_os_boot *sal_state_for_booting_cpu = &sal_boot_rendez_state[0];
 
 #define set_brendez_area(x) (sal_state_for_booting_cpu = &sal_boot_rendez_state[(x)]);
 
-#define get_idle_for_cpu(x)		(idle_thread_array[(x)])
-#define set_idle_for_cpu(x,p)	(idle_thread_array[(x)] = (p))
-
 #else
-
-#define get_idle_for_cpu(x)		(NULL)
-#define set_idle_for_cpu(x,p)
 #define set_brendez_area(x)
 #endif
 
@@ -480,54 +467,12 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	return NULL;
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-void __cpuinit
-do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 static int __cpuinit
-do_boot_cpu (int sapicid, int cpu)
+do_boot_cpu (int sapicid, int cpu, struct task_struct *idle)
 {
 	int timeout;
-	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER(c_idle.done),
-	};
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
- 	c_idle.idle = get_idle_for_cpu(cpu);
- 	if (c_idle.idle) {
-		init_idle(c_idle.idle, cpu);
- 		goto do_rest;
-	}
-
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-
-	if (IS_ERR(c_idle.idle))
-		panic("failed fork for CPU %d", cpu);
-
-	set_idle_for_cpu(cpu, c_idle.idle);
-
-do_rest:
-	task_for_booting_cpu = c_idle.idle;
 
+	task_for_booting_cpu = idle;
 	Dprintk("Sending wakeup vector %lu to AP 0x%x/0x%x.\n", ap_wakeup_vector, cpu, sapicid);
 
 	set_brendez_area(cpu);
@@ -811,7 +756,7 @@ __cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 	/* Processor goes to start_secondary(), sets online flag */
-	ret = do_boot_cpu(sapicid, cpu);
+	ret = do_boot_cpu(sapicid, cpu, tidle);
 	if (ret < 0)
 		return ret;
 
