Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0L1RRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:17:14 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:47922 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab0L1RQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:16:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 2/3] mfd: twl4030-irq: drop the workqueue hackery
Date: Tue, 28 Dec 2010 19:14:18 +0200
Message-Id: <1293556459-28613-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
In-Reply-To: <1293556459-28613-1-git-send-email-balbi@ti.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally that workqueue isn't needed anymore.
Drop that hackery and move the spinlock_t to
a mutex so we can issue I2C operations with
a lock held.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |  226 +++++++++++++++++++--------------------------
 1 files changed, 96 insertions(+), 130 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 91331a7..298956d 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 #include <linux/i2c/twl.h>
 
@@ -434,46 +435,36 @@ static inline void activate_irq(int irq)
 
 /*----------------------------------------------------------------------*/
 
-static DEFINE_SPINLOCK(sih_agent_lock);
-
-static struct workqueue_struct *wq;
-
 struct sih_agent {
 	int			irq_base;
 	const struct sih	*sih;
 
 	u32			imr;
-	bool			imr_change_pending;
-	struct work_struct	mask_work;
-
 	u32			edge_change;
-	struct work_struct	edge_work;
+
+	struct mutex		irq_lock;
 };
 
-static void twl4030_sih_do_mask(struct work_struct *work)
+/*----------------------------------------------------------------------*/
+
+static void twl4030_sih_mask(unsigned irq)
 {
-	struct sih_agent	*agent;
-	const struct sih	*sih;
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+	const struct sih	*sih = agent->sih;
+
 	union {
 		u8	bytes[4];
 		u32	word;
 	}			imr;
+
 	int			status;
 
-	agent = container_of(work, struct sih_agent, mask_work);
-
-	/* see what work we have */
-	spin_lock_irq(&sih_agent_lock);
-	if (agent->imr_change_pending) {
-		sih = agent->sih;
-		/* byte[0] gets overwritten as we write ... */
-		imr.word = cpu_to_le32(agent->imr << 8);
-		agent->imr_change_pending = false;
-	} else
-		sih = NULL;
-	spin_unlock_irq(&sih_agent_lock);
-	if (!sih)
-		return;
+	agent->imr |= BIT(irq - agent->irq_base);
+
+	mutex_lock(&agent->irq_lock);
+
+	/* byte[0] gets overwritten as we write ... */
+	imr.word = cpu_to_le32(agent->imr << 8);
 
 	/* write the whole mask ... simpler than subsetting it */
 	status = twl_i2c_write(sih->module, imr.bytes,
@@ -481,111 +472,42 @@ static void twl4030_sih_do_mask(struct work_struct *work)
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
 				"write", status);
+	mutex_unlock(&agent->irq_lock);
 }
 
-static void twl4030_sih_do_edge(struct work_struct *work)
+static void twl4030_sih_unmask(unsigned irq)
 {
-	struct sih_agent	*agent;
-	const struct sih	*sih;
-	u8			bytes[6];
-	u32			edge_change;
-	int			status;
-
-	agent = container_of(work, struct sih_agent, edge_work);
-
-	/* see what work we have */
-	spin_lock_irq(&sih_agent_lock);
-	edge_change = agent->edge_change;
-	agent->edge_change = 0;
-	sih = edge_change ? agent->sih : NULL;
-	spin_unlock_irq(&sih_agent_lock);
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
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+	const struct sih	*sih = agent->sih;
 
-	/* Modify only the bits we know must change */
-	while (edge_change) {
-		int		i = fls(edge_change) - 1;
-		struct irq_desc	*d = irq_to_desc(i + agent->irq_base);
-		int		byte = 1 + (i >> 2);
-		int		off = (i & 0x3) * 2;
-
-		if (!d) {
-			pr_err("twl4030: Invalid IRQ: %d\n",
-			       i + agent->irq_base);
-			return;
-		}
+	union {
+		u8	bytes[4];
+		u32	word;
+	}			imr;
 
-		bytes[byte] &= ~(0x03 << off);
+	int			status;
 
-		raw_spin_lock_irq(&d->lock);
-		if (d->status & IRQ_TYPE_EDGE_RISING)
-			bytes[byte] |= BIT(off + 1);
-		if (d->status & IRQ_TYPE_EDGE_FALLING)
-			bytes[byte] |= BIT(off + 0);
-		raw_spin_unlock_irq(&d->lock);
+	mutex_lock(&agent->irq_lock);
+	agent->imr &= ~BIT(irq - agent->irq_base);
 
-		edge_change &= ~BIT(i);
-	}
+	/* byte[0] gets overwritten as we write ... */
+	imr.word = cpu_to_le32(agent->imr << 8);
 
-	/* Write */
-	status = twl_i2c_write(sih->module, bytes,
-			sih->edr_offset, sih->bytes_edr);
+	/* write the whole mask ... simpler than subsetting it */
+	status = twl_i2c_write(sih->module, imr.bytes,
+			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
 				"write", status);
-}
-
-/*----------------------------------------------------------------------*/
-
-/*
- * All irq_chip methods get issued from code holding irq_desc[irq].lock,
- * which can't perform the underlying I2C operations (because they sleep).
- * So we must hand them off to a thread (workqueue) and cope with asynch
- * completion, potentially including some re-ordering, of these requests.
- */
-
-static void twl4030_sih_mask(unsigned irq)
-{
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr |= BIT(irq - sih->irq_base);
-	sih->imr_change_pending = true;
-	queue_work(wq, &sih->mask_work);
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
-}
-
-static void twl4030_sih_unmask(unsigned irq)
-{
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&sih_agent_lock, flags);
-	sih->imr &= ~BIT(irq - sih->irq_base);
-	sih->imr_change_pending = true;
-	queue_work(wq, &sih->mask_work);
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
+	mutex_unlock(&agent->irq_lock);
 }
 
 static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+	const struct sih	*sih = agent->sih;
