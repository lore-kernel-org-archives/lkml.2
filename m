Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab2CMTnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:43:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1184 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2CMTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:43:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Mar 2012 12:43:15 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>
CC: Peter Hsiang <cdefgab1288@gmail.com>, <linux-kernel@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] ASoC: max98095: add jack detection
Date: Tue, 13 Mar 2012 12:44:08 -0700
Message-ID: <1331667848-8168-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds the logic to support using the jack detect mechanism built
in to the codec to detect both when a jack was inserted and what type of
jack is present.

This change also supports the use of an external mechanism for headphone
detection. If this mechanism exists, when the max98095_jack_detect function
is called, the hp_jack is simply passed NULL.

This change supports both simple headphones, powered headphones, microphones
and headsets with both headphones and a mic.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 include/sound/max98095.h    |    7 ++
 sound/soc/codecs/max98095.c |  166 ++++++++++++++++++++++++++++++++++++++++++-
 sound/soc/codecs/max98095.h |   22 ++++++
 3 files changed, 194 insertions(+), 1 deletions(-)

diff --git a/include/sound/max98095.h b/include/sound/max98095.h
index 7513a42..7d0fb09 100644
--- a/include/sound/max98095.h
+++ b/include/sound/max98095.h
@@ -49,6 +49,13 @@ struct max98095_pdata {
 	 */
 	unsigned int digmic_left_mode:1;
 	unsigned int digmic_right_mode:1;
+
+	/* Pin5 is the mechanical method of sensing jack insertion
+	 * but it is something that might not be supported.
+	 * 0 = PIN5 not supported
+	 * 1 = PIN5 supported
+	 */
+	int jack_detect_pin5en:1;
 };
 
 #endif
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 0bb511a..fc7a335 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <asm/div64.h>
 #include <sound/max98095.h>
+#include <sound/jack.h>
 #include "max98095.h"
 
 enum max98095_type {
@@ -51,6 +52,9 @@ struct max98095_priv {
 	u8 lin_state;
 	unsigned int mic1pre;
 	unsigned int mic2pre;
+	int irq;
+	struct snd_soc_jack *headphone_jack;
+	struct snd_soc_jack *mic_jack;
 };
 
 static const u8 max98095_reg_def[M98095_REG_CNT] = {
@@ -2173,9 +2177,135 @@ static void max98095_handle_pdata(struct snd_soc_codec *codec)
 		max98095_handle_bq_pdata(codec);
 }
 
+static int max98095_report_jack(struct snd_soc_codec *codec)
+{
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	unsigned int value;
+	int hp_report = 0;
+	int mic_report = 0;
+
+	/* Read the Jack Status Register */
+	value = snd_soc_read(codec, M98095_007_JACK_AUTO_STS);
+
+	/* If ddone is not set, then detection isn't finished yet */
+	if ((value & M98095_DDONE) == 0)
+		return -EINVAL;
+
+	/* if hp, check its bit, and if set, clear it */
+	if ((value & M98095_HP_IN || value & M98095_LO_IN) &&
+		max98095->headphone_jack)
+		hp_report |= SND_JACK_HEADPHONE;
+
+	/* if mic, check its bit, and if set, clear it */
+	if ((value & M98095_MIC_IN) && max98095->mic_jack)
+		mic_report |= SND_JACK_MICROPHONE;
+
+	if (max98095->headphone_jack == max98095->mic_jack)
+		snd_soc_jack_report(max98095->headphone_jack,
+					hp_report | mic_report,
+					SND_JACK_HEADSET);
+	else {
+		if (max98095->headphone_jack)
+			snd_soc_jack_report(max98095->headphone_jack,
+					hp_report, SND_JACK_HEADPHONE);
+		if (max98095->mic_jack)
+			snd_soc_jack_report(max98095->mic_jack,
+					mic_report, SND_JACK_MICROPHONE);
+	}
+
+	return 0;
+}
+
+static irqreturn_t max98095_jack_handler(int irq, void *data)
+{
+	struct snd_soc_codec *codec = data;
+	int ret;
+
+	ret = max98095_report_jack(codec);
+
+	return ret ? IRQ_NONE : IRQ_HANDLED;
+
+}
+
+int max98095_jack_detect_enable(struct snd_soc_codec *codec)
+{
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+	int detect_enable = M98095_JDEN;
+
+	if (max98095->pdata->jack_detect_pin5en)
+		detect_enable |= M98095_PIN5EN;
+
+	/* configure jack detection: slew is calculated as 4 * (delay + 1)
+	 * The default is 24 (0x18) to get 100ms delay.
+	 */
+	ret = snd_soc_write(codec, M98095_08E_JACK_DC_SLEW,
+				M98095_DEFAULT_SLEW_DELAY);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to cfg auto detect %d\n", ret);
+		return ret;
+	}
+
+	/* configure auto detection to be enabled */
+	ret = snd_soc_write(codec, M98095_089_JACK_DET_AUTO, detect_enable);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to cfg auto detect %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+int max98095_jack_detect_disable(struct snd_soc_codec *codec)
+{
+	int ret = 0;
+
+	/* configure auto detection to be disabled */
+	ret = snd_soc_write(codec, M98095_089_JACK_DET_AUTO, 0x0);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to cfg auto detect %d\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+int max98095_jack_detect(struct snd_soc_codec *codec,
+	struct snd_soc_jack *hp_jack, struct snd_soc_jack *mic_jack)
+{
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+
+	max98095->headphone_jack = hp_jack;
+	max98095->mic_jack = mic_jack;
+
+	/* only progress if we have at least 1 jack pointer */
+	if (!hp_jack && !mic_jack)
+		return -EINVAL;
+
+	max98095_jack_detect_enable(codec);
+
+	/* enable interrupts for headphone jack detection */
+	ret = snd_soc_update_bits(codec, M98095_013_JACK_INT_EN,
+		M98095_IDDONE, M98095_IDDONE);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to cfg jack irqs %d\n", ret);
+		return ret;
+	}
+
+	max98095_report_jack(codec);
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int max98095_suspend(struct snd_soc_codec *codec)
 {
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+
+	if (max98095->headphone_jack || max98095->mic_jack)
+		max98095_jack_detect_disable(codec);
+
+	disable_irq(max98095->irq);
 	max98095_set_bias_level(codec, SND_SOC_BIAS_OFF);
 
 	return 0;
@@ -2183,8 +2313,16 @@ static int max98095_suspend(struct snd_soc_codec *codec)
 
 static int max98095_resume(struct snd_soc_codec *codec)
 {
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+
 	max98095_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
+	if (max98095->headphone_jack || max98095->mic_jack) {
+		max98095_jack_detect_enable(codec);
+		max98095_report_jack(codec);
+	}
+	enable_irq(max98095->irq);
+
 	return 0;
 }
 #else
@@ -2266,11 +2404,23 @@ static int max98095_probe(struct snd_soc_codec *codec)
 	max98095->mic1pre = 0;
 	max98095->mic2pre = 0;
 
+	if (max98095->irq) {
+		/* register an audio interrupt */
+		ret = request_threaded_irq(max98095->irq, NULL,
+			max98095_jack_handler,
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"max98095", codec);
+		if (ret) {
+			dev_err(codec->dev, "Failed to request IRQ: %d\n", ret);
+			goto err_access;
+		}
+	}
+
 	ret = snd_soc_read(codec, M98095_0FF_REV_ID);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failure reading hardware revision: %d\n",
 			ret);
-		goto err_access;
+		goto err_irq;
 	}
 	dev_info(codec->dev, "Hardware revision: %c\n", ret - 0x40 + 'A');
 
@@ -2306,14 +2456,27 @@ static int max98095_probe(struct snd_soc_codec *codec)
 
 	max98095_add_widgets(codec);
 
+	return 0;
+
+err_irq:
+	if (max98095->irq)
+		free_irq(max98095->irq, codec);
 err_access:
 	return ret;
 }
 
 static int max98095_remove(struct snd_soc_codec *codec)
 {
+	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
+
 	max98095_set_bias_level(codec, SND_SOC_BIAS_OFF);
 
+	if (max98095->headphone_jack || max98095->mic_jack)
+		max98095_jack_detect_disable(codec);
+
+	if (max98095->irq)
+		free_irq(max98095->irq, codec);
+
 	return 0;
 }
 
