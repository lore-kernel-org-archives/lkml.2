Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1JLPAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:00:12 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6496 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JLPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:00:10 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 7/9] ASoC: da7210: Add support for ALC and
 Noise suppression
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:37:50 +0530
Message-ID: <1318432070.12107.426.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds controls to set following ALC parameters,
 - Max gain, Min gain, Noise gain, Attack rate, Release rate and delay

It also adds a switch to enable/disable noise suppression.

As per DA7210 data sheet, ALC and noise suppression can be enabled
only if certain conditions are met. This condition checks are handled
by simply using "_EXT" version of controls to capture change events.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>

---
 sound/soc/codecs/da7210.c |  104 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index eb12c82..9cab62a 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -26,6 +26,7 @@
 #include <sound/tlv.h>
 
 /* DA7210 register space */
+#define DA7210_CONTROL			0x01
 #define DA7210_STATUS			0x02
 #define DA7210_STARTUP1			0x03
 #define DA7210_MIC_L			0x07
@@ -65,6 +66,12 @@
 #define DA7210_PLL_DIV2			0x2A
 #define DA7210_PLL_DIV3			0x2B
 #define DA7210_PLL			0x2C
+#define DA7210_ALC_MAX			0x83
+#define DA7210_ALC_MIN			0x84
+#define DA7210_ALC_NOIS			0x85
+#define DA7210_ALC_ATT			0x86
+#define DA7210_ALC_REL			0x87
+#define DA7210_ALC_DEL			0x88
 #define DA7210_A_HID_UNLOCK		0x8A
 #define DA7210_A_TEST_UNLOCK		0x8B
 #define DA7210_A_PLL1			0x90
@@ -87,6 +94,7 @@
 #define DA7210_IN_R_EN			(1 << 7)
 
 /* ADC bit fields */
+#define DA7210_ADC_ALC_EN		(1 << 0)
 #define DA7210_ADC_L_EN			(1 << 3)
 #define DA7210_ADC_R_EN			(1 << 7)
 
@@ -165,9 +173,11 @@
 #define DA7210_OUT2_EN			(1 << 7)
 
 /* AUX1_L bit fields */
+#define DA7210_AUX1_L_VOL		(0x3F << 0)
 #define DA7210_AUX1_L_EN		(1 << 7)
 
 /* AUX1_R bit fields */
+#define DA7210_AUX1_R_VOL		(0x3F << 0)
 #define DA7210_AUX1_R_EN		(1 << 7)
 
 /* AUX2 bit fields */
@@ -176,6 +186,19 @@
 /* SOFTMUTE bit fields */
 #define DA7210_RAMP_EN			(1 << 6)
 
+/* CONTROL bit fields */
+#define DA7210_NOISE_SUP_EN		(1 << 3)
+
+/* IN_GAIN bit fields */
+#define DA7210_INPGA_L_VOL		(0x0F << 0)
+#define DA7210_INPGA_R_VOL		(0xF0 << 0)
+
+/* ZERO_CROSS bit fields */
+#define DA7210_AUX1_L_ZC		(1 << 0)
+#define DA7210_AUX1_R_ZC		(1 << 1)
+#define DA7210_HP_L_ZC			(1 << 6)
+#define DA7210_HP_R_ZC			(1 << 7)
+
 /* Default gain/vol values */
 #define DA7210_DFLT_DAC_GAIN		0x10  /* 0dB */
 #define DA7210_DFLT_OUT1_VOL		0x35  /* 0dB */
@@ -185,6 +208,10 @@
 #define DA7210_DFLT_AUX2_VOL		0x02  /* 6dB */
 #define DA7210_DFLT_INPGA_VOL		0x07  /* 6dB */
 
