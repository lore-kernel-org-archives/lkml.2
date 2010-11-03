Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0KCHBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:01:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40033 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0KCHBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wumm7of6PR4BBCwp2g0vSpH7Q52qPQfp+PHMj2ahasFsERUhjtoYd3UGAcaXoBEpnB
         fl8BT0fd7Tx1Wa5I2YjSOsClsAy0sS/bQNEHXtp/Kzy+jmgWJJl5rSgXxQpVt5BT61rZ
         kCVRt5dXGeBdC9cF/f3MLoM+LyR+cfXPKfX5Q=
Subject: [PATCH] ASoC: Fix snd_soc_register_dais error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 03 Nov 2010 15:04:45 +0800
Message-Id: <1288767885.32421.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc for dai may fail at any iteration of the for loop,
thus properly unregister already registered DAIs before return error.

The error handling code in snd_soc_register_dais() already ensure all the DAIs
are unregistered before return error, we can remove the error handling code
to unregister DAIs in snd_soc_register_codec().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 614a8b3..441285a 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3043,8 +3043,10 @@ int snd_soc_register_dais(struct device *dev,
 	for (i = 0; i < count; i++) {
 
 		dai = kzalloc(sizeof(struct snd_soc_dai), GFP_KERNEL);
-		if (dai == NULL)
-			return -ENOMEM;
+		if (dai == NULL) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		/* create DAI component name */
 		dai->name = fmt_multiple_name(dev, &dai_drv[i]);
@@ -3263,9 +3265,6 @@ int snd_soc_register_codec(struct device *dev,
 	return 0;
 
 error:
-	for (i--; i >= 0; i--)
-		snd_soc_unregister_dai(dev);
-
 	if (codec->reg_cache)
 		kfree(codec->reg_cache);
 	kfree(codec->name);
-- 
1.7.2



