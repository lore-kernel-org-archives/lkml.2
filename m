Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0JOEFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:05:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0JOEF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:05:28 -0400
Date: Fri, 15 Oct 2010 00:05:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        kyle@mcmartin.ca
Subject: [PATCH 3/4] cris: convert arch-v32 away from __do_IRQ
Message-ID: <20101015040527.GD6333@bombadil.infradead.org>
References: <20101015040127.GA6333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015040127.GA6333@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, since the caller of do_IRQ and crisv32_do_multiple are
masking and unmasking the relevant interrupts for us, it looks
like handle_simple_irq is appropriate here as well.

Also, remove a pile of unneeded handlers since the defaults will
be fine (or because they're tested for NULL already.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/cris/arch-v32/kernel/irq.c       |   53 +++++++++------------------------
 arch/cris/include/arch-v32/arch/irq.h |    4 +-
 2 files changed, 16 insertions(+), 41 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 4c78afd..6fab3f5 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -277,7 +277,7 @@ out:
 	return cpu;
 }
 
-void crisv32_mask_irq(int irq)
+void crisv32_mask_irq(unsigned int irq)
 {
 	int cpu;
 
@@ -285,41 +285,11 @@ void crisv32_mask_irq(int irq)
 		block_irq(irq, cpu);
 }
 
-void crisv32_unmask_irq(int irq)
+void crisv32_unmask_irq(unsigned int irq)
 {
 	unblock_irq(irq, irq_cpu(irq));
 }
 
-
-static unsigned int startup_crisv32_irq(unsigned int irq)
-{
-	crisv32_unmask_irq(irq);
-	return 0;
-}
-
-static void shutdown_crisv32_irq(unsigned int irq)
-{
-	crisv32_mask_irq(irq);
-}
-
-static void enable_crisv32_irq(unsigned int irq)
-{
-	crisv32_unmask_irq(irq);
-}
-
-static void disable_crisv32_irq(unsigned int irq)
-{
-	crisv32_mask_irq(irq);
-}
-
-static void ack_crisv32_irq(unsigned int irq)
-{
-}
-
-static void end_crisv32_irq(unsigned int irq)
-{
-}
-
 int set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
 {
 	unsigned long flags;
@@ -330,14 +300,16 @@ int set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
 	return 0;
 }
 
+static void crisv32_noop(unsigned int irq)
+{
+}
+
 static struct irq_chip crisv32_irq_type = {
 	.name =        "CRISv32",
-	.startup =     startup_crisv32_irq,
-	.shutdown =    shutdown_crisv32_irq,
-	.enable =      enable_crisv32_irq,
-	.disable =     disable_crisv32_irq,
-	.ack =         ack_crisv32_irq,
-	.end =         end_crisv32_irq,
+	.mask =        crisv32_mask_irq,
+	.disable =     crisv32_mask_irq,
+	.unmask =      crisv32_unmask_irq,
+	.ack =         crisv32_noop,
 	.set_affinity = set_affinity_crisv32_irq
 };
 
@@ -472,15 +444,18 @@ init_IRQ(void)
 
 	/* Point all IRQ's to bad handlers. */
 	for (i = FIRST_IRQ, j = 0; j < NR_IRQS; i++, j++) {
-		set_irq_chip_and_handler(j, &crisv32_irq_type, cris_do_IRQ);
+		set_irq_chip_and_handler(j, &crisv32_irq_type,
+			handle_simple_irq);
 		set_exception_vector(i, interrupt[j]);
 	}
 
         /* Mark Timer and IPI IRQs as CPU local */
 	irq_allocations[TIMER0_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
 	irq_desc[TIMER0_INTR_VECT].status |= IRQ_PER_CPU;
+	set_irq_handler(TIMER0_INTR_VECT, handle_percpu_irq);
 	irq_allocations[IPI_INTR_VECT - FIRST_IRQ].cpu = CPU_FIXED;
 	irq_desc[IPI_INTR_VECT].status |= IRQ_PER_CPU;
+	set_irq_handler(IPI_INTR_VECT, handle_percpu_irq);
 
 	set_exception_vector(0x00, nmi_interrupt);
 	set_exception_vector(0x30, multiple_interrupt);
diff --git a/arch/cris/include/arch-v32/arch/irq.h b/arch/cris/include/arch-v32/arch/irq.h
index b31e998..fbe5d43 100644
--- a/arch/cris/include/arch-v32/arch/irq.h
+++ b/arch/cris/include/arch-v32/arch/irq.h
@@ -23,8 +23,8 @@ struct etrax_interrupt_vector {
 
 extern struct etrax_interrupt_vector *etrax_irv;	/* head.S */
 
-void crisv32_mask_irq(int irq);
-void crisv32_unmask_irq(int irq);
+void crisv32_mask_irq(unsigned int irq);
+void crisv32_unmask_irq(unsigned int irq);
 
 void set_exception_vector(int n, irqvectptr addr);
 
-- 
1.7.3.1

