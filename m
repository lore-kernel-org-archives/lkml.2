Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1F1JJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:09:31 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:37345 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab1F1JIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:08:34 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Kalle Komierowski <kalle.komierowski@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/ab8500-gpadc: refactor GPADC API, add raw access
Date: Tue, 28 Jun 2011 11:08:03 +0200
Message-ID: <1309252083-26836-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kalle Komierowski <kalle.komierowski@gmail.com>

- A bug in the use of the exported functions made the raw ADC
  value converted to voltage entity twice.
- ab8500_gpadc_[convert|read_raw|ad_to_voltage] clarifies
  each functions use case, *convert wraps *read_raw, and we
  can access raw ADC values properly.
- Renamed gpadc function arguments from "input" to "channel" to
  clarify use, so we don't get confused again.

Signed-off-by: Kalle Komierowski <kalle.komierowski@gmail.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Reviewed-by: John Beckett <john.beckett@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c       |   56 +++++++++++++++++++++++++++++---------
 include/linux/mfd/ab8500/gpadc.h |    5 +++-
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index f16afb2..e985d17 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -143,12 +143,15 @@ struct ab8500_gpadc *ab8500_gpadc_get(char *name)
 }
 EXPORT_SYMBOL(ab8500_gpadc_get);
 
-static int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 input,
+/**
+ * ab8500_gpadc_ad_to_voltage() - Convert a raw ADC value to a voltage
+ */
+int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 channel,
 	int ad_value)
 {
 	int res;
 
-	switch (input) {
+	switch (channel) {
 	case MAIN_CHARGER_V:
 		/* For some reason we don't have calibrated data */
 		if (!gpadc->cal_data[ADC_INPUT_VMAIN].gain) {
@@ -232,18 +235,46 @@ static int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 input,
 	}
 	return res;
 }
+EXPORT_SYMBOL(ab8500_gpadc_ad_to_voltage);
 
 /**
  * ab8500_gpadc_convert() - gpadc conversion
- * @input:	analog input to be converted to digital data
+ * @channel:	analog channel to be converted to digital data
  *
  * This function converts the selected analog i/p to digital
  * data.
  */
-int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel)
+{
+	int ad_value;
+	int voltage;
+
+	ad_value = ab8500_gpadc_read_raw(gpadc, channel);
+	if (ad_value < 0) {
+		dev_err(gpadc->dev, "GPADC raw value failed ch: %d\n", channel);
+		return ad_value;
+	}
+
+	voltage = ab8500_gpadc_ad_to_voltage(gpadc, channel, ad_value);
+
+	if (voltage < 0)
+		dev_err(gpadc->dev, "GPADC to voltage conversion failed ch:"
+			" %d AD: 0x%x\n", channel, ad_value);
+
+	return voltage;
+}
+EXPORT_SYMBOL(ab8500_gpadc_convert);
+
+/**
+ * ab8500_gpadc_read_raw() - gpadc read
+ * @channel:	analog channel to be read
+ *
+ * This function obtains the raw ADC value, this then needs
+ * to be converted by calling ab8500_gpadc_ad_to_voltage()
+ */
+int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 {
 	int ret;
-	u16 data = 0;
 	int looplimit = 0;
 	u8 val, low_data, high_data;
 
@@ -278,9 +309,9 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 		goto out;
 	}
 
-	/* Select the input source and set average samples to 16 */
+	/* Select the channel source and set average samples to 16 */
 	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL2_REG, (input | SW_AVG_16));
+		AB8500_GPADC_CTRL2_REG, (channel | SW_AVG_16));
 	if (ret < 0) {
 		dev_err(gpadc->dev,
 			"gpadc_conversion: set avg samples failed\n");
@@ -292,7 +323,7 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 	 * charging current sense if it needed, ABB 3.0 needs some special
 	 * treatment too.
 	 */
-	switch (input) {
+	switch (channel) {
 	case MAIN_CHARGER_C:
 	case USB_CHARGER_C:
 		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
@@ -359,7 +390,6 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 		goto out;
 	}
 
-	data = (high_data << 8) | low_data;
 	/* Disable GPADC */
 	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
@@ -370,8 +400,8 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 	/* Disable VTVout LDO this is required for GPADC */
 	regulator_disable(gpadc->regu);
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
-	ret = ab8500_gpadc_ad_to_voltage(gpadc, input, data);
-	return ret;
+
+	return (high_data << 8) | low_data;
 
 out:
 	/*
@@ -385,10 +415,10 @@ out:
 	regulator_disable(gpadc->regu);
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	dev_err(gpadc->dev,
-		"gpadc_conversion: Failed to AD convert channel %d\n", input);
+		"gpadc_conversion: Failed to AD convert channel %d\n", channel);
 	return ret;
 }
-EXPORT_SYMBOL(ab8500_gpadc_convert);
+EXPORT_SYMBOL(ab8500_gpadc_read_raw);
 
 /**
  * ab8500_bm_gpswadcconvend_handler() - isr for s/w gpadc conversion completion
diff --git a/include/linux/mfd/ab8500/gpadc.h b/include/linux/mfd/ab8500/gpadc.h
index 46b9540..2529667 100644
--- a/include/linux/mfd/ab8500/gpadc.h
+++ b/include/linux/mfd/ab8500/gpadc.h
@@ -27,6 +27,9 @@
 struct ab8500_gpadc;
 
 struct ab8500_gpadc *ab8500_gpadc_get(char *name);
-int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input);
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel);
+int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel);
+int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc,
+    u8 channel, int ad_value);
 
 #endif /* _AB8500_GPADC_H */
-- 
1.7.3.2

