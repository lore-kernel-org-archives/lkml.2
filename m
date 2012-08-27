Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2H0WMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:12:12 -0400
Received: from d1.icnet.pl ([212.160.220.21]:37592 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab2H0WMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:12:08 -0400
X-Greylist: delayed 2577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 18:12:08 EDT
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] ASoC: ams-delta: fix card initalization failure
Date: Mon, 27 Aug 2012 23:28:30 +0200
Message-Id: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d, 'device-core:
Ensure drvdata = NULL when no driver is bound', the Amstrad Delta sound
card no longer initializes correctly due to drvdata reset to NULL by an
upper layer before the codec device, required for successful card setup,
is registered. Fix this by moving the codec registration bits up, before
the card is probed for.

Created and tested against linux-3.6-rc3

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 sound/soc/omap/ams-delta.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 7d4fa8e..270de9c 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -590,20 +590,22 @@ static int __init ams_delta_module_init(void)
 	if (!ams_delta_audio_platform_device)
 		return -ENOMEM;
 
-	platform_set_drvdata(ams_delta_audio_platform_device,
-				&ams_delta_audio_card);
-
-	ret = platform_device_add(ams_delta_audio_platform_device);
-	if (ret)
-		goto err;
-
 	/*
 	 * Codec platform device could be registered from elsewhere (board?),
 	 * but I do it here as it makes sense only if used with the card.
+	 * Moreover, it must be registered before the card is probed for,
+	 * or the card setup fails due to drvdata reset by upper layers.
 	 */
 	cx20442_platform_device =
 		platform_device_register_simple("cx20442-codec", -1, NULL, 0);
-	return 0;
+
+	platform_set_drvdata(ams_delta_audio_platform_device,
+			     &ams_delta_audio_card);
+
+	ret = platform_device_add(ams_delta_audio_platform_device);
+	if (!ret)
+		return ret;
+
 err:
 	platform_device_put(ams_delta_audio_platform_device);
 	return ret;
-- 
1.7.3.4

