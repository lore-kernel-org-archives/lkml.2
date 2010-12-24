Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0LXNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:50:33 -0500
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1185 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752693Ab0LXNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:48:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27157
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: [PATCH 8/9] ASoC: codecs: wm9090: Fix register cache incoherency
Date: Fri, 24 Dec 2010 14:48:03 +0100
Message-Id: <1293198484-1902-9-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293198484-1902-1-git-send-email-lars@metafoo.de>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch(commit f0fba2ad1) introduced a generic register cache
framework. But the wm8753 driver still uses its own register cache for its
private functions, while functions from the ASoC core use the generic cache.
Thus we end up with two from each other incoherent caches, which leads to
undefined behaviour.
This pachtes fixes the issue by changing the wm9090 driver to use the generic
cache framework.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

---
Compile tested only
---
 sound/soc/codecs/wm9090.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index 7ba5807..a788c42 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -140,7 +140,6 @@ static const u16 wm9090_reg_defaults[] = {
 /* This struct is used to save the context */
 struct wm9090_priv {
 	struct mutex mutex;
-	u16 reg_cache[WM9090_MAX_REGISTER + 1];
 	struct wm9090_platform_data pdata;
 	void *control_data;
 };
@@ -552,6 +551,7 @@ static int wm9090_set_bias_level(struct snd_soc_codec *codec,
 static int wm9090_probe(struct snd_soc_codec *codec)
 {
 	struct wm9090_priv *wm9090 = snd_soc_codec_get_drvdata(codec);
+	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	codec->control_data = wm9090->control_data;
@@ -576,22 +576,22 @@ static int wm9090_probe(struct snd_soc_codec *codec)
 	/* Configure some defaults; they will be written out when we
 	 * bring the bias up.
 	 */
-	wm9090->reg_cache[WM9090_IN1_LINE_INPUT_A_VOLUME] |= WM9090_IN1_VU
+	reg_cache[WM9090_IN1_LINE_INPUT_A_VOLUME] |= WM9090_IN1_VU
 		| WM9090_IN1A_ZC;
-	wm9090->reg_cache[WM9090_IN1_LINE_INPUT_B_VOLUME] |= WM9090_IN1_VU
+	reg_cache[WM9090_IN1_LINE_INPUT_B_VOLUME] |= WM9090_IN1_VU
 		| WM9090_IN1B_ZC;
-	wm9090->reg_cache[WM9090_IN2_LINE_INPUT_A_VOLUME] |= WM9090_IN2_VU
+	reg_cache[WM9090_IN2_LINE_INPUT_A_VOLUME] |= WM9090_IN2_VU
 		| WM9090_IN2A_ZC;
-	wm9090->reg_cache[WM9090_IN2_LINE_INPUT_B_VOLUME] |= WM9090_IN2_VU
+	reg_cache[WM9090_IN2_LINE_INPUT_B_VOLUME] |= WM9090_IN2_VU
 		| WM9090_IN2B_ZC;
-	wm9090->reg_cache[WM9090_SPEAKER_VOLUME_LEFT] |=
+	reg_cache[WM9090_SPEAKER_VOLUME_LEFT] |=
 		WM9090_SPKOUT_VU | WM9090_SPKOUTL_ZC;
-	wm9090->reg_cache[WM9090_LEFT_OUTPUT_VOLUME] |=
+	reg_cache[WM9090_LEFT_OUTPUT_VOLUME] |=
 		WM9090_HPOUT1_VU | WM9090_HPOUT1L_ZC;
-	wm9090->reg_cache[WM9090_RIGHT_OUTPUT_VOLUME] |=
+	reg_cache[WM9090_RIGHT_OUTPUT_VOLUME] |=
 		WM9090_HPOUT1_VU | WM9090_HPOUT1R_ZC;
 
-	wm9090->reg_cache[WM9090_CLOCKING_1] |= WM9090_TOCLK_ENA;
+	reg_cache[WM9090_CLOCKING_1] |= WM9090_TOCLK_ENA;
 
 	wm9090_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-- 
1.7.2.3

