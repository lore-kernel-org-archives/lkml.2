Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3AJMFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:05:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50013 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209Ab3AJMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/11] extcon: arizona: Move start and stop mic functions earlier
Date: Thu, 10 Jan 2013 12:04:19 +0000
Message-Id: <1357819462-12232-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple code motion supporting future work.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |  120 +++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index cc258a8..dab4584 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -112,6 +112,66 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 	dev_dbg(arizona->dev, "Set jack polarity to %d\n", mode);
 }
 
+static void arizona_start_mic(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	bool change;
+	int ret;
+
+	info->detecting = true;
+	info->mic = false;
+	info->jack_flips = 0;
+
+	/* Microphone detection can't use idle mode */
+	pm_runtime_get(info->dev);
+
+	ret = regulator_enable(info->micvdd);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to enable MICVDD: %d\n",
+			ret);
+	}
+
+	if (info->micd_reva) {
+		regmap_write(arizona->regmap, 0x80, 0x3);
+		regmap_write(arizona->regmap, 0x294, 0);
+		regmap_write(arizona->regmap, 0x80, 0x0);
+	}
+
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_ACCESSORY_DETECT_MODE_1,
+			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
+
+	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				 ARIZONA_MICD_ENA, ARIZONA_MICD_ENA,
+				 &change);
+	if (!change) {
+		regulator_disable(info->micvdd);
+		pm_runtime_put_autosuspend(info->dev);
+	}
+}
+
+static void arizona_stop_mic(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	bool change;
+
+	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
+				 ARIZONA_MICD_ENA, 0,
+				 &change);
+
+	if (info->micd_reva) {
+		regmap_write(arizona->regmap, 0x80, 0x3);
+		regmap_write(arizona->regmap, 0x294, 2);
+		regmap_write(arizona->regmap, 0x80, 0x0);
+	}
+
+	if (change) {
+		regulator_disable(info->micvdd);
+		pm_runtime_mark_last_busy(info->dev);
+		pm_runtime_put_autosuspend(info->dev);
+	}
+}
+
 static struct {
 	unsigned int factor_a;
 	unsigned int factor_b;
@@ -396,66 +456,6 @@ err:
 	info->hpdet_active = false;
 }
 
-static void arizona_start_mic(struct arizona_extcon_info *info)
-{
-	struct arizona *arizona = info->arizona;
-	bool change;
-	int ret;
-
-	info->detecting = true;
-	info->mic = false;
-	info->jack_flips = 0;
-
-	/* Microphone detection can't use idle mode */
-	pm_runtime_get(info->dev);
-
-	ret = regulator_enable(info->micvdd);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to enable MICVDD: %d\n",
-			ret);
-	}
-
-	if (info->micd_reva) {
-		regmap_write(arizona->regmap, 0x80, 0x3);
-		regmap_write(arizona->regmap, 0x294, 0);
-		regmap_write(arizona->regmap, 0x80, 0x0);
-	}
-
-	regmap_update_bits(arizona->regmap,
-			   ARIZONA_ACCESSORY_DETECT_MODE_1,
-			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
-
-	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
-				 ARIZONA_MICD_ENA, ARIZONA_MICD_ENA,
-				 &change);
-	if (!change) {
-		regulator_disable(info->micvdd);
-		pm_runtime_put_autosuspend(info->dev);
-	}
-}
-
-static void arizona_stop_mic(struct arizona_extcon_info *info)
-{
-	struct arizona *arizona = info->arizona;
-	bool change;
-
-	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
-				 ARIZONA_MICD_ENA, 0,
-				 &change);
-
-	if (info->micd_reva) {
-		regmap_write(arizona->regmap, 0x80, 0x3);
-		regmap_write(arizona->regmap, 0x294, 2);
-		regmap_write(arizona->regmap, 0x80, 0x0);
-	}
-
-	if (change) {
-		regulator_disable(info->micvdd);
-		pm_runtime_mark_last_busy(info->dev);
-		pm_runtime_put_autosuspend(info->dev);
-	}
-}
-
 static irqreturn_t arizona_micdet(int irq, void *data)
 {
 	struct arizona_extcon_info *info = data;
-- 
1.7.10.4

