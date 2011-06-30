Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1F3Jvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:51:46 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46672 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab1F3JvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:24 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/7] mfd: twl4030-irq: implement bus_lock/bus_sync_unlock methods
Date: Thu, 30 Jun 2011 12:51:05 +0300
Message-Id: <1309427470-605-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for doing that, drop the locking and change that
to a mutex.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 7be97cb..291364c 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -460,8 +460,6 @@ static inline void activate_irq(int irq)
 
 /*----------------------------------------------------------------------*/
 
-static DEFINE_SPINLOCK(sih_agent_lock);
-
 static struct workqueue_struct *wq;
 
 struct sih_agent {
@@ -474,6 +472,8 @@ struct sih_agent {
 
 	u32			edge_change;
 	struct work_struct	edge_work;
+
+	struct mutex		irq_lock;
 };
 
 static void twl4030_sih_do_mask(struct work_struct *work)
@@ -489,7 +489,6 @@ static void twl4030_sih_do_mask(struct work_struct *work)
 	agent = container_of(work, struct sih_agent, mask_work);
 
 	/* see what work we have */
-	spin_lock_irq(&sih_agent_lock);
 	if (agent->imr_change_pending) {
 		sih = agent->sih;
 		/* byte[0] gets overwritten as we write ... */
@@ -497,7 +496,6 @@ static void twl4030_sih_do_mask(struct work_struct *work)
 		agent->imr_change_pending = false;
 	} else
 		sih = NULL;
-	spin_unlock_irq(&sih_agent_lock);
 	if (!sih)
 		return;
 
@@ -520,11 +518,9 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 	agent = container_of(work, struct sih_agent, edge_work);
 
 	/* see what work we have */
-	spin_lock_irq(&sih_agent_lock);
 	edge_change = agent->edge_change;
 	agent->edge_change = 0;
 	sih = edge_change ? agent->sih : NULL;
-	spin_unlock_irq(&sih_agent_lock);
 	if (!sih)
 		return;
 
@@ -580,49 +576,57 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 static void twl4030_sih_mask(struct irq_data *data)
 {
 	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
-	unsigned long flags;
 
-	spin_lock_irqsave(&sih_agent_lock, flags);
 	sih->imr |= BIT(data->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
 static void twl4030_sih_unmask(struct irq_data *data)
 {
 	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
-	unsigned long flags;
 
-	spin_lock_irqsave(&sih_agent_lock, flags);
 	sih->imr &= ~BIT(data->irq - sih->irq_base);
 	sih->imr_change_pending = true;
 	queue_work(wq, &sih->mask_work);
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
 static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 {
 	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
-	unsigned long flags;
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	spin_lock_irqsave(&sih_agent_lock, flags);
 	if (irqd_get_trigger_type(data) != trigger) {
 		sih->edge_change |= BIT(data->irq - sih->irq_base);
 		queue_work(wq, &sih->edge_work);
 	}
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
+
 	return 0;
 }
 
+static void twl4030_sih_bus_lock(struct irq_data *data)
+{
+	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&sih->irq_lock);
+}
+
+static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
+{
+	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+
+	mutex_unlock(&sih->irq_lock);
+}
+
 static struct irq_chip twl4030_sih_irq_chip = {
 	.name		= "twl4030",
 	.irq_mask	= twl4030_sih_mask,
 	.irq_unmask	= twl4030_sih_unmask,
 	.irq_set_type	= twl4030_sih_set_type,
+	.irq_bus_lock	= twl4030_sih_bus_lock,
+	.irq_bus_sync_unlock = twl4030_sih_bus_sync_unlock,
 };
 
 /*----------------------------------------------------------------------*/
@@ -718,15 +722,16 @@ int twl4030_sih_setup(int module)
 	agent->irq_base = irq_base;
 	agent->sih = sih;
 	agent->imr = ~0;
+	mutex_init(&agent->irq_lock);
 	INIT_WORK(&agent->mask_work, twl4030_sih_do_mask);
 	INIT_WORK(&agent->edge_work, twl4030_sih_do_edge);
 
 	for (i = 0; i < sih->bits; i++) {
 		irq = irq_base + i;
 
+		irq_set_chip_data(irq, agent);
 		irq_set_chip_and_handler(irq, &twl4030_sih_irq_chip,
 					 handle_edge_irq);
-		irq_set_chip_data(irq, agent);
 		activate_irq(irq);
 	}
 
-- 
1.7.6

