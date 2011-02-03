Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1BCArr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:47 -0500
Received: from www.tglx.de ([62.245.132.106]:37648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab1BCArd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:33 -0500
Message-Id: <20110203004210.143127544@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 2/8] ia64: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=ia64-remove-stale-irq_chip-end.pach
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/hp/sim/hpsim_irq.c  |    1 -
 arch/ia64/kernel/iosapic.c    |    2 --
 arch/ia64/kernel/irq_lsapic.c |    1 -
 arch/ia64/sn/kernel/irq.c     |   23 -----------------------
 4 files changed, 27 deletions(-)

Index: linux-2.6-tip/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6-tip/arch/ia64/hp/sim/hpsim_irq.c
@@ -34,7 +34,6 @@ static struct irq_chip irq_type_hp_sim =
 	.enable =	hpsim_irq_noop,
 	.disable =	hpsim_irq_noop,
 	.ack =		hpsim_irq_noop,
-	.end =		hpsim_irq_noop,
 	.set_affinity =	hpsim_set_affinity_noop,
 };
 
Index: linux-2.6-tip/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6-tip/arch/ia64/kernel/iosapic.c
@@ -460,7 +460,6 @@ iosapic_ack_edge_irq (unsigned int irq)
 
 #define iosapic_enable_edge_irq		unmask_irq
 #define iosapic_disable_edge_irq	nop
-#define iosapic_end_edge_irq		nop
 
 static struct irq_chip irq_type_iosapic_edge = {
 	.name =		"IO-SAPIC-edge",
@@ -469,7 +468,6 @@ static struct irq_chip irq_type_iosapic_
 	.enable =	iosapic_enable_edge_irq,
 	.disable =	iosapic_disable_edge_irq,
 	.ack =		iosapic_ack_edge_irq,
-	.end =		iosapic_end_edge_irq,
 	.mask =		mask_irq,
 	.unmask =	unmask_irq,
 	.set_affinity =	iosapic_set_affinity
Index: linux-2.6-tip/arch/ia64/kernel/irq_lsapic.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/irq_lsapic.c
+++ linux-2.6-tip/arch/ia64/kernel/irq_lsapic.c
@@ -40,6 +40,5 @@ struct irq_chip irq_type_ia64_lsapic = {
 	.enable =	lsapic_noop,
 	.disable =	lsapic_noop,
 	.ack =		lsapic_noop,
-	.end =		lsapic_noop,
 	.retrigger =	lsapic_retrigger,
 };
Index: linux-2.6-tip/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6-tip/arch/ia64/sn/kernel/irq.c
@@ -114,28 +114,6 @@ static void sn_ack_irq(unsigned int irq)
 	move_native_irq(irq);
 }
 
-static void sn_end_irq(unsigned int irq)
-{
-	int ivec;
-	u64 event_occurred;
-
-	ivec = irq & 0xff;
-	if (ivec == SGI_UART_VECTOR) {
-		event_occurred = HUB_L((u64*)LOCAL_MMR_ADDR (SH_EVENT_OCCURRED));
-		/* If the UART bit is set here, we may have received an
-		 * interrupt from the UART that the driver missed.  To
-		 * make sure, we IPI ourselves to force us to look again.
-		 */
-		if (event_occurred & SH_EVENT_OCCURRED_UART_INT_MASK) {
-			platform_send_ipi(smp_processor_id(), SGI_UART_VECTOR,
-					  IA64_IPI_DM_INT, 0);
-		}
-	}
-	__clear_bit(ivec, (volatile void *)pda->sn_in_service_ivecs);
-	if (sn_force_interrupt_flag)
-		force_interrupt(irq);
-}
-
 static void sn_irq_info_free(struct rcu_head *head);
 
 struct sn_irq_info *sn_retarget_vector(struct sn_irq_info *sn_irq_info,
@@ -275,7 +253,6 @@ struct irq_chip irq_type_sn = {
 	.enable		= sn_enable_irq,
 	.disable	= sn_disable_irq,
 	.ack		= sn_ack_irq,
-	.end		= sn_end_irq,
 	.mask		= sn_mask_irq,
 	.unmask		= sn_unmask_irq,
 	.set_affinity	= sn_set_affinity_irq


