Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0FWOla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:41:30 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47583 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0FWOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KweXRH5e+rGfmg3AnWSHm+d+tkhGmZS3aX+MKiP4Z9OoY1p6r/GVfc8vLLpFm0ZiAA
         65rXh/qxP66jJZg2Ka6nnmogMalxM5AlqgCe9p2tKvMg8UE+a7GQE7Y3rGrj4OIPCIj7
         ftP9olIU8G8nTjQGwGjsl7oFRszq0UTZ0AV3Y=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: DaVinci: Added support for stereo I2S
Date: Wed, 23 Jun 2010 16:33:54 +0200
Message-Id: <1277303635-5675-1-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

	Added audio playback support with [frame sync master - clock master] mode
	and with [frame sync master - clock slave].
	Clock slave can be important when the external codec need system clock
	and bit clock synchronized.
	In the clock master case there is a FIXME message in the source code, because we
	(Davide and myself) have guessed a frequency of 122000000 that seems the base
	to be divided.
	This patch has been developed against the
		http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
	git tree and has been tested on bmx board (similar to dm365 evm, but using
	uda1345 as external audio codec).

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 arch/arm/mach-davinci/include/mach/asp.h |    7 ++
 sound/soc/davinci/davinci-i2s.c          |  141 ++++++++++++++++++++++++++----
 2 files changed, 129 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/arch/arm/mach-davinci/include/mach/asp.h
index 834725f..b1faeb9 100644
--- a/arch/arm/mach-davinci/include/mach/asp.h
+++ b/arch/arm/mach-davinci/include/mach/asp.h
@@ -63,6 +63,13 @@ struct snd_platform_data {
 	unsigned sram_size_playback;
 	unsigned sram_size_capture;
 
+	/*
+	 * This define works when both clock and FS are output for the cpu
+	 * and makes clock very fast (FS is not simmetrical, but sampling
+	 * frequency is better approximated
+	 */
+	int i2s_fast_clock;
+
 	/* McASP specific fields */
 	int tdm_slots;
 	u8 op_mode;
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index adadcd3..8811d25 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -68,16 +68,23 @@
 #define DAVINCI_MCBSP_RCR_RDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_RCR_RFIG		(1 << 18)
 #define DAVINCI_MCBSP_RCR_RWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_RCR_RFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_RCR_RPHASE		(1 << 31)
 
 #define DAVINCI_MCBSP_XCR_XWDLEN1(v)	((v) << 5)
 #define DAVINCI_MCBSP_XCR_XFRLEN1(v)	((v) << 8)
 #define DAVINCI_MCBSP_XCR_XDATDLY(v)	((v) << 16)
 #define DAVINCI_MCBSP_XCR_XFIG		(1 << 18)
 #define DAVINCI_MCBSP_XCR_XWDLEN2(v)	((v) << 21)
+#define DAVINCI_MCBSP_XCR_XFRLEN2(v)	((v) << 24)
+#define DAVINCI_MCBSP_XCR_XPHASE	(1 << 31)
 
+
+#define CLKGDV(v)				(v)     /* Bits 0:7 */
 #define DAVINCI_MCBSP_SRGR_FWID(v)	((v) << 8)
 #define DAVINCI_MCBSP_SRGR_FPER(v)	((v) << 16)
 #define DAVINCI_MCBSP_SRGR_FSGM		(1 << 28)
+#define DAVINCI_MCBSP_SRGR_CLKSM	(1 << 29)
 
 #define DAVINCI_MCBSP_PCR_CLKRP		(1 << 0)
 #define DAVINCI_MCBSP_PCR_CLKXP		(1 << 1)
@@ -144,8 +151,17 @@ struct davinci_mcbsp_dev {
 	 * won't end up being swapped because of the underrun.
 	 */
 	unsigned enable_channel_combine:1;
+
+	int i2s_fast_clock;
+};
+
+struct davinci_mcbsp_data {
+	unsigned int	fmt;
+	int             clk_div;
 };
 
+static struct davinci_mcbsp_data mcbsp_data;
+
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
 					   int reg, u32 val)
 {
@@ -255,24 +271,27 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	unsigned int pcr;
 	unsigned int srgr;
 	srgr = DAVINCI_MCBSP_SRGR_FSGM |
-		DAVINCI_MCBSP_SRGR_FPER(DEFAULT_BITPERSAMPLE * 2 - 1) |
-		DAVINCI_MCBSP_SRGR_FWID(DEFAULT_BITPERSAMPLE - 1);
+	       DAVINCI_MCBSP_SRGR_FPER(DEFAULT_BITPERSAMPLE * 2 - 1) |
+	       DAVINCI_MCBSP_SRGR_FWID(DEFAULT_BITPERSAMPLE - 1);
+	/* Attention srgr is updated by hw_params! */
 
+	mcbsp_data.fmt = fmt;
 	/* set master/slave audio interface */
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFM:
 	case SND_SOC_DAIFMT_CBS_CFS:
 		/* cpu is master */
 		pcr = DAVINCI_MCBSP_PCR_FSXM |
-			DAVINCI_MCBSP_PCR_FSRM |
-			DAVINCI_MCBSP_PCR_CLKXM |
-			DAVINCI_MCBSP_PCR_CLKRM;
+		      DAVINCI_MCBSP_PCR_FSRM |
+		      DAVINCI_MCBSP_PCR_CLKXM |
+		      DAVINCI_MCBSP_PCR_CLKRM;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		/* McBSP CLKR pin is the input for the Sample Rate Generator.
 		 * McBSP FSR and FSX are driven by the Sample Rate Generator. */
 		pcr = DAVINCI_MCBSP_PCR_SCLKME |
-			DAVINCI_MCBSP_PCR_FSXM |
-			DAVINCI_MCBSP_PCR_FSRM;
+		      DAVINCI_MCBSP_PCR_FSXM |
+		      DAVINCI_MCBSP_PCR_FSRM;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		/* codec is master */
@@ -372,6 +391,17 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 	return 0;
 }
 
