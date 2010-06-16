Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab0FPSzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:55:54 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:44868 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab0FPSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:55:51 -0400
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 14:55:51 EDT
X-ASG-Debug-ID: 1276713666-3414609b0001-xx1T2L
X-Barracuda-Envelope-From: Jesse.Marroquin@maxim-ic.com
From: <jesse.marroquin@maxim-ic.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
       <perex@perex.cz>, <tiwai@suse.de>, <peter.ujfalusi@nokia.com>,
       <barry.song@analog.com>, <jy0922.shim@samsung.com>,
       <morimoto.kuninori@renesas.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
       Jesse Marroquin <jesse.marroquin@maxim-ic.com>,
       Peter Hsiang <peter.hsiang@maxim-ic.com>
X-ASG-Orig-Subj: [PATCH] ASoC: Add max9888 CODEC driver
Subject: [PATCH] ASoC: Add max9888 CODEC driver
Date: Wed, 16 Jun 2010 13:40:57 -0500
Message-ID: <1276713657-27858-1-git-send-email-jesse.marroquin@maxim-ic.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 16 Jun 2010 18:41:25.0057 (UTC) FILETIME=[86056B10:01CB0D83]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1276713666
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Marroquin <jesse.marroquin@maxim-ic.com>

This patch adds max9888 CODEC driver.

Signed-off-by: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
---
 sound/soc/codecs/Kconfig   |    4 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/max9888.c | 1939 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/max9888.h |  180 ++++
 4 files changed, 2125 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/max9888.c
 create mode 100644 sound/soc/codecs/max9888.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index c37c844..7bbdf74 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -71,6 +71,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_WM9705 if SND_SOC_AC97_BUS
 	select SND_SOC_WM9712 if SND_SOC_AC97_BUS
 	select SND_SOC_WM9713 if SND_SOC_AC97_BUS
+	select SND_SOC_MAX9888 if I2C
         help
           Normally ASoC codec drivers are only built if a machine driver which
           uses them is also built since they are only usable with a machine
@@ -273,6 +274,9 @@ config SND_SOC_WM9712
 config SND_SOC_WM9713
 	tristate
 
+config SND_SOC_MAX9888
+	tristate
+
 # Amp
 config SND_SOC_MAX9877
 	tristate
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 4a9c205..e2eab0f 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -57,6 +57,7 @@ snd-soc-wm9705-objs := wm9705.o
 snd-soc-wm9712-objs := wm9712.o
 snd-soc-wm9713-objs := wm9713.o
 snd-soc-wm-hubs-objs := wm_hubs.o
+snd-soc-max9888-objs := max9888.o
 
 # Amp
 snd-soc-max9877-objs := max9877.o
@@ -123,6 +124,7 @@ obj-$(CONFIG_SND_SOC_WM9705)	+= snd-soc-wm9705.o
 obj-$(CONFIG_SND_SOC_WM9712)	+= snd-soc-wm9712.o
 obj-$(CONFIG_SND_SOC_WM9713)	+= snd-soc-wm9713.o
 obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
