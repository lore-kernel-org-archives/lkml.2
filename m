Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2EJQcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:32:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:3905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab2EJQ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142389134"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq can not be migrated out of it and remove CPU0 check in smp_callin()
Date: Thu, 10 May 2012 09:16:46 -0700
Message-Id: <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Don't offline CPU0 if any irq can not be migrated out of it.

Call identify_boot_cpu_online() for CPU0 in smp_callin() and continue to online
CPU0 in native_cpu_up().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/smpboot.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e543e02..fa3822e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -121,8 +121,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 /*
- * Report back to the Boot Processor.
- * Running on AP.
+ * Report back to the Boot Processor during boot time or to the caller processor
+ * during CPU online.
  */
 static void __cpuinit smp_callin(void)
 {
@@ -210,6 +210,13 @@ static void __cpuinit smp_callin(void)
 	pr_debug("Stack at about %p\n", &cpuid);
 
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
@@ -778,7 +785,7 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	if (apicid == BAD_APICID ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
 	    !apic->apic_id_valid(apicid)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
@@ -1224,12 +1231,33 @@ int native_cpu_disable(void)
 	 * Perhaps use cpufreq to drop frequency, but that could go
 	 * into generic code.
 	 *
-	 * We won't take down the boot processor on i386 due to some
+	 * We won't take down the boot processor on x86 if some
 	 * interrupts only being able to be serviced by the BSP.
-	 * Especially so if we're not using an IOAPIC	-zwane
+	 * Especially so if we're not using an IOAPIC
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

