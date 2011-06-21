Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1FUOmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:42:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37393 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1FUOkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:02 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 09/18] ASoC: twl6040: Convert into TWL6040 MFD child
Date: Tue, 21 Jun 2011 16:39:07 +0300
Message-ID: <1308663556-29120-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Misael Lopez Cruz <misael.lopez@ti.com>

Convert TWL6040 CODEC driver into a TWL6040 MFD child, it implies
that MFD-level operations like register accesses, clock setting
and power management are done through MFD APIs, not directly by
CODEC driver anymore. To avoid conflicts with the other MFD child,
vibrator registers are skipped in CODEC driver.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/Kconfig   |    1 +
 sound/soc/codecs/twl6040.c |  425 +++++++++-----------------------------------
 sound/soc/codecs/twl6040.h |  118 ------------
 sound/soc/omap/sdp4430.c   |    2 +
 4 files changed, 90 insertions(+), 456 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 0002220..922f59f 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -240,6 +240,7 @@ config SND_SOC_TWL4030
 	tristate
 
 config SND_SOC_TWL6040
+	select TWL6040_CORE
 	tristate
 
 config SND_SOC_UDA134X
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index ade6616..a20e293 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -24,11 +24,10 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/i2c/twl.h>
+#include <linux/mfd/twl6040.h>
 
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -77,14 +76,12 @@ struct twl6040_jack_data {
 
 /* codec private data */
 struct twl6040_data {
-	int audpwron;
-	int naudint;
 	int codec_powered;
 	int pll;
 	int non_lp;
+	unsigned int clk_in;
 	unsigned int sysclk;
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
-	struct completion ready;
 	struct twl6040_jack_data hs_jack;
 	struct snd_soc_codec *codec;
 	struct workqueue_struct *workqueue;
@@ -239,12 +236,13 @@ static inline void twl6040_write_reg_cache(struct snd_soc_codec *codec,
 static int twl6040_read_reg_volatile(struct snd_soc_codec *codec,
 			unsigned int reg)
 {
+	struct twl6040 *twl6040 = codec->control_data;
 	u8 value;
 
 	if (reg >= TWL6040_CACHEREGNUM)
 		return -EIO;
 
-	twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &value, reg);
+	value = twl6040_reg_read(twl6040, reg);
 	twl6040_write_reg_cache(codec, reg, value);
 
 	return value;
@@ -256,11 +254,13 @@ static int twl6040_read_reg_volatile(struct snd_soc_codec *codec,
 static int twl6040_write(struct snd_soc_codec *codec,
 			unsigned int reg, unsigned int value)
 {
+	struct twl6040 *twl6040 = codec->control_data;
+
 	if (reg >= TWL6040_CACHEREGNUM)
 		return -EIO;
 
 	twl6040_write_reg_cache(codec, reg, value);
-	return twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, value, reg);
+	return twl6040_reg_write(twl6040, reg, value);
 }
 
 static void twl6040_init_vio_regs(struct snd_soc_codec *codec)
@@ -268,15 +268,21 @@ static void twl6040_init_vio_regs(struct snd_soc_codec *codec)
 	u8 *cache = codec->reg_cache;
 	int reg, i;
 
-	/* allow registers to be accessed by i2c */
-	twl6040_write(codec, TWL6040_REG_ACCCTL, cache[TWL6040_REG_ACCCTL]);
-
 	for (i = 0; i < TWL6040_VIOREGNUM; i++) {
 		reg = twl6040_vio_reg[i];
-		/* skip read-only registers (ASICID, ASICREV, STATUS) */
+		/*
+		 * skip read-only registers (ASICID, ASICREV, STATUS)
+		 * and registers shared among MFD children
+		 */
 		switch (reg) {
 		case TWL6040_REG_ASICID:
 		case TWL6040_REG_ASICREV:
+		case TWL6040_REG_INTID:
+		case TWL6040_REG_INTMR:
+		case TWL6040_REG_NCPCTL:
+		case TWL6040_REG_LDOCTL:
+		case TWL6040_REG_GPOCTL:
+		case TWL6040_REG_ACCCTL:
 		case TWL6040_REG_STATUS:
 			continue;
 		default:
@@ -293,6 +299,20 @@ static void twl6040_init_vdd_regs(struct snd_soc_codec *codec)
 
 	for (i = 0; i < TWL6040_VDDREGNUM; i++) {
 		reg = twl6040_vdd_reg[i];
+		/* skip vibra and PLL registers */
+		switch (reg) {
+		case TWL6040_REG_VIBCTLL:
+		case TWL6040_REG_VIBDATL:
+		case TWL6040_REG_VIBCTLR:
+		case TWL6040_REG_VIBDATR:
+		case TWL6040_REG_HPPLLCTL:
+		case TWL6040_REG_LPPLLCTL:
+		case TWL6040_REG_LPPLLDIV:
+			continue;
+		default:
+			break;
+		}
+
 		twl6040_write(codec, reg, cache[reg]);
 	}
 }
@@ -596,88 +616,6 @@ static int pga_event(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
-/* twl6040 codec manual power-up sequence */
-static void twl6040_power_up(struct snd_soc_codec *codec)
-{
-	u8 ncpctl, ldoctl, lppllctl, accctl;
-
-	ncpctl = twl6040_read_reg_cache(codec, TWL6040_REG_NCPCTL);
-	ldoctl = twl6040_read_reg_cache(codec, TWL6040_REG_LDOCTL);
-	lppllctl = twl6040_read_reg_cache(codec, TWL6040_REG_LPPLLCTL);
-	accctl = twl6040_read_reg_cache(codec, TWL6040_REG_ACCCTL);
-
-	/* enable reference system */
-	ldoctl |= TWL6040_REFENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	msleep(10);
-	/* enable internal oscillator */
-	ldoctl |= TWL6040_OSCENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(10);
-	/* enable high-side ldo */
-	ldoctl |= TWL6040_HSLDOENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(244);
-	/* enable negative charge pump */
-	ncpctl |= TWL6040_NCPENA | TWL6040_NCPOPEN;
-	twl6040_write(codec, TWL6040_REG_NCPCTL, ncpctl);
-	udelay(488);
-	/* enable low-side ldo */
-	ldoctl |= TWL6040_LSLDOENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(244);
-	/* enable low-power pll */
-	lppllctl |= TWL6040_LPLLENA;
-	twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-	/* reset state machine */
-	accctl |= TWL6040_RESETSPLIT;
-	twl6040_write(codec, TWL6040_REG_ACCCTL, accctl);
-	mdelay(5);
-	accctl &= ~TWL6040_RESETSPLIT;
-	twl6040_write(codec, TWL6040_REG_ACCCTL, accctl);
-	/* disable internal oscillator */
-	ldoctl &= ~TWL6040_OSCENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-}
-
-/* twl6040 codec manual power-down sequence */
-static void twl6040_power_down(struct snd_soc_codec *codec)
-{
-	u8 ncpctl, ldoctl, lppllctl, accctl;
-
-	ncpctl = twl6040_read_reg_cache(codec, TWL6040_REG_NCPCTL);
-	ldoctl = twl6040_read_reg_cache(codec, TWL6040_REG_LDOCTL);
-	lppllctl = twl6040_read_reg_cache(codec, TWL6040_REG_LPPLLCTL);
-	accctl = twl6040_read_reg_cache(codec, TWL6040_REG_ACCCTL);
-
-	/* enable internal oscillator */
-	ldoctl |= TWL6040_OSCENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(10);
-	/* disable low-power pll */
-	lppllctl &= ~TWL6040_LPLLENA;
-	twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-	/* disable low-side ldo */
-	ldoctl &= ~TWL6040_LSLDOENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(244);
-	/* disable negative charge pump */
-	ncpctl &= ~(TWL6040_NCPENA | TWL6040_NCPOPEN);
-	twl6040_write(codec, TWL6040_REG_NCPCTL, ncpctl);
-	udelay(488);
-	/* disable high-side ldo */
-	ldoctl &= ~TWL6040_HSLDOENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	udelay(244);
-	/* disable internal oscillator */
-	ldoctl &= ~TWL6040_OSCENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	/* disable reference system */
-	ldoctl &= ~TWL6040_REFENA;
-	twl6040_write(codec, TWL6040_REG_LDOCTL, ldoctl);
-	msleep(10);
-}
-
 /* set headset dac and driver power mode */
 static int headset_power_mode(struct snd_soc_codec *codec, int high_perf)
 {
@@ -766,33 +704,19 @@ static void twl6040_accessory_work(struct work_struct *work)
 }
 
 /* audio interrupt handler */
-static irqreturn_t twl6040_naudint_handler(int irq, void *data)
+static irqreturn_t twl6040_audio_handler(int irq, void *data)
 {
 	struct snd_soc_codec *codec = data;
+	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
 	u8 intid;
 
-	twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &intid, TWL6040_REG_INTID);
-
-	if (intid & TWL6040_THINT)
-		dev_alert(codec->dev, "die temp over-limit detection\n");
+	intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
 
 	if ((intid & TWL6040_PLUGINT) || (intid & TWL6040_UNPLUGINT))
 		queue_delayed_work(priv->workqueue, &priv->delayed_work,
 							msecs_to_jiffies(200));
 
-	if (intid & TWL6040_HOOKINT)
-		dev_info(codec->dev, "hook detection\n");
-
-	if (intid & TWL6040_HFINT)
-		dev_alert(codec->dev, "hf drivers over current detection\n");
-
-	if (intid & TWL6040_VIBINT)
-		dev_alert(codec->dev, "vib drivers over current detection\n");
-
-	if (intid & TWL6040_READYINT)
-		complete(&priv->ready);
-
 	return IRQ_HANDLED;
 }
 
@@ -1231,36 +1155,11 @@ static int twl6040_add_widgets(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static int twl6040_power_up_completion(struct snd_soc_codec *codec,
-					int naudint)
-{
-	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	int time_left;
-	u8 intid;
-
-	time_left = wait_for_completion_timeout(&priv->ready,
-				msecs_to_jiffies(144));
-
-	if (!time_left) {
-		twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &intid,
-							TWL6040_REG_INTID);
-		if (!(intid & TWL6040_READYINT)) {
-			dev_err(codec->dev, "timeout waiting for READYINT\n");
-			return -ETIMEDOUT;
-		}
-	}
-
-	priv->codec_powered = 1;
-
-	return 0;
-}
-
 static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 				enum snd_soc_bias_level level)
 {
+	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	int audpwron = priv->audpwron;
-	int naudint = priv->naudint;
 	int ret;
 
 	switch (level) {
@@ -1272,62 +1171,30 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 		if (priv->codec_powered)
 			break;
 
-		if (gpio_is_valid(audpwron)) {
-			/* use AUDPWRON line */
-			gpio_set_value(audpwron, 1);
-
-			/* wait for power-up completion */
-			ret = twl6040_power_up_completion(codec, naudint);
-			if (ret)
-				return ret;
+		ret = twl6040_power(twl6040, 1);
+		if (ret)
+			return ret;
 
-			/* sync registers updated during power-up sequence */
-			twl6040_read_reg_volatile(codec, TWL6040_REG_NCPCTL);
-			twl6040_read_reg_volatile(codec, TWL6040_REG_LDOCTL);
-			twl6040_read_reg_volatile(codec, TWL6040_REG_LPPLLCTL);
-		} else {
-			/* use manual power-up sequence */
-			twl6040_power_up(codec);
-			priv->codec_powered = 1;
-		}
+		priv->codec_powered = 1;
 
 		/* initialize vdd/vss registers with reg_cache */
 		twl6040_init_vdd_regs(codec);
 
 		/* Set external boost GPO */
 		twl6040_write(codec, TWL6040_REG_GPOCTL, 0x02);
-
-		/* Set initial minimal gain values */
-		twl6040_write(codec, TWL6040_REG_HSGAIN, 0xFF);
-		twl6040_write(codec, TWL6040_REG_EARCTL, 0x1E);
-		twl6040_write(codec, TWL6040_REG_HFLGAIN, 0x1D);
-		twl6040_write(codec, TWL6040_REG_HFRGAIN, 0x1D);
 		break;
 	case SND_SOC_BIAS_OFF:
 		if (!priv->codec_powered)
 			break;
 
-		if (gpio_is_valid(audpwron)) {
-			/* use AUDPWRON line */
-			gpio_set_value(audpwron, 0);
-
-			/* power-down sequence latency */
-			udelay(500);
-
-			/* sync registers updated during power-down sequence */
-			twl6040_read_reg_volatile(codec, TWL6040_REG_NCPCTL);
-			twl6040_read_reg_volatile(codec, TWL6040_REG_LDOCTL);
-			twl6040_write_reg_cache(codec, TWL6040_REG_LPPLLCTL,
-						0x00);
-		} else {
-			/* use manual power-down sequence */
-			twl6040_power_down(codec);
-		}
-
+		twl6040_power(twl6040, 0);
 		priv->codec_powered = 0;
 		break;
 	}
 
+	/* get PLL and sysclk after power transition */
+	priv->pll = twl6040_get_pll(twl6040);
+	priv->sysclk = twl6040_get_sysclk(twl6040);
 	codec->dapm.bias_level = level;
 
 	return 0;
@@ -1374,39 +1241,40 @@ static int twl6040_hw_params(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
+	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	u8 lppllctl;
-	int rate;
+	unsigned int sysclk;
+	int rate, ret;
 
 	/* nothing to do for high-perf pll, it supports only 48 kHz */
 	if (priv->pll == TWL6040_HPPLL_ID)
 		return 0;
 
-	lppllctl = twl6040_read_reg_cache(codec, TWL6040_REG_LPPLLCTL);
-
 	rate = params_rate(params);
 	switch (rate) {
 	case 11250:
 	case 22500:
 	case 44100:
 	case 88200:
-		lppllctl |= TWL6040_LPLLFIN;
-		priv->sysclk = 17640000;
+		sysclk = 17640000;
 		break;
 	case 8000:
 	case 16000:
 	case 32000:
 	case 48000:
 	case 96000:
-		lppllctl &= ~TWL6040_LPLLFIN;
-		priv->sysclk = 19200000;
+		sysclk = 19200000;
 		break;
 	default:
 		dev_err(codec->dev, "unsupported rate %d\n", rate);
 		return -EINVAL;
 	}
 
-	twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
+	ret = twl6040_set_pll(twl6040, TWL6040_LPPLL_ID, priv->clk_in, sysclk);
+	if (ret)
+		return ret;
+
+	priv->sysclk = twl6040_get_sysclk(twl6040);
 
 	return 0;
 }
@@ -1449,99 +1317,27 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		int clk_id, unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
+	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	u8 hppllctl, lppllctl;
-
-	hppllctl = twl6040_read_reg_cache(codec, TWL6040_REG_HPPLLCTL);
-	lppllctl = twl6040_read_reg_cache(codec, TWL6040_REG_LPPLLCTL);
+	int ret = 0;
 
 	switch (clk_id) {
 	case TWL6040_SYSCLK_SEL_LPPLL:
-		switch (freq) {
-		case 32768:
-			/* headset dac and driver must be in low-power mode */
-			headset_power_mode(codec, 0);
-
-			/* clk32k input requires low-power pll */
-			lppllctl |= TWL6040_LPLLENA;
-			twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-			mdelay(5);
-			lppllctl &= ~TWL6040_HPLLSEL;
-			twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-			hppllctl &= ~TWL6040_HPLLENA;
-			twl6040_write(codec, TWL6040_REG_HPPLLCTL, hppllctl);
-			break;
-		default:
-			dev_err(codec->dev, "unknown mclk freq %d\n", freq);
-			return -EINVAL;
-		}
-
-		/* lppll divider */
-		switch (priv->sysclk) {
-		case 17640000:
-			lppllctl |= TWL6040_LPLLFIN;
-			break;
-		case 19200000:
-			lppllctl &= ~TWL6040_LPLLFIN;
-			break;
-		default:
-			/* sysclk not yet configured */
-			lppllctl &= ~TWL6040_LPLLFIN;
-			priv->sysclk = 19200000;
-			break;
-		}
-
-		twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
+		ret = twl6040_set_pll(twl6040, TWL6040_LPPLL_ID,
+				      freq, priv->sysclk);
+		if (ret)
+			return ret;
 
-		priv->pll = TWL6040_LPPLL_ID;
+		headset_power_mode(codec, 0);
 		priv->sysclk_constraints = &lp_constraints;
 		break;
 	case TWL6040_SYSCLK_SEL_HPPLL:
-		hppllctl &= ~TWL6040_MCLK_MSK;
-
-		switch (freq) {
-		case 12000000:
-			/* mclk input, pll enabled */
-			hppllctl |= TWL6040_MCLK_12000KHZ |
-				    TWL6040_HPLLSQRBP |
-				    TWL6040_HPLLENA;
-			break;
-		case 19200000:
-			/* mclk input, pll disabled */
-			hppllctl |= TWL6040_MCLK_19200KHZ |
-				    TWL6040_HPLLSQRENA |
-				    TWL6040_HPLLBP;
-			break;
-		case 26000000:
-			/* mclk input, pll enabled */
-			hppllctl |= TWL6040_MCLK_26000KHZ |
-				    TWL6040_HPLLSQRBP |
-				    TWL6040_HPLLENA;
-			break;
-		case 38400000:
-			/* clk slicer, pll disabled */
-			hppllctl |= TWL6040_MCLK_38400KHZ |
-				    TWL6040_HPLLSQRENA |
-				    TWL6040_HPLLBP;
-			break;
-		default:
-			dev_err(codec->dev, "unknown mclk freq %d\n", freq);
-			return -EINVAL;
-		}
+		ret = twl6040_set_pll(twl6040, TWL6040_HPPLL_ID,
+				      freq, priv->sysclk);
+		if (ret)
+			return ret;
 
-		/* headset dac and driver must be in high-performance mode */
 		headset_power_mode(codec, 1);
-
-		twl6040_write(codec, TWL6040_REG_HPPLLCTL, hppllctl);
-		udelay(500);
-		lppllctl |= TWL6040_HPLLSEL;
-		twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-		lppllctl &= ~TWL6040_LPLLENA;
-		twl6040_write(codec, TWL6040_REG_LPPLLCTL, lppllctl);
-
-		/* high-performance pll can provide only 19.2 MHz */
-		priv->pll = TWL6040_HPPLL_ID;
-		priv->sysclk = 19200000;
 		priv->sysclk_constraints = &hp_constraints;
 		break;
 	default:
@@ -1549,6 +1345,10 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		return -EINVAL;
 	}
 
+	priv->pll = twl6040_get_pll(twl6040);
+	priv->clk_in = freq;
+	priv->sysclk = twl6040_get_sysclk(twl6040);
+
 	return 0;
 }
 
@@ -1600,11 +1400,8 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
-	struct twl4030_audio_data *twl_codec = codec->dev->platform_data;
 	struct twl6040_data *priv;
-	int audpwron, naudint;
 	int ret = 0;
-	u8 icrev, intmr = TWL6040_ALLINT_MSK;
 
 	priv = kzalloc(sizeof(struct twl6040_data), GFP_KERNEL);
 	if (priv == NULL)
@@ -1612,23 +1409,9 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 	snd_soc_codec_set_drvdata(codec, priv);
 
 	priv->codec = codec;
+	codec->control_data = dev_get_drvdata(codec->dev->parent);
 
-	twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &icrev, TWL6040_REG_ASICREV);
-
-	if (twl_codec && (icrev > 0))
-		audpwron = twl_codec->audpwron_gpio;
-	else
-		audpwron = -EINVAL;
-
-	if (twl_codec)
-		naudint = twl_codec->naudint_irq;
-	else
-		naudint = 0;
-
-	priv->audpwron = audpwron;
-	priv->naudint = naudint;
 	priv->workqueue = create_singlethread_workqueue("twl6040-codec");
-
 	if (!priv->workqueue) {
 		ret = -ENOMEM;
 		goto work_err;
@@ -1638,56 +1421,34 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 
 	mutex_init(&priv->mutex);
 
-	init_completion(&priv->ready);
 	init_completion(&priv->headset.ramp_done);
 	init_completion(&priv->handsfree.ramp_done);
 
-	if (gpio_is_valid(audpwron)) {
-		ret = gpio_request(audpwron, "audpwron");
-		if (ret)
-			goto gpio1_err;
-
-		ret = gpio_direction_output(audpwron, 0);
-		if (ret)
-			goto gpio2_err;
-
-		priv->codec_powered = 0;
-
-		/* enable only codec ready interrupt */
-		intmr &= ~(TWL6040_READYMSK | TWL6040_PLUGMSK);
-
-		/* reset interrupt status to allow correct power up sequence */
-		twl6040_read_reg_volatile(codec, TWL6040_REG_INTID);
-	}
-	twl6040_write(codec, TWL6040_REG_INTMR, intmr);
-
-	if (naudint) {
-		/* audio interrupt */
-		ret = request_threaded_irq(naudint, NULL,
-				twl6040_naudint_handler,
-				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				"twl6040_codec", codec);
-		if (ret)
-			goto gpio2_err;
-	}
-
-	/* init vio registers */
-	twl6040_init_vio_regs(codec);
-
 	priv->hf_workqueue = create_singlethread_workqueue("twl6040-hf");
 	if (priv->hf_workqueue == NULL) {
 		ret = -ENOMEM;
-		goto irq_err;
+		goto hfwq_err;
 	}
 	priv->hs_workqueue = create_singlethread_workqueue("twl6040-hs");
 	if (priv->hs_workqueue == NULL) {
 		ret = -ENOMEM;
-		goto wq_err;
+		goto hswq_err;
 	}
 
 	INIT_DELAYED_WORK(&priv->hs_delayed_work, twl6040_pga_hs_work);
 	INIT_DELAYED_WORK(&priv->hf_delayed_work, twl6040_pga_hf_work);
 
+	ret = twl6040_request_irq(codec->control_data, TWL6040_IRQ_PLUG,
+				  twl6040_audio_handler, 0,
+				  "twl6040_irq_plug", codec);
+	if (ret) {
+		dev_err(codec->dev, "PLUG IRQ request failed: %d\n", ret);
+		goto plugirq_err;
+	}
+
+	/* init vio registers */
+	twl6040_init_vio_regs(codec);
+
 	/* power on device */
 	ret = twl6040_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 	if (ret)
@@ -1700,16 +1461,12 @@ static int twl6040_probe(struct snd_soc_codec *codec)
 	return 0;
 
 bias_err:
+	twl6040_free_irq(codec->control_data, TWL6040_IRQ_PLUG, codec);
+plugirq_err:
 	destroy_workqueue(priv->hs_workqueue);
-wq_err:
+hswq_err:
 	destroy_workqueue(priv->hf_workqueue);
-irq_err:
-	if (naudint)
-		free_irq(naudint, codec);
-gpio2_err:
-	if (gpio_is_valid(audpwron))
-		gpio_free(audpwron);
-gpio1_err:
+hfwq_err:
 	destroy_workqueue(priv->workqueue);
 work_err:
 	kfree(priv);
@@ -1719,17 +1476,9 @@ work_err:
 static int twl6040_remove(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	int audpwron = priv->audpwron;
-	int naudint = priv->naudint;
 
 	twl6040_set_bias_level(codec, SND_SOC_BIAS_OFF);
-
-	if (gpio_is_valid(audpwron))
-		gpio_free(audpwron);
-
-	if (naudint)
-		free_irq(naudint, codec);
-
+	twl6040_free_irq(codec->control_data, TWL6040_IRQ_PLUG, codec);
 	destroy_workqueue(priv->workqueue);
 	destroy_workqueue(priv->hf_workqueue);
 	destroy_workqueue(priv->hs_workqueue);
diff --git a/sound/soc/codecs/twl6040.h b/sound/soc/codecs/twl6040.h
index 23aeed0..234bfad 100644
--- a/sound/soc/codecs/twl6040.h
+++ b/sound/soc/codecs/twl6040.h
@@ -22,124 +22,6 @@
 #ifndef __TWL6040_H__
 #define __TWL6040_H__
 
-#define TWL6040_REG_ASICID		0x01
-#define TWL6040_REG_ASICREV		0x02
-#define TWL6040_REG_INTID		0x03
-#define TWL6040_REG_INTMR		0x04
-#define TWL6040_REG_NCPCTL		0x05
-#define TWL6040_REG_LDOCTL		0x06
-#define TWL6040_REG_HPPLLCTL		0x07
-#define TWL6040_REG_LPPLLCTL		0x08
-#define TWL6040_REG_LPPLLDIV		0x09
-#define TWL6040_REG_AMICBCTL		0x0A
-#define TWL6040_REG_DMICBCTL		0x0B
-#define TWL6040_REG_MICLCTL		0x0C
-#define TWL6040_REG_MICRCTL		0x0D
-#define TWL6040_REG_MICGAIN		0x0E
-#define TWL6040_REG_LINEGAIN		0x0F
-#define TWL6040_REG_HSLCTL		0x10
-#define TWL6040_REG_HSRCTL		0x11
-#define TWL6040_REG_HSGAIN		0x12
-#define TWL6040_REG_EARCTL		0x13
-#define TWL6040_REG_HFLCTL		0x14
-#define TWL6040_REG_HFLGAIN		0x15
-#define TWL6040_REG_HFRCTL		0x16
-#define TWL6040_REG_HFRGAIN		0x17
-#define TWL6040_REG_VIBCTLL		0x18
-#define TWL6040_REG_VIBDATL		0x19
-#define TWL6040_REG_VIBCTLR		0x1A
-#define TWL6040_REG_VIBDATR		0x1B
-#define TWL6040_REG_HKCTL1		0x1C
-#define TWL6040_REG_HKCTL2		0x1D
-#define TWL6040_REG_GPOCTL		0x1E
-#define TWL6040_REG_ALB			0x1F
-#define TWL6040_REG_DLB			0x20
-#define TWL6040_REG_TRIM1		0x28
-#define TWL6040_REG_TRIM2		0x29
-#define TWL6040_REG_TRIM3		0x2A
-#define TWL6040_REG_HSOTRIM		0x2B
-#define TWL6040_REG_HFOTRIM		0x2C
-#define TWL6040_REG_ACCCTL		0x2D
-#define TWL6040_REG_STATUS		0x2E
-
-#define TWL6040_CACHEREGNUM		(TWL6040_REG_STATUS + 1)
-
-#define TWL6040_VIOREGNUM		18
-#define TWL6040_VDDREGNUM		21
-
-/* INTID (0x03) fields */
-
-#define TWL6040_THINT			0x01
-#define TWL6040_PLUGINT			0x02
-#define TWL6040_UNPLUGINT		0x04
-#define TWL6040_HOOKINT			0x08
-#define TWL6040_HFINT			0x10
-#define TWL6040_VIBINT			0x20
-#define TWL6040_READYINT		0x40
-
-/* INTMR (0x04) fields */
-
-#define TWL6040_PLUGMSK			0x02
-#define TWL6040_READYMSK		0x40
-#define TWL6040_ALLINT_MSK		0x7B
-
-/* NCPCTL (0x05) fields */
-
-#define TWL6040_NCPENA			0x01
-#define TWL6040_NCPOPEN			0x40
-
-/* LDOCTL (0x06) fields */
-
-#define TWL6040_LSLDOENA		0x01
-#define TWL6040_HSLDOENA		0x04
-#define TWL6040_REFENA			0x40
-#define TWL6040_OSCENA			0x80
-
-/* HPPLLCTL (0x07) fields */
-
-#define TWL6040_HPLLENA			0x01
-#define TWL6040_HPLLRST			0x02
-#define TWL6040_HPLLBP			0x04
-#define TWL6040_HPLLSQRENA		0x08
-#define TWL6040_HPLLSQRBP		0x10
-#define TWL6040_MCLK_12000KHZ		(0 << 5)
-#define TWL6040_MCLK_19200KHZ		(1 << 5)
-#define TWL6040_MCLK_26000KHZ		(2 << 5)
-#define TWL6040_MCLK_38400KHZ		(3 << 5)
-#define TWL6040_MCLK_MSK		0x60
-
-/* LPPLLCTL (0x08) fields */
-
-#define TWL6040_LPLLENA			0x01
-#define TWL6040_LPLLRST			0x02
-#define TWL6040_LPLLSEL			0x04
-#define TWL6040_LPLLFIN			0x08
-#define TWL6040_HPLLSEL			0x10
-
-/* HSLCTL (0x10) fields */
-
-#define TWL6040_HSDACMODEL		0x02
-#define TWL6040_HSDRVMODEL		0x08
-
-/* HSRCTL (0x11) fields */
-
-#define TWL6040_HSDACMODER		0x02
-#define TWL6040_HSDRVMODER		0x08
-
-/* ACCCTL (0x2D) fields */
-
-#define TWL6040_RESETSPLIT		0x04
-
-#define TWL6040_SYSCLK_SEL_LPPLL	1
-#define TWL6040_SYSCLK_SEL_HPPLL	2
-
-#define TWL6040_HPPLL_ID		1
-#define TWL6040_LPPLL_ID		2
-
-/* STATUS (0x2E) fields */
-
-#define TWL6040_PLUGCOMP		0x02
-
 void twl6040_hs_jack_detect(struct snd_soc_codec *codec,
 			    struct snd_soc_jack *jack, int report);
 
diff --git a/sound/soc/omap/sdp4430.c b/sound/soc/omap/sdp4430.c
index 189e039..5d67c25 100644
--- a/sound/soc/omap/sdp4430.c
+++ b/sound/soc/omap/sdp4430.c
@@ -21,6 +21,8 @@
 
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/twl6040.h>
+
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
-- 
1.7.5.3

