Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1L3DHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 22:07:47 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50857 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab1L3DHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 22:07:37 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v2 2/4] ASoC: cx20442: add bias control over a platform provided regulator
Date: Fri, 30 Dec 2011 04:04:54 +0100
Message-Id: <1325214296-2888-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that a regulator device for controlling the codec chip reset state
over a platform agnostic regulator API is available on the only board
using this driver so far, extend the driver with a bias control function
which will request virtual power to the codec chip from that virtual
regulator, and will supersede the present implementation existing at the
sound card level.

Thanks to the regulator sharing mechanism, both the old (the sound card)
and the new (the codec) implementations should coexist smoothly until
the sound card file is updated. For this to work as expected, update the
sound card .set_bias_level callback to not touch codec->dapm.bias_level.

While extending the cx20442 structure, drop unused control_type member.

Created against linxu-3.2-rc6, tested on top of patch 1/4 "ARM: OMAP1:
ams-delta: set up a regulator over the modem reset GPIO pin".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Changes against initial version:
* don't track the regulator enable/disable state, compare new bias
  level against the old one instead; thanks to Mark Brown for suggesting
  this change,
* update the Amstrad Delta sound card file to not touch the codec bias
  level for the above change to work as expected,
* display a warning if getting the regulator fails.
  
 sound/soc/codecs/cx20442.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
 sound/soc/omap/ams-delta.c |    8 ++----
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/cx20442.c b/sound/soc/codecs/cx20442.c
index bc7067d..941c527 100644
--- a/sound/soc/codecs/cx20442.c
+++ b/sound/soc/codecs/cx20442.c
@@ -16,6 +16,7 @@
 #include <linux/tty.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/regulator/consumer.h>
 
 #include <sound/core.h>
 #include <sound/initval.h>
@@ -25,8 +26,8 @@
 
 
 struct cx20442_priv {
-	enum snd_soc_control_type control_type;
 	void *control_data;
+	struct regulator *por;
 };
 
 #define CX20442_PM		0x0
@@ -324,6 +325,38 @@ static struct snd_soc_dai_driver cx20442_dai = {
 	},
 };
 
+static int cx20442_set_bias_level(struct snd_soc_codec *codec,
+		enum snd_soc_bias_level level)
+{
+	struct cx20442_priv *cx20442 = snd_soc_codec_get_drvdata(codec);
+	int err = 0;
+
+	switch (level) {
+	case SND_SOC_BIAS_PREPARE:
+		if (codec->dapm.bias_level != SND_SOC_BIAS_STANDBY)
+			break;
+		if (IS_ERR(cx20442->por))
+			err = PTR_ERR(cx20442->por);
+		else
+			err = regulator_enable(cx20442->por);
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		if (codec->dapm.bias_level != SND_SOC_BIAS_PREPARE)
+			break;
+		if (IS_ERR(cx20442->por))
+			err = PTR_ERR(cx20442->por);
+		else
+			err = regulator_disable(cx20442->por);
+		break;
+	default:
+		break;
+	}
+	if (!err)
+		codec->dapm.bias_level = level;
+
+	return err;
+}
+
 static int cx20442_codec_probe(struct snd_soc_codec *codec)
 {
 	struct cx20442_priv *cx20442;
@@ -331,9 +364,13 @@ static int cx20442_codec_probe(struct snd_soc_codec *codec)
 	cx20442 = kzalloc(sizeof(struct cx20442_priv), GFP_KERNEL);
 	if (cx20442 == NULL)
 		return -ENOMEM;
-	snd_soc_codec_set_drvdata(codec, cx20442);
 
+	cx20442->por = regulator_get(codec->dev, "POR");
+	if (IS_ERR(cx20442->por))
+		dev_warn(codec->dev, "failed to get the regulator");
 	cx20442->control_data = NULL;
+
+	snd_soc_codec_set_drvdata(codec, cx20442);
 	codec->hw_write = NULL;
 	codec->card->pop_time = 0;
 
@@ -350,6 +387,12 @@ static int cx20442_codec_remove(struct snd_soc_codec *codec)
 			tty_hangup(tty);
 	}
 
+	if (!IS_ERR(cx20442->por)) {
+		/* should be already in STANDBY, hence disabled */
+		regulator_put(cx20442->por);
+	}
+
+	snd_soc_codec_set_drvdata(codec, NULL);
 	kfree(cx20442);
 	return 0;
 }
@@ -359,6 +402,7 @@ static const u8 cx20442_reg;
 static struct snd_soc_codec_driver cx20442_codec_dev = {
 	.probe = 	cx20442_codec_probe,
 	.remove = 	cx20442_codec_remove,
+	.set_bias_level = cx20442_set_bias_level,
 	.reg_cache_default = &cx20442_reg,
 	.reg_cache_size = 1,
 	.reg_word_size = sizeof(u8),
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index be81bc7..0462c7e 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -431,22 +431,20 @@ static int ams_delta_set_bias_level(struct snd_soc_card *card,
 				    struct snd_soc_dapm_context *dapm,
 				    enum snd_soc_bias_level level)
 {
-	struct snd_soc_codec *codec = card->rtd->codec;
-
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 	case SND_SOC_BIAS_PREPARE:
 	case SND_SOC_BIAS_STANDBY:
-		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
+		if (card->dapm.bias_level == SND_SOC_BIAS_OFF)
 			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
 						AMS_DELTA_LATCH2_MODEM_NRESET);
 		break;
 	case SND_SOC_BIAS_OFF:
-		if (codec->dapm.bias_level != SND_SOC_BIAS_OFF)
+		if (card->dapm.bias_level != SND_SOC_BIAS_OFF)
 			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
 						0);
 	}
-	codec->dapm.bias_level = level;
+	card->dapm.bias_level = level;
 
 	return 0;
 }
-- 
1.7.3.4

