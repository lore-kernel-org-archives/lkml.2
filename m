Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1CIUqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:46:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53807 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1CIUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=qxnUDndSg5BCUngykj+y825rLYBX2oh6ikx9qyxzLpdG4WXGU62XIhS2IGpUQ3R8ir
         gHIN8AGnYKxyKFXwJbSsNn8qlgR7f7MMCa2VHZIs6HtHQ2uhcEgaeo6ZSJIcQGw+MH5d
         DwvANPaKV9s7GJX1NQ41Ac8toDJrwvHcHiiZ4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org, perex@perex.cz, tiwai@suse.de
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH RFC] arm: mini2440: Fix uda134x codec problem.
Date: Wed,  9 Mar 2011 21:46:20 +0100
Message-Id: <1299703580-3957-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/arm/mach-s3c2440/mach-mini2440.c |    7 +++++++
 sound/soc/codecs/uda134x.c            |    3 ++-
 sound/soc/samsung/s3c24xx_uda134x.c   |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index f62bb4c..7c3fb07 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -506,6 +506,11 @@ static struct i2c_board_info mini2440_i2c_devs[] __initdata = {
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
@@ -521,7 +526,9 @@ static struct platform_device *mini2440_devices[] __initdata = {
 	&s3c_device_nand,
 	&s3c_device_sdi,
 	&s3c_device_iis,
+	&uda1340_codec,
 	&mini2440_audio,
+	&samsung_asoc_dma,
 };
 
 static void __init mini2440_map_io(void)
diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index e76847a..48ffd40 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -486,7 +486,8 @@ static struct snd_soc_dai_driver uda134x_dai = {
 static int uda134x_soc_probe(struct snd_soc_codec *codec)
 {
 	struct uda134x_priv *uda134x;
-	struct uda134x_platform_data *pd = dev_get_drvdata(codec->card->dev);
+	struct uda134x_platform_data *pd = codec->card->dev->platform_data;
+
 	int ret;
 
 	printk(KERN_INFO "UDA134X SoC Audio Codec\n");
diff --git a/sound/soc/samsung/s3c24xx_uda134x.c b/sound/soc/samsung/s3c24xx_uda134x.c
index 2c09e93..86f1dc4 100644
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -226,7 +226,7 @@ static struct snd_soc_ops s3c24xx_uda134x_ops = {
 static struct snd_soc_dai_link s3c24xx_uda134x_dai_link = {
 	.name = "UDA134X",
 	.stream_name = "UDA134X",
-	.codec_name = "uda134x-hifi",
+	.codec_name = "uda134x-codec",
 	.codec_dai_name = "uda134x-hifi",
 	.cpu_dai_name = "s3c24xx-iis",
 	.ops = &s3c24xx_uda134x_ops,
@@ -321,6 +321,7 @@ static int s3c24xx_uda134x_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(s3c24xx_uda134x_snd_device,
 			     &snd_soc_s3c24xx_uda134x);
+	platform_device_add_data(s3c24xx_uda134x_snd_device, &s3c24xx_uda134x, sizeof(s3c24xx_uda134x));
 	ret = platform_device_add(s3c24xx_uda134x_snd_device);
 	if (ret) {
 		printk(KERN_ERR "S3C24XX_UDA134X SoC Audio: Unable to add\n");
-- 
1.7.1

