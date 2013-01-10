Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3AJMFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:05:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50007 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab3AJMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/11] extcon: arizona: Enable basic headphone identification
Date: Thu, 10 Jan 2013 12:04:18 +0000
Message-Id: <1357819462-12232-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the headphone detection to identify if the accessory is a headphone or
line load. There are two different revisions of the IP with different
register layouts, support both.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c       |  341 +++++++++++++++++++++++++++++++--
 drivers/mfd/wm5102-tables.c           |    3 +
 include/linux/mfd/arizona/registers.h |   12 ++
 3 files changed, 335 insertions(+), 21 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index b5190a8..cc258a8 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -31,8 +31,14 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
+#define ARIZONA_DEFAULT_HP 32
+
 #define ARIZONA_NUM_BUTTONS 6
 
+#define ARIZONA_ACCDET_MODE_MIC 0
+#define ARIZONA_ACCDET_MODE_HPL 1
+#define ARIZONA_ACCDET_MODE_HPR 2
+
 struct arizona_extcon_info {
 	struct device *dev;
 	struct arizona *arizona;
@@ -47,10 +53,14 @@ struct arizona_extcon_info {
 	bool micd_reva;
 	bool micd_clamp;
 
+	bool hpdet_active;
+
 	bool mic;
 	bool detecting;
 	int jack_flips;
 
+	int hpdet_ip;
+
 	struct extcon_dev edev;
 };
 
@@ -74,11 +84,13 @@ static struct {
 #define ARIZONA_CABLE_MECHANICAL 0
 #define ARIZONA_CABLE_MICROPHONE 1
 #define ARIZONA_CABLE_HEADPHONE  2
+#define ARIZONA_CABLE_LINEOUT    3
 
 static const char *arizona_cable[] = {
 	"Mechanical",
 	"Microphone",
 	"Headphone",
+	"Line-out",
 	NULL,
 };
 
@@ -100,6 +112,290 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 	dev_dbg(arizona->dev, "Set jack polarity to %d\n", mode);
 }
 
+static struct {
+	unsigned int factor_a;
+	unsigned int factor_b;
+} arizona_hpdet_b_ranges[] = {
+	{  5528,   362464 },
+	{ 11084,  6186851 },
+	{ 11065, 65460395 },
+};
+
+static struct {
+	int min;
+	int max;
+} arizona_hpdet_c_ranges[] = {
+	{ 0,       30 },
+	{ 8,      100 },
+	{ 100,   1000 },
+	{ 1000, 10000 },
+};
+
+static int arizona_hpdet_read(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	unsigned int val, range;
+	int ret;
+
+	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_2, &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read HPDET status: %d\n",
+			ret);
+		return ret;
+	}
+
+	switch (info->hpdet_ip) {
+	case 0:
+		if (!(val & ARIZONA_HP_DONE)) {
+			dev_err(arizona->dev, "HPDET did not complete: %x\n",
+				val);
+			val = ARIZONA_DEFAULT_HP;
+		}
+
+		val &= ARIZONA_HP_LVL_MASK;
+		break;
+
+	case 1:
+		if (!(val & ARIZONA_HP_DONE_B)) {
+			dev_err(arizona->dev, "HPDET did not complete: %x\n",
+				val);
+			return ARIZONA_DEFAULT_HP;
+		}
+
+		ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to read HP value: %d\n",
+				ret);
+			return ARIZONA_DEFAULT_HP;
+		}
+
+		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
+			    &range);
+		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
+			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
+
+		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
+		    (val < 100 || val > 0x3fb)) {
+			range++;
+			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
+				range);
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_HEADPHONE_DETECT_1,
+					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+					   range <<
+					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+			return -EAGAIN;
+		}
+
+		/* If we go out of range report top of range */
+		if (val < 100 || val > 0x3fb) {
+			dev_dbg(arizona->dev, "Measurement out of range\n");
+			return 10000;
+		}
+
+		dev_dbg(arizona->dev, "HPDET read %d in range %d\n",
+			val, range);
+
+		val = arizona_hpdet_b_ranges[range].factor_b
+			/ ((val * 100) -
+			   arizona_hpdet_b_ranges[range].factor_a);
+		break;
+
+	default:
+		dev_warn(arizona->dev, "Unknown HPDET IP revision %d\n",
+			 info->hpdet_ip);
+	case 2:
+		if (!(val & ARIZONA_HP_DONE_B)) {
+			dev_err(arizona->dev, "HPDET did not complete: %x\n",
+				val);
+			return ARIZONA_DEFAULT_HP;
+		}
+
+		val &= ARIZONA_HP_LVL_B_MASK;
+
+		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
+			    &range);
+		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
+			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
+
+		/* Skip up or down a range? */
+		if (range && (val < arizona_hpdet_c_ranges[range].min)) {
+			range--;
+			dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
+				arizona_hpdet_c_ranges[range].min,
+				arizona_hpdet_c_ranges[range].max);
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_HEADPHONE_DETECT_1,
+					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+					   range <<
+					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+			return -EAGAIN;
+		}
+
+		if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
+		    (val >= arizona_hpdet_c_ranges[range].max)) {
+			range++;
+			dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
+				arizona_hpdet_c_ranges[range].min,
+				arizona_hpdet_c_ranges[range].max);
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_HEADPHONE_DETECT_1,
+					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
+					   range <<
+					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
+			return -EAGAIN;
+		}
+	}
+
+	dev_dbg(arizona->dev, "HP impedance %d ohms\n", val);
+	return val;
+}
+
+static irqreturn_t arizona_hpdet_irq(int irq, void *data)
+{
+	struct arizona_extcon_info *info = data;
+	struct arizona *arizona = info->arizona;
+	int report = ARIZONA_CABLE_HEADPHONE;
+	int ret;
+
+	mutex_lock(&info->lock);
+
+	/* If we got a spurious IRQ for some reason then ignore it */
+	if (!info->hpdet_active) {
+		dev_warn(arizona->dev, "Spurious HPDET IRQ\n");
+		mutex_unlock(&info->lock);
+		return IRQ_NONE;
+	}
+
+	/* If the cable was removed while measuring ignore the result */
+	ret = extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to check cable state: %d\n",
+			ret);
+		goto out;
+	} else if (!ret) {
+		dev_dbg(arizona->dev, "Ignoring HPDET for removed cable\n");
+		goto done;
+	}
+
+	ret = arizona_hpdet_read(info);
+	if (ret == -EAGAIN) {
+		goto out;
+	} else if (ret < 0) {
+		goto done;
+	}
+
+	/* Reset back to starting range */
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_HEADPHONE_DETECT_1,
+			   ARIZONA_HP_IMPEDANCE_RANGE_MASK, 0);
+
+	/* Report high impedence cables as line outputs */
+	if (ret >= 5000)
+		report = ARIZONA_CABLE_LINEOUT;
+	else
+		report = ARIZONA_CABLE_HEADPHONE;
+
+	ret = extcon_set_cable_state_(&info->edev, report, true);
+	if (ret != 0)
+		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
+			ret);
+
+	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
+
+	ret = regmap_update_bits(arizona->regmap, 0x226, 0x4000, 0);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
+
+done:
+	regmap_update_bits(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
+			   ARIZONA_HP_POLL, 0);
+
+	/* Revert back to MICDET mode */
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_ACCESSORY_DETECT_MODE_1,
+			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
+
+	/* If we have a mic then reenable MICDET */
+	if (info->mic)
+		arizona_start_mic(info);
+
+	if (info->hpdet_active) {
+		pm_runtime_put_autosuspend(info->dev);
+		info->hpdet_active = false;
+	}
+
+out:
+	mutex_unlock(&info->lock);
+
+	return IRQ_HANDLED;
+}
+
+static void arizona_identify_headphone(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	int ret;
+
+	dev_dbg(arizona->dev, "Starting HPDET\n");
+
+	/* Make sure we keep the device enabled during the measurement */
+	pm_runtime_get(info->dev);
+
+	info->hpdet_active = true;
+
+	if (info->mic)
+		arizona_stop_mic(info);
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
+				 ARIZONA_ACCDET_MODE_MASK,
+				 ARIZONA_ACCDET_MODE_HPL);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to set HPDETL mode: %d\n", ret);
+		goto err;
+	}
+
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
+	if (info->mic)
+		arizona_start_mic(info);
+
+	info->hpdet_active = false;
+}
+	}
+
+	info->hpdet_active = false;
+}
+
 static void arizona_start_mic(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
@@ -125,6 +421,10 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
 		regmap_write(arizona->regmap, 0x80, 0x0);
 	}
 
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_ACCESSORY_DETECT_MODE_1,
+			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
+
 	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
 				 ARIZONA_MICD_ENA, ARIZONA_MICD_ENA,
 				 &change);
