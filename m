Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1F3JwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:52:21 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:57624 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030Ab1F3Jvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:33 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 5/7] mfd: twl4030-irq: drop edge_work
Date: Thu, 30 Jun 2011 12:51:08 +0300
Message-Id: <1309427470-605-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and do all the synchronization with the
hardware during bus_sync_unlock. We can now
remove all the workqueues.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |  124 +++++++++++++++++++--------------------------
 1 files changed, 52 insertions(+), 72 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index bf62389..1b9ab2f 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -422,8 +422,6 @@ static inline void activate_irq(int irq)
 
 /*----------------------------------------------------------------------*/
 
-static struct workqueue_struct *wq;
-
 struct sih_agent {
 	int			irq_base;
 	const struct sih	*sih;
@@ -432,68 +430,10 @@ struct sih_agent {
 	bool			imr_change_pending;
 
 	u32			edge_change;
-	struct work_struct	edge_work;
 
 	struct mutex		irq_lock;
 };
 
-static void twl4030_sih_do_edge(struct work_struct *work)
-{
-	struct sih_agent	*agent;
-	const struct sih	*sih;
-	u8			bytes[6];
-	u32			edge_change;
-	int			status;
-
-	agent = container_of(work, struct sih_agent, edge_work);
-
-	/* see what work we have */
-	edge_change = agent->edge_change;
-	agent->edge_change = 0;
-	sih = edge_change ? agent->sih : NULL;
-	if (!sih)
-		return;
-
-	/* Read, reserving first byte for write scratch.  Yes, this
-	 * could be cached for some speedup ... but be careful about
-	 * any processor on the other IRQ line, EDR registers are
-	 * shared.
-	 */
-	status = twl_i2c_read(sih->module, bytes + 1,
-			sih->edr_offset, sih->bytes_edr);
-	if (status) {
-		pr_err("twl4030: %s, %s --> %d\n", __func__,
-				"read", status);
-		return;
-	}
-
-	/* Modify only the bits we know must change */
-	while (edge_change) {
-		int		i = fls(edge_change) - 1;
-		struct irq_data	*idata = irq_get_irq_data(i + agent->irq_base);
-		int		byte = 1 + (i >> 2);
-		int		off = (i & 0x3) * 2;
-		unsigned int	type;
-
-		bytes[byte] &= ~(0x03 << off);
-
-		type = irqd_get_trigger_type(idata);
-		if (type & IRQ_TYPE_EDGE_RISING)
-			bytes[byte] |= BIT(off + 1);
-		if (type & IRQ_TYPE_EDGE_FALLING)
-			bytes[byte] |= BIT(off + 0);
-
-		edge_change &= ~BIT(i);
-	}
-
-	/* Write */
-	status = twl_i2c_write(sih->module, bytes,
-			sih->edr_offset, sih->bytes_edr);
-	if (status)
-		pr_err("twl4030: %s, %s --> %d\n", __func__,
-				"write", status);
-}
-
 /*----------------------------------------------------------------------*/
 
 /*
@@ -526,10 +466,8 @@ static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	if (irqd_get_trigger_type(data) != trigger) {
+	if (irqd_get_trigger_type(data) != trigger)
 		agent->edge_change |= BIT(data->irq - agent->irq_base);
-		queue_work(wq, &agent->edge_work);
-	}
 
 	return 0;
 }
@@ -566,6 +504,56 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 					"write", status);
 	}
 
+	if (agent->edge_change) {
+		u32		edge_change;
+		u8		bytes[6];
+
+		edge_change = agent->edge_change;
+		agent->edge_change = 0;
+
+		/*
+		 * Read, reserving first byte for write scratch.  Yes, this
+		 * could be cached for some speedup ... but be careful about
+		 * any processor on the other IRQ line, EDR registers are
+		 * shared.
+		 */
+		status = twl_i2c_read(sih->module, bytes + 1,
+				sih->edr_offset, sih->bytes_edr);
+		if (status) {
+			pr_err("twl4030: %s, %s --> %d\n", __func__,
+					"read", status);
+			return;
+		}
+
+		/* Modify only the bits we know must change */
+		while (edge_change) {
+			int		i = fls(edge_change) - 1;
+			struct irq_data	*idata;
+			int		byte = 1 + (i >> 2);
+			int		off = (i & 0x3) * 2;
+			unsigned int	type;
+
+			idata = irq_get_irq_data(i + agent->irq_base);
+
+			bytes[byte] &= ~(0x03 << off);
+
+			type = irqd_get_trigger_type(idata);
+			if (type & IRQ_TYPE_EDGE_RISING)
+				bytes[byte] |= BIT(off + 1);
+			if (type & IRQ_TYPE_EDGE_FALLING)
+				bytes[byte] |= BIT(off + 0);
+
+			edge_change &= ~BIT(i);
+		}
+
+		/* Write */
+		status = twl_i2c_write(sih->module, bytes,
+				sih->edr_offset, sih->bytes_edr);
+		if (status)
+			pr_err("twl4030: %s, %s --> %d\n", __func__,
+					"write", status);
+	}
+
 	mutex_unlock(&agent->irq_lock);
 }
 
@@ -672,7 +660,6 @@ int twl4030_sih_setup(int module)
 	agent->sih = sih;
 	agent->imr = ~0;
 	mutex_init(&agent->irq_lock);
-	INIT_WORK(&agent->edge_work, twl4030_sih_do_edge);
 
 	for (i = 0; i < sih->bits; i++) {
 		irq = irq_base + i;
@@ -720,12 +707,6 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	if (status < 0)
 		return status;
 
-	wq = create_singlethread_workqueue("twl4030-irqchip");
-	if (!wq) {
-		pr_err("twl4030: workqueue FAIL\n");
-		return -ESRCH;
-	}
-
 	twl4030_irq_base = irq_base;
 
 	/* install an irq handler for each of the SIH modules;
@@ -766,8 +747,7 @@ fail_rqirq:
 fail:
 	for (i = irq_base; i < irq_end; i++)
 		irq_set_chip_and_handler(i, NULL, NULL);
-	destroy_workqueue(wq);
-	wq = NULL;
+
 	return status;
 }
 
-- 
1.7.6

