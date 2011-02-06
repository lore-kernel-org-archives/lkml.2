Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1BFUdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:33:51 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1329 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752875Ab1BFUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:33:50 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 3878
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: codecs: wm8753: Fix DAI mode switching
Date: Sun,  6 Feb 2011 10:04:11 +0100
Message-Id: <1296983051-3105-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wm8753 codec supports switching between different DAI modes.
The current drivers tries to implement this by changing the DAI driver at
runtime. But to properly work this would require support from the ASoC core.

So this patch takes a different approch on how the DAI mode switching is
implemented.

The only difference, from a driver point of view, between the different DAI modes
is how to program the DAI format to the hardware. So what this patch is, it
stores the current format for each DAI in the drivers private struct and when
the DAI mode is changed the format gets simply reprogrammed according to the
new DAI mode.

Futhermore this patch restricts the changing of the DAI format to when the
codec is inactive.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/wm8753.c |  296 ++++++++++++++++++--------------------------
 1 files changed, 121 insertions(+), 175 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index 79b02ae..3f09dee 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -55,8 +55,10 @@ static int caps_charge = 2000;
 module_param(caps_charge, int, 0);
 MODULE_PARM_DESC(caps_charge, "WM8753 cap charge time (msecs)");
 
-static void wm8753_set_dai_mode(struct snd_soc_codec *codec,
-		struct snd_soc_dai *dai, unsigned int hifi);
+static int wm8753_hifi_write_dai_fmt(struct snd_soc_codec *codec,
+		unsigned int fmt);
+static int wm8753_voice_write_dai_fmt(struct snd_soc_codec *codec,
+		unsigned int fmt);
 
 /*
  * wm8753 register cache
@@ -87,6 +89,10 @@ struct wm8753_priv {
 	enum snd_soc_control_type control_type;
 	unsigned int sysclk;
 	unsigned int pcmclk;
+
+	unsigned int voice_fmt;
+	unsigned int hifi_fmt;
+
 	int dai_func;
 };
 
@@ -170,9 +176,9 @@ static int wm8753_get_dai(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
-	int mode = snd_soc_read(codec, WM8753_IOCTL);
+	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
 
-	ucontrol->value.integer.value[0] = (mode & 0xc) >> 2;
+	ucontrol->value.integer.value[0] = wm8753->dai_func;
 	return 0;
 }
 
@@ -180,16 +186,26 @@ static int wm8753_set_dai(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
-	int mode = snd_soc_read(codec, WM8753_IOCTL);
 	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
+	u16 ioctl;
+
+	if (codec->active)
+		return -EBUSY;
+
+	ioctl = snd_soc_read(codec, WM8753_IOCTL);
+
+	wm8753->dai_func = ucontrol->value.integer.value[0];
+
+	if (((ioctl >> 2) & 0x3) == wm8753->dai_func)
+		return 1;
+
+	ioctl = (ioctl & 0x1f3) | (wm8753->dai_func << 2);
+	snd_soc_write(codec, WM8753_IOCTL, ioctl);
 
-	if (((mode & 0xc) >> 2) == ucontrol->value.integer.value[0])
-		return 0;
 
-	mode &= 0xfff3;
-	mode |= (ucontrol->value.integer.value[0] << 2);
+	wm8753_hifi_write_dai_fmt(codec, wm8753->hifi_fmt);
+	wm8753_voice_write_dai_fmt(codec, wm8753->voice_fmt);
 
-	wm8753->dai_func =  ucontrol->value.integer.value[0];
 	return 1;
 }
 
@@ -828,10 +844,9 @@ static int wm8753_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 /*
  * Set's ADC and Voice DAC format.
  */
-static int wm8753_vdac_adc_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_vdac_adc_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 voice = snd_soc_read(codec, WM8753_PCM) & 0x01ec;
 
 	/* interface format */
@@ -858,13 +873,6 @@ static int wm8753_vdac_adc_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
-static int wm8753_pcm_startup(struct snd_pcm_substream *substream,
-				struct snd_soc_dai *dai)
-{
-	wm8753_set_dai_mode(dai->codec, dai, 0);
-	return 0;
-}
-
 /*
  * Set PCM DAI bit size and sample rate.
  */
