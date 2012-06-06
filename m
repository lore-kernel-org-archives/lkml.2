Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab2FFPC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:02:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2FFPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:02:24 -0400
Date: Wed, 6 Jun 2012 08:02:13 -0700
From: tip-bot for Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Message-ID: <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, kiran.thirumalai@gmail.com, ido@wizery.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, kiran.thirumalai@gmail.com, tglx@linutronix.de,
        ido@wizery.com
In-Reply-To: <1338675095-27260-2-git-send-email-ido@wizery.com>
References: <1338675095-27260-2-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/vsmp:
  Ignore IOAPIC IRQ affinity if possible
Git-Commit-ID: 3aabb53ce5849605cee731bbc32f37120b4c4ceb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:02:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aabb53ce5849605cee731bbc32f37120b4c4ceb
Gitweb:     http://git.kernel.org/tip/3aabb53ce5849605cee731bbc32f37120b4c4ceb
Author:     Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
AuthorDate: Sun, 3 Jun 2012 01:11:35 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 09:06:20 +0200

x86/vsmp: Ignore IOAPIC IRQ affinity if possible

vSMP can route interrupts more optimally based on internal
knowledge the OS does not have. In order to support this
optimization, all CPUs must be able to handle all possible
IOAPIC interrupts.

Fix this by setting the vector allocation domain for all CPUs
and by enabling this feature in vSMP.

Signed-off-by: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ rebased, simplified, and reworded the commit message ]
Signed-off-by: Ido Yariv <ido@wizery.com>
Link: http://lkml.kernel.org/r/1338675095-27260-2-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsmp_64.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 59eea85..c72c0d3 100644
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
+ * the APIC used.
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
