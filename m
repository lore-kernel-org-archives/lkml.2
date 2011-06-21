Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1FUOnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:43:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51977 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1FUOjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:53 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 05/18] MFD: twl4030-codec: Rename internals from codec to audio
Date: Tue, 21 Jun 2011 16:39:03 +0300
Message-ID: <1308663556-29120-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of renaming the driver from twl4030-codec
to twl4030-audio, first do some clean ups in the driver,
which does not cause any problems outside.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-codec.c |  135 ++++++++++++++++++++++---------------------
 1 files changed, 68 insertions(+), 67 deletions(-)

diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 2bf4136..e1782b3 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -1,5 +1,6 @@
 /*
- * MFD driver for twl4030 codec submodule
+ * MFD driver for twl4030 audio submodule, which contains an audio codec, and
+ * the vibra control.
  *
  * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
@@ -31,53 +32,53 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl4030-codec.h>
 
-#define TWL4030_CODEC_CELLS	2
+#define TWL4030_AUDIO_CELLS	2
 
-static struct platform_device *twl4030_codec_dev;
+static struct platform_device *twl4030_audio_dev;
 
-struct twl4030_codec_resource {
+struct twl4030_audio_resource {
 	int request_count;
 	u8 reg;
 	u8 mask;
 };
 
-struct twl4030_codec {
+struct twl4030_audio {
 	unsigned int audio_mclk;
 	struct mutex mutex;
-	struct twl4030_codec_resource resource[TWL4030_CODEC_RES_MAX];
-	struct mfd_cell cells[TWL4030_CODEC_CELLS];
+	struct twl4030_audio_resource resource[TWL4030_CODEC_RES_MAX];
+	struct mfd_cell cells[TWL4030_AUDIO_CELLS];
 };
 
 /*
  * Modify the resource, the function returns the content of the register
  * after the modification.
  */
-static int twl4030_codec_set_resource(enum twl4030_codec_res id, int enable)
+static int twl4030_audio_set_resource(enum twl4030_codec_res id, int enable)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	u8 val;
 
 	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
-			codec->resource[id].reg);
+			audio->resource[id].reg);
 
 	if (enable)
-		val |= codec->resource[id].mask;
+		val |= audio->resource[id].mask;
 	else
-		val &= ~codec->resource[id].mask;
+		val &= ~audio->resource[id].mask;
 
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-					val, codec->resource[id].reg);
+					val, audio->resource[id].reg);
 
 	return val;
 }
 
-static inline int twl4030_codec_get_resource(enum twl4030_codec_res id)
+static inline int twl4030_audio_get_resource(enum twl4030_codec_res id)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	u8 val;
 
 	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
-			codec->resource[id].reg);
+			audio->resource[id].reg);
 
 	return val;
 }
@@ -88,24 +89,24 @@ static inline int twl4030_codec_get_resource(enum twl4030_codec_res id)
  */
 int twl4030_codec_enable_resource(enum twl4030_codec_res id)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	int val;
 
 	if (id >= TWL4030_CODEC_RES_MAX) {
-		dev_err(&twl4030_codec_dev->dev,
+		dev_err(&twl4030_audio_dev->dev,
 				"Invalid resource ID (%u)\n", id);
 		return -EINVAL;
 	}
 
-	mutex_lock(&codec->mutex);
-	if (!codec->resource[id].request_count)
+	mutex_lock(&audio->mutex);
+	if (!audio->resource[id].request_count)
 		/* Resource was disabled, enable it */
-		val = twl4030_codec_set_resource(id, 1);
+		val = twl4030_audio_set_resource(id, 1);
 	else
-		val = twl4030_codec_get_resource(id);
+		val = twl4030_audio_get_resource(id);
 
-	codec->resource[id].request_count++;
-	mutex_unlock(&codec->mutex);
+	audio->resource[id].request_count++;
+	mutex_unlock(&audio->mutex);
 
 	return val;
 }
@@ -117,31 +118,31 @@ EXPORT_SYMBOL_GPL(twl4030_codec_enable_resource);
  */
 int twl4030_codec_disable_resource(unsigned id)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 	int val;
 
 	if (id >= TWL4030_CODEC_RES_MAX) {
-		dev_err(&twl4030_codec_dev->dev,
+		dev_err(&twl4030_audio_dev->dev,
 				"Invalid resource ID (%u)\n", id);
 		return -EINVAL;
 	}
 
-	mutex_lock(&codec->mutex);
-	if (!codec->resource[id].request_count) {
-		dev_err(&twl4030_codec_dev->dev,
+	mutex_lock(&audio->mutex);
+	if (!audio->resource[id].request_count) {
+		dev_err(&twl4030_audio_dev->dev,
 			"Resource has been disabled already (%u)\n", id);
-		mutex_unlock(&codec->mutex);
+		mutex_unlock(&audio->mutex);
 		return -EPERM;
 	}
-	codec->resource[id].request_count--;
+	audio->resource[id].request_count--;
 
-	if (!codec->resource[id].request_count)
+	if (!audio->resource[id].request_count)
 		/* Resource can be disabled now */
-		val = twl4030_codec_set_resource(id, 0);
+		val = twl4030_audio_set_resource(id, 0);
 	else
-		val = twl4030_codec_get_resource(id);
+		val = twl4030_audio_get_resource(id);
 
-	mutex_unlock(&codec->mutex);
+	mutex_unlock(&audio->mutex);
 
 	return val;
 }
@@ -149,15 +150,15 @@ EXPORT_SYMBOL_GPL(twl4030_codec_disable_resource);
 
 unsigned int twl4030_codec_get_mclk(void)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	struct twl4030_audio *audio = platform_get_drvdata(twl4030_audio_dev);
 
-	return codec->audio_mclk;
+	return audio->audio_mclk;
 }
 EXPORT_SYMBOL_GPL(twl4030_codec_get_mclk);
 
-static int __devinit twl4030_codec_probe(struct platform_device *pdev)
+static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec *codec;
+	struct twl4030_audio *audio;
 	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
 	struct mfd_cell *cell = NULL;
 	int ret, childs = 0;
@@ -187,33 +188,33 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					val, TWL4030_REG_APLL_CTL);
 
