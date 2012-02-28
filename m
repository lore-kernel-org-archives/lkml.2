Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2B1HaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:30:14 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:43202 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756119Ab2B1H2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:46 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 09/13] DMA:remove unnecessary dma configurations
Date: Tue, 28 Feb 2012 15:27:41 +0800
Message-Id: <1330414065-2949-10-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:29.0298 (UTC) FILETIME=[91220520:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.remove old unnecessary dma configurations

Change-Id: I3741d39ba643d7a6b95341e0ba695a689d18e147
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 sound/soc/pxa/mmp2-sspa.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/pxa/mmp2-sspa.c b/sound/soc/pxa/mmp2-sspa.c
index de3a45f..76e57c7 100644
--- a/sound/soc/pxa/mmp2-sspa.c
+++ b/sound/soc/pxa/mmp2-sspa.c
@@ -259,9 +259,6 @@ mmp2_sspa_get_dma_params(int id, struct ssp_device *sspa, int width, int out)
 		return NULL;
 
 	dma = &mmp2_pcm_adma_params[index];
-	dma->dcmd = (out ? (TDCR_DSTDIR_ADDR_HOLD | TDCR_SRCDIR_ADDR_INC) :
-			   (TDCR_SRCDIR_ADDR_HOLD | TDCR_DSTDIR_ADDR_INC)) |
-		    TDCR_PACKMOD | TDCR_BURSTSZ_4B | TDCR_FETCHND | width;
 	dma->dma_ch = out ? sspa->drcmr_tx : sspa->drcmr_rx;
 	dma->dev_addr = out ? (sspa->phys_base + SSPA_TXD) :
 			      (sspa->phys_base + SSPA_RXD);
@@ -629,20 +626,24 @@ static int mmp3_sspa_hw_params(struct snd_pcm_substream *substream,
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S8:
-		word_size = SSPA_CTL_8_BITS;
+		sspa_ctrl |= SSPA_CTL_XSSZ1(SSPA_CTL_8_BITS);
+		word_size = SSPA_CTL_16_BITS;
 		bits_per_frame = 16;
 		as_width = TDCR_SSZ_8_BITS;
 	case SNDRV_PCM_FORMAT_S16_LE:
+		sspa_ctrl |= SSPA_CTL_XSSZ1(SSPA_CTL_16_BITS);
 		word_size = SSPA_CTL_32_BITS;
 		bits_per_frame = 32;
 		as_width = TDCR_SSZ_16_BITS;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
+		sspa_ctrl |= SSPA_CTL_XSSZ1(SSPA_CTL_24_BITS);
 		word_size = SSPA_CTL_24_BITS;
 		bits_per_frame = 48;
 		as_width = TDCR_SSZ_24_BITS;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
+		sspa_ctrl |= SSPA_CTL_XSSZ1(SSPA_CTL_32_BITS);
 		word_size = SSPA_CTL_32_BITS;
 		bits_per_frame = 64;
 		as_width = TDCR_SSZ_32_BITS;
@@ -655,8 +656,7 @@ static int mmp3_sspa_hw_params(struct snd_pcm_substream *substream,
 	 * that word_size bit can be sent out. the word_size - 1 length of
 	 * 0 would be ignored in codec. it should be also appiled to other
 	 * formats besides S16_LE */
-	sspa_ctrl |= SSPA_CTL_XSSZ1(word_size) |
-		     SSPA_CTL_XWDLEN1(word_size);
+	sspa_ctrl |= SSPA_CTL_XWDLEN1(word_size);
 	sspa_sp |= SSPA_SP_FPER((bits_per_frame << 1) - 1) |
 		     SSPA_SP_FWID(bits_per_frame - 1);
 
@@ -670,16 +670,16 @@ static int mmp3_sspa_hw_params(struct snd_pcm_substream *substream,
 		mmp2_sspa_write_reg(sspa, SSPA_RXCTL, sspa_ctrl);
 		mmp2_sspa_write_reg(sspa, SSPA_RXFIFO_UL, 0x0);
 		mmp2_sspa_write_reg(sspa, SSPA_RXSP, sspa_sp);
-#ifdef CONFIG_CPU_MMP3
+
 		if (sspa_sp & SSPA_SP_MSL) {
-		/* FIXME: hw issue, for the rx port, can not config the
-		 * master mode in TXSP register. and must clear this bit
-		 * in TXSP register */
-		sspa_sp = mmp2_sspa_read_reg(sspa, SSPA_TXSP);
-		sspa_sp |= SSPA_SP_WEN;
-		mmp2_sspa_write_reg(sspa, SSPA_TXSP, sspa_sp & ~SSPA_SP_MSL);
+			/* FIXME: hw issue, for the rx port, can not config the
+			 * master mode in TXSP register. and must clear this bit
+			 * in TXSP register */
+			sspa_sp = mmp2_sspa_read_reg(sspa, SSPA_TXSP);
+			sspa_sp |= SSPA_SP_WEN;
+			mmp2_sspa_write_reg(sspa, SSPA_TXSP,
+						sspa_sp & ~SSPA_SP_MSL);
 		}
-#endif
 	}
 
 	mmp2_sspa_dump_reg(sspa);
-- 
1.7.0.4

