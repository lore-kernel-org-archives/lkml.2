Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2AWV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:28:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23751 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2AWV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:28:43 -0500
Date: Mon, 23 Jan 2012 22:28:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Liam Girdwood <lrg@ti.com>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: ASoC: Fix use-after-free in wm2000 - don't release_firmware()
 twice
Message-ID: <alpine.LNX.2.00.1201232224250.8772@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wm2000_i2c_probe(), if we take the true branch in

"
  ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_wm2000,
                               NULL, 0);
  if (ret != 0)
          goto err_fw;
"

then we'll release_firmware(fw) at the 'err_fw' label. But we've already 
done that just a few lines above. That's a use-after-free bug.

This patch restructures the code so that we always call
release_firmware(fw) before leaving the function, but only ever call
it once.
This means that we have to initialize 'fw' to NULL since some paths
may now end up calling it without having called request_firmware(),
but since request_firmware() deals gracefully with NULL pointers, we
are fine if we just NULL initialize it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/wm2000.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

 note:
  Since I have no real way to test this, it is compile tested only.
  I believe the logic is identical, but please check my work before
  applying it.

diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index c288090..a75c376 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -733,8 +733,9 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 	struct wm2000_priv *wm2000;
 	struct wm2000_platform_data *pdata;
 	const char *filename;
-	const struct firmware *fw;
-	int reg, ret;
+	const struct firmware *fw = NULL;
+	int ret;
+	int reg;
 	u16 id;
 
 	wm2000 = devm_kzalloc(&i2c->dev, sizeof(struct wm2000_priv),
@@ -751,7 +752,7 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm2000->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		goto out;
 	}
 
 	/* Verify that this is a WM2000 */
@@ -763,7 +764,7 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 	if (id != 0x2000) {
 		dev_err(&i2c->dev, "Device is not a WM2000 - ID %x\n", id);
 		ret = -ENODEV;
-		goto err_regmap;
+		goto out_regmap_exit;
 	}
 
 	reg = wm2000_read(i2c, WM2000_REG_REVISON);
@@ -782,7 +783,7 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 	ret = request_firmware(&fw, filename, &i2c->dev);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to acquire ANC data: %d\n", ret);
-		goto err_regmap;
+		goto out_regmap_exit;
 	}
 
 	/* Pre-cook the concatenation of the register address onto the image */
@@ -793,15 +794,13 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 	if (wm2000->anc_download == NULL) {
 		dev_err(&i2c->dev, "Out of memory\n");
 		ret = -ENOMEM;
-		goto err_fw;
+		goto out_regmap_exit;
 	}
 
 	wm2000->anc_download[0] = 0x80;
 	wm2000->anc_download[1] = 0x00;
 	memcpy(wm2000->anc_download + 2, fw->data, fw->size);
 
-	release_firmware(fw);
-
 	wm2000->anc_eng_ena = 1;
 	wm2000->anc_active = 1;
 	wm2000->spk_ena = 1;
@@ -809,18 +808,14 @@ static int __devinit wm2000_i2c_probe(struct i2c_client *i2c,
 
 	wm2000_reset(wm2000);
 
-	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_wm2000,
-				     NULL, 0);
-	if (ret != 0)
-		goto err_fw;
+	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_wm2000, NULL, 0);
+	if (!ret)
+		goto out;
 
-	return 0;
-
-err_fw:
-	release_firmware(fw);
-err_regmap:
+out_regmap_exit:
 	regmap_exit(wm2000->regmap);
-err:
+out:
+	release_firmware(fw);
 	return ret;
 }
 
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

