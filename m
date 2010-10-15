Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab0JOEFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:05:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0JOEFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:05:24 -0400
Date: Fri, 15 Oct 2010 00:05:23 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        kyle@mcmartin.ca
Subject: [PATCH 2/4] cris: convert arch-v10 away from __do_IRQ
Message-ID: <20101015040523.GC6333@bombadil.infradead.org>
References: <20101015040127.GA6333@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015040127.GA6333@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like handle_simple_irq will be fine here, since the do_IRQ
code is masking the interrupts for us.

Also remove a pile of unneeded handlers where the defaults filled
in by the genirq layer will do.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/cris/arch-v10/kernel/irq.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/irq.c b/arch/cris/arch-v10/kernel/irq.c
index 25d6252..07f17ce 100644
--- a/arch/cris/arch-v10/kernel/irq.c
+++ b/arch/cris/arch-v10/kernel/irq.c
@@ -104,16 +104,6 @@ static void (*interrupt[NR_IRQS])(void) = {
 	IRQ31_interrupt
 };
 
-static void enable_crisv10_irq(unsigned int irq);
-
-static unsigned int startup_crisv10_irq(unsigned int irq)
-{
-	enable_crisv10_irq(irq);
-	return 0;
-}
-
-#define shutdown_crisv10_irq	disable_crisv10_irq
-
 static void enable_crisv10_irq(unsigned int irq)
 {
 	crisv10_unmask_irq(irq);
@@ -124,22 +114,16 @@ static void disable_crisv10_irq(unsigned int irq)
 	crisv10_mask_irq(irq);
 }
 
-static void ack_crisv10_irq(unsigned int irq)
-{
-}
-
-static void end_crisv10_irq(unsigned int irq)
+static void crisv10_noop(unsigned int irq)
 {
 }
 
 static struct irq_chip crisv10_irq_type = {
 	.name =        "CRISv10",
-	.startup =     startup_crisv10_irq,
-	.shutdown =    shutdown_crisv10_irq,
-	.enable =      enable_crisv10_irq,
+	.unmask =      enable_crisv10_irq,
+	.mask =        disable_crisv10_irq,
 	.disable =     disable_crisv10_irq,
-	.ack =         ack_crisv10_irq,
-	.end =         end_crisv10_irq,
+	.ack =         crisv10_noop,
 	.set_affinity = NULL
 };
 
@@ -221,7 +205,7 @@ init_IRQ(void)
 
 	/* Initialize IRQ handler descriptors. */
 	for(i = 2; i < NR_IRQS; i++) {
-		set_irq_chip_and_handler(i, &crisv10_irq_type, cris_do_IRQ);
+		set_irq_chip_and_handler(i, &crisv10_irq_type, handle_simple_irq);
 		set_int_vector(i, interrupt[i]);
 	}
 
-- 
1.7.3.1

