Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0GOIgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:36:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63040 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab0GOIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bRimf0Yr1h+qQSIWyDLEaFABoGgVw+heSy4/u4B6DLmOVvqmI6VUMM6chPmf7xw5jR
         xD+DbIPkoe+kIlE+Kl+GyxljswOXc5f8+NUGcCBu/LRQe82B7nz46PxZHwwfMdUBhzpH
         zNx3Ca+f/EmHAq+QFNM1vqdCB90Nzqbh8uRgk=
Subject: [PATCH v2 11/12] wm8978: fix a memory leak if another WM8978 is
	registered
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279163338.29294.30.camel@mola>
References: <1279162147.29294.2.camel@mola> <1279163338.29294.30.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 16:37:06 +0800
Message-Id: <1279183026.10733.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e53ff15ee6843d6591509f9aeeb2fa1a0c1eccee Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Jul 2010 16:33:20 +0800
Subject: [PATCH] wm8978: fix a memory leak if a wm8978_register fail

There is a memory leak found if wm8978_register() fail.
This patch moves the buffer allocate and release
at the same level to prevent the memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8978.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 51d5f43..8a1ad77 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -1076,7 +1076,6 @@ static __devinit int wm8978_register(struct wm8978_priv *wm8978)
 err_codec:
 	snd_soc_unregister_codec(codec);
 err:
-	kfree(wm8978);
 	return ret;
 }
 
@@ -1085,13 +1084,13 @@ static __devexit void wm8978_unregister(struct wm8978_priv *wm8978)
 	wm8978_set_bias_level(&wm8978->codec, SND_SOC_BIAS_OFF);
 	snd_soc_unregister_dai(&wm8978_dai);
 	snd_soc_unregister_codec(&wm8978->codec);
-	kfree(wm8978);
 	wm8978_codec = NULL;
 }
 
 static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
 				      const struct i2c_device_id *id)
 {
+	int ret;
 	struct wm8978_priv *wm8978;
 	struct snd_soc_codec *codec;
 
@@ -1107,13 +1106,18 @@ static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
 
 	codec->dev = &i2c->dev;
 
-	return wm8978_register(wm8978);
+	ret = wm8978_register(wm8978);
+	if (ret < 0)
+		kfree(wm8978);
+
+	return ret;
 }
 
 static __devexit int wm8978_i2c_remove(struct i2c_client *client)
 {
 	struct wm8978_priv *wm8978 = i2c_get_clientdata(client);
 	wm8978_unregister(wm8978);
+	kfree(wm8978);
 	return 0;
 }
 
-- 
1.5.4.3



