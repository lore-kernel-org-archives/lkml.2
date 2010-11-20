Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0KTAJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:09:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:31929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0KTAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:09:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,226,1288594800"; 
   d="scan'208";a="679266930"
Subject: [patch] x86: avoid unnecessary smp alternatives switch during
 suspend/resume
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 19 Nov 2010 16:09:24 -0800
Message-Id: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend, we disable all the non boot cpus. And during resume we bring
them all back again. So no need to do alternatives_smp_switch() in between.

This speeds up both suspend and resume paths.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

 arch/x86/kernel/smpboot.c |    7 ++++++-
 include/linux/cpu.h       |    2 ++
 kernel/cpu.c              |    3 +++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f0a0624..0b04ca3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1349,7 +1349,12 @@ void native_cpu_die(unsigned int cpu)
 			if (system_state == SYSTEM_RUNNING)
 				pr_info("CPU %u is now offline\n", cpu);
 
-			if (1 == num_online_cpus())
+			/*
+			 * Don't do the smp alternatives switch during
+			 * suspend. We will be back in the SMP mode after
+			 * resume.
+			 */
+			if (1 == num_online_cpus() && !pm_sleep_smp)
 				alternatives_smp_switch(0);
 			return;
 		}
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4823af6..8cab04c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -169,11 +169,13 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #ifdef CONFIG_PM_SLEEP_SMP
 extern int suspend_cpu_hotplug;
+extern int pm_sleep_smp;
 
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
 #else /* !CONFIG_PM_SLEEP_SMP */
 #define suspend_cpu_hotplug	0
+#define pm_sleep_smp		0
 
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8615aa6..2eed810 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -381,6 +381,7 @@ out:
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
+int pm_sleep_smp;
 
 int disable_nonboot_cpus(void)
 {
@@ -393,6 +394,7 @@ int disable_nonboot_cpus(void)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
+	pm_sleep_smp = 1;
 
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
@@ -454,6 +456,7 @@ void __ref enable_nonboot_cpus(void)
 
 	cpumask_clear(frozen_cpus);
 out:
+	pm_sleep_smp = 0;
 	cpu_maps_update_done();
 }
 