@@ -189,11 +489,11 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 
 	/* If we got a high impedence we should have a headset, report it. */
 	if (info->detecting && (val & 0x400)) {
+		arizona_identify_headphone(info);
+
 		ret = extcon_update_state(&info->edev,
-					  1 << ARIZONA_CABLE_MICROPHONE |
-					  1 << ARIZONA_CABLE_HEADPHONE,
-					  1 << ARIZONA_CABLE_MICROPHONE |
-					  1 << ARIZONA_CABLE_HEADPHONE);
+					  1 << ARIZONA_CABLE_MICROPHONE,
+					  1 << ARIZONA_CABLE_MICROPHONE);
 
 		if (ret != 0)
 			dev_err(arizona->dev, "Headset report failed: %d\n",
@@ -214,17 +514,12 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		info->jack_flips++;
 
 		if (info->jack_flips >= info->micd_num_modes) {
-			dev_dbg(arizona->dev, "Detected headphone\n");
+			dev_dbg(arizona->dev, "Detected HP/line\n");
+			arizona_identify_headphone(info);
+
 			info->detecting = false;
-			arizona_stop_mic(info);
 
-			ret = extcon_set_cable_state_(&info->edev,
-						      ARIZONA_CABLE_HEADPHONE,
-						      true);
-			if (ret != 0)
-				dev_err(arizona->dev,
-					"Headphone report failed: %d\n",
-				ret);
+			arizona_stop_mic(info);
 		} else {
 			info->micd_mode++;
 			if (info->micd_mode == info->micd_num_modes)
@@ -260,13 +555,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			info->detecting = false;
 			arizona_stop_mic(info);
 
-			ret = extcon_set_cable_state_(&info->edev,
-						      ARIZONA_CABLE_HEADPHONE,
-						      true);
-			if (ret != 0)
-				dev_err(arizona->dev,
-					"Headphone report failed: %d\n",
-				ret);
+			arizona_identify_headphone(info);
 		} else {
 			dev_warn(arizona->dev, "Button with no mic: %x\n",
 				 val);
@@ -387,6 +676,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 			break;
 		default:
 			info->micd_clamp = true;
+			info->hpdet_ip = 1;
 			break;
 		}
 		break;
@@ -524,6 +814,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		goto err_fall_wake;
 	}
 
