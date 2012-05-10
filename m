Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab2EJKz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:55:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62343 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab2EJKzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:55:23 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-6d-4fab9e9ae301
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        thomas.abraham@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic
Date: Thu, 10 May 2012 19:55:08 +0900
Message-id: <1336647308-10926-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support irq domain for Maxim MAX8997 muic
instead of irq_base in platform data and max8997 driver
private data are instead. It is tested on TRATS board.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/extcon-max8997.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index ab25c54..d3961cb 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -82,6 +82,7 @@
 struct max8997_muic_irq {
 	unsigned int irq;
 	const char *name;
+	unsigned int virq;
 };
 
 static struct max8997_muic_irq muic_irqs[] = {
@@ -348,12 +349,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
 {
 	struct max8997_muic_info *info = container_of(work,
 			struct max8997_muic_info, irq_work);
-	struct max8997_dev *max8997 = i2c_get_clientdata(info->muic);
 	u8 status[2];
 	u8 adc, chg_type;
-
-	int irq_type = info->irq - max8997->irq_base;
-	int ret;
+	int irq_type = 0;
+	int i, ret;
 
 	mutex_lock(&info->mutex);
 
@@ -368,6 +367,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
 	dev_dbg(info->dev, "%s: STATUS1:0x%x, 2:0x%x\n", __func__,
 			status[0], status[1]);
 
+	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+		if (info->irq == muic_irqs[i].virq)
+			irq_type = muic_irqs[i].irq;
+
 	switch (irq_type) {
 	case MAX8997_MUICIRQ_ADC:
 		adc = status[0] & STATUS1_ADC_MASK;
@@ -453,11 +456,15 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
 		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
+		int virq = 0;
+
+		virq = irq_create_mapping(max8997->irq_domain, muic_irq->irq);
+		if (!virq)
+			goto err_irq;
+		muic_irq->virq = virq;
 
-		ret = request_threaded_irq(pdata->irq_base + muic_irq->irq,
-				NULL, max8997_muic_irq_handler,
-				0, muic_irq->name,
-				info);
+		ret = request_threaded_irq(virq, NULL,max8997_muic_irq_handler,
+				0, muic_irq->name, info);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed: irq request (IRQ: %d,"
@@ -512,11 +519,10 @@ err_kfree:
 static int __devexit max8997_muic_remove(struct platform_device *pdev)
 {
 	struct max8997_muic_info *info = platform_get_drvdata(pdev);
-	struct max8997_dev *max8997 = i2c_get_clientdata(info->muic);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
-		free_irq(max8997->irq_base + muic_irqs[i].irq, info);
+		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 
 	extcon_dev_unregister(info->edev);
-- 
1.7.0.4

