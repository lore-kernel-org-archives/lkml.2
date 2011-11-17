Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1KQL3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:29:11 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56841 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab1KQL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:29:08 -0500
Subject: [RFC PATCH v2 3/4] cpuidle: (POWER) Enable cpuidle and directly call
 cpuidle_idle_call() for pSeries
To: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 17 Nov 2011 16:58:59 +0530
Message-ID: <20111117112852.9191.34256.stgit@localhost6.localdomain6>
In-Reply-To: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111701-7014-0000-0000-00000017E4E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables cpuidle for pSeries and cpuidle_idle_call() is
directly called from the idle loop. As a result pseries_idle cpuidle
driver registered with cpuidle subsystem comes into action. This patch
also removes the routines pseries_shared_idle_sleep and
pseries_dedicated_idle_sleep as they are now implemented as part of
pseries_idle cpuidle driver.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Trinabh Gupta <g.trinabh@gmail.com>
Signed-off-by: Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
---
 arch/powerpc/platforms/Kconfig         |    6 ++
 arch/powerpc/platforms/pseries/setup.c |   86 +-------------------------------
 include/linux/cpuidle.h                |    2 -
 3 files changed, 8 insertions(+), 86 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index e458872..0d2a028 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -211,6 +211,12 @@ config PPC_PASEMI_CPUFREQ
 
 endmenu
 
+menu "CPUIdle driver"
+
+source "drivers/cpuidle/Kconfig"
+
+endmenu
+
 config PPC601_SYNC_FIX
 	bool "Workarounds for PPC601 bugs"
 	depends on 6xx && (PPC_PREP || PPC_PMAC)
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 9c6716a..f624e74 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
+#include <linux/cpuidle.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
@@ -74,9 +75,6 @@ EXPORT_SYMBOL(CMO_PageSize);
 
 int fwnmi_active;  /* TRUE if an FWNMI handler is present */
 
-static void pseries_shared_idle_sleep(void);
-static void pseries_dedicated_idle_sleep(void);
-
 static struct device_node *pSeries_mpic_node;
 
 static void pSeries_show_cpuinfo(struct seq_file *m)
@@ -374,18 +372,9 @@ static void __init pSeries_setup_arch(void)
 
 	pSeries_nvram_init();
 
-	/* Choose an idle loop */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
 		vpa_init(boot_cpuid);
-		if (get_lppaca()->shared_proc) {
-			printk(KERN_DEBUG "Using shared processor idle loop\n");
-			ppc_md.power_save = pseries_shared_idle_sleep;
-		} else {
-			printk(KERN_DEBUG "Using dedicated idle loop\n");
-			ppc_md.power_save = pseries_dedicated_idle_sleep;
-		}
-	} else {
-		printk(KERN_DEBUG "Using default idle loop\n");
+		ppc_md.power_save = (void *)cpuidle_idle_call;
 	}
 
 	if (firmware_has_feature(FW_FEATURE_LPAR))
@@ -586,77 +575,6 @@ static int __init pSeries_probe(void)
 	return 1;
 }
 
-static void pseries_dedicated_idle_sleep(void)
-{ 
-	unsigned int cpu = smp_processor_id();
-	unsigned long start_snooze;
-	unsigned long in_purr, out_purr;
-	long snooze = __get_cpu_var(smt_snooze_delay);
-
-	/*
-	 * Indicate to the HV that we are idle. Now would be
-	 * a good time to find other work to dispatch.
-	 */
-	get_lppaca()->idle = 1;
-	get_lppaca()->donate_dedicated_cpu = 1;
-	in_purr = mfspr(SPRN_PURR);
-
-	/*
-	 * We come in with interrupts disabled, and need_resched()
-	 * has been checked recently.  If we should poll for a little
-	 * while, do so.
-	 */
-	if (snooze) {
-		start_snooze = get_tb() + snooze * tb_ticks_per_usec;
-		local_irq_enable();
-		set_thread_flag(TIF_POLLING_NRFLAG);
-
-		while ((snooze < 0) || (get_tb() < start_snooze)) {
-			if (need_resched() || cpu_is_offline(cpu))
-				goto out;
-			ppc64_runlatch_off();
-			HMT_low();
-			HMT_very_low();
-		}
-
-		HMT_medium();
-		clear_thread_flag(TIF_POLLING_NRFLAG);
-		smp_mb();
-		local_irq_disable();
-		if (need_resched() || cpu_is_offline(cpu))
-			goto out;
-	}
-
-	cede_processor();
-
-out:
-	HMT_medium();
-	out_purr = mfspr(SPRN_PURR);
-	get_lppaca()->wait_state_cycles += out_purr - in_purr;
-	get_lppaca()->donate_dedicated_cpu = 0;
-	get_lppaca()->idle = 0;
-}
-
-static void pseries_shared_idle_sleep(void)
-{
-	/*
-	 * Indicate to the HV that we are idle. Now would be
-	 * a good time to find other work to dispatch.
-	 */
-	get_lppaca()->idle = 1;
-
-	/*
-	 * Yield the processor to the hypervisor.  We return if
-	 * an external interrupt occurs (which are driven prior
-	 * to returning here) or if a prod occurs from another
-	 * processor. When returning here, external interrupts
-	 * are enabled.
-	 */
-	cede_processor();
-
-	get_lppaca()->idle = 0;
-}
-
 static int pSeries_pci_probe_mode(struct pci_bus *bus)
 {
 	if (firmware_has_feature(FW_FEATURE_LPAR))
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 7408af8..23f81de 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -130,7 +130,6 @@ struct cpuidle_driver {
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
 extern int cpuidle_idle_call(void);
-
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 struct cpuidle_driver *cpuidle_get_driver(void);
 extern void cpuidle_unregister_driver(struct cpuidle_driver *drv);
@@ -145,7 +144,6 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
 #else
 static inline void disable_cpuidle(void) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
-
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }

