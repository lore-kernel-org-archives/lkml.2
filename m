Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0F3NsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:48:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0F3NsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PswctX3MySJGhxcgpUSTpo+Y/uKivMZUZM53Y/+c5AOHxwOgtekDNx5/oVuDU4vJG3
         OBSA97QHuiVAnEpYiUZNTEGC/+G2LnaBQrFBE8my+XZn+nKl20S/E7PcmvwUd0G/Dlue
         WhrKit4LXCptF4KoVpY/gTvsgGRw7wJoplJJ0=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ASoC: DaVinci: Added two clocking possibilities to McBSP (I2S)
Date: Wed, 30 Jun 2010 15:47:56 +0200
Message-Id: <1277905678-4695-2-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
References: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
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
 sound/soc/davinci/davinci-i2s.c |   92 +++++++++++++++++++++++++++++++++++----
 1 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index adadcd3..319e8ca 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -68,16 +68,21 @@
 #define DAVINCI_MCBSP_RCR_RDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_RCR_RFIG		(1 << 18)
 #define DAVINCI_MCBSP_RCR_RWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_RCR_RFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_RCR_RPHASE	(1 << 31)
 
 #define DAVINCI_MCBSP_XCR_XWDLEN1(v)	((v) << 5)
 #define DAVINCI_MCBSP_XCR_XFRLEN1(v)	((v) << 8)
 #define DAVINCI_MCBSP_XCR_XDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_XCR_XFIG		(1 << 18)
 #define DAVINCI_MCBSP_XCR_XWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_XCR_XFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_XCR_XPHASE	(1 << 31)
 
 #define DAVINCI_MCBSP_SRGR_FWID(v)	((v) << 8)
 #define DAVINCI_MCBSP_SRGR_FPER(v)	((v) << 16)
 #define DAVINCI_MCBSP_SRGR_FSGM		(1 << 28)
+#define DAVINCI_MCBSP_SRGR_CLKSM	(1 << 29)
 
 #define DAVINCI_MCBSP_PCR_CLKRP		(1 << 0)
 #define DAVINCI_MCBSP_PCR_CLKXP		(1 << 1)
@@ -144,6 +149,9 @@ struct davinci_mcbsp_dev {
 	 * won't end up being swapped because of the underrun.
 	 */
 	unsigned enable_channel_combine:1;
+
+	unsigned int fmt;
+	int clk_div;
 };
 
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
@@ -254,10 +262,12 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
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
@@ -372,6 +382,16 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	return 0;
 }
 
+static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
+				int div_id, int div)
+{
+	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
+	int srgr;
+
+	dev->clk_div = div;
+	return 0;
+}
+
 static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *params,
 				 struct snd_soc_dai *dai)
@@ -380,8 +400,8 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
@@ -396,12 +416,44 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
+	default:
+		/* Clock and frame sync given from external sources */
+		i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_SAMPLE_BITS);
+		srgr = DAVINCI_MCBSP_SRGR_FSGM;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(snd_interval_value(i) - 1);
+		pr_debug("%s - %d  FWID set: re-read srgr = %X\n",
+			__func__, __LINE__, snd_interval_value(i) - 1);
+
+		i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_FRAME_BITS);
+		srgr |= DAVINCI_MCBSP_SRGR_FPER(snd_interval_value(i) - 1);
+	}
 	davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_SRGR_REG, srgr);
 
 	rcr = DAVINCI_MCBSP_RCR_RFIG;
@@ -426,12 +478,29 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 			element_cnt = 1;
 			fmt = double_fmt[fmt];
 		}
+		if (master == SND_SOC_DAIFMT_CBS_CFS ||
+				master == SND_SOC_DAIFMT_CBS_CFM) {
+			rcr |= DAVINCI_MCBSP_RCR_RFRLEN2(0);
+			xcr |= DAVINCI_MCBSP_XCR_XFRLEN2(0);
+			rcr |= DAVINCI_MCBSP_RCR_RPHASE;
+			xcr |= DAVINCI_MCBSP_XCR_XPHASE;
+		} else {
+			rcr |= DAVINCI_MCBSP_RCR_RFRLEN2(element_cnt - 1);
+			xcr |= DAVINCI_MCBSP_XCR_XFRLEN2(element_cnt - 1);
+		}
 	}
 	dma_params->acnt = dma_params->data_type = data_type[fmt];
 	dma_params->fifo_level = 0;
 	mcbsp_word_length = asp_word_length[fmt];
-	rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(element_cnt - 1);
-	xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(element_cnt - 1);
+
+	if (master == SND_SOC_DAIFMT_CBS_CFS ||
+			master == SND_SOC_DAIFMT_CBS_CFM) {
+		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(0);
+		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(0);
+	} else {
+		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(element_cnt - 1);
+		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(element_cnt - 1);
+	}
 
 	rcr |= DAVINCI_MCBSP_RCR_RWDLEN1(mcbsp_word_length) |
 		DAVINCI_MCBSP_RCR_RWDLEN2(mcbsp_word_length);
@@ -442,6 +511,10 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_XCR_REG, xcr);
 	else
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_RCR_REG, rcr);
+
+	pr_debug("%s - %d  srgr=%X\n", __func__, __LINE__, srgr);
+	pr_debug("%s - %d  xcr=%X\n", __func__, __LINE__, xcr);
+	pr_debug("%s - %d  rcr=%X\n", __func__, __LINE__, rcr);
 	return 0;
 }
 
@@ -500,6 +573,7 @@ static struct snd_soc_dai_ops davinci_i2s_dai_ops = {
 	.trigger	= davinci_i2s_trigger,
 	.hw_params	= davinci_i2s_hw_params,
 	.set_fmt	= davinci_i2s_set_dai_fmt,
+	.set_clkdiv	= davinci_i2s_dai_set_clkdiv,
 
 };
 
-- 
1.7.0.4

