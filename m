Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0GOC6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:58:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37787 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab0GOC6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hp9jJaiwS/eSMcK9t87mikA56U9WHKR47F9s11+h9wm0JQ9PDW8lgPEChWL/nXeRhh
         w4wP1FZDfD0nICW4LSEJdNYnZ1woBkEMfTWZt+0gvLv0pkQi/rdtuO9XjUAjqIQBOJPw
         cztfHiq1eJbb7dwk9n+OmQ4zELs4yLqd4K5Ts=
Subject: [PATCH 6/12] wm8904: fix resource reclaim in wm8904_register error
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
Date: Thu, 15 Jul 2010 10:59:28 +0800
Message-Id: <1279162768.29294.17.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. wm8904 need to be kfreed in wm8904_register() error path before return.
2. fix the error path for snd_soc_register_codec() fail and
   snd_soc_register_dai() fail to properly free resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8904.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 87f14f8..f7dcabf 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2433,7 +2433,8 @@ static int wm8904_register(struct wm8904_priv *wm8904,
 
 	if (wm8904_codec) {
 		dev_err(codec->dev, "Another WM8904 is registered\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	mutex_init(&codec->mutex);
@@ -2462,7 +2463,8 @@ static int wm8904_register(struct wm8904_priv *wm8904,
 	default:
 		dev_err(codec->dev, "Unknown device type %d\n",
 			wm8904->devtype);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	memcpy(codec->reg_cache, wm8904_reg, sizeof(wm8904_reg));
@@ -2566,18 +2568,19 @@ static int wm8904_register(struct wm8904_priv *wm8904,
 	ret = snd_soc_register_codec(codec);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
-		return ret;
+		goto err_enable;
 	}
 
 	ret = snd_soc_register_dai(&wm8904_dai);
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
 	regulator_bulk_disable(ARRAY_SIZE(wm8904->supplies), wm8904->supplies);
 err_get:
-- 
1.5.4.3



