Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2HUGPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:15:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34103 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2HUGPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:15:41 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-4f-5033278ba857
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCH 1/2] mfd: MAX77693: Fix bug of interrupt handlding for
 MAX77693 devices
Date: Tue, 21 Aug 2012 15:15:52 +0900
Message-id: <1345529752-24842-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd1udeMAg/vLVSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGgRsvWAseSlU8mnycqYFxglgXIweHhICJxIU+wy5GTiBTTOLC
	vfVsXYxcHEIC0xklNn84yQ7hLGWSWDJtPxNIFZuAlsT+FzfYQGwRAUmJZ4/XMYIUMQvMZpS4
	9qCJGSQhLJAgMXnzLzCbRUBVon3OHFYQm1fAVWJa8xc2iHUKEq3LDrFPYORewMiwilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyPYh8+kdzCuarA4xCjAwajEw/tjkVGAEGtiWXFl7iFGCQ5m
	JRHeRgbjACHelMTKqtSi/Pii0pzU4kOM0hwsSuK8/H2GAUIC6YklqdmpqQWpRTBZJg5OqQbG
	if/Tc8XMrN3uTmZafVKlf6eshYJalM21W9IFfA3/hFc/fT/lP7dSvoOvxDWlEzfcPm82nfKc
	KfnCbjO58sb6NyIWQgvvtD4snlJufHBl0tFnUY9LTm2exFEUkbFC70Drf0MRv0d7FLMi5hsF
	XvI6u6s4ovRRmMhyn9ATJ1rtNicu1TBmy1ukxFKckWioxVxUnAgAaiBoAN0BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug related to interrupt handling for MAX77693 devices.
- Unmask interrupt masking bit for charger/flash/muic to revolve
that interrupt isn't happened when external connector is attached.
- Fix wrong regmap instance when muic interrupt is happened.

This patch were discussed and confirm discussion about this patch on below url:
http://lkml.org/lkml/2012/7/16/118

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