+obj-$(CONFIG_SND_SOC_MAX9888)	+= snd-soc-max9888.o
 
 # Amp
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
diff --git a/sound/soc/codecs/max9888.c b/sound/soc/codecs/max9888.c
new file mode 100644
index 0000000..c81f177
--- /dev/null
+++ b/sound/soc/codecs/max9888.c
@@ -0,0 +1,1939 @@
+/*
+ * max9888.c -- MAX9888 ALSA SoC Audio driver
+ *
+ * Copyright 2010 Maxim Integrated Products
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+#include <sound/tlv.h>
+
+#include "max9888.h"
+
+#define AUDIO_NAME		"MAX9888"
+#define MAX9888_DRIVER_VERSION	"1.0"
+
+#ifdef MAX9888_DEBUG
+#define dprintk(x...) printk(KERN_WARNING x)
+#else
+#define dprintk(x...)
+#endif
+
+#define err(format, arg...) \
+	printk(KERN_ERR AUDIO_NAME ": " format "\n" , ## arg)
+
+#define info(format, arg...) \
+	printk(KERN_INFO AUDIO_NAME ": " format "\n" , ## arg)
+
+#define warn(format, arg...) \
+	printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)
+
+struct snd_soc_codec_device soc_codec_dev_max9888;
+
+/* codec private data */
+struct max9888_priv {
+	unsigned int sysclk;
+	unsigned int dai1_rate;
+	unsigned int dai1_fmt;
+	unsigned int reg_14_val;
+	unsigned int dai2_rate;
+	unsigned int dai2_fmt;
+	unsigned int reg_1c_val;
+	unsigned int rev_version;
+	struct snd_soc_codec codec;
+};
+
+/*
+ * Equalizer DSP filter coefficients generated from the evkit software tool
+ */
+static unsigned int param_eq_band_1_voice[] = {
+	0x2027, 0xC001, 0x3FFB, 0x0042, 0x0184 };
+static unsigned int param_eq_band_2_voice[] = {
+	0x2027, 0xC003, 0x3FE7, 0x012F, 0x037B };
+static unsigned int param_eq_band_3_voice[] = {
+	0x3EC6, 0xC024, 0x3C2E, 0x043D, 0x15C7 };
+static unsigned int param_eq_band_4_voice[] = {
+	0x3EC6, 0xC261, 0x344F, 0x1145, 0x24DF };
+static unsigned int param_eq_band_5_voice[] = {
+	0x2027, 0xEEB0, 0x38F9, 0x3D9C, 0x1D26 };
+static unsigned int param_eq_band_1_music[] = {
+	0x1027, 0xC001, 0x3F9F, 0x006C, 0x06F2, };
+static unsigned int param_eq_band_2_music[] = {
+	0x2894, 0xC003, 0x3F32, 0x0110, 0x0A1A, };
+static unsigned int param_eq_band_3_music[] = {
+	0x2D25, 0xC072, 0x39F3, 0x0782, 0x1B29, };
+static unsigned int param_eq_band_4_music[] = {
+	0x1463, 0xC59A, 0x2876, 0x1A2E, 0x3195, };
+static unsigned int param_eq_band_5_music[] = {
+	0x4000, 0xD468, 0x30EA, 0x2EDB, 0x2944, };
+
+static unsigned int param_eq_band_1_flat[] = {
+	0x2027, 0xc001, 0x3ff1, 0x006a, 0x02b4 };
+static unsigned int param_eq_band_2_flat[] = {
+	0x2027, 0xc008, 0x3fcc, 0x01e4, 0x0512 };
+static unsigned int param_eq_band_3_flat[] = {
+	0x2027, 0xc052, 0x3f77, 0x0661, 0x083e };
+static unsigned int param_eq_band_4_flat[] = {
+	0x2027, 0xc2dd, 0x3e60, 0x12eb, 0x0e54 };
+static unsigned int param_eq_band_5_flat[] = {
+	0x2027, 0xe611, 0x36fa, 0x3a82, 0x20c2 };
+
+static unsigned int param_eq_band_1_trebel_reduce[] = {
+	0x2027, 0xC001, 0x3FFB, 0x0042, 0x0184, };
+static unsigned int param_eq_band_2_trebel_reduce[] = {
+	0x2027, 0xC003, 0x3FE7, 0x012F, 0x037B, };
+static unsigned int param_eq_band_3_trebel_reduce[] = {
+	0x2027, 0xC028, 0x3FA4, 0x0471, 0x06BC, };
+static unsigned int param_eq_band_4_trebel_reduce[] = {
+	0x16AE, 0xC22A, 0x2FAF, 0x1080, 0x2AAF, };
+static unsigned int param_eq_band_5_trebel_reduce[] = {
+	0x1027, 0xEBF3, 0xFC34, 0x3CC6, 0x3FE3, };
+
+static unsigned int param_eq_band_1_loudness[] = {
+	0x3F62, 0xC001, 0x3FDF, 0x0042, 0x040B, };
+static unsigned int param_eq_band_2_loudness[] = {
+	0x2D25, 0xC003, 0x3F08, 0x0101, 0x0B17, };
+static unsigned int param_eq_band_3_loudness[] = {
+	0x2027, 0xC028, 0x3FA4, 0x0471, 0x06BC, };
+static unsigned int param_eq_band_4_loudness[] = {
+	0x2D25, 0xC245, 0x3290, 0x10E2, 0x273B, };
+static unsigned int param_eq_band_5_loudness[] = {
+	0x4000, 0xEBF3, 0x149E, 0x3CC6, 0x3C96, };
+
+/*
+ * Dynamic high pass excursion limiter filter coefficients.
+ * The coefficients define the user programmable frequency response for the
+ * excursion limiter.
+ * Use the PC evkit software to generate the coefficients and put it here.
+ */
+static unsigned int param_ex_resp_a[] = { 0, 0, 0, 0, 0 };
+static unsigned int param_ex_resp_b[] = { 0, 0, 0, 0, 0 };
+static unsigned int param_ex_resp_c[] = { 0, 0, 0, 0, 0 };
+
+/*
+ * Read the MAX9888 register space
+ */
+static unsigned int max9888_read(struct snd_soc_codec *codec, unsigned int reg)
+{
+	struct i2c_msg msg[2];
+	struct i2c_client *client;
+	u8 data[2];
+	int ret = 0;
+
+	client = (struct i2c_client *)codec->control_data;
+	data[0] = reg;
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].buf = &data[0];
+	msg[0].len = 1;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = &data[1];
+	msg[1].len = 1;
+#if defined(CONFIG_I2C)
+	ret = i2c_transfer(client->adapter, &msg[0], 2);
+#endif
+	return (ret == 2) ? data[1] : -EIO;
+}
+
+/*
+ * Write to the MAX9888 register space
+ */
+static int max9888_write(struct snd_soc_codec *codec, unsigned int reg,
+			 unsigned int value)
+{
+	u8 data[2];
+
+	data[0] = reg;
+	data[1] = value;
+
+	dprintk("%s 0x%02x=0x%02x\n", __func__, reg, value);
+	if (codec->hw_write(codec->control_data, data, 2) == 2)
+		return 0;
+	else
+		return -EIO;
+}
+
+#define INA1_PGA_BIT	0x01
+#define INA2_PGA_BIT	0x02
+#define INB1_PGA_BIT	0x04
+#define INB2_PGA_BIT	0x08
+
+/*
+ * The INx1 and INx2 PGA's share a power control signal.
+ * This function OR's the two power events to keep an unpowered INx
+ * from turning off it's counterpart.
+ * The control names are used to identify the PGA.
+ */
+int max9888_pga_event(struct snd_soc_dapm_widget *w, struct snd_kcontrol *k,
+			 int event)
+{
+	struct snd_soc_codec *codec = w->codec;
+	unsigned int val;
+	unsigned int pga;
+	unsigned int mask;
+	static int power_state;
+
+	if (w->reg != M9888_REG_4A_PWR_EN_IN)
+		return -EINVAL;
+
+	if (strncmp(w->name, "INA1", 4) == 0) {
+		pga = INA1_PGA_BIT;
+		mask = INA1_PGA_BIT | INA2_PGA_BIT;
+	} else if (strncmp(w->name, "INA2", 4) == 0) {
+		pga = INA2_PGA_BIT;
+		mask = INA1_PGA_BIT | INA2_PGA_BIT;
+	} else if (strncmp(w->name, "INB1", 4) == 0) {
+		pga = INB1_PGA_BIT;
+		mask = INB1_PGA_BIT | INB2_PGA_BIT;
+	} else if (strncmp(w->name, "INB2", 4) == 0) {
+		pga = INB2_PGA_BIT;
+		mask = INB1_PGA_BIT | INB2_PGA_BIT;
+	} else {
+		return -EINVAL;
+	}
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+
+		power_state |= pga;
+
+		/* Turn on, avoiding unnecessary writes */
+		val = max9888_read(codec, w->reg);
+
+		if (!(val & (1 << w->shift))) {
+			val |= (1 << w->shift);
+			max9888_write(codec, w->reg, val | MBEN);
+		}
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
+		power_state &= ~pga;
+
+		/* Turn off if both are off, avoiding unnecessary writes */
+		if (!(power_state & mask)) {
+			val = max9888_read(codec, w->reg);
+			if (val & (1 << w->shift)) {
+				val &= ~(1 << w->shift);
+				max9888_write(codec, w->reg, val & ~MBEN);
+			}
+		}
+		break;
+	default:
+		val = max9888_read(codec, w->reg);
+		max9888_write(codec, w->reg, val | MBEN);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Define a few static eq settings
+ */
+static const char *max9888_eq[] = {
+	"voice", "music", "flat", "treble reduce", "loudness" };
+
+static const struct soc_enum max9888_eq_enum[] = {
+	SOC_ENUM_SINGLE_EXT(5, max9888_eq),
+};
+
+enum max9888_eq_enumeration {
+	MAX9888_EQ_VOICE = 0,
+	MAX9888_EQ_MUSIC,
+	MAX9888_EQ_FLAT,
+	MAX9888_EQ_TREBLE_REDUCE,
+	MAX9888_EQ_LOUDNESS
+};
+
+static int max9888_eq1_value = MAX9888_EQ_FLAT;
+static int max9888_eq2_value = MAX9888_EQ_FLAT;
+
+/*
+ * Do work of loading regs from table
+ */
+int m9888_eq_band(struct snd_soc_codec *codec, unsigned int dai,
+		  unsigned int band, unsigned int *coefs)
+{
+	unsigned int eq_reg;
+	unsigned int i;
+
+	if (band > 4)
+		return 1;
+
+	if (dai > 1)
+		return 1;
+
+	/* Load the base register address */
+	eq_reg = dai ? M9888_REG_82_DAI2_EQ_BASE : M9888_REG_50_DAI1_EQ_BASE;
+
+	/* Add the band address offset, note adjustment for word address */
+	eq_reg += band * (REGS_PER_BAND << 1);
+
+	/* Step through the registers and coefs */
+	for (i = 0; i < REGS_PER_BAND; i++) {
+		max9888_write(codec, eq_reg++, HIGH_BYTE(coefs[i]));
+		max9888_write(codec, eq_reg++, LOW_BYTE(coefs[i]));
+	}
+
+	return 0;
+}
+
+/*
+ * Load selected eq from coefficient table
+ */
+int m9888_eq_control(struct snd_soc_codec *codec, unsigned int dai,
+		     unsigned int curve)
+{
+	switch (curve) {
+	case MAX9888_EQ_VOICE:
+		m9888_eq_band(codec, dai, 0, param_eq_band_1_voice);
+		m9888_eq_band(codec, dai, 1, param_eq_band_2_voice);
+		m9888_eq_band(codec, dai, 2, param_eq_band_3_voice);
+		m9888_eq_band(codec, dai, 3, param_eq_band_4_voice);
+		m9888_eq_band(codec, dai, 4, param_eq_band_5_voice);
+		break;
+	case MAX9888_EQ_MUSIC:
+		m9888_eq_band(codec, dai, 0, param_eq_band_1_music);
+		m9888_eq_band(codec, dai, 1, param_eq_band_2_music);
+		m9888_eq_band(codec, dai, 2, param_eq_band_3_music);
+		m9888_eq_band(codec, dai, 3, param_eq_band_4_music);
+		m9888_eq_band(codec, dai, 4, param_eq_band_5_music);
+		break;
+	case MAX9888_EQ_FLAT:
+		m9888_eq_band(codec, dai, 0, param_eq_band_1_flat);
+		m9888_eq_band(codec, dai, 1, param_eq_band_2_flat);
+		m9888_eq_band(codec, dai, 2, param_eq_band_3_flat);
+		m9888_eq_band(codec, dai, 3, param_eq_band_4_flat);
+		m9888_eq_band(codec, dai, 4, param_eq_band_5_flat);
+		break;
+	case MAX9888_EQ_TREBLE_REDUCE:
+		m9888_eq_band(codec, dai, 0, param_eq_band_1_trebel_reduce);
+		m9888_eq_band(codec, dai, 1, param_eq_band_2_trebel_reduce);
+		m9888_eq_band(codec, dai, 2, param_eq_band_3_trebel_reduce);
+		m9888_eq_band(codec, dai, 3, param_eq_band_4_trebel_reduce);
+		m9888_eq_band(codec, dai, 4, param_eq_band_5_trebel_reduce);
+		break;
+	case MAX9888_EQ_LOUDNESS:
+		m9888_eq_band(codec, dai, 0, param_eq_band_1_loudness);
+		m9888_eq_band(codec, dai, 1, param_eq_band_2_loudness);
+		m9888_eq_band(codec, dai, 2, param_eq_band_3_loudness);
+		m9888_eq_band(codec, dai, 3, param_eq_band_4_loudness);
+		m9888_eq_band(codec, dai, 4, param_eq_band_5_loudness);
+		break;
+	}
+
+	return 1;
+}
+
+/*
+ * Load new eq settings
+ */
+static int max9888_eq1_set(struct snd_kcontrol *kcontrol,
+			   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	unsigned char reg;
+
+	max9888_eq1_value = ucontrol->value.integer.value[0];
+
+	reg = max9888_read(codec, M9888_REG_47_CFG_LEVEL);
+	reg &= ~EQ1EN;
+	max9888_write(codec, M9888_REG_47_CFG_LEVEL, reg);
+
+	m9888_eq_control(codec, 0, max9888_eq1_value);
+
+	reg |= EQ1EN;
+	max9888_write(codec, M9888_REG_47_CFG_LEVEL, reg);
+
+	return 1;
+}
+
+/*
+ * Return current eq setting
+ */
+static int max9888_eq1_get(struct snd_kcontrol *kcontrol,
+			   struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = max9888_eq1_value;
+	return 0;
+}
+
+/*
+ * Load new eq settings
+ */
+static int max9888_eq2_set(struct snd_kcontrol *kcontrol,
+			   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	unsigned char reg;
+
+	max9888_eq2_value = ucontrol->value.integer.value[0];
+
+	reg = max9888_read(codec, M9888_REG_47_CFG_LEVEL);
+	reg &= ~EQ2EN;
+	max9888_write(codec, M9888_REG_47_CFG_LEVEL, reg);
+
+	m9888_eq_control(codec, 1, max9888_eq2_value);
+
+	reg |= EQ2EN;
+	max9888_write(codec, M9888_REG_47_CFG_LEVEL, reg);
+
+	return 1;
+}
+
+/*
+ * Return current eq setting
+ */
+static int max9888_eq2_get(struct snd_kcontrol *kcontrol,
+			   struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = max9888_eq2_value;
+	return 0;
+}
+
+/*
+ * Excursion limiter modes
+ */
+static const char *max9888_ex_mode[] = {
+	"disable",
+	"100Hz",
+	"400Hz",
+	"600Hz",
+	"800Hz",
+	"1000Hz",
+	"200-400Hz",
+	"400-600Hz",
+	"400-800Hz",
+	"user-400Hz",
+	"user-600Hz",
+	"user-800Hz",
+	"user-1000Hz"
+};
+
+static const unsigned int ex_mode_table[] = {
+	0x00,
+	(0 << 4) | 3,
+	(1 << 4) | 0,
+	(2 << 4) | 0,
+	(3 << 4) | 0,
+	(4 << 4) | 0,
+	(1 << 4) | 1,
+	(2 << 4) | 2,
+	(3 << 4) | 2,
+	(1 << 4) | 3,
+	(2 << 4) | 3,
+	(3 << 4) | 3,
+	(4 << 4) | 3
+};
+
+static const struct soc_enum max9888_ex_mode_enum[] = {
+	SOC_ENUM_SINGLE_EXT(13, max9888_ex_mode),
+};
+
+static unsigned int max9888_ex_mode_value;
+
+/*
+ * Excursion limiter mode - set mode
+ */
+static int max9888_ex_mode_set(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	max9888_ex_mode_value = ucontrol->value.integer.value[0];
+
+	if (max9888_ex_mode_value <= 13) {
+		max9888_write(codec, M9888_REG_3F_SPKDHP,
+			      ex_mode_table[max9888_ex_mode_value]);
+	}
+
+	return 1;
+}
+
+/*
+ * Excursion limiter mode - get mode
+ */
+static int max9888_ex_mode_get(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = max9888_ex_mode_value;
+	return 0;
+}
+
+/*
+ * Functions and control structures for loading
+ * static coefficients into the bi-quad filter.
+ *
+ * As it is the user has a choice of three filters - a, b, or c.
+ */
+static const char *max9888_ex_resp[] = { "a", "b", "c" };
+
+static const struct soc_enum max9888_ex_resp_enum[] = {
+	SOC_ENUM_SINGLE_EXT(3, max9888_ex_resp),
+};
+
+enum max9888_ex_resp_enumeration {
+	MAX9888_BIQUAD_A = 0,
+	MAX9888_BIQUAD_B,
+	MAX9888_BIQUAD_C
+};
+
+static int max9888_ex1_resp_value = MAX9888_BIQUAD_A;
+static int max9888_ex2_resp_value = MAX9888_BIQUAD_A;
+
+/*
+ * Load user programmable mode excursion limiter filter coefficients
+ */
+static void max9888_ex_resp_control(struct snd_soc_codec *codec, int reg,
+				    unsigned int *param)
+{
+	max9888_write(codec, reg, HIGH_BYTE(param[0]));
+	max9888_write(codec, ++reg, LOW_BYTE(param[0]));
+	max9888_write(codec, ++reg, HIGH_BYTE(param[1]));
+	max9888_write(codec, ++reg, LOW_BYTE(param[1]));
+	max9888_write(codec, ++reg, HIGH_BYTE(param[2]));
+	max9888_write(codec, ++reg, LOW_BYTE(param[2]));
+	max9888_write(codec, ++reg, HIGH_BYTE(param[3]));
+	max9888_write(codec, ++reg, LOW_BYTE(param[3]));
+	max9888_write(codec, ++reg, HIGH_BYTE(param[4]));
+	max9888_write(codec, ++reg, LOW_BYTE(param[4]));
+}
+
+/*
+ * Select and load excursion limiter user mode coefficient selection
+ */
+static int max9888_ex1_resp_set(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	max9888_ex1_resp_value = ucontrol->value.integer.value[0];
+
+	switch (max9888_ex1_resp_value) {
+	case MAX9888_BIQUAD_A:
+		max9888_ex_resp_control(codec, M9888_REG_B4_DAI1_BIQUAD_BASE,
+					param_ex_resp_a);
+		break;
+
+	case MAX9888_BIQUAD_B:
+		max9888_ex_resp_control(codec, M9888_REG_B4_DAI1_BIQUAD_BASE,
+					param_ex_resp_b);
+		break;
+
+	case MAX9888_BIQUAD_C:
+		max9888_ex_resp_control(codec, M9888_REG_B4_DAI1_BIQUAD_BASE,
+					param_ex_resp_c);
+		break;
+	}
+
+	return 1;
+}
+
+/*
+ * Return current excursion limiter user mode coefficient selection
+ */
+static int max9888_ex1_resp_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = max9888_ex1_resp_value;
+	return 0;
+}
+
+/*
+ * Select and load excursion limiter user mode coefficient selection
+ */
+static int max9888_ex2_resp_set(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	max9888_ex2_resp_value = ucontrol->value.integer.value[0];
+
+	switch (max9888_ex2_resp_value) {
+	case MAX9888_BIQUAD_A:
+		max9888_ex_resp_control(codec, M9888_REG_BE_DAI2_BIQUAD_BASE,
+					param_ex_resp_a);
+		break;
+
+	case MAX9888_BIQUAD_B:
+		max9888_ex_resp_control(codec, M9888_REG_BE_DAI2_BIQUAD_BASE,
+					param_ex_resp_b);
+		break;
+
+	case MAX9888_BIQUAD_C:
+		max9888_ex_resp_control(codec, M9888_REG_BE_DAI2_BIQUAD_BASE,
+					param_ex_resp_c);
+		break;
+	}
+
+	return 1;
+}
+
+/*
+ * Return current excursion limiter user mode coefficient selection
+ */
+static int max9888_ex2_resp_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = max9888_ex2_resp_value;
+	return 0;
+}
+
+/*
+ * Control mic1 analog amplifier circuit on/off, and gain
+ * Typical setting: register value of 0x7F for 30dB mic gain
+ */
+void m9888_mic1_gain_control(struct snd_soc_codec *codec, unsigned int gain,
+			     unsigned int power_on)
+{
+	/* power off the amplifier */
+	if (power_on == 0) {
+		max9888_write(codec, M9888_REG_31_LVL_MIC1, 0x00);
+		return;
+	}
+	/* 0dB..19dB */
+	if (gain < 20) {
+		max9888_write(codec, M9888_REG_31_LVL_MIC1,
+			      (1 << 5) | (20 - gain));
+		return;
+	}
+	/* 20dB..29dB */
+	if (gain < 30) {
+		max9888_write(codec, M9888_REG_31_LVL_MIC1,
+			      (2 << 5) | (40 - gain));
+		return;
+	}
+	/* 30dB..49B */
+	if (gain < 50) {
+		max9888_write(codec, M9888_REG_31_LVL_MIC1,
+			      (3 << 5) | (50 - gain));
+		return;
+	}
+	/* set to maximum 50dB */
+	max9888_write(codec, M9888_REG_31_LVL_MIC1, (3 << 5) | 0);
+}
+
+/*
+ * Control mic2 analog amplifier circuit on/off, and gain
+ * Typical setting: register value of 0x7F for 30dB mic gain
+ */
+void m9888_mic2_gain_control(struct snd_soc_codec *codec, unsigned int gain,
+			     unsigned int power_on)
+{
+	/* power off the amplifier */
+	if (power_on == 0) {
+		max9888_write(codec, M9888_REG_32_LVL_MIC2, 0x00);
+		return;
+	}
+	/* 0dB..19dB */
+	if (gain < 20) {
+		max9888_write(codec, M9888_REG_32_LVL_MIC2,
+			      (1 << 5) | (20 - gain));
+		return;
+	}
+	/* 20dB..29dB */
+	if (gain < 30) {
+		max9888_write(codec, M9888_REG_32_LVL_MIC2,
+			      (2 << 5) | (40 - gain));
+		return;
+	}
+	/* 30dB..49B */
+	if (gain < 50) {
+		max9888_write(codec, M9888_REG_32_LVL_MIC2,
+			      (3 << 5) | (50 - gain));
+		return;
+	}
+	/* set to maximum 50dB */
+	max9888_write(codec, M9888_REG_32_LVL_MIC2, (3 << 5) | 0);
+}
+
+/*
+ * Set headphone output volume and mute setting
+ */
+void headphone_set_volume(struct snd_soc_codec *codec, u8 vol, u8 mute)
+{
+
+	if (vol > 0x1F)
+		vol = 0x1F;
+
+	if (mute > 1)
+		mute = 1;
+
+	max9888_write(codec, M9888_REG_38_LVL_HEADPHONE_L,
+		      (mute << 7) | (vol << 0));
+	max9888_write(codec, M9888_REG_39_LVL_HEADPHONE_R,
+		      (mute << 7) | (vol << 0));
+}
+
+/*
+ * set receiver output volume and mute setting
+ */
+void receiver_set_volume(struct snd_soc_codec *codec, u8 vol, u8 mute)
+{
+
+	if (vol > 0x1F)
+		vol = 0x1F;
+
+	if (mute > 1)
+		mute = 1;
+
+	max9888_write(codec, M9888_REG_3A_LVL_RECEIVER,
+		      (mute << 7) | (vol << 0));
+}
+
+/*
+ * set speaker output volume and mute setting
+ */
+void speaker_set_volume(struct snd_soc_codec *codec, u8 vol, u8 mute)
+{
+
+	if (vol > 0x1F)
+		vol = 0x1F;
+
+	if (mute > 1)
+		mute = 1;
+
+	max9888_write(codec, M9888_REG_3B_LVL_SPEAKER_L,
+		      (mute << 7) | (vol << 0));
+	max9888_write(codec, M9888_REG_3C_LVL_SPEAKER_R,
+		      (mute << 7) | (vol << 0));
+}
+
+/*
+ * configure speaker ALC
+ */
+void m9888_speaker_ALC_control(struct snd_soc_codec *codec)
+{
+	/* compressor enable */
+	max9888_write(codec, M9888_REG_41_SPKALC_COMP, (0 << 7) |
+		      (7 << 4) | (0 << 3) | (0 << 0));
+}
+
+/*
+ * Control mic AGC for both microphone inputs.
+ */
+void m9888_mic_AGC_control(struct snd_soc_codec *codec)
+{
+	max9888_write(codec, M9888_REG_3D_MICAGC_CFG, (0 << 7) |
+		      (0 << 4) | (0 << 2) | (0 << 0));
+
+	max9888_write(codec, M9888_REG_3E_MICAGC_THRESHOLD, (0 << 4) |
+		      (0 << 0));
+}
+
+/*
+ * Mute the speaker
+ */
+static const char *max9888_hp_spk_mute[] = { "disable", "enable" };
+
+static const struct soc_enum max9888_hp_spk_mute_enum[] = {
+	SOC_ENUM_SINGLE_EXT(2, max9888_hp_spk_mute),
+};
+
+#define MAX9888_HP_SPK_MUTE_DISABLE	0
+#define MAX9888_HP_SPK_MUTE_ENABLE	1
+
+static int max9888_spk_mute_set(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	u8 lReg = max9888_read(codec, M9888_REG_3B_LVL_SPEAKER_L);
+	u8 rReg = max9888_read(codec, M9888_REG_3C_LVL_SPEAKER_R);
+
+	if (ucontrol->value.integer.value[0] == MAX9888_HP_SPK_MUTE_ENABLE) {
+		/* Enable mute for both channels */
+		lReg |= SPXM;
+		rReg |= SPXM;
+	} else if (ucontrol->value.integer.value[0]
+			== MAX9888_HP_SPK_MUTE_DISABLE) {
+		/* Disable mute for both channels */
+		lReg &= ~SPXM;
+		rReg &= ~SPXM;
+	} else {
+		return -1;
+	}
+
+	max9888_write(codec, M9888_REG_3B_LVL_SPEAKER_L, lReg);
+	max9888_write(codec, M9888_REG_3C_LVL_SPEAKER_R, rReg);
+
+	return 1;
+}
+
+static int max9888_spk_mute_get(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	u8 reg = max9888_read(codec, M9888_REG_3B_LVL_SPEAKER_L);
+
+	ucontrol->value.integer.value[0] = (reg & SPXM) ? 1 : 0;
+
+	return 0;
+}
+
+/*
+ * Mute the headphone
+ */
+static int max9888_hp_mute_set(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	u8 lReg = max9888_read(codec, M9888_REG_38_LVL_HEADPHONE_L);
+	u8 rReg = max9888_read(codec, M9888_REG_39_LVL_HEADPHONE_R);
+
+	if (MAX9888_HP_SPK_MUTE_ENABLE == ucontrol->value.integer.value[0]) {
+		/* Enable mute for both channels */
+		lReg |= HPXM;
+		rReg |= HPXM;
+	} else {
+		/* Disable mute for both channels */
+		lReg &= ~HPXM;
+		rReg &= ~HPXM;
+	}
+
+	max9888_write(codec, M9888_REG_38_LVL_HEADPHONE_L, lReg);
+	max9888_write(codec, M9888_REG_39_LVL_HEADPHONE_R, rReg);
+
+	return 1;
+}
+
+/*
+ * Get current headphone mute hardware register setting
+ */
+static int max9888_hp_mute_get(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	u8 reg = max9888_read(codec, M9888_REG_38_LVL_HEADPHONE_L);
+
+	ucontrol->value.integer.value[0] = (reg & HPXM) ? 1 : 0;
+	return 0;
+}
+
+static const char *max9888_rx_mute[] = { "disable", "enable" };
+static const char *max9888_fltr_mode[] = { "voice", "music" };
+static const char *max9888_highrate[] = { ">50khz", "<50khz" };
+
+static const char *max9888_dai1_fltr[] = {
+	"disable", "fc=258/fs=16k", "fc=500/fs=16k",
+	"fc=258/fs=8k", "fc=500/fs=8k", "fc=200" };
+static const char *max9888_dc_block[] = { "disable", "enable" };
+static const char *max9888_exlimit_threshold[] = {
+	"0.6v", "1.2v", "1.8v", "2.4v", "3.0", "3.6v", "4.2v", "4.8v" };
+
+static const struct soc_enum max9888_enum[] = {
+	SOC_ENUM_SINGLE(M9888_REG_3A_LVL_RECEIVER, 7, 2, max9888_rx_mute),
+	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 7, 2, max9888_fltr_mode),
+	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 3, 2, max9888_highrate),
+	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 0, 6, max9888_dai1_fltr),
+	SOC_ENUM_SINGLE(M9888_REG_18_DAI1_FILTERS, 4, 6, max9888_dai1_fltr),
+	SOC_ENUM_SINGLE(M9888_REG_20_DAI2_FILTERS, 3, 2, max9888_highrate),
+	SOC_ENUM_SINGLE(M9888_REG_20_DAI2_FILTERS, 0, 2, max9888_dc_block),
+	SOC_ENUM_SINGLE(M9888_REG_40_SPKDHP_THRESHOLD, 0, 8,
+			max9888_exlimit_threshold)
+};
+
+static const struct snd_kcontrol_new max9888_snd_controls[] = {
+
+	/* analog output levels */
+	SOC_DOUBLE_R("hp_vol", M9888_REG_38_LVL_HEADPHONE_L,
+		     M9888_REG_39_LVL_HEADPHONE_R, 0, 31, 0),
+	SOC_DOUBLE_R("spk_vol", M9888_REG_3B_LVL_SPEAKER_L,
+		     M9888_REG_3C_LVL_SPEAKER_R, 0, 31, 0),
+	SOC_SINGLE("rec_vol", M9888_REG_3A_LVL_RECEIVER, 0, 31, 0),
+
+	SOC_ENUM_EXT("hp_mute", max9888_hp_spk_mute_enum, max9888_hp_mute_get,
+		     max9888_hp_mute_set),
+	SOC_ENUM_EXT("spk_mute", max9888_hp_spk_mute_enum, max9888_spk_mute_get,
+		     max9888_spk_mute_set),
+	SOC_ENUM("rec_mute", max9888_enum[0]),
+
+	/* analog input levels */
+	SOC_SINGLE("mic1_gain", M9888_REG_31_LVL_MIC1, 0, 31, 1),
+	SOC_SINGLE("mic2_gain", M9888_REG_32_LVL_MIC2, 0, 31, 1),
+
+	SOC_SINGLE("mic1_pre", M9888_REG_31_LVL_MIC1, 5, 3, 0),
+	SOC_SINGLE("mic2_pre", M9888_REG_32_LVL_MIC2, 5, 3, 0),
+
+	SOC_SINGLE("ina_gain", M9888_REG_33_LVL_INA, 0, 7, 1),
+	SOC_SINGLE("inb_gain", M9888_REG_34_LVL_INB, 0, 7, 1),
+
+	/* digital gains */
+	SOC_SINGLE("adcl_dvol", M9888_REG_2F_LVL_ADC_L, 0, 15, 0),
+	SOC_SINGLE("adcr_dvol", M9888_REG_30_LVL_ADC_R, 0, 15, 0),
+
+	SOC_SINGLE("adcl_dgain", M9888_REG_2F_LVL_ADC_L, 4, 3, 0),
+	SOC_SINGLE("adcr_dgain", M9888_REG_30_LVL_ADC_R, 4, 3, 0),
+
+	/* equalizer */
+	SOC_SINGLE("eq1_enable", M9888_REG_47_CFG_LEVEL, 0, 1, 0),
+	SOC_SINGLE("eq2_enable", M9888_REG_47_CFG_LEVEL, 1, 1, 0),
+
+	SOC_SINGLE("eq1_atten", M9888_REG_2C_LVL_DAI1_PLAY_EQ, 0, 15, 0),
+	SOC_SINGLE("eq2_atten", M9888_REG_2E_LVL_DAI2_PLAY_EQ, 0, 15, 0),
+
+	SOC_ENUM_EXT("eq1_resp", max9888_eq_enum, max9888_eq1_get,
+		     max9888_eq1_set),
+	SOC_ENUM_EXT("eq2_resp", max9888_eq_enum, max9888_eq2_get,
+		     max9888_eq2_set),
+
+	/* excursion limiter */
+	SOC_ENUM_EXT("exlmt_mode", max9888_ex_mode_enum, max9888_ex_mode_get,
+		     max9888_ex_mode_set),
+	SOC_ENUM("exlmt_thresh", max9888_enum[7]),
+	SOC_ENUM_EXT("exlmt1_resp", max9888_ex_resp_enum, max9888_ex1_resp_get,
+		     max9888_ex1_resp_set),
+	SOC_ENUM_EXT("exlmt2_resp", max9888_ex_resp_enum, max9888_ex2_resp_get,
+		     max9888_ex2_resp_set),
+
+	/* voice/music filters */
+	SOC_ENUM("dai1_flt_mode", max9888_enum[1]),
+	SOC_ENUM("dai1_flt_dac", max9888_enum[3]),
+	SOC_ENUM("dai1_flt_adc", max9888_enum[4]),
+
+	SOC_ENUM("dai1_highrate", max9888_enum[2]),
+	SOC_ENUM("dai2_highrate", max9888_enum[5]),
+	SOC_ENUM("dai2_dcblock", max9888_enum[6]),
+
+	/* automatic level control (for both DAI1/DAI2) */
+	SOC_SINGLE("alc_enable", M9888_REG_41_SPKALC_COMP, 7, 1, 0),
+	SOC_SINGLE("alc_thresh", M9888_REG_41_SPKALC_COMP, 0, 7, 0),
+	SOC_SINGLE("alc_multiband", M9888_REG_41_SPKALC_COMP, 3, 1, 0),
+	SOC_SINGLE("alc_rlstime", M9888_REG_41_SPKALC_COMP, 4, 7, 0),
+
+	/* power limiter */
+	SOC_SINGLE("pwlmt_thresh", M9888_REG_42_PWRLMT_CFG, 4, 15, 0),
+	SOC_SINGLE("pwlmt_weight", M9888_REG_42_PWRLMT_CFG, 0, 7, 0),
+	SOC_SINGLE("pwlmt_time1", M9888_REG_43_PWRLMT_TIME, 0, 15, 0),
+	SOC_SINGLE("pwlmt_time2", M9888_REG_43_PWRLMT_TIME, 4, 15, 0),
+
+	/* THD distortion limiter */
+	SOC_SINGLE("thdlmt_thresh", M9888_REG_44_THDLMT_CFG, 4, 15, 0),
+	SOC_SINGLE("thdlmt_time", M9888_REG_44_THDLMT_CFG, 0, 7, 0),
+};
+
+/* Left speaker mixer switch */
+static const struct snd_kcontrol_new max9888_left_speaker_mixer_controls[] = {
+	SOC_DAPM_SINGLE("left_dac", M9888_REG_29_MIX_SPEAKER, 7, 1, 0),
+	SOC_DAPM_SINGLE("right_dac", M9888_REG_29_MIX_SPEAKER, 6, 1, 0),
+	SOC_DAPM_SINGLE("preout3", M9888_REG_29_MIX_SPEAKER, 4, 1, 0),
+};
+
+/* Right speaker mixer switch */
+static const struct snd_kcontrol_new max9888_right_speaker_mixer_controls[] = {
+	SOC_DAPM_SINGLE("left_dac", M9888_REG_29_MIX_SPEAKER, 3, 1, 0),
+	SOC_DAPM_SINGLE("right_dac", M9888_REG_29_MIX_SPEAKER, 2, 1, 0),
+	SOC_DAPM_SINGLE("preout2", M9888_REG_29_MIX_SPEAKER, 0, 1, 0),
+};
+
+/* Left headphone mixer switch */
+static const struct snd_kcontrol_new max9888_left_headphone_mixer_controls[] = {
+	SOC_DAPM_SINGLE("left_dac", M9888_REG_27_MIX_HEADPHONE, 7, 1, 0),
+	SOC_DAPM_SINGLE("right_dac", M9888_REG_27_MIX_HEADPHONE, 6, 1, 0),
+	SOC_DAPM_SINGLE("preout1", M9888_REG_27_MIX_HEADPHONE, 4, 1, 0),
+};
+
+/* Right headphone mixer switch */
+static const struct snd_kcontrol_new
+		max9888_right_headphone_mixer_controls[] = {
+	SOC_DAPM_SINGLE("left_dac", M9888_REG_27_MIX_HEADPHONE, 3, 1, 0),
+	SOC_DAPM_SINGLE("right_dac", M9888_REG_27_MIX_HEADPHONE, 2, 1, 0),
+	SOC_DAPM_SINGLE("preout2", M9888_REG_27_MIX_HEADPHONE, 0, 1, 0),
+};
+
+/* Earpiece/receiver mixer switch */
+static const struct snd_kcontrol_new max9888_receiver_mixer_controls[] = {
+	SOC_DAPM_SINGLE("left_dac", M9888_REG_28_MIX_RECEIVER, 3, 1, 0),
+	SOC_DAPM_SINGLE("right_dac", M9888_REG_28_MIX_RECEIVER, 2, 1, 0),
+	SOC_DAPM_SINGLE("preout1", M9888_REG_28_MIX_RECEIVER, 1, 1, 0),
+	SOC_DAPM_SINGLE("preout2", M9888_REG_28_MIX_RECEIVER, 0, 1, 0),
+};
+
+/* Pre-output mixer 1 switch */
+static const struct snd_kcontrol_new max9888_preout_mixer_1_controls[] = {
+	SOC_DAPM_SINGLE("ina1", M9888_REG_24_MIX_PREOUT_A, 3, 1, 0),
+	SOC_DAPM_SINGLE("ina2", M9888_REG_24_MIX_PREOUT_A, 2, 1, 0),
+	SOC_DAPM_SINGLE("inb1", M9888_REG_24_MIX_PREOUT_A, 1, 1, 0),
+	SOC_DAPM_SINGLE("inb2", M9888_REG_24_MIX_PREOUT_A, 0, 1, 0),
+};
+
+/* Pre-output mixer 2 switch */
+static const struct snd_kcontrol_new max9888_preout_mixer_2_controls[] = {
+	SOC_DAPM_SINGLE("ina1", M9888_REG_25_MIX_PREOUT_B, 3, 1, 0),
+	SOC_DAPM_SINGLE("ina2", M9888_REG_25_MIX_PREOUT_B, 2, 1, 0),
+	SOC_DAPM_SINGLE("inb1", M9888_REG_25_MIX_PREOUT_B, 1, 1, 0),
+	SOC_DAPM_SINGLE("inb2", M9888_REG_25_MIX_PREOUT_B, 0, 1, 0),
+};
+
+/* Pre-output mixer 3 switch */
+static const struct snd_kcontrol_new max9888_preout_mixer_3_controls[] = {
+	SOC_DAPM_SINGLE("ina1", M9888_REG_26_MIX_PREOUT_C, 3, 1, 0),
+	SOC_DAPM_SINGLE("ina2", M9888_REG_26_MIX_PREOUT_C, 2, 1, 0),
+	SOC_DAPM_SINGLE("inb1", M9888_REG_26_MIX_PREOUT_C, 1, 1, 0),
+	SOC_DAPM_SINGLE("inb2", M9888_REG_26_MIX_PREOUT_C, 0, 1, 0),
+};
+
+/* Left ADC mixer switch */
+static const struct snd_kcontrol_new max9888_left_ADC_mixer_controls[] = {
+	SOC_DAPM_SINGLE("mic1", M9888_REG_22_MIX_ADC_LEFT, 7, 1, 0),
+	SOC_DAPM_SINGLE("mic2", M9888_REG_22_MIX_ADC_LEFT, 6, 1, 0),
+	SOC_DAPM_SINGLE("ina1", M9888_REG_22_MIX_ADC_LEFT, 3, 1, 0),
+	SOC_DAPM_SINGLE("ina2", M9888_REG_22_MIX_ADC_LEFT, 2, 1, 0),
+	SOC_DAPM_SINGLE("inb1", M9888_REG_22_MIX_ADC_LEFT, 1, 1, 0),
+	SOC_DAPM_SINGLE("inb2", M9888_REG_22_MIX_ADC_LEFT, 0, 1, 0),
+};
+
+/* Right ADC mixer switch */
+static const struct snd_kcontrol_new max9888_right_ADC_mixer_controls[] = {
+	SOC_DAPM_SINGLE("mic1", M9888_REG_23_MIX_ADC_RIGHT, 7, 1, 0),
+	SOC_DAPM_SINGLE("mic2", M9888_REG_23_MIX_ADC_RIGHT, 6, 1, 0),
+	SOC_DAPM_SINGLE("ina1", M9888_REG_23_MIX_ADC_RIGHT, 3, 1, 0),
+	SOC_DAPM_SINGLE("ina2", M9888_REG_23_MIX_ADC_RIGHT, 2, 1, 0),
+	SOC_DAPM_SINGLE("inb1", M9888_REG_23_MIX_ADC_RIGHT, 1, 1, 0),
+	SOC_DAPM_SINGLE("inb2", M9888_REG_23_MIX_ADC_RIGHT, 0, 1, 0),
+};
+
+static const struct snd_soc_dapm_widget max9888_dapm_widgets[] = {
+
+	SND_SOC_DAPM_ADC("ADCL", "HiFi Capture", M9888_REG_4A_PWR_EN_IN, 1, 0),
+	SND_SOC_DAPM_ADC("ADCR", "HiFi Capture", M9888_REG_4A_PWR_EN_IN, 0, 0),
+
+	SND_SOC_DAPM_DAC("DACL", "HiFi Playback", M9888_REG_4B_PWR_EN_OUT, 1,
+			 0),
+	SND_SOC_DAPM_DAC("DACR", "HiFi Playback", M9888_REG_4B_PWR_EN_OUT, 0,
+			 0),
+
+	SND_SOC_DAPM_PGA("HP Left Out", M9888_REG_4B_PWR_EN_OUT, 7, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("HP Right Out", M9888_REG_4B_PWR_EN_OUT, 6, 0, NULL,
+			 0),
+
+	SND_SOC_DAPM_PGA("SPK Left Out", M9888_REG_4B_PWR_EN_OUT, 5, 0, NULL,
+			 0),
+	SND_SOC_DAPM_PGA("SPK Right Out", M9888_REG_4B_PWR_EN_OUT, 4, 0, NULL,
+			 0),
+
+	SND_SOC_DAPM_PGA("REC Out", M9888_REG_4B_PWR_EN_OUT, 3, 0, NULL, 0),
+
+	SND_SOC_DAPM_MIXER("hp_left_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_left_headphone_mixer_controls[0],
+			   ARRAY_SIZE(max9888_left_headphone_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("hp_right_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_right_headphone_mixer_controls[0],
+			   ARRAY_SIZE(max9888_right_headphone_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("spk_left_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_left_speaker_mixer_controls[0],
+			   ARRAY_SIZE(max9888_left_speaker_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("spk_right_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_right_speaker_mixer_controls[0],
+			   ARRAY_SIZE(max9888_left_speaker_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("rec_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_receiver_mixer_controls[0],
+			   ARRAY_SIZE(max9888_receiver_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("preout1_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_preout_mixer_1_controls[0],
+			   ARRAY_SIZE(max9888_preout_mixer_1_controls)),
+
+	SND_SOC_DAPM_MIXER("preout2_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_preout_mixer_2_controls[0],
+			   ARRAY_SIZE(max9888_preout_mixer_2_controls)),
+
+	SND_SOC_DAPM_MIXER("preout3_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_preout_mixer_3_controls[0],
+			   ARRAY_SIZE(max9888_preout_mixer_1_controls)),
+
+	SND_SOC_DAPM_MIXER("left_adc_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_left_ADC_mixer_controls[0],
+			   ARRAY_SIZE(max9888_left_ADC_mixer_controls)),
+
+	SND_SOC_DAPM_MIXER("right_adc_mixer", SND_SOC_NOPM, 0, 0,
+			   &max9888_right_ADC_mixer_controls[0],
+			   ARRAY_SIZE(max9888_right_ADC_mixer_controls)),
+
+	SND_SOC_DAPM_PGA_E("INA1 Input", M9888_REG_4A_PWR_EN_IN,
+			       7, 0, NULL, 0, max9888_pga_event,
+			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+
+	SND_SOC_DAPM_PGA_E("INA2 Input", M9888_REG_4A_PWR_EN_IN,
+			       7, 0, NULL, 0, max9888_pga_event,
+			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+
+	SND_SOC_DAPM_PGA_E("INB1 Input", M9888_REG_4A_PWR_EN_IN,
+			       6, 0, NULL, 0, max9888_pga_event,
+			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+
+	SND_SOC_DAPM_PGA_E("INB2 Input", M9888_REG_4A_PWR_EN_IN,
+			       6, 0, NULL, 0, max9888_pga_event,
+			       SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+
+	SND_SOC_DAPM_MICBIAS("Mic Bias", M9888_REG_4A_PWR_EN_IN, 3, 0),
+	SND_SOC_DAPM_MICBIAS("Digmic_l", M9888_REG_46_CFG_MIC, 5, 0),
+	SND_SOC_DAPM_MICBIAS("Digmic_r", M9888_REG_46_CFG_MIC, 4, 0),
+
+	SND_SOC_DAPM_OUTPUT("HPL"),
+	SND_SOC_DAPM_OUTPUT("HPR"),
+	SND_SOC_DAPM_OUTPUT("SPKL"),
+	SND_SOC_DAPM_OUTPUT("SPKR"),
+	SND_SOC_DAPM_OUTPUT("REC"),
+
+	SND_SOC_DAPM_INPUT("DIGMIC"),
+	SND_SOC_DAPM_INPUT("MIC1"),
+	SND_SOC_DAPM_INPUT("MIC2"),
+	SND_SOC_DAPM_INPUT("INA1"),
+	SND_SOC_DAPM_INPUT("INA2"),
+	SND_SOC_DAPM_INPUT("INB1"),
+	SND_SOC_DAPM_INPUT("INB2"),
+};
+
+static const struct snd_soc_dapm_route audio_map[] = {
+	/* Left headphone output mixer */
+	{"hp_left_mixer", "left_dac", "DACL"},
+	{"hp_left_mixer", "right_dac", "DACR"},
+	{"hp_left_mixer", "preout1", "preout1_mixer"},
+
+	/* Right headphone output mixer */
+	{"hp_right_mixer", "left_dac", "DACL"},
+	{"hp_right_mixer", "right_dac", "DACR"},
+	{"hp_right_mixer", "preout2", "preout2_mixer"},
+
+	/* Left speaker output mixer */
+	{"spk_left_mixer", "left_dac", "DACL"},
+	{"spk_left_mixer", "right_dac", "DACR"},
+	{"spk_left_mixer", "preout3", "preout3_mixer"},
+
+	/* Right speaker output mixer */
+	{"spk_right_mixer", "left_dac", "DACL"},
+	{"spk_right_mixer", "right_dac", "DACR"},
+	{"spk_right_mixer", "preout2", "preout3_mixer"},
+
+	/* Earpiece/Receiver output mixer */
+	{"rec_mixer", "left_dac", "DACL"},
+	{"rec_mixer", "right_dac", "DACR"},
+	{"rec_mixer", "preout1", "preout1_mixer"},
+	{"rec_mixer", "preout2", "preout2_mixer"},
+
+	{"HP Left Out", NULL, "hp_left_mixer"},
+	{"HPL", NULL, "HP Left Out"},
+
+	{"HP Right Out", NULL, "hp_right_mixer"},
+	{"HPR", NULL, "HP Right Out"},
+
+	{"SPK Left Out", NULL, "spk_left_mixer"},
+	{"SPKL", NULL, "SPK Left Out"},
+
+	{"SPK Right Out", NULL, "spk_right_mixer"},
+	{"SPKR", NULL, "SPK Right Out"},
+
+	{"REC Out", NULL, "rec_mixer"},
+	{"REC", NULL, "REC Out"},
+
+	/* Left ADC input mixer */
+	{"left_adc_mixer", "mic1", "Mic Bias"},
+	{"left_adc_mixer", "mic2", "Mic Bias"},
+	{"left_adc_mixer", "ina1", "INA1 Input"},
+	{"left_adc_mixer", "ina2", "INA2 Input"},
+	{"left_adc_mixer", "inb1", "INB1 Input"},
+	{"left_adc_mixer", "inb2", "INB2 Input"},
+
+	/* Right ADC input mixer */
+	{"right_adc_mixer", "mic1", "Mic Bias"},
+	{"right_adc_mixer", "mic2", "Mic Bias"},
+	{"right_adc_mixer", "ina1", "INA1 Input"},
+	{"right_adc_mixer", "ina2", "INA2 Input"},
+	{"right_adc_mixer", "inb1", "INB1 Input"},
+	{"right_adc_mixer", "inb2", "INB2 Input"},
+
+	/* Pre-output 1 mixer */
+	{"preout1_mixer", "ina1", "INA1 Input"},
+	{"preout1_mixer", "ina2", "INA2 Input"},
+	{"preout1_mixer", "inb1", "INB1 Input"},
+	{"preout1_mixer", "inb2", "INB2 Input"},
+
+	/* Pre-output 2 mixer */
+	{"preout2_mixer", "ina1", "INA1 Input"},
+	{"preout2_mixer", "ina2", "INA2 Input"},
+	{"preout2_mixer", "inb1", "INB1 Input"},
+	{"preout2_mixer", "inb2", "INB2 Input"},
+
+	/* Pre-output 3 mixer */
+	{"preout3_mixer", "ina1", "INA1 Input"},
+	{"preout3_mixer", "ina2", "INA2 Input"},
+	{"preout3_mixer", "inb1", "INB1 Input"},
+	{"preout3_mixer", "inb2", "INB2 Input"},
+
+	/* inputs */
+	{"ADCL", NULL, "left_adc_mixer"},
+	{"ADCR", NULL, "right_adc_mixer"},
+
+	{"INA1 Input", NULL, "INA1"},
+	{"INA2 Input", NULL, "INA2"},
+	{"INB1 Input", NULL, "INB1"},
+	{"INB2 Input", NULL, "INB2"},
+
+	{"Digmic_l", NULL, "DIGMIC"},
+	{"Digmic_r", NULL, "DIGMIC"},
+	{"Mic Bias", NULL, "MIC1"},
+	{"Mic Bias", NULL, "MIC2"},
+};
+
+/*
+ * Add widgets
+ */
+static int max9888_add_widgets(struct snd_soc_codec *codec)
+{
+	snd_soc_dapm_new_controls(codec, max9888_dapm_widgets,
+				  ARRAY_SIZE(max9888_dapm_widgets));
+
+	/* set up audio path interconnects */
+	snd_soc_dapm_add_routes(codec, audio_map, ARRAY_SIZE(audio_map));
+
+	snd_soc_dapm_new_widgets(codec);
+	return 0;
+}
+
+/*
+ * Set bias level
+ */
+static int max9888_set_bias_level(struct snd_soc_codec *codec,
+				  enum snd_soc_bias_level level)
+{
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+	case SND_SOC_BIAS_PREPARE:
+	case SND_SOC_BIAS_STANDBY:
+		max9888_write(codec, M9888_REG_4C_PWR_SYS, SHDN|JDWK);
+		break;
+	case SND_SOC_BIAS_OFF:
+		max9888_write(codec, M9888_REG_4C_PWR_SYS, JDWK);
+		break;
+	}
+	codec->bias_level = level;
+	return 0;
+}
+
+/*
+ * mute CODEC
+ */
+int max9888_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	if (mute)
+		max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	else
+		max9888_set_bias_level(codec, SND_SOC_BIAS_ON);
+	return 0;
+}
+
+/*
+ * Power down CODEC
+ */
+void max9888_shutdown(struct snd_pcm_substream *substream,
+			 struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+}
+
+/*
+ * Setup DAI1 format
+ */
+static int max9888_dai1_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+
+	if (fmt != max9888->dai1_fmt) {
+		max9888->dai1_fmt = fmt;
+
+		/* DAI clock master/slave wrt the codec */
+		switch (fmt & SND_SOC_DAIFMT_CBS_CFS) {
+		case SND_SOC_DAIFMT_CBS_CFS:
+			/* codec clk & frm slave */
+			max9888->reg_14_val &= ~(1 << 7);
+			max9888_write(codec, M9888_REG_12_DAI1_CLKCFG_HI, 0x80);
+			max9888_write(codec, M9888_REG_13_DAI1_CLKCFG_LO, 0x00);
+			break;
+		case SND_SOC_DAIFMT_CBM_CFM:
+			/* codec clk & frm master */
+			max9888->reg_14_val |= (1 << 7);
+			break;
+		case SND_SOC_DAIFMT_CBS_CFM:
+			/* codec clk slave & frm master */
+		case SND_SOC_DAIFMT_CBM_CFS:
+			/* codec clk master & frame slave */
+			info("Clock mode unsupported");
+			return -1;
+		}
+
+		/* I2S or TDM */
+		if ((fmt & SND_SOC_DAIFMT_I2S) == SND_SOC_DAIFMT_I2S)
+			max9888->reg_14_val &= ~(1 << 2);
+		else
+			max9888->reg_14_val |= (1 << 2);
+
+		/* DAI hardware signal inversions */
+		switch (fmt & SND_SOC_DAIFMT_NB_NF) {
+		case SND_SOC_DAIFMT_NB_NF:
+			max9888->reg_14_val &= ~(1 << 5);
+			max9888->reg_14_val &= ~(1 << 6);
+			break;
+		case SND_SOC_DAIFMT_NB_IF:
+			max9888->reg_14_val |= (1 << 5);
+			max9888->reg_14_val |= (1 << 6);
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			max9888->reg_14_val |= (1 << 5);
+			max9888->reg_14_val &= ~(1 << 6);
+			break;
+		case SND_SOC_DAIFMT_IB_IF:
+			max9888->reg_14_val |= (1 << 5);
+			max9888->reg_14_val &= ~(1 << 6);
+			break;
+		}
+		max9888_write(codec, M9888_REG_14_DAI1_FORMAT,
+			      max9888->reg_14_val);
+
+		max9888_write(codec, M9888_REG_15_DAI1_CLOCK,
+			      (0 << 6) | (0 << 0));
+
+		max9888_write(codec, M9888_REG_16_DAI1_IOCFG,
+			      (1 << 6) |
+			      (0 << 5) |
+			      (0 << 4) |
+			      (0 << 3) | (0 << 2) | (1 << 1) | (1 << 0));
+
+		max9888_write(codec, M9888_REG_17_DAI1_TDM,
+			      (0 << 6) | (1 << 4) | (0 << 0));
+	}
+
+	return 0;
+}
+
+/*
+ * Setup DAI2 format
+ */
+static int max9888_dai2_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+
+	if (fmt != max9888->dai2_fmt) {
+		max9888->dai2_fmt = fmt;
+		/* DAI clock master/slave wrt the codec  */
+		switch (fmt & SND_SOC_DAIFMT_CBS_CFS) {
+		case SND_SOC_DAIFMT_CBS_CFS:
+			/* codec clk & frm slave */
+			max9888->reg_1c_val &= ~(1 << 7);
+			max9888_write(codec, M9888_REG_1A_DAI2_CLKCFG_HI, 0x80);
+			max9888_write(codec, M9888_REG_1B_DAI2_CLKCFG_LO, 0x00);
+			break;
+		case SND_SOC_DAIFMT_CBM_CFM:
+			/* codec clk & frm master */
+			max9888->reg_1c_val |= (1 << 7);
+			break;
+		case SND_SOC_DAIFMT_CBS_CFM:
+			/* codec clk slave & frm master */
+		case SND_SOC_DAIFMT_CBM_CFS:
+			/* codec clk master & frame slave */
+			info("Clock mode unsupported");
+			return -1;
+		}
+
+		/* I2S or TDM */
+		if ((fmt & SND_SOC_DAIFMT_I2S) == SND_SOC_DAIFMT_I2S)
+			max9888->reg_1c_val &= ~(1 << 2);
+		else
+			max9888->reg_1c_val |= (1 << 2);
+
+		/* DAI hardware signal inversions */
+		switch (fmt & SND_SOC_DAIFMT_NB_NF) {
+		case SND_SOC_DAIFMT_NB_NF:
+			max9888->reg_1c_val &= ~(1 << 5);
+			max9888->reg_1c_val &= ~(1 << 6);
+			break;
+		case SND_SOC_DAIFMT_NB_IF:
+			max9888->reg_1c_val |= (1 << 5);
+			max9888->reg_1c_val |= (1 << 6);
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			max9888->reg_1c_val |= (1 << 5);
+			max9888->reg_1c_val &= ~(1 << 6);
+			break;
+		case SND_SOC_DAIFMT_IB_IF:
+			max9888->reg_1c_val |= (1 << 5);
+			max9888->reg_1c_val &= ~(1 << 6);
+			break;
+		}
+		max9888_write(codec, M9888_REG_1C_DAI2_FORMAT,
+			      max9888->reg_1c_val);
+
+		max9888_write(codec, M9888_REG_1D_DAI2_CLOCK, (0 << 0));
+
+		max9888_write(codec, M9888_REG_1E_DAI2_IOCFG,
+			      (2 << 6) |
+			      (0 << 4) |
+			      (0 << 3) | (0 << 2) | (1 << 1) | (1 << 0));
+
+		max9888_write(codec, M9888_REG_1F_DAI2_TDM,
+			      (0 << 6) | (1 << 4) | (0 << 0));
+	}
+
+	return 0;
+}
+
+/*
+ * Setup clock
+ */
+static int max9888_dai_set_sysclk(struct snd_soc_dai *codec_dai,
+				  int clk_id, unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+
+	if (freq != max9888->sysclk) {
+		max9888->sysclk = freq;
+
+		/* setup clocks for slave mode,
+		and using the PLL anyclock feature
+		PSCLK = 0x01 (when master clk is 10MHz to 20MHz)
+		0x02 (when master clk is 20MHz to 30MHz) */
+		if ((freq >= 10000000) && (freq < 20000000)) {
+			max9888_write(codec, M9888_REG_10_SYS_CLK, 0x10);
+		} else if ((freq >= 20000000) && (freq < 30000000)) {
+			max9888_write(codec, M9888_REG_10_SYS_CLK, 0x20);
+		} else {
+			info("Invalid master clock frequency %u", freq);
+			return 1;
+		}
+
+		/* these registers writes take effect with SHDN cycle */
+		if (max9888_read(codec, M9888_REG_4C_PWR_SYS) & 0x80) {
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x00);
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x80);
+		}
+	}
+
+	max9888->sysclk = freq;
+	return 0;
+}
+
+struct rate_table_struct {
+	u32 rate;
+	u16 sr1;
+};
+
+/* codec mclk clock divider coefficients */
+static const struct rate_table_struct rate_table[] = {
+	{8000, 0x1},
+	{11025, 0x2},
+	{16000, 0x3},
+	{22050, 0x4},
+	{24000, 0x5},
+	{32000, 0x6},
+	{44100, 0x7},
+	{48000, 0x8},
+	{88200, 0x9},
+	{96000, 0xA},
+};
+
+static inline int rate_index(int rate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rate_table); i++) {
+		if (rate_table[i].rate >= rate)
+			return i;
+	}
+	return 0;
+}
+
+/*
+ * Setup hw params, sample rate
+ */
+static int max9888_dai1_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+	unsigned int rate;
+	unsigned int reg14val;
+	u16 reg11val;
+
+	rate = params_rate(params);
+
+	/* data 16/24 bit width */
+	reg14val = max9888->reg_14_val;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		reg14val &= ~(1 << 0);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		reg14val |= (1 << 0);
+		break;
+	}
+
+	if ((rate != max9888->dai1_rate) || (reg14val != max9888->reg_14_val)) {
+		/* set DAI1 SR1 value for the DSP; FREQ1:0=anyclock */
+		reg11val = (rate_table[rate_index(rate)].sr1 << 4) | 0;
+		max9888_write(codec, M9888_REG_11_DAI1_CLKMODE, reg11val);
+		max9888->dai1_rate = rate;
+
+		max9888_write(codec, M9888_REG_14_DAI1_FORMAT, reg14val);
+		max9888->reg_14_val = reg14val;
+
+		/* these registers writes take effect with SHDN cycle */
+		if (max9888_read(codec, M9888_REG_4C_PWR_SYS) & 0x80) {
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x00);
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x80);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Setup hw params, sample rate
+ */
+static int max9888_dai2_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+	unsigned int rate;
+	unsigned int reg1Cval;
+	u16 reg19val;
+
+	rate = params_rate(params);
+
+	/* data 16/24 bit width */
+	reg1Cval = max9888->reg_1c_val;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		reg1Cval &= ~(1 << 0);
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		reg1Cval |= (1 << 0);
+		break;
+	}
+
+	if ((rate != max9888->dai2_rate) || (reg1Cval != max9888->reg_1c_val)) {
+		/* set DAI2 SR2 value for the DSP; FREQ1:0=anyclock */
+		reg19val = (rate_table[rate_index(rate)].sr1 << 4) | 0;
+		max9888_write(codec, M9888_REG_19_DAI2_CLKMODE, reg19val);
+		max9888->dai1_rate = rate;
+
+		max9888_write(codec, M9888_REG_1C_DAI2_FORMAT, reg1Cval);
+		max9888->reg_1c_val = reg1Cval;
+
+		/* these registers writes take effect with SHDN cycle */
+		if (max9888_read(codec, M9888_REG_4C_PWR_SYS) & 0x80) {
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x00);
+			max9888_write(codec, M9888_REG_4C_PWR_SYS, 0x80);
+		}
+	}
+
+	return 0;
+}
+
+#define MAX9888_RATES	SNDRV_PCM_RATE_8000_96000
+#define MAX9888_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE)
+
+static struct snd_soc_dai_ops max9888_dai_ops_hifi_mode = {
+	.shutdown = max9888_shutdown,
+	.digital_mute = max9888_mute,
+	.set_sysclk = max9888_dai_set_sysclk,
+	.set_fmt = max9888_dai1_set_fmt,
+	.hw_params = max9888_dai1_hw_params
+};
+
+static struct snd_soc_dai_ops max9888_dai_ops_voice_mode = {
+	.shutdown = max9888_shutdown,
+	.digital_mute = max9888_mute,
+	.set_sysclk = max9888_dai_set_sysclk,
+	.set_fmt = max9888_dai2_set_fmt,
+	.hw_params = max9888_dai2_hw_params
+};
+
+struct snd_soc_dai max9888_dai[] = {
+/* DAI HIFI mode 1 */
+	{
+	 .name = "max9888 DAI0",
+	 .playback = {
+		      .stream_name = "Playback",
+		      .channels_min = 1,
+		      .channels_max = 2,
+		      .rates = MAX9888_RATES,
+		      .formats = MAX9888_FORMATS,
+		      },
+	 .capture = {
+		     .stream_name = "Capture",
+		     .channels_min = 1,
+		     .channels_max = 2,
+		     .rates = MAX9888_RATES,
+		     .formats = MAX9888_FORMATS,
+		     },
+	 .ops = &max9888_dai_ops_hifi_mode,
+	 },
+
+/* DAI Voice mode 2 */
+	{.name = "max9888 DAI1",
+	 .id = 2,
+	 .playback = {
+		      .stream_name = "Voice Playback",
+		      .channels_min = 1,
+		      .channels_max = 1,
+		      .rates = MAX9888_RATES,
+		      .formats = MAX9888_FORMATS,},
+	 .capture = {
+		     .stream_name = "Capture",
+		     .channels_min = 1,
+		     .channels_max = 1,
+		     .rates = MAX9888_RATES,
+		     .formats = MAX9888_FORMATS,},
+	 .ops = &max9888_dai_ops_voice_mode,
+	 },
+};
+EXPORT_SYMBOL_GPL(max9888_dai);
+
+
+/*
+ * Restore previous state if power was removed.
+ * As it is now the CODEC is brought out of shut down.
+ */
+static void max9888_init_private_data(struct max9888_priv *max9888)
+{
+	max9888->sysclk = (unsigned)-1;
+	max9888->dai1_rate = (unsigned)-1;
+	max9888->dai2_rate = (unsigned)-1;
+	max9888->dai1_fmt = (unsigned)-1;
+	max9888->dai2_fmt = (unsigned)-1;
+
+	max9888->reg_14_val =
+	    max9888->reg_1c_val =
+	    (0 << 7) |
+	    (0 << 6) | (0 << 5) | (1 << 4) | (0 << 2) | (0 << 1) | (0 << 0);
+}
+
+/*
+ * The current state should be saved if power is removed.
+ * As it is now the CODEC is just shut down.
+ */
+static int max9888_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+	dprintk("%s\n", __func__);
+	/* we only need to suspend if we are a valid card */
+	if (!codec->card)
+		return 0;
+
+	max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	return 0;
+}
+
+/*
+ * Restore previous state if power was removed.
+ * As it is now the CODEC is brought out of shut down.
+ */
+static int max9888_resume(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct max9888_priv *max9888 = codec->private_data;
+
+	max9888_init_private_data(max9888);
+
+	max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	max9888_set_bias_level(codec, SND_SOC_BIAS_ON);
+
+	return 0;
+}
+
+/*
+ * Initialize the codec.
+ */
+static struct snd_soc_codec *max9888_codec;
+
+static int max9888_register(struct max9888_priv *max9888)
+{
+	int ret, i;
+	struct snd_soc_codec *codec = &max9888->codec;
+
+	if (max9888_codec) {
+		dev_err(codec->dev, "Multiple max9888 devices not supported\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	mutex_init(&codec->mutex);
+	INIT_LIST_HEAD(&codec->dapm_widgets);
+	INIT_LIST_HEAD(&codec->dapm_paths);
+
+	codec->name = "MAX9888";
+	codec->owner = THIS_MODULE;
+	codec->read = max9888_read;
+	codec->write = max9888_write;
+	codec->bias_level = SND_SOC_BIAS_STANDBY;
+	codec->set_bias_level = max9888_set_bias_level;
+	codec->dai = max9888_dai;
+	codec->num_dai = 1;
+	codec->private_data = max9888;
+
+	/* disable device via dapm interface */
+	max9888->rev_version = max9888_read(codec, M9888_REG_FF_REV_ID);
+	max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	max9888_init_private_data(max9888);
+
+	/* Jack detection function only works well on Revision C */
+	if (max9888->rev_version == MAX9888_REVC) {
+		max9888_write(codec, M9888_REG_0F_IRQ_ENABLE, IJDET);
+		max9888_write(codec, M9888_REG_49_CFG_JACKDET,
+				JDETEN | JDEB_200ms);
+		max9888_write(codec, M9888_REG_4C_PWR_SYS, JDWK);
+	}
+
+	max9888_write(codec, M9888_REG_22_MIX_ADC_LEFT, MIX_MIC1 | MIX_INA1);
+	max9888_write(codec, M9888_REG_23_MIX_ADC_RIGHT, MIX_MIC2 | MIX_INA1);
+	max9888_write(codec, M9888_REG_21_MIX_DAC,
+		      MIX_DAI1L_TO_DACL | MIX_DAI2L_TO_DACL | MIX_DAI1R_TO_DACR
+		      | MIX_DAI2R_TO_DACR);
+	max9888_write(codec, M9888_REG_29_MIX_SPEAKER,
+		      MIX_LDAC_TO_SPL | MIX_RDAC_TO_SPR);
+	max9888_write(codec, M9888_REG_27_MIX_HEADPHONE,
+		      MIX_LDAC_TO_HPL | MIX_RDAC_TO_HPR);
+
+	headphone_set_volume(codec, 0x1f, 0);
+	speaker_set_volume(codec, 0x1f, 0);
+	m9888_mic1_gain_control(codec, 20, 1);
+	m9888_mic2_gain_control(codec, 20, 1);
+
+	/* power on device */
+	max9888_codec = codec;
+	for (i = 0; i < codec->num_dai; i++)
+		max9888_dai[i].dev = codec->dev;
+
+	ret = snd_soc_register_codec(codec);
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
+		goto err;
+	}
+
+	ret = snd_soc_register_dais(&max9888_dai[0], codec->num_dai);
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to register DAIs: %d\n", ret);
+		goto err_codec;
+	}
+
+	return ret;
+
+err_codec:
+	snd_soc_unregister_codec(codec);
+err:
+	kfree(max9888);
+
+	return ret;
+}
+
+static void max9888_unregister(struct max9888_priv *max9888)
+{
+	struct snd_soc_codec *codec = &max9888->codec;
+	snd_soc_unregister_dais(max9888_dai, codec->num_dai);
+	snd_soc_unregister_codec(codec);
+	kfree(max9888);
+	max9888_codec = NULL;
+}
+
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+
+static unsigned short normal_i2c[] = { 0, I2C_CLIENT_END };
+
+/* Magic definition of all other variables and things */
+I2C_CLIENT_INSMOD;
+
+static struct i2c_driver max9888_i2c_driver;
+
+static int max9888_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *id)
+{
+	struct snd_soc_codec *codec;
+	struct max9888_priv *max9888;
+
+	max9888 = kzalloc(sizeof(struct max9888_priv), GFP_KERNEL);
+	if (max9888 == NULL)
+		return -ENOMEM;
+
+	codec = &max9888->codec;
+	codec->hw_write = (hw_write_t) i2c_master_send;
+	codec->control_data = i2c;
+	i2c_set_clientdata(i2c, max9888);
+
+	codec->dev = &i2c->dev;
+
+	return max9888_register(max9888);
+}
+
+static int max9888_i2c_remove(struct i2c_client *client)
+{
+	struct max9888_priv *max9888 = i2c_get_clientdata(client);
+	max9888_unregister(max9888);
+	return 0;
+}
+
+static const struct i2c_device_id max9888_i2c_id[] = {
+	{"max9888", 0},
+	{}
+};
+
+/*
+ * gumstix i2c codec control layer
+ */
+static struct i2c_driver max9888_i2c_driver = {
+	.driver = {
+		   .name = "MAX9888 I2C CODEC",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = max9888_i2c_probe,
+	.remove = max9888_i2c_remove,
+	.id_table = max9888_i2c_id,
+};
+#endif
+
+/*
+ * Make sure that a max9888 is attached to the I2C bus.
+ */
+
+static int max9888_probe(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec;
+	struct max9888_priv *max9888;
+	int ret = 0;
+
+	if (!max9888_codec) {
+		dev_err(&pdev->dev, "max9888 codec not yet registered\n");
+		return -EINVAL;
+	}
+
+	socdev->card->codec = max9888_codec;
+	codec = max9888_codec;
+	max9888 = codec->private_data;
+
+	if (max9888->rev_version == MAX9888_REVB)
+		info("RevB Audio CODEC %s", MAX9888_DRIVER_VERSION);
+	else if (max9888->rev_version == MAX9888_REVC)
+		info("RevC Audio CODEC %s", MAX9888_DRIVER_VERSION);
+	else
+		warn("Not supported MAX9888 : %d", max9888->rev_version);
+
+	/* register pcms */
+	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
+	if (ret < 0) {
+		printk(KERN_ERR "max9888: failed to create pcms\n");
+		goto pcm_err;
+	}
+
+	snd_soc_add_controls(codec, max9888_snd_controls,
+			     ARRAY_SIZE(max9888_snd_controls));
+	max9888_add_widgets(codec);
+	ret = snd_soc_init_card(socdev);
+	if (ret < 0) {
+		printk(KERN_ERR "max9888: failed to register card\n");
+		goto card_err;
+	}
+
+	return 0;
+
+card_err:
+	snd_soc_free_pcms(socdev);
+	snd_soc_dapm_free(socdev);
+
+pcm_err:
+	return ret;
+}
+
+/*
+ * Driver is being unloaded, power down the codec and free allocated resources
+ */
+static int max9888_remove(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	if (codec->control_data)
+		max9888_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	snd_soc_free_pcms(socdev);
+	snd_soc_dapm_free(socdev);
+
+	return 0;
+}
+
+struct snd_soc_codec_device soc_codec_dev_max9888 = {
+	.probe = max9888_probe,
+	.remove = max9888_remove,
+	.suspend = max9888_suspend,
+	.resume = max9888_resume,
+};
+EXPORT_SYMBOL_GPL(soc_codec_dev_max9888);
+
+static int __init max9888_modinit(void)
+{
+	int ret;
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	ret = i2c_add_driver(&max9888_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register max9888 I2C driver: %d\n", ret);
+#endif
+	return 0;
+}
+
+module_init(max9888_modinit);
+
+static void __exit max9888_exit(void)
+{
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_driver(&max9888_i2c_driver);
+#endif
+}
+
+module_exit(max9888_exit);
+
+MODULE_DESCRIPTION("ALSA SoC MAX9888 driver");
+MODULE_AUTHOR("Jesse Marroquin <jesse.marroquin@maxim-ic.com>");
+MODULE_AUTHOR("Peter Hsiang <peter.hsiang@maxim-ic.com>");
+MODULE_AUTHOR("BooJin Kim <boojin.kim@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/max9888.h b/sound/soc/codecs/max9888.h
new file mode 100644
index 0000000..1053854
--- /dev/null
+++ b/sound/soc/codecs/max9888.h
@@ -0,0 +1,180 @@
+/*
+ * max9888.h -- MAX9888 ALSA SoC Audio driver
+ *
+ * Copyright 2010 Maxim Integrated Products
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_MAX9888_H
+#define __LINUX_MAX9888_H __FILE__
+
+/*
+ *
+ * MAX9888 Registers Definition and Bit Fields
+ *
+ */
+#define M9888_REG_00_IRQ_STATUS		0x00
+#define M9888_REG_01_MIC_STATUS		0x01
+#define M9888_REG_02_JACK_STAUS		0x02
+#define M9888_REG_0F_IRQ_ENABLE		0x0F
+#define IJDET			(1<<1)
+
+#define M9888_REG_10_SYS_CLK		0x10
+#define M9888_REG_11_DAI1_CLKMODE	0x11
+#define M9888_REG_12_DAI1_CLKCFG_HI	0x12
+#define M9888_REG_13_DAI1_CLKCFG_LO	0x13
+#define M9888_REG_14_DAI1_FORMAT	0x14
+#define M9888_REG_15_DAI1_CLOCK		0x15
+#define M9888_REG_16_DAI1_IOCFG		0x16
+#define M9888_REG_17_DAI1_TDM		0x17
+#define M9888_REG_18_DAI1_FILTERS	0x18
+#define M9888_REG_19_DAI2_CLKMODE	0x19
+#define M9888_REG_1A_DAI2_CLKCFG_HI	0x1A
+#define M9888_REG_1B_DAI2_CLKCFG_LO	0x1B
+#define M9888_REG_1C_DAI2_FORMAT	0x1C
+#define M9888_REG_1D_DAI2_CLOCK		0x1D
+#define M9888_REG_1E_DAI2_IOCFG		0x1E
+#define M9888_REG_1F_DAI2_TDM		0x1F
+#define M9888_REG_20_DAI2_FILTERS	0x20
+
+#define M9888_REG_21_MIX_DAC		0x21
+#define MIX_DAI1L_TO_DACL	(1<<7)
+#define MIX_DAI1R_TO_DACL	(1<<6)
+#define MIX_DAI2L_TO_DACL	(1<<5)
+#define MIX_DAI2R_TO_DACL	(1<<4)
+#define MIX_DAI1L_TO_DACR	(1<<3)
+#define MIX_DAI1R_TO_DACR	(1<<2)
+#define MIX_DAI2L_TO_DACR	(1<<1)
+#define MIX_DAI2R_TO_DACR	(1<<0)
+
+#define M9888_REG_22_MIX_ADC_LEFT	0x22
+#define M9888_REG_23_MIX_ADC_RIGHT	0x23
+#define MIX_MIC1		(1<<7)
+#define MIX_MIC2		(1<<6)
+#define MIX_INA1		(1<<3)
+#define MIX_INA2		(1<<2)
+#define MIX_INB1		(1<<1)
+#define MIX_INB2		(1<<0)
+#define MIX_INA_DIFFERENTIAL	(1<<2)
+#define MIX_INB_DIFFERENTIAL	(1<<0)
+
+#define M9888_REG_24_MIX_PREOUT_A	0x24
+#define M9888_REG_25_MIX_PREOUT_B	0x25
+#define M9888_REG_26_MIX_PREOUT_C	0x26
+#define MIX_INA1		(1<<3)
+#define MIX_INA2		(1<<2)
+#define MIX_INB1		(1<<1)
+#define MIX_INB2		(1<<0)
+#define MIX_INA_DIFFERENTIAL	(1<<2)
+#define MIX_INB_DIFFERENTIAL	(1<<0)
+
+#define M9888_REG_27_MIX_HEADPHONE	0x27
+#define MIX_LDAC_TO_HPL		(3<<6)
+#define MIX_RDAC_TO_HPR		(3<<2)
+
+#define M9888_REG_28_MIX_RECEIVER	0x28
+#define M9888_REG_29_MIX_SPEAKER	0x29
+#define MIX_LDAC_TO_SPL		(1<<7)
+#define MIX_RDAC_TO_SPR		(1<<2)
+
+#define M9888_REG_2A_LVL_SIDETONE	0x2A
+#define M9888_REG_2B_LVL_DAI1_PLAY	0x2B
+#define M9888_REG_2C_LVL_DAI1_PLAY_EQ	0x2C
+#define M9888_REG_2D_LVL_DAI2_PLAY	0x2D
+#define M9888_REG_2E_LVL_DAI2_PLAY_EQ	0x2E
+#define M9888_REG_2F_LVL_ADC_L		0x2F
+#define M9888_REG_30_LVL_ADC_R		0x30
+#define M9888_REG_31_LVL_MIC1		0x31
+#define M9888_REG_32_LVL_MIC2		0x32
+#define M9888_REG_33_LVL_INA		0x33
+#define M9888_REG_34_LVL_INB		0x34
+#define M9888_REG_35_LVL_PREOUT_A	0x35
+#define M9888_REG_36_LVL_PREOUT_B	0x36
+#define M9888_REG_37_LVL_PREOUT_C	0x37
+#define M9888_REG_38_LVL_HEADPHONE_L	0x38
+#define M9888_REG_39_LVL_HEADPHONE_R	0x39
+#define HPXM			(1<<7)
+
+#define M9888_REG_3A_LVL_RECEIVER	0x3A
+#define RECM			(1<<7)
+
+#define M9888_REG_3B_LVL_SPEAKER_L	0x3B
+#define M9888_REG_3C_LVL_SPEAKER_R	0x3C
+#define SPXM			(1<<7)
+
+#define M9888_REG_3D_MICAGC_CFG		0x3D
+#define M9888_REG_3E_MICAGC_THRESHOLD	0x3E
+#define M9888_REG_3F_SPKDHP		0x3F
+#define M9888_REG_40_SPKDHP_THRESHOLD	0x40
+#define M9888_REG_41_SPKALC_COMP	0x41
+#define M9888_REG_42_PWRLMT_CFG		0x42
+#define M9888_REG_43_PWRLMT_TIME	0x43
+#define M9888_REG_44_THDLMT_CFG		0x44
+#define M9888_REG_45_CFG_AUDIO_IN	0x45
+#define M9888_REG_46_CFG_MIC		0x46
+#define DIGMICLEN		(1<<5)
+#define DIGMICREN		(1<<4)
+
+#define M9888_REG_47_CFG_LEVEL		0x47
+#define VSEN			(1<<6)
+#define ZDEN			(1<<5)
+#define EQ2EN			(1<<1)
+#define EQ1EN			(1<<0)
+
+#define M9888_REG_48_CFG_BYPASS		0x48
+#define M9888_REG_49_CFG_JACKDET	0x49
+#define JDETEN			(1<<7)
+#define JDEB_25ms		(0<<0)
+#define JDEB_50ms		(1<<0)
+#define JDEB_100ms		(2<<0)
+#define JDEB_200ms		(3<<0)
+
+#define M9888_REG_4A_PWR_EN_IN		0x4A
+#define INAEN			(1<<7)
+#define INBEN			(1<<6)
+#define MBEN			(1<<3)
+#define ADLEN			(1<<1)
+#define ADREN			(1<<0)
+
+#define M9888_REG_4B_PWR_EN_OUT		0x4B
+#define HPLEN			(1<<7)
+#define HPREN			(1<<6)
+#define SPLEN			(1<<5)
+#define SPREN			(1<<4)
+#define RECEN			(1<<3)
+#define DALEN			(1<<1)
+#define DAREN			(1<<0)
+
+#define M9888_REG_4C_PWR_SYS		0x4C
+#define SHDN			(1<<7)
+#define JDWK			(1<<0)
+
+#define M9888_REG_50_DAI1_EQ_BASE	0x50
+#define M9888_REG_82_DAI2_EQ_BASE	0x82
+#define M9888_REG_B4_DAI1_BIQUAD_BASE	0xB4
+#define M9888_REG_BE_DAI2_BIQUAD_BASE	0xBE
+#define M9888_REG_FF_REV_ID		0xFF
+
+#define MAX9888_REVB			0x42
+#define MAX9888_REVC			0x43
+
+#define REGS_PER_BAND			5
+#define REGS_PER_BIQUAD			5
+
+#define HIGH_BYTE(w)			((w >> 8) & 0x00ff)
+#define LOW_BYTE(w)			(w & 0x00ff)
+
+#define MAX9888_DAI_HIFI		0
+#define MAX9888_DAI_VOICE		1
+
+struct max9888_setup_data {
+	unsigned short i2c_address;
+};
+
+extern struct snd_soc_dai max9888_dai[2];
+extern struct snd_soc_codec_device soc_codec_dev_max9888;
+
+#endif /* __LINUX_MAX9888_H */
-- 
1.5.5.6

