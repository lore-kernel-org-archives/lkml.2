Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3AJMFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:05:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50016 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab3AJMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 09/11] extcon: arizona: Support HPDET based accessory identification
Date: Thu, 10 Jan 2013 12:04:20 +0000
Message-Id: <1357819462-12232-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The accessory detection functionality in Arizona devices is flexible and
supports several system designs in addition to the default one implemented
by the existing driver. One such design uses the HPDET feature to determine
what kind of accessory is present by comparing measurements taken with the
two headphone grounds available on the device, implement that if selected
by platform data.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |  159 ++++++++++++++++++++++++++++++++++---
 include/linux/mfd/arizona/pdata.h |    3 +
 2 files changed, 150 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index dab4584..ba9525e 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -55,6 +55,9 @@ struct arizona_extcon_info {
 
 	bool hpdet_active;
 
+	int num_hpdet_res;
+	unsigned int hpdet_res[2];
+
 	bool mic;
 	bool detecting;
 	int jack_flips;
@@ -65,8 +68,8 @@ struct arizona_extcon_info {
 };
 
 static const struct arizona_micd_config micd_default_modes[] = {
-	{ ARIZONA_ACCDET_SRC, 1 << ARIZONA_MICD_BIAS_SRC_SHIFT, 0 },
 	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
+	{ ARIZONA_ACCDET_SRC, 1 << ARIZONA_MICD_BIAS_SRC_SHIFT, 0 },
 };
 
 static struct {
@@ -118,10 +121,6 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
 	bool change;
 	int ret;
 
-	info->detecting = true;
-	info->mic = false;
-	info->jack_flips = 0;
-
 	/* Microphone detection can't use idle mode */
 	pm_runtime_get(info->dev);
 
@@ -311,12 +310,80 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 	return val;
 }
 
+static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
+{
+	struct arizona *arizona = info->arizona;
+	int ret;
+
+	/*
+	 * If we're using HPDET for accessory identification we need
+	 * to take multiple measurements, step through them in sequence.
+	 */
+	if (arizona->pdata.hpdet_acc_id) {
+		info->hpdet_res[info->num_hpdet_res++] = *reading;
+
+		/*
+		 * If the impedence is too high don't measure the
+		 * second ground.
+		 */
+		if (info->num_hpdet_res == 1 && *reading >= 45) {
+			dev_dbg(arizona->dev, "Skipping ground flip\n");
+			info->hpdet_res[info->num_hpdet_res++] = *reading;
+		}
+
+		if (info->num_hpdet_res == 1) {
+			dev_dbg(arizona->dev, "Flipping ground\n");
+
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_ACCESSORY_DETECT_MODE_1,
+					   ARIZONA_ACCDET_SRC,
+					   ~info->micd_modes[0].src);
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_HEADPHONE_DETECT_1,
+					   ARIZONA_HP_POLL, 0);
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_HEADPHONE_DETECT_1,
+					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+			return -EAGAIN;
+		}
+
+		/* OK, got both.  Now, compare... */
+		dev_dbg(arizona->dev, "HPDET measured %d %d\n",
+			info->hpdet_res[0], info->hpdet_res[1]);
+
+		if (info->hpdet_res[0] > info->hpdet_res[1] * 2) {
+			dev_dbg(arizona->dev, "Detected mic\n");
+			info->mic = true;
+			ret = extcon_set_cable_state_(&info->edev,
+						      ARIZONA_CABLE_MICROPHONE,
+						      true);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to report mic: %d\n", ret);
+			}
+
+			/* Take the headphone impedance for the main report */
+			*reading = info->hpdet_res[1];
+		} else {
+			dev_dbg(arizona->dev, "Detected headphone\n");
+		}
+
+		/* Make sure everything is reset back to the real polarity */
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_ACCESSORY_DETECT_MODE_1,
+				   ARIZONA_ACCDET_SRC,
+				   info->micd_modes[0].src);
+	}
+
+	return 0;
+}
+
 static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
 	int report = ARIZONA_CABLE_HEADPHONE;
-	int ret;
+	int ret, reading;
 
 	mutex_lock(&info->lock);
 
