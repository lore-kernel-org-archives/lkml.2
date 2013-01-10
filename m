Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3AJMFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:05:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50019 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab3AJMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/11] extcon: arizona: Support direct microphone measurement via HPDET
Date: Thu, 10 Jan 2013 12:04:21 +0000
Message-Id: <1357819462-12232-10-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some GPIO control it is possible to detect microphones in a wider
range of configurations by directly measuring the microphone impedance
when the HPDET method cannot distinguish between the behaviour of the
two grounds. Allow a GPIO to be provided in platform data and use it to
implement this behaviour.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |   50 +++++++++++++++++++++++++++++++++----
 include/linux/mfd/arizona/pdata.h |    3 +++
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index ba9525e..de141f7 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -56,7 +56,7 @@ struct arizona_extcon_info {
 	bool hpdet_active;
 
 	int num_hpdet_res;
-	unsigned int hpdet_res[2];
+	unsigned int hpdet_res[3];
 
 	bool mic;
 	bool detecting;
@@ -313,6 +313,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 {
 	struct arizona *arizona = info->arizona;
+	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	int ret;
 
 	/*
@@ -338,9 +339,27 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 					   ARIZONA_ACCESSORY_DETECT_MODE_1,
 					   ARIZONA_ACCDET_SRC,
 					   ~info->micd_modes[0].src);
+
 			regmap_update_bits(arizona->regmap,
 					   ARIZONA_HEADPHONE_DETECT_1,
-					   ARIZONA_HP_POLL, 0);
+					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
+			return -EAGAIN;
+		}
+
+		/* Only check the mic directly if we didn't already ID it */
+		if (id_gpio && info->num_hpdet_res == 2 &&
+		    !((info->hpdet_res[0] > info->hpdet_res[1] * 2))) {
+			dev_dbg(arizona->dev, "Measuring mic\n");
+
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_ACCESSORY_DETECT_MODE_1,
+					   ARIZONA_ACCDET_MODE_MASK |
+					   ARIZONA_ACCDET_SRC,
+					   ARIZONA_ACCDET_MODE_HPR |
+					   info->micd_modes[0].src);
+
+			gpio_set_value_cansleep(id_gpio, 1);
+
 			regmap_update_bits(arizona->regmap,
 					   ARIZONA_HEADPHONE_DETECT_1,
 					   ARIZONA_HP_POLL, ARIZONA_HP_POLL);
@@ -348,10 +367,16 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		}
 
 		/* OK, got both.  Now, compare... */
-		dev_dbg(arizona->dev, "HPDET measured %d %d\n",
-			info->hpdet_res[0], info->hpdet_res[1]);
+		dev_dbg(arizona->dev, "HPDET measured %d %d %d\n",
+			info->hpdet_res[0], info->hpdet_res[1],
+			info->hpdet_res[2]);
 
-		if (info->hpdet_res[0] > info->hpdet_res[1] * 2) {
+		/*
+		 * Either the two grounds measure differently or we
+		 * measure the mic as high impedance.
+		 */
+		if ((info->hpdet_res[0] > info->hpdet_res[1] * 2) ||
+		    (id_gpio && info->hpdet_res[2] > 10)) {
 			dev_dbg(arizona->dev, "Detected mic\n");
 			info->mic = true;
 			ret = extcon_set_cable_state_(&info->edev,
@@ -382,6 +407,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
+	int id_gpio = arizona->pdata.hpdet_id_gpio;
 	int report = ARIZONA_CABLE_HEADPHONE;
 	int ret, reading;
 
@@ -446,6 +472,8 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 		dev_warn(arizona->dev, "Failed to undo magic: %d\n", ret);
 
 done:
+	if (id_gpio)
+		gpio_set_value_cansleep(id_gpio, 0);
 
 	/* Revert back to MICDET mode */
 	regmap_update_bits(arizona->regmap,
@@ -854,6 +882,18 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (arizona->pdata.hpdet_id_gpio > 0) {
+		ret = devm_gpio_request_one(&pdev->dev,
+					    arizona->pdata.hpdet_id_gpio,
+					    GPIOF_OUT_INIT_LOW,
+					    "HPDET");
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to request GPIO%d: %d\n",
+				arizona->pdata.hpdet_id_gpio, ret);
+			goto err_register;
+		}
+	}
+
 	if (arizona->pdata.micd_bias_start_time)
 		regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_1,
 				   ARIZONA_MICD_BIAS_STARTTIME_MASK,
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 7c08787..bcbe4fd 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -102,6 +102,9 @@ struct arizona_pdata {
 	/** Use the headphone detect circuit to identify the accessory */
 	bool hpdet_acc_id;
 
+	/** GPIO used for mic isolation with HPDET */
+	int hpdet_id_gpio;
+
 	/** GPIO for mic detection polarity */
 	int micd_pol_gpio;
 
-- 
1.7.10.4

