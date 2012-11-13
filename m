Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2KMQpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:45:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60452 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab2KMQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:45:29 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com
Cc: patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] ASoC: arizona: Add support for multiplexer with no associated mixer
Date: Tue, 13 Nov 2012 16:40:32 +0000
Message-Id: <1352824834-11224-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Asynchronous Sample Rate Converters on the wm5102/wm5110 have no
mixer attached to their input, but they do allow the input to be
selected from a number of sources via a multiplexer. Currently the
platform assumes the presence of 4 multiplexers and a mixer for each
block.

This patch adds support multiplexed single input blocks into the Arizona
platform.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/sound/soc/codecs/arizona.h b/sound/soc/codecs/arizona.h
index 5a09127..f1c0ec9 100644
--- a/sound/soc/codecs/arizona.h
+++ b/sound/soc/codecs/arizona.h
@@ -94,33 +94,30 @@ extern int arizona_mixer_values[ARIZONA_NUM_MIXER_INPUTS];
 	const struct snd_kcontrol_new name##_mux =	\
 		SOC_DAPM_VALUE_ENUM("Route", name##_enum)
 
+#define ARIZONA_MUX_ENUMS(name, base_reg) \
+	static ARIZONA_MUX_ENUM_DECL(name##_enum, base_reg);      \
+	static ARIZONA_MUX_CTL_DECL(name)
+
 #define ARIZONA_MIXER_ENUMS(name, base_reg) \
-	static ARIZONA_MUX_ENUM_DECL(name##_in1_enum, base_reg);      \
-	static ARIZONA_MUX_ENUM_DECL(name##_in2_enum, base_reg + 2);  \
-	static ARIZONA_MUX_ENUM_DECL(name##_in3_enum, base_reg + 4);  \
-	static ARIZONA_MUX_ENUM_DECL(name##_in4_enum, base_reg + 6);  \
-	static ARIZONA_MUX_CTL_DECL(name##_in1); \
-	static ARIZONA_MUX_CTL_DECL(name##_in2); \
-	static ARIZONA_MUX_CTL_DECL(name##_in3); \
-	static ARIZONA_MUX_CTL_DECL(name##_in4)
+	ARIZONA_MUX_ENUMS(name##_in1, base_reg);     \
+	ARIZONA_MUX_ENUMS(name##_in2, base_reg + 2); \
+	ARIZONA_MUX_ENUMS(name##_in3, base_reg + 4); \
+	ARIZONA_MUX_ENUMS(name##_in4, base_reg + 6)
 
 #define ARIZONA_DSP_AUX_ENUMS(name, base_reg) \
-	static ARIZONA_MUX_ENUM_DECL(name##_aux1_enum, base_reg);	\
-	static ARIZONA_MUX_ENUM_DECL(name##_aux2_enum, base_reg + 8);	\
-	static ARIZONA_MUX_ENUM_DECL(name##_aux3_enum, base_reg + 16);	\
-	static ARIZONA_MUX_ENUM_DECL(name##_aux4_enum, base_reg + 24);	\
-	static ARIZONA_MUX_ENUM_DECL(name##_aux5_enum, base_reg + 32);	\
-	static ARIZONA_MUX_ENUM_DECL(name##_aux6_enum, base_reg + 40);	\
-	static ARIZONA_MUX_CTL_DECL(name##_aux1); \
-	static ARIZONA_MUX_CTL_DECL(name##_aux2); \
-	static ARIZONA_MUX_CTL_DECL(name##_aux3); \
-	static ARIZONA_MUX_CTL_DECL(name##_aux4); \
-	static ARIZONA_MUX_CTL_DECL(name##_aux5); \
-	static ARIZONA_MUX_CTL_DECL(name##_aux6)
+	ARIZONA_MUX_ENUMS(name##_aux1, base_reg);	\
+	ARIZONA_MUX_ENUMS(name##_aux2, base_reg + 8);	\
+	ARIZONA_MUX_ENUMS(name##_aux3, base_reg + 16);	\
+	ARIZONA_MUX_ENUMS(name##_aux4, base_reg + 24);	\
+	ARIZONA_MUX_ENUMS(name##_aux5, base_reg + 32);	\
+	ARIZONA_MUX_ENUMS(name##_aux6, base_reg + 40)
 
 #define ARIZONA_MUX(name, ctrl) \
 	SND_SOC_DAPM_VALUE_MUX(name, SND_SOC_NOPM, 0, 0, ctrl)
 
+#define ARIZONA_MUX_WIDGETS(name, name_str) \
+	ARIZONA_MUX(name_str " Input", &name##_mux)
+
 #define ARIZONA_MIXER_WIDGETS(name, name_str)	\
 	ARIZONA_MUX(name_str " Input 1", &name##_in1_mux), \
 	ARIZONA_MUX(name_str " Input 2", &name##_in2_mux), \
@@ -138,6 +135,9 @@ extern int arizona_mixer_values[ARIZONA_NUM_MIXER_INPUTS];
 	ARIZONA_MUX(name_str " Aux 5", &name##_aux5_mux), \
 	ARIZONA_MUX(name_str " Aux 6", &name##_aux6_mux)
 
+#define ARIZONA_MUX_ROUTES(name) \
+	ARIZONA_MIXER_INPUT_ROUTES(name " Input")
+
 #define ARIZONA_MIXER_ROUTES(widget, name) \
 	{ widget, NULL, name " Mixer" },         \
 	{ name " Mixer", NULL, name " Input 1" }, \
-- 
1.7.2.5

