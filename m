Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3AJMEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:04:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50005 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab3AJMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/11] extcon: arizona: Support use of GPIO5 as an input to jack detection
Date: Thu, 10 Jan 2013 12:04:17 +0000
Message-Id: <1357819462-12232-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some system designs provide an input on GPIO5 which in conjunction with
the jack detection feature indicates the presence of an accessory.
Support such systems, using the microphone clamp feature to minimise
wakeups of the processor.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   76 ++++++++++++++++++++++++++++---------
 include/linux/mfd/arizona/pdata.h |    3 ++
 2 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 3ef3bee..b5190a8 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -290,13 +290,21 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
-	unsigned int val;
+	unsigned int val, present, mask;
 	int ret, i;
 
 	pm_runtime_get_sync(info->dev);
 
 	mutex_lock(&info->lock);
 
+	if (arizona->pdata.jd_gpio5) {
+		mask = ARIZONA_MICD_CLAMP_STS;
+		present = 0;
+	} else {
+		mask = ARIZONA_JD1_STS;
+		present = ARIZONA_JD1_STS;
+	}
+
 	ret = regmap_read(arizona->regmap, ARIZONA_AOD_IRQ_RAW_STATUS, &val);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read jackdet status: %d\n",
@@ -306,7 +314,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if (val & ARIZONA_JD1_STS) {
+	if ((val & mask) == present) {
 		dev_dbg(arizona->dev, "Detected jack\n");
 		ret = extcon_set_cable_state_(&info->edev,
 					      ARIZONA_CABLE_MECHANICAL, true);
@@ -321,6 +329,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 		arizona_stop_mic(info);
 
+
 		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
 			input_report_key(info->input,
 					 arizona_lvl_to_key[i].report, 0);
@@ -345,6 +354,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct arizona_pdata *pdata;
 	struct arizona_extcon_info *info;
+	int jack_irq_fall, jack_irq_rise;
 	int ret, mode, i;
 
 	pdata = dev_get_platdata(arizona->dev);
@@ -426,12 +436,24 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 				   << ARIZONA_MICD_BIAS_STARTTIME_SHIFT);
 
 	/*
-	 * If we have a clamp use it.
+	 * If we have a clamp use it, activating in conjunction with
+	 * GPIO5 if that is connected for jack detect operation.
 	 */
 	if (info->micd_clamp) {
-		regmap_update_bits(arizona->regmap,
-				   ARIZONA_MICD_CLAMP_CONTROL,
-				   ARIZONA_MICD_CLAMP_MODE_MASK, 4);
+		if (arizona->pdata.jd_gpio5) {
+			/* Put the GPIO into input mode */
+			regmap_write(arizona->regmap, ARIZONA_GPIO5_CTRL,
+				     0xc101);
+
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_MICD_CLAMP_CONTROL,
+					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x9);
+		} else {
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_MICD_CLAMP_CONTROL,
+					   ARIZONA_MICD_CLAMP_MODE_MASK, 0x4);
+		}
+
 		regmap_update_bits(arizona->regmap,
 				   ARIZONA_JACK_DETECT_DEBOUNCE,
 				   ARIZONA_MICD_CLAMP_DB,
@@ -458,7 +480,15 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	pm_runtime_idle(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	ret = arizona_request_irq(arizona, ARIZONA_IRQ_JD_RISE,
+	if (arizona->pdata.jd_gpio5) {
+		jack_irq_rise = ARIZONA_IRQ_MICD_CLAMP_RISE;
+		jack_irq_fall = ARIZONA_IRQ_MICD_CLAMP_FALL;
+	} else {
+		jack_irq_rise = ARIZONA_IRQ_JD_RISE;
+		jack_irq_fall = ARIZONA_IRQ_JD_FALL;
+	}
+
+	ret = arizona_request_irq(arizona, jack_irq_rise,
 				  "JACKDET rise", arizona_jackdet, info);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to get JACKDET rise IRQ: %d\n",
@@ -466,21 +496,21 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		goto err_input;
 	}
 
-	ret = arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 1);
+	ret = arizona_set_irq_wake(arizona, jack_irq_rise, 1);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to set JD rise IRQ wake: %d\n",
 			ret);
 		goto err_rise;
 	}
 
-	ret = arizona_request_irq(arizona, ARIZONA_IRQ_JD_FALL,
+	ret = arizona_request_irq(arizona, jack_irq_fall,
 				  "JACKDET fall", arizona_jackdet, info);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to get JD fall IRQ: %d\n", ret);
 		goto err_rise_wake;
 	}
 
-	ret = arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 1);
+	ret = arizona_set_irq_wake(arizona, jack_irq_fall, 1);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to set JD fall IRQ wake: %d\n",
 			ret);
@@ -522,13 +552,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 err_micdet:
 	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
 err_fall_wake:
-	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 0);
+	arizona_set_irq_wake(arizona, jack_irq_fall, 0);
 err_fall:
-	arizona_free_irq(arizona, ARIZONA_IRQ_JD_FALL, info);
+	arizona_free_irq(arizona, jack_irq_fall, info);
 err_rise_wake:
-	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 0);
+	arizona_set_irq_wake(arizona, jack_irq_rise, 0);
 err_rise:
-	arizona_free_irq(arizona, ARIZONA_IRQ_JD_RISE, info);
+	arizona_free_irq(arizona, jack_irq_rise, info);
 err_input:
 err_register:
 	pm_runtime_disable(&pdev->dev);
@@ -541,6 +571,7 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 {
 	struct arizona_extcon_info *info = platform_get_drvdata(pdev);
 	struct arizona *arizona = info->arizona;
+	int jack_irq_rise, jack_irq_fall;
 
 	pm_runtime_disable(&pdev->dev);
 
@@ -548,11 +579,20 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 			   ARIZONA_MICD_CLAMP_CONTROL,
 			   ARIZONA_MICD_CLAMP_MODE_MASK, 0);
 
-	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 0);
-	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 0);
+	if (arizona->pdata.jd_gpio5) {
+		jack_irq_rise = ARIZONA_IRQ_MICD_CLAMP_RISE;
+		jack_irq_fall = ARIZONA_IRQ_MICD_CLAMP_FALL;
+	} else {
+		jack_irq_rise = ARIZONA_IRQ_JD_RISE;
+		jack_irq_fall = ARIZONA_IRQ_JD_FALL;
+	}
+
+	arizona_set_irq_wake(arizona, jack_irq_rise, 0);
+	arizona_set_irq_wake(arizona, jack_irq_fall, 0);
+	arizona_free_irq(arizona, ARIZONA_IRQ_HPDET, info);
 	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
-	arizona_free_irq(arizona, ARIZONA_IRQ_JD_RISE, info);
-	arizona_free_irq(arizona, ARIZONA_IRQ_JD_FALL, info);
+	arizona_free_irq(arizona, jack_irq_rise, info);
+	arizona_free_irq(arizona, jack_irq_fall, info);
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 5b05088..0fc26a48 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -96,6 +96,9 @@ struct arizona_pdata {
 	/** Pin state for GPIO pins */
 	int gpio_defaults[ARIZONA_MAX_GPIO];
 
+	/** GPIO5 is used for jack detection */
+	bool jd_gpio5;
+
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
-- 
1.7.10.4

