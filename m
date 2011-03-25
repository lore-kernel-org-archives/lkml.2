Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab1CYLOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:14:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:38564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934512Ab1CYLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:29 -0400
Message-Id: <20110325111217.864886972@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 03/10] mfd: ezx-pcap: Remvove open coded irq handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-ezx.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in checking irq_desc here, as it _is_ available. The
driver configured those lines, so they cannot go away.

The home brewn disabled/note_interrupt magic can be removed as well by
adding a irq_disable callback which avoids the lazy disable.

That driver needs to be converted to threaded interrupts.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/ezx-pcap.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/drivers/mfd/ezx-pcap.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/ezx-pcap.c
+++ linux-2.6-tip/drivers/mfd/ezx-pcap.c
@@ -162,6 +162,7 @@ static void pcap_unmask_irq(struct irq_d
 
 static struct irq_chip pcap_irq_chip = {
 	.name		= "pcap",
+	.irq_disable	= pcap_mask_irq,
 	.irq_mask	= pcap_mask_irq,
 	.irq_unmask	= pcap_unmask_irq,
 };
@@ -196,17 +197,8 @@ static void pcap_isr_work(struct work_st
 		local_irq_disable();
 		service = isr & ~msr;
 		for (irq = pcap->irq_base; service; service >>= 1, irq++) {
-			if (service & 1) {
-				struct irq_desc *desc = irq_to_desc(irq);
-
-				if (WARN(!desc, "Invalid PCAP IRQ %d\n", irq))
-					break;
-
-				if (desc->status & IRQ_DISABLED)
-					note_interrupt(irq, desc, IRQ_NONE);
-				else
-					desc->handle_irq(irq, desc);
-			}
+			if (service & 1)
+				generic_handle_irq(irq);
 		}
 		local_irq_enable();
 		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);


