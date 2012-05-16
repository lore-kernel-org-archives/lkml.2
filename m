Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2EPHmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:42:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39541 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab2EPHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:41:58 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-c4-4fb35a457206
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        thomas.abraham@linaro.org
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v3 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic
Date: Wed, 16 May 2012 16:41:47 +0900
Message-id: <1337154107-22070-1-git-send-email-cw00.choi@samsung.com>
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
 drivers/extcon/Kconfig          |    2 +-
 drivers/extcon/extcon-max8997.c |   27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index a5cd4e2..258889d 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -34,7 +34,7 @@ config EXTCON_GPIO
 
 config EXTCON_MAX8997
 	tristate "MAX8997 EXTCON Support"
-	depends on MFD_MAX8997
+	depends on MFD_MAX8997 && IRQ_DOMAIN
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX8997 PMIC. The MAX8997 MUIC is a USB port accessory
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index ab25c54..47546e3 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
 #include <linux/extcon.h>
+#include <linux/irqdomain.h>
 
 #define	DEV_NAME			"max8997-muic"
 
@@ -82,6 +83,7 @@
 struct max8997_muic_irq {
 	unsigned int irq;
 	const char *name;
+	unsigned int virq;
 };
 
 static struct max8997_muic_irq muic_irqs[] = {
@@ -348,12 +350,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
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
 
@@ -368,6 +368,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
 	dev_dbg(info->dev, "%s: STATUS1:0x%x, 2:0x%x\n", __func__,
 			status[0], status[1]);
 
+	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+		if (info->irq == muic_irqs[i].virq)
+			irq_type = muic_irqs[i].irq;
+
 	switch (irq_type) {
 	case MAX8997_MUICIRQ_ADC:
 		adc = status[0] & STATUS1_ADC_MASK;
@@ -453,11 +457,15 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 
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
@@ -512,11 +520,10 @@ err_kfree:
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

