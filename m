Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0GOCzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:55:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56197 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab0GOCzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w52LfttTmzb5pMQWGc1tPACvq1cGBK7PfepEFczyR9rwcrmyL0mw9oexVkZvRF5lQA
         W+kpxt4aRSWtO1TK8wDSgqebgvf6VE0SoBYQu0wzLRiH21sEaJVxAB8HJ6uCFVbrgHB+
         GBbgmU8vmCTKFH4tiVmYjP8f/tUenVsGk8Cmc=
Subject: [PATCH 4/12] wm8523: fix resource reclaim in wm8523_register error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
In-Reply-To: <1279162147.29294.2.camel@mola>
References: <1279162147.29294.2.camel@mola>
Content-Type: text/plain
Date: Thu, 15 Jul 2010 10:56:30 +0800
Message-Id: <1279162590.29294.12.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. If another WM8523 is registered, need to kfree wm8523 before return -EINVAL.
2. If snd_soc_register_codec failed, goto error path to properly free resources.
3. Instead of using mixed in-line and goto style cleanup, use goto style error
   handling if snd_soc_register_dai failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8523.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index 37242a7..0ad039b 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -482,7 +482,8 @@ static int wm8523_register(struct wm8523_priv *wm8523,
 
 	if (wm8523_codec) {
 		dev_err(codec->dev, "Another WM8523 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	mutex_init(&codec->mutex);
@@ -570,18 +571,19 @@ static int wm8523_register(struct wm8523_priv *wm8523,
 	ret = snd_soc_register_codec(codec);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
-		return ret;
+		goto err_enable;
 	}
 
 	ret = snd_soc_register_dai(&wm8523_dai);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		snd_soc_unregister_codec(codec);
-		return ret;
+		goto err_codec;
 	}
 
 	return 0;
 
+err_codec:
+	snd_soc_unregister_codec(codec);
 err_enable:
 	regulator_bulk_disable(ARRAY_SIZE(wm8523->supplies), wm8523->supplies);
 err_get:
-- 
1.5.4.3



