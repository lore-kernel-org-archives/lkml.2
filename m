Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1FUOkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:40:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1FUOkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Axel Castaneda Gonzalez <x0055901@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 17/18] ASoC: twl6040: Configure ramp step based on platform
Date: Tue, 21 Jun 2011 16:39:15 +0300
Message-ID: <1308663556-29120-18-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Castaneda Gonzalez <x0055901@ti.com>

Enable ramp down/up step to be configured based on
platform.

Signed-off-by: Axel Castaneda Gonzalez <x0055901@ti.com>
Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/i2c/twl.h    |    4 ++
 sound/soc/codecs/twl6040.c |   91 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 75 insertions(+), 20 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 685fd76..114c0f6 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -664,6 +664,10 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
+	u16 hs_left_step;
+	u16 hs_right_step;
+	u16 hf_left_step;
+	u16 hf_right_step;
 	void (*set_hs_extmute)(int mute);
 };
 
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 39ecf2f..0145041 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -83,6 +83,10 @@ struct twl6040_data {
 	int hs_power_mode_locked;
 	unsigned int clk_in;
 	unsigned int sysclk;
+	u16 hs_left_step;
+	u16 hs_right_step;
+	u16 hf_left_step;
+	u16 hf_right_step;
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
 	struct twl6040_jack_data hs_jack;
 	struct snd_soc_codec *codec;
@@ -339,7 +343,11 @@ static inline int twl6040_hs_ramp_step(struct snd_soc_codec *codec,
 	if (headset->ramp == TWL6040_RAMP_UP) {
 		/* ramp step up */
 		if (val < headset->left_vol) {
-			val += left_step;
+			if (val + left_step > headset->left_vol)
+				val = headset->left_vol;
+			else
+				val += left_step;
+
 			reg &= ~TWL6040_HSL_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HSGAIN,
 					(reg | (~val & TWL6040_HSL_VOL_MASK)));
@@ -349,7 +357,11 @@ static inline int twl6040_hs_ramp_step(struct snd_soc_codec *codec,
 	} else if (headset->ramp == TWL6040_RAMP_DOWN) {
 		/* ramp step down */
 		if (val > 0x0) {
-			val -= left_step;
+			if ((int)val - (int)left_step < 0)
+				val = 0;
+			else
+				val -= left_step;
+
 			reg &= ~TWL6040_HSL_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HSGAIN, reg |
 						(~val & TWL6040_HSL_VOL_MASK));
@@ -366,7 +378,11 @@ static inline int twl6040_hs_ramp_step(struct snd_soc_codec *codec,
 	if (headset->ramp == TWL6040_RAMP_UP) {
 		/* ramp step up */
 		if (val < headset->right_vol) {
-			val += right_step;
+			if (val + right_step > headset->right_vol)
+				val = headset->right_vol;
+			else
+				val += right_step;
+
 			reg &= ~TWL6040_HSR_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HSGAIN,
 				(reg | (~val << TWL6040_HSR_VOL_SHIFT)));
@@ -376,7 +392,11 @@ static inline int twl6040_hs_ramp_step(struct snd_soc_codec *codec,
 	} else if (headset->ramp == TWL6040_RAMP_DOWN) {
 		/* ramp step down */
 		if (val > 0x0) {
-			val -= right_step;
+			if ((int)val - (int)right_step < 0)
+				val = 0;
+			else
+				val -= right_step;
+
 			reg &= ~TWL6040_HSR_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HSGAIN,
 					 reg | (~val << TWL6040_HSR_VOL_SHIFT));
@@ -407,7 +427,11 @@ static inline int twl6040_hf_ramp_step(struct snd_soc_codec *codec,
 	if (handsfree->ramp == TWL6040_RAMP_UP) {
 		/* ramp step up */
 		if (val < handsfree->left_vol) {
-			val += left_step;
+			if (val + left_step > handsfree->left_vol)
+				val = handsfree->left_vol;
+			else
+				val += left_step;
+
 			reg &= ~TWL6040_HF_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HFLGAIN,
 						reg | (0x1D - val));
@@ -417,7 +441,11 @@ static inline int twl6040_hf_ramp_step(struct snd_soc_codec *codec,
 	} else if (handsfree->ramp == TWL6040_RAMP_DOWN) {
 		/* ramp step down */
 		if (val > 0) {
-			val -= left_step;
+			if ((int)val - (int)left_step < 0)
+				val = 0;
+			else
+				val -= left_step;
+
 			reg &= ~TWL6040_HF_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HFLGAIN,
 						reg | (0x1D - val));
@@ -434,7 +462,11 @@ static inline int twl6040_hf_ramp_step(struct snd_soc_codec *codec,
 	if (handsfree->ramp == TWL6040_RAMP_UP) {
 		/* ramp step up */
 		if (val < handsfree->right_vol) {
-			val += right_step;
+			if (val + right_step > handsfree->right_vol)
+				val = handsfree->right_vol;
+			else
+				val += right_step;
+
 			reg &= ~TWL6040_HF_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HFRGAIN,
 						reg | (0x1D - val));
@@ -444,7 +476,11 @@ static inline int twl6040_hf_ramp_step(struct snd_soc_codec *codec,
 	} else if (handsfree->ramp == TWL6040_RAMP_DOWN) {
 		/* ramp step down */
 		if (val > 0) {
-			val -= right_step;
+			if ((int)val - (int)right_step < 0)
+				val = 0;
+			else
+				val -= right_step;
+
 			reg &= ~TWL6040_HF_VOL_MASK;
 			twl6040_write(codec, TWL6040_REG_HFRGAIN,
 						reg | (0x1D - val));
@@ -473,11 +509,9 @@ static void twl6040_pga_hs_work(struct work_struct *work)
 
 	/* HS PGA volumes have 4 bits of resolution to ramp */
 	for (i = 0; i <= 16; i++) {
-		headset_complete = 1;
-		if (headset->ramp != TWL6040_RAMP_NONE)
-			headset_complete = twl6040_hs_ramp_step(codec,
-							headset->left_step,
-							headset->right_step);
+		headset_complete = twl6040_hs_ramp_step(codec,
+						headset->left_step,
+						headset->right_step);
 
 		/* ramp finished ? */
 		if (headset_complete)
@@ -518,11 +552,9 @@ static void twl6040_pga_hf_work(struct work_struct *work)
 
 	/* HF PGA volumes have 5 bits of resolution to ramp */
 	for (i = 0; i <= 32; i++) {
-		handsfree_complete = 1;
-		if (handsfree->ramp != TWL6040_RAMP_NONE)
-			handsfree_complete = twl6040_hf_ramp_step(codec,
-							handsfree->left_step,
-							handsfree->right_step);
+		handsfree_complete = twl6040_hf_ramp_step(codec,
+						handsfree->left_step,
+						handsfree->right_step);
 
 		/* ramp finished ? */
 		if (handsfree_complete)
@@ -563,12 +595,16 @@ static int pga_event(struct snd_soc_dapm_widget *w,
 		out = &priv->headset;
 		work = &priv->hs_delayed_work;
 		queue = priv->hs_workqueue;
+		out->left_step = priv->hs_left_step;
+		out->right_step = priv->hs_right_step;
 		out->step_delay = 5;	/* 5 ms between volume ramp steps */
 		break;
 	case 4:
 		out = &priv->handsfree;
 		work = &priv->hf_delayed_work;
 		queue = priv->hf_workqueue;
+		out->left_step = priv->hf_left_step;
+		out->right_step = priv->hf_right_step;
 		out->step_delay = 5;	/* 5 ms between volume ramp steps */
 		if (SND_SOC_DAPM_EVENT_ON(event))
 			priv->non_lp++;
@@ -601,8 +637,6 @@ static int pga_event(struct snd_soc_dapm_widget *w,
 
 		if (!delayed_work_pending(work)) {
 			/* use volume ramp for power-down */
-			out->left_step = 1;
-			out->right_step = 1;
 			out->ramp = TWL6040_RAMP_DOWN;
 			INIT_COMPLETION(out->ramp_done);
 
@@ -1492,6 +1526,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv;
+	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
 	int ret = 0;
 
 	priv = kzalloc(sizeof(struct twl6040_data), GFP_KERNEL);
@@ -1502,6 +1537,22 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 	priv->codec = codec;
 	codec->control_data = dev_get_drvdata(codec->dev->parent);
 
+	if (pdata && pdata->hs_left_step && pdata->hs_right_step) {
+		priv->hs_left_step = pdata->hs_left_step;
+		priv->hs_right_step = pdata->hs_right_step;
+	} else {
+		priv->hs_left_step = 1;
+		priv->hs_right_step = 1;
+	}
+
+	if (pdata && pdata->hf_left_step && pdata->hf_right_step) {
+		priv->hf_left_step = pdata->hf_left_step;
+		priv->hf_right_step = pdata->hf_right_step;
+	} else {
+		priv->hf_left_step = 1;
+		priv->hf_right_step = 1;
+	}
+
 	priv->sysclk_constraints = &hp_constraints;
 	priv->workqueue = create_singlethread_workqueue("twl6040-codec");
 	if (!priv->workqueue) {
-- 
1.7.5.3