@@ -905,10 +913,9 @@ static int wm8753_pcm_hw_params(struct snd_pcm_substream *substream,
 /*
  * Set's PCM dai fmt and BCLK.
  */
-static int wm8753_pcm_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_pcm_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 voice, ioctl;
 
 	voice = snd_soc_read(codec, WM8753_PCM) & 0x011f;
@@ -999,10 +1006,9 @@ static int wm8753_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 /*
  * Set's HiFi DAC format.
  */
-static int wm8753_hdac_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_hdac_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 hifi = snd_soc_read(codec, WM8753_HIFI) & 0x01e0;
 
 	/* interface format */
@@ -1032,10 +1038,9 @@ static int wm8753_hdac_set_dai_fmt(struct snd_soc_dai *codec_dai,
 /*
  * Set's I2S DAI format.
  */
-static int wm8753_i2s_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_i2s_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 ioctl, hifi;
 
 	hifi = snd_soc_read(codec, WM8753_HIFI) & 0x011f;
@@ -1098,13 +1103,6 @@ static int wm8753_i2s_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
-static int wm8753_i2s_startup(struct snd_pcm_substream *substream,
-				struct snd_soc_dai *dai)
-{
-	wm8753_set_dai_mode(dai->codec, dai, 1);
-	return 0;
-}
-
 /*
  * Set PCM DAI bit size and sample rate.
  */
@@ -1147,61 +1145,117 @@ static int wm8753_i2s_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int wm8753_mode1v_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_mode1v_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 clock;
 
 	/* set clk source as pcmclk */
 	clock = snd_soc_read(codec, WM8753_CLOCK) & 0xfffb;
 	snd_soc_write(codec, WM8753_CLOCK, clock);
 
-	if (wm8753_vdac_adc_set_dai_fmt(codec_dai, fmt) < 0)
-		return -EINVAL;
-	return wm8753_pcm_set_dai_fmt(codec_dai, fmt);
+	return wm8753_vdac_adc_set_dai_fmt(codec, fmt);
 }
 
-static int wm8753_mode1h_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_mode1h_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	if (wm8753_hdac_set_dai_fmt(codec_dai, fmt) < 0)
-		return -EINVAL;
-	return wm8753_i2s_set_dai_fmt(codec_dai, fmt);
+	return wm8753_hdac_set_dai_fmt(codec, fmt);
 }
 
-static int wm8753_mode2_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_mode2_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 clock;
 
 	/* set clk source as pcmclk */
 	clock = snd_soc_read(codec, WM8753_CLOCK) & 0xfffb;
 	snd_soc_write(codec, WM8753_CLOCK, clock);
 
-	if (wm8753_vdac_adc_set_dai_fmt(codec_dai, fmt) < 0)
-		return -EINVAL;
-	return wm8753_i2s_set_dai_fmt(codec_dai, fmt);
+	return wm8753_vdac_adc_set_dai_fmt(codec, fmt);
 }
 
-static int wm8753_mode3_4_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int wm8753_mode3_4_set_dai_fmt(struct snd_soc_codec *codec,
 		unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	u16 clock;
 
 	/* set clk source as mclk */
 	clock = snd_soc_read(codec, WM8753_CLOCK) & 0xfffb;
 	snd_soc_write(codec, WM8753_CLOCK, clock | 0x4);
 
-	if (wm8753_hdac_set_dai_fmt(codec_dai, fmt) < 0)
+	if (wm8753_hdac_set_dai_fmt(codec, fmt) < 0)
 		return -EINVAL;
-	if (wm8753_vdac_adc_set_dai_fmt(codec_dai, fmt) < 0)
-		return -EINVAL;
-	return wm8753_i2s_set_dai_fmt(codec_dai, fmt);
+	return wm8753_vdac_adc_set_dai_fmt(codec, fmt);
 }
 
