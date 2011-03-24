Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1CXV1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:27:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:39938 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756800Ab1CXV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:27:37 -0400
Message-Id: <20110324212508.931638262@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 Mar 2011 21:27:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 1/3] arm/gpio: Remove three copies of broken and racy debug
	code
References: <20110324212330.292903803@linutronix.de>
Content-Disposition: inline; filename=remove-gpio-crap.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiolib plus two gpio implementations in arm fiddle in the guts of
irq_desc in a racy and buggy way. Remove the stuff. I already told the
gpio folks that we can provide that information in a proper way if
necessary.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-ep93xx/gpio.c  |   39 -------------------------------------
 arch/arm/plat-nomadik/gpio.c |   45 -------------------------------------------
 drivers/gpio/gpiolib.c       |   45 -------------------------------------------
 3 files changed, 129 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
@@ -366,45 +366,6 @@ static void ep93xx_gpio_dbg_show(struct 
 				gpiochip_is_requested(chip, i) ? : "",
 				is_out ? "out" : "in ",
 				(data_reg & (1 << i)) ? "hi" : "lo");
-
-		if (!is_out) {
-			int irq = gpio_to_irq(gpio);
-			struct irq_desc *desc = irq_desc + irq;
-
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
-						irq, trigger,
-						(desc->status & IRQ_WAKEUP)
-							? " wakeup" : "");
-			}
-		}
-
 		seq_printf(s, "\n");
 	}
 }
Index: linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/plat-nomadik/gpio.c
+++ linux-2.6-tip/arch/arm/plat-nomadik/gpio.c
@@ -832,51 +832,6 @@ static void nmk_gpio_dbg_show(struct seq
 				: "?  ",
 			(mode < 0) ? "unknown" : modes[mode],
 			pull ? "pull" : "none");
-
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
Index: linux-2.6-tip/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/gpiolib.c
+++ linux-2.6-tip/drivers/gpio/gpiolib.c
@@ -1656,51 +1656,6 @@ static void gpiolib_dbg_show(struct seq_
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
 				: "?  ");
-
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