@@ -2348,6 +2511,7 @@ static int max98095_i2c_probe(struct i2c_client *i2c,
 	max98095->devtype = id->driver_data;
 	i2c_set_clientdata(i2c, max98095);
 	max98095->pdata = i2c->dev.platform_data;
+	max98095->irq = i2c->irq;
 
 	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_max98095,
 				     max98095_dai, ARRAY_SIZE(max98095_dai));
diff --git a/sound/soc/codecs/max98095.h b/sound/soc/codecs/max98095.h
index 891584a..2ebbe4e 100644
--- a/sound/soc/codecs/max98095.h
+++ b/sound/soc/codecs/max98095.h
@@ -175,11 +175,23 @@
 
 /* MAX98095 Registers Bit Fields */
 
+/* M98095_007_JACK_AUTO_STS */
+	#define M98095_MIC_IN			(1<<3)
+	#define M98095_LO_IN			(1<<5)
+	#define M98095_HP_IN			(1<<6)
+	#define M98095_DDONE			(1<<7)
+
 /* M98095_00F_HOST_CFG */
 	#define M98095_SEG                      (1<<0)
 	#define M98095_XTEN                     (1<<1)
 	#define M98095_MDLLEN                   (1<<2)
 
+/* M98095_013_JACK_INT_EN */
+	#define M98095_IMIC_IN			(1<<3)
+	#define M98095_ILO_IN			(1<<5)
+	#define M98095_IHP_IN			(1<<6)
+	#define M98095_IDDONE			(1<<7)
+
 /* M98095_027_DAI1_CLKMODE, M98095_031_DAI2_CLKMODE, M98095_03B_DAI3_CLKMODE */
 	#define M98095_CLKMODE_MASK             0xFF
 
@@ -255,6 +267,10 @@
 	#define M98095_EQ2EN                    (1<<1)
 	#define M98095_EQ1EN                    (1<<0)
 
+/* M98095_089_JACK_DET_AUTO */
+	#define M98095_PIN5EN			(1<<2)
+	#define M98095_JDEN			(1<<7)
+
 /* M98095_090_PWR_EN_IN */
 	#define M98095_INEN                     (1<<7)
 	#define M98095_MB2EN                    (1<<3)
@@ -296,4 +312,10 @@
 #define M98095_174_DAI1_BQ_BASE             0x74
 #define M98095_17E_DAI2_BQ_BASE             0x7E
 
+/* Default Delay used in Slew Rate Calculation for Jack detection */
+#define M98095_DEFAULT_SLEW_DELAY		0x18
+
+extern int max98095_jack_detect(struct snd_soc_codec *codec,
+	struct snd_soc_jack *hp_jack, struct snd_soc_jack *mic_jack);
+
 #endif
-- 
1.7.3.4

