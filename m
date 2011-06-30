Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1F3Jvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:51:55 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:35508 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914Ab1F3Jv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:29 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 4/7] mfd: twl4030-irq: drop mask_work
Date: Thu, 30 Jun 2011 12:51:07 +0300
Message-Id: <1309427470-605-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... we can do the synchronization with the
hardware when calling bus_sync_unlock as
we're supposed to. While at that, also make
variable names uniform on all functions.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |   82 ++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index e1e0944..bf62389 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -430,7 +430,6 @@ struct sih_agent {
 
 	u32			imr;
 	bool			imr_change_pending;
-	struct work_struct	mask_work;
 
 	u32			edge_change;
 	struct work_struct	edge_work;
@@ -438,37 +437,6 @@ struct sih_agent {
 	struct mutex		irq_lock;
 };
 
-static void twl4030_sih_do_mask(struct work_struct *work)
-{
-	struct sih_agent	*agent;
-	const struct sih	*sih;
-	union {
-		u8	bytes[4];
-		u32	word;
-	}			imr;
-	int			status;
-
-	agent = container_of(work, struct sih_agent, mask_work);
-
-	/* see what work we have */
-	if (agent->imr_change_pending) {
-		sih = agent->sih;
-		/* byte[0] gets overwritten as we write ... */
-		imr.word = cpu_to_le32(agent->imr << 8);
-		agent->imr_change_pending = false;
-	} else
-		sih = NULL;
-	if (!sih)
-		return;
-
-	/* write the whole mask ... simpler than subsetting it */
-	status = twl_i2c_write(sih->module, imr.bytes,
-			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
-	if (status)
-		pr_err("twl4030: %s, %s --> %d\n", __func__,
-				"write", status);
-}
-
 static void twl4030_sih_do_edge(struct work_struct *work)
 {
 	struct sih_agent	*agent;
@@ -537,32 +505,30 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 
 static void twl4030_sih_mask(struct irq_data *data)
 {
-	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct sih_agent *agent = irq_data_get_irq_chip_data(data);
 
-	sih->imr |= BIT(data->irq - sih->irq_base);
-	sih->imr_change_pending = true;
-	queue_work(wq, &sih->mask_work);
+	agent->imr |= BIT(data->irq - agent->irq_base);
+	agent->imr_change_pending = true;
 }
 
 static void twl4030_sih_unmask(struct irq_data *data)
 {
-	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct sih_agent *agent = irq_data_get_irq_chip_data(data);
 
-	sih->imr &= ~BIT(data->irq - sih->irq_base);
-	sih->imr_change_pending = true;
-	queue_work(wq, &sih->mask_work);
+	agent->imr &= ~BIT(data->irq - agent->irq_base);
+	agent->imr_change_pending = true;
 }
 
 static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 {
-	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct sih_agent *agent = irq_data_get_irq_chip_data(data);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
 	if (irqd_get_trigger_type(data) != trigger) {
-		sih->edge_change |= BIT(data->irq - sih->irq_base);
-		queue_work(wq, &sih->edge_work);
+		agent->edge_change |= BIT(data->irq - agent->irq_base);
+		queue_work(wq, &agent->edge_work);
 	}
 
 	return 0;
@@ -570,16 +536,37 @@ static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 
 static void twl4030_sih_bus_lock(struct irq_data *data)
 {
-	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct sih_agent	*agent = irq_data_get_irq_chip_data(data);
 
-	mutex_lock(&sih->irq_lock);
+	mutex_lock(&agent->irq_lock);
 }
 
 static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 {
-	struct sih_agent *sih = irq_data_get_irq_chip_data(data);
+	struct sih_agent	*agent = irq_data_get_irq_chip_data(data);
+	const struct sih	*sih = agent->sih;
+	int			status;
+
+	if (agent->imr_change_pending) {
+		union {
+			u32	word;
+			u8	bytes[4];
+		} imr;
+
+		/* byte[0] gets overwriten as we write ... */
+		imr.word = cpu_to_le32(agent->imr << 8);
+		agent->imr_change_pending = false;
+
+		/* write the whole mask ... simpler than subsetting it */
+		status = twl_i2c_write(sih->module, imr.bytes,
+				sih->mask[irq_line].imr_offset,
+				sih->bytes_ixr);
+		if (status)
+			pr_err("twl4030: %s, %s --> %d\n", __func__,
+					"write", status);
+	}
 
-	mutex_unlock(&sih->irq_lock);
+	mutex_unlock(&agent->irq_lock);
 }
 
 static struct irq_chip twl4030_sih_irq_chip = {
@@ -685,7 +672,6 @@ int twl4030_sih_setup(int module)
 	agent->sih = sih;
 	agent->imr = ~0;
 	mutex_init(&agent->irq_lock);
-	INIT_WORK(&agent->mask_work, twl4030_sih_do_mask);
 	INIT_WORK(&agent->edge_work, twl4030_sih_do_edge);
 
 	for (i = 0; i < sih->bits; i++) {
-- 
1.7.6

