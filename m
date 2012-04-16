Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2DPHju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:39:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41742 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2DPHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:39:48 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>,
        Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 2/2] vsmp: Ignore IOAPIC IRQ affinity if possible
Date: Mon, 16 Apr 2012 10:39:36 +0300
Message-Id: <1334561976-13965-2-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334561976-13965-1-git-send-email-ido@wizery.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
 <1334561976-13965-1-git-send-email-ido@wizery.com>
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
Changes from v1:
- Updated Kiran's email address

 arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
 arch/x86/kernel/vsmp_64.c       |   15 +++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 3fe9866..0f96703 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -29,6 +29,15 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
 }
 
 /*
+ * In vSMP, all cpus should be capable of handling interrupts, regardless of
+ * the apic used.
+ */
+static void fill_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_setall(retmask);
+}
+
+/*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init default_setup_apic_routing(void)
@@ -51,6 +60,7 @@ void __init default_setup_apic_routing(void)
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
+		apic->vector_allocation_domain = fill_vector_allocation_domain;
 	}
 }
 
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 61571fd..c91b08f 100644
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
+	/*
+	 * If possible, let the vSMP foundation route the interrupt optimally */
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
+	printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);
 
 	early_iounmap(address, 8);
 }
-- 
1.7.7.6

