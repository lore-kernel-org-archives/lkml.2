Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0F3NsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:48:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab0F3NsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oirLGkG5LW14UENAIgtoPmfcYix0OX3j/tl7aL91wPOHvcKahKoYDdvdDZ+A3Fjf3A
         mdhrgMsGlCbNS1axw3ieAZUsqZfGIouvLtvptZGocXNupHDHboxNi70PrdpzjURv4O9F
         ZBxO6SsU5SpTLlheE4R5ECvvbW+DmqYwCK0WM=
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
Subject: [PATCH 2/3] ASoC: DaVinci: Added selection of clk input pin for McBSP
Date: Wed, 30 Jun 2010 15:47:57 +0200
Message-Id: <1277905678-4695-3-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
References: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    When McBSP peripheral gets the clock from an external pin,
    there are three possible chooses, MCBSP_CLKX, MCBSP_CLKR
    and MCBSP_CLKS.
    evm-dm365 uses MCBSP_CLKR, instead in bmx board I have a different
    hardware connection and I use MCBSP_CLKS, so I have added
    this possibility.

    This patch has been developed against the:
        http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and has been tested on bmx board (similar to dm365 evm)

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 arch/arm/mach-davinci/include/mach/asp.h |    8 ++++++++
 sound/soc/davinci/davinci-i2s.c          |   28 +++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/arch/arm/mach-davinci/include/mach/asp.h
index 834725f..314570d 100644
--- a/arch/arm/mach-davinci/include/mach/asp.h
+++ b/arch/arm/mach-davinci/include/mach/asp.h
@@ -63,6 +63,9 @@ struct snd_platform_data {
 	unsigned sram_size_playback;
 	unsigned sram_size_capture;
 
+	/* To be used when cpu gets clock from external pin */
+	int clk_input_pin;
+
 	/* McASP specific fields */
 	int tdm_slots;
 	u8 op_mode;
@@ -78,6 +81,11 @@ enum {
 	MCASP_VERSION_2,	/* DA8xx/OMAPL1x */
 };
 
+enum {
+	MCBSP_CLKR = 0,		/* DM365 */
+	MCBSP_CLKS,
+};
+
 #define INACTIVE_MODE	0
 #define TX_MODE		1
 #define RX_MODE		2
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index 319e8ca..e478be9 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -152,6 +152,7 @@ struct davinci_mcbsp_dev {
 
 	unsigned int fmt;
 	int clk_div;
+	int clk_input_pin;
 };
 
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
@@ -278,11 +279,26 @@ static int davinci_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 			DAVINCI_MCBSP_PCR_CLKRM;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
-		/* McBSP CLKR pin is the input for the Sample Rate Generator.
-		 * McBSP FSR and FSX are driven by the Sample Rate Generator. */
-		pcr = DAVINCI_MCBSP_PCR_SCLKME |
-			DAVINCI_MCBSP_PCR_FSXM |
-			DAVINCI_MCBSP_PCR_FSRM;
+		pcr = DAVINCI_MCBSP_PCR_FSRM | DAVINCI_MCBSP_PCR_FSXM;
+		/*
+		 * Selection of the clock input pin that is the
+		 * input for the Sample Rate Generator.
+		 * McBSP FSR and FSX are driven by the Sample Rate
+		 * Generator.
+		 */
+		switch (dev->clk_input_pin) {
+		case MCBSP_CLKS:
+			pcr |= DAVINCI_MCBSP_PCR_CLKXM |
+				DAVINCI_MCBSP_PCR_CLKRM;
+			break;
+		case MCBSP_CLKR:
+			pcr |= DAVINCI_MCBSP_PCR_SCLKME;
+			break;
+		default:
+			printk(KERN_ERR "%s:bad clk_input_pin\n", __func__);
+			return -EINVAL;
+		}
+
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		/* codec is master */
@@ -436,6 +452,7 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		srgr |= clk_div;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
+		/* Clock given on CLKS */
 		srgr = DAVINCI_MCBSP_SRGR_FSGM;
 		clk_div = dev->clk_div - 1;
 		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length * 8 - 1);
@@ -626,6 +643,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 			pdata->sram_size_playback;
 		dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].sram_size =
 			pdata->sram_size_capture;
+		dev->clk_input_pin = pdata->clk_input_pin;
 	}
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
-- 
1.7.0.4