+static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
+				int div_id, int div)
+{
+	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
+	int srgr;
+
+	mcbsp_data.clk_div = div;
+	return 0;
+}
+
+
 static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *params,
 				 struct snd_soc_dai *dai)
@@ -380,11 +410,12 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
+	struct clk *clk;
 
 	/* general line settings */
 	spcr = davinci_mcbsp_read_reg(dev, DAVINCI_MCBSP_SPCR_REG);
@@ -396,12 +427,60 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_SPCR_REG, spcr);
 	}
 
-	i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_SAMPLE_BITS);
-	srgr = DAVINCI_MCBSP_SRGR_FSGM;
-	srgr |= DAVINCI_MCBSP_SRGR_FWID(snd_interval_value(i) - 1);
+	master = mcbsp_data.fmt & SND_SOC_DAIFMT_MASTER_MASK;
+	fmt = params_format(params);
+	mcbsp_word_length = asp_word_length[fmt];
 
-	i = hw_param_interval(params, SNDRV_PCM_HW_PARAM_FRAME_BITS);
-	srgr |= DAVINCI_MCBSP_SRGR_FPER(snd_interval_value(i) - 1);
+	if (master == SND_SOC_DAIFMT_CBS_CFS) {
+		clk = clk_get(NULL, "pll1_sysclk6");
+		if (clk)
+			freq = clk_get_rate(clk);
+		freq = 122000000; /* FIXME ask to Texas */
+		if (dev->i2s_fast_clock) {
+			clk_div = 256;
+			do {
+				framesize = (freq / (--clk_div)) /
+					    params->rate_num *
+					    params->rate_den;
+			} while (((framesize < 33) || (framesize > 4095)) &&
+				 (clk_div));
+			clk_div--;
+			srgr = DAVINCI_MCBSP_SRGR_FSGM |
+			       DAVINCI_MCBSP_SRGR_CLKSM;
+			srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
+							8 - 1);
+			srgr |= DAVINCI_MCBSP_SRGR_FPER(framesize - 1);
+		} else {
+			/* simmetric waveforms */
+			srgr = DAVINCI_MCBSP_SRGR_FSGM |
+			       DAVINCI_MCBSP_SRGR_CLKSM;
+			srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
+							8 - 1);
+			srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
+							16 - 1);
+			clk_div = freq / (mcbsp_word_length * 16) /
+				  params->rate_num * params->rate_den;
+		}
+		clk_div &= 0xFF;
+		srgr |= clk_div;
+	} else if (master == SND_SOC_DAIFMT_CBS_CFM) {
+		/* Clock given on CLKS */
+		srgr = DAVINCI_MCBSP_SRGR_FSGM;
+		clk_div = mcbsp_data.clk_div - 1;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length * 8 - 1);
+		srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length * 16 - 1);
+		clk_div &= 0xFF;
+		srgr |= clk_div;
+	} else {
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
@@ -426,22 +505,45 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
+			/* FIXME ask to Texas */
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
+		/* FIXME ask to Texas */
+		rcr |= DAVINCI_MCBSP_RCR_RFRLEN1(element_cnt - 1);
+		xcr |= DAVINCI_MCBSP_XCR_XFRLEN1(element_cnt - 1);
+	}
 
 	rcr |= DAVINCI_MCBSP_RCR_RWDLEN1(mcbsp_word_length) |
-		DAVINCI_MCBSP_RCR_RWDLEN2(mcbsp_word_length);
+	       DAVINCI_MCBSP_RCR_RWDLEN2(mcbsp_word_length);
 	xcr |= DAVINCI_MCBSP_XCR_XWDLEN1(mcbsp_word_length) |
-		DAVINCI_MCBSP_XCR_XWDLEN2(mcbsp_word_length);
+	       DAVINCI_MCBSP_XCR_XWDLEN2(mcbsp_word_length);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_XCR_REG, xcr);
 	else
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_RCR_REG, rcr);
+
+	pr_debug("%s - %d  srgr=%X\n", __func__, __LINE__, srgr);
+	pr_debug("%s - %d  xcr=%X\n", __func__, __LINE__, xcr);
+	pr_debug("%s - %d  rcr=%X\n", __func__, __LINE__, rcr);
 	return 0;
 }
 
@@ -500,7 +602,7 @@ static struct snd_soc_dai_ops davinci_i2s_dai_ops = {
 	.trigger	= davinci_i2s_trigger,
 	.hw_params	= davinci_i2s_hw_params,
 	.set_fmt	= davinci_i2s_set_dai_fmt,
-
+	.set_clkdiv = davinci_i2s_dai_set_clkdiv,
 };
 
 struct snd_soc_dai davinci_i2s_dai = {
@@ -548,6 +650,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	}
 	if (pdata) {
 		dev->enable_channel_combine = pdata->enable_channel_combine;
+		dev->i2s_fast_clock = pdata->i2s_fast_clock;
 		dev->dma_params[SNDRV_PCM_STREAM_PLAYBACK].sram_size =
 			pdata->sram_size_playback;
 		dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].sram_size =
-- 
1.7.0.4

