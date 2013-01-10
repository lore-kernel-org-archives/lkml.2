Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3AJMEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:04:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab3AJMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:04:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/11] extcon: arizona: Use microphone clamp function if available
Date: Thu, 10 Jan 2013 12:04:16 +0000
Message-Id: <1357819462-12232-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <1357819462-12232-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Arizona devices include a microphone clamp function which is tied to
jack detect. Activate this feature when present in order to ensure best
performance of the subsystem.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c       |   19 +++++++++++++++++++
 include/linux/mfd/arizona/core.h      |    4 +++-
 include/linux/mfd/arizona/registers.h |   28 ++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 635b707..3ef3bee 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -45,6 +45,7 @@ struct arizona_extcon_info {
 	int micd_num_modes;
 
 	bool micd_reva;
+	bool micd_clamp;
 
 	bool mic;
 	bool detecting;
@@ -375,6 +376,7 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 			info->micd_reva = true;
 			break;
 		default:
+			info->micd_clamp = true;
 			break;
 		}
 		break;
@@ -423,6 +425,19 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 				   arizona->pdata.micd_bias_start_time
 				   << ARIZONA_MICD_BIAS_STARTTIME_SHIFT);
 
+	/*
+	 * If we have a clamp use it.
+	 */
+	if (info->micd_clamp) {
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_MICD_CLAMP_CONTROL,
+				   ARIZONA_MICD_CLAMP_MODE_MASK, 4);
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_JACK_DETECT_DEBOUNCE,
+				   ARIZONA_MICD_CLAMP_DB,
+				   ARIZONA_MICD_CLAMP_DB);
+	}
+
 	arizona_extcon_set_mode(info, 0);
 
 	info->input = devm_input_allocate_device(&pdev->dev);