+static int wm8753_hifi_write_dai_fmt(struct snd_soc_codec *codec,
+		unsigned int fmt)
+{
+	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+
+	switch (wm8753->dai_func) {
+	case 0:
+		ret = wm8753_mode1h_set_dai_fmt(codec, fmt);
+		break;
+	case 1:
+		ret = wm8753_mode2_set_dai_fmt(codec, fmt);
+		break;
+	case 2:
+	case 3:
+		ret = wm8753_mode3_4_set_dai_fmt(codec, fmt);
+		break;
+	default:
+		 break;
+	}
+	if (ret)
+		return ret;
+
+	return wm8753_i2s_set_dai_fmt(codec, fmt);
+}
+
+static int wm8753_hifi_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
+
+	wm8753->hifi_fmt = fmt;
+
+	return wm8753_hifi_write_dai_fmt(codec, fmt);
+};
+
+static int wm8753_voice_write_dai_fmt(struct snd_soc_codec *codec,
+		unsigned int fmt)
+{
+	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
+	int ret = 0;
+
+	if (wm8753->dai_func != 0)
+		return 0;
+
+	ret = wm8753_mode1v_set_dai_fmt(codec, fmt);
+	if (ret)
+		return ret;
+	ret = wm8753_pcm_set_dai_fmt(codec, fmt);
+	if (ret)
+		return ret;
+
+	return 0;
+};
+
+static int wm8753_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
+
+	wm8753->voice_fmt = fmt;
+
+	return wm8753_voice_write_dai_fmt(codec, fmt);
+};
+
 static int wm8753_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
