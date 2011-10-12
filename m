Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1JLOqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:46:55 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3662 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1JLOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:46:54 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 2/9] ASoC: da7210: Add support for line input
 and mic
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:28:12 +0530
Message-ID: <1318431492.12107.403.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DA7210 has three line inputs (AUX1 Left, AUX1 Right and AUX2) and
a stereo MIC. This patch adds gain controls for MIC, AUX1, AUX2 as
well as INPGA. It also adds a control to set  MIC BIAS voltage.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   79 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index eef861d..6039ada 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -30,6 +30,10 @@
 #define DA7210_STARTUP1			0x03
 #define DA7210_MIC_L			0x07
 #define DA7210_MIC_R			0x08
+#define DA7210_AUX1_L			0x09
+#define DA7210_AUX1_R			0x0A
+#define DA7210_AUX2			0x0B
+#define DA7210_IN_GAIN			0x0C
 #define DA7210_INMIX_L			0x0D
 #define DA7210_INMIX_R			0x0E
 #define DA7210_ADC_HPF			0x0F
@@ -147,10 +151,23 @@
 #define DA7210_OUT2_OUTMIX_L		(1 << 6)
 #define DA7210_OUT2_EN			(1 << 7)
 
+/* AUX1_L bit fields */
+#define DA7210_AUX1_L_EN		(1 << 7)
+
+/* AUX1_R bit fields */
+#define DA7210_AUX1_R_EN		(1 << 7)
+
+/* AUX2 bit fields */
+#define DA7210_AUX2_EN			(1 << 3)
+
 /* Default gain/vol values */
 #define DA7210_DFLT_DAC_GAIN		0x10  /* 0dB */
 #define DA7210_DFLT_OUT1_VOL		0x35  /* 0dB */
 #define DA7210_DFLT_OUT2_VOL		0x06  /* 0dB */
+#define DA7210_DFLT_MIC_VOL		0x02  /* 6dB */
+#define DA7210_DFLT_AUX1_VOL		0x35  /* 6dB */
+#define DA7210_DFLT_AUX2_VOL		0x02  /* 6dB */
+#define DA7210_DFLT_INPGA_VOL		0x07  /* 6dB */
 
 #define DA7210_VERSION "0.0.1"
 
@@ -170,6 +187,9 @@
  */
 static const DECLARE_TLV_DB_SCALE(hp_out_tlv, -7950, 150, 1);
 static const DECLARE_TLV_DB_SCALE(dac_gain_tlv, -7725, 75, 0);
+static const DECLARE_TLV_DB_SCALE(mic_vol_tlv, -600, 600, 0);
+static const DECLARE_TLV_DB_SCALE(aux2_vol_tlv, -600, 600, 0);
+static const DECLARE_TLV_DB_SCALE(inpga_gain_tlv, -450, 150, 0);
 
 static const unsigned int lineout_vol_tlv[] = {
 	TLV_DB_RANGE_HEAD(2),
@@ -185,6 +205,20 @@ static const unsigned int mono_vol_tlv[] = {
 	0x3, 0x7, TLV_DB_SCALE_ITEM(-1800, 600, 0)
 };
 
+static const unsigned int aux1_vol_tlv[] = {
+	TLV_DB_RANGE_HEAD(2),
+	0x0, 0x10, TLV_DB_SCALE_ITEM(TLV_DB_GAIN_MUTE, 0, 1),
+	/* -48dB to 21dB */
+	0x11, 0x3f, TLV_DB_SCALE_ITEM(-4800, 150, 0)
+};
+
+static const char *da7210_mic_bias_voltage_txt[] = {
+	"1.5", "1.6", "2.2", "2.3"
+};
+
+static const struct soc_enum da7210_mic_bias =
+	SOC_ENUM_SINGLE(DA7210_MIC_L, 4, 4, da7210_mic_bias_voltage_txt);
+
 static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_DOUBLE_R_TLV("HeadPhone Playback Volume",
@@ -198,6 +232,22 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 			 0, 0x3f, 0, lineout_vol_tlv),
 	SOC_SINGLE_TLV("Mono Playback Volume", DA7210_OUT2, 0, 0x7, 0,
 		       mono_vol_tlv),
+
+	/* MIC related controls */
+	SOC_DOUBLE_R_TLV("Mic Capture Volume",
+			 DA7210_MIC_L, DA7210_MIC_R,
+			 0, 0x5, 0, mic_vol_tlv),
+	SOC_ENUM("Mic Bias Voltage", da7210_mic_bias),
+
+	/* AUX related controls */
+	SOC_DOUBLE_R_TLV("Aux1 Capture Volume",
+			 DA7210_AUX1_L, DA7210_AUX1_R,
+			 0, 0x3f, 0, aux1_vol_tlv),
+	SOC_SINGLE_TLV("Aux2 Capture Volume", DA7210_AUX2, 0, 0x3, 0,
+		       aux2_vol_tlv),
+
+	SOC_DOUBLE_TLV("In PGA Capture Volume", DA7210_IN_GAIN, 0, 4, 0xF, 0,
+		       inpga_gain_tlv),
 };
 
 /* Codec private data */
