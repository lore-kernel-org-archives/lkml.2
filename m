Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1JODqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 23:46:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40047 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1JODqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 23:46:14 -0400
Subject: [PATCH v2] ASoC: max98095: Convert codec->hw_write to snd_soc_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hsiang <peter.hsiang@maxim-ic.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 11:46:02 +0800
Message-ID: <1318650362.6399.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec->hw_write is broken now, convert codec->hw_write to snd_soc_write.

The hardware has 2 banks of registers sharing a section in I2C register space.
The 1st bank is the primary one and is cached.
The 2nd bank is for loading coefficients only and they do not need cache.
These coefficients registers are therefore direct writes.
Thus we set cache_bypass flag to deal with this before calling snd_soc_write.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi,
  I don't have this hardware, I'd appreciate if someone can test this patch.

Thanks,
Axel

 sound/soc/codecs/max98095.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 6982f74..26d7b08 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -617,14 +617,13 @@ static int max98095_volatile(struct snd_soc_codec *codec, unsigned int reg)
 static int max98095_hw_write(struct snd_soc_codec *codec, unsigned int reg,
 			     unsigned int value)
 {
-	u8 data[2];
+	int ret;
 
-	data[0] = reg;
-	data[1] = value;
-	if (codec->hw_write(codec->control_data, data, 2) == 2)
-		return 0;
-	else
-		return -EIO;
+	codec->cache_bypass = 1;
+	ret = snd_soc_write(codec, reg, value);
+	codec->cache_bypass = 0;
+
+	return ret ? -EIO : 0;
 }
 
 /*
-- 
1.7.4.1



