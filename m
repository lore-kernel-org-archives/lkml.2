Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0GWF4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:56:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56451 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0GWFyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LSOdC5ug1KvvhGhBZD4VMWL5WXZ8guGo4QzfDfC2MqwIdMa+k7y0rdt1HIlHLqxFYD
         EdghqYSnzTHGE4R++090ramnwmj5hNB5o7UViIPDs61j1E08fFsJU5yYpAIrcttzRKu7
         uGaxXcNISAbVLSZhFjmbO8x2n5rnsDeFAlq1c=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 06/12] wm8904: fix resource reclaim in wm8904_register error path
Date: Fri, 23 Jul 2010 05:53:48 +0000
Message-Id: <1279864434-8010-7-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
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
1.7.0.4

