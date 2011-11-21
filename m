Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1KUEHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:07:10 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:59839 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab1KUEHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:07:08 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Date: Mon, 21 Nov 2011 13:08:50 +0900
Message-Id: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
resistance to voltage noise. On chip regulator realizes power supply rejection
ratio (PSRR) be over 90dB so more than 50dB is improved than ever. ML26124-01HB/
ML26124-02GD can deliver stable audio performance without being affected by noise
from the power supply circuit and peripheral components. The chip also includes
a composite video signal output, which can be applied to various portable device
 requirements. The ML26124 is realized these functions into very small package
the size is only 2.56mm x 2.46mm therefore can be construct high quality sound
system easily.
ML26124-01HB is 25pin WCSP package; ML26124-02GD is 32pin WQFN package.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 sound/soc/codecs/Kconfig   |    4 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/ml26124.c |  583 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ml26124.h |  123 ++++++++++
 4 files changed, 712 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/ml26124.c
 create mode 100644 sound/soc/codecs/ml26124.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 4584514..6cb0915 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -39,6 +39,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX98095 if I2C
 	select SND_SOC_MAX9850 if I2C
 	select SND_SOC_MAX9877 if I2C
+	select SND_SOC_ML26124 if I2C
 	select SND_SOC_PCM3008
 	select SND_SOC_RT5631 if I2C
 	select SND_SOC_SGTL5000 if I2C
@@ -211,6 +212,9 @@ config SND_SOC_DMIC
 config SND_SOC_MAX98088
        tristate
 
+config SND_SOC_ML26124
+	tristate
+
 config SND_SOC_MAX98095
        tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index a2c7842..ad3f460 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -23,6 +23,7 @@ snd-soc-dfbmcs320-objs := dfbmcs320.o
 snd-soc-dmic-objs := dmic.o
 snd-soc-l3-objs := l3.o
 snd-soc-max98088-objs := max98088.o
+snd-soc-ml26124-objs := ml26124.o
 snd-soc-max98095-objs := max98095.o
 snd-soc-max9850-objs := max9850.o
 snd-soc-pcm3008-objs := pcm3008.o
@@ -124,6 +125,7 @@ obj-$(CONFIG_SND_SOC_DMIC)	+= snd-soc-dmic.o
 obj-$(CONFIG_SND_SOC_L3)	+= snd-soc-l3.o
 obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
 obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
+obj-$(CONFIG_SND_SOC_ML26124)	+= snd-soc-ml26124.o
 obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
 obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
