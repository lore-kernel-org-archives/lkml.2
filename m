Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0F1Gos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:44:48 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59803 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0F1Goq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XIfAL11DS0XOWpEbyNTL+RwJrX+zHE6yutYzrrN1xZR1m07sdX3p1zskUPSnehd3mH
         jX/WthArLcKLI876UHdv1nELzT2NO5XJyoEC/C30AUk2w/aX8adEcvUKa2dTpuqRI0iq
         0y1nYfTs3pydisuXso8fODs7hsrqbAqPP6wo4=
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
Subject: [PATCH] ASoC: DaVinci: Added support for cpu clocking I2S
Date: Mon, 28 Jun 2010 08:44:46 +0200
Message-Id: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    Added audio playback support with [frame sync master - clock master] mode
    and with [frame sync master - clock slave].

    1. SND_SOC_DAIFMT_CBS_CFS (the cpu generates clock and frame sync)
       I need to clarify how the McBSP is clocked internally.
       Reading sprufi3a-1.pdf (TMS320DM36x DMSoC Multichannel Buffered Serial
       Port (McBSP) Interface) at "2.5.3 Data Clock Generation" paragraph this
       info not appears really clear if we are in the case of "McBSP internal
       input clock".
       I hope some Ti developers can help me.
       There is a FIXME message in the patch.

       i2s_fast_clock switch can be used to have better approximate or
       symmetric waveforms.
       clk_input_pin board info can be used to select it depending on hw
       connections

    2. SND_SOC_DAIFMT_CBS_CFM (the cpu get clock from external pin
                               and generates frame sync)
       Clock slave can be important when the external codec need system clock
       and bit clock synchronized (tested with uda1345).

    3. We haven't changed the evmdm365 support (due also to CPLD that doesn't
                                                help to understand)
        We don't know in this mode if audio stereo works on evmdm365.
        Probably it does.

	This patch has been developed against the
		http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
	git tree and has been tested on bmx board (similar to dm365 evm, but using
	uda1345 as external audio codec).

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 arch/arm/mach-davinci/include/mach/asp.h |   16 ++++
 sound/soc/davinci/davinci-i2s.c          |  126 ++++++++++++++++++++++++++----
 2 files changed, 128 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/arch/arm/mach-davinci/include/mach/asp.h
index 834725f..f9b6da2 100644
--- a/arch/arm/mach-davinci/include/mach/asp.h
+++ b/arch/arm/mach-davinci/include/mach/asp.h
@@ -63,6 +63,16 @@ struct snd_platform_data {
 	unsigned sram_size_playback;
 	unsigned sram_size_capture;
 
+	/*
+	 * This define works when both clock and FS are output for the cpu
+	 * and makes clock very fast (FS is not simmetrical, but sampling
+	 * frequency is better approximated
+	 */
+	int i2s_fast_clock;
+
+	/* To be used when cpu gets clock from extenal pin */
+	int clk_input_pin;
+
 	/* McASP specific fields */
 	int tdm_slots;
 	u8 op_mode;
@@ -78,6 +88,12 @@ enum {
 	MCASP_VERSION_2,	/* DA8xx/OMAPL1x */
 };
 
+enum {
+	MCBSP_CLKR = 0,		/* DM365 */
+	MCBSP_CLKS,
+};
+
+
 #define INACTIVE_MODE	0
 #define TX_MODE		1
 #define RX_MODE		2
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index adadcd3..786ade6 100644
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
@@ -144,6 +149,11 @@ struct davinci_mcbsp_dev {
 	 * won't end up being swapped because of the underrun.
 	 */
 	unsigned enable_channel_combine:1;
+
+	int i2s_fast_clock;
+	unsigned int fmt;
+	int clk_div;
+	int clk_input_pin;
 };
 
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
@@ -254,10 +264,12 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
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
@@ -268,11 +280,18 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 			DAVINCI_MCBSP_PCR_CLKRM;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
-		/* McBSP CLKR pin is the input for the Sample Rate Generator.
-		 * McBSP FSR and FSX are driven by the Sample Rate Generator. */
-		pcr = DAVINCI_MCBSP_PCR_SCLKME |
-			DAVINCI_MCBSP_PCR_FSXM |
-			DAVINCI_MCBSP_PCR_FSRM;
+		pcr = DAVINCI_MCBSP_PCR_FSRM | DAVINCI_MCBSP_PCR_FSXM;
+		if (dev->clk_input_pin == MCBSP_CLKS)
+			pcr |= DAVINCI_MCBSP_PCR_CLKXM |
+				DAVINCI_MCBSP_PCR_CLKRM;
+		else
+			/*
+			 * McBSP CLKR pin is the input for the Sample Rate
+			 * Generator.
+			 * McBSP FSR and FSX are driven by the Sample Rate
+			 * Generator.
+			 */
+			pcr |= DAVINCI_MCBSP_PCR_SCLKME;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		/* codec is master */
@@ -372,6 +391,16 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
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
@@ -380,11 +409,12 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
@@ -396,12 +426,56 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
+	if (master == SND_SOC_DAIFMT_CBS_CFS) {
+		clk = clk_get(NULL, "pll1_sysclk6");
+		if (clk)
+			freq = clk_get_rate(clk);
+		freq = 122000000; /* FIXME ask to Texas */
+		srgr = DAVINCI_MCBSP_SRGR_FSGM |
+		       DAVINCI_MCBSP_SRGR_CLKSM;
+		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
+						8 - 1);
+		if (dev->i2s_fast_clock) {
+			clk_div = 256;
+			do {
+				framesize = (freq / (--clk_div)) /
+					    params->rate_num *
+					    params->rate_den;
+			} while (((framesize < 33) || (framesize > 4095)) &&
+				 (clk_div));
+			clk_div--;
+			srgr |= DAVINCI_MCBSP_SRGR_FPER(framesize - 1);
+		} else {
+			/* symmetric waveforms */
+			clk_div = freq / (mcbsp_word_length * 16) /
+				  params->rate_num * params->rate_den;
+			srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
+							16 - 1);
+		}
+		clk_div &= 0xFF;
+		srgr |= clk_div;
+	} else if (master == SND_SOC_DAIFMT_CBM_CFS) {
+		/* Clock given on CLKS */
+		srgr = DAVINCI_MCBSP_SRGR_FSGM;
+		clk_div = dev->clk_div - 1;
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
@@ -426,12 +500,29 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
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
@@ -442,6 +533,10 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_XCR_REG, xcr);
 	else
 		davinci_mcbsp_write_reg(dev, DAVINCI_MCBSP_RCR_REG, rcr);
+
+	pr_debug("%s - %d  srgr=%X\n", __func__, __LINE__, srgr);
+	pr_debug("%s - %d  xcr=%X\n", __func__, __LINE__, xcr);
+	pr_debug("%s - %d  rcr=%X\n", __func__, __LINE__, rcr);
 	return 0;
 }
 
@@ -500,6 +595,7 @@ static struct snd_soc_dai_ops davinci_i2s_dai_ops = {
 	.trigger	= davinci_i2s_trigger,
 	.hw_params	= davinci_i2s_hw_params,
 	.set_fmt	= davinci_i2s_set_dai_fmt,
+	.set_clkdiv	= davinci_i2s_dai_set_clkdiv,
 
 };
 
@@ -552,6 +648,8 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 			pdata->sram_size_playback;
 		dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].sram_size =
 			pdata->sram_size_capture;
+		dev->i2s_fast_clock = pdata->i2s_fast_clock;
+		dev->clk_input_pin = pdata->clk_input_pin;
 	}
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
-- 
1.7.0.4

