Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0KYHHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:07:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0KYHHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N73pHlg5LjIXxW4vtZT7t9Hw5QPJM4n7YU7Bh2ukPW7KvN5N6K+NtXT098LehVRH08
         moPT2aL44N0trISqIz0ii3XzWSpBgDGNHmvnxj3TvsAb1lvIcDDGrXvaU1u41KronCf5
         R8HqkkGHtHX+eqKOlZfBYQkEGL4henu20BM6c=
Subject: [PATCH 6/8] ASoC: simone: fix resource leak in simone_init error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:12:30 +0800
Message-Id: <1290669150.30158.18.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error path to properly free allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/ep93xx/simone.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/ep93xx/simone.c b/sound/soc/ep93xx/simone.c
index 4b0d199..2868179 100644
--- a/sound/soc/ep93xx/simone.c
+++ b/sound/soc/ep93xx/simone.c
@@ -54,24 +54,26 @@ static int __init simone_init(void)
 
 	ret = platform_device_add(simone_snd_ac97_device);
 	if (ret)
-		goto fail;
+		goto fail1;
 
 	simone_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!simone_snd_device) {
 		ret = -ENOMEM;
-		goto fail;
+		goto fail2;
 	}
 
 	platform_set_drvdata(simone_snd_device, &snd_soc_simone);
 	ret = platform_device_add(simone_snd_device);
-	if (ret) {
-		platform_device_put(simone_snd_device);
-		goto fail;
-	}
+	if (ret)
+		goto fail3;
 
-	return ret;
+	return 0;
 
-fail:
+fail3:
+	platform_device_put(simone_snd_device);
+fail2:
+	platform_device_del(simone_snd_ac97_device);
+fail1:
 	platform_device_put(simone_snd_ac97_device);
 	return ret;
 }
-- 
1.7.2