+	ret = arizona_request_irq(arizona, ARIZONA_IRQ_HPDET,
+				  "HPDET", arizona_hpdet_irq, info);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to get HPDET IRQ: %d\n", ret);
+		goto err_micdet;
+	}
+
 	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
 			   ARIZONA_MICD_RATE_MASK,
 			   8 << ARIZONA_MICD_RATE_SHIFT);
@@ -544,11 +841,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	ret = input_register_device(info->input);
 	if (ret) {
 		dev_err(&pdev->dev, "Can't register input device: %d\n", ret);
-		goto err_micdet;
+		goto err_hpdet;
 	}
 
 	return 0;
 
+err_hpdet:
+	arizona_free_irq(arizona, ARIZONA_IRQ_HPDET, info);
 err_micdet:
 	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
 err_fall_wake:
diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 088872a..311cc36 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1106,6 +1106,8 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_ACCESSORY_DETECT_MODE_1:
 	case ARIZONA_HEADPHONE_DETECT_1:
 	case ARIZONA_HEADPHONE_DETECT_2:
+	case ARIZONA_HP_DACVAL:
+	case ARIZONA_MICD_CLAMP_CONTROL:
 	case ARIZONA_MIC_DETECT_1:
 	case ARIZONA_MIC_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
@@ -1875,6 +1877,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_2:
 	case ARIZONA_DSP1_STATUS_3:
 	case ARIZONA_HEADPHONE_DETECT_2:
+	case ARIZONA_HP_DACVAL:
 	case ARIZONA_MIC_DETECT_3:
 		return true;
 	default:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index f3211f0..e915053 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -119,6 +119,7 @@
 #define ARIZONA_ACCESSORY_DETECT_MODE_1          0x293
 #define ARIZONA_HEADPHONE_DETECT_1               0x29B
 #define ARIZONA_HEADPHONE_DETECT_2               0x29C
+#define ARIZONA_HP_DACVAL			 0x29F
 #define ARIZONA_MICD_CLAMP_CONTROL               0x2A2
 #define ARIZONA_MIC_DETECT_1                     0x2A3
 #define ARIZONA_MIC_DETECT_2                     0x2A4
@@ -2036,6 +2037,9 @@
 /*
  * R667 (0x29B) - Headphone Detect 1
  */
+#define ARIZONA_HP_IMPEDANCE_RANGE_MASK          0x0600  /* HP_IMPEDANCE_RANGE - [10:9] */
+#define ARIZONA_HP_IMPEDANCE_RANGE_SHIFT              9  /* HP_IMPEDANCE_RANGE - [10:9] */
+#define ARIZONA_HP_IMPEDANCE_RANGE_WIDTH              2  /* HP_IMPEDANCE_RANGE - [10:9] */
 #define ARIZONA_HP_STEP_SIZE                     0x0100  /* HP_STEP_SIZE */
 #define ARIZONA_HP_STEP_SIZE_MASK                0x0100  /* HP_STEP_SIZE */
 #define ARIZONA_HP_STEP_SIZE_SHIFT                    8  /* HP_STEP_SIZE */
@@ -2070,6 +2074,14 @@
 #define ARIZONA_HP_LVL_SHIFT                          0  /* HP_LVL - [6:0] */
 #define ARIZONA_HP_LVL_WIDTH                          7  /* HP_LVL - [6:0] */
 
+#define ARIZONA_HP_DONE_B                        0x8000  /* HP_DONE */
+#define ARIZONA_HP_DONE_B_MASK                   0x8000  /* HP_DONE */
+#define ARIZONA_HP_DONE_B_SHIFT                      15  /* HP_DONE */
+#define ARIZONA_HP_DONE_B_WIDTH                       1  /* HP_DONE */
+#define ARIZONA_HP_LVL_B_MASK                    0x7FFF  /* HP_LVL - [14:0] */
+#define ARIZONA_HP_LVL_B_SHIFT                        0  /* HP_LVL - [14:0] */
+#define ARIZONA_HP_LVL_B_WIDTH                       15  /* HP_LVL - [14:0] */
+
 /*
  * R674 (0x2A2) - MICD clamp control
  */
-- 
1.7.10.4

