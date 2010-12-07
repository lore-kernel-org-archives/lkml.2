Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0LGI7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:59:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36997 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0LGI7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:59:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qfBT9XsjpHy18P7iDN9dS8ffZdE5jnQ3pDFHBDW72TTTHNLNkhexoEO8NFclDmsqqX
         m1yPGkWtLB2+Jda2olt5fkaez451dTiai0v/GtMkaJbcfnxSh9bKTLuoKr8UO3NB7884
         l3OR5UYazyc0qjYVbYeB0wSyMxeb57RfbOaxc=
Subject: [PATCH] ASoC: Fix snd_soc_instantiate_card error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Tue, 07 Dec 2010 17:06:02 +0800
Message-Id: <1291712762.4776.11.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0443551476ee6fabe45a0fbc7460dca8e0f6a965 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 7 Dec 2010 16:12:29 +0800
Subject: [PATCH] ASoC: Fix snd_soc_instantiate_card error path

Properly free the resources in the case of snd_card_register failure
and soc_register_ac97_dai_link failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

This patch is against linux-next tree.

In the case of soc_register_ac97_dai_link failure,
I think we need below fix for Linus's tree:
Add 
while (--i >= 0)
	soc_unregister_ac97_dai_link(&card->rtd[i]);
just before goto probe_dai_err;
Should I also send a patch against Linus's tree?

Regards,
Axel

 sound/soc/soc-core.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 392d336..b4c8c38 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1839,18 +1839,20 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
 	ret = snd_card_register(card->snd_card);
 	if (ret < 0) {
 		printk(KERN_ERR "asoc: failed to register soundcard for %s\n", card->name);
-		goto probe_dai_err;
+		goto probe_aux_dev_err;
 	}
 
 #ifdef CONFIG_SND_SOC_AC97_BUS
 	/* register any AC97 codecs */
 	for (i = 0; i < card->num_rtd; i++) {
-			ret = soc_register_ac97_dai_link(&card->rtd[i]);
-			if (ret < 0) {
-				printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
-				goto probe_dai_err;
-			}
+		ret = soc_register_ac97_dai_link(&card->rtd[i]);
+		if (ret < 0) {
+			printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
+			while (--i >= 0)
+				soc_unregister_ac97_dai_link(&card->rtd[i]);
+			goto probe_aux_dev_err;
 		}
+	}
 #endif
 
 	card->instantiated = 1;
-- 
1.7.2



