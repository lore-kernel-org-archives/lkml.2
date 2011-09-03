Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1ICFl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:41:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58376 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1ICFl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:41:58 -0400
Subject: [PATCH] ASoC: sn95031: Fix the logic to find free channel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harsha Priya <priya.harsha@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Sep 2011 13:41:47 +0800
Message-ID: <1315028507.2268.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of no free channel available,
current implementation returns 0 instead of negative errno.

This patch fixes the logic to return -EINVAL if no free channel available.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sn95031.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index 84ffdeb..b4f1cb4 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -79,7 +79,7 @@ static void configure_adc(struct snd_soc_codec *sn95031_codec, int val)
  */
 static int find_free_channel(struct snd_soc_codec *sn95031_codec)
 {
-	int ret = 0, i, value;
+	int i, value;
 
 	/* check whether ADC is enabled */
 	value = snd_soc_read(sn95031_codec, SN95031_ADC1CNTL1);
@@ -91,12 +91,10 @@ static int find_free_channel(struct snd_soc_codec *sn95031_codec)
 	for (i = 0; i <	SN95031_ADC_CHANLS_MAX; i++) {
 		value = snd_soc_read(sn95031_codec,
 				SN95031_ADC_CHNL_START_ADDR + i);
-		if (value & SN95031_STOPBIT_MASK) {
-			ret = i;
+		if (value & SN95031_STOPBIT_MASK)
 			break;
-		}
 	}
-	return (ret > SN95031_ADC_LOOP_MAX) ? (-EINVAL) : ret;
+	return (i == SN95031_ADC_CHANLS_MAX) ? (-EINVAL) : i;
 }
 
 /* Initialize the ADC for reading micbias values. Can sleep. */
-- 
1.7.4.1



