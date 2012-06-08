Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab2FHPnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:43:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43231 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab2FHPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:43:11 -0400
Date: Fri, 8 Jun 2012 18:43:01 +0300
From: Ido Yariv <ido@wizery.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        kiran.thirumalai@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Ignore IOAPIC IRQ affinity if
 possible
Message-ID: <20120608154301.GA11242@NoteStation>
References: <1338675095-27260-2-git-send-email-ido@wizery.com>
 <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
 <20120608085229.GA10638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608085229.GA10638@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jun 08, 2012 at 10:52:29AM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Ravikiran Thirumalai <kiran.thirumalai@gmail.com> wrote:
> 
> > Commit-ID:  3aabb53ce5849605cee731bbc32f37120b4c4ceb
> > Gitweb:     http://git.kernel.org/tip/3aabb53ce5849605cee731bbc32f37120b4c4ceb
> > Author:     Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
> > AuthorDate: Sun, 3 Jun 2012 01:11:35 +0300
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 6 Jun 2012 09:06:20 +0200
> > 
> > x86/vsmp: Ignore IOAPIC IRQ affinity if possible
> 
> This patch causes the following build failure:
> 
>  (.init.text+0x10626): undefined reference to `no_irq_affinity'
> 
> on UP kernels.

This seems to break when CONFIG_PARAVIRT is set but CONFIG_SMP isn't.
Since there's little point in optimizing IOAPIC routing for UP kernels,
how about the following fix?

Thanks,
Ido.

>From a67a9f5b0efa20c4da0fa85848d6c9e46f8f2665 Mon Sep 17 00:00:00 2001
From: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Date: Sun, 3 Jun 2012 01:11:35 +0300
Subject: [PATCH] x86/vsmp: Ignore IOAPIC IRQ affinity if possible

vSMP can route interrupts more optimally based on internal
knowledge the OS does not have. In order to support this
optimization, all CPUs must be able to handle all possible
IOAPIC interrupts.

Fix this by setting the vector allocation domain for all CPUs
and by enabling this feature in vSMP.

Signed-off-by: Ravikiran Thirumalai <kiran.thirumalai@gmail.com>
Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: rebased, simplified, and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/x86/kernel/vsmp_64.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 59eea85..6b96a73 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -16,6 +16,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/apic.h>
 #include <asm/pci-direct.h>
@@ -95,6 +96,15 @@ static void __init set_vsmp_pv_ops(void)
 	ctl = readl(address + 4);
 	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
 	       cap, ctl);
+
+	/* If possible, let the vSMP foundation route the interrupt optimally */
+#ifdef CONFIG_SMP
+	if (cap & ctl & BIT(8)) {
+		ctl &= ~BIT(8);
+		no_irq_affinity = 1;
+	}
+#endif
+
 	if (cap & ctl & (1 << 4)) {
 		/* Setup irq ops and turn on vSMP  IRQ fastpath handling */
 		pv_irq_ops.irq_disable = PV_CALLEE_SAVE(vsmp_irq_disable);
@@ -102,12 +112,11 @@ static void __init set_vsmp_pv_ops(void)
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
@@ -192,10 +201,20 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
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
-- 
1.7.10.2

