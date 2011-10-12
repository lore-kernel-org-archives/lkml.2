Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1JLOs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:48:58 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53200 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JLOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:48:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 0,
Subject: [alsa-devel] [PATCH 3/9] ASoC: da7210: Add support for ADC & DAC
 equalizers
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:30:06 +0530
Message-ID: <1318431606.12107.408.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ADC and DAC five band equalizers
available on DA7210 codec.

Tested on Samsung SMDK6410 board with DA7210 evaluation board.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 6039ada..b48a8af 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -38,10 +38,16 @@
 #define DA7210_INMIX_R			0x0E
 #define DA7210_ADC_HPF			0x0F
 #define DA7210_ADC			0x10
+#define DA7210_ADC_EQ1_2		0X11
+#define DA7210_ADC_EQ3_4		0x12
+#define DA7210_ADC_EQ5			0x13
 #define DA7210_DAC_HPF			0x14
 #define DA7210_DAC_L			0x15
 #define DA7210_DAC_R			0x16
 #define DA7210_DAC_SEL			0x17
+#define DA7210_DAC_EQ1_2		0x19
+#define DA7210_DAC_EQ3_4		0x1A
+#define DA7210_DAC_EQ5			0x1B
 #define DA7210_OUTMIX_L			0x1C
 #define DA7210_OUTMIX_R			0x1D
 #define DA7210_OUT1_L			0x1E
@@ -190,6 +196,8 @@ static const DECLARE_TLV_DB_SCALE(dac_gain_tlv, -7725, 75, 0);
 static const DECLARE_TLV_DB_SCALE(mic_vol_tlv, -600, 600, 0);
 static const DECLARE_TLV_DB_SCALE(aux2_vol_tlv, -600, 600, 0);
 static const DECLARE_TLV_DB_SCALE(inpga_gain_tlv, -450, 150, 0);
+static const DECLARE_TLV_DB_SCALE(eq_gain_tlv, -1050, 150, 0);
+static const DECLARE_TLV_DB_SCALE(adc_eq_master_gain_tlv, -1800, 600, 1);
 
 static const unsigned int lineout_vol_tlv[] = {
 	TLV_DB_RANGE_HEAD(2),
@@ -248,6 +256,34 @@ static const struct snd_kcontrol_new da7210_snd_controls[] = {
 
 	SOC_DOUBLE_TLV("In PGA Capture Volume", DA7210_IN_GAIN, 0, 4, 0xF, 0,
 		       inpga_gain_tlv),
+
+	/* DAC Equalizer  controls */
+	SOC_SINGLE("DAC EQ Switch", DA7210_DAC_EQ5, 7, 1, 0),
+	SOC_SINGLE_TLV("DAC EQ1 Volume", DA7210_DAC_EQ1_2, 0, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("DAC EQ2 Volume", DA7210_DAC_EQ1_2, 4, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("DAC EQ3 Volume", DA7210_DAC_EQ3_4, 0, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("DAC EQ4 Volume", DA7210_DAC_EQ3_4, 4, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("DAC EQ5 Volume", DA7210_DAC_EQ5, 0, 0xf, 1,
+		       eq_gain_tlv),
+
+	/* ADC Equalizer  controls */
+	SOC_SINGLE("ADC EQ Switch", DA7210_ADC_EQ5, 7, 1, 0),
+	SOC_SINGLE_TLV("ADC EQ Master Volume", DA7210_ADC_EQ5, 4, 0x3,
+		       1, adc_eq_master_gain_tlv),
+	SOC_SINGLE_TLV("ADC EQ1 Volume", DA7210_ADC_EQ1_2, 0, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("ADC EQ2 Volume", DA7210_ADC_EQ1_2, 4, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("ADC EQ3 Volume", DA7210_ADC_EQ3_4, 0, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("ADC EQ4 Volume", DA7210_ADC_EQ3_4, 4, 0xf, 1,
+		       eq_gain_tlv),
+	SOC_SINGLE_TLV("ADC EQ5 Volume", DA7210_ADC_EQ5, 0, 0xf, 1,
+		       eq_gain_tlv),
 };
 
 /* Codec private data */
-- 
1.7.1


