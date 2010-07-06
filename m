Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0GFIjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:39:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51202 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab0GFIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RlsrsxeolG3dtLtHnRU13LNQ9Li0/7H0ADLHVKt4Gg9x3hds4HRBqt5yluwchQAn4b
         3yqG/+a95I84lOkJKfboeH/JVnl37agY3th0jWFSmJxDmVz+Xp2LqMbtK6I82ANTLaLX
         cast8rSQY+hC9GXlaVwi/+gwJwqnUzHEg+tz4=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: sudhakar.raj@ti.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ASoC: DaVinci: Added two clocking possibilities to McBSP (I2S)
Date: Tue,  6 Jul 2010 10:39:02 +0200
Message-Id: <1278405544-3852-2-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278405544-3852-1-git-send-email-lamiaposta71@gmail.com>
References: <1278405544-3852-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    Added two clocking options for dm365 McBSP peripheral when used
    with I2S timings, that are SND_SOC_DAIFMT_CBS_CFS (the cpu generates
    clock and frame sync) and SND_SOC_DAIFMT_CBS_CFM (the cpu gets clock
    from external pin and generates frame sync).
    A slave clock management can be important when the external codec needs
    the system clock and the bit clock synchronized (tested with uda1345).
    This patch has been developed against the:
        http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and has been tested on bmx board (similar to dm365 evm, but using
    uda1345 as external audio codec).

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 sound/soc/davinci/davinci-i2s.c |  110 +++++++++++++++++++++++++++++++++++---
 sound/soc/davinci/davinci-i2s.h |    5 ++
 2 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index adadcd3..c8f038c 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -26,6 +26,7 @@
 #include <mach/asp.h>
 
 #include "davinci-pcm.h"
+#include "davinci-i2s.h"
 
 
 /*
@@ -68,16 +69,21 @@
 #define DAVINCI_MCBSP_RCR_RDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_RCR_RFIG		(1 << 18)
 #define DAVINCI_MCBSP_RCR_RWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_RCR_RFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_RCR_RPHASE	BIT(31)
 
 #define DAVINCI_MCBSP_XCR_XWDLEN1(v)	((v) << 5)
 #define DAVINCI_MCBSP_XCR_XFRLEN1(v)	((v) << 8)
 #define DAVINCI_MCBSP_XCR_XDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_XCR_XFIG		(1 << 18)
 #define DAVINCI_MCBSP_XCR_XWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_XCR_XFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_XCR_XPHASE	BIT(31)
 
 #define DAVINCI_MCBSP_SRGR_FWID(v)	((v) << 8)
 #define DAVINCI_MCBSP_SRGR_FPER(v)	((v) << 16)
 #define DAVINCI_MCBSP_SRGR_FSGM		(1 << 28)
+#define DAVINCI_MCBSP_SRGR_CLKSM	BIT(29)
 
 #define DAVINCI_MCBSP_PCR_CLKRP		(1 << 0)
 #define DAVINCI_MCBSP_PCR_CLKXP		(1 << 1)
@@ -144,6 +150,9 @@ struct davinci_mcbsp_dev {
 	 * won't end up being swapped because of the underrun.
 	 */
 	unsigned enable_channel_combine:1;
+
+	unsigned int fmt;
+	int clk_div;
 };
 
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
@@ -254,10 +263,12 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
 	unsigned int pcr;
 	unsigned int srgr;
+	/* Attention srgr is updated by hw_params! */
 	srgr = DAVINCI_MCBSP_SRGR_FSGM |
 		DAVINCI_MCBSP_SRGR_FPER(DEFAULT_BITPERSAMPLE * 2 - 1) |
 		DAVINCI_MCBSP_SRGR_FWID(DEFAULT_BITPERSAMPLE - 1);
 
+	dev->fmt = fmt;
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBS_CFS:
@@ -372,6 +383,18 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	return 0;
 }
 
+static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
+				int div_id, int div)
+{
+	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
+
+	if (div_id != DAVINCI_MCBSP_CLKGDV)
+		return -ENODEV;
+
+	dev->clk_div = div;
+	return 0;
+}
+
 static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *params,
 				 struct snd_soc_dai *dai)
@@ -380,8 +403,8 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 	struct davinci_pcm_dma_params *dma_params =
 					&dev->dma_params[substream->stream];
 	struct snd_interval *i = NULL;
-	int mcbsp_word_length;
-	unsigned int rcr, xcr, srgr;
+	int mcbsp_word_length, master;
+	unsigned int rcr, xcr, srgr, clk_div, freq, framesize;
 	u32 spcr;
 	snd_pcm_format_t fmt;
 	unsigned element_cnt = 1;
@@ -396,12 +419,47 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_SPCR_REG, spcr);
 	}
 
-	i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_SAMPLE_BITS);
-	srgr = DAVINCI_MCBSP_SRGR_FSGM;
-	srgr |= DAVINCI_MCBSP_SRGR_FWID(snd_interval_value(i) - 1);
+	master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
+	fmt = params_format(params);
+	mcbsp_word_length = asp_word_length[fmt];
 
