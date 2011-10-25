Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1JYLt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:49:28 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:58591 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1JYLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:49:27 -0400
Message-ID: <4EA6A23D.3080605@scalemp.com>
Date: Tue, 25 Oct 2011 13:49:17 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: [PATCH] IRQ: no IRQ affinity patch
References: <4EA66964.8050602@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274368@VMBX108.ihostexchange.net>
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274368@VMBX108.ihostexchange.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell vSMP Foundation to ignore IOAPIC irq routing and make the kernel
work in this mode by setting vector_allocation for all CPUs, so IDT
on all processors will accept this interrupt.

Signed-off-by: Eial Czerwacki<eial@scalemp.com>
Signed-off-by: Shai Fultheim<shai@scalemp.com>
Author: Ravikiran Thirumalai<kiran@scalemp.com>
---

Index: b/arch/x86/kernel/vsmp_64.c
===================================================================
--- a/arch/x86/kernel/vsmp_64.c	2010-05-12 14:59:32.000000000 -0700
+++ b/arch/x86/kernel/vsmp_64.c	2010-05-24 11:58:28.000000000 -0700
@@ -15,6 +15,7 @@
   #include<linux/init.h>
   #include<linux/pci_ids.h>
   #include<linux/pci_regs.h>
+#include<linux/irq.h>

   #include<asm/apic.h>
   #include<asm/pci-direct.h>
@@ -92,6 +93,12 @@ static void __init set_vsmp_pv_ops(void)
   	ctl = readl(address + 4);
   	printk(KERN_INFO "vSMP CTL: capabilities:0x%08x  control:0x%08x\n",
   	       cap, ctl);
+	/* Set irqrouting to ignore since this vsmp */
+	if (cap&   ctl&   (1<<   8)) {
+		ctl&= ~(1<<   8);
+		no_irq_affinity = 1;
+	}
+
   	if (cap&   ctl&   (1<<   4)) {
   		/* Setup irq ops and turn on vSMP  IRQ fastpath handling */
   		pv_irq_ops.irq_disable = PV_CALLEE_SAVE(vsmp_irq_disable);
@@ -99,12 +106,11 @@ static void __init set_vsmp_pv_ops(void)
   		pv_irq_ops.save_fl  = PV_CALLEE_SAVE(vsmp_save_fl);
   		pv_irq_ops.restore_fl  = PV_CALLEE_SAVE(vsmp_restore_fl);
   		pv_init_ops.patch = vsmp_patch;
-
   		ctl&= ~(1<<   4);
-		writel(ctl, address + 4);
-		ctl = readl(address + 4);
-		printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);
   	}
+	writel(ctl, address + 4);
+	ctl = readl(address + 4);
+	printk(KERN_INFO "vSMP CTL: control set to:0x%08x\n", ctl);

   	early_iounmap(address, 8);
   }

Index: b/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- a/arch/x86/kernel/apic/apic_flat_64.c	2010-05-12 14:59:32.000000000 -0700
+++ b/arch/x86/kernel/apic/apic_flat_64.c	2010-05-24 11:58:28.000000000 -0700
@@ -52,7 +52,10 @@
   	 * hyperthread was specified in the interrupt desitination.
   	 */
   	cpumask_clear(retmask);
-	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
+	if(is_vsmp_box())
+		cpumask_setall(retmask);
+	else
+		cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
   }

   /*
@@ -263,7 +266,10 @@
   static void physflat_vector_allocation_domain(int cpu, struct cpumask *retmask)
   {
   	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
+	if(is_vsmp_box())
+		cpumask_setall(retmask);
+	else
+		cpumask_set_cpu(cpu, retmask);
   }

   static void physflat_send_IPI_mask(const struct cpumask *cpumask, int vector)

Index: b/arch/x86/include/asm/x2apic.h
===================================================================
--- a/arch/x86/include/asm/x2apic.h 	2010-05-12 14:59:32.000000000 -0700
+++ b/arch/x86/include/asm/x2apic.h 	2010-05-24 11:58:28.000000000 -0700
@@ -29,7 +29,10 @@
   static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
   {
   	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
+	if(is_vsmp_box())
+		cpumask_setall(retmask);
+	else
+		cpumask_set_cpu(cpu, retmask);
   }

   static void



