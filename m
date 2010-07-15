Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0GODA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:00:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46939 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0GODA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AJvBrffYLfDR6+hixY4ZsbVJsYMRjdejFg0DMsbLui221zXtcBIx0yBa0jxuBV3H8t
         6qvtXxz4TZpQhEI1ceRjwVcosrvEGcDLrOrQtYgBucpaUXQgJutzC03AzQL8KSMNwWrN
         qMADuS/BnJGaDZt/tLDncdhJr5/QaiTi8GpIg=
Subject: [PATCH 7/12] wm8940: fix resource reclaim in wm8940_register error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 11:01:33 +0800
Message-Id: <1279162893.29294.20.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 44c93254e5158e3086c4707148d24746067f6b14 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Jul 2010 10:13:34 +0800
Subject: [PATCH] wm8940: fix resource reclaim in wm8940_register error path

This patch fixes the error path in wm8940_register to properly free resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index e3c4bbf..9673e6f 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -766,7 +766,8 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 	u16 reg;
 	if (wm8940_codec) {
 		dev_err(codec->dev, "Another WM8940 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	INIT_LIST_HEAD(&codec->dapm_widgets);
@@ -785,7 +786,7 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, control);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	memcpy(codec->reg_cache, wm8940_reg_defaults,
@@ -794,7 +795,7 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 	ret = wm8940_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
-		return ret;
+		goto err;
 	}
 
 	wm8940_dai.dev = codec->dev;
@@ -803,7 +804,7 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 
 	ret = snd_soc_write(codec, WM8940_POWER1, 0x180);
 	if (ret < 0)
-		return ret;
+		goto err;
 
 	if (!pdata)
 		dev_warn(codec->dev, "No platform data supplied\n");
@@ -811,7 +812,7 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 		reg = snd_soc_read(codec, WM8940_OUTPUTCTL);
 		ret = snd_soc_write(codec, WM8940_OUTPUTCTL, reg | pdata->vroi);
 		if (ret < 0)
-			return ret;
+			goto err;
 	}
 
 
@@ -820,17 +821,22 @@ static int wm8940_register(struct wm8940_priv *wm8940,
 	ret = snd_soc_register_codec(codec);
 	if (ret) {
 		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	ret = snd_soc_register_dai(&wm8940_dai);
 	if (ret) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		snd_soc_unregister_codec(codec);
-		return ret;
+		goto err_codec;
 	}
 
 	return 0;
+
+err_codec:
+	snd_soc_unregister_codec(codec);
+err:
+	kfree(wm8940);
+	return ret;
 }
 
 static void wm8940_unregister(struct wm8940_priv *wm8940)
-- 
1.5.4.3