@@ -529,6 +544,10 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	regmap_update_bits(arizona->regmap,
+			   ARIZONA_MICD_CLAMP_CONTROL,
+			   ARIZONA_MICD_CLAMP_MODE_MASK, 0);
+
 	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_RISE, 0);
 	arizona_set_irq_wake(arizona, ARIZONA_IRQ_JD_FALL, 0);
 	arizona_free_irq(arizona, ARIZONA_IRQ_MICDET, info);
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index a580363..a710255 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -75,8 +75,10 @@ enum arizona_type {
 #define ARIZONA_IRQ_DCS_HP_DONE           47
 #define ARIZONA_IRQ_FLL2_CLOCK_OK         48
 #define ARIZONA_IRQ_FLL1_CLOCK_OK         49
+#define ARIZONA_IRQ_MICD_CLAMP_RISE	  50
+#define ARIZONA_IRQ_MICD_CLAMP_FALL	  51
 
-#define ARIZONA_NUM_IRQ                   50
+#define ARIZONA_NUM_IRQ                   52
 
 struct snd_soc_dapm_context;
 
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 1f6fe31..f3211f0 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -119,6 +119,7 @@
 #define ARIZONA_ACCESSORY_DETECT_MODE_1          0x293
 #define ARIZONA_HEADPHONE_DETECT_1               0x29B
 #define ARIZONA_HEADPHONE_DETECT_2               0x29C
+#define ARIZONA_MICD_CLAMP_CONTROL               0x2A2
 #define ARIZONA_MIC_DETECT_1                     0x2A3
 #define ARIZONA_MIC_DETECT_2                     0x2A4
 #define ARIZONA_MIC_DETECT_3                     0x2A5
@@ -2070,6 +2071,13 @@
 #define ARIZONA_HP_LVL_WIDTH                          7  /* HP_LVL - [6:0] */
 
 /*
+ * R674 (0x2A2) - MICD clamp control
+ */
+#define ARIZONA_MICD_CLAMP_MODE_MASK             0x000F  /* MICD_CLAMP_MODE - [3:0] */
+#define ARIZONA_MICD_CLAMP_MODE_SHIFT                 0  /* MICD_CLAMP_MODE - [3:0] */
+#define ARIZONA_MICD_CLAMP_MODE_WIDTH                 4  /* MICD_CLAMP_MODE - [3:0] */
+
+/*
  * R675 (0x2A3) - Mic Detect 1
  */
 #define ARIZONA_MICD_BIAS_STARTTIME_MASK         0xF000  /* MICD_BIAS_STARTTIME - [15:12] */
@@ -5267,6 +5275,12 @@
 /*
  * R3409 (0xD51) - AOD IRQ1
  */
+#define ARIZONA_MICD_CLAMP_FALL_EINT1            0x0080  /* MICD_CLAMP_FALL_EINT1 */
+#define ARIZONA_MICD_CLAMP_FALL_EINT1_MASK       0x0080  /* MICD_CLAMP_FALL_EINT1 */
+#define ARIZONA_MICD_CLAMP_FALL_EINT1_SHIFT           7  /* MICD_CLAMP_FALL_EINT1 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT1            0x0040  /* MICD_CLAMP_RISE_EINT1 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT1_MASK       0x0040  /* MICD_CLAMP_RISE_EINT1 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT1_SHIFT           6  /* MICD_CLAMP_RISE_EINT1 */
 #define ARIZONA_GP5_FALL_EINT1                   0x0020  /* GP5_FALL_EINT1 */
 #define ARIZONA_GP5_FALL_EINT1_MASK              0x0020  /* GP5_FALL_EINT1 */
 #define ARIZONA_GP5_FALL_EINT1_SHIFT                  5  /* GP5_FALL_EINT1 */
@@ -5295,6 +5309,12 @@
 /*
  * R3410 (0xD52) - AOD IRQ2
  */
+#define ARIZONA_MICD_CLAMP_FALL_EINT2            0x0080  /* MICD_CLAMP_FALL_EINT2 */
+#define ARIZONA_MICD_CLAMP_FALL_EINT2_MASK       0x0080  /* MICD_CLAMP_FALL_EINT2 */
+#define ARIZONA_MICD_CLAMP_FALL_EINT2_SHIFT           7  /* MICD_CLAMP_FALL_EINT2 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT2            0x0040  /* MICD_CLAMP_RISE_EINT2 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT2_MASK       0x0040  /* MICD_CLAMP_RISE_EINT2 */
+#define ARIZONA_MICD_CLAMP_RISE_EINT2_SHIFT           6  /* MICD_CLAMP_RISE_EINT2 */
 #define ARIZONA_GP5_FALL_EINT2                   0x0020  /* GP5_FALL_EINT2 */
 #define ARIZONA_GP5_FALL_EINT2_MASK              0x0020  /* GP5_FALL_EINT2 */
 #define ARIZONA_GP5_FALL_EINT2_SHIFT                  5  /* GP5_FALL_EINT2 */
@@ -5379,6 +5399,10 @@
 /*
  * R3413 (0xD55) - AOD IRQ Raw Status
  */
+#define ARIZONA_MICD_CLAMP_STS                   0x0008  /* MICD_CLAMP_STS */
+#define ARIZONA_MICD_CLAMP_STS_MASK              0x0008  /* MICD_CLAMP_STS */
+#define ARIZONA_MICD_CLAMP_STS_SHIFT                  3  /* MICD_CLAMP_STS */
+#define ARIZONA_MICD_CLAMP_STS_WIDTH                  1  /* MICD_CLAMP_STS */
 #define ARIZONA_GP5_STS                          0x0004  /* GP5_STS */
 #define ARIZONA_GP5_STS_MASK                     0x0004  /* GP5_STS */
 #define ARIZONA_GP5_STS_SHIFT                         2  /* GP5_STS */
@@ -5395,6 +5419,10 @@
 /*
  * R3414 (0xD56) - Jack detect debounce
  */
+#define ARIZONA_MICD_CLAMP_DB                    0x0008  /* MICD_CLAMP_DB */
+#define ARIZONA_MICD_CLAMP_DB_MASK               0x0008  /* MICD_CLAMP_DB */
+#define ARIZONA_MICD_CLAMP_DB_SHIFT                   3  /* MICD_CLAMP_DB */
+#define ARIZONA_MICD_CLAMP_DB_WIDTH                   1  /* MICD_CLAMP_DB */
 #define ARIZONA_JD2_DB                           0x0002  /* JD2_DB */
 #define ARIZONA_JD2_DB_MASK                      0x0002  /* JD2_DB */
 #define ARIZONA_JD2_DB_SHIFT                          1  /* JD2_DB */
-- 
1.7.10.4

