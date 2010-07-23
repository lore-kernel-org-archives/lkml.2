Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0GWFym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57042 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0GWFyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xGDDMhawIIVEHH9FELgRRzUHCDC1ErLGEtgEn+J89qMywwqSZ0WTrIqw+aEqBCEcUP
         LIpb1DraXDOeDPVnITjgZdIt9BFaYR+EwyPoQP8mehiNYsxEenmd3+9KmC5/SU90YM+g
         yy692PGWgTIIZKsUfKtD6SzOkVud3dMiN+eLk=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 12/12] wm9081: fix resource reclaim in wm9081_register error path
Date: Fri, 23 Jul 2010 05:53:54 +0000
Message-Id: <1279864434-8010-13-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error path in wm9081_register to properly free resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm9081.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index 13186fb..76b37ff 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -1356,7 +1356,7 @@ static int wm9081_register(struct wm9081_priv *wm9081,
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, control);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	reg = snd_soc_read(codec, WM9081_SOFTWARE_RESET);
@@ -1369,7 +1369,7 @@ static int wm9081_register(struct wm9081_priv *wm9081,
 	ret = wm9081_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
-		return ret;
+		goto err;
 	}
 
 	wm9081_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
@@ -1388,18 +1388,19 @@ static int wm9081_register(struct wm9081_priv *wm9081,
 	ret = snd_soc_register_codec(codec);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	ret = snd_soc_register_dai(&wm9081_dai);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		snd_soc_unregister_codec(codec);
-		return ret;
+		goto err_codec;
 	}
 
 	return 0;
 
+err_codec:
+	snd_soc_unregister_codec(codec);
 err:
 	kfree(wm9081);
 	return ret;
-- 
1.7.0.4

