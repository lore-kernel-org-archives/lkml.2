Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1CYU4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:56:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:36075 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1CYU4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:56:40 -0400
Date: Fri, 25 Mar 2011 21:56:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] vlynq: Convert irq functions
In-Reply-To: <alpine.LFD.2.00.1103251223240.31464@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103251223240.31464@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new irq_chip functions and the new namespace.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
[ Sorry, a bug in my coccinelle script went unnoticed due to other local
  changes }

 drivers/vlynq/vlynq.c |   64 ++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

Index: linux-2.6-tip/drivers/vlynq/vlynq.c
===================================================================
--- linux-2.6-tip.orig/drivers/vlynq/vlynq.c
+++ linux-2.6-tip/drivers/vlynq/vlynq.c
@@ -135,40 +135,40 @@ static void vlynq_reset(struct vlynq_dev
 	msleep(5);
 }
 
-static void vlynq_irq_unmask(unsigned int irq)
+static void vlynq_irq_unmask(struct irq_data *d)
 {
-	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
+	u32 val;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	val |= (VINT_ENABLE | virq) << VINT_OFFSET(virq);
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static void vlynq_irq_mask(unsigned int irq)
+static void vlynq_irq_mask(struct irq_data *d)
 {
-	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
+	u32 val;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	val &= ~(VINT_ENABLE << VINT_OFFSET(virq));
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
+static int vlynq_irq_type(struct irq_data *d, unsigned int flow_type)
 {
-	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
+	u32 val;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	switch (flow_type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -192,10 +192,9 @@ static int vlynq_irq_type(unsigned int i
 	return 0;
 }
 
-static void vlynq_local_ack(unsigned int irq)
+static void vlynq_local_ack(struct irq_data *d)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
-
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	u32 status = readl(&dev->local->status);
 
 	pr_debug("%s: local status: 0x%08x\n",
@@ -203,10 +202,9 @@ static void vlynq_local_ack(unsigned int
 	writel(status, &dev->local->status);
 }
 
-static void vlynq_remote_ack(unsigned int irq)
+static void vlynq_remote_ack(struct irq_data *d)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
-
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	u32 status = readl(&dev->remote->status);
 
 	pr_debug("%s: remote status: 0x%08x\n",
@@ -238,23 +236,23 @@ static irqreturn_t vlynq_irq(int irq, vo
 
 static struct irq_chip vlynq_irq_chip = {
 	.name = "vlynq",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.set_type = vlynq_irq_type,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_set_type = vlynq_irq_type,
 };
 
 static struct irq_chip vlynq_local_chip = {
 	.name = "vlynq local error",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.ack = vlynq_local_ack,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_ack = vlynq_local_ack,
 };
 
 static struct irq_chip vlynq_remote_chip = {
 	.name = "vlynq local error",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.ack = vlynq_remote_ack,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_ack = vlynq_remote_ack,
 };
 
 static int vlynq_setup_irq(struct vlynq_device *dev)
@@ -291,17 +289,17 @@ static int vlynq_setup_irq(struct vlynq_
 	for (i = dev->irq_start; i <= dev->irq_end; i++) {
 		virq = i - dev->irq_start;
 		if (virq == dev->local_irq) {
-			set_irq_chip_and_handler(i, &vlynq_local_chip,
+			irq_set_chip_and_handler(i, &vlynq_local_chip,
 						 handle_level_irq);
-			set_irq_chip_data(i, dev);
+			irq_set_chip_data(i, dev);
 		} else if (virq == dev->remote_irq) {
-			set_irq_chip_and_handler(i, &vlynq_remote_chip,
+			irq_set_chip_and_handler(i, &vlynq_remote_chip,
 						 handle_level_irq);
-			set_irq_chip_data(i, dev);
+			irq_set_chip_data(i, dev);
 		} else {
-			set_irq_chip_and_handler(i, &vlynq_irq_chip,
+			irq_set_chip_and_handler(i, &vlynq_irq_chip,
 						 handle_simple_irq);
-			set_irq_chip_data(i, dev);
+			irq_set_chip_data(i, dev);
 			writel(0, &dev->remote->int_device[virq >> 2]);
 		}
 	}
