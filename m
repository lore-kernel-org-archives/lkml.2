Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab1BJXh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:37:27 -0500
Received: from www.tglx.de ([62.245.132.106]:44216 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433Ab1BJXhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:24 -0500
Message-Id: <20110210223257.489197200@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 33/75] gpio: Remove broken irq_desc hackery.
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=gpio-kill-broken-hack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No code outside of core is supposed to fiddle with this. If there is
something missing in core, then talk to me and we'll fix it. But
fiddling in core guts just because it can be done is a nono. Using it
unlocked and writing a comment about it is ....

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpio/gpiolib.c |   44 --------------------------------------------
 1 file changed, 44 deletions(-)

Index: linux-2.6-tip/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/gpiolib.c
+++ linux-2.6-tip/drivers/gpio/gpiolib.c
@@ -1657,50 +1657,6 @@ static void gpiolib_dbg_show(struct seq_
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ");
 
-		if (!is_out) {
-			int		irq = gpio_to_irq(gpio);
-			struct irq_desc	*desc = irq_to_desc(irq);
-
-			/* This races with request_irq(), set_irq_type(),
-			 * and set_irq_wake() ... but those are "rare".
-			 *
-			 * More significantly, trigger type flags aren't
-			 * currently maintained by genirq.
-			 */
-			if (irq >= 0 && desc->action) {
-				char *trigger;
-
-				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-					irq, trigger,
-					(desc->status & IRQ_WAKEUP)
-						? " wakeup" : "");
-			}
-		}
-
 		seq_printf(s, "\n");
 	}
 }


