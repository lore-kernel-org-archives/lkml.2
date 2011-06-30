Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab1F3BJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:09:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28398 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1F3BJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:09:45 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-e9-4e0bccd5d3e5
Date: Thu, 30 Jun 2011 10:09:40 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] power: MAX8903 Charger: allow platform data to be __initdata
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1309396180-23094-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Jun 2011 01:09:55.0698 (UTC)
 FILETIME=[6C647520:01CC36C2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform files may have declared 8903 platform data as __initdata. This
patch removes the dependency on pdata pointer so that using __initdata
on pdata will not incur errors. Note that such error does not incur SECTION
MISMATCH warning in (at least some) compilers.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/max8903_charger.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 33ff0e3..a9b0209 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -28,7 +28,7 @@
 #include <linux/power/max8903_charger.h>
 
 struct max8903_data {
-	struct max8903_pdata *pdata;
+	struct max8903_pdata pdata;
 	struct device *dev;
 	struct power_supply psy;
 	bool fault;
@@ -52,8 +52,8 @@ static int max8903_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-		if (data->pdata->chg) {
-			if (gpio_get_value(data->pdata->chg) == 0)
+		if (data->pdata.chg) {
+			if (gpio_get_value(data->pdata.chg) == 0)
 				val->intval = POWER_SUPPLY_STATUS_CHARGING;
 			else if (data->usb_in || data->ta_in)
 				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
@@ -80,7 +80,7 @@ static int max8903_get_property(struct power_supply *psy,
 static irqreturn_t max8903_dcin(int irq, void *_data)
 {
 	struct max8903_data *data = _data;
-	struct max8903_pdata *pdata = data->pdata;
+	struct max8903_pdata *pdata = &data->pdata;
 	bool ta_in;
 	enum power_supply_type old_type;
 
@@ -121,7 +121,7 @@ static irqreturn_t max8903_dcin(int irq, void *_data)
 static irqreturn_t max8903_usbin(int irq, void *_data)
 {
 	struct max8903_data *data = _data;
-	struct max8903_pdata *pdata = data->pdata;
+	struct max8903_pdata *pdata = &data->pdata;
 	bool usb_in;
 	enum power_supply_type old_type;
 
@@ -160,7 +160,7 @@ static irqreturn_t max8903_usbin(int irq, void *_data)
 static irqreturn_t max8903_fault(int irq, void *_data)
 {
 	struct max8903_data *data = _data;
-	struct max8903_pdata *pdata = data->pdata;
+	struct max8903_pdata *pdata = &data->pdata;
 	bool fault;
 
 	fault = gpio_get_value(pdata->flt) ? false : true;
@@ -193,7 +193,7 @@ static __devinit int max8903_probe(struct platform_device *pdev)
 		dev_err(dev, "Cannot allocate memory.\n");
 		return -ENOMEM;
 	}
-	data->pdata = pdata;
+	memcpy(&data->pdata, pdata, sizeof(struct max8903_pdata));
 	data->dev = dev;
 	platform_set_drvdata(pdev, data);
 
@@ -349,7 +349,7 @@ static __devexit int max8903_remove(struct platform_device *pdev)
 	struct max8903_data *data = platform_get_drvdata(pdev);
 
 	if (data) {
-		struct max8903_pdata *pdata = data->pdata;
+		struct max8903_pdata *pdata = &data->pdata;
 
 		if (pdata->flt)
 			free_irq(gpio_to_irq(pdata->flt), data);
-- 
1.7.4.1

