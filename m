Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1KDWVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:21:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1KDWVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337217"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 8/9] x86/smpboot.c: Don't offline BSP if any irq can not be migrated out of it
Date: Fri,  4 Nov 2011 15:04:00 -0700
Message-Id: <1320444241-834-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Don't offline BSP if any irq can not be migrated out of it.

Call identify_boot_cpu_online() for BSP in smp_callin() and continue to online
BSP in native_cpu_up().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/smpboot.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..83838c5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -136,8 +136,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 /*
- * Report back to the Boot Processor.
- * Running on AP.
+ * Report back to the Boot Processor during boot time or to the caller processor
+ * during CPU online.
  */
 static void __cpuinit smp_callin(void)
 {
@@ -224,6 +224,13 @@ static void __cpuinit smp_callin(void)
 	smp_store_cpu_info(cpuid);
 
 	/*
+	 * This function won't run on the BSP during boot time. It run
+	 * on BSP only when BSP is offlined and onlined again.
+	 */
+	if (cpuid == 0)
+		identify_boot_cpu_online();
+
+	/*
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
@@ -839,7 +846,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
@@ -1283,12 +1290,34 @@ int native_cpu_disable(void)
 	 * Perhaps use cpufreq to drop frequency, but that could go
 	 * into generic code.
 	 *
-	 * We won't take down the boot processor on i386 due to some
+	 * We won't take down the boot processor on i386 if some
 	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
+	 * Especially so if we're not using an IOAPIC
+	 * -original comment from zwane, changed by fyu
 	 */
-	if (cpu == 0)
-		return -EBUSY;
+	if (cpu == 0) {
+		int irq;
+		struct irq_desc *desc;
+		struct irq_data *data;
+		struct irq_chip *chip;
+
+		for_each_irq_desc(irq, desc) {
+			raw_spin_lock(&desc->lock);
+			if (!irq_has_action(irq)) {
+				raw_spin_unlock(&desc->lock);
+				continue;
+			}
+
+			data = irq_desc_get_irq_data(desc);
+			chip = irq_data_get_irq_chip(data);
+			if (!chip->irq_set_affinity) {
+				pr_debug("irq%d can't move out of BSP\n", irq);
+				raw_spin_unlock(&desc->lock);
+				return -EBUSY;
+			}
+			raw_spin_unlock(&desc->lock);
+		}
+	}
 
 	clear_local_APIC();
 
-- 
1.6.0.3

