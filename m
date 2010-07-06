Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0GFIjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:39:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57916 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0GFIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZAgN3f0EDikzAeQVxhoTu+XUIRXj3OVSRCzqRxRGtPnR2WYuC4Tp8qYupO3lkD3VMy
         F8eWSl3KSKCUXHjVVTHJX3a5Cev9fK+oUISzKJwUnYpDL1rVD/izb/wFJf7RaeK4Um7O
         3RcFmm8VYkBJO8ArmbgHg5xsOtuMHfLtlkDZg=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: sudhakar.raj@ti.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 3/3] ASoC: DaVinci: More accurate continuous serial clock for McBSP (I2S)
Date: Tue,  6 Jul 2010 10:39:04 +0200
Message-Id: <1278405544-3852-4-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278405544-3852-1-git-send-email-lamiaposta71@gmail.com>
References: <1278405544-3852-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

    i2s_accurate_sck switch can be used to have a better approximate
    sampling frequency.
    The clock is an externally visible bit clock and it is named
    i2s continuous serial clock (I2S_SCK).
    The trade off is between more accurate clock (fast clock)
    and less accurate clock (slow clock).
    The waveform will be not symmetric.
    Probably it is possible to get a better algorithm for calculating
    the divider, trying to keep a slower clock as possible.

    This patch has been developed against the
        http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
    git tree and has been tested on bmx board (similar to dm365 evm, but using
    uda1345 as external audio codec).

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
---
 arch/arm/mach-davinci/include/mach/asp.h |   33 ++++++++++++++++++++++++++++++
 sound/soc/davinci/davinci-i2s.c          |   24 +++++++++++++++++----
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/arch/arm/mach-davinci/include/mach/asp.h
index 0847d21..b12c69e 100644
--- a/arch/arm/mach-davinci/include/mach/asp.h
+++ b/arch/arm/mach-davinci/include/mach/asp.h
@@ -73,6 +73,39 @@ struct snd_platform_data {
 	 */
 	int clk_input_pin;
 
+	/*
+	 * This flag works when both clock and FS are outputs for the cpu
+	 * and makes clock more accurate (FS is not symmetrical and the
+	 * clock is very fast.
+	 * The clock becoming faster is named
+	 * i2s continuous serial clock (I2S_SCK) and it is an externally
+	 * visible bit clock.
+	 *
+	 * first line : WordSelect
+	 * second line : ContinuousSerialClock
+	 * third line: SerialData
+	 *
+	 * SYMMETRICAL APPROACH:
+	 *   _______________________          LEFT
+	 * _|         RIGHT         |______________________|
+	 *     _   _         _   _   _   _         _   _
+	 *   _| |_| |_ x16 _| |_| |_| |_| |_ x16 _| |_| |_
+	 *     _   _         _   _   _   _         _   _
+	 *   _/ \_/ \_ ... _/ \_/ \_/ \_/ \_ ... _/ \_/ \_
+	 *    \_/ \_/       \_/ \_/ \_/ \_/       \_/ \_/
+	 *
+	 * ACCURATE CLOCK APPROACH:
+	 *   ______________          LEFT
+	 * _|     RIGHT    |_______________________________|
+	 *     _         _   _         _   _   _   _   _   _
+	 *   _| |_ x16 _| |_| |_ x16 _| |_| |_| |_| |_| |_| |
+	 *     _         _   _          _      dummy cycles
+	 *   _/ \_ ... _/ \_/ \_  ... _/ \__________________
+	 *    \_/       \_/ \_/        \_/
+	 *
+	 */
+	bool i2s_accurate_sck;
+
 	/* McASP specific fields */
 	int tdm_slots;
 	u8 op_mode;
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index ba5644b..b251bc9 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -155,6 +155,7 @@ struct davinci_mcbsp_dev {
 	unsigned int fmt;
 	int clk_div;
 	int clk_input_pin;
+	bool i2s_accurate_sck;
 };
 
 static inline void davinci_mcbsp_write_reg(struct davinci_mcbsp_dev *dev,
@@ -447,11 +448,23 @@ static int davinci_i2s_hw_params(struct snd_pcm_substream *substream,
 		       DAVINCI_MCBSP_SRGR_CLKSM;
 		srgr |= DAVINCI_MCBSP_SRGR_FWID(mcbsp_word_length *
 						8 - 1);
-		/* symmetric waveforms */
-		clk_div = freq / (mcbsp_word_length * 16) /
-			  params->rate_num * params->rate_den;
-		srgr |= DAVINCI_MCBSP_SRGR_FPER(mcbsp_word_length *
-						16 - 1);
+		if (dev->i2s_accurate_sck) {
+			clk_div = 256;
+			do {
+				framesize = (freq / (--clk_div)) /
+				params->rate_num *
+					params->rate_den;
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
@@ -662,6 +675,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 		dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].sram_size =
 			pdata->sram_size_capture;
 		dev->clk_input_pin = pdata->clk_input_pin;
+		dev->i2s_accurate_sck = pdata->i2s_accurate_sck;
 	}
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
-- 
1.7.0.4

