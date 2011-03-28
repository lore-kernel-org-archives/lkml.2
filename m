Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1C1Rg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:36:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:49827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1C1Rg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:36:56 -0400
Date: Mon, 28 Mar 2011 17:36:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        florian@openwrt.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/cleanup] vlynq: Convert irq functions
Message-ID: <tip-8ec4ad2bebd1dd7e782bd1a1ac4c5e17ceb2ff81@git.kernel.org>
Git-Commit-ID: 8ec4ad2bebd1dd7e782bd1a1ac4c5e17ceb2ff81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Mar 2011 17:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ec4ad2bebd1dd7e782bd1a1ac4c5e17ceb2ff81
Gitweb:     http://git.kernel.org/tip/8ec4ad2bebd1dd7e782bd1a1ac4c5e17ceb2ff81
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 Mar 2011 21:56:37 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Mar 2011 19:33:04 +0200

vlynq: Convert irq functions

Convert to the new irq_chip functions and the new namespace.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Florian Fainelli <florian@openwrt.org>
LKML-Reference: <alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6>
---
 drivers/vlynq/vlynq.c |   64 +++++++++++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f885c86..aa250ce 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -135,40 +135,40 @@ static void vlynq_reset(struct vlynq_device *dev)
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
@@ -192,10 +192,9 @@ static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
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
@@ -203,10 +202,9 @@ static void vlynq_local_ack(unsigned int irq)
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
@@ -238,23 +236,23 @@ static irqreturn_t vlynq_irq(int irq, void *dev_id)
 
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
@@ -291,17 +289,17 @@ static int vlynq_setup_irq(struct vlynq_device *dev)
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
