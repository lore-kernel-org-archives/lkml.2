Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0F3NsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:48:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52203 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab0F3NsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qfSOEuZzo9staszsZzg+cG/6hjY6lTpYrJZD1Kbgk5Sc2nyPrvLo86uNHpuym9yL0l
         dYLQKOkSoqxertmW/NLGPGVLcUhSgkm38l7zsNEAtheAzXBx8w/MMjTM4SDmRQQd4M24
         arWLHcaBqJbHowPKh8s3Yv9I22c+JDQuuYVsw=
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
Subject: [PATCH 3/3] ASoC: DaVinci: Added fast clock timing for McBSP (I2S)
Date: Wed, 30 Jun 2010 15:47:58 +0200
Message-Id: <1277905678-4695-4-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
References: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    i2s_fast_clock switch can be used to have a better approximate
    frequency.
    The waveform will be not symmetric.

    This patch has been developed against the
        http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and has been tested on bmx board (similar to dm365 evm, but using
    uda1345 as external audio codec).

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 arch/arm/mach-davinci/include/mach/asp.h |    7 +++++++
 sound/soc/davinci/davinci-i2s.c          |   24 +++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/arch/arm/mach-davinci/include/mach/asp.h
index 314570d..2d8f8af 100644
--- a/arch/arm/mach-davinci/include/mach/asp.h
+++ b/arch/arm/mach-davinci/include/mach/asp.h
@@ -63,6 +63,13 @@ struct snd_platform_data {
 	unsigned sram_size_playback;
 	unsigned sram_size_capture;
 
+	/*
+	 * This define works when both clock and FS are output for the cpu
+	 * and makes clock very fast (FS is not symmetrical, but sampling
+	 * frequency is better approximated
+	 */
+	bool i2s_fast_clock;
+
 	/* To be used when cpu gets clock from external pin */
 	int clk_input_pin;
 
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index e478be9..0af5bae 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -150,6 +150,7 @@ struct davinci_mcbsp_dev {
 	 */
 	unsigned enable_channel_combine:1;
 
+	bool i2s_fast_clock;
 	unsigned int fmt;
 	int clk_div;
 	int clk_input_pin;
@@ -443,11 +444,23 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		       DAVINCI_MCBSP_SRGR_CLKSM;
 		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
 						8 - 1);
-		/* symmetric waveforms */
-		clk_div = freq / (mcbsp_word_length * 16) /
-			  params->rate_num * params->rate_den;
-		srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
-						16 - 1);
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
 		clk_div &= 0xFF;
 		srgr |= clk_div;
 		break;
@@ -643,6 +656,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 			pdata->sram_size_playback;
 		dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].sram_size =
 			pdata->sram_size_capture;
+		dev->i2s_fast_clock = pdata->i2s_fast_clock;
 		dev->clk_input_pin = pdata->clk_input_pin;
 	}
 	dev->clk = clk_get(&pdev->dev, NULL);
-- 
1.7.0.4