+	struct irq_desc		*desc = irq_to_desc(irq);
+	int			status = 0;
 
 	if (!desc) {
 		pr_err("twl4030: Invalid IRQ: %d\n", irq);
@@ -595,15 +517,67 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	spin_lock_irqsave(&sih_agent_lock, flags);
+	mutex_lock(&agent->irq_lock);
 	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
+		u8			bytes[6];
+		u32			edge_change;
+
 		desc->status &= ~IRQ_TYPE_SENSE_MASK;
 		desc->status |= trigger;
-		sih->edge_change |= BIT(irq - sih->irq_base);
-		queue_work(wq, &sih->edge_work);
+		agent->edge_change |= BIT(irq - agent->irq_base);
+		edge_change = agent->edge_change;
+
+		/* Read, reserving first byte for write scratch.  Yes, this
+		 * could be cached for some speedup ... but be careful about
+		 * any processor on the other IRQ line, EDR registers are
+		 * shared.
+		 */
+		status = twl_i2c_read(sih->module, bytes + 1,
+				sih->edr_offset, sih->bytes_edr);
+		if (status) {
+			pr_err("twl4030: %s, %s --> %d\n", __func__,
+					"read", status);
+			goto out;
+		}
+
+		/* Modify only the bits we know must change */
+		while (edge_change) {
+			int		i = fls(edge_change) - 1;
+			struct irq_desc	*d = irq_to_desc(i + agent->irq_base);
+			int		byte = 1 + (i >> 2);
+			int		off = (i & 0x3) * 2;
+
+			if (!d) {
+				pr_err("twl4030: Invalid IRQ: %d\n",
+						i + agent->irq_base);
+				status = -ENODEV;
+				goto out;
+			}
+
+			bytes[byte] &= ~(0x03 << off);
+
+			raw_spin_lock_irq(&d->lock);
+			if (d->status & IRQ_TYPE_EDGE_RISING)
+				bytes[byte] |= BIT(off + 1);
+			if (d->status & IRQ_TYPE_EDGE_FALLING)
+				bytes[byte] |= BIT(off + 0);
+			raw_spin_unlock_irq(&d->lock);
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
 	}
-	spin_unlock_irqrestore(&sih_agent_lock, flags);
-	return 0;
+
+out:
+	mutex_unlock(&agent->irq_lock);
+
+	return status;
 }
 
 static struct irq_chip twl4030_sih_irq_chip = {
@@ -706,8 +680,7 @@ int twl4030_sih_setup(int module)
 	agent->irq_base = irq_base;
 	agent->sih = sih;
 	agent->imr = ~0;
-	INIT_WORK(&agent->mask_work, twl4030_sih_do_mask);
-	INIT_WORK(&agent->edge_work, twl4030_sih_do_edge);
+	mutex_init(&agent->irq_lock);
 
 	for (i = 0; i < sih->bits; i++) {
 		irq = irq_base + i;
@@ -755,12 +728,6 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
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
@@ -802,8 +769,7 @@ fail_rqirq:
 fail:
 	for (i = irq_base; i < irq_end; i++)
 		set_irq_chip_and_handler(i, NULL, NULL);
-	destroy_workqueue(wq);
-	wq = NULL;
+
 	return status;
 }
 
-- 
1.7.3.4.598.g85356

