Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2GPJlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:41:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33759 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GPJlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:41:18 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-9b-5003e1bd9e32
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] mfd: MAX77693: Fix bug of interrupt handlding for MAX77693
 devices
Date: Mon, 16 Jul 2012 18:41:05 +0900
Message-id: <1342431665-2812-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd29D5kDDKZs4ba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZq2b1MBW8kqy4PH8hUwPjatEuRk4OCQETieapbawQtpjEhXvr
	2boYuTiEBBYxSvxa/IsdwlnKJLHp9xZGkCo2AS2J/S9usIHYIgKSEs8erwOLMwvUSuy71gQ2
	SVggVOJux2+wOIuAqsSNJd0sIDavgIvEkgkv2CG2KUi0LjvEPoGRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2MYB8+k97BuKrB4hCjAAejEg/vgTvMAUKsiWXFlbmHGCU4mJVEeDs7
	gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5Tby/+gsJpCeWpGanphakFsFkmTg4pRoYDSWv+93e
	XPxD1t1mguzzHfXv7e+q1RTwFxluDfvgvVhH6tW3urpqcf6fNQZ2nHJn/uwzLJjX2WE06/Td
	tit+8/a2Wwk53rJhyP9xiz/93uOTvMprplhd+CBWred1V1f3eMA2mYk1et8fRh2oajppK6Cg
	5zXnqySz5mEXpYUNnOGBjMKqBa1KLMUZiYZazEXFiQAKVpBF3QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug related to interrupt handling for MAX77693 devices.
- Unmask interrupt masking bit for charger/flash/muic to revolve
that interrupt isn't happened when external connector is attached.
- Fix wrong regmap instance when muic interrupt is happened.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max77693-irq.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
index 2b40356..1029d01 100644
--- a/drivers/mfd/max77693-irq.c
+++ b/drivers/mfd/max77693-irq.c
@@ -137,6 +137,9 @@ static void max77693_irq_mask(struct irq_data *data)
 	const struct max77693_irq_data *irq_data =
 				irq_to_max77693_irq(max77693, data->irq);
 
+	if (irq_data->group >= MAX77693_IRQ_GROUP_NR)
+		return;
+
 	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
 		max77693->irq_masks_cur[irq_data->group] &= ~irq_data->mask;
 	else
@@ -149,6 +152,9 @@ static void max77693_irq_unmask(struct irq_data *data)
 	const struct max77693_irq_data *irq_data =
 	    irq_to_max77693_irq(max77693, data->irq);
 
+	if (irq_data->group >= MAX77693_IRQ_GROUP_NR)
+		return;
+
 	if (irq_data->group >= MUIC_INT1 && irq_data->group <= MUIC_INT3)
 		max77693->irq_masks_cur[irq_data->group] |= irq_data->mask;
 	else
@@ -200,7 +206,7 @@ static irqreturn_t max77693_irq_thread(int irq, void *data)
 
 	if (irq_src & MAX77693_IRQSRC_MUIC)
 		/* MUIC INT1 ~ INT3 */
-		max77693_bulk_read(max77693->regmap, MAX77693_MUIC_REG_INT1,
+		max77693_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
 			MAX77693_NUM_IRQ_MUIC_REGS, &irq_reg[MUIC_INT1]);
 
 	/* Apply masking */
@@ -255,7 +261,8 @@ int max77693_irq_init(struct max77693_dev *max77693)
 {
 	struct irq_domain *domain;
 	int i;
-	int ret;
+	int ret = 0;
+	u8 intsrc_mask;
 
 	mutex_init(&max77693->irqlock);
 
@@ -287,19 +294,38 @@ int max77693_irq_init(struct max77693_dev *max77693)
 					&max77693_irq_domain_ops, max77693);
 	if (!domain) {
 		dev_err(max77693->dev, "could not create irq domain\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_irq;
 	}
 	max77693->irq_domain = domain;
 
+	/* Unmask max77693 interrupt */
+	ret = max77693_read_reg(max77693->regmap,
+			MAX77693_PMIC_REG_INTSRC_MASK, &intsrc_mask);
+	if (ret < 0) {
+		dev_err(max77693->dev, "fail to read PMIC register\n");
+		goto err_irq;
+	}
+
+	intsrc_mask &= ~(MAX77693_IRQSRC_CHG);
+	intsrc_mask &= ~(MAX77693_IRQSRC_FLASH);
+	intsrc_mask &= ~(MAX77693_IRQSRC_MUIC);
+	ret = max77693_write_reg(max77693->regmap,
+			MAX77693_PMIC_REG_INTSRC_MASK, intsrc_mask);
+	if (ret < 0) {
+		dev_err(max77693->dev, "fail to write PMIC register\n");
+		goto err_irq;
+	}
+
 	ret = request_threaded_irq(max77693->irq, NULL, max77693_irq_thread,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   "max77693-irq", max77693);
-
 	if (ret)
 		dev_err(max77693->dev, "Failed to request IRQ %d: %d\n",
 			max77693->irq, ret);
 
-	return 0;
+err_irq:
+	return ret;
 }
 
 void max77693_irq_exit(struct max77693_dev *max77693)
-- 
1.7.0.4

