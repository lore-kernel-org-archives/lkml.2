Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162645Ab2GLXSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:18:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162607Ab2GLXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:04:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 24/68] ASoC: tlv320aic3x: Fix codec pll configure bug
Date: Thu, 12 Jul 2012 16:01:58 -0700
Message-Id: <20120712175037.588606968@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic3x.c |    4 +---
 sound/soc/codecs/tlv320aic3x.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -949,9 +949,7 @@ static int aic3x_hw_params(struct snd_pc
 	}
 
 found:
-	data = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-	snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
-		      data | (pll_p << PLLP_SHIFT));
+	snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG, PLLP_MASK, pll_p);
 	snd_soc_write(codec, AIC3X_OVRF_STATUS_AND_PLLR_REG,
 		      pll_r << PLLR_SHIFT);
 	snd_soc_write(codec, AIC3X_PLL_PROGB_REG, pll_j << PLLJ_SHIFT);
--- a/sound/soc/codecs/tlv320aic3x.h
+++ b/sound/soc/codecs/tlv320aic3x.h
@@ -166,6 +166,7 @@
 
 /* PLL registers bitfields */
 #define PLLP_SHIFT		0
+#define PLLP_MASK		7
 #define PLLQ_SHIFT		3
 #define PLLR_SHIFT		0
 #define PLLJ_SHIFT		2


