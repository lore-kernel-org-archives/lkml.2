Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1JLOyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:54:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:10446 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1JLOuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:50:15 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 4/9] ASoC: da7210: Add support for mute and
 zero cross controls
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:31:35 +0530
Message-ID: <1318431695.12107.411.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for below set of controls,
(1) Mute controls for MIC, AUX, ADC and DAC
(2) Zero cross controls for head phone, AUX, INPGA and line out
(3) Head phone mode selection - class H or G

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index b48a8af..1b4554a 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -45,6 +45,7 @@
 #define DA7210_DAC_L			0x15
 #define DA7210_DAC_R			0x16
 #define DA7210_DAC_SEL			0x17
+#define DA7210_SOFTMUTE			0x18
 #define DA7210_DAC_EQ1_2		0x19
 #define DA7210_DAC_EQ3_4		0x1A
 #define DA7210_DAC_EQ5			0x1B
@@ -56,6 +57,7 @@
 #define DA7210_HP_L_VOL			0x21
 #define DA7210_HP_R_VOL			0x22
 #define DA7210_HP_CFG			0x23
+#define DA7210_ZERO_CROSS		0x24
 #define DA7210_DAI_SRC_SEL		0x25
 #define DA7210_DAI_CFG1			0x26
 #define DA7210_DAI_CFG3			0x28
@@ -166,6 +168,9 @@
 /* AUX2 bit fields */
 #define DA7210_AUX2_EN			(1 << 3)
 
+/* SOFTMUTE bit fields */
+#define DA7210_RAMP_EN			(1 << 6)
+
 /* Default gain/vol values */
 #define DA7210_DFLT_DAC_GAIN		0x10  /* 0dB */
 #define DA7210_DFLT_OUT1_VOL		0x35  /* 0dB */
@@ -227,6 +232,13 @@ static const char *da7210_mic_bias_voltage_txt[] = {
 static const struct soc_enum da7210_mic_bias =
 	SOC_ENUM_SINGLE(DA7210_MIC_L, 4, 4, da7210_mic_bias_voltage_txt);
 
+static const char *da7210_hp_mode_txt[] = {
+	"Class H", "Class G"
+};
+
+static const struct soc_enum da7210_hp_mode_sel =
+	SOC_ENUM_SINGLE(DA7210_HP_CFG, 0, 2, da7210_hp_mode_txt);
+
 static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_DOUBLE_R_TLV("HeadPhone Playback Volume",
@@ -284,6 +296,24 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 		       eq_gain_tlv),
 	SOC_SINGLE_TLV("ADC EQ5 Volume", DA7210_ADC_EQ5, 0, 0xf, 1,
 		       eq_gain_tlv),
+
+	/* Mute controls */
+	SOC_SINGLE("Mic Left Mute Switch", DA7210_MIC_L, 3, 1, 0),
+	SOC_SINGLE("Mic Right Mute Switch", DA7210_MIC_R, 3, 1, 0),
+	SOC_SINGLE("Aux2 Mute Switch", DA7210_AUX2, 2, 1, 0),
+	SOC_SINGLE("ADC Left Mute Switch", DA7210_ADC, 2, 1, 0),
+	SOC_SINGLE("ADC Right Mute Switch", DA7210_ADC, 6, 1, 0),
+	SOC_SINGLE("DAC Mute Switch", DA7210_DAC_HPF, 2, 1, 0),
+	SOC_SINGLE("DAC Soft Mute Switch", DA7210_SOFTMUTE, 7, 1, 0),
+	SOC_SINGLE("DAC Soft Mute Rate", DA7210_SOFTMUTE, 0, 0X7, 0),
+
+	/* Zero cross controls */
+	SOC_DOUBLE("Aux1 ZC Switch", DA7210_ZERO_CROSS, 0, 1, 1, 0),
+	SOC_DOUBLE("In PGA ZC Switch", DA7210_ZERO_CROSS, 2, 3, 1, 0),
+	SOC_DOUBLE("Lineout ZC Switch", DA7210_ZERO_CROSS, 4, 5, 1, 0),
+	SOC_DOUBLE("Headphone ZC Switch", DA7210_ZERO_CROSS, 6, 7, 1, 0),
+
+	SOC_ENUM("Headphone Class", da7210_hp_mode_sel),
 };
 
 /* Codec private data */
@@ -629,6 +659,8 @@ static int da7210_probe(struct snd_soc_codec *codec)
 	/* Set default In PGA gain */
 	snd_soc_write(codec, DA7210_IN_GAIN, DA7210_DFLT_INPGA_VOL |
 						(DA7210_DFLT_INPGA_VOL << 4));
+	/* Enable ramp mode for DAC gain update */
+	snd_soc_write(codec, DA7210_SOFTMUTE, DA7210_RAMP_EN);
 
 	/* Diable PLL and bypass it */
 	snd_soc_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
-- 
1.7.1


