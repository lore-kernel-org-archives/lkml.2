Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1CYNdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:33:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:33071 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173Ab1CYNc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:32:58 -0400
Message-Id: <20110325133203.039794496@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:32:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [patch 2/2] bfin: Convert irq namespace
References: <20110325133039.521553268@linutronix.de>
Content-Disposition: inline; filename=bfin-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new function names. Scripted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
 arch/blackfin/kernel/irqchip.c            |    2 -
 arch/blackfin/mach-common/ints-priority.c |   34 +++++++++++++++---------------
 2 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/arch/blackfin/kernel/irqchip.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/kernel/irqchip.c
+++ linux-2.6-tip/arch/blackfin/kernel/irqchip.c
@@ -48,7 +48,7 @@ int show_interrupts(struct seq_file *p, 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-		seq_printf(p, " %8s", get_irq_desc_chip(desc)->name);
+		seq_printf(p, " %8s", irq_desc_get_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
 			seq_printf(p, "  %s", action->name);
Index: linux-2.6-tip/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/mach-common/ints-priority.c
+++ linux-2.6-tip/arch/blackfin/mach-common/ints-priority.c
@@ -559,7 +559,7 @@ static inline void bfin_set_irq_handler(
 #ifdef CONFIG_IPIPE
 	handle = handle_level_irq;
 #endif
-	__set_irq_handler_unlocked(irq, handle);
+	__irq_set_handler_locked(irq, handle);
 }
 
 static DECLARE_BITMAP(gpio_enabled, MAX_BLACKFIN_GPIOS);
@@ -1163,9 +1163,9 @@ int __init init_arch_irq(void)
 
 	for (irq = 0; irq <= SYS_IRQS; irq++) {
 		if (irq <= IRQ_CORETMR)
-			set_irq_chip(irq, &bfin_core_irqchip);
+			irq_set_chip(irq, &bfin_core_irqchip);
 		else
-			set_irq_chip(irq, &bfin_internal_irqchip);
+			irq_set_chip(irq, &bfin_internal_irqchip);
 
 		switch (irq) {
 #if defined(CONFIG_BF53x)
@@ -1189,50 +1189,50 @@ int __init init_arch_irq(void)
 #elif defined(CONFIG_BF538) || defined(CONFIG_BF539)
 		case IRQ_PORTF_INTA:
 #endif
-			set_irq_chained_handler(irq,
-						bfin_demux_gpio_irq);
+			irq_set_chained_handler(irq, bfin_demux_gpio_irq);
 			break;
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
 		case IRQ_GENERIC_ERROR:
-			set_irq_chained_handler(irq, bfin_demux_error_irq);
+			irq_set_chained_handler(irq, bfin_demux_error_irq);
 			break;
 #endif
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 		case IRQ_MAC_ERROR:
-			set_irq_chained_handler(irq, bfin_demux_mac_status_irq);
+			irq_set_chained_handler(irq,
+						bfin_demux_mac_status_irq);
 			break;
 #endif
 #ifdef CONFIG_SMP
 		case IRQ_SUPPLE_0:
 		case IRQ_SUPPLE_1:
-			set_irq_handler(irq, handle_percpu_irq);
+			irq_set_handler(irq, handle_percpu_irq);
 			break;
 #endif
 
 #ifdef CONFIG_TICKSOURCE_CORETMR
 		case IRQ_CORETMR:
 # ifdef CONFIG_SMP
-			set_irq_handler(irq, handle_percpu_irq);
+			irq_set_handler(irq, handle_percpu_irq);
 			break;
 # else
-			set_irq_handler(irq, handle_simple_irq);
+			irq_set_handler(irq, handle_simple_irq);
 			break;
 # endif
 #endif
 
 #ifdef CONFIG_TICKSOURCE_GPTMR0
 		case IRQ_TIMER0:
-			set_irq_handler(irq, handle_simple_irq);
+			irq_set_handler(irq, handle_simple_irq);
 			break;
 #endif
 
 #ifdef CONFIG_IPIPE
 		default:
-			set_irq_handler(irq, handle_level_irq);
+			irq_set_handler(irq, handle_level_irq);
 			break;
 #else /* !CONFIG_IPIPE */
 		default:
-			set_irq_handler(irq, handle_simple_irq);
+			irq_set_handler(irq, handle_simple_irq);
 			break;
 #endif /* !CONFIG_IPIPE */
 		}
@@ -1240,22 +1240,22 @@ int __init init_arch_irq(void)
 
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
 	for (irq = IRQ_PPI_ERROR; irq <= IRQ_UART1_ERROR; irq++)
-		set_irq_chip_and_handler(irq, &bfin_generic_error_irqchip,
+		irq_set_chip_and_handler(irq, &bfin_generic_error_irqchip,
 					 handle_level_irq);
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
-	set_irq_chained_handler(IRQ_MAC_ERROR, bfin_demux_mac_status_irq);
+	irq_set_chained_handler(IRQ_MAC_ERROR, bfin_demux_mac_status_irq);
 #endif
 #endif
 
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 	for (irq = IRQ_MAC_PHYINT; irq <= IRQ_MAC_STMDONE; irq++)
-		set_irq_chip_and_handler(irq, &bfin_mac_status_irqchip,
+		irq_set_chip_and_handler(irq, &bfin_mac_status_irqchip,
 					 handle_level_irq);
 #endif
 	/* if configured as edge, then will be changed to do_edge_IRQ */
 	for (irq = GPIO_IRQ_BASE;
 		irq < (GPIO_IRQ_BASE + MAX_BLACKFIN_GPIOS); irq++)
-		set_irq_chip_and_handler(irq, &bfin_gpio_irqchip,
+		irq_set_chip_and_handler(irq, &bfin_gpio_irqchip,
 					 handle_level_irq);
 
 	bfin_write_IMASK(0);


