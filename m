Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0L1AzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:55:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44142 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0L1AzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:55:18 -0500
Message-ID: <4D193533.6060103@kernel.org>
Date: Mon, 27 Dec 2010 16:54:11 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, sparseirq: let nr_irqs equal to NR_IRQS
References: <4CEB877D.9060709@kernel.org> <4CF75626.6000306@kernel.org> <alpine.LFD.2.00.1012021019060.2653@localhost6.localdomain6> <4CF7FA58.8070803@kernel.org> <alpine.LFD.2.00.1012022112400.2653@localhost6.localdomain6> <4CF7FF66.3010802@kernel.org> <alpine.LFD.2.00.1012022125401.2653@localhost6.localdomain6> <20101222125711.GI10809@elte.hu>
In-Reply-To: <20101222125711.GI10809@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



For x86_64 system:
when we have 128 cpus with 5 ioapics, will have nr_irqs = 3064
	120 + 8 * 128 + 120 * 16
systems could take 20 pcie,  when intel 10g are used with
sriov and ixgbevf, every vf will need 3 irqs, and one device
have 64 vf. so will need 20 * 3 * 64 = 3840.
some 6 ports Intel 10gb may need more.

Just remove that function for x86, and let nr_irqs to NR_IRQS
because We already have radix-tree and bit_map for searching desc for irq.

Notes: long before same vresion cause one of Ingo's setup udev hang...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   22 ----------------------
 1 file changed, 22 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3637,28 +3637,6 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
-int __init arch_probe_nr_irqs(void)
-{
-	int nr;
-
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
-
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += nr_irqs_gsi * 16;
-#endif
-	if (nr < nr_irqs)
-		nr_irqs = nr;
-
-	return NR_IRQS_LEGACY;
-}
-#endif
-
 static int __io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