+/* Minimum INPGA and AUX1 volume to enable noise suppression */
+#define DA7210_INPGA_MIN_VOL_NS		0x0A  /* 10.5dB */
+#define DA7210_AUX1_MIN_VOL_NS		0x35  /* 6dB */
+
 #define DA7210_VERSION "0.0.1"
 
 /*
@@ -247,6 +274,70 @@ static const char *da7210_hp_mode_txt[] = {
 static const struct soc_enum da7210_hp_mode_sel =
 	SOC_ENUM_SINGLE(DA7210_HP_CFG, 0, 2, da7210_hp_mode_txt);
 
+/* ALC can be enabled only if noise suppression is disabled */
+static int da7210_put_alc_sw(struct snd_kcontrol *kcontrol,
+			     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	u8 *reg_cache = codec->reg_cache;
+
+	if (ucontrol->value.integer.value[0]) {
+		/* Check if noise suppression is enabled */
+		if (reg_cache[DA7210_CONTROL] & DA7210_NOISE_SUP_EN) {
+			dev_dbg(codec->dev, "Failed to enable ALC\n");
+			return -EPERM;
+		}
+	}
+	/* If all conditions are met or we are actually disabling ALC */
+	return snd_soc_put_volsw(kcontrol, ucontrol);
+}
+
+/* Noise suppression can be enabled only if following conditions are met
+ *  ALC disabled
+ *  ZC enabled for HP and AUX1 PGA
+ *  INPGA_L_VOL and INPGA_R_VOL >= 10.5 dB
+ *  AUX1_L_VOL and AUX1_R_VOL >= 6 dB
+ */
+static int da7210_put_noise_sup_sw(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	u8 *reg_cache = codec->reg_cache;
+	u8 val;
+
+	if (ucontrol->value.integer.value[0]) {
+		/* Check if ALC is enabled */
+		if (reg_cache[DA7210_ADC] & DA7210_ADC_ALC_EN)
+			goto err;
+
+		/* Check ZC for HP and AUX1 PGA */
+		if ((reg_cache[DA7210_ZERO_CROSS] &
+			(DA7210_AUX1_L_ZC | DA7210_AUX1_R_ZC | DA7210_HP_L_ZC |
+			DA7210_HP_R_ZC)) != 0xc3)
+			goto err;
+
+		/* Check INPGA_L_VOL and INPGA_R_VOL */
+		val = reg_cache[DA7210_IN_GAIN];
+		if (((val & DA7210_INPGA_L_VOL) < DA7210_INPGA_MIN_VOL_NS) ||
+			(((val & DA7210_INPGA_R_VOL) >> 4) <
+			DA7210_INPGA_MIN_VOL_NS))
+			goto err;
+
+		/* Check AUX1_L_VOL and AUX1_R_VOL */
+		if (((reg_cache[DA7210_AUX1_L] & DA7210_AUX1_L_VOL) <
+			DA7210_AUX1_MIN_VOL_NS) ||
+			((reg_cache[DA7210_AUX1_R] & DA7210_AUX1_R_VOL) <
+			DA7210_AUX1_MIN_VOL_NS))
+			goto err;
+	}
+	/* If all conditions are met or we are actually disabling Noise sup */
+	return snd_soc_put_volsw(kcontrol, ucontrol);
+
+err:
+	dev_dbg(codec->dev, "Failed to enable Noise suppression\n");
+	return -EPERM;
+}
+
 static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_DOUBLE_R_TLV("HeadPhone Playback Volume",
@@ -322,6 +413,19 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 	SOC_DOUBLE("Headphone ZC Switch", DA7210_ZERO_CROSS, 6, 7, 1, 0),
 
 	SOC_ENUM("Headphone Class", da7210_hp_mode_sel),
+
+	/* ALC controls */
+	SOC_SINGLE_EXT("ALC Enable Switch", DA7210_ADC, 0, 1, 0,
+		       snd_soc_get_volsw, da7210_put_alc_sw),
+	SOC_SINGLE("ALC Capture Max Gain", DA7210_ALC_MAX, 0, 0x3F, 0),
+	SOC_SINGLE("ALC Capture Min Gain", DA7210_ALC_MIN, 0, 0x3F, 0),
+	SOC_SINGLE("ALC Capture Noise Gain", DA7210_ALC_NOIS, 0, 0x3F, 0),
+	SOC_SINGLE("ALC Capture Attack Rate", DA7210_ALC_ATT, 0, 0xFF, 0),
+	SOC_SINGLE("ALC Capture Release Rate", DA7210_ALC_REL, 0, 0xFF, 0),
+	SOC_SINGLE("ALC Capture Release Delay", DA7210_ALC_DEL, 0, 0xFF, 0),
+
+	SOC_SINGLE_EXT("Noise Suppression Enable Switch", DA7210_CONTROL, 3, 1,
+		       0, snd_soc_get_volsw, da7210_put_noise_sup_sw),
 };
 
 /* Codec private data */
-- 
1.7.1


