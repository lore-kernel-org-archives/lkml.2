Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2GIOwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:52:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38102 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab2GIOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:57 -0400
Message-Id: <20120709143118.240869686@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 11/48] ASoC: tlv320aic3x: Fix codec pll configure bug
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>

commit c9fe573a6584034670c1a55ee8162d623519cbbf upstream.

In sound/soc/codecs/tlv320aic3x.c

        data = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
        snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
                      data | (pll_p << PLLP_SHIFT));

In the above code, pll-p value is OR'ed with previous value without
clearing it. Bug is not seen if pll-p value doesn't change across
Sampling frequency.

However on some platforms (like AM335x EVM-SK), pll-p may have different
values across different sampling frequencies. In such case, above code
configures the pll with a wrong value.
Because of this bug, when a audio stream is played with pll value
different from previous stream, audio is heard as differently(like its
stretched).

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/tlv320aic3x.c |    4 +---
 sound/soc/codecs/tlv320aic3x.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 64d2a4f..e9b62b5 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -935,9 +935,7 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 	}
 
 found:
-	data = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-	snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
-		      data | (pll_p << PLLP_SHIFT));
+	snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG, PLLP_MASK, pll_p);
 	snd_soc_write(codec, AIC3X_OVRF_STATUS_AND_PLLR_REG,
 		      pll_r << PLLR_SHIFT);
 	snd_soc_write(codec, AIC3X_PLL_PROGB_REG, pll_j << PLLJ_SHIFT);
diff --git a/sound/soc/codecs/tlv320aic3x.h b/sound/soc/codecs/tlv320aic3x.h
index 6f097fb..08c7f66 100644
--- a/sound/soc/codecs/tlv320aic3x.h
+++ b/sound/soc/codecs/tlv320aic3x.h
@@ -166,6 +166,7 @@
 
 /* PLL registers bitfields */
 #define PLLP_SHIFT		0
+#define PLLP_MASK		7
 #define PLLQ_SHIFT		3
 #define PLLR_SHIFT		0
 #define PLLJ_SHIFT		2


