Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab1CYLMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:38591 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934552Ab1CYLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:33 -0400
Message-Id: <20110325111218.345624524@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 08/10] mfd: twl6030: Cleanup interrupt handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfdtwl6.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_desc checking in the interrupt demux routine is totally
pointless. The driver sets those lines up, so that cant go away
magically.

Remove the open coded handler magic and use the proper accessor.

This driver needs to be converted to threaded interrupts and buslock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/twl6030-irq.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

Index: linux-2.6-tip/drivers/mfd/twl6030-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/twl6030-irq.c
+++ linux-2.6-tip/drivers/mfd/twl6030-irq.c
@@ -140,22 +140,7 @@ static int twl6030_irq_thread(void *data
 			if (sts.int_sts & 0x1) {
 				int module_irq = twl6030_irq_base +
 					twl6030_interrupt_mapping[i];
-				struct irq_desc *d = irq_to_desc(module_irq);
-
-				if (!d) {
-					pr_err("twl6030: Invalid SIH IRQ: %d\n",
-					       module_irq);
-					return -EINVAL;
-				}
-
-				/* These can't be masked ... always warn
-				 * if we get any surprises.
-				 */
-				if (d->status & IRQ_DISABLED)
-					note_interrupt(module_irq, d,
-							IRQ_NONE);
-				else
-					d->handle_irq(module_irq, d);
+				generic_handle_irq(module_irq);
 
 			}
 		local_irq_enable();


