Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1CYNYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:24:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:34668 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639Ab1CYNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:07 -0400
Message-Id: <20110325132048.810036564@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 13:22:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [patch 15/23] arm: ep93xx: Use proper irq accessor functions
References: <20110325131617.258789658@linutronix.de>
Content-Disposition: inline; filename=arm-ep93xx.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to write the flow type. Core code does already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-ep93xx/gpio.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
+++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
@@ -117,7 +117,7 @@ static void ep93xx_gpio_irq_ack(struct i
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc[d->irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 		ep93xx_gpio_update_int_params(port);
 	}
@@ -131,7 +131,7 @@ static void ep93xx_gpio_irq_mask_ack(str
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
 
-	if ((irq_desc[d->irq].status & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
 
 	gpio_int_unmasked[port] &= ~port_mask;
@@ -165,10 +165,10 @@ static void ep93xx_gpio_irq_unmask(struc
  */
 static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
-	struct irq_desc *desc = irq_desc + d->irq;
 	const int gpio = irq_to_gpio(d->irq);
 	const int port = gpio >> 3;
 	const int port_mask = 1 << (gpio & 7);
+	irq_flow_handler_t handler;
 
 	gpio_direction_input(gpio);
 
@@ -176,22 +176,22 @@ static int ep93xx_gpio_irq_type(struct i
 	case IRQ_TYPE_EDGE_RISING:
 		gpio_int_type1[port] |= port_mask;
 		gpio_int_type2[port] |= port_mask;
-		desc->handle_irq = handle_edge_irq;
+		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		gpio_int_type1[port] |= port_mask;
 		gpio_int_type2[port] &= ~port_mask;
-		desc->handle_irq = handle_edge_irq;
+		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		gpio_int_type1[port] &= ~port_mask;
 		gpio_int_type2[port] |= port_mask;
-		desc->handle_irq = handle_level_irq;
+		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		gpio_int_type1[port] &= ~port_mask;
 		gpio_int_type2[port] &= ~port_mask;
-		desc->handle_irq = handle_level_irq;
+		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
 		gpio_int_type1[port] |= port_mask;
@@ -200,17 +200,16 @@ static int ep93xx_gpio_irq_type(struct i
 			gpio_int_type2[port] &= ~port_mask; /* falling */
 		else
 			gpio_int_type2[port] |= port_mask; /* rising */
-		desc->handle_irq = handle_edge_irq;
+		handler = handle_edge_irq;
 		break;
 	default:
 		pr_err("failed to set irq type %d for gpio %d\n", type, gpio);
 		return -EINVAL;
 	}
 
-	gpio_int_enabled[port] |= port_mask;
+	__set_irq_handler_locked(d->irq, handler);
 
-	desc->status &= ~IRQ_TYPE_SENSE_MASK;
-	desc->status |= type & IRQ_TYPE_SENSE_MASK;
+	gpio_int_enabled[port] |= port_mask;
 
 	ep93xx_gpio_update_int_params(port);
 


