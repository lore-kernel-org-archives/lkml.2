Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2IJKsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:48:52 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:42968 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757276Ab2IJKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/14] ASoC: twl4030: Move hs_extmute GPIO handling to driver
Date: Mon, 10 Sep 2012 13:46:27 +0300
Message-Id: <1347273992-9107-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The external mute (if it is in use) is handled by a GPIO line. Prepare to
remove the set_hs_extmute callback and replace it with:
hs_extmute_gpio: the GPIO number to use for external mute

When the users of set_hs_extmute has been converted the callback can be removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/i2c/twl.h    |  4 +++-
 sound/soc/codecs/twl4030.c | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index ac6488c..2040309 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -667,7 +667,9 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
-	void (*set_hs_extmute)(int mute);
+	void (*set_hs_extmute)(int mute); /* Deprecated, use hs_extmute_gpio and
+					     hs_extmute_disable_level */
+	int hs_extmute_gpio;
 };
 
 struct twl4030_vibra_data {
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 391fcfc..5fc271a 100644
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
@@ -302,6 +303,22 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	u8 reg, byte;
 	int i = 0;
 
+	if (pdata && pdata->hs_extmute &&
+	    gpio_is_valid(pdata->hs_extmute_gpio)) {
+		int ret;
+
+		if (!pdata->hs_extmute_gpio)
+			dev_warn(codec->dev,
+				 "Extmute GPIO is 0 is this correct?\n");
+
+		ret = gpio_request_one(pdata->hs_extmute_gpio,
+				       GPIOF_OUT_INIT_LOW, "hs_extmute");
+		if (ret) {
+			dev_err(codec->dev, "Failed to get hs_extmute GPIO\n");
+			pdata->hs_extmute_gpio = -1;
+		}
+	}
+
 	/* Check defaults, if instructed before anything else */
 	if (pdata && pdata->check_defaults)
 		twl4030_check_defaults(codec);
@@ -748,7 +765,10 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 	/* Enable external mute control, this dramatically reduces
 	 * the pop-noise */
 	if (pdata && pdata->hs_extmute) {
-		if (pdata->set_hs_extmute) {
+		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
+			gpio_set_value(pdata->hs_extmute_gpio, 1);
+		} else if (pdata->set_hs_extmute) {
+			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
 			pdata->set_hs_extmute(1);
 		} else {
 			hs_pop |= TWL4030_EXTMUTE;
@@ -786,7 +806,10 @@ static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 
 	/* Disable external mute */
 	if (pdata && pdata->hs_extmute) {
-		if (pdata->set_hs_extmute) {
+		if (gpio_is_valid(pdata->hs_extmute_gpio)) {
+			gpio_set_value(pdata->hs_extmute_gpio, 0);
+		} else if (pdata->set_hs_extmute) {
+			dev_warn(codec->dev, "set_hs_extmute is deprecated\n");
 			pdata->set_hs_extmute(0);
 		} else {
 			hs_pop &= ~TWL4030_EXTMUTE;
@@ -2230,12 +2253,17 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 
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
1.7.12

