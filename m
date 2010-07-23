Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0GWFy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56451 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab0GWFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QozWYTtGNOYNMWK8mZEU0h3FAJ0dwLb/XbHbNIRFyNrJIVmNB3fFmXzI4onYTT9yoM
         ltSL8jKZ+Y3mivExWuyD5ySBATeQH0RUBm1E44dt4mv8q8APmawQTMPj4uxp7fwBhOaL
         aep3VG4ZgF0P1tq0yvoO7NYhIJf1GSIHVZ87o=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 04/12] wm8523: fix resource reclaim in wm8523_register error path
Date: Fri, 23 Jul 2010 05:53:46 +0000
Message-Id: <1279864434-8010-5-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
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
1.7.0.4

