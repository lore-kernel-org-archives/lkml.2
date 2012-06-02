Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926Ab2FBWMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 18:12:23 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44588 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650Ab2FBWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 18:11:58 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>,
        Ravikiran Thirumalai <kiran.thirumalai@gmail.com>,
        Ido Yariv <ido@wizery.com>
Subject: [PATCH v3 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Date: Sun,  3 Jun 2012 01:11:35 +0300
Message-Id: <1338675095-27260-2-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338675095-27260-1-git-send-email-ido@wizery.com>
References: <20120509212117.GA32594@NoteStation.guest.lab126.com>
 <1338675095-27260-1-git-send-email-ido@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>

vSMP can route interrupts more optimally based on internal knowledge the
OS does not have. In order to support this optimization, all CPUs must
be able to handle all possible IOAPIC interrupts.

Fix this by setting the vector allocation domain for all CPUs and by
enabling this feature in vSMP.

Signed-off-by: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: rebased, simplified, and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
Changes from v2:
- Set the vector allocation domain in the apic_post_init callback

 arch/x86/kernel/vsmp_64.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 59eea85..a24cf34 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -16,6 +16,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/apic.h>
 #include <asm/pci-direct.h>
@@ -95,6 +96,13 @@ static void __init set_vsmp_pv_ops(void)
 	ctl = readl(address + 4);
 	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
 	       cap, ctl);
+
+	/* If possible, let the vSMP foundation route the interrupt optimally */
+	if (cap & ctl & BIT(8)) {
+		ctl &= ~BIT(8);
+		no_irq_affinity = 1;
+	}
+
 	if (cap & ctl & (1 << 4)) {
 		/* Setup irq ops and turn on vSMP  IRQ fastpath handling */
 		pv_irq_ops.irq_disable = PV_CALLEE_SAVE(vsmp_irq_disable);
@@ -102,12 +110,11 @@ static void __init set_vsmp_pv_ops(void)
 		pv_irq_ops.save_fl  = PV_CALLEE_SAVE(vsmp_save_fl);
 		pv_irq_ops.restore_fl  = PV_CALLEE_SAVE(vsmp_restore_fl);
 		pv_init_ops.patch = vsmp_patch;
-
 		ctl &= ~(1 << 4);
-		writel(ctl, address + 4);
-		ctl = readl(address + 4);
-		printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);
 	}
+	writel(ctl, address + 4);
+	ctl = readl(address + 4);
+	pr_info("vSMP CTL: control set to:0x%08x\n", ctl);
 
 	early_iounmap(address, 8);
 }
@@ -192,10 +199,20 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
 	return hard_smp_processor_id() >> index_msb;
 }
 
+/*
+ * In vSMP, all cpus should be capable of handling interrupts, regardless of
+ * the apic used.
+ */
+static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_setall(retmask);
+}
+
 static void vsmp_apic_post_init(void)
 {
 	/* need to update phys_pkg_id */
 	apic->phys_pkg_id = apicid_phys_pkg_id;
+	apic->vector_allocation_domain = fill_vector_allocation_domain;
 }
 
 void __init vsmp_init(void)
-- 
1.7.7.6

