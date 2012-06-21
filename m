Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2FUBLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:11:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2FUBKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:10:48 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-c0-4fe274976e8d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] Extcon: MAX8997: Add support irq domain for MAX8997 muic
Date: Thu, 21 Jun 2012 10:10:45 +0900
Message-id: <1340241045-22291-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd3pJY/8DV7MkrG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZp/btZivol634+2Q1SwPjY/EuRk4OCQETiSlPPzND2GISF+6t
	Z+ti5OIQEpjOKDH34RpWCGcZk8Sz729ZQarYBLQk9r+4wQZiiwjISTy5/YcZpIhZ4DOjxORz
	65hAEsICvhJb5u0BG8sioCqxeX8nC4jNK+AqMfPbZFaIdQoSrcsOsU9g5F7AyLCKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTI9iLz6R3MK5qsDjEKMDBqMTDy5H9yF+INbGsuDL3EKMEB7OS
	CO9yNaAQb0piZVVqUX58UWlOavEhRmkOFiVx3ibrC/5CAumJJanZqakFqUUwWSYOTqkGRlFx
	kWzeCdVxQpIn3xQeeLjQ6ZfViU0iL7wW6ht2fWvSd4lSXW/34rnCjF8FyR5Ksf+mNnKd4LrE
	wPRZ9G/V3qArggm5inap5xYxCnsGH8+ZPHl2g9imKR65JxnqbiRI3+J/tuaQ/M2jsc17jgoX
	fZk4qWXKfNFjfKxpVbzsz3KnTb494U7BFSWW4oxEQy3mouJEAHhjspbeAQAA
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
 drivers/extcon/extcon-max8997.c |   29 ++++++++++++++++++-----------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 29c5cf8..bf6b2ea 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -23,7 +23,7 @@ config EXTCON_GPIO
 
 config EXTCON_MAX8997
 	tristate "MAX8997 EXTCON Support"
-	depends on MFD_MAX8997
+	depends on MFD_MAX8997 && IRQ_DOMAIN
 	help
 	  If you say yes here you get support for the MUIC device of
 	  Maxim MAX8997 PMIC. The MAX8997 MUIC is a USB port accessory
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 23416e4..fe24cc6 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -26,6 +26,7 @@
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
 #include <linux/extcon.h>
+#include <linux/irqdomain.h>
 
 #define	DEV_NAME			"max8997-muic"
 
@@ -77,6 +78,7 @@
 struct max8997_muic_irq {
 	unsigned int irq;
 	const char *name;
+	unsigned int virq;
 };
 
 static struct max8997_muic_irq muic_irqs[] = {
@@ -343,12 +345,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
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
 
@@ -363,6 +363,10 @@ static void max8997_muic_irq_work(struct work_struct *work)
 	dev_dbg(info->dev, "%s: STATUS1:0x%x, 2:0x%x\n", __func__,
 			status[0], status[1]);
 
+	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
+		if (info->irq == muic_irqs[i].virq)
+			irq_type = muic_irqs[i].irq;
+
 	switch (irq_type) {
 	case MAX8997_MUICIRQ_ADC:
 		adc = status[0] & STATUS1_ADC_MASK;
@@ -448,11 +452,15 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 
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
@@ -496,7 +504,7 @@ err_extcon:
 	kfree(info->edev);
 err_irq:
 	while (--i >= 0)
-		free_irq(pdata->irq_base + muic_irqs[i].irq, info);
+		free_irq(muic_irqs[i].virq, info);
 	kfree(info);
 err_kfree:
 	return ret;
@@ -505,11 +513,10 @@ err_kfree:
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

