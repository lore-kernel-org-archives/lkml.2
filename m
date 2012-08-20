Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2HTLej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:34:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44326 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2HTLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:34:36 -0400
Date: Mon, 20 Aug 2012 12:34:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Subject: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120820113427.GN8450@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
 <s5h628lu0q9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h628lu0q9.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Fri, 27 Jul 2012 08:50:05 +0100
Subject: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree

We continue to allow the AB8500 CODEC to be registered via the AB8500
Multi Functional Device API, only this time we extract its configuration
from the Device Tree binary.

CC: alsa-devel@alsa-project.org
Acked-by: Ola Lilja <ola.o.lilja@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/abx500/ab8500-codec.h |    6 ++-
 sound/soc/codecs/ab8500-codec.c         |   81 +++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/abx500/ab8500-codec.h b/include/linux/mfd/abx500/ab8500-codec.h
index dc65292..d707941 100644
--- a/include/linux/mfd/abx500/ab8500-codec.h
+++ b/include/linux/mfd/abx500/ab8500-codec.h
@@ -23,7 +23,8 @@ enum amic_type {
 /* Mic-biases */
 enum amic_micbias {
 	AMIC_MICBIAS_VAMIC1,
-	AMIC_MICBIAS_VAMIC2
+	AMIC_MICBIAS_VAMIC2,
+	AMIC_MICBIAS_UNKNOWN
 };
 
 /* Bias-voltage */
@@ -31,7 +32,8 @@ enum ear_cm_voltage {
 	EAR_CMV_0_95V,
 	EAR_CMV_1_10V,
 	EAR_CMV_1_27V,
-	EAR_CMV_1_58V
+	EAR_CMV_1_58V,
+	EAR_CMV_UNKNOWN
 };
 
 /* Analog microphone settings */
diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 23b4018..99dffcf 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -34,6 +34,7 @@
 #include <linux/mfd/abx500/ab8500-sysctrl.h>
 #include <linux/mfd/abx500/ab8500-codec.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -2394,9 +2395,65 @@ struct snd_soc_dai_driver ab8500_codec_dai[] = {
 	}
 };
 
+static void ab8500_codec_of_probe(struct device *dev, struct device_node *np,
+				struct ab8500_codec_platform_data *codec)
+{
+	u32 value;
+
+	if (of_get_property(np, "stericsson,amic1-type-single-ended", NULL))
+		codec->amics.mic1_type = AMIC_TYPE_SINGLE_ENDED;
+	else
+		codec->amics.mic1_type = AMIC_TYPE_DIFFERENTIAL;
+
+	if (of_get_property(np, "stericsson,amic2-type-single-ended", NULL))
+		codec->amics.mic2_type = AMIC_TYPE_SINGLE_ENDED;
+	else
+		codec->amics.mic2_type = AMIC_TYPE_DIFFERENTIAL;
+
+	/* Has a non-standard Vamic been requested? */
+	if (of_get_property(np, "stericsson,amic1a-bias-vamic2", NULL))
+		codec->amics.mic1a_micbias = AMIC_MICBIAS_VAMIC2;
+	else
+		codec->amics.mic1a_micbias = AMIC_MICBIAS_VAMIC1;
+
+	if (of_get_property(np, "stericsson,amic1b-bias-vamic2", NULL))
+		codec->amics.mic1b_micbias = AMIC_MICBIAS_VAMIC2;
+	else
+		codec->amics.mic1b_micbias = AMIC_MICBIAS_VAMIC1;
+
+	if (of_get_property(np, "stericsson,amic2-bias-vamic1", NULL))
+		codec->amics.mic2_micbias = AMIC_MICBIAS_VAMIC1;
+	else
+		codec->amics.mic2_micbias = AMIC_MICBIAS_VAMIC2;
+
+	if (!of_property_read_u32(np, "stericsson,earpeice-cmv", &value)) {
+		switch (value) {
+		case 950 :
+			codec->ear_cmv = EAR_CMV_0_95V;
+			break;
+		case 1100 :
+			codec->ear_cmv = EAR_CMV_1_10V;
+			break;
+		case 1270 :
+			codec->ear_cmv = EAR_CMV_1_27V;
+			break;
+		case 1580 :
+			codec->ear_cmv = EAR_CMV_1_58V;
+			break;
+		default :
+			codec->ear_cmv = EAR_CMV_UNKNOWN;
+			dev_err(dev, "Unsuitable earpiece voltage found in DT\n");
+		}
+	} else {
+		dev_warn(dev, "No earpiece voltage found in DT - using default\n");
+		codec->ear_cmv = EAR_CMV_0_95V;
+	}
+}
+
 static int ab8500_codec_probe(struct snd_soc_codec *codec)
 {
 	struct device *dev = codec->dev;
+	struct device_node *np = dev->of_node;
 	struct ab8500_codec_drvdata *drvdata = dev_get_drvdata(dev);
 	struct ab8500_platform_data *pdata;
 	struct filter_control *fc;
@@ -2407,6 +2464,30 @@ static int ab8500_codec_probe(struct snd_soc_codec *codec)
 	/* Setup AB8500 according to board-settings */
 	pdata = (struct ab8500_platform_data *)dev_get_platdata(dev->parent);
 
+	if (np) {
+		if (!pdata)
+			pdata = devm_kzalloc(dev,
+					sizeof(struct ab8500_platform_data),
+					GFP_KERNEL);
+
+		if (pdata && !pdata->codec)
+			pdata->codec
+				= devm_kzalloc(dev,
+					sizeof(struct ab8500_codec_platform_data),
+					GFP_KERNEL);
+
+		if (!(pdata && pdata->codec))
+			return -ENOMEM;
+
+		ab8500_codec_of_probe(dev, np, pdata->codec);
+
+	} else {
+		if (!(pdata && pdata->codec)) {
+			dev_err(dev, "No codec platform data or DT found\n");
+			return -EINVAL;
+		}
+	}
+
 	/* Inform SoC Core that we have our own I/O arrangements. */
 	codec->control_data = (void *)true;
 
-- 
1.7.9.5
