Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1JLOpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:45:10 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:53267
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab1JLOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:45:09 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 0,
Subject: [alsa-devel] [PATCH 1/9] ASoC: da7210: Add support for line out
 and DAC
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:26:15 +0530
Message-ID: <1318431375.12107.398.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DA7210 has three line outputs. OUT1 Left, OUT1 Right and OUT2 (mono).
This patch adds support for gain controls for these three line outs.
It also adds support for overall DAC gain control.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   55 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index a9d9d39..eef861d 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -40,6 +40,9 @@
 #define DA7210_DAC_SEL			0x17
 #define DA7210_OUTMIX_L			0x1C
 #define DA7210_OUTMIX_R			0x1D
+#define DA7210_OUT1_L			0x1E
+#define DA7210_OUT1_R			0x1F
+#define DA7210_OUT2			0x20
 #define DA7210_HP_L_VOL			0x21
 #define DA7210_HP_R_VOL			0x22
 #define DA7210_HP_CFG			0x23
@@ -133,6 +136,22 @@
 #define DA7210_PLL_FS_96000		(0xF << 0)
 #define DA7210_PLL_EN			(0x1 << 7)
 
+/* OUT1_L bit fields */
+#define DA7210_OUT1_L_EN		(1 << 7)
+
+/* OUT1_R bit fields */
+#define DA7210_OUT1_R_EN		(1 << 7)
+
+/* OUT2 bit fields */
+#define DA7210_OUT2_OUTMIX_R		(1 << 5)
+#define DA7210_OUT2_OUTMIX_L		(1 << 6)
+#define DA7210_OUT2_EN			(1 << 7)
+
+/* Default gain/vol values */
+#define DA7210_DFLT_DAC_GAIN		0x10  /* 0dB */
+#define DA7210_DFLT_OUT1_VOL		0x35  /* 0dB */
+#define DA7210_DFLT_OUT2_VOL		0x06  /* 0dB */
+
 #define DA7210_VERSION "0.0.1"
 
 /*
@@ -150,12 +169,35 @@
  * -> min = -79.5 dB
  */
 static const DECLARE_TLV_DB_SCALE(hp_out_tlv, -7950, 150, 1);
+static const DECLARE_TLV_DB_SCALE(dac_gain_tlv, -7725, 75, 0);
+
+static const unsigned int lineout_vol_tlv[] = {
+	TLV_DB_RANGE_HEAD(2),
+	0x0, 0x10, TLV_DB_SCALE_ITEM(TLV_DB_GAIN_MUTE, 0, 1),
+	/* -54dB to 15dB */
+	0x11, 0x3f, TLV_DB_SCALE_ITEM(-5400, 150, 0)
+};
+
+static const unsigned int mono_vol_tlv[] = {
+	TLV_DB_RANGE_HEAD(2),
+	0x0, 0x2, TLV_DB_SCALE_ITEM(-1800, 0, 1),
+	/* -18dB to 6dB */
+	0x3, 0x7, TLV_DB_SCALE_ITEM(-1800, 600, 0)
+};
 
 static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_DOUBLE_R_TLV("HeadPhone Playback Volume",
 			 DA7210_HP_L_VOL, DA7210_HP_R_VOL,
 			 0, 0x3F, 0, hp_out_tlv),
+	SOC_DOUBLE_R_TLV("DAC Playback Volume",
+			 DA7210_DAC_L, DA7210_DAC_R,
+			 0, 0x77, 1, dac_gain_tlv),
+	SOC_DOUBLE_R_TLV("Lineout Playback Volume",
+			 DA7210_OUT1_L, DA7210_OUT1_R,
+			 0, 0x3f, 0, lineout_vol_tlv),
+	SOC_SINGLE_TLV("Mono Playback Volume", DA7210_OUT2, 0, 0x7, 0,
+		       mono_vol_tlv),
 };
 
 /* Codec private data */
@@ -478,6 +520,19 @@ static int da7210_probe(struct snd_soc_codec *codec)
 		     DA7210_HP_2CAP_MODE | DA7210_HP_SENSE_EN |
 		     DA7210_HP_L_EN | DA7210_HP_MODE | DA7210_HP_R_EN);
 
+	/* Set default DAC gain */
+	snd_soc_write(codec, DA7210_DAC_L, DA7210_DFLT_DAC_GAIN);
+	snd_soc_write(codec, DA7210_DAC_R, DA7210_DFLT_DAC_GAIN);
+
+	/* Enable Line out amplifiers and set default vol */
+	snd_soc_write(codec, DA7210_OUT1_L, DA7210_DFLT_OUT1_VOL |
+					   DA7210_OUT1_L_EN);
+	snd_soc_write(codec, DA7210_OUT1_R, DA7210_DFLT_OUT1_VOL |
+					   DA7210_OUT1_R_EN);
+	snd_soc_write(codec, DA7210_OUT2, DA7210_DFLT_OUT2_VOL |
+		     DA7210_OUT2_EN | DA7210_OUT2_OUTMIX_L |
+		     DA7210_OUT2_OUTMIX_R);
+
 	/* Diable PLL and bypass it */
 	snd_soc_write(codec, DA7210_PLL, DA7210_PLL_FS_48000);
 
-- 
1.7.1


