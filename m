Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0KYHGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:06:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63732 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0KYHGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LhZFJSgSB3uc3rR3g+wM29FR9DZ8tzSFoWgqDX1UdbyGpI13wwYHuwGE6sWrHDVOYw
         9JEaziV9PqHFHvYaDTkcfsicC8tFAhwcb7uToVJD/SGW+R6ZiGfWVOR2Ajev4vErG2h7
         UgZstMTOYTorOfEX7L44hgUW4JkKaqhgMW5cg=
Subject: [PATCH 5/8] ASoC: smdk_wm9713: fix resource leak in smdk_init
	error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jaswinder Singh Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:11:45 +0800
Message-Id: <1290669105.30158.16.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error path to properly free allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/smdk_wm9713.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/soc/samsung/smdk_wm9713.c b/sound/soc/samsung/smdk_wm9713.c
index 7ce2430..238cb3a 100644
--- a/sound/soc/samsung/smdk_wm9713.c
+++ b/sound/soc/samsung/smdk_wm9713.c
@@ -70,24 +70,27 @@ static int __init smdk_init(void)
 
 	ret = platform_device_add(smdk_snd_wm9713_device);
 	if (ret)
-		goto err;
+		goto err1;
 
 	smdk_snd_ac97_device = platform_device_alloc("soc-audio", -1);
 	if (!smdk_snd_ac97_device) {
 		ret = -ENOMEM;
-		goto err;
+		goto err2;
 	}
 
 	platform_set_drvdata(smdk_snd_ac97_device, &smdk);
 
 	ret = platform_device_add(smdk_snd_ac97_device);
-	if (ret) {
-		platform_device_put(smdk_snd_ac97_device);
-		goto err;
-	}
+	if (ret)
+		goto err3;
 
 	return 0;
-err:
+
+err3:
+	platform_device_put(smdk_snd_ac97_device);
+err2:
+	platform_device_del(smdk_snd_wm9713_device);
+err1:
 	platform_device_put(smdk_snd_wm9713_device);
 	return ret;
 }
-- 
1.7.2



