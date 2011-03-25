Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab1CZA3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:29:24 -0400
Received: from kroah.org ([198.145.64.141]:41411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab1CYXwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:08 2011
Message-Id: <20110325234508.692629623@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [08/63] ASoC: mini2440: Fix uda134x codec problem.
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Belisko <marek.belisko@open-nandra.com>

commit a110f4ef810ee29d810876df725f41d66629733e upstream.

ASoC audio for mini2440 platform in current kenrel doesn't work.
First problem is samsung_asoc_dma device is missing in initialization.
Next problem is with codec. Codec is initialized but never probed
because no platform_device exist for codec driver. It leads to errors
during codec binding to asoc dai. Next problem was platform data which
was passed from board to asoc main driver but not passed to codec when
called codec_soc_probe().

Following patch should fix issues. But not sure if in correct way.
Please review.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-s3c2440/mach-mini2440.c |    7 +++++++
 sound/soc/codecs/uda134x.c            |    3 ++-
 sound/soc/samsung/s3c24xx_uda134x.c   |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -506,6 +506,11 @@ static struct i2c_board_info mini2440_i2
 	},
 };
 
+static struct platform_device uda1340_codec = {
+		.name = "uda134x-codec",
+		.id = -1,
+};
+
 static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_ohci,
 	&s3c_device_wdt,
@@ -521,7 +526,9 @@ static struct platform_device *mini2440_
 	&s3c_device_nand,
 	&s3c_device_sdi,
 	&s3c_device_iis,
+	&uda1340_codec,
 	&mini2440_audio,
+	&samsung_asoc_dma,
 };
 
 static void __init mini2440_map_io(void)
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -486,7 +486,8 @@ static struct snd_soc_dai_driver uda134x
 static int uda134x_soc_probe(struct snd_soc_codec *codec)
 {
 	struct uda134x_priv *uda134x;
-	struct uda134x_platform_data *pd = dev_get_drvdata(codec->card->dev);
+	struct uda134x_platform_data *pd = codec->card->dev->platform_data;
+
 	int ret;
 
 	printk(KERN_INFO "UDA134X SoC Audio Codec\n");
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -226,7 +226,7 @@ static struct snd_soc_ops s3c24xx_uda134
 static struct snd_soc_dai_link s3c24xx_uda134x_dai_link = {
 	.name = "UDA134X",
 	.stream_name = "UDA134X",
-	.codec_name = "uda134x-hifi",
+	.codec_name = "uda134x-codec",
 	.codec_dai_name = "uda134x-hifi",
 	.cpu_dai_name = "s3c24xx-iis",
 	.ops = &s3c24xx_uda134x_ops,
@@ -321,6 +321,7 @@ static int s3c24xx_uda134x_probe(struct
 
 	platform_set_drvdata(s3c24xx_uda134x_snd_device,
 			     &snd_soc_s3c24xx_uda134x);
+	platform_device_add_data(s3c24xx_uda134x_snd_device, &s3c24xx_uda134x, sizeof(s3c24xx_uda134x));
 	ret = platform_device_add(s3c24xx_uda134x_snd_device);
 	if (ret) {
 		printk(KERN_ERR "S3C24XX_UDA134X SoC Audio: Unable to add\n");