@@ -344,14 +411,23 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	} else if (ret < 0) {
 		goto done;
 	}
+	reading = ret;
 
 	/* Reset back to starting range */
 	regmap_update_bits(arizona->regmap,
 			   ARIZONA_HEADPHONE_DETECT_1,
-			   ARIZONA_HP_IMPEDANCE_RANGE_MASK, 0);
+			   ARIZONA_HP_IMPEDANCE_RANGE_MASK | ARIZONA_HP_POLL,
+			   0);
+
+	ret = arizona_hpdet_do_id(info, &reading);
+	if (ret == -EAGAIN) {
+		goto out;
+	} else if (ret < 0) {
+		goto done;
+	}
 
 	/* Report high impedence cables as line outputs */
-	if (ret >= 5000)
+	if (reading >= 5000)
 		report = ARIZONA_CABLE_LINEOUT;
 	else
 		report = ARIZONA_CABLE_HEADPHONE;
@@ -370,8 +446,6 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
 
 done:
-	regmap_update_bits(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
-			   ARIZONA_HP_POLL, 0);
 
 	/* Revert back to MICDET mode */
 	regmap_update_bits(arizona->regmap,
@@ -451,8 +525,58 @@ err:
 
 	info->hpdet_active = false;
 }
+
+static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	int ret;
+
+	dev_dbg(arizona->dev, "Starting identification via HPDET\n");
+
+	/* Make sure we keep the device enabled during the measurement */
+	pm_runtime_get(info->dev);
+
+	info->hpdet_active = true;
+
+	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
+
+	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0x4000);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
+
+	ret = regmap_update_bits(arizona->regmap,
+				 ARIZONA_ACCESSORY_DETECT_MODE_1,
+				 ARIZONA_ACCDET_SRC | ARIZONA_ACCDET_MODE_MASK,
+				 info->micd_modes[0].src |
+				 ARIZONA_ACCDET_MODE_HPL);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to set HPDETL mode: %d\n", ret);
+		goto err;
 	}
 
+	ret = regmap_update_bits(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
+				 ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Can't start HPDETL measurement: %d\n",
+			ret);
+		goto err;
+	}
+
+	return;
+
+err:
+	regmap_update_bits(arizona->regmap, ARIZONA_ACCESSORY_DETECT_MODE_1,
+			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
+
+	/* Just report headphone */
+	ret = extcon_update_state(&info->edev,
+				  1 << ARIZONA_CABLE_HEADPHONE,
+				  1 << ARIZONA_CABLE_HEADPHONE);
+	if (ret != 0)
+		dev_err(arizona->dev, "Failed to report headphone: %d\n", ret);
+
 	info->hpdet_active = false;
 }
 
@@ -612,12 +736,24 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 			dev_err(arizona->dev, "Mechanical report failed: %d\n",
 				ret);
 
-		arizona_start_mic(info);
+		if (!arizona->pdata.hpdet_acc_id) {
+			info->detecting = true;
+			info->mic = false;
+			info->jack_flips = 0;
+
+			arizona_start_mic(info);
+		} else {
+			arizona_start_hpdet_acc_id(info);
+		}
 	} else {
 		dev_dbg(arizona->dev, "Detected jack removal\n");
 
 		arizona_stop_mic(info);
 
+		info->num_hpdet_res = 0;
+		for (i = 0; i < ARRAY_SIZE(info->hpdet_res); i++)
+			info->hpdet_res[i] = 0;
+		info->mic = false;
 
 		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
 			input_report_key(info->input,
@@ -665,7 +801,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->arizona = arizona;
 	info->dev = &pdev->dev;
-	info->detecting = true;
 	platform_set_drvdata(pdev, info);
 
 	switch (arizona->type) {
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 0fc26a48..7c08787 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -99,6 +99,9 @@ struct arizona_pdata {
 	/** GPIO5 is used for jack detection */
 	bool jd_gpio5;
 
+	/** Use the headphone detect circuit to identify the accessory */
+	bool hpdet_acc_id;
+
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
-- 
1.7.10.4

