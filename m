Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1CGCNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:13:19 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:31703 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1CGCNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:17 -0500
X-IronPort-AV: E=Sophos;i="4.62,274,1297054800"; 
   d="scan'208";a="30065195"
From: <cliff.cai@analog.com>
To: broonie@opensource.wolfsonmicro.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH] Add driver for Analog Devices ADAU1701 SigmaDSP
Date: Mon, 7 Mar 2011 09:11:42 +0800
Message-ID: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

ADAU1701 is an SigmaDSP processor,it supports I2S audio interface.
It needs to include "linux/sigma.h" which is still in Andrew Morton's
tree. 

Signed-off-by: Cliff Cai<cliff.cai@analog.com>
---
 sound/soc/codecs/Kconfig    |    4 +
 sound/soc/codecs/Makefile   |    2 +
 sound/soc/codecs/adau1701.c |  417 +++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/adau1701.h |  111 ++++++++++++
 4 files changed, 534 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/adau1701.c
 create mode 100644 sound/soc/codecs/adau1701.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index bbc97fd..ba931c4 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -20,6 +20,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_PCM3008
 	select SND_SOC_SPDIF
 	select SND_SOC_SSM2602 if I2C
+	select SND_SOC_ADAU1701 if I2C
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TLV320AIC23 if I2C
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
@@ -98,6 +99,9 @@ config SND_SOC_SPDIF
 config SND_SOC_SSM2602
 	tristate
 
+config SND_SOC_ADAU1701
+	tristate
+
 config SND_SOC_STAC9766
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 8b75305..ed48581 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -8,6 +8,7 @@ snd-soc-l3-objs := l3.o
 snd-soc-pcm3008-objs := pcm3008.o
 snd-soc-spdif-objs := spdif_transciever.o
 snd-soc-ssm2602-objs := ssm2602.o
+snd-soc-adau1701-objs := adau1701.o
 snd-soc-stac9766-objs := stac9766.o
 snd-soc-tlv320aic23-objs := tlv320aic23.o
 snd-soc-tlv320aic26-objs := tlv320aic26.o
@@ -45,6 +46,7 @@ obj-$(CONFIG_SND_SOC_L3)	+= snd-soc-l3.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
 obj-$(CONFIG_SND_SOC_SPDIF)	+= snd-soc-spdif.o
 obj-$(CONFIG_SND_SOC_SSM2602)	+= snd-soc-ssm2602.o
+obj-$(CONFIG_SND_SOC_ADAU1701)	+= snd-soc-adau1701.o
 obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
 obj-$(CONFIG_SND_SOC_TLV320AIC26)	+= snd-soc-tlv320aic26.o
diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
new file mode 100644
index 0000000..b7c671d
--- /dev/null
+++ b/sound/soc/codecs/adau1701.c
@@ -0,0 +1,417 @@
+/*
+ * Driver for ADAU1701 SigmaDSP processor
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/sigma.h>
+#include <linux/sysfs.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+
+#include "adau1701.h"
+
+#define AUDIO_NAME "adau1701"
+#define ADAU1701_VERSION "0.10"
+#define ADAU1701_FIRMWARE "SigmaDSP_fw.bin"
+
+/* codec private data */
+struct adau1701_priv {
+	struct snd_soc_codec *codec;
+	enum snd_soc_control_type control_type;
+};
+
+/*
+ * Write a ADAU1701 register,since the register length is from 1 to 5,
+ * So, use our own read/write functions instead of snd_soc_read/write.
+ */
+static int adau1701_write_register(struct snd_soc_codec *codec,
+	u16 reg_address, u8 length, u32 value)
+{
+	int ret;
+	int count = length + 2; /*data plus 16bit register address*/
+	u8 buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
+
+	if (length == 0)
+		return -1;
+	buf[0] = (reg_address >> 8) & 0xFF;
+	buf[1] = reg_address & 0xFF;
+	if (length == 1)
+		buf[2] = value & 0xFF;
+	else if (length == 2) {
+		buf[2] = (value >> 8) & 0xFF;
+		buf[3] = value & 0xFF;
+	} else if (length == 3) {
+		buf[2] = (value >> 16) & 0xFF;
+		buf[3] = (value >> 8) & 0xFF;
+		buf[4] = value & 0xFF;
+	}
+	ret = i2c_master_send(codec->control_data, buf, count);
+
+	return ret;
+
+}
+
+/*
+ * read ADAU1701 hw register
+ */
+static u32 adau1701_read_register(struct snd_soc_codec *codec,
+	u16 reg_address, u8 length)
+{
+	u8 addr[2];
+	u8 buf[2];
+	u32 value = 0;
+	int ret;
+
+	if (reg_address < ADAU1701_FIRSTREG)
+		reg_address = reg_address + ADAU1701_FIRSTREG;
+
+	if ((reg_address < ADAU1701_FIRSTREG) || (reg_address > ADAU1701_LASTREG))
+		return -EIO;
+
+	addr[0] = (reg_address >> 8) & 0xFF;
+	addr[1] = reg_address & 0xFF;
+
+	/* write the 2byte read address */
+	ret = i2c_master_send(codec->control_data, addr, 2);
+	if (ret)
+		return ret;
+
+	if (length == 1) {
+		if (i2c_master_recv(codec->control_data, buf, 1) != 1)
+			return -EIO;
+		value = buf[0];
+	} else if (length == 2) {
+		if (i2c_master_recv(codec->control_data, buf, 2) != 2)
+			return -EIO;
+		value = (buf[0] << 8) | buf[1];
+	}
+	return value;
+}
+
+static int adau1701_setprogram(struct snd_soc_codec *codec)
+{
+	int ret = 0;
+
+	ret = process_sigma_firmware(codec->control_data, ADAU1701_FIRMWARE);
+
+	return ret;
+}
+
+static int adau1701_pcm_prepare(struct snd_pcm_substream *substream,
+				struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	int reg = 0;
+
+	reg = SEROCTL_MASTER | SEROCTL_OBF16 | SEROCTL_OLF1024;
+	adau1701_write_register(codec, ADAU1701_SEROCTL, 2, reg);
+
+	return 0;
+}
+
+static void adau1701_shutdown(struct snd_pcm_substream *substream,
+			      struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	adau1701_write_register(codec, ADAU1701_SEROCTL, 2, 0);
+}
+
+static int adau1701_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	u16 reg = 0;
+
+	if (mute) {
+		/* mute inputs/outputs */
+		reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
+		reg |= AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD | AUXNPOW_D2PD | AUXNPOW_D3PD;
+		adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
+	} else {
+		/* unmute inputs/outputs */
+		reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
+		reg &= ~(AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD | AUXNPOW_D2PD | AUXNPOW_D3PD);
+		adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
+	}
+
+	return 0;
+}
+
+static int adau1701_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	u32 reg = 0;
+
+	reg = adau1701_read_register(codec, ADAU1701_SERITL1, 1);
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		reg |= SERITL1_LEFTJ;
+		break;
+	/* TODO: support TDM */
+	default:
+		return 0;
+	}
+
+	/* clock inversion */
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		break;
+	/* TODO: support signal inversions */
+	default:
+		return 0;
+	}
+
+	/* set iface format*/
+	adau1701_write_register(codec, ADAU1701_SERITL1, 1, reg);
+	return 0;
+}
+
+static int adau1701_set_bias_level(struct snd_soc_codec *codec,
+				 enum snd_soc_bias_level level)
+{
+	u16 reg;
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+		reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
+		reg &= ~(AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
+			 AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD);
+		adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
+		break;
+	case SND_SOC_BIAS_PREPARE:
+		break;
+	case SND_SOC_BIAS_STANDBY:
+		break;
+	case SND_SOC_BIAS_OFF:
+		/* everything off, dac mute, inactive */
+		reg = adau1701_read_register(codec, ADAU1701_AUXNPOW, 2);
+		reg |= AUXNPOW_AAPD | AUXNPOW_D0PD | AUXNPOW_D1PD |  AUXNPOW_D2PD |
+			 AUXNPOW_D3PD | AUXNPOW_VBPD | AUXNPOW_VRPD;
+		adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, reg);
+		break;
+
+	}
+	codec->bias_level = level;
+	return 0;
+}
+
+#define ADAU1701_RATES SNDRV_PCM_RATE_48000
+
+#define ADAU1701_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
+	SNDRV_PCM_FMTBIT_S24_LE)
+
+static struct snd_soc_dai_ops adau1701_dai_ops = {
+	.prepare	= adau1701_pcm_prepare,
+	.shutdown	= adau1701_shutdown,
+	.digital_mute	= adau1701_mute,
+	.set_fmt	= adau1701_set_dai_fmt,
+};
+
+struct snd_soc_dai_driver adau1701_dai = {
+	.name = "ADAU1701",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = ADAU1701_RATES,
+		.formats = ADAU1701_FORMATS,
+	},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = ADAU1701_RATES,
+		.formats = ADAU1701_FORMATS,
+	},
+	.ops = &adau1701_dai_ops,
+};
+EXPORT_SYMBOL_GPL(adau1701_dai);
+
+static int adau1701_suspend(struct snd_soc_codec *codec, pm_message_t state)
+{
+	adau1701_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	return 0;
+}
+
+static int adau1701_resume(struct snd_soc_codec *codec)
+{
+	adau1701_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+	return 0;
+}
+
+static ssize_t adau1371_dsp_load(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret = 0;
+	struct adau1701_priv *adau1701 = dev_get_drvdata(dev);
+	struct snd_soc_codec *codec = adau1701->codec;
+	ret = adau1701_setprogram(codec);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+static DEVICE_ATTR(dsp, 0644, NULL, adau1371_dsp_load);
+
+static int adau1701_reg_init(struct snd_soc_codec *codec)
+{
+	u32 reg;
+	int ret = 0;
+
+	reg = DSPCTRL_DAM | DSPCTRL_ADM;
+	adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
+	/* Load default program */
+	ret = adau1701_setprogram(codec);
+	if (ret < 0) {
+		printk(KERN_ERR "Loading program data failed\n");
+		goto error;
+	}
+	reg = DSPCTRL_DAM | DSPCTRL_ADM;
+	adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
+	reg = 0x08;
+	adau1701_write_register(codec, ADAU1701_DSPRES, 1, reg);
+	adau1701_write_register(codec, ADAU1701_SEROCTL, 2, 0);
+	adau1701_write_register(codec, ADAU1701_SERITL1, 1, 0);
+	/* Configure the multipurpose pins as serial in/out pins */
+	reg = MPCONF_SDATAP | MPCONF_SDATAP << 16 | MPCONF_SDATAP << 20;
+	adau1701_write_register(codec, ADAU1701_MPCONF0, 3, reg);
+	reg = MPCONF_AUXADC << 8 | MPCONF_SDATAP << 12 | MPCONF_SDATAP << 16 |
+		MPCONF_SDATAP << 20;
+	adau1701_write_register(codec, ADAU1701_MPCONF1, 3, reg);
+	adau1701_write_register(codec, ADAU1701_AUXNPOW, 2, 0);
+	reg = AUXADCE_AAEN;
+	adau1701_write_register(codec, ADAU1701_AUXADCE, 2, reg);
+	reg = DACSET_DACEN;
+	adau1701_write_register(codec, ADAU1701_DACSET, 2, reg);
+	reg = DSPCTRL_DAM | DSPCTRL_ADM | DSPCTRL_CR;
+	adau1701_write_register(codec, ADAU1701_DSPCTRL, 2, reg);
+	/* Power-up the oscillator */
+	adau1701_write_register(codec, ADAU1701_OSCIPOW, 2, 0);
+error:
+	return ret;
+}
+
+static int adau1701_probe(struct snd_soc_codec *codec)
+{
+	int ret = 0;
+
+	struct adau1701_priv *adau1701 = snd_soc_codec_get_drvdata(codec);
+
+	adau1701->codec = codec;
+	ret = snd_soc_codec_set_cache_io(codec, 16, 16, adau1701->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
+	ret = adau1701_reg_init(codec);
+	if (ret < 0) {
+		dev_err(codec->dev, "failed to initialize\n");
+		return ret;
+	}
+	ret = device_create_file(codec->dev, &dev_attr_dsp);
+	if (ret)
+		dev_err(codec->dev, "device_create_file() failed\n");
+
+	return ret;
+}
+
+static int adau1701_remove(struct snd_soc_codec *codec)
+{
+	adau1701_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	return 0;
+}
+
+struct snd_soc_codec_driver soc_codec_dev_adau1701 = {
+	.probe =	adau1701_probe,
+	.remove =	adau1701_remove,
+	.suspend =	adau1701_suspend,
+	.resume =	adau1701_resume,
+	.set_bias_level = adau1701_set_bias_level,
+};
+
+static __devinit int adau1701_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct adau1701_priv *adau1701;
+	int ret = 0;
+
+	adau1701 = kzalloc(sizeof(struct adau1701_priv), GFP_KERNEL);
+	if (adau1701 == NULL)
+		return -ENOMEM;
+
+	adau1701->control_type = SND_SOC_I2C;
+	i2c_set_clientdata(i2c, adau1701);
+	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_dev_adau1701, &adau1701_dai, 1);
+	if (ret < 0)
+		kfree(adau1701);
+
+	return ret;
+}
+
+static __devexit int adau1701_i2c_remove(struct i2c_client *client)
+{
+	snd_soc_unregister_codec(&client->dev);
+	kfree(i2c_get_clientdata(client));
+	return 0;
+}
+
+static const struct i2c_device_id adau1701_i2c_id[] = {
+	{ "adau1701", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adau1701_i2c_id);
+
+/* corgi i2c codec control layer */
+static struct i2c_driver adau1701_i2c_driver = {
+	.driver = {
+		.name = "adau1701-codec",
+		.owner = THIS_MODULE,
+	},
+	.probe    = adau1701_i2c_probe,
+	.remove   = __devexit_p(adau1701_i2c_remove),
+	.id_table = adau1701_i2c_id,
+};
+
+static int __init adau1701_modinit(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&adau1701_i2c_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "Failed to register adau1701 I2C driver: %d\n",
+		       ret);
+	}
+
+	return ret;
+}
+module_init(adau1701_modinit);
+
+static void __exit adau1701_exit(void)
+{
+	i2c_del_driver(&adau1701_i2c_driver);
+}
+module_exit(adau1701_exit);
+
+MODULE_DESCRIPTION("ASoC ADAU1701 SigmaDSP driver");
+MODULE_AUTHOR("Cliff Cai");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/adau1701.h b/sound/soc/codecs/adau1701.h
new file mode 100644
index 0000000..174199e
--- /dev/null
+++ b/sound/soc/codecs/adau1701.h
@@ -0,0 +1,111 @@
+/*
+ * header file for adau1701 SigmaDSP processor
+ *
+ * Copyright 2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef _ADAU1701_H
+#define _ADAU1701_H
+
+/*
+ * Register definition.
+ */
+#define ADAU1701_FIRSTREG	0x0800
+#define ADAU1701_LASTREG	0x0827
+#define ADAU1701_IFACE0		0x0800
+#define ADAU1701_IFACE1		0x0801
+#define ADAU1701_IFACE2		0x0802
+#define ADAU1701_IFACE3		0x0803
+#define ADAU1701_IFACE4		0x0804
+#define ADAU1701_IFACE5		0x0805
+#define ADAU1701_IFACE6		0x0806
+#define ADAU1701_IFACE7		0x0807
+
+#define ADAU1701_GPIOSET	0x0808
+#define ADAU1701_AUXADC0	0x0809
+#define ADAU1701_AUXADC1	0x080A
+#define ADAU1701_AUXADC2	0x080B
+#define ADAU1701_AUXADC3	0x080C
+
+#define ADAU1701_SAFELD0	0x0810
+#define ADAU1701_SAFELD1	0x0811
+#define ADAU1701_SAFELD2	0x0812
+#define ADAU1701_SAFELD3	0x0813
+#define ADAU1701_SAFELD4	0x0814
+
+#define ADAU1701_SLDADD0	0x0815
+#define ADAU1701_SLDADD1	0x0816
+#define ADAU1701_SLDADD2	0x0817
+#define ADAU1701_SLDADD3	0x0818
+#define ADAU1701_SLDADD4	0x0819
+
+#define ADAU1701_DATCAP0	0x081A
+#define ADAU1701_DATCAP1	0x081B
+
+#define ADAU1701_DSPCTRL	0x081C
+#define ADAU1701_DSPRES		0x081D
+#define ADAU1701_SEROCTL	0x081E
+#define ADAU1701_SERITL1	0x081F
+
+#define ADAU1701_MPCONF0	0x0820
+#define ADAU1701_MPCONF1	0x0821
+
+#define ADAU1701_AUXNPOW	0x0822
+#define ADAU1701_AUXADCE	0x0824
+
+#define ADAU1701_OSCIPOW	0x0826
+#define ADAU1701_DACSET		0x0827
+
+
+#define ADAU1701_NUMCACHEREG	0x29
+
+/* Bit fields */
+#define DSPCTRL_CR		(1 << 2)
+#define DSPCTRL_DAM		(1 << 3)
+#define DSPCTRL_ADM		(1 << 4)
+#define DSPCTRL_IST		(1 << 5)
+#define DSPCTRL_IFCW		(1 << 6)
+#define DSPCTRL_GPCW		(1 << 7)
+#define DSPCTRL_AACW		(1 << 8)
+
+#define MPCONF_GPIOIDE		(0)
+#define MPCONF_GPIOINDE		(1)
+#define MPCONF_GPIOOPT		(2)
+#define MPCONF_OCOPT		(3)
+#define MPCONF_SDATAP		(4)
+#define MPCONF_GPIOIDEI		(8)
+#define MPCONF_GPIOINDEI	(9)
+#define MPCONF_GPIOOPTI		(0xA)
+#define MPCONF_OCOPTI		(0xB)
+#define MPCONF_SDATAPI		(0xC)
+#define MPCONF_AUXADC		(0xF)
+
+#define SEROCTL_MASTER		(0x0800)
+#define SEROCTL_OBF16		(0x0000)
+#define SEROCTL_OBF8		(0x0200)
+#define SEROCTL_OBF4		(0x0400)
+#define SEROCTL_OBF2		(0x0600)
+
+#define SEROCTL_OLF1024		(0x0000)
+#define SEROCTL_OLF512		(0x0080)
+#define SEROCTL_OLF256		(0x0100)
+#define SEROCTL_OLFRSV		(0x0180)
+
+#define AUXNPOW_AAPD		(0x80)
+#define AUXNPOW_VBPD		(0x40)
+#define AUXNPOW_VRPD		(0x20)
+#define AUXNPOW_D3PD		(0x1)
+#define AUXNPOW_D2PD		(0x2)
+#define AUXNPOW_D1PD		(0x4)
+#define AUXNPOW_D0PD		(0x8)
+
+#define SERITL1_LEFTJ		(1)
+#define SERITL1_TDM		(2)
+
+#define	AUXADCE_AAEN		(1 << 15)
+#define OSCIPOW_OPD		(0x04)
+#define	DACSET_DACEN		(1)
+
+#endif
-- 
1.7.1