-	i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_FRAME_BITS);
-	srgr |= DAVINCI_MCBSP_SRGR_FPER(snd_interval_value(i) - 1);
+	switch (master) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		freq = clk_get_rate(dev->clk);
+		srgr = DAVINCI_MCBSP_SRGR_FSGM |
+		       DAVINCI_MCBSP_SRGR_CLKSM;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
+						8 - 1);
+		/* symmetric waveforms */
+		clk_div = freq / (mcbsp_word_length * 16) /
+			  params->rate_num * params->rate_den;
+		srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
+						16 - 1);
+		clk_div &= 0xFF;
+		srgr |= clk_div;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		srgr = DAVINCI_MCBSP_SRGR_FSGM;
+		clk_div = dev->clk_div - 1;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length * 8 - 1);
+		srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length * 16 - 1);
+		clk_div &= 0xFF;
+		srgr |= clk_div;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		/* Clock and frame sync given from external sources */
+		i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_SAMPLE_BITS);
+		srgr = DAVINCI_MCBSP_SRGR_FSGM;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(snd_interval_value(i) - 1);
+		pr_debug("%s - %d  FWID set: re-read srgr = %X\n",
+			__func__, __LINE__, snd_interval_value(i) - 1);
+
+		i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_FRAME_BITS);
+		srgr |= DAVINCI_MCBSP_SRGR_FPER(snd_interval_value(i) - 1);
+		break;
+	default:
+		return -EINVAL;
+	}
 	davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_SRGR_REG, srgr);
 
 	rcr = DAVINCI_MCBSP_RCR_RFIG;
@@ -426,12 +484,41 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 			element_cnt = 1;
 			fmt = double_fmt[fmt];
 		}
+		switch (master) {
+		case SND_SOC_DAIFMT_CBS_CFS:
+		case SND_SOC_DAIFMT_CBS_CFM:
+			rcr |= DAVINCI_MCBSP_RCR_RFRLEN2(0);
+			xcr |= DAVINCI_MCBSP_XCR_XFRLEN2(0);
+			rcr |= DAVINCI_MCBSP_RCR_RPHASE;
+			xcr |= DAVINCI_MCBSP_XCR_XPHASE;
+			break;
+		case SND_SOC_DAIFMT_CBM_CFM:
+		case SND_SOC_DAIFMT_CBM_CFS:
+			rcr |= DAVINCI_MCBSP_RCR_RFRLEN2(element_cnt - 1);
+			xcr |= DAVINCI_MCBSP_XCR_XFRLEN2(element_cnt - 1);
+			break;
+		default:
+			return -EINVAL;
+		}
 	}
 	dma_params->acnt = dma_params->data_type = data_type[fmt];
 	dma_params->fifo_level = 0;
 	mcbsp_word_length = asp_word_length[fmt];
-	rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(element_cnt - 1);
-	xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(element_cnt - 1);
+
+	switch (master) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+	case SND_SOC_DAIFMT_CBS_CFM:
+		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(0);
+		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(0);
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+	case SND_SOC_DAIFMT_CBM_CFS:
+		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(element_cnt - 1);
+		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(element_cnt - 1);
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	rcr |= DAVINCI_MCBSP_RCR_RWDLEN1(mcbsp_word_length) |
 		DAVINCI_MCBSP_RCR_RWDLEN2(mcbsp_word_length);
@@ -442,6 +529,10 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_XCR_REG, xcr);
 	else
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_RCR_REG, rcr);
+
+	pr_debug("%s - %d  srgr=%X\n", __func__, __LINE__, srgr);
+	pr_debug("%s - %d  xcr=%X\n", __func__, __LINE__, xcr);
+	pr_debug("%s - %d  rcr=%X\n", __func__, __LINE__, rcr);
 	return 0;
 }
 
@@ -500,6 +591,7 @@ static struct snd_soc_dai_ops davinci_i2s_dai_ops = {
 	.trigger	= davinci_i2s_trigger,
 	.hw_params	= davinci_i2s_hw_params,
 	.set_fmt	= davinci_i2s_set_dai_fmt,
+	.set_clkdiv	= davinci_i2s_dai_set_clkdiv,
 
 };
 
diff --git a/sound/soc/davinci/davinci-i2s.h b/sound/soc/davinci/davinci-i2s.h
index 241648c..0b1e77b 100644
--- a/sound/soc/davinci/davinci-i2s.h
+++ b/sound/soc/davinci/davinci-i2s.h
@@ -12,6 +12,11 @@
 #ifndef _DAVINCI_I2S_H
 #define _DAVINCI_I2S_H
 
+/* McBSP dividers */
+enum davinci_mcbsp_div {
+	DAVINCI_MCBSP_CLKGDV,              /* Sample rate generator divider */
+};
+
 extern struct snd_soc_dai davinci_i2s_dai;
 
 #endif
-- 
1.7.0.4

