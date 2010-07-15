Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0GOCyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:54:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62430 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0GOCyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f7AmoZ++UQRzzn3PFzrQy/M0yk4YopCzGREa+WSOw+3Y3/o2UBe4iqCgUz4xBg+VC2
         52k28qV2oHLVzmFKCybJhJtUUDtzg5ysm9HD0CPw/7VF8kMVL0AGKx2RwjfLLjpWPArK
         xSHF6Dy3N0R/LnUCJQAGsRF9fprPUbH1d0jeE=
Subject: [PATCH 3/12] da7210: fix a memory leak if failed to initialise
	da7210 audio codec
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <Phil.Edworthy@renesas.com>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:53:49 +0800
Message-Id: <1279162429.29294.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da7210 should be kfreed if da7210_init() return error.
This patch also fixes the error handing in the case of snd_soc_register_dai()
fail by adding snd_soc_unregister_codec() in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/da7210.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 75af2d6..3b9a6cc 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -488,7 +488,7 @@ static int da7210_init(struct da7210_priv *da7210)
 	ret = snd_soc_register_dai(&da7210_dai);
 	if (ret) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		goto init_err;
+		goto codec_err;
 	}
 
 	/* FIXME
@@ -574,6 +574,8 @@ static int da7210_init(struct da7210_priv *da7210)
 
 	return ret;
 
+codec_err:
+	snd_soc_unregister_codec(codec);
 init_err:
 	kfree(codec->reg_cache);
 	codec->reg_cache = NULL;
@@ -601,8 +603,10 @@ static int __devinit da7210_i2c_probe(struct i2c_client *i2c,
 	codec->control_data = i2c;
 
 	ret = da7210_init(da7210);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("Failed to initialise da7210 audio codec\n");
+		kfree(da7210);
+	}
 
 	return ret;
 }
-- 
1.5.4.3