@@ -1268,57 +1322,25 @@ static int wm8753_set_bias_level(struct snd_soc_codec *codec,
  * 3. Voice disabled - HIFI over HIFI
  * 4. Voice disabled - HIFI over HIFI, uses voice DAI LRC for capture
  */
-static struct snd_soc_dai_ops wm8753_dai_ops_hifi_mode1 = {
-	.startup = wm8753_i2s_startup,
+static struct snd_soc_dai_ops wm8753_dai_ops_hifi_mode = {
 	.hw_params	= wm8753_i2s_hw_params,
 	.digital_mute	= wm8753_mute,
-	.set_fmt	= wm8753_mode1h_set_dai_fmt,
-	.set_clkdiv	= wm8753_set_dai_clkdiv,
-	.set_pll	= wm8753_set_dai_pll,
-	.set_sysclk	= wm8753_set_dai_sysclk,
-};
-
-static struct snd_soc_dai_ops wm8753_dai_ops_voice_mode1 = {
-	.startup = wm8753_pcm_startup,
-	.hw_params	= wm8753_pcm_hw_params,
-	.digital_mute	= wm8753_mute,
-	.set_fmt	= wm8753_mode1v_set_dai_fmt,
+	.set_fmt	= wm8753_hifi_set_dai_fmt,
 	.set_clkdiv	= wm8753_set_dai_clkdiv,
 	.set_pll	= wm8753_set_dai_pll,
 	.set_sysclk	= wm8753_set_dai_sysclk,
 };
 
-static struct snd_soc_dai_ops wm8753_dai_ops_voice_mode2 = {
-	.startup = wm8753_pcm_startup,
+static struct snd_soc_dai_ops wm8753_dai_ops_voice_mode = {
 	.hw_params	= wm8753_pcm_hw_params,
 	.digital_mute	= wm8753_mute,
-	.set_fmt	= wm8753_mode2_set_dai_fmt,
-	.set_clkdiv	= wm8753_set_dai_clkdiv,
-	.set_pll	= wm8753_set_dai_pll,
-	.set_sysclk	= wm8753_set_dai_sysclk,
-};
-
-static struct snd_soc_dai_ops wm8753_dai_ops_hifi_mode3	= {
-	.startup = wm8753_i2s_startup,
-	.hw_params	= wm8753_i2s_hw_params,
-	.digital_mute	= wm8753_mute,
-	.set_fmt	= wm8753_mode3_4_set_dai_fmt,
-	.set_clkdiv	= wm8753_set_dai_clkdiv,
-	.set_pll	= wm8753_set_dai_pll,
-	.set_sysclk	= wm8753_set_dai_sysclk,
-};
-
-static struct snd_soc_dai_ops wm8753_dai_ops_hifi_mode4	= {
-	.startup = wm8753_i2s_startup,
-	.hw_params	= wm8753_i2s_hw_params,
-	.digital_mute	= wm8753_mute,
-	.set_fmt	= wm8753_mode3_4_set_dai_fmt,
+	.set_fmt	= wm8753_voice_set_dai_fmt,
 	.set_clkdiv	= wm8753_set_dai_clkdiv,
 	.set_pll	= wm8753_set_dai_pll,
 	.set_sysclk	= wm8753_set_dai_sysclk,
 };
 
-static struct snd_soc_dai_driver wm8753_all_dai[] = {
+static struct snd_soc_dai_driver wm8753_dai[] = {
 /* DAI HiFi mode 1 */
 {	.name = "wm8753-hifi",
 	.playback = {
@@ -1326,14 +1348,16 @@ static struct snd_soc_dai_driver wm8753_all_dai[] = {
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS},
+		.formats = WM8753_FORMATS
+	},
 	.capture = { /* dummy for fast DAI switching */
 		.stream_name = "Capture",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS},
-	.ops = &wm8753_dai_ops_hifi_mode1,
+		.formats = WM8753_FORMATS
+	},
+	.ops = &wm8753_dai_ops_hifi_mode,
 },
 /* DAI Voice mode 1 */
 {	.name = "wm8753-voice",
@@ -1342,97 +1366,19 @@ static struct snd_soc_dai_driver wm8753_all_dai[] = {
 		.channels_min = 1,
 		.channels_max = 1,
 		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.capture = {
-		.stream_name = "Capture",
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.ops = &wm8753_dai_ops_voice_mode1,
-},
-/* DAI HiFi mode 2 - dummy */
-{	.name = "wm8753-hifi",
-},
-/* DAI Voice mode 2 */
-{	.name = "wm8753-voice",
-	.playback = {
-		.stream_name = "Voice Playback",
-		.channels_min = 1,
-		.channels_max = 1,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.capture = {
-		.stream_name = "Capture",
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.ops = &wm8753_dai_ops_voice_mode2,
-},
-/* DAI HiFi mode 3 */
-{	.name = "wm8753-hifi",
-	.playback = {
-		.stream_name = "HiFi Playback",
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.capture = {
-		.stream_name = "Capture",
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.ops = &wm8753_dai_ops_hifi_mode3,
-},
-/* DAI Voice mode 3 - dummy */
-{	.name = "wm8753-voice",
-},
-/* DAI HiFi mode 4 */
-{	.name = "wm8753-hifi",
-	.playback = {
-		.stream_name = "HiFi Playback",
-		.channels_min = 1,
-		.channels_max = 2,
-		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
+		.formats = WM8753_FORMATS,
+	},
 	.capture = {
 		.stream_name = "Capture",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = WM8753_RATES,
-		.formats = WM8753_FORMATS,},
-	.ops = &wm8753_dai_ops_hifi_mode4,
-},
-/* DAI Voice mode 4 - dummy */
-{	.name = "wm8753-voice",
-},
-};
-
-static struct snd_soc_dai_driver wm8753_dai[] = {
-	{
-		.name = "wm8753-aif0",
-	},
-	{
-		.name = "wm8753-aif1",
+		.formats = WM8753_FORMATS,
 	},
+	.ops = &wm8753_dai_ops_voice_mode,
+},
 };
 
-static void wm8753_set_dai_mode(struct snd_soc_codec *codec,
-		struct snd_soc_dai *dai, unsigned int hifi)
-{
-	struct wm8753_priv *wm8753 = snd_soc_codec_get_drvdata(codec);
-
-	if (wm8753->dai_func < 4) {
-		if (hifi)
-			dai->driver = &wm8753_all_dai[wm8753->dai_func << 1];
-		else
-			dai->driver = &wm8753_all_dai[(wm8753->dai_func << 1) + 1];
-	}
-	snd_soc_write(codec, WM8753_IOCTL, wm8753->dai_func);
-}
-
 static void wm8753_work(struct work_struct *work)
 {
 	struct snd_soc_dapm_context *dapm =
-- 
1.7.2.3

