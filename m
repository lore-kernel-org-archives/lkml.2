Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1FUOkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:40:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48256 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1FUOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:57 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH v6 06/18] MFD: twl4030-codec -> twl4030-audio: Rename the driver
Date: Tue, 21 Jun 2011 16:39:04 +0300
Message-ID: <1308663556-29120-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the driver, and header file from twl4030-codec to
twl4030-audio.
To avoid breakage change depending drivers at the same time.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Misael Lopez Cruz <misael.lopez@ti.com>
---
 drivers/input/misc/Kconfig                         |    2 +-
 drivers/input/misc/twl4030-vibra.c                 |   10 +++---
 drivers/mfd/Kconfig                                |    2 +-
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/{twl4030-codec.c => twl4030-audio.c}   |   33 +++++++++----------
 .../linux/mfd/{twl4030-codec.h => twl4030-audio.h} |   16 +++++-----
 sound/soc/codecs/Kconfig                           |    2 +-
 sound/soc/codecs/twl4030.c                         |   16 +++++-----
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/zoom2.c                             |    2 +-
 10 files changed, 43 insertions(+), 44 deletions(-)
 rename drivers/mfd/{twl4030-codec.c => twl4030-audio.c} (87%)
 rename include/linux/mfd/{twl4030-codec.h => twl4030-audio.h} (96%)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 45dc6aa..077309a 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -267,7 +267,7 @@ config INPUT_TWL4030_PWRBUTTON
 config INPUT_TWL4030_VIBRA
 	tristate "Support for TWL4030 Vibrator"
 	depends on TWL4030_CORE
-	select TWL4030_CODEC
+	select MFD_TWL4030_AUDIO
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables support for TWL4030 Vibrator Driver.
diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 014dd4a..7abca85 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -28,7 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 #include <linux/i2c/twl.h>
-#include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/twl4030-audio.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 
@@ -67,7 +67,7 @@ static void vibra_enable(struct vibra_info *info)
 {
 	u8 reg;
 
-	twl4030_codec_enable_resource(TWL4030_CODEC_RES_POWER);
+	twl4030_audio_enable_resource(TWL4030_AUDIO_RES_POWER);
 
 	/* turn H-Bridge on */
 	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE,
@@ -75,7 +75,7 @@ static void vibra_enable(struct vibra_info *info)
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 			 (reg | TWL4030_VIBRA_EN), TWL4030_REG_VIBRA_CTL);
 
-	twl4030_codec_enable_resource(TWL4030_CODEC_RES_APLL);
+	twl4030_audio_enable_resource(TWL4030_AUDIO_RES_APLL);
 
 	info->enabled = true;
 }
@@ -90,8 +90,8 @@ static void vibra_disable(struct vibra_info *info)
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 			 (reg & ~TWL4030_VIBRA_EN), TWL4030_REG_VIBRA_CTL);
 
-	twl4030_codec_disable_resource(TWL4030_CODEC_RES_APLL);
-	twl4030_codec_disable_resource(TWL4030_CODEC_RES_POWER);
+	twl4030_audio_disable_resource(TWL4030_AUDIO_RES_APLL);
+	twl4030_audio_disable_resource(TWL4030_AUDIO_RES_POWER);
 
 	info->enabled = false;
 }
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 519ebab..30f3536 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -240,7 +240,7 @@ config TWL4030_POWER
 	  and load scripts controlling which resources are switched off/on
 	  or reset when a sleep, wakeup or warm reset event occurs.
 
-config TWL4030_CODEC
+config MFD_TWL4030_AUDIO
 	bool
 	depends on TWL4030_CORE
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5309ec3..77cb99a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_MENELAUS)		+= menelaus.o
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
-obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
+obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
 obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-audio.c
similarity index 87%
rename from drivers/mfd/twl4030-codec.c
rename to drivers/mfd/twl4030-audio.c
index e1782b3..5cdf841 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -30,7 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c/twl.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/twl4030-audio.h>
 
 #define TWL4030_AUDIO_CELLS	2
 
