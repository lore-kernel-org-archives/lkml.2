Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0KZGqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 01:46:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60059 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0KZGqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 01:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SLcpBv3cyrkV2vfR1VDO6DQuTdtbPUuFFPsvliiInLB1LqPlWD0aHIBXsD2S3ejHNv
         TmW2zNcDFwOFvx6jbQy5H5uAPfvnWH0A02Wd1uejy6bm6FLoQSrSNpxnRQutBMWPeYdy
         7jEy5mT/rN75jhVaagq0nB9+zy7/JEaae1ZiA=
Subject: [PATCH 1/4] ASoC: Fix resource leask in goni_wm8994.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290754245.25125.1.camel@mola>
References: <1290754245.25125.1.camel@mola>
Content-Type: text/plain
Date: Fri, 26 Nov 2010 14:51:56 +0800
Message-Id: <1290754316.25125.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly free allocated resources in goni_init() error path.
Add missing snd_soc_unregister_dai() in goni_exit().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/goni_wm8994.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index dcfac54..cc8528c 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -283,20 +283,25 @@ static int __init goni_init(void)
 
 	/* register voice DAI here */
 	ret = snd_soc_register_dai(&goni_snd_device->dev, &voice_dai);
-	if (ret)
+	if (ret) {
+		platform_device_put(goni_snd_device);
 		return ret;
+	}
 
 	platform_set_drvdata(goni_snd_device, &goni);
 	ret = platform_device_add(goni_snd_device);
 
-	if (ret)
+	if (ret) {
+		snd_soc_unregister_dai(&goni_snd_device->dev);
 		platform_device_put(goni_snd_device);
+	}
 
 	return ret;
 }
 
 static void __exit goni_exit(void)
 {
+	snd_soc_unregister_dai(&goni_snd_device->dev);
 	platform_device_unregister(goni_snd_device);
 }
 
-- 
1.7.2



