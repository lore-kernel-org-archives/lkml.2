Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1LWXOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 18:14:20 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36062 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab1LWXOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 18:14:16 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 2/4] ASoC: cx20442: add bias control over a platform provided regulator
Date: Sat, 24 Dec 2011 00:12:22 +0100
Message-Id: <1324681944-19067-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
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
and the new (the codec) implementations will coexist smoothly until the
sound card file is updated.

While extending the cx20442 structure, drop unused control_type member.

Created against linxu-3.2-rc6, tested on top of patch 1/4 "ARM: OMAP1:
ams-delta: set up regulator over modem reset GPIO pin".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 sound/soc/codecs/cx20442.c |   58 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cx20442.c b/sound/soc/codecs/cx20442.c
index bc7067d..d159c23 100644
--- a/sound/soc/codecs/cx20442.c
+++ b/sound/soc/codecs/cx20442.c
@@ -16,6 +16,7 @@
 #include <linux/tty.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/regulator/consumer.h>
 
 #include <sound/core.h>
 #include <sound/initval.h>
@@ -25,8 +26,12 @@
 
 
 struct cx20442_priv {
-	enum snd_soc_control_type control_type;
 	void *control_data;
+	struct {
+		struct mutex lock;
+		struct regulator *regulator;
+		bool enabled;
+	} por;
 };
 
 #define CX20442_PM		0x0
@@ -324,6 +329,41 @@ static struct snd_soc_dai_driver cx20442_dai = {
 	},
 };
 
+static int cx20442_set_bias_level(struct snd_soc_codec *codec,
+		enum snd_soc_bias_level level)
+{
+	struct cx20442_priv *cx20442 = snd_soc_codec_get_drvdata(codec);
+	int err = 0;
+
+	mutex_lock(&cx20442->por.lock);
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+	case SND_SOC_BIAS_PREPARE:
+		if (IS_ERR(cx20442->por.regulator)) {
+			err = PTR_ERR(cx20442->por.regulator);
+		} else if (!cx20442->por.enabled) {
+			err = regulator_enable(cx20442->por.regulator);
+			if (!err)
+				cx20442->por.enabled = true;
+		}
+		break;
+	case SND_SOC_BIAS_STANDBY:
+	case SND_SOC_BIAS_OFF:
+		if (IS_ERR(cx20442->por.regulator)) {
+			err = PTR_ERR(cx20442->por.regulator);
+		} else if (cx20442->por.enabled) {
+			err = regulator_disable(cx20442->por.regulator);
+			if (!err)
+				cx20442->por.enabled = false;
+		}
+	}
+	mutex_unlock(&cx20442->por.lock);
+	if (!err)
+		codec->dapm.bias_level = level;
+
+	return err;
+}
+
 static int cx20442_codec_probe(struct snd_soc_codec *codec)
 {
 	struct cx20442_priv *cx20442;
@@ -331,9 +371,12 @@ static int cx20442_codec_probe(struct snd_soc_codec *codec)
 	cx20442 = kzalloc(sizeof(struct cx20442_priv), GFP_KERNEL);
 	if (cx20442 == NULL)
 		return -ENOMEM;
-	snd_soc_codec_set_drvdata(codec, cx20442);
 
+	mutex_init(&cx20442->por.lock);
+	cx20442->por.regulator = regulator_get(codec->dev, "POR");
 	cx20442->control_data = NULL;
+
+	snd_soc_codec_set_drvdata(codec, cx20442);
 	codec->hw_write = NULL;
 	codec->card->pop_time = 0;
 
@@ -350,6 +393,16 @@ static int cx20442_codec_remove(struct snd_soc_codec *codec)
 			tty_hangup(tty);
 	}
 
+	mutex_lock(&cx20442->por.lock);
+	if (!IS_ERR(cx20442->por.regulator)) {
+		if (cx20442->por.enabled)
+			regulator_disable(cx20442->por.regulator);
+		regulator_put(cx20442->por.regulator);
+		cx20442->por.regulator = ERR_PTR(-ENODEV);
+	}
+	mutex_unlock(&cx20442->por.lock);
+
+	snd_soc_codec_set_drvdata(codec, NULL);
 	kfree(cx20442);
 	return 0;
 }
@@ -359,6 +412,7 @@ static const u8 cx20442_reg;
 static struct snd_soc_codec_driver cx20442_codec_dev = {
 	.probe = 	cx20442_codec_probe,
 	.remove = 	cx20442_codec_remove,
+	.set_bias_level = cx20442_set_bias_level,
 	.reg_cache_default = &cx20442_reg,
 	.reg_cache_size = 1,
 	.reg_word_size = sizeof(u8),
-- 
1.7.3.4

