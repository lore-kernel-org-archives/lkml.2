Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849Ab1ETO0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:26:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48262 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356Ab1ETO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:26:43 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, tiwai@suse.de,
        Michael Williamson <michael.williamson@criticallink.com>
Subject: [PATCH v1 RESEND] audio: tlv320aic26: fix PLL register configuration
Date: Fri, 20 May 2011 10:26:06 -0400
Message-Id: <1305901566-8125-1-git-send-email-michael.williamson@criticallink.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current PLL configuration code for the tlc320aic26 codec appears to assume a
hardcoded system clock of 12 MHz.  Use the clock value provided by the DAI_OPS
API for the calculation.

Tested using a MityDSP-L138 platform providing a 24.576 MHz clock.

Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
This got bounced by the alsa-devel list (I wasn't on list).  I'm not sure 
whose tree this needs to go through, but given the lack of response
I'm guessing alsa-devel. If I'm missing a list, any advice would be 
appreciated.

Changes from V0:
  - Added some parens for clarification
  - Added some comments to describe what the computations were attempting to do

 sound/soc/codecs/tlv320aic26.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index e2a7608..7859bdc 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -161,10 +161,18 @@ static int aic26_hw_params(struct snd_pcm_substream *substream,
 		dev_dbg(&aic26->spi->dev, "bad format\n"); return -EINVAL;
 	}
 
-	/* Configure PLL */
+	/**
+	 * Configure PLL
+	 * fsref = (mclk * PLLM) / 2048
+	 * where PLLM = J.DDDD (DDDD register ranges from 0 to 9999, decimal)
+	 */
 	pval = 1;
-	jval = (fsref == 44100) ? 7 : 8;
-	dval = (fsref == 44100) ? 5264 : 1920;
+	/* compute J portion of multiplier */
+	jval = fsref / (aic26->mclk / 2048);
+	/* compute fractional DDDD component of multiplier */
+	dval = fsref - (jval * (aic26->mclk / 2048));
+	dval = (10000 * dval) / (aic26->mclk / 2048);
+	dev_dbg(&aic26->spi->dev, "Setting PLLM to %d.%04d\n", jval, dval);
 	qval = 0;
 	reg = 0x8000 | qval << 11 | pval << 8 | jval << 2;
 	aic26_reg_write(codec, AIC26_REG_PLL_PROG1, reg);
-- 
1.7.0.4

