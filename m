Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0GWFzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:55:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57042 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0GWFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jdT1xfqYT3qp/nf3L/tnRDjJZesNSJIw4qLKBz2ZKCMbktqYNVHpijtmfO4z9DBFkN
         pXe0/bk0vFCXcFvNHRAKgjpC2ySxwhVGA4R4sSctYJPV9/LtShfnXEMVKF5Xpurs1Y0G
         xTxNqr74XHZRIVGZnLKNZVDkg8QfpjCPJV0fo=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 09/12] wm8961: fix resource reclaim in wm8961_register error path
Date: Fri, 23 Jul 2010 05:53:51 +0000
Message-Id: <1279864434-8010-10-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the error path in wm8961_register to properly free resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8961.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index 5b9a756..2549d3a 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -1102,7 +1102,7 @@ static int wm8961_register(struct wm8961_priv *wm8961)
 	ret = wm8961_reset(codec);
 	if (ret < 0) {
 		dev_err(codec->dev, "Failed to issue reset\n");
-		return ret;
+		goto err;
 	}
 
 	/* Enable class W */
@@ -1147,18 +1147,19 @@ static int wm8961_register(struct wm8961_priv *wm8961)
 	ret = snd_soc_register_codec(codec);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
-		return ret;
+		goto err;
 	}
 
 	ret = snd_soc_register_dai(&wm8961_dai);
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
 	kfree(wm8961);
 	return ret;
-- 
1.7.0.4