new file mode 100644
index 0000000..646af7d
--- /dev/null
+++ b/sound/soc/codecs/ml26124.c
@@ -0,0 +1,583 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/tlv.h>
+
+#include "ml26124.h"
+
+struct ml26124_priv {
+	enum snd_soc_control_type control_type;
+	spinlock_t lock;
+	struct snd_pcm_substream *substream;
+	unsigned int rate;
+	unsigned int ch;
+	struct mutex i2c_mutex;
+};
+
+static const char *ml26124_lrmcon[] = {"Use L", "Use R", "Use (L+R)", "Use (L+R)/2"};
+static const char *ml26124_dvfconcon[] = {"1/fs=20.8us", "2/fs", "4/fs", "8/fs",
+"16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs",
+"4096/fs", "8192/fs", "16384/fs=341msec"};
+static const char *ml26124_hpf2cut[] = {"FS=8n/11.025n/16n = 80/110/120",
+					"100/138/150", "130/179/195",
+					"160/221/240", "200/276/300",
+					"260/358/390", "320/441/480",
+					"400/551/600"};
+static const char *ml26124_alcmode[] = {"ALC mode", "Limitter mode"};
+static const char *ml26124_ngtyp[] = {"Gain hold mode", "Mute mode"};
+static const char *ml26124_alcatk[] = {"ALC mode=4/fs  Limiter mode=ALC mode/4",
+     "8/fs", "16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs",
+     "2048/fs", "4096/fs", "8192/fs", "16384", "32768", "65536", "131072"};
+static const char *ml26124_alcdcy[] = {"Limitter mode=4/fs  ALC mode=Limitter mode * 4",
+     "8/fs", "16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs",
+     "2048/fs", "4096/fs", "8192/fs", "16384", "32768", "65536", "131072"};
+static const char *ml26124_alchld[] = {"128/fs", "256/fs", "512/fs", "1024/fs",
+     "2048/fs", "4096/fs", "8192/fs", "16384/fs", "32768/fs", "65536/fs", "131072/fs",
+     "262144/fs", "524288/fs", "1048576/fs", "2097152/fs"};
+static const char *ml26124_alczctm[] = {"128/fs", "256/fs", "512/fs", "1024/fs"};
+static const char *ml26124_platk[] = {"1/fs=20.8us", "2/fs", "4/fs", "8/fs",
+"16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs",
+"4096/fs", "8192/fs", "16384/fs=341msec", "32768/fs"};
+static const char *ml26124_pldcy[] = {"4/fs", "8/fs", "16/fs", "32/fs", "64/fs",
+     "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs", "4096/fs", "8192/fs",
+     "16384", "32768", "65536", "131072"};
+static const char *ml26124_plzctm[] = {"128/fs", "256/fs", "512/fs", "1024/fs"};
+
+static const char *ml26124_input_select[] = {"Analog MIC-in", "Digital MIC-in"};
+
+static const struct soc_enum ml26124_enum[] = {
+/* #define SOC_ENUM_SINGLE(xreg, xshift, xmax, xtexts) */
+	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 0, 4, ml26124_lrmcon),
+	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 4, 15, ml26124_dvfconcon),
+	SOC_ENUM_SINGLE(ML26124_HPF2_CUTOFF, 0, 8, ml26124_hpf2cut),
+	SOC_ENUM_SINGLE(ML26124_ALC_MODE, 0, 2, ml26124_alcmode),
+	SOC_ENUM_SINGLE(ML26124_ALC_MODE, 2, 2, ml26124_ngtyp),
+	SOC_ENUM_SINGLE(ML26124_ALC_ATTACK_TIM, 0, 16, ml26124_alcatk),
+	SOC_ENUM_SINGLE(ML26124_ALC_DECAY_TIM, 0, 16, ml26124_alcdcy),
+	SOC_ENUM_SINGLE(ML26124_ALC_HOLD_TIM, 0, 16, ml26124_alchld),
+	SOC_ENUM_SINGLE(ML26124_ALC_ZERO_TIMOUT, 0, 4, ml26124_alczctm),
+	SOC_ENUM_SINGLE(ML26124_PL_ATTACKTIME, 0, 16, ml26124_platk),
+	SOC_ENUM_SINGLE(ML26124_PL_DECAYTIME, 0, 16, ml26124_pldcy),
+	SOC_ENUM_SINGLE(ML26124_PL_0CROSS_TIMOUT, 0, 4, ml26124_plzctm),
+	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 1, ml26124_input_select),
+};
+
+/* ML26124 configuration */
+static const DECLARE_TLV_DB_SCALE(rec_play_digi_vol, -7150, 50, 0);
+static const DECLARE_TLV_DB_SCALE(digi_boost_vol, -1200, 75, 0);
+static const DECLARE_TLV_DB_SCALE(eq_band_gain, -7150, 50, 0);
+static const DECLARE_TLV_DB_SCALE(alclvl, -2250, 150, 0);
+static const DECLARE_TLV_DB_SCALE(alcmingain, -1200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(alcmaxgain, -675, 600, 0);
+static const DECLARE_TLV_DB_SCALE(ngth, -7650, 150, 0);
+static const DECLARE_TLV_DB_SCALE(plilv, -2250, 150, 0);
+static const DECLARE_TLV_DB_SCALE(plmingain, -1200, 600, 0);
+static const DECLARE_TLV_DB_SCALE(plmaxgain, -675, 600, 0);
+static const DECLARE_TLV_DB_SCALE(plvl, -1200, 75, 0);
+
+static const struct snd_kcontrol_new ml26124_snd_controls[] = {
+	SOC_SINGLE_TLV("Record Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
+	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
+	SOC_SINGLE_TLV("Digital Boost Volume",  ML26124_DIGI_BOOST_VOL, 0, 0x3f, 0, digi_boost_vol),
+	SOC_SINGLE_TLV("EQ Band0 Gain Setting",  ML26124_EQ_GAIN_BRAND0, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band1 Gain Setting",  ML26124_EQ_GAIN_BRAND1, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band2 Gain Setting",  ML26124_EQ_GAIN_BRAND2, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band3 Gain Setting",  ML26124_EQ_GAIN_BRAND3, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("EQ Band4 Gain Setting",  ML26124_EQ_GAIN_BRAND4, 0, 0xff, 1, eq_band_gain),
+	SOC_SINGLE_TLV("ALC Target Level",  ML26124_ALC_TARGET_LEV, 0, 0xf, 1, alclvl),
+	SOC_SINGLE_TLV("ALC Min Gain Control",  ML26124_ALC_MAXMIN_GAIN, 0, 7, 0, alcmingain),
+	SOC_SINGLE_TLV("ALC MAX Gain Control",  ML26124_ALC_MAXMIN_GAIN, 4, 7, 1, alcmaxgain),
+	SOC_SINGLE_TLV("Noise Gate Threshold",  ML26124_NOIS_GATE_THRSH, 0, 0x1f, 0, ngth),
+	SOC_SINGLE_TLV("Playback Limitter Target Level",  ML26124_PL_TARGETTIME, 0, 0xf, 1, plilv),
+	SOC_SINGLE_TLV("Playback Limitter Min Gain",  ML26124_PL_MAXMIN_GAIN, 0, 7, 0, plmingain),
+	SOC_SINGLE_TLV("Playback Limitter Max Gain",  ML26124_PL_MAXMIN_GAIN, 4, 7, 1, plmaxgain),
+	SOC_SINGLE_TLV("Playback Boost Volume",  ML26124_PLYBAK_BOST_VOL, 0, 0x3f, 0, plvl),
+};
+
+static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
+	SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),
+	SOC_SINGLE("Record ALC ON/OFF", ML26124_FILTER_EN, 1, 1, 0),
+	SOC_SINGLE("Digital Volume Fade ON/OFF", ML26124_FILTER_EN, 3, 1, 0),
+	SOC_SINGLE("Ditital Volume MUTE", ML26124_FILTER_EN, 4, 1, 0),
+	SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),
+	SOC_SINGLE("Noise Gate ON/OFF", ML26124_ALC_MODE, 1, 1, 0),
+};
+
+static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
+	SND_SOC_DAPM_VMID("VMID"),
+	SND_SOC_DAPM_MICBIAS("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0),
+	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
+	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
+	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
+	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_LINE("LINEOUT", NULL),
+	SND_SOC_DAPM_INPUT("VIDEOIN"),
+	SND_SOC_DAPM_INPUT("MDIN"),
+	SND_SOC_DAPM_INPUT("MIN"),
+	SND_SOC_DAPM_INPUT("LIN"),
+	SND_SOC_DAPM_INPUT("SDIN"),
+	SND_SOC_DAPM_OUTPUT("VIDEOOUT"),
+	SND_SOC_DAPM_OUTPUT("SPOUT"),
+	SND_SOC_DAPM_OUTPUT("LOUT"),
+	SND_SOC_DAPM_OUTPUT("SDOUT"),
+};
+
+#define	CODEC_DEV_ADDR		(0x1A)
+
+
+static struct i2c_board_info ioh_hwmon_info[] = {
+	{I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR + 1)},
+	{I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR + 2)},
+	{I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR + 3)},
+	{I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR + 4)},
+	{I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR + 5)},
+	{I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
+};
+
+static const struct snd_soc_dapm_route intercon[] = {
+};
+
+static int snd_card_codec_reg_read(struct ml26124_priv *priv,
+				   unsigned char reg, unsigned char *val)
+{
+	unsigned char data;
+	struct i2c_client *i2c;
+
+	mutex_lock(&priv->i2c_mutex);
+
+	i2c = i2c_new_device(i2c_get_adapter(1),
+			     &ioh_hwmon_info[priv->substream->number]);
+	if (!i2c) {
+		mutex_unlock(&priv->i2c_mutex);
+		return -1;
+	}
+
+	if (i2c_master_send(i2c, &reg, 1) != 1) {
+		mutex_unlock(&priv->i2c_mutex);
+		return -1;
+	}
+
+	if (i2c_master_recv(i2c, &data, 1) != 1) {
+		mutex_unlock(&priv->i2c_mutex);
+		return -1;
+	}
+
+	*val = data;
+	i2c_unregister_device(i2c);
+	mutex_unlock(&priv->i2c_mutex);
+
+	return 0;
+}
+
+static int snd_card_codec_reg_write(struct ml26124_priv *priv,
+				    unsigned char reg, unsigned char val)
+{
+	unsigned char buf[2] = {(reg|1), val};
+	struct i2c_client *i2c;
+
+	mutex_lock(&priv->i2c_mutex);
+
+	i2c = i2c_new_device(i2c_get_adapter(1),
+			     &ioh_hwmon_info[priv->substream->number]);
+
+	if (i2c_master_send(i2c, &buf[0], 2) != 2) {
+		mutex_unlock(&priv->i2c_mutex);
+		return -1;
+	}
+
+	i2c_unregister_device(i2c);
+	mutex_unlock(&priv->i2c_mutex);
+
+	return 0;
+}
+
+static int snd_card_codec_set(int number, struct ml26124_priv *priv)
+{
+	unsigned char data;
+	unsigned int rate = priv->rate;
+	unsigned int channels = priv->ch;
+
+	snd_card_codec_reg_read(priv, 0x30, &data);	 /* Read MICVIAS Voltage */
+
+	snd_card_codec_reg_write(priv, 0x10, 0x01);	/* soft reset assert */
+	snd_card_codec_reg_write(priv, 0x10, 0x00);	/* soft reset negate */
+
+	snd_card_codec_reg_write(priv, 0x0c, 0x00);	/* Stop clock  */
+
+	switch (rate) {
+	case 16000:
+		snd_card_codec_reg_write(priv, 0x00, 0x03);
+		snd_card_codec_reg_write(priv, 0x02, 0x0c);
+		snd_card_codec_reg_write(priv, 0x04, 0x00);
+		snd_card_codec_reg_write(priv, 0x06, 0x20);
+		snd_card_codec_reg_write(priv, 0x08, 0x00);
+		snd_card_codec_reg_write(priv, 0x0a, 0x04);
+		break;
+	case 32000:
+		snd_card_codec_reg_write(priv, 0x00, 0x06);
+		snd_card_codec_reg_write(priv, 0x02, 0x0c);
+		snd_card_codec_reg_write(priv, 0x04, 0x00);
+		snd_card_codec_reg_write(priv, 0x06, 0x20);
+		snd_card_codec_reg_write(priv, 0x08, 0x00);
+		snd_card_codec_reg_write(priv, 0x0a, 0x04);
+		break;
+	case 48000:
+		snd_card_codec_reg_write(priv, 0x00, 0x08);
+		snd_card_codec_reg_write(priv, 0x02, 0x0c);
+		snd_card_codec_reg_write(priv, 0x04, 0x00);
+		snd_card_codec_reg_write(priv, 0x06, 0x30);
+		snd_card_codec_reg_write(priv, 0x08, 0x00);
+		snd_card_codec_reg_write(priv, 0x0a, 0x04);
+		break;
+	default:
+		pr_err("%s:this rate is no support for ml26124\n", __func__);
+		break;
+	}
+
+	snd_card_codec_reg_write(priv, 0x0c, 0x03); /* Start MCLK and PLL */
+	msleep(20);
+	snd_card_codec_reg_write(priv, 0x0c, 0x0f); /* Clock control: MCLKI use */
+	snd_card_codec_reg_write(priv, 0x0e, 0x04);
+
+	if (channels == 1) {
+		snd_card_codec_reg_write(priv, 0x60, 0x23); /* SAI transmitter control */
+					/* 0x23 : FMTO=1, H=Left L=Right, no-delay*/
+		snd_card_codec_reg_write(priv, 0x62, 0x23);  /* Receive side SAI control */
+	} else {
+		snd_card_codec_reg_write(priv, 0x60, 0x00);
+		snd_card_codec_reg_write(priv, 0x62, 0x00);
+	}
+
+	snd_card_codec_reg_write(priv, 0x64, 0x00); /* master/slave set slave */
+
+	snd_card_codec_reg_write(priv, 0x20, 0x02); /* VMID on. normal mode */
+	msleep(50);
+
+	snd_card_codec_reg_write(priv, 0x20, 0x06); /* Analog REference Power Managemet */
+	snd_card_codec_reg_write(priv, 0x22, 0x0a); /* Analog Input Power Management */
+	snd_card_codec_reg_write(priv, 0x24, 0x02); /* DAC power Management */
+	snd_card_codec_reg_write(priv, 0x26, 0x13);
+	snd_card_codec_reg_write(priv, 0x26, 0x1f); /* Speaker Amplified Poer Management */
+	snd_card_codec_reg_write(priv, 0x28, 0x02); /* LOUT Control Regsister */
+
+	snd_card_codec_reg_write(priv, 0x54, 0x02); /* Speaker Amplifier output Control */
+	snd_card_codec_reg_write(priv, 0x5a, 0x00); /* Mic Interface Control Register */
+
+	snd_card_codec_reg_write(priv, 0x12, 0x01); /* Record/Playback Running Control Register */
+	snd_card_codec_reg_write(priv, 0x12, 0x03);
+	msleep(20);
+	snd_card_codec_reg_write(priv, 0x66, 0x03); /* DSP filter function Enable */
+
+	snd_card_codec_reg_write(priv, 0x3a, 0x27); /* Speaker Amplifier Volume Control */
+	snd_card_codec_reg_write(priv, 0x32, 0x20); /* Mic Input Volume Control */
+
+	return 0;
+}
+
+static int ml26124_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params,
+			    struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	if (snd_card_codec_set(substream->number, priv))
+		return -1;
+
+	return snd_pcm_lib_malloc_pages(substream,
+					params_buffer_bytes(hw_params));
+}
+
+static int snd_card_codec_free(int number, struct ml26124_priv *priv)
+{
+	snd_card_codec_reg_write(priv, 0x10, 1);	/* soft reset assert */
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream,
+				      struct snd_soc_dai *dai)
+{
+	struct ml26124_priv *priv = substream->runtime->private_data;
+
+	if (snd_card_codec_free(substream->number, priv))
+			return -1;
+
+	return snd_pcm_lib_free_pages(substream);
+}
+
+static int ml26124_pcm_prepare(struct snd_pcm_substream *substream,
+			      struct snd_soc_dai *dai)
+{
+	return 0;
+}
+
+static void ml26124_shutdown(struct snd_pcm_substream *substream,
+			    struct snd_soc_dai *dai)
+{
+}
+
+#define ML26124_DVOL_CTL		0x68	/* Digital Volume Conotrol
+						   Function Enable Register */
+#define DVOL_CTL_DVMUTE_ON		BIT(4)	/* Digital volume MUTE On */
+#define DVOL_CTL_DVMUTE_OFF		0	/* Digital volume MUTE Off */
+
+static int ml26124_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	if (mute)
+		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
+					 DVOL_CTL_DVMUTE_ON);
+	else
+		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
+					 DVOL_CTL_DVMUTE_OFF);
+	return 0;
+}
+
+static int ml26124_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+	unsigned char mode;
+
+	/* set master/slave audio interface */
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		mode = 1;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		mode = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	snd_card_codec_reg_write(priv, ML26124_SAI_MODE_SEL, mode);
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* clock inversion */
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define ML26124_REF_PM	0x20
+#define REF_PM_MICBEN	BIT(2)	/* MIC BIAS Enable */
+#define REF_PM_LOBIAS	BIT(6)	/* LOUT terminal BIAS Enable (1/2REGOUT) */
+#define REF_PM_VMID_ON	BIT(1)	/* VMID generation circuit ON */
+#define REF_PM_VMID_ON_FAST	BIT(0) /* VMID generation circuit Fast mode ON */
+#define REF_PM_VMID_OFF	0	/* VMID generation circuit OFF */
+
+static int ml26124_set_bias_level(struct snd_soc_codec *codec,
+		enum snd_soc_bias_level level)
+{
+	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+	case SND_SOC_BIAS_PREPARE:
+	case SND_SOC_BIAS_STANDBY:
+		snd_card_codec_reg_write(priv, ML26124_REF_PM, REF_PM_VMID_ON);
+		msleep(50);
+		snd_card_codec_reg_write(priv, ML26124_REF_PM,
+					 REF_PM_VMID_ON | REF_PM_MICBEN);
+		break;
+	case SND_SOC_BIAS_OFF:
+		snd_card_codec_reg_write(priv, ML26124_REF_PM,
+					 REF_PM_VMID_OFF | REF_PM_MICBEN);
+		break;
+	}
+	codec->bias_level = level;
+	return 0;
+}
+
+#define ML26124_RATES SNDRV_PCM_RATE_8000_96000
+
+#define ML26124_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
+	SNDRV_PCM_FMTBIT_S24_LE)
+
+static struct snd_soc_dai_ops ml26124_dai_ops = {
+	.prepare	= ml26124_pcm_prepare,
+	.hw_params	= ml26124_hw_params,
+	.hw_free	= snd_card_ml7213i2s_hw_free,
+	.shutdown	= ml26124_shutdown,
+	.digital_mute	= ml26124_mute,
+	.set_fmt	= ml26124_set_dai_fmt,
+};
+
+struct snd_soc_dai_driver ml26124_dai = {
+	.name = "ml26124-hifi",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = ML26124_RATES,
+		.formats = ML26124_FORMATS,},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = ML26124_RATES,
+		.formats = ML26124_FORMATS,},
+	.ops = &ml26124_dai_ops,
+	.symmetric_rates = 1,
+};
+
+#ifdef CONFIG_PM
+static int ml26124_suspend(struct snd_soc_codec *codec, pm_message_t state)
+{
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_OFF);
+
+	return 0;
+}
+
+static int ml26124_resume(struct snd_soc_codec *codec)
+{
+	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	return 0;
+}
+#else
+#define ml26124_suspend NULL
+#define ml26124_resume NULL
+#endif
+
+static int ml26124_probe(struct snd_soc_codec *codec)
+{
+	snd_soc_add_controls(codec, ml26124_snd_controls,
+			     ARRAY_SIZE(ml26124_snd_controls));
+
+	snd_soc_dapm_new_controls(codec, ml26124_dapm_widgets,
+				  ARRAY_SIZE(ml26124_dapm_widgets));
+	return 0;
+}
+
+/* power down chip */
+static int ml26124_remove(struct snd_soc_codec *codec)
+{
+	return 0;
+}
+#define REG_CACHE_SIZE		0x79
+static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {
+	.probe =	ml26124_probe,
+	.remove =	ml26124_remove,
+	.suspend =	ml26124_suspend,
+	.resume =	ml26124_resume,
+	.set_bias_level = ml26124_set_bias_level,
+	.reg_cache_size = REG_CACHE_SIZE,
+	.reg_word_size = sizeof(u8),
+};
+
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+static __devinit int ml26124_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
+{
+	struct ml26124_priv *priv;
+	int ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, priv);
+	priv->control_type = SND_SOC_I2C;
+
+	ret =  snd_soc_register_codec(&i2c->dev,
+			&soc_codec_dev_ml26124, &ml26124_dai, 1);
+	if (ret < 0)
+		kfree(priv);
+
+	mutex_init(&priv->i2c_mutex);
+
+	return ret;
+}
+
+static __devexit int ml26124_i2c_remove(struct i2c_client *client)
+{
+	snd_soc_unregister_codec(&client->dev);
+	kfree(i2c_get_clientdata(client));
+	return 0;
+}
+
+static const struct i2c_device_id ml26124_i2c_id[] = {
+	{ "ml26124", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ml26124_i2c_id);
+
+static struct i2c_driver ml26124_i2c_driver = {
+	.driver = {
+		.name = "ml26124-codec",
+		.owner = THIS_MODULE,
+	},
+	.probe =    ml26124_i2c_probe,
+	.remove =   __devexit_p(ml26124_i2c_remove),
+	.id_table = ml26124_i2c_id,
+};
+#endif
+
+static int __init ml26124_modinit(void)
+{
+	int ret = 0;
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	ret = i2c_add_driver(&ml26124_i2c_driver);
+	if (ret != 0) {
+		pr_err("Failed to register ML26124 I2C driver: %d\n", ret);
+	}
+#endif
+	return ret;
+}
+module_init(ml26124_modinit);
+
+static void __exit ml26124_exit(void)
+{
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+	i2c_del_driver(&ml26124_i2c_driver);
+#endif
+}
+module_exit(ml26124_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML26124 ALSA SoC codec driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ml26124.h b/sound/soc/codecs/ml26124.h
new file mode 100644
index 0000000..c1de498
--- /dev/null
+++ b/sound/soc/codecs/ml26124.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML26124_H
+#define ML26124_H
+
+/* Clock Control Register */
+#define ML26124_SMPLING_RATE		0x00
+#define ML26124_PLLNL			0x02
+#define ML26124_PLLNH			0x04
+#define ML26124_PLLML			0x06
+#define ML26124_PLLMH			0x08
+#define ML26124_PLLDIV			0x0a
+#define ML26124_CLK_EN			0x0c
+#define ML26124_CLK_CTL			0x0e
+
+/* System Control Register */
+#define ML26124_SW_RST			0x10
+#define ML26124_REC_PLYBAK_RUN		0x12
+#define ML26124_MIC_TIM			0x14
+
+/* Power Mnagement Register */
+#define ML26124_PW_REF_PW_MNG		0x20
+#define ML26124_PW_IN_PW_MNG		0x22
+#define ML26124_PW_DAC_PW_MNG		0x24
+#define ML26124_PW_SPAMP_PW_MNG		0x26
+#define ML26124_PW_LOUT_PW_MNG		0x28
+#define ML26124_PW_VOUT_PW_MNG		0x2a
+#define ML26124_PW_ZCCMP_PW_MNG		0x2e
+
+/* Analog Reference Control Register */
+#define ML26124_PW_MICBIAS_VOL		0x30
+
+/* Input/Output Amplifier Control Register */
+#define ML26124_PW_MIC_IN_VOL		0x32
+#define ML26124_PW_MIC_BOST_VOL		0x38
+#define ML26124_PW_SPK_AMP_VOL		0x3a
+#define ML26124_PW_AMP_VOL_FUNC		0x48
+#define ML26124_PW_AMP_VOL_FADE		0x4a
+
+/* Analog Path Control Register */
+#define ML26124_SPK_AMP_OUT		0x54
+#define ML26124_MIC_IF_CTL		0x5a
+#define ML26124_MIC_SELECT		0xe8
+//#define ML26124_CTL			0x
+
+/* Audio Interface Control Register */
+#define ML26124_SAI_TRANS_CTL		0x60
+#define ML26124_SAI_RCV_CTL		0x62
+#define ML26124_SAI_MODE_SEL		0x64
+
+/* DSP Control Register */
+#define ML26124_FILTER_EN		0x66
+#define ML26124_VOL_CTL_EN		0x68
+#define ML26124_MIXER_VOL_CTL		0x6a
+#define ML26124_RECORD_DIG_VOL		0x6c
+#define ML26124_PLBAK_DIG_VOL		0x70
+#define ML26124_DIGI_BOOST_VOL		0x72
+#define ML26124_EQ_GAIN_BRAND0		0x74
+#define ML26124_EQ_GAIN_BRAND1		0x76
+#define ML26124_EQ_GAIN_BRAND2		0x78
+#define ML26124_EQ_GAIN_BRAND3		0x7a
+#define ML26124_EQ_GAIN_BRAND4		0x7c
+#define ML26124_HPF2_CUTOFF		0x7e
+#define ML26124_EQBRAND0_F0L		0x80
+#define ML26124_EQBRAND0_F0H		0x82
+#define ML26124_EQBRAND0_F1L		0x84
+#define ML26124_EQBRAND0_F1H		0x86
+#define ML26124_EQBRAND1_F0L		0x88
+#define ML26124_EQBRAND1_F0H		0x8a
+#define ML26124_EQBRAND1_F1L		0x8c
+#define ML26124_EQBRAND1_F1H		0x8e
+#define ML26124_EQBRAND2_F0L		0x90
+#define ML26124_EQBRAND2_F0H		0x92
+#define ML26124_EQBRAND2_F1L		0x94
+#define ML26124_EQBRAND2_F1H		0x96
+#define ML26124_EQBRAND3_F0L		0x98
+#define ML26124_EQBRAND3_F0H		0x9a
+#define ML26124_EQBRAND3_F1L		0x9c
+#define ML26124_EQBRAND3_F1H		0x9e
+#define ML26124_EQBRAND4_F0L		0xa0
+#define ML26124_EQBRAND4_F0H		0xa2
+#define ML26124_EQBRAND4_F1L		0xa4
+#define ML26124_EQBRAND4_F1H		0xa6
+
+/* ALC Control Register */
+#define ML26124_ALC_MODE		0xb0
+#define ML26124_ALC_ATTACK_TIM		0xb2
+#define ML26124_ALC_DECAY_TIM		0xb4
+#define ML26124_ALC_HOLD_TIM		0xb6
+#define ML26124_ALC_TARGET_LEV		0xb8
+#define ML26124_ALC_MAXMIN_GAIN		0xba
+#define ML26124_NOIS_GATE_THRSH		0xbc
+#define ML26124_ALC_ZERO_TIMOUT		0xbe
+
+/* Playback Limiter Control Register */
+#define ML26124_PL_ATTACKTIME		0xc0
+#define ML26124_PL_DECAYTIME		0xc2
+#define ML26124_PL_TARGETTIME		0xc4
+#define ML26124_PL_MAXMIN_GAIN		0xc6
+#define ML26124_PLYBAK_BOST_VOL		0xc8
+#define ML26124_PL_0CROSS_TIMOUT	0xca
+
+/* Video Amplifer Control Register */
+#define ML26124_VIDEO_AMP_GAIN_CTL	0xd0
+#define ML26124_VIDEO_AMP_SETUP1	0xd2
+#define ML26124_VIDEO_AMP_CTL2		0xd4
+
+#endif
-- 
1.7.4.4

