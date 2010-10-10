Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0JJR3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:29:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab0JJR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yBAC3vRb8y8DD5LhIz25BN0jAohnJYkw/cZWkRiS/PUmevB9EU5SUzemMoGL0mMwJd
         kQBstnMGLOpbSOQNEtN7jwRdlyeskkeDCiUyjKhUJIasU+pl34FWYkGoThQSyKNo2efd
         PzTQRC6dabQUYpLHQKyzYq0+y0Z/gSS5wGuDs=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: wm8804: fix error handling code
Date: Sun, 10 Oct 2010 21:29:04 +0400
Message-Id: <1286731745-18169-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() returns NULL on error, not ERR_PTR().
Also wm8804_modinit() didn't called i2c_del_driver() if
spi_register_driver() failed.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 sound/soc/codecs/wm8804.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 642b07c..ff4dffd 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -720,8 +720,8 @@ static int __devinit wm8804_spi_probe(struct spi_device *spi)
 	int ret;
 
 	wm8804 = kzalloc(sizeof *wm8804, GFP_KERNEL);
-	if (IS_ERR(wm8804))
-		return PTR_ERR(wm8804);
+	if (!wm8804)
+		return -ENOMEM;
 
 	wm8804->control_type = SND_SOC_SPI;
 	spi_set_drvdata(spi, wm8804);
@@ -758,8 +758,8 @@ static __devinit int wm8804_i2c_probe(struct i2c_client *i2c,
 	int ret;
 
 	wm8804 = kzalloc(sizeof *wm8804, GFP_KERNEL);
-	if (IS_ERR(wm8804))
-		return PTR_ERR(wm8804);
+	if (!wm8804)
+		return -ENOMEM;
 
 	wm8804->control_type = SND_SOC_I2C;
 	i2c_set_clientdata(i2c, wm8804);
@@ -804,6 +804,7 @@ static int __init wm8804_modinit(void)
 	if (ret) {
 		printk(KERN_ERR "Failed to register wm8804 I2C driver: %d\n",
 		       ret);
+		goto err;
 	}
 #endif
 #if defined(CONFIG_SPI_MASTER)
@@ -811,7 +812,13 @@ static int __init wm8804_modinit(void)
 	if (ret != 0) {
 		printk(KERN_ERR "Failed to register wm8804 SPI driver: %d\n",
 		       ret);
+		goto err_i2c;
 	}
+err_i2c:
+#endif
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_driver(&wm8804_i2c_driver);
+err:
 #endif
 	return ret;
 }
-- 
1.7.0.4

