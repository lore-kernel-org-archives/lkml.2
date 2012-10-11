Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2JKKuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:50:40 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:2306 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab2JKKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:50:38 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: [alsa-devel] [PATCH] ASoC: codecs: da9055: DAPMise Headphone and
 Lineout enable controls
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Oct 2012 16:31:05 +0530
Message-ID: <1349953265.24126.39.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch DAPMises headphone and lineout output enable controls. 

Earlier these output enable bits were permanently turned on in probe.
In da9055 codec, right outmixer is directly connected with right HP and
Line out. This resulted in two side effects,

(1) When you only want to use lineout, right HP (and connected charge
pump) also gets enabled

(2) When you only want to use stereo HP, lineout also gets enabled

This patch adds three switches to select which output(s) should be
enabled.

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 sound/soc/codecs/da9055.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index abf3e43..d3a6de2 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -753,6 +753,17 @@ static const struct snd_kcontrol_new da9055_dapm_mixoutr_controls[] = {
 			6, 1, 0),
 };
 
+/* Headphone Output Enable */
+static const struct snd_kcontrol_new da9055_dapm_hp_l_control =
+SOC_DAPM_SINGLE("Switch", DA9055_HP_L_CTRL, 3, 1, 0);
+
+static const struct snd_kcontrol_new da9055_dapm_hp_r_control =
+SOC_DAPM_SINGLE("Switch", DA9055_HP_R_CTRL, 3, 1, 0);
+
+/* Lineout Output Enable */
+static const struct snd_kcontrol_new da9055_dapm_lineout_control =
+SOC_DAPM_SINGLE("Switch", DA9055_LINE_CTRL, 3, 1, 0);
+
 /* DAPM widgets */
 static const struct snd_soc_dapm_widget da9055_dapm_widgets[] = {
 	/* Input Side */
@@ -817,6 +828,14 @@ static const struct snd_soc_dapm_widget da9055_dapm_widgets[] = {
 			   &da9055_dapm_mixoutr_controls[0],
 			   ARRAY_SIZE(da9055_dapm_mixoutr_controls)),
 
+	/* Output Enable Switches */
+	SND_SOC_DAPM_SWITCH("Headphone Left Enable", SND_SOC_NOPM, 0, 0,
+			    &da9055_dapm_hp_l_control),
+	SND_SOC_DAPM_SWITCH("Headphone Right Enable", SND_SOC_NOPM, 0, 0,
+			    &da9055_dapm_hp_r_control),
+	SND_SOC_DAPM_SWITCH("Lineout Enable", SND_SOC_NOPM, 0, 0,
+			    &da9055_dapm_lineout_control),
+
 	/* Output PGAs */
 	SND_SOC_DAPM_PGA("MIXOUT Left", DA9055_MIXOUT_L_CTRL, 7, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("MIXOUT Right", DA9055_MIXOUT_R_CTRL, 7, 0, NULL, 0),
@@ -902,17 +921,20 @@ static const struct snd_soc_dapm_route da9055_audio_map[] = {
 	{"Out Mixer Right", "DAC Right Switch", "DAC Right"},
 
 	{"MIXOUT Left", NULL, "Out Mixer Left"},
-	{"Headphone Left", NULL, "MIXOUT Left"},
+	{"Headphone Left Enable", "Switch", "MIXOUT Left"},
+	{"Headphone Left", NULL, "Headphone Left Enable"},
 	{"Headphone Left", NULL, "Charge Pump"},
 	{"HPL", NULL, "Headphone Left"},
 
 	{"MIXOUT Right", NULL, "Out Mixer Right"},
-	{"Headphone Right", NULL, "MIXOUT Right"},
+	{"Headphone Right Enable", "Switch", "MIXOUT Right"},
+	{"Headphone Right", NULL, "Headphone Right Enable"},
 	{"Headphone Right", NULL, "Charge Pump"},
 	{"HPR", NULL, "Headphone Right"},
 
 	{"MIXOUT Right", NULL, "Out Mixer Right"},
-	{"Lineout", NULL, "MIXOUT Right"},
+	{"Lineout Enable", "Switch", "MIXOUT Right"},
+	{"Lineout", NULL, "Lineout Enable"},
 	{"LINE", NULL, "Lineout"},
 };
 
@@ -1394,8 +1416,7 @@ static int da9055_probe(struct snd_soc_codec *codec)
 			    DA9055_GAIN_RAMPING_EN, DA9055_GAIN_RAMPING_EN);
 
 	/*
-	 * There are two separate control bits for input and output mixers as
-	 * well as headphone and line outs.
+	 * There are two separate control bits for input and output mixers.
 	 * One to enable corresponding amplifier and other to enable its
 	 * output. As amplifier bits are related to power control, they are
 	 * being managed by DAPM while other (non power related) bits are
@@ -1411,14 +1432,6 @@ static int da9055_probe(struct snd_soc_codec *codec)
 	snd_soc_update_bits(codec, DA9055_MIXOUT_R_CTRL,
 			    DA9055_MIXOUT_R_MIX_EN, DA9055_MIXOUT_R_MIX_EN);
 
-	snd_soc_update_bits(codec, DA9055_HP_L_CTRL,
-			    DA9055_HP_L_AMP_OE, DA9055_HP_L_AMP_OE);
-	snd_soc_update_bits(codec, DA9055_HP_R_CTRL,
-			    DA9055_HP_R_AMP_OE, DA9055_HP_R_AMP_OE);
-
-	snd_soc_update_bits(codec, DA9055_LINE_CTRL,
-			    DA9055_LINE_AMP_OE, DA9055_LINE_AMP_OE);
-
 	/* Set this as per your system configuration */
 	snd_soc_write(codec, DA9055_PLL_CTRL, DA9055_PLL_INDIV_10_20_MHZ);
 
-- 
1.7.1