-	codec = kzalloc(sizeof(struct twl4030_codec), GFP_KERNEL);
-	if (!codec)
+	audio = kzalloc(sizeof(struct twl4030_audio), GFP_KERNEL);
+	if (!audio)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, codec);
+	platform_set_drvdata(pdev, audio);
 
-	twl4030_codec_dev = pdev;
-	mutex_init(&codec->mutex);
-	codec->audio_mclk = pdata->audio_mclk;
+	twl4030_audio_dev = pdev;
+	mutex_init(&audio->mutex);
+	audio->audio_mclk = pdata->audio_mclk;
 
 	/* Codec power */
-	codec->resource[TWL4030_CODEC_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
-	codec->resource[TWL4030_CODEC_RES_POWER].mask = TWL4030_CODECPDZ;
+	audio->resource[TWL4030_CODEC_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
+	audio->resource[TWL4030_CODEC_RES_POWER].mask = TWL4030_CODECPDZ;
 
 	/* PLL */
-	codec->resource[TWL4030_CODEC_RES_APLL].reg = TWL4030_REG_APLL_CTL;
-	codec->resource[TWL4030_CODEC_RES_APLL].mask = TWL4030_APLL_EN;
+	audio->resource[TWL4030_CODEC_RES_APLL].reg = TWL4030_REG_APLL_CTL;
+	audio->resource[TWL4030_CODEC_RES_APLL].mask = TWL4030_APLL_EN;
 
 	if (pdata->audio) {
-		cell = &codec->cells[childs];
+		cell = &audio->cells[childs];
 		cell->name = "twl4030-codec";
 		cell->platform_data = pdata->audio;
 		cell->pdata_size = sizeof(*pdata->audio);
 		childs++;
 	}
 	if (pdata->vibra) {
-		cell = &codec->cells[childs];
+		cell = &audio->cells[childs];
 		cell->name = "twl4030-vibra";
 		cell->platform_data = pdata->vibra;
 		cell->pdata_size = sizeof(*pdata->vibra);
@@ -221,7 +222,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	}
 
 	if (childs)
-		ret = mfd_add_devices(&pdev->dev, pdev->id, codec->cells,
+		ret = mfd_add_devices(&pdev->dev, pdev->id, audio->cells,
 				      childs, NULL, 0);
 	else {
 		dev_err(&pdev->dev, "No platform data found for childs\n");
@@ -232,45 +233,45 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 		return 0;
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(codec);
-	twl4030_codec_dev = NULL;
+	kfree(audio);
+	twl4030_audio_dev = NULL;
 	return ret;
 }
 
-static int __devexit twl4030_codec_remove(struct platform_device *pdev)
+static int __devexit twl4030_audio_remove(struct platform_device *pdev)
 {
-	struct twl4030_codec *codec = platform_get_drvdata(pdev);
+	struct twl4030_audio *audio = platform_get_drvdata(pdev);
 
 	mfd_remove_devices(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(codec);
-	twl4030_codec_dev = NULL;
+	kfree(audio);
+	twl4030_audio_dev = NULL;
 
 	return 0;
 }
 
 MODULE_ALIAS("platform:twl4030-audio");
 
-static struct platform_driver twl4030_codec_driver = {
-	.probe		= twl4030_codec_probe,
-	.remove		= __devexit_p(twl4030_codec_remove),
+static struct platform_driver twl4030_audio_driver = {
+	.probe		= twl4030_audio_probe,
+	.remove		= __devexit_p(twl4030_audio_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "twl4030-audio",
 	},
 };
 
-static int __devinit twl4030_codec_init(void)
+static int __devinit twl4030_audio_init(void)
 {
-	return platform_driver_register(&twl4030_codec_driver);
+	return platform_driver_register(&twl4030_audio_driver);
 }
-module_init(twl4030_codec_init);
+module_init(twl4030_audio_init);
 
-static void __devexit twl4030_codec_exit(void)
+static void __devexit twl4030_audio_exit(void)
 {
-	platform_driver_unregister(&twl4030_codec_driver);
+	platform_driver_unregister(&twl4030_audio_driver);
 }
-module_exit(twl4030_codec_exit);
+module_exit(twl4030_audio_exit);
 
 MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.5.3