@@ -251,13 +301,9 @@ static int da7210_startup(struct snd_pcm_substream *substream,
 		snd_soc_update_bits(codec, DA7210_OUTMIX_R, 0x1F, 0x10);
 
 	} else {
-		/* Volume 7 */
-		snd_soc_update_bits(codec, DA7210_MIC_L, 0x7, 0x7);
-		snd_soc_update_bits(codec, DA7210_MIC_R, 0x7, 0x7);
-
-		/* Enable Mic */
-		snd_soc_update_bits(codec, DA7210_INMIX_L, 0x1F, 0x1);
-		snd_soc_update_bits(codec, DA7210_INMIX_R, 0x1F, 0x1);
+		/* Enable Mic,AUX1 and AUX2 */
+		snd_soc_update_bits(codec, DA7210_INMIX_L, 0x1F, 0xD);
+		snd_soc_update_bits(codec, DA7210_INMIX_R, 0x1F, 0xD);
 	}
 
 	return 0;
@@ -492,8 +538,10 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	 */
 
 	/* Enable Left & Right MIC PGA and Mic Bias */
-	snd_soc_write(codec, DA7210_MIC_L, DA7210_MIC_L_EN | DA7210_MICBIAS_EN);
-	snd_soc_write(codec, DA7210_MIC_R, DA7210_MIC_R_EN);
+	snd_soc_write(codec, DA7210_MIC_L, DA7210_MIC_L_EN | DA7210_MICBIAS_EN |
+		     DA7210_DFLT_MIC_VOL);
+	snd_soc_write(codec, DA7210_MIC_R, DA7210_MIC_R_EN |
+		     DA7210_DFLT_MIC_VOL);
 
 	/* Enable Left and Right input PGA */
 	snd_soc_write(codec, DA7210_INMIX_L, DA7210_IN_L_EN);
@@ -533,6 +581,19 @@ static int da7210_probe(struct snd_soc_codec *codec)
 		     DA7210_OUT2_EN | DA7210_OUT2_OUTMIX_L |
 		     DA7210_OUT2_OUTMIX_R);
 
+	/* Enable Aux1 and set default vol */
+	snd_soc_write(codec, DA7210_AUX1_L, DA7210_DFLT_AUX1_VOL |
+					   DA7210_AUX1_L_EN);
+	snd_soc_write(codec, DA7210_AUX1_R, DA7210_DFLT_AUX1_VOL |
+					   DA7210_AUX1_R_EN);
+	/* Enable Aux2 and set default vol */
+	snd_soc_write(codec, DA7210_AUX2, DA7210_DFLT_AUX2_VOL |
+		     DA7210_AUX2_EN);
+
+	/* Set default In PGA gain */
+	snd_soc_write(codec, DA7210_IN_GAIN, DA7210_DFLT_INPGA_VOL |
+						(DA7210_DFLT_INPGA_VOL << 4));
+
 	/* Diable PLL and bypass it */
 	snd_soc_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
 
-- 
1.7.1


