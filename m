Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1BCEP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:15:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40980 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab1BCEP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:15:26 -0500
Date: Wed, 2 Feb 2011 20:15:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202201522.72d37f1e@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

In this case, move the various platform_data pointers
to driver_data.  All of the clients which make use of it
are also changed.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/misc/twl4030-vibra.c |    2 +-
 drivers/mfd/twl4030-codec.c        |    6 ++----
 sound/soc/codecs/twl4030.c         |    9 ++++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 014dd4a..7d7602a 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -196,7 +196,7 @@ static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
 
 static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_vibra_data *pdata = pdev->dev.platform_data;
+	struct twl4030_codec_vibra_data *pdata = platform_get_drvdata(pdev);
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 9a4b196..d44ad30 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -208,15 +208,13 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	if (pdata->audio) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-codec";
-		cell->platform_data = pdata->audio;
-		cell->data_size = sizeof(*pdata->audio);
+		cell->driver_data = pdata->audio;
 		childs++;
 	}
 	if (pdata->vibra) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-vibra";
-		cell->platform_data = pdata->vibra;
-		cell->data_size = sizeof(*pdata->vibra);
+		cell->driver_data = pdata->vibra;
 		childs++;
 	}
 
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index e4d464b..3721671 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -130,6 +130,7 @@ static const u8 twl4030_reg[TWL4030_CACHEREGNUM] = {
 /* codec private data */
 struct twl4030_priv {
 	struct snd_soc_codec codec;
+	struct twl4030_codec_audio_data *pdata;
 
 	unsigned int codec_powered;
 
@@ -297,8 +298,8 @@ static inline void twl4030_reset_registers(struct snd_soc_codec *codec)
 
 static void twl4030_init_chip(struct snd_soc_codec *codec)
 {
-	struct twl4030_codec_audio_data *pdata = dev_get_platdata(codec->dev);
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	struct twl4030_codec_audio_data *pdata = twl4030->pdata;
 	u8 reg, byte;
 	int i = 0;
 
@@ -732,9 +733,9 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 
 static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 {
-	struct twl4030_codec_audio_data *pdata = codec->dev->platform_data;
 	unsigned char hs_gain, hs_pop;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	struct twl4030_codec_audio_data *pdata = twl4030->pdata;
 	/* Base values for ramp delay calculation: 2^19 - 2^26 */
 	unsigned int ramp_base[] = {524288, 1048576, 2097152, 4194304,
 				    8388608, 16777216, 33554432, 67108864};
@@ -2251,6 +2252,7 @@ static int twl4030_soc_resume(struct snd_soc_codec *codec)
 
 static int twl4030_soc_probe(struct snd_soc_codec *codec)
 {
+	struct twl4030_codec_audio_data *pdata = dev_get_drvdata(codec->dev);
 	struct twl4030_priv *twl4030;
 
 	twl4030 = kzalloc(sizeof(struct twl4030_priv), GFP_KERNEL);
@@ -2258,6 +2260,7 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 		printk("Can not allocate memroy\n");
 		return -ENOMEM;
 	}
+	twl4030->pdata = pdata;
 	snd_soc_codec_set_drvdata(codec, twl4030);
 	/* Set the defaults, and power up the codec */
 	twl4030->sysclk = twl4030_codec_get_mclk() / 1000;
@@ -2297,7 +2300,7 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_audio_data *pdata = pdev->dev.platform_data;
+	struct twl4030_codec_audio_data *pdata = platform_get_drvdata(pdev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform_data is missing\n");
-- 
1.7.2.3

