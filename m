Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1FFLkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:40:40 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1044 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755898Ab1FFLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/6] ASoC: AD1836: Add ADC/DAC controls helper macros
Date: Mon,  6 Jun 2011 13:38:36 +0200
Message-Id: <1307360320-4727-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different ADC and DAC controls follow the same scheme, so add some helper
macros for declaring them.
This should make the code a bit more readable and also decreases the code size
a bit.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |   48 ++++++++++++++++++++++++--------------------
 sound/soc/codecs/ad1836.h |   23 ++++++---------------
 2 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 754c496..5c6d239 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -44,28 +44,32 @@ static const char *ad1836_deemp[] = {"None", "44.1kHz", "32kHz", "48kHz"};
 static const struct soc_enum ad1836_deemp_enum =
 	SOC_ENUM_SINGLE(AD1836_DAC_CTRL1, 8, 4, ad1836_deemp);
 
+#define AD1836_DAC_VOLUME(x) \
+	SOC_DOUBLE_R("DAC" #x " Playback Volume", AD1836_DAC_L_VOL(x), \
+			AD1836_DAC_R_VOL(x), 0, 0x3FF, 0)
+
+#define AD1836_DAC_SWITCH(x) \
+	SOC_DOUBLE("DAC" #x " Playback Switch", AD1836_DAC_CTRL2, \
+			AD1836_MUTE_LEFT(x), AD1836_MUTE_RIGHT(x), 1, 1)
+
+#define AD1836_ADC_SWITCH(x) \
+	SOC_DOUBLE("ADC" #x " Capture Switch", AD1836_ADC_CTRL2, \
+		AD1836_MUTE_LEFT(x), AD1836_MUTE_RIGHT(x), 1, 1)
+
 static const struct snd_kcontrol_new ad1836_snd_controls[] = {
 	/* DAC volume control */
-	SOC_DOUBLE_R("DAC1 Volume", AD1836_DAC_L1_VOL,
-			AD1836_DAC_R1_VOL, 0, 0x3FF, 0),
-	SOC_DOUBLE_R("DAC2 Volume", AD1836_DAC_L2_VOL,
-			AD1836_DAC_R2_VOL, 0, 0x3FF, 0),
-	SOC_DOUBLE_R("DAC3 Volume", AD1836_DAC_L3_VOL,
-			AD1836_DAC_R3_VOL, 0, 0x3FF, 0),
+	AD1836_DAC_VOLUME(1),
+	AD1836_DAC_VOLUME(2),
+	AD1836_DAC_VOLUME(3),
 
 	/* ADC switch control */
-	SOC_DOUBLE("ADC1 Switch", AD1836_ADC_CTRL2, AD1836_ADCL1_MUTE,
-		AD1836_ADCR1_MUTE, 1, 1),
-	SOC_DOUBLE("ADC2 Switch", AD1836_ADC_CTRL2, AD1836_ADCL2_MUTE,
-		AD1836_ADCR2_MUTE, 1, 1),
+	AD1836_ADC_SWITCH(1),
+	AD1836_ADC_SWITCH(2),
 
 	/* DAC switch control */
-	SOC_DOUBLE("DAC1 Switch", AD1836_DAC_CTRL2, AD1836_DACL1_MUTE,
-		AD1836_DACR1_MUTE, 1, 1),
-	SOC_DOUBLE("DAC2 Switch", AD1836_DAC_CTRL2, AD1836_DACL2_MUTE,
-		AD1836_DACR2_MUTE, 1, 1),
-	SOC_DOUBLE("DAC3 Switch", AD1836_DAC_CTRL2, AD1836_DACL3_MUTE,
-		AD1836_DACR3_MUTE, 1, 1),
+	AD1836_DAC_SWITCH(1),
+	AD1836_DAC_SWITCH(2),
+	AD1836_DAC_SWITCH(3),
 
 	/* ADC high-pass filter */
 	SOC_SINGLE("ADC High Pass Filter Switch", AD1836_ADC_CTRL1,
@@ -242,12 +246,12 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 	/* left/right diff:PGA/MUX */
 	snd_soc_write(codec, AD1836_ADC_CTRL3, 0x3A);
 	/* volume */
-	snd_soc_write(codec, AD1836_DAC_L1_VOL, 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R1_VOL, 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_L2_VOL, 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R2_VOL, 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_L3_VOL, 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R3_VOL, 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_L_VOL(1), 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_R_VOL(1), 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_L_VOL(2), 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_R_VOL(2), 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_L_VOL(3), 0x3FF);
+	snd_soc_write(codec, AD1836_DAC_R_VOL(3), 0x3FF);
 
 	snd_soc_add_controls(codec, ad1836_snd_controls,
 			     ARRAY_SIZE(ad1836_snd_controls));
diff --git a/sound/soc/codecs/ad1836.h b/sound/soc/codecs/ad1836.h
index 9d6a3f8..f13402f 100644
--- a/sound/soc/codecs/ad1836.h
+++ b/sound/soc/codecs/ad1836.h
@@ -28,29 +28,20 @@
 #define AD1836_DAC_WORD_LEN_OFFSET     3
 
 #define AD1836_DAC_CTRL2               1
-#define AD1836_DACL1_MUTE              0
-#define AD1836_DACR1_MUTE              1
-#define AD1836_DACL2_MUTE              2
-#define AD1836_DACR2_MUTE              3
-#define AD1836_DACL3_MUTE              4
-#define AD1836_DACR3_MUTE              5
 
-#define AD1836_DAC_L1_VOL              2
-#define AD1836_DAC_R1_VOL              3
-#define AD1836_DAC_L2_VOL              4
-#define AD1836_DAC_R2_VOL              5
-#define AD1836_DAC_L3_VOL              6
-#define AD1836_DAC_R3_VOL              7
+/* These macros are one-based. So AD183X_MUTE_LEFT(1) will return the mute bit
+ * for the first ADC/DAC */
+#define AD1836_MUTE_LEFT(x) (((x) * 2) - 2)
+#define AD1836_MUTE_RIGHT(x) (((x) * 2) - 1)
+
+#define AD1836_DAC_L_VOL(x) ((x) * 2)
+#define AD1836_DAC_R_VOL(x) (1 + ((x) * 2))
 
 #define AD1836_ADC_CTRL1               12
 #define AD1836_ADC_POWERDOWN           7
 #define AD1836_ADC_HIGHPASS_FILTER     8
 
 #define AD1836_ADC_CTRL2               13
-#define AD1836_ADCL1_MUTE 		0
-#define AD1836_ADCR1_MUTE 		1
-#define AD1836_ADCL2_MUTE 		2
-#define AD1836_ADCR2_MUTE 		3
 #define AD1836_ADC_WORD_LEN_MASK       0x30
 #define AD1836_ADC_WORD_OFFSET         5
 #define AD1836_ADC_SERFMT_MASK	       (7 << 6)
-- 
1.7.2.5