@@ -45,7 +45,7 @@ struct twl4030_audio_resource {
 struct twl4030_audio {
 	unsigned int audio_mclk;
 	struct mutex mutex;
-	struct twl4030_audio_resource resource[TWL4030_CODEC_RES_MAX];
+	struct twl4030_audio_resource resource[TWL4030_AUDIO_RES_MAX];
 	struct mfd_cell cells[TWL4030_AUDIO_CELLS];
 };
 
@@ -53,7 +53,7 @@ struct twl4030_audio {
  * Modify the resource, the function returns the content of the register
  * after the modification.
  */
-static int twl4030_audio_set_resource(enum twl4030_codec_res id, int enable)
+static int twl4030_audio_set_resource(enum twl4030_audio_res id, int enable)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	u8 val;
@@ -72,7 +72,7 @@ static int twl4030_audio_set_resource(enum twl4030_codec_res id, int enable)
 	return val;
 }
 
-static inline int twl4030_audio_get_resource(enum twl4030_codec_res id)
+static inline int twl4030_audio_get_resource(enum twl4030_audio_res id)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	u8 val;
@@ -87,12 +87,12 @@ static inline int twl4030_audio_get_resource(enum twl4030_codec_res id)
  * Enable the resource.
  * The function returns with error or the content of the register
  */
-int twl4030_codec_enable_resource(enum twl4030_codec_res id)
+int twl4030_audio_enable_resource(enum twl4030_audio_res id)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	int val;
 
-	if (id >= TWL4030_CODEC_RES_MAX) {
+	if (id >= TWL4030_AUDIO_RES_MAX) {
 		dev_err(&twl4030_audio_dev->dev,
 				"Invalid resource ID (%u)\n", id);
 		return -EINVAL;
@@ -110,18 +110,18 @@ int twl4030_codec_enable_resource(enum twl4030_codec_res id)
 
 	return val;
 }
-EXPORT_SYMBOL_GPL(twl4030_codec_enable_resource);
+EXPORT_SYMBOL_GPL(twl4030_audio_enable_resource);
 
 /*
  * Disable the resource.
  * The function returns with error or the content of the register
  */
-int twl4030_codec_disable_resource(unsigned id)
+int twl4030_audio_disable_resource(unsigned id)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	int val;
 
-	if (id >= TWL4030_CODEC_RES_MAX) {
+	if (id >= TWL4030_AUDIO_RES_MAX) {
 		dev_err(&twl4030_audio_dev->dev,
 				"Invalid resource ID (%u)\n", id);
 		return -EINVAL;
@@ -146,15 +146,15 @@ int twl4030_codec_disable_resource(unsigned id)
 
 	return val;
 }
-EXPORT_SYMBOL_GPL(twl4030_codec_disable_resource);
+EXPORT_SYMBOL_GPL(twl4030_audio_disable_resource);
 
-unsigned int twl4030_codec_get_mclk(void)
+unsigned int twl4030_audio_get_mclk(void)
 {
 	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 
 	return audio->audio_mclk;
 }
-EXPORT_SYMBOL_GPL(twl4030_codec_get_mclk);
+EXPORT_SYMBOL_GPL(twl4030_audio_get_mclk);
 
 static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 {
@@ -199,12 +199,12 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 	audio->audio_mclk = pdata->audio_mclk;
 
 	/* Codec power */
-	audio->resource[TWL4030_CODEC_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
-	audio->resource[TWL4030_CODEC_RES_POWER].mask = TWL4030_CODECPDZ;
+	audio->resource[TWL4030_AUDIO_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
+	audio->resource[TWL4030_AUDIO_RES_POWER].mask = TWL4030_CODECPDZ;
 
 	/* PLL */
-	audio->resource[TWL4030_CODEC_RES_APLL].reg = TWL4030_REG_APLL_CTL;
-	audio->resource[TWL4030_CODEC_RES_APLL].mask = TWL4030_APLL_EN;
+	audio->resource[TWL4030_AUDIO_RES_APLL].reg = TWL4030_REG_APLL_CTL;
+	audio->resource[TWL4030_AUDIO_RES_APLL].mask = TWL4030_APLL_EN;
 
 	if (pdata->audio) {
 		cell = &audio->cells[childs];
@@ -275,4 +275,3 @@ module_exit(twl4030_audio_exit);
 
 MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
 MODULE_LICENSE("GPL");
-
diff --git a/include/linux/mfd/twl4030-codec.h b/include/linux/mfd/twl4030-audio.h
similarity index 96%
rename from include/linux/mfd/twl4030-codec.h
rename to include/linux/mfd/twl4030-audio.h
index 5cc16bb..3d22b72 100644
--- a/include/linux/mfd/twl4030-codec.h
+++ b/include/linux/mfd/twl4030-audio.h
@@ -1,5 +1,5 @@
 /*
- * MFD driver for twl4030 codec submodule
+ * MFD driver for twl4030 audio submodule
  *
  * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
@@ -259,14 +259,14 @@
 #define TWL4030_VIBRA_DIR_SEL		0x20
 
 /* TWL4030 codec resource IDs */
-enum twl4030_codec_res {
-	TWL4030_CODEC_RES_POWER = 0,
-	TWL4030_CODEC_RES_APLL,
-	TWL4030_CODEC_RES_MAX,
+enum twl4030_audio_res {
+	TWL4030_AUDIO_RES_POWER = 0,
+	TWL4030_AUDIO_RES_APLL,
+	TWL4030_AUDIO_RES_MAX,
 };
 
-int twl4030_codec_disable_resource(enum twl4030_codec_res id);
-int twl4030_codec_enable_resource(enum twl4030_codec_res id);
-unsigned int twl4030_codec_get_mclk(void);
+int twl4030_audio_disable_resource(enum twl4030_audio_res id);
+int twl4030_audio_enable_resource(enum twl4030_audio_res id);
+unsigned int twl4030_audio_get_mclk(void);
 
 #endif	/* End of __TWL4030_CODEC_H__ */
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 98175a0..0002220 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -236,7 +236,7 @@ config SND_SOC_TLV320DAC33
 	tristate
 
 config SND_SOC_TWL4030
-	select TWL4030_CODEC
+	select MFD_TWL4030_AUDIO
 	tristate
 
 config SND_SOC_TWL6040
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index bec788b..5e648d3 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -36,7 +36,7 @@
 #include <sound/tlv.h>
 
 /* Register descriptions are here */
-#include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/twl4030-audio.h>
 
 /* Shadow register used by the audio driver */
 #define TWL4030_REG_SW_SHADOW		0x4A
@@ -251,9 +251,9 @@ static void twl4030_codec_enable(struct snd_soc_codec *codec, int enable)
 		return;
 
 	if (enable)
-		mode = twl4030_codec_enable_resource(TWL4030_CODEC_RES_POWER);
+		mode = twl4030_audio_enable_resource(TWL4030_AUDIO_RES_POWER);
 	else
-		mode = twl4030_codec_disable_resource(TWL4030_CODEC_RES_POWER);
+		mode = twl4030_audio_disable_resource(TWL4030_AUDIO_RES_POWER);
 
 	if (mode >= 0) {
 		twl4030_write_reg_cache(codec, TWL4030_REG_CODEC_MODE, mode);
@@ -375,13 +375,13 @@ static void twl4030_apll_enable(struct snd_soc_codec *codec, int enable)
 	if (enable) {
 		twl4030->apll_enabled++;
 		if (twl4030->apll_enabled == 1)
-			status = twl4030_codec_enable_resource(
-							TWL4030_CODEC_RES_APLL);
+			status = twl4030_audio_enable_resource(
+							TWL4030_AUDIO_RES_APLL);
 	} else {
 		twl4030->apll_enabled--;
 		if (!twl4030->apll_enabled)
-			status = twl4030_codec_disable_resource(
-							TWL4030_CODEC_RES_APLL);
+			status = twl4030_audio_disable_resource(
+							TWL4030_AUDIO_RES_APLL);
 	}
 
 	if (status >= 0)
@@ -2260,7 +2260,7 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 	}
 	snd_soc_codec_set_drvdata(codec, twl4030);
 	/* Set the defaults, and power up the codec */
-	twl4030->sysclk = twl4030_codec_get_mclk() / 1000;
+	twl4030->sysclk = twl4030_audio_get_mclk() / 1000;
 	codec->dapm.idle_bias_off = 1;
 
 	twl4030_init_chip(codec);
diff --git a/sound/soc/omap/sdp3430.c b/sound/soc/omap/sdp3430.c
index 3f72d17..9f6a758 100644
--- a/sound/soc/omap/sdp3430.c
+++ b/sound/soc/omap/sdp3430.c
@@ -36,7 +36,7 @@
 #include <plat/mcbsp.h>
 
 /* Register descriptions for twl4030 codec part */
-#include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/twl4030-audio.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
index 0170994..9a2666f 100644
--- a/sound/soc/omap/zoom2.c
+++ b/sound/soc/omap/zoom2.c
@@ -32,7 +32,7 @@
 #include <plat/mcbsp.h>
 
 /* Register descriptions for twl4030 codec part */
-#include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/twl4030-audio.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
-- 
1.7.5.3

