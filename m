Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1GDKGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:06:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41303 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab1GDKGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:06:07 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 3/6] ASoC: twl6040: Simplify sample rate constraint handling
Date: Mon, 4 Jul 2011 13:05:55 +0300
Message-ID: <1309773958-14608-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can manage the sample rate constraints without the need
to maintain a variable and a pointer.
This simplifies the handling of the constraint, and makes it
more robust.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index e61f32f..9229049 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -88,7 +88,6 @@ struct twl6040_data {
 	u16 hs_right_step;
 	u16 hf_left_step;
 	u16 hf_right_step;
-	struct snd_pcm_hw_constraint_list *sysclk_constraints;
 	struct twl6040_jack_data hs_jack;
 	struct snd_soc_codec *codec;
 	struct workqueue_struct *workqueue;
@@ -223,11 +222,6 @@ static unsigned int lp_rates[] = {
 	96000,
 };
 
-static struct snd_pcm_hw_constraint_list lp_constraints = {
-	.count	= ARRAY_SIZE(lp_rates),
-	.list	= lp_rates,
-};
-
 static unsigned int hp_rates[] = {
 	8000,
 	16000,
@@ -236,9 +230,9 @@ static unsigned int hp_rates[] = {
 	96000,
 };
 
-static struct snd_pcm_hw_constraint_list hp_constraints = {
-	.count	= ARRAY_SIZE(hp_rates),
-	.list	= hp_rates,
+static struct snd_pcm_hw_constraint_list sysclk_constraints[] = {
+	{ .count = ARRAY_SIZE(lp_rates), .list = lp_rates, },
+	{ .count = ARRAY_SIZE(hp_rates), .list = hp_rates, },
 };
 
 /*
@@ -1098,10 +1092,6 @@ static int twl6040_pll_put_enum(struct snd_kcontrol *kcontrol,
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
 
 	priv->pll_power_mode = ucontrol->value.enumerated.item[0];
-	if (priv->pll_power_mode)
-		priv->sysclk_constraints = &hp_constraints;
-	else
-		priv->sysclk_constraints = &lp_constraints;
 
 	return 0;
 }
@@ -1369,7 +1359,7 @@ static int twl6040_startup(struct snd_pcm_substream *substream,
 
 	snd_pcm_hw_constraint_list(substream->runtime, 0,
 				SNDRV_PCM_HW_PARAM_RATE,
-				priv->sysclk_constraints);
+				&sysclk_constraints[priv->pll_power_mode]);
 
 	return 0;
 }
@@ -1589,7 +1579,6 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 		priv->hf_right_step = 1;
 	}
 
-	priv->sysclk_constraints = &lp_constraints;
 	priv->workqueue = create_singlethread_workqueue("twl6040-codec");
 	if (!priv->workqueue) {
 		ret = -ENOMEM;
-- 
1.7.6

