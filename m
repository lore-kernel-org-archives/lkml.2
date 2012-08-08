Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290Ab2HHJmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:42:09 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:36455 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030232Ab2HHJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:42:00 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 06/11] ASoC: twl4030: Move hs_extmute GPIO handling to driver
Date: Wed,  8 Aug 2012 12:41:22 +0300
Message-Id: <1344418887-5262-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The external mute (if it is in use) is handled by a GPIO line. Prepare to
remove the set_hs_extmute callback and replace it with two sets of platform
data:
hs_extmute_gpio: the GPIO number to use for external mute
hs_extmute_disable_level: the GPIO level to use when the external mute is
not enabled.

The codec driver can handle the external mute functionality based on these
parameters and when the users of set_hs_extmute has been converted the
callback can be removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    |    6 +++++-
 sound/soc/codecs/twl4030.c |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 7ea898c..75ce6d1 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -666,7 +666,11 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
-	void (*set_hs_extmute)(int mute);
+	void (*set_hs_extmute)(int mute); /* Deprecated, use hs_extmute_gpio and
+					     hs_extmute_disable_level */
+	int hs_extmute_gpio;
+	unsigned int hs_extmute_disable_level:1; /* the GPIO state to disable
+						    the extmute */
 };
 
 struct twl4030_vibra_data {
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 391fcfc..0630040 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -302,6 +303,24 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	u8 reg, byte;
 	int i = 0;
 
+	if (pdata && pdata->hs_extmute &&
+	    gpio_is_valid(pdata->hs_extmute_gpio)) {
+		int ret, level;
+
+		if (!pdata->hs_extmute_gpio)
+			dev_warn(codec->dev,
+				 "Extmute GPIO is 0 is this correct?\n");
+
+		level = pdata->hs_extmute_disable_level;
+		ret = gpio_request_one(pdata->hs_extmute_gpio, level ?
+				       GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
+				       "hs_extmute");
+		if (ret) {
+			dev_err(codec->dev, "Failed to get hs_extmute GPIO\n");
+			pdata->hs_extmute_gpio = -1;
+		}
+	}
+
 	/* Check defaults, if instructed before anything else */
 	if (pdata && pdata->check_defaults)
 		twl4030_check_defaults(codec);
@@ -748,7 +767,11 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 	/* Enable external mute control, this dramatically reduces
 	 * the pop-noise */
 	if (pdata && pdata->hs_extmute) {
-		if (pdata->set_hs_extmute) {
+		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
+			gpio_set_value(pdata->hs_extmute_gpio,
+				       !pdata->hs_extmute_disable_level);
+		} else if (pdata->set_hs_extmute) {
+			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
 			pdata->set_hs_extmute(1);
 		} else {
 			hs_pop |= TWL4030_EXTMUTE;
@@ -786,7 +809,11 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 
 	/* Disable external mute */
 	if (pdata && pdata->hs_extmute) {
-		if (pdata->set_hs_extmute) {
+		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
+			gpio_set_value(pdata->hs_extmute_gpio,
+				       pdata->hs_extmute_disable_level);
+		} else if (pdata->set_hs_extmute) {
+			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
 			pdata->set_hs_extmute(0);
 		} else {
 			hs_pop &= ~TWL4030_EXTMUTE;
@@ -2230,12 +2257,17 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 
 static int twl4030_soc_remove(struct snd_soc_codec *codec)
 {
+	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 
 	/* Reset registers to their chip default before leaving */
 	twl4030_reset_registers(codec);
 	twl4030_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	kfree(twl4030);
+
+	if (pdata && pdata->hs_extmute && gpio_is_valid(pdata->hs_extmute_gpio))
+		gpio_free(pdata->hs_extmute_gpio);
+
 	return 0;
 }
 
-- 
1.7.8.6

