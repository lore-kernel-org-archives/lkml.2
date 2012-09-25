Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2IYQVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:21:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab2IYQNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:42 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 25/57] power: ab8500: adaptation to ab version
Date: Tue, 25 Sep 2012 10:12:22 -0600
Message-Id: <1348589574-25655-26-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add AB9540 and AB8505 support to ab8500_temp
driver.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_btemp.c         |   71 ++++++++++++++++++++++++++-------
 include/linux/mfd/abx500/ab8500-bm.h |    2 +
 2 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 74cddba..506f124 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -37,6 +37,9 @@
 #define BTEMP_BATCTRL_CURR_SRC_7UA	7
 #define BTEMP_BATCTRL_CURR_SRC_20UA	20
 
+#define BTEMP_BATCTRL_CURR_SRC_16UA	16
+#define BTEMP_BATCTRL_CURR_SRC_18UA	18
+
 #define to_ab8500_btemp_device_info(x) container_of((x), \
 	struct ab8500_btemp, btemp_psy);
 
@@ -212,10 +215,18 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 
 	/* Only do this for batteries with internal NTC */
 	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
-		if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
-			curr = BAT_CTRL_7U_ENA;
-		else
-			curr = BAT_CTRL_20U_ENA;
+
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_16UA)
+				curr = BAT_CTRL_16U_ENA;
+			else
+				curr = BAT_CTRL_18U_ENA;
+		} else {
+			if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
+				curr = BAT_CTRL_7U_ENA;
+			else
+				curr = BAT_CTRL_20U_ENA;
+		}
 
 		dev_dbg(di->dev, "Set BATCTRL %duA\n", di->curr_source);
 
@@ -246,11 +257,22 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	} else if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
 		dev_dbg(di->dev, "Disable BATCTRL curr source\n");
 
-		/* Write 0 to the curr bits */
-		ret = abx500_mask_and_set_register_interruptible(di->dev,
-			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
-			BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
-			~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			/* Write 0 to the curr bits */
+			ret = abx500_mask_and_set_register_interruptible(
+				di->dev,
+				AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+				BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA,
+				~(BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA));
+		} else {
+			/* Write 0 to the curr bits */
+			ret = abx500_mask_and_set_register_interruptible(
+				di->dev,
+				AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+				BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
+				~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+		}
+
 		if (ret) {
 			dev_err(di->dev, "%s failed disabling current source\n",
 				__func__);
@@ -292,11 +314,20 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 	 * if we got an error above
 	 */
 disable_curr_source:
-	/* Write 0 to the curr bits */
-	ret = abx500_mask_and_set_register_interruptible(di->dev,
+	if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+		/* Write 0 to the curr bits */
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
+			BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA,
+			~(BAT_CTRL_16U_ENA | BAT_CTRL_18U_ENA));
+	} else {
+		/* Write 0 to the curr bits */
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER, AB8500_BAT_CTRL_CURRENT_SOURCE,
 			BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA,
 			~(BAT_CTRL_7U_ENA | BAT_CTRL_20U_ENA));
+	}
+
 	if (ret) {
 		dev_err(di->dev, "%s failed disabling current source\n",
 			__func__);
@@ -510,8 +541,11 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 {
 	int res;
 	u8 i;
+	if (is_ab9540(di->parent) || is_ab8505(di->parent))
+		di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
+	else
+		di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
 
-	di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
 	di->bat->batt_id = BATTERY_UNKNOWN;
 
 	res =  ab8500_btemp_get_batctrl_res(di);
@@ -548,9 +582,16 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	 * detected type is Type 1, else we use the 7uA source
 	 */
 	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL &&
-			di->bat->batt_id == 1) {
-		dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
-		di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
+						 di->bat->batt_id == 1) {
+		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			dev_dbg(di->dev,
+					"Set BATCTRL current source to 16uA\n");
+			di->curr_source = BTEMP_BATCTRL_CURR_SRC_16UA;
+		} else {
+			dev_dbg(di->dev,
+					"Set BATCTRL current source to 20uA\n");
+			di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
+		}
 	}
 
 	return di->bat->batt_id;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 25af2c1..175197c 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -226,6 +226,8 @@
 /* BatCtrl Current Source Constants */
 #define BAT_CTRL_7U_ENA			0x01
 #define BAT_CTRL_20U_ENA		0x02
+#define BAT_CTRL_18U_ENA		0x01
+#define BAT_CTRL_16U_ENA		0x02
 #define BAT_CTRL_CMP_ENA		0x04
 #define FORCE_BAT_CTRL_CMP_HIGH		0x08
 #define BAT_CTRL_PULL_UP_ENA		0x10
-- 
1.7.5.4

