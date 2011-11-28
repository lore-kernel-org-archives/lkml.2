Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1K1Q10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:27:26 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:57072
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940Ab1K1Q1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:27:24 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <drivers@analog.com>, <device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/7] ASoC: AD193X: Use snd_soc_update_bits where appropriate
Date: Mon, 28 Nov 2011 17:28:11 +0100
Message-ID: <1322497692-27868-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322497692-27868-1-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can reduce the code size here a bit by using snd_soc_update_bits instead of
open-coding the read-modify-write cycle. The conversion done in this patch is
not completely straightforward and some minor code restructuring has been
incorporated to further reduce the code size.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |   96 +++++++++++++++++----------------------------
 sound/soc/codecs/ad193x.h |   17 ++++----
 2 files changed, 45 insertions(+), 68 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index c19e223..7d64f20 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -123,35 +123,29 @@ static int ad193x_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 			       unsigned int rx_mask, int slots, int width)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	int dac_reg = snd_soc_read(codec, AD193X_DAC_CTRL1);
-	int adc_reg = snd_soc_read(codec, AD193X_ADC_CTRL2);
-
-	dac_reg &= ~AD193X_DAC_CHAN_MASK;
-	adc_reg &= ~AD193X_ADC_CHAN_MASK;
+	unsigned int channels;
 
 	switch (slots) {
 	case 2:
-		dac_reg |= AD193X_DAC_2_CHANNELS << AD193X_DAC_CHAN_SHFT;
-		adc_reg |= AD193X_ADC_2_CHANNELS << AD193X_ADC_CHAN_SHFT;
+		channels = AD193X_2_CHANNELS;
 		break;
 	case 4:
-		dac_reg |= AD193X_DAC_4_CHANNELS << AD193X_DAC_CHAN_SHFT;
-		adc_reg |= AD193X_ADC_4_CHANNELS << AD193X_ADC_CHAN_SHFT;
+		channels = AD193X_4_CHANNELS;
 		break;
 	case 8:
-		dac_reg |= AD193X_DAC_8_CHANNELS << AD193X_DAC_CHAN_SHFT;
-		adc_reg |= AD193X_ADC_8_CHANNELS << AD193X_ADC_CHAN_SHFT;
+		channels = AD193X_8_CHANNELS;
 		break;
 	case 16:
-		dac_reg |= AD193X_DAC_16_CHANNELS << AD193X_DAC_CHAN_SHFT;
-		adc_reg |= AD193X_ADC_16_CHANNELS << AD193X_ADC_CHAN_SHFT;
+		channels = AD193X_16_CHANNELS;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	snd_soc_write(codec, AD193X_DAC_CTRL1, dac_reg);
-	snd_soc_write(codec, AD193X_ADC_CTRL2, adc_reg);
+	snd_soc_update_bits(codec, AD193X_DAC_CTRL1, AD193X_DAC_CHAN_MASK,
+		channels << AD193X_DAC_CHAN_SHFT);
+	snd_soc_update_bits(codec, AD193X_ADC_CTRL2, AD193X_ADC_CHAN_MASK,
+		channels << AD193X_ADC_CHAN_SHFT);
 
 	return 0;
 }
@@ -160,23 +154,19 @@ static int ad193x_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	int adc_reg1, adc_reg2, dac_reg;
-
-	adc_reg1 = snd_soc_read(codec, AD193X_ADC_CTRL1);
-	adc_reg2 = snd_soc_read(codec, AD193X_ADC_CTRL2);
-	dac_reg = snd_soc_read(codec, AD193X_DAC_CTRL1);
+	unsigned int adc_serfmt = 0;
+	unsigned int adc_fmt = 0;
+	unsigned int dac_fmt = 0;
 
 	/* At present, the driver only support AUX ADC mode(SND_SOC_DAIFMT_I2S
 	 * with TDM) and ADC&DAC TDM mode(SND_SOC_DAIFMT_DSP_A)
 	 */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		adc_reg1 &= ~AD193X_ADC_SERFMT_MASK;
