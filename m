Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0LGM4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:56:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38247 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0LGM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D8uYkyPzb4SL3ptav6Ays1tpWbcVqP1rNWYEywfiOvJerg6z2W6IOtxYNKJsSV/ltp
         wlVzNJXr91f6pmUUYDEAz8BWZ6jt99fwlvsea1XzLLq2G7QhR0906cUXJSuhJiREs37l
         jlGmv7EoEtHE/shvP1VWMr8UK8JwLzdUPsanQ=
Subject: [PATCH] ASoC: Fix resource leak if soc_register_ac97_dai_link
 failed
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 20:56:30 +0800
Message-ID: <1291726590.2760.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly free the resources in the case of soc_register_ac97_dai_link failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

This patch is against Linus tree.

Regards,
Axel
 sound/soc/soc-core.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 441285a..d7f80c3 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1619,12 +1619,14 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
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
+			goto probe_dai_err;
 		}
+	}
 #endif
 
 	card->instantiated = 1;
-- 
1.7.0.4