-		adc_reg1 |= AD193X_ADC_SERFMT_TDM;
+		adc_serfmt |= AD193X_ADC_SERFMT_TDM;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		adc_reg1 &= ~AD193X_ADC_SERFMT_MASK;
-		adc_reg1 |= AD193X_ADC_SERFMT_AUX;
+		adc_serfmt |= AD193X_ADC_SERFMT_AUX;
 		break;
 	default:
 		return -EINVAL;
@@ -184,29 +174,20 @@ static int ad193x_set_dai_fmt(struct snd_soc_dai *codec_dai,
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF: /* normal bit clock + frame */
-		adc_reg2 &= ~AD193X_ADC_LEFT_HIGH;
-		adc_reg2 &= ~AD193X_ADC_BCLK_INV;
-		dac_reg &= ~AD193X_DAC_LEFT_HIGH;
-		dac_reg &= ~AD193X_DAC_BCLK_INV;
 		break;
 	case SND_SOC_DAIFMT_NB_IF: /* normal bclk + invert frm */
-		adc_reg2 |= AD193X_ADC_LEFT_HIGH;
-		adc_reg2 &= ~AD193X_ADC_BCLK_INV;
-		dac_reg |= AD193X_DAC_LEFT_HIGH;
-		dac_reg &= ~AD193X_DAC_BCLK_INV;
+		adc_fmt |= AD193X_ADC_LEFT_HIGH;
+		dac_fmt |= AD193X_DAC_LEFT_HIGH;
 		break;
 	case SND_SOC_DAIFMT_IB_NF: /* invert bclk + normal frm */
-		adc_reg2 &= ~AD193X_ADC_LEFT_HIGH;
-		adc_reg2 |= AD193X_ADC_BCLK_INV;
-		dac_reg &= ~AD193X_DAC_LEFT_HIGH;
-		dac_reg |= AD193X_DAC_BCLK_INV;
+		adc_fmt |= AD193X_ADC_BCLK_INV;
+		dac_fmt |= AD193X_DAC_BCLK_INV;
 		break;
-
 	case SND_SOC_DAIFMT_IB_IF: /* invert bclk + frm */
-		adc_reg2 |= AD193X_ADC_LEFT_HIGH;
-		adc_reg2 |= AD193X_ADC_BCLK_INV;
-		dac_reg |= AD193X_DAC_LEFT_HIGH;
-		dac_reg |= AD193X_DAC_BCLK_INV;
+		adc_fmt |= AD193X_ADC_LEFT_HIGH;
+		adc_fmt |= AD193X_ADC_BCLK_INV;
+		dac_fmt |= AD193X_DAC_LEFT_HIGH;
+		dac_fmt |= AD193X_DAC_BCLK_INV;
 		break;
 	default:
 		return -EINVAL;
@@ -214,36 +195,31 @@ static int ad193x_set_dai_fmt(struct snd_soc_dai *codec_dai,
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBM_CFM: /* codec clk & frm master */
-		adc_reg2 |= AD193X_ADC_LCR_MASTER;
-		adc_reg2 |= AD193X_ADC_BCLK_MASTER;
-		dac_reg |= AD193X_DAC_LCR_MASTER;
-		dac_reg |= AD193X_DAC_BCLK_MASTER;
+		adc_fmt |= AD193X_ADC_LCR_MASTER;
+		adc_fmt |= AD193X_ADC_BCLK_MASTER;
+		dac_fmt |= AD193X_DAC_LCR_MASTER;
+		dac_fmt |= AD193X_DAC_BCLK_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFM: /* codec clk slave & frm master */
-		adc_reg2 |= AD193X_ADC_LCR_MASTER;
-		adc_reg2 &= ~AD193X_ADC_BCLK_MASTER;
-		dac_reg |= AD193X_DAC_LCR_MASTER;
-		dac_reg &= ~AD193X_DAC_BCLK_MASTER;
+		adc_fmt |= AD193X_ADC_LCR_MASTER;
+		dac_fmt |= AD193X_DAC_LCR_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS: /* codec clk master & frame slave */
-		adc_reg2 &= ~AD193X_ADC_LCR_MASTER;
-		adc_reg2 |= AD193X_ADC_BCLK_MASTER;
-		dac_reg &= ~AD193X_DAC_LCR_MASTER;
-		dac_reg |= AD193X_DAC_BCLK_MASTER;
+		adc_fmt |= AD193X_ADC_BCLK_MASTER;
+		dac_fmt |= AD193X_DAC_BCLK_MASTER;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFS: /* codec clk & frm slave */
-		adc_reg2 &= ~AD193X_ADC_LCR_MASTER;
-		adc_reg2 &= ~AD193X_ADC_BCLK_MASTER;
-		dac_reg &= ~AD193X_DAC_LCR_MASTER;
-		dac_reg &= ~AD193X_DAC_BCLK_MASTER;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	snd_soc_write(codec, AD193X_ADC_CTRL1, adc_reg1);
-	snd_soc_write(codec, AD193X_ADC_CTRL2, adc_reg2);
-	snd_soc_write(codec, AD193X_DAC_CTRL1, dac_reg);
+	snd_soc_update_bits(codec, AD193X_ADC_CTRL1, AD193X_ADC_SERFMT_MASK,
+	    adc_serfmt);
+	snd_soc_update_bits(codec, AD193X_ADC_CTRL2, AD193X_ADC_FMT_MASK,
+	    adc_fmt);
+	snd_soc_update_bits(codec, AD193X_DAC_CTRL1, AD193X_DAC_FMT_MASK,
+	    dac_fmt);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/ad193x.h b/sound/soc/codecs/ad193x.h
index 1507eaa..4733880 100644
--- a/sound/soc/codecs/ad193x.h
+++ b/sound/soc/codecs/ad193x.h
@@ -23,16 +23,14 @@
 #define AD193X_DAC_SERFMT_STEREO	(0 << 6)
 #define AD193X_DAC_SERFMT_TDM		(1 << 6)
 #define AD193X_DAC_CTRL1        0x03
-#define AD193X_DAC_2_CHANNELS   0
-#define AD193X_DAC_4_CHANNELS   1
-#define AD193X_DAC_8_CHANNELS   2
-#define AD193X_DAC_16_CHANNELS  3
 #define AD193X_DAC_CHAN_SHFT    1
 #define AD193X_DAC_CHAN_MASK    (3 << AD193X_DAC_CHAN_SHFT)
 #define AD193X_DAC_LCR_MASTER   (1 << 4)
 #define AD193X_DAC_BCLK_MASTER  (1 << 5)
 #define AD193X_DAC_LEFT_HIGH    (1 << 3)
 #define AD193X_DAC_BCLK_INV     (1 << 7)
+#define AD193X_DAC_FMT_MASK	(AD193X_DAC_LCR_MASTER | \
+	AD193X_DAC_BCLK_MASTER | AD193X_DAC_LEFT_HIGH | AD193X_DAC_BCLK_INV)
 #define AD193X_DAC_CTRL2        0x04
 #define AD193X_DAC_WORD_LEN_SHFT        3
 #define AD193X_DAC_WORD_LEN_MASK        0x18
@@ -68,16 +66,19 @@
 #define AD193X_ADC_SERFMT_AUX		(2 << 5)
 #define AD193X_ADC_WORD_LEN_MASK	0x3
 #define AD193X_ADC_CTRL2        0x10
-#define AD193X_ADC_2_CHANNELS   0
-#define AD193X_ADC_4_CHANNELS   1
-#define AD193X_ADC_8_CHANNELS   2
-#define AD193X_ADC_16_CHANNELS  3
 #define AD193X_ADC_CHAN_SHFT    4
 #define AD193X_ADC_CHAN_MASK    (3 << AD193X_ADC_CHAN_SHFT)
 #define AD193X_ADC_LCR_MASTER   (1 << 3)
 #define AD193X_ADC_BCLK_MASTER  (1 << 6)
 #define AD193X_ADC_LEFT_HIGH    (1 << 2)
 #define AD193X_ADC_BCLK_INV     (1 << 1)
+#define AD193X_ADC_FMT_MASK	(AD193X_ADC_LCR_MASTER | \
+	AD193X_ADC_BCLK_MASTER | AD193X_ADC_LEFT_HIGH | AD193X_ADC_BCLK_INV)
+
+#define AD193X_2_CHANNELS   0
+#define AD193X_4_CHANNELS   1
+#define AD193X_8_CHANNELS   2
+#define AD193X_16_CHANNELS  3
 
 #define AD193X_NUM_REGS          17
 
-- 
1.7.7.3


