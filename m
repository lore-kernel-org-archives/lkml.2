Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1KHJER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:04:17 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:28295 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab1KHJD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:03:58 -0500
Message-ID: <4EB8F079.9080703@dsn.lapis-semi.com>
Date: Tue, 08 Nov 2011 18:03:53 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
CC: perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com> <8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com> <4E9BAEF7.1080406@dsn.lapis-semi.com> <s5h7h3ysa4l.wl%tiwai@suse.de> <4EA5563A.10703@dsn.lapis-semi.com> <20111024122015.GA26033@opensource.wolfsonmicro.com>
In-Reply-To: <20111024122015.GA26033@opensource.wolfsonmicro.com>
Content-Type: multipart/mixed;
 boundary="------------000506070709060806020102"
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000506070709060806020102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

(2011/10/24 21:20), Mark Brown wrote:
> On Mon, Oct 24, 2011 at 09:12:42PM +0900, Tomoya MORINAGA wrote:
>
>> 1. PCI interface function.
>> Any current ASoC drivers don't have PCI interface function.
>> So I don't know where the function should be in machine driver or
>> platform driver.
>
> It depends on what the driver is for.  Probably you want a driver which
> is some combination of machine driver and the various drivers that are
> normally part of the SoC - whatever roles in the system are filled by
> this hardware the driver ought to register subsystem drivers for those
> roles.
>
>> 2. Register Access
>> Can platform driver access register ?
>> According to the soc document, platform driver must not access hardware,
>> however, some drivers looks accessing their hardware.
>
> What makes you say this?  A driver that can't access hardware would be
> rather useless...
>
>

Though roughly, we re-created 3 files codec driver, platform drive and 
machine driver. (Not debugged/tested)
Could you check these files ?

(1)codec driver
    ml26124.c ml26124.h

(2)platform driver
    ml7213ioh-plat.c ml7213ioh-plat.h ioh_i2s_config.h ioh_i2s.h

(3)machine driver
    ml7213ioh-machine.c

Thanks in advance.

-- 
tomoya
ROHM Co., Ltd.

--------------000506070709060806020102
Content-Type: text/plain;
 name="ml26124.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ml26124.c"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/pm.h>
#include <linux/i2c.h>
#include <linux/slab.h>
#include <linux/platform_device.h>
#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/pcm_params.h>
#include <sound/soc.h>
#include <sound/soc-dapm.h>
#include <sound/tlv.h>

#include "ml26124.h"

struct cbdata {
	struct ioh_i2s_data *priv;
	int stop;
	int cnt;
};

struct snd_ml7213i2s_pcm {
	enum snd_soc_control_type control_type;
	struct snd_ml7213i2s *ml7213i2s;
	spinlock_t lock;
	unsigned int irq_pos;
	unsigned int buf_pos;
	struct snd_pcm_substream *substream;
	struct cbdata cbd;              /* i2s callback info */
	unsigned int channels;
	unsigned int rw;
	unsigned int rate;
	unsigned int ch;
	unsigned int setup_flag;
	unsigned int format;
	unsigned int bclkfs;
	struct mutex i2c_mutex;
};

/*
 * wm8731 register cache
 * We can't read the WM8731 register space when we are
 * using 2 wire for device control, so we cache them instead.
 * There is no point in caching the reset register
 */
static const u16 wm8731_reg[WM8731_CACHEREGNUM] = {
	0x0097, 0x0097, 0x0079, 0x0079,
	0x000a, 0x0008, 0x009f, 0x000a,
	0x0000, 0x0000
};

#define wm8731_reset(c)	snd_soc_write(c, WM8731_RESET, 0)

static const char *ml26124_lrmcon[] = {"Use L", "Use R", "Use (L+R)", "Use (L+R)/2"};
static const char *ml26124_dvfconcon[] = {"1/fs=20.8us", "2/fs", "4/fs", "8/fs",
"16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs",
"4096/fs", "8192/fs", "16384/fs=341msec"};
static const char *ml26124_hpf2cut[] = {"FS=8n/11.025n/16n = 80/110/120",
					"100/138/150", "130/179/195",
					"160/221/240", "200/276/300",
					"260/358/390", "320/441/480",
					"400/551/600"};
static const char *ml26124_alcmode[] = {"ALC mode", "Limitter mode"};
static const char *ml26124_ngtyp[] = {"Gain hold mode", "Mute mode"};
static const char *ml26124_alcatk[] = {"ALC mode=4/fs  Limiter mode=ALC mode/4",
     "8/fs", "16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs",
     "2048/fs", "4096/fs", "8192/fs", "16384", "32768", "65536", "131072"};
static const char *ml26124_alcdcy[] = {"Limitter mode=4/fs  ALC mode=Limitter mode * 4",
     "8/fs", "16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs",
     "2048/fs", "4096/fs", "8192/fs", "16384", "32768", "65536", "131072"};
static const char *ml26124_alchld[] = {"128/fs", "256/fs", "512/fs", "1024/fs",
     "2048/fs", "4096/fs", "8192/fs", "16384/fs", "32768/fs", "65536/fs", "131072/fs",
     "262144/fs", "524288/fs", "1048576/fs", "2097152/fs"};
static const char *ml26124_alczctm[] = {"128/fs", "256/fs", "512/fs", "1024/fs"};
static const char *ml26124_platk[] = {"1/fs=20.8us", "2/fs", "4/fs", "8/fs",
"16/fs", "32/fs", "64/fs", "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs",
"4096/fs", "8192/fs", "16384/fs=341msec", "32768/fs"};
static const char *ml26124_pldcy[] = {"4/fs", "8/fs", "16/fs", "32/fs", "64/fs",
     "128/fs", "256/fs", "512/fs", "1024/fs", "2048/fs", "4096/fs", "8192/fs",
     "16384", "32768", "65536", "131072"};
static const char *ml26124_plzctm[] = {"128/fs", "256/fs", "512/fs", "1024/fs"};

static const char *ml26124_input_select[] = {"Analog MIC-in", "Digital MIC-in"};

static const struct soc_enum ml26124_enum[] = {
/* #define SOC_ENUM_SINGLE(xreg, xshift, xmax, xtexts) */
	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 0, 4, ml26124_lrmcon),
	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 4, 15, ml26124_dvfconcon),
	SOC_ENUM_SINGLE(ML26124_HPF2_CUTOFF, 0, 8, ml26124_hpf2cut),
	SOC_ENUM_SINGLE(ML26124_ALC_MODE, 0, 2, ml26124_alcmode),
	SOC_ENUM_SINGLE(ML26124_ALC_MODE, 2, 2, ml26124_ngtyp),
	SOC_ENUM_SINGLE(ML26124_ALC_ATTACK_TIM, 0, 16, ml26124_alcatk),
	SOC_ENUM_SINGLE(ML26124_ALC_DECAY_TIM, 0, 16, ml26124_alcdcy),
	SOC_ENUM_SINGLE(ML26124_ALC_HOLD_TIM, 0, 16, ml26124_alchld),
	SOC_ENUM_SINGLE(ML26124_ALC_ZERO_TIMOUT, 0, 4, ml26124_alczctm),
	SOC_ENUM_SINGLE(ML26124_PL_ATTACKTIME, 0, 16, ml26124_platk),
	SOC_ENUM_SINGLE(ML26124_PL_DECAYTIME, 0, 16, ml26124_pldcy),
	SOC_ENUM_SINGLE(ML26124_PL_0CROSS_TIMOUT, 0, 4, ml26124_plzctm),
	SOC_ENUM_SINGLE(ML26124_MIC_IF_CTL, 0, 1, ml26124_input_select),
};

/* ML26124 configuration */
static const DECLARE_TLV_DB_SCALE(rec_play_digi_vol, -7150, 50, 0);
static const DECLARE_TLV_DB_SCALE(digi_boost_vol, -1200, 75, 0);
static const DECLARE_TLV_DB_SCALE(eq_band_gain, -7150, 50, 0);
static const DECLARE_TLV_DB_SCALE(alclvl, -2250, 150, 0);
static const DECLARE_TLV_DB_SCALE(alcmingain, -1200, 600, 0);
static const DECLARE_TLV_DB_SCALE(alcmaxgain, -675, 600, 0);
static const DECLARE_TLV_DB_SCALE(ngth, -7650, 150, 0);
static const DECLARE_TLV_DB_SCALE(plilv, -2250, 150, 0);
static const DECLARE_TLV_DB_SCALE(plmingain, -1200, 600, 0);
static const DECLARE_TLV_DB_SCALE(plmaxgain, -675, 600, 0);
static const DECLARE_TLV_DB_SCALE(plvl, -1200, 75, 0);

static const struct snd_kcontrol_new ml26124_snd_controls[] = {
	SOC_SINGLE_TLV("Record Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
	SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
	SOC_SINGLE_TLV("Digital Boost Volume",  ML26124_DIGI_BOOST_VOL, 0, 0x3f, 0, digi_boost_vol),
	SOC_SINGLE_TLV("EQ Band0 Gain Setting",  ML26124_EQ_GAIN_BRAND0, 0, 0xff, 1, eq_band_gain),
	SOC_SINGLE_TLV("EQ Band1 Gain Setting",  ML26124_EQ_GAIN_BRAND1, 0, 0xff, 1, eq_band_gain),
	SOC_SINGLE_TLV("EQ Band2 Gain Setting",  ML26124_EQ_GAIN_BRAND2, 0, 0xff, 1, eq_band_gain),
	SOC_SINGLE_TLV("EQ Band3 Gain Setting",  ML26124_EQ_GAIN_BRAND3, 0, 0xff, 1, eq_band_gain),
	SOC_SINGLE_TLV("EQ Band4 Gain Setting",  ML26124_EQ_GAIN_BRAND4, 0, 0xff, 1, eq_band_gain),
	SOC_SINGLE_TLV("ALC Target Level",  ML26124_ALC_TARGET_LEV, 0, 0xf, 1, alclvl),
	SOC_SINGLE_TLV("ALC Min Gain Control",  ML26124_ALC_MAXMIN_GAIN, 0, 7, 0, alcmingain),
	SOC_SINGLE_TLV("ALC MAX Gain Control",  ML26124_ALC_MAXMIN_GAIN, 4, 7, 1, alcmaxgain),
	SOC_SINGLE_TLV("Noise Gate Threshold",  ML26124_NOIS_GATE_THRSH, 0, 0x1f, 0, ngth),
	SOC_SINGLE_TLV("Playback Limitter Target Level",  ML26124_PL_TARGETTIME, 0, 0xf, 1, plilv),
	SOC_SINGLE_TLV("Playback Limitter Min Gain",  ML26124_PL_MAXMIN_GAIN, 0, 7, 0, plmingain),
	SOC_SINGLE_TLV("Playback Limitter Max Gain",  ML26124_PL_MAXMIN_GAIN, 4, 7, 1, plmaxgain),
	SOC_SINGLE_TLV("Playback Boost Volume",  ML26124_PLYBAK_BOST_VOL, 0, 0x3f, 0, plvl),
};

static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
	SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),
	SOC_SINGLE("Record ALC ON/OFF", ML26124_FILTER_EN, 1, 1, 0),
	SOC_SINGLE("Digital Volume Fade ON/OFF", ML26124_FILTER_EN, 3, 1, 0),
	SOC_SINGLE("Ditital Volume MUTE", ML26124_FILTER_EN, 4, 1, 0),
	SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),
	SOC_SINGLE("Noise Gate ON/OFF", ML26124_ALC_MODE, 1, 1, 0),
};

static const struct snd_soc_dapm_widget ml26124_dapm_widgets[] = {
	SND_SOC_DAPM_VMID("VMID"),
	SND_SOC_DAPM_MICBIAS("MICBIAS", ML26124_PW_REF_PW_MNG, 0, 0),
	SND_SOC_DAPM_ADC("ADC", "Capture", ML26124_PW_IN_PW_MNG, 1, 0),
	SND_SOC_DAPM_PGA("PGA", ML26124_PW_IN_PW_MNG, 3, 0, NULL, 0),
	SND_SOC_DAPM_DAC("DAC", "Playback", ML26124_PW_DAC_PW_MNG, 1, 0),
	SND_SOC_DAPM_SPK("Speaker", NULL),
	SND_SOC_DAPM_LINE("LINEOUT", NULL),
	SND_SOC_DAPM_INPUT("VIDEOIN"),
	SND_SOC_DAPM_INPUT("MDIN"),
	SND_SOC_DAPM_INPUT("MIN"),
	SND_SOC_DAPM_INPUT("LIN"),
	SND_SOC_DAPM_INPUT("SDIN"),
	SND_SOC_DAPM_OUTPUT("VIDEOOUT"),
	SND_SOC_DAPM_OUTPUT("SPOUT"),
	SND_SOC_DAPM_OUTPUT("LOUT"),
	SND_SOC_DAPM_OUTPUT("SDOUT"),
};

#define	CODEC_DEV_ADDR		(0x1A)


static struct i2c_board_info ioh_hwmon_info[] = {
	{I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR + 1)},
	{I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR + 2)},
	{I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR + 3)},
	{I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR + 4)},
	{I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR + 5)},
	{I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
};

static const struct snd_soc_dapm_route intercon[] = {
};

static int snd_card_codec_reg_read(struct snd_ml7213i2s_pcm *priv,
				   unsigned char reg, unsigned char *val)
{
	unsigned char data;
	struct i2c_client *i2c;

	mutex_lock(&priv->i2c_mutex);

	i2c = i2c_new_device(i2c_get_adapter(1),
			     &ioh_hwmon_info[priv->substream->number]);
	if (!i2c) {
		mutex_unlock(&priv->i2c_mutex);
		return -1;
	}

	if (i2c_master_send(i2c, &reg, 1) != 1) {
		mutex_unlock(&priv->i2c_mutex);
		return -1;
	}

	if (i2c_master_recv(i2c, &data, 1) != 1) {
		mutex_unlock(&priv->i2c_mutex);
		return -1;
	}

	*val = data;
	i2c_unregister_device(i2c);
	mutex_unlock(&priv->i2c_mutex);

	return 0;
}

static int snd_card_codec_reg_write(struct snd_ml7213i2s_pcm *priv,
				    unsigned char reg, unsigned char val)
{
	unsigned char buf[2] = {(reg|1), val};
	struct i2c_client *i2c;

	mutex_lock(&priv->i2c_mutex);

	i2c = i2c_new_device(i2c_get_adapter(1),
			     &ioh_hwmon_info[priv->substream->number]);

	if (i2c_master_send(i2c, &buf[0], 2) != 2) {
		mutex_unlock(&priv->i2c_mutex);
		return -1;
	}

	i2c_unregister_device(i2c);
	mutex_unlock(&priv->i2c_mutex);

	return 0;
}

static int snd_card_codec_set(int number, struct snd_ml7213i2s_pcm *priv)
{
	unsigned char data;
	unsigned int rate = priv->rate;
	unsigned int channels = priv->ch;

	snd_card_codec_reg_read(priv, 0x30, &data);	 /* Read MICVIAS Voltage */

	snd_card_codec_reg_write(priv, 0x10, 0x01);	/* soft reset assert */
	snd_card_codec_reg_write(priv, 0x10, 0x00);	/* soft reset negate */

	snd_card_codec_reg_write(priv, 0x0c, 0x00);	/* Stop clock  */

	switch (rate) {
	case 16000:
		snd_card_codec_reg_write(priv, 0x00, 0x03);
		snd_card_codec_reg_write(priv, 0x02, 0x0c);
		snd_card_codec_reg_write(priv, 0x04, 0x00);
		snd_card_codec_reg_write(priv, 0x06, 0x20);
		snd_card_codec_reg_write(priv, 0x08, 0x00);
		snd_card_codec_reg_write(priv, 0x0a, 0x04);
		break;
	case 32000:
		snd_card_codec_reg_write(priv, 0x00, 0x06);
		snd_card_codec_reg_write(priv, 0x02, 0x0c);
		snd_card_codec_reg_write(priv, 0x04, 0x00);
		snd_card_codec_reg_write(priv, 0x06, 0x20);
		snd_card_codec_reg_write(priv, 0x08, 0x00);
		snd_card_codec_reg_write(priv, 0x0a, 0x04);
		break;
	case 48000:
		snd_card_codec_reg_write(priv, 0x00, 0x08);
		snd_card_codec_reg_write(priv, 0x02, 0x0c);
		snd_card_codec_reg_write(priv, 0x04, 0x00);
		snd_card_codec_reg_write(priv, 0x06, 0x30);
		snd_card_codec_reg_write(priv, 0x08, 0x00);
		snd_card_codec_reg_write(priv, 0x0a, 0x04);
		break;
	default:
		pr_err("%s:this rate is no support for ml26124\n", __func__);
		break;
	}

	snd_card_codec_reg_write(priv, 0x0c, 0x03); /* Start MCLK and PLL */
	msleep(20);
	snd_card_codec_reg_write(priv, 0x0c, 0x0f); /* Clock control: MCLKI use */
	snd_card_codec_reg_write(priv, 0x0e, 0x04);

	if (channels == 1) {
		snd_card_codec_reg_write(priv, 0x60, 0x23); /* SAI transmitter control */
					/* 0x23 : FMTO=1, H=Left L=Right, no-delay*/
		snd_card_codec_reg_write(priv, 0x62, 0x23);  /* Receive side SAI control */
	} else {
		snd_card_codec_reg_write(priv, 0x60, 0x00);
		snd_card_codec_reg_write(priv, 0x62, 0x00);
	}

	snd_card_codec_reg_write(priv, 0x64, 0x00); /* master/slave set slave */

	snd_card_codec_reg_write(priv, 0x20, 0x02); /* VMID on. normal mode */
	msleep(50);

	snd_card_codec_reg_write(priv, 0x20, 0x06); /* Analog REference Power Managemet */
	snd_card_codec_reg_write(priv, 0x22, 0x0a); /* Analog Input Power Management */
	snd_card_codec_reg_write(priv, 0x24, 0x02); /* DAC power Management */
	snd_card_codec_reg_write(priv, 0x26, 0x13);
	snd_card_codec_reg_write(priv, 0x26, 0x1f); /* Speaker Amplified Poer Management */
	snd_card_codec_reg_write(priv, 0x28, 0x02); /* LOUT Control Regsister */

	snd_card_codec_reg_write(priv, 0x54, 0x02); /* Speaker Amplifier output Control */
	snd_card_codec_reg_write(priv, 0x5a, 0x00); /* Mic Interface Control Register */

	snd_card_codec_reg_write(priv, 0x12, 0x01); /* Record/Playback Running Control Register */
	snd_card_codec_reg_write(priv, 0x12, 0x03);
	msleep(20);
	snd_card_codec_reg_write(priv, 0x66, 0x03); /* DSP filter function Enable */

	snd_card_codec_reg_write(priv, 0x3a, 0x27); /* Speaker Amplifier Volume Control */
	snd_card_codec_reg_write(priv, 0x32, 0x20); /* Mic Input Volume Control */

	return 0;
}

static int ml26124_hw_params(struct snd_pcm_substream *substream,
			    struct snd_pcm_hw_params *hw_params,
			    struct snd_soc_dai *dai)
{
	struct snd_soc_codec *codec = dai->codec;
	struct snd_ml7213i2s_pcm *priv = snd_soc_codec_get_drvdata(codec);

	if (snd_card_codec_set(substream->number, priv))
		return -1;

	return snd_pcm_lib_malloc_pages(substream,
					params_buffer_bytes(hw_params));
}

static int snd_card_codec_free(int number, struct snd_ml7213i2s_pcm *priv)
{
	snd_card_codec_reg_write(priv, 0x10, 1);	/* soft reset assert */

	return 0;
}

static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream,
				      struct snd_soc_dai *dai)
{
	struct snd_ml7213i2s_pcm *priv = substream->runtime->private_data;

	if (snd_card_codec_free(substream->number, priv))
			return -1;

	return snd_pcm_lib_free_pages(substream);
}

static int ml26124_pcm_prepare(struct snd_pcm_substream *substream,
			      struct snd_soc_dai *dai)
{
	return 0;
}

static void ml26124_shutdown(struct snd_pcm_substream *substream,
			    struct snd_soc_dai *dai)
{
}

#define ML26124_DVOL_CTL		0x68	/* Digital Volume Conotrol
						   Function Enable Register */
#define DVOL_CTL_DVMUTE_ON		BIT(4)	/* Digital volume MUTE On */
#define DVOL_CTL_DVMUTE_OFF		0	/* Digital volume MUTE Off */

static int ml26124_mute(struct snd_soc_dai *dai, int mute)
{
	struct snd_soc_codec *codec = dai->codec;
	struct snd_ml7213i2s_pcm *priv = snd_soc_codec_get_drvdata(codec);

	if (mute)
		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
					 DVOL_CTL_DVMUTE_ON);
	else
		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
					 DVOL_CTL_DVMUTE_OFF);
	return 0;
}

static int ml26124_set_dai_fmt(struct snd_soc_dai *codec_dai,
		unsigned int fmt)
{
	struct snd_soc_codec *codec = codec_dai->codec;
	struct snd_ml7213i2s_pcm *priv = snd_soc_codec_get_drvdata(codec);
	unsigned char mode;

	/* set master/slave audio interface */
	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
	case SND_SOC_DAIFMT_CBM_CFM:
		mode = 1;
		break;
	case SND_SOC_DAIFMT_CBS_CFS:
		mode = 0;
		break;
	default:
		return -EINVAL;
	}
	snd_card_codec_reg_write(priv, ML26124_SAI_MODE_SEL, mode);

	/* interface format */
	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
	case SND_SOC_DAIFMT_I2S:
		break;
	default:
		return -EINVAL;
	}

	/* clock inversion */
	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
	case SND_SOC_DAIFMT_NB_NF:
		break;
	default:
		return -EINVAL;
	}

	return 0;
}

#define ML26124_REF_PM	0x20
#define REF_PM_MICBEN	BIT(2)	/* MIC BIAS Enable */
#define REF_PM_LOBIAS	BIT(6)	/* LOUT terminal BIAS Enable (1/2REGOUT) */
#define REF_PM_VMID_ON	BIT(1)	/* VMID generation circuit ON */
#define REF_PM_VMID_ON_FAST	BIT(0) /* VMID generation circuit Fast mode ON */
#define REF_PM_VMID_OFF	0	/* VMID generation circuit OFF */

static int ml26124_set_bias_level(struct snd_soc_codec *codec,
		enum snd_soc_bias_level level)
{
	struct snd_ml7213i2s_pcm *priv = snd_soc_codec_get_drvdata(codec);

	switch (level) {
	case SND_SOC_BIAS_ON:
	case SND_SOC_BIAS_PREPARE:
	case SND_SOC_BIAS_STANDBY:
		snd_card_codec_reg_write(priv, ML26124_REF_PM, REF_PM_VMID_ON);
		msleep(50);
		snd_card_codec_reg_write(priv, ML26124_REF_PM,
					 REF_PM_VMID_ON | REF_PM_MICBEN);
		break;
	case SND_SOC_BIAS_OFF:
		snd_card_codec_reg_write(priv, ML26124_REF_PM,
					 REF_PM_VMID_OFF | REF_PM_MICBEN);
		break;
	}
	codec->bias_level = level;
	return 0;
}

#define ML26124_RATES SNDRV_PCM_RATE_8000_96000

#define ML26124_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
	SNDRV_PCM_FMTBIT_S24_LE)

static struct snd_soc_dai_ops ml26124_dai_ops = {
	.prepare	= ml26124_pcm_prepare,
	.hw_params	= ml26124_hw_params,
	.hw_free	= snd_card_ml7213i2s_hw_free,
	.shutdown	= ml26124_shutdown,
	.digital_mute	= ml26124_mute,
	.set_fmt	= ml26124_set_dai_fmt,
};

struct snd_soc_dai_driver ml26124_dai = {
	.name = "ml26124-hifi",
	.playback = {
		.stream_name = "Playback",
		.channels_min = 1,
		.channels_max = 2,
		.rates = ML26124_RATES,
		.formats = ML26124_FORMATS,},
	.capture = {
		.stream_name = "Capture",
		.channels_min = 1,
		.channels_max = 2,
		.rates = ML26124_RATES,
		.formats = ML26124_FORMATS,},
	.ops = &ml26124_dai_ops,
	.symmetric_rates = 1,
};

#ifdef CONFIG_PM
static int ml26124_suspend(struct snd_soc_codec *codec, pm_message_t state)
{
	ml26124_set_bias_level(codec, SND_SOC_BIAS_OFF);

	return 0;
}

static int ml26124_resume(struct snd_soc_codec *codec)
{
	ml26124_set_bias_level(codec, SND_SOC_BIAS_STANDBY);

	return 0;
}
#else
#define ml26124_suspend NULL
#define ml26124_resume NULL
#endif

static int ml26124_probe(struct snd_soc_codec *codec)
{
	snd_soc_add_controls(codec, ml26124_snd_controls,
			     ARRAY_SIZE(ml26124_snd_controls));

	snd_soc_dapm_new_controls(codec, ml26124_dapm_widgets,
				  ARRAY_SIZE(ml26124_dapm_widgets));
	return 0;
}

/* power down chip */
static int ml26124_remove(struct snd_soc_codec *codec)
{
	return 0;
}

static struct snd_soc_codec_driver soc_codec_dev_ml26124 = {
	.probe =	ml26124_probe,
	.remove =	ml26124_remove,
	.suspend =	ml26124_suspend,
	.resume =	ml26124_resume,
	.set_bias_level = ml26124_set_bias_level,
	.reg_cache_size = ARRAY_SIZE(wm8731_reg),
	.reg_word_size = sizeof(u16),
	.reg_cache_default = wm8731_reg,
};

#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
static __devinit int ml26124_i2c_probe(struct i2c_client *i2c,
				      const struct i2c_device_id *id)
{
	struct snd_ml7213i2s_pcm *priv;
	int ret;

	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
	if (priv == NULL)
		return -ENOMEM;

	i2c_set_clientdata(i2c, priv);
	priv->control_type = SND_SOC_I2C;

	ret =  snd_soc_register_codec(&i2c->dev,
			&soc_codec_dev_ml26124, &ml26124_dai, 1);
	if (ret < 0)
		kfree(priv);

	mutex_init(&priv->i2c_mutex);

	return ret;
}

static __devexit int ml26124_i2c_remove(struct i2c_client *client)
{
	snd_soc_unregister_codec(&client->dev);
	kfree(i2c_get_clientdata(client));
	return 0;
}

static const struct i2c_device_id ml26124_i2c_id[] = {
	{ "ml26124", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, ml26124_i2c_id);

static struct i2c_driver ml26124_i2c_driver = {
	.driver = {
		.name = "ml26124-codec",
		.owner = THIS_MODULE,
	},
	.probe =    ml26124_i2c_probe,
	.remove =   __devexit_p(ml26124_i2c_remove),
	.id_table = ml26124_i2c_id,
};
#endif

static int __init ml26124_modinit(void)
{
	int ret = 0;
#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
	ret = i2c_add_driver(&ml26124_i2c_driver);
	if (ret != 0) {
		pr_err("Failed to register ML26124 I2C driver: %d\n", ret);
	}
#endif
	return ret;
}
module_init(ml26124_modinit);

static void __exit ml26124_exit(void)
{
#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
	i2c_del_driver(&ml26124_i2c_driver);
#endif
}
module_exit(ml26124_exit);

MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
MODULE_DESCRIPTION("LAPIS Semiconductor ML26124 ALSA SoC codec driver");
MODULE_LICENSE("GPL");

--------------000506070709060806020102
Content-Type: text/plain;
 name="ioh_i2s.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ioh_i2s.h"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#ifndef ML7213_IOH_I2S
#define ML7213_IOH_I2S

#define I2S_AEMPTY_THRESH	64	/* Almost  Empty Threshold */
#define I2S_AFULL_THRESH	64	/* Almost  Full Threshold */

#define MAX_I2S_RX_CH	MAX_I2S_CH
#define MAX_I2S_TX_CH	MAX_I2S_CH

#define	INTER_BUFF_SIZE		(I2S_AEMPTY_THRESH*4 \
				 *I2S_DMA_SG_NUM \
				 *I2S_DMA_SG_MAX)
#define	I2S_DMA_SG_NUM		(128)
#define	I2S_DMA_SG_MAX		(64)

struct ioh_i2s_data;


enum ioh_direction {
	IOH_PLAYBACK = 0,
	IOH_CAPTURE,
};

enum ioh_i2s_fifo_type {
	IOH_FIFO_32  = 4,
	IOH_FIFO_16 = 2,
	IOH_FIFO_8 = 1,
};

enum ioh_i2s_status {
	IOH_EOK = 0,
	IOH_EDONE = 1,
	IOH_EUNDERRUN = 2,
	IOH_EOVERRUN = 3,
	IOH_EFRAMESYNC = 4,
};

struct ioh_i2s_config_common_reg {
	u32 i2sclkcnt;	/*clock control register(ch0~5) */
	u32 i2sistatus;	/*interrupt status */
	u32 i2sidisp;		/*active interrupts */
	u32 i2simask;		/*interrupt mask */
	u32 i2simaskclr;	/*interrupt mask clear */
};

struct ioh_i2s_config_tx_reg {
	u32 i2sdrtx;	/*data register */
	u32 i2scnttx; /*control register */
	u32 i2sfifoctx;	/*FIFO control register */
	u32 i2saftx;	/*almost full threshold setting */
	u32 i2saetx;	/*almost empty threshold setting */
	u32 i2smsktx;	/*interrupt mask settings */
	u32 i2sisttx;	/*for acknowledging interrupts */
	u32 i2smontx;	/*monitor register */
};

struct ioh_i2s_config_rx_reg {
	u32 i2sdrrx;	/* data register */
	u32 i2scntrx;	/* control register */
	u32 i2sfifocrx;/* FIFO control register */
	u32 i2safrx;	/* almost full threshold setting */
	u32 i2saerx;	/* almost empty threshold setting */
	u32 i2smskrx;	/* interrupt mask settings */
	u32 i2sistrx;	/* for acknowledging interrupts */
	u32 i2smonrx;	/* monitor register */
};

struct ioh_i2s_config_reg {
	/* The common register settings */
	struct ioh_i2s_config_common_reg cmn;

	/* TX channel settings */
	struct ioh_i2s_config_tx_reg tx;

	/* RX channel settings */
	struct ioh_i2s_config_rx_reg rx;
};

/* For power management save/retore use */
struct ioh_i2s_pm_common_reg {
	u32 i2sclkcnt[6];
	u32 i2simask;
};

struct ioh_i2s_pm_ch_reg {
	u32 i2sdrtx;	/* Tx: data register */
	u32 i2scnttx; /* Tx: control register */
	u32 i2sfifoctx;	/* Tx: FIFO control register */
	u32 i2saftx;	/* Tx: almost full threshold setting */
	u32 i2saetx;	/* Tx: almost empty threshold setting */
	u32 i2smsktx;	/* Tx: interrupt mask settings */
	u32 i2sisttx;	/* Tx: for acknowledging interrupts */
	u32 i2scntrx;	/* Rx: control register */
	u32 i2sfifocrx; /* Rx: FIFO control register */
	u32 i2safrx;	/* Rx: almost full threshold setting */
	u32 i2saerx;	/* Rx: almost empty threshold setting */
	u32 i2smskrx;	/* Rx: interrupt mask settings */
	u32 i2sistrx;	/* Rx: for acknowledging interrupts */
};

#endif

--------------000506070709060806020102
Content-Type: text/plain;
 name="ioh_i2s_config.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ioh_i2s_config.h"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#ifndef ML7213_IOH_I2S_CONFIG
#define ML7213_IOH_I2S_CONFIG

#include "ioh_i2s.h"

#define	IOH_I2S_USE_PARAM	(1)
#define	I2S_SUPPORT_FS_NUM	(7)

#define	PERIOD_POS_MAX		(I2S_DMA_SG_NUM)
#define	PERIOD_LEN_TX		(I2S_AEMPTY_THRESH * PERIOD_POS_MAX)
#define	PERIOD_LEN_RX		(I2S_AFULL_THRESH * PERIOD_POS_MAX)

#define	SUPPORT_FORMAT		(SNDRV_PCM_FMTBIT_U8 | \
				 SNDRV_PCM_FMTBIT_S16_LE | \
				 SNDRV_PCM_FMTBIT_S32_LE)
#define	MAX_PERIOD_SIZE_TX	(PERIOD_LEN_TX*4)
#define	MAX_PERIOD_SIZE_RX	(PERIOD_LEN_RX*4)

#if (PERIOD_LEN_TX < (I2S_AEMPTY_THRESH*I2S_DMA_SG_NUM))
	#error IOH_I2S_CONFIG Error : PERIOD_LEN_TX is enlarged more.
#endif

#if (PERIOD_LEN_RX < (I2S_AFULL_THRESH*I2S_DMA_SG_NUM))
	#error IOH_I2S_CONFIG Error : PERIOD_LEN_RX is enlarged more.
#endif


/* ######################################################################## */
/* ###		Parameter setup possible value				### */
/* ######################################################################## */
/* ioh_mssel_t */
#define	ioh_mssel_slave		(0)
#define	ioh_mssel_master	(1)

enum ioh_bclkpol_t {
	ioh_bclkpol_falling = 0,
	ioh_bclkpol_rising,
};

enum ioh_masterclksel_t {
	ioh_masterclksel_mclk = 0,
	ioh_masterclksel_mlbclk,
};

enum ioh_lrckfmt_t {
	ioh_lrclkfmt_i2s = 1,
	ioh_lrclkfmt_longframe,
	ioh_lrclkfmt_shortframe,
};

enum ioh_mclkfs_t {
	ioh_mclkfs_64fs = 0,
	ioh_mclkfs_128fs,
	ioh_mclkfs_192fs,
	ioh_mclkfs_256fs,
	ioh_mclkfs_384fs,
	ioh_mclkfs_512fs,
	ioh_mclkfs_768fs,
	ioh_mclkfs_1024fs,
};

/* ioh_dabit_t */
#define	ioh_dabit_8bit		(0)
#define	ioh_dabit_16bit		(2)
#define	ioh_dabit_24bit		(5)

/* ioh_bclkfs_t */
#define	ioh_bclkfs_8fs		(0)
#define	ioh_bclkfs_16fs		(1)
#define	ioh_bclkfs_32fs		(2)
#define	ioh_bclkfs_64fs		(3)

/* ioh_tel_t */
#define	ioh_tel_i2s_fmt		(0)
#define	ioh_tel_tel_fmt		(1)

enum ioh_dlyoff_t {
	ioh_dlyoff_dly_on = 0,		/* date delat on */
	ioh_dlyoff_dly_off,		/* date delat off */
};

/* ioh_lsb_t */
#define	ioh_lsb_msb_first	(0)
#define	ioh_lsb_lsb_first	(1)

enum ioh_lrpol_t {
	ioh_lrpol_no_invert = 0,	/* Low of LRCLK is L data.
					   High of LRCLK is R data. */
	ioh_lrpol_invert,		/* Low of LRCLK is R data.
					   High of LRCLK is L data. */
};

enum ioh_aft_t {
	ioh_aft_front = 0,
	ioh_aft_back,
};


struct i2s_config_tab_t {
	unsigned int i2sclkcnt;
	unsigned int i2scnttx;
	unsigned int i2scntrx;
	unsigned int i2s_mclk;
};

struct i2s_config_rate_sub_t {
	unsigned int rate;
	unsigned int mclkfs;
};

struct i2s_config_rate_t {
	struct i2s_config_rate_sub_t i2s_config_rate_sub[I2S_SUPPORT_FS_NUM];
};


/* ######################################################################## */
/* ###		Parameter Config PreProcessor				### */
/* ######################################################################## */

/* I2S Config Value */
#define USE_CHANNELS_MIN	1
#define USE_CHANNELS_MAX	2

#define	MAX_I2S_CH		6		/*I2S0 ~ I2S5*/


/* =================== I2S CH0 config =================== */
#define	I2S_CH0_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH0_FS_16000	16000
	#define	I2S_CH0_FS_32000	32000
	#define	I2S_CH0_FS_48000	48000
  #else
	#define	I2S_CH0_FS_8000		8000
	#define	I2S_CH0_FS_11025	11025
	#define	I2S_CH0_FS_22050	22050
	#define	I2S_CH0_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH0_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH0_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH0 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH0_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH0_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH0_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH0_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH0_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH0_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH0_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH0_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH0_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH0_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH0 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH0_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH0_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH0_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH0_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH0_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH0_RX_LSB_MONO		(ioh_lsb_msb_first)


/* =================== I2S CH1 config =================== */
#define	I2S_CH1_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH1_FS_16000	16000
	#define	I2S_CH1_FS_32000	32000
	#define	I2S_CH1_FS_48000	48000
  #else
	#define	I2S_CH1_FS_8000		8000
	#define	I2S_CH1_FS_11025	11025
	#define	I2S_CH1_FS_22050	22050
	#define	I2S_CH1_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH1_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH1_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH1 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH1_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH1_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH1_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH1_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH1_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH1_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH1_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH1_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH1_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH1_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH1 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH1_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH1_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH1_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH1_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH1_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH1_RX_LSB_MONO		(ioh_lsb_msb_first)


/* =================== I2S CH2 config =================== */
#define	I2S_CH2_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH2_FS_16000	16000
	#define	I2S_CH2_FS_32000	32000
	#define	I2S_CH2_FS_48000	48000
  #else
	#define	I2S_CH2_FS_8000		8000
	#define	I2S_CH2_FS_11025	11025
	#define	I2S_CH2_FS_22050	22050
	#define	I2S_CH2_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH2_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH2_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH2 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH2_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH2_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH2_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH2_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH2_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH2_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH2_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH2_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH2_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH2_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH2 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH2_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH2_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH2_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH2_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH2_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH2_RX_LSB_MONO		(ioh_lsb_msb_first)


/* =================== I2S CH3 config =================== */
#define	I2S_CH3_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH3_FS_16000	16000
	#define	I2S_CH3_FS_32000	32000
	#define	I2S_CH3_FS_48000	48000
  #else
	#define	I2S_CH3_FS_8000		8000
	#define	I2S_CH3_FS_11025	11025
	#define	I2S_CH3_FS_22050	22050
	#define	I2S_CH3_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH3_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH3_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH3 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH3_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH3_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH3_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH3_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH3_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH3_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH3_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH3_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH3_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH3_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH3 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH3_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH3_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH3_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH3_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH3_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH3_RX_LSB_MONO		(ioh_lsb_msb_first)


/* =================== I2S CH4 config =================== */
#define	I2S_CH4_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH4_FS_16000	16000
	#define	I2S_CH4_FS_32000	32000
	#define	I2S_CH4_FS_48000	48000
  #else
	#define	I2S_CH4_FS_8000		8000
	#define	I2S_CH4_FS_11025	11025
	#define	I2S_CH4_FS_22050	22050
	#define	I2S_CH4_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH4_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH4_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH4 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH4_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH4_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH4_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH4_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH4_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH4_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH4_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH4_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH4_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH4_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH4 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH4_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH4_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH4_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH4_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH4_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH4_RX_LSB_MONO		(ioh_lsb_msb_first)


/* =================== I2S CH5 config =================== */
#define	I2S_CH5_MCLK		(12288000) /* Master Clock Frequency[Hz] */
  #if IOH_I2S_USE_PARAM
	#define	I2S_CH5_FS_16000	16000
	#define	I2S_CH5_FS_32000	32000
	#define	I2S_CH5_FS_48000	48000
  #else
	#define	I2S_CH5_FS_8000		8000
	#define	I2S_CH5_FS_11025	11025
	#define	I2S_CH5_FS_22050	22050
	#define	I2S_CH5_FS_44100	44100
  #endif

/* select master or slave. The value is ioh_mssel_t */
#define	I2S_CH5_MSSEL			(ioh_mssel_master)
/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
#define	I2S_CH5_MASTERCLKSEL		(ioh_masterclksel_mclk)

	/* I2S CH5 stereo config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH5_BCLKPOL_STEREO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH5_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH5_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH5_TX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
#define	I2S_CH5_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of TX side. The value is ioh_aft_t */
#define	I2S_CH5_TX_AFT_STEREO		(ioh_aft_front)

/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH5_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH5_RX_LSB_STEREO		(ioh_lsb_msb_first)
/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
#define	I2S_CH5_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
/* select transmit data front or back of RX side. The value is ioh_aft_t */
#define	I2S_CH5_RX_AFT_STEREO		(ioh_aft_front)

	/* I2S CH5 monaural config */
/* select BCLK polarity. The value is enum ioh_bclkpol_t */
#define	I2S_CH5_BCLKPOL_MONO		(ioh_bclkpol_falling)
/* select DAI format. The value is enum ioh_lrckfmt_t */
#define	I2S_CH5_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)

/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH5_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH5_TX_LSB_MONO		(ioh_lsb_msb_first)
/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
#define	I2S_CH5_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
#define	I2S_CH5_RX_LSB_MONO		(ioh_lsb_msb_first)


/* ######################################################################## */
/* ###		Parameter Check PreProcessor				### */
/* ######################################################################## */

/* ===== CH0 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH0	(0)
#ifdef	I2S_CH0_FS_8000
	#define	USE_RATE_CH0_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH0	(8000)
	#if (USE_RATE_MAX_CH0 < 8000)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(8000)
	#endif
#else
	#define	USE_RATE_CH0_8000	0
#endif

#ifdef	I2S_CH0_FS_11025
	#define	USE_RATE_CH0_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(11025)
	#endif
	#if (USE_RATE_MAX_CH0 < 11025)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(11025)
	#endif
#else
	#define	USE_RATE_CH0_11025	0
#endif

#ifdef	I2S_CH0_FS_16000
	#define	USE_RATE_CH0_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(16000)
	#endif
	#if (USE_RATE_MAX_CH0 < 16000)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(16000)
	#endif
#else
	#define	USE_RATE_CH0_16000	0
#endif

#ifdef	I2S_CH0_FS_22050
	#define	USE_RATE_CH0_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(22050)
	#endif
	#if (USE_RATE_MAX_CH0 < 22050)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(22050)
	#endif
#else
	#define	USE_RATE_CH0_22050	0
#endif

#ifdef	I2S_CH0_FS_32000
	#define	USE_RATE_CH0_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(32000)
	#endif
	#if (USE_RATE_MAX_CH0 < 32000)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(32000)
	#endif
#else
	#define	USE_RATE_CH0_32000	0
#endif

#ifdef	I2S_CH0_FS_44100
	#define	USE_RATE_CH0_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(44100)
	#endif
	#if (USE_RATE_MAX_CH0 < 44100)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(44100)
	#endif
#else
	#define	USE_RATE_CH0_44100	0
#endif

#ifdef	I2S_CH0_FS_48000
	#define	USE_RATE_CH0_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH0
		#define	USE_RATE_MIN_CH0	(48000)
	#endif
	#if (USE_RATE_MAX_CH0 < 48000)
		#undef	USE_RATE_MAX_CH0
		#define	USE_RATE_MAX_CH0	(48000)
	#endif
#else
	#define	USE_RATE_CH0_48000	0
#endif

#define	USE_RATE_CH0	(USE_RATE_CH0_8000|USE_RATE_CH0_11025 |		\
			 USE_RATE_CH0_16000|USE_RATE_CH0_22050 |	\
			 USE_RATE_CH0_32000|USE_RATE_CH0_44100 |	\
			 USE_RATE_CH0_48000)


#define I2S_CH0_64FS		(I2S_CH0_MCLK/64)
#define I2S_CH0_128FS		(I2S_CH0_MCLK/128)
#define I2S_CH0_192FS		(I2S_CH0_MCLK/192)
#define I2S_CH0_256FS		(I2S_CH0_MCLK/256)
#define I2S_CH0_384FS		(I2S_CH0_MCLK/384)
#define I2S_CH0_512FS		(I2S_CH0_MCLK/512)
#define I2S_CH0_768FS		(I2S_CH0_MCLK/768)
#define I2S_CH0_1024FS		(I2S_CH0_MCLK/1024)


#if (I2S_CH0_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH0_FS_8000
	#if (I2S_CH0_64FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_128FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_192FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_256FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_384FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_512FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_768FS != I2S_CH0_FS_8000) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_8000)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH0_FS_11025
	#if (I2S_CH0_64FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_128FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_192FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_256FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_384FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_512FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_768FS != I2S_CH0_FS_11025) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_11025)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH0_FS_16000
	#if (I2S_CH0_64FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_128FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_192FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_256FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_384FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_512FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_768FS != I2S_CH0_FS_16000) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_16000)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH0_FS_22050
	#if (I2S_CH0_64FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_128FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_192FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_256FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_384FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_512FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_768FS != I2S_CH0_FS_22050) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_22050)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH0_FS_32000
	#if (I2S_CH0_64FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_128FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_192FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_256FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_384FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_512FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_768FS != I2S_CH0_FS_32000) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_32000)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH0_FS_44100
	#if (I2S_CH0_64FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_128FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_192FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_256FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_384FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_512FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_768FS != I2S_CH0_FS_44100) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_44100)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH0_FS_48000
	#if (I2S_CH0_64FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_128FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_192FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_256FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_384FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_512FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_768FS != I2S_CH0_FS_48000) && \
		(I2S_CH0_1024FS != I2S_CH0_FS_48000)
		#error IOH_I2S_CH0_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH0_MSSEL == ioh_mssel_master)] */


/* ===== CH1 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH1	(0)
#ifdef	I2S_CH1_FS_8000
	#define	USE_RATE_CH1_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH1	(8000)
	#if (USE_RATE_MAX_CH1 < 8000)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(8000)
	#endif
#else
	#define	USE_RATE_CH1_8000	0
#endif

#ifdef	I2S_CH1_FS_11025
	#define	USE_RATE_CH1_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(11025)
	#endif
	#if (USE_RATE_MAX_CH1 < 11025)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(11025)
	#endif
#else
	#define	USE_RATE_CH1_11025	0
#endif

#ifdef	I2S_CH1_FS_16000
	#define	USE_RATE_CH1_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(16000)
	#endif
	#if (USE_RATE_MAX_CH1 < 16000)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(16000)
	#endif
#else
	#define	USE_RATE_CH1_16000	0
#endif

#ifdef	I2S_CH1_FS_22050
	#define	USE_RATE_CH1_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(22050)
	#endif
	#if (USE_RATE_MAX_CH1 < 22050)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(22050)
	#endif
#else
	#define	USE_RATE_CH1_22050	0
#endif

#ifdef	I2S_CH1_FS_32000
	#define	USE_RATE_CH1_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(32000)
	#endif
	#if (USE_RATE_MAX_CH1 < 32000)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(32000)
	#endif
#else
	#define	USE_RATE_CH1_32000	0
#endif

#ifdef	I2S_CH1_FS_44100
	#define	USE_RATE_CH1_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(44100)
	#endif
	#if (USE_RATE_MAX_CH1 < 44100)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(44100)
	#endif
#else
	#define	USE_RATE_CH1_44100	0
#endif

#ifdef	I2S_CH1_FS_48000
	#define	USE_RATE_CH1_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH1
		#define	USE_RATE_MIN_CH1	(48000)
	#endif
	#if (USE_RATE_MAX_CH1 < 48000)
		#undef	USE_RATE_MAX_CH1
		#define	USE_RATE_MAX_CH1	(48000)
	#endif
#else
	#define	USE_RATE_CH1_48000	0
#endif

#define	USE_RATE_CH1	(USE_RATE_CH1_8000|USE_RATE_CH1_11025 |		\
			 USE_RATE_CH1_16000|USE_RATE_CH1_22050 |	\
			 USE_RATE_CH1_32000|USE_RATE_CH1_44100 |	\
			 USE_RATE_CH1_48000)


#define I2S_CH1_64FS		(I2S_CH1_MCLK/64)
#define I2S_CH1_128FS		(I2S_CH1_MCLK/128)
#define I2S_CH1_192FS		(I2S_CH1_MCLK/192)
#define I2S_CH1_256FS		(I2S_CH1_MCLK/256)
#define I2S_CH1_384FS		(I2S_CH1_MCLK/384)
#define I2S_CH1_512FS		(I2S_CH1_MCLK/512)
#define I2S_CH1_768FS		(I2S_CH1_MCLK/768)
#define I2S_CH1_1024FS		(I2S_CH1_MCLK/1024)


#if (I2S_CH1_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH1_FS_8000
	#if (I2S_CH1_64FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_128FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_192FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_256FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_384FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_512FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_768FS != I2S_CH1_FS_8000) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_8000)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH1_FS_11025
	#if (I2S_CH1_64FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_128FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_192FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_256FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_384FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_512FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_768FS != I2S_CH1_FS_11025) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_11025)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH1_FS_16000
	#if (I2S_CH1_64FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_128FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_192FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_256FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_384FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_512FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_768FS != I2S_CH1_FS_16000) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_16000)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH1_FS_22050
	#if (I2S_CH1_64FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_128FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_192FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_256FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_384FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_512FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_768FS != I2S_CH1_FS_22050) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_22050)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH1_FS_32000
	#if (I2S_CH1_64FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_128FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_192FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_256FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_384FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_512FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_768FS != I2S_CH1_FS_32000) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_32000)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH1_FS_44100
	#if (I2S_CH1_64FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_128FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_192FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_256FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_384FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_512FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_768FS != I2S_CH1_FS_44100) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_44100)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH1_FS_48000
	#if (I2S_CH1_64FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_128FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_192FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_256FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_384FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_512FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_768FS != I2S_CH1_FS_48000) && \
		(I2S_CH1_1024FS != I2S_CH1_FS_48000)
		#error IOH_I2S_CH1_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH1_MSSEL == ioh_mssel_master)] */


/* ===== CH2 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH2	(0)
#ifdef	I2S_CH2_FS_8000
	#define	USE_RATE_CH2_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH2	(8000)
	#if (USE_RATE_MAX_CH2 < 8000)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(8000)
	#endif
#else
	#define	USE_RATE_CH2_8000	0
#endif

#ifdef	I2S_CH2_FS_11025
	#define	USE_RATE_CH2_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(11025)
	#endif
	#if (USE_RATE_MAX_CH2 < 11025)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(11025)
	#endif
#else
	#define	USE_RATE_CH2_11025	0
#endif

#ifdef	I2S_CH2_FS_16000
	#define	USE_RATE_CH2_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(16000)
	#endif
	#if (USE_RATE_MAX_CH2 < 16000)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(16000)
	#endif
#else
	#define	USE_RATE_CH2_16000	0
#endif

#ifdef	I2S_CH2_FS_22050
	#define	USE_RATE_CH2_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(22050)
	#endif
	#if (USE_RATE_MAX_CH2 < 22050)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(22050)
	#endif
#else
	#define	USE_RATE_CH2_22050	0
#endif

#ifdef	I2S_CH2_FS_32000
	#define	USE_RATE_CH2_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(32000)
	#endif
	#if (USE_RATE_MAX_CH2 < 32000)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(32000)
	#endif
#else
	#define	USE_RATE_CH2_32000	0
#endif

#ifdef	I2S_CH2_FS_44100
	#define	USE_RATE_CH2_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(44100)
	#endif
	#if (USE_RATE_MAX_CH2 < 44100)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(44100)
	#endif
#else
	#define	USE_RATE_CH2_44100	0
#endif

#ifdef	I2S_CH2_FS_48000
	#define	USE_RATE_CH2_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH2
		#define	USE_RATE_MIN_CH2	(48000)
	#endif
	#if (USE_RATE_MAX_CH2 < 48000)
		#undef	USE_RATE_MAX_CH2
		#define	USE_RATE_MAX_CH2	(48000)
	#endif
#else
	#define	USE_RATE_CH2_48000	0
#endif

#define	USE_RATE_CH2	(USE_RATE_CH2_8000|USE_RATE_CH2_11025 |		\
			 USE_RATE_CH2_16000|USE_RATE_CH2_22050 |	\
			 USE_RATE_CH2_32000|USE_RATE_CH2_44100 |	\
			 USE_RATE_CH2_48000)


#define I2S_CH2_64FS		(I2S_CH2_MCLK/64)
#define I2S_CH2_128FS		(I2S_CH2_MCLK/128)
#define I2S_CH2_192FS		(I2S_CH2_MCLK/192)
#define I2S_CH2_256FS		(I2S_CH2_MCLK/256)
#define I2S_CH2_384FS		(I2S_CH2_MCLK/384)
#define I2S_CH2_512FS		(I2S_CH2_MCLK/512)
#define I2S_CH2_768FS		(I2S_CH2_MCLK/768)
#define I2S_CH2_1024FS		(I2S_CH2_MCLK/1024)


#if (I2S_CH2_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH2_FS_8000
	#if (I2S_CH2_64FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_128FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_192FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_256FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_384FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_512FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_768FS != I2S_CH2_FS_8000) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_8000)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH2_FS_11025
	#if (I2S_CH2_64FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_128FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_192FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_256FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_384FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_512FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_768FS != I2S_CH2_FS_11025) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_11025)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH2_FS_16000
	#if (I2S_CH2_64FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_128FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_192FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_256FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_384FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_512FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_768FS != I2S_CH2_FS_16000) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_16000)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH2_FS_22050
	#if (I2S_CH2_64FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_128FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_192FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_256FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_384FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_512FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_768FS != I2S_CH2_FS_22050) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_22050)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH2_FS_32000
	#if (I2S_CH2_64FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_128FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_192FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_256FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_384FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_512FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_768FS != I2S_CH2_FS_32000) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_32000)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH2_FS_44100
	#if (I2S_CH2_64FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_128FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_192FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_256FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_384FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_512FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_768FS != I2S_CH2_FS_44100) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_44100)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH2_FS_48000
	#if (I2S_CH2_64FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_128FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_192FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_256FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_384FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_512FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_768FS != I2S_CH2_FS_48000) && \
		(I2S_CH2_1024FS != I2S_CH2_FS_48000)
		#error IOH_I2S_CH2_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH2_MSSEL == ioh_mssel_master)] */


/* ===== CH3 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH3	(0)
#ifdef	I2S_CH3_FS_8000
	#define	USE_RATE_CH3_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH3	(8000)
	#if (USE_RATE_MAX_CH3 < 8000)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(8000)
	#endif
#else
	#define	USE_RATE_CH3_8000	0
#endif

#ifdef	I2S_CH3_FS_11025
	#define	USE_RATE_CH3_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(11025)
	#endif
	#if (USE_RATE_MAX_CH3 < 11025)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(11025)
	#endif
#else
	#define	USE_RATE_CH3_11025	0
#endif

#ifdef	I2S_CH3_FS_16000
	#define	USE_RATE_CH3_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(16000)
	#endif
	#if (USE_RATE_MAX_CH3 < 16000)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(16000)
	#endif
#else
	#define	USE_RATE_CH3_16000	0
#endif

#ifdef	I2S_CH3_FS_22050
	#define	USE_RATE_CH3_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(22050)
	#endif
	#if (USE_RATE_MAX_CH3 < 22050)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(22050)
	#endif
#else
	#define	USE_RATE_CH3_22050	0
#endif

#ifdef	I2S_CH3_FS_32000
	#define	USE_RATE_CH3_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(32000)
	#endif
	#if (USE_RATE_MAX_CH3 < 32000)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(32000)
	#endif
#else
	#define	USE_RATE_CH3_32000	0
#endif

#ifdef	I2S_CH3_FS_44100
	#define	USE_RATE_CH3_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(44100)
	#endif
	#if (USE_RATE_MAX_CH3 < 44100)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(44100)
	#endif
#else
	#define	USE_RATE_CH3_44100	0
#endif

#ifdef	I2S_CH3_FS_48000
	#define	USE_RATE_CH3_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH3
		#define	USE_RATE_MIN_CH3	(48000)
	#endif
	#if (USE_RATE_MAX_CH3 < 48000)
		#undef	USE_RATE_MAX_CH3
		#define	USE_RATE_MAX_CH3	(48000)
	#endif
#else
	#define	USE_RATE_CH3_48000	0
#endif

#define	USE_RATE_CH3	(USE_RATE_CH3_8000|USE_RATE_CH3_11025 |		\
			 USE_RATE_CH3_16000|USE_RATE_CH3_22050 |	\
			 USE_RATE_CH3_32000|USE_RATE_CH3_44100 |	\
			 USE_RATE_CH3_48000)


#define I2S_CH3_64FS		(I2S_CH3_MCLK/64)
#define I2S_CH3_128FS		(I2S_CH3_MCLK/128)
#define I2S_CH3_192FS		(I2S_CH3_MCLK/192)
#define I2S_CH3_256FS		(I2S_CH3_MCLK/256)
#define I2S_CH3_384FS		(I2S_CH3_MCLK/384)
#define I2S_CH3_512FS		(I2S_CH3_MCLK/512)
#define I2S_CH3_768FS		(I2S_CH3_MCLK/768)
#define I2S_CH3_1024FS		(I2S_CH3_MCLK/1024)


#if (I2S_CH3_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH3_FS_8000
	#if (I2S_CH3_64FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_128FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_192FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_256FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_384FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_512FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_768FS != I2S_CH3_FS_8000) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_8000)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH3_FS_11025
	#if (I2S_CH3_64FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_128FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_192FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_256FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_384FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_512FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_768FS != I2S_CH3_FS_11025) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_11025)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH3_FS_16000
	#if (I2S_CH3_64FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_128FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_192FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_256FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_384FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_512FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_768FS != I2S_CH3_FS_16000) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_16000)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH3_FS_22050
	#if (I2S_CH3_64FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_128FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_192FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_256FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_384FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_512FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_768FS != I2S_CH3_FS_22050) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_22050)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH3_FS_32000
	#if (I2S_CH3_64FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_128FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_192FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_256FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_384FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_512FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_768FS != I2S_CH3_FS_32000) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_32000)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH3_FS_44100
	#if (I2S_CH3_64FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_128FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_192FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_256FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_384FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_512FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_768FS != I2S_CH3_FS_44100) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_44100)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH3_FS_48000
	#if (I2S_CH3_64FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_128FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_192FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_256FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_384FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_512FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_768FS != I2S_CH3_FS_48000) && \
		(I2S_CH3_1024FS != I2S_CH3_FS_48000)
		#error IOH_I2S_CH3_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH3_MSSEL == ioh_mssel_master)] */


/* ===== CH4 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH4	(0)
#ifdef	I2S_CH4_FS_8000
	#define	USE_RATE_CH4_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH4	(8000)
	#if (USE_RATE_MAX_CH4 < 8000)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(8000)
	#endif
#else
	#define	USE_RATE_CH4_8000	0
#endif

#ifdef	I2S_CH4_FS_11025
	#define	USE_RATE_CH4_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(11025)
	#endif
	#if (USE_RATE_MAX_CH4 < 11025)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(11025)
	#endif
#else
	#define	USE_RATE_CH4_11025	0
#endif

#ifdef	I2S_CH4_FS_16000
	#define	USE_RATE_CH4_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(16000)
	#endif
	#if (USE_RATE_MAX_CH4 < 16000)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(16000)
	#endif
#else
	#define	USE_RATE_CH4_16000	0
#endif

#ifdef	I2S_CH4_FS_22050
	#define	USE_RATE_CH4_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(22050)
	#endif
	#if (USE_RATE_MAX_CH4 < 22050)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(22050)
	#endif
#else
	#define	USE_RATE_CH4_22050	0
#endif

#ifdef	I2S_CH4_FS_32000
	#define	USE_RATE_CH4_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(32000)
	#endif
	#if (USE_RATE_MAX_CH4 < 32000)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(32000)
	#endif
#else
	#define	USE_RATE_CH4_32000	0
#endif

#ifdef	I2S_CH4_FS_44100
	#define	USE_RATE_CH4_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(44100)
	#endif
	#if (USE_RATE_MAX_CH4 < 44100)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(44100)
	#endif
#else
	#define	USE_RATE_CH4_44100	0
#endif

#ifdef	I2S_CH4_FS_48000
	#define	USE_RATE_CH4_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH4
		#define	USE_RATE_MIN_CH4	(48000)
	#endif
	#if (USE_RATE_MAX_CH4 < 48000)
		#undef	USE_RATE_MAX_CH4
		#define	USE_RATE_MAX_CH4	(48000)
	#endif
#else
	#define	USE_RATE_CH4_48000	0
#endif

#define	USE_RATE_CH4	(USE_RATE_CH4_8000|USE_RATE_CH4_11025 |		\
			 USE_RATE_CH4_16000|USE_RATE_CH4_22050 |	\
			 USE_RATE_CH4_32000|USE_RATE_CH4_44100 |	\
			 USE_RATE_CH4_48000)


#define I2S_CH4_64FS		(I2S_CH4_MCLK/64)
#define I2S_CH4_128FS		(I2S_CH4_MCLK/128)
#define I2S_CH4_192FS		(I2S_CH4_MCLK/192)
#define I2S_CH4_256FS		(I2S_CH4_MCLK/256)
#define I2S_CH4_384FS		(I2S_CH4_MCLK/384)
#define I2S_CH4_512FS		(I2S_CH4_MCLK/512)
#define I2S_CH4_768FS		(I2S_CH4_MCLK/768)
#define I2S_CH4_1024FS		(I2S_CH4_MCLK/1024)


#if (I2S_CH4_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH4_FS_8000
	#if (I2S_CH4_64FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_128FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_192FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_256FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_384FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_512FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_768FS != I2S_CH4_FS_8000) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_8000)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH4_FS_11025
	#if (I2S_CH4_64FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_128FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_192FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_256FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_384FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_512FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_768FS != I2S_CH4_FS_11025) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_11025)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH4_FS_16000
	#if (I2S_CH4_64FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_128FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_192FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_256FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_384FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_512FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_768FS != I2S_CH4_FS_16000) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_16000)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH4_FS_22050
	#if (I2S_CH4_64FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_128FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_192FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_256FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_384FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_512FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_768FS != I2S_CH4_FS_22050) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_22050)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH4_FS_32000
	#if (I2S_CH4_64FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_128FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_192FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_256FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_384FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_512FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_768FS != I2S_CH4_FS_32000) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_32000)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH4_FS_44100
	#if (I2S_CH4_64FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_128FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_192FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_256FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_384FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_512FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_768FS != I2S_CH4_FS_44100) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_44100)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH4_FS_48000
	#if (I2S_CH4_64FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_128FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_192FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_256FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_384FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_512FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_768FS != I2S_CH4_FS_48000) && \
		(I2S_CH4_1024FS != I2S_CH4_FS_48000)
		#error IOH_I2S_CH4_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH4_MSSEL == ioh_mssel_master)] */


/* ===== CH5 Parameter Error Check ==== */
#define	USE_RATE_MAX_CH5	(0)
#ifdef	I2S_CH5_FS_8000
	#define	USE_RATE_CH5_8000	SNDRV_PCM_RATE_8000
	#define	USE_RATE_MIN_CH5	(8000)
	#if (USE_RATE_MAX_CH5 < 8000)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(8000)
	#endif
#else
	#define	USE_RATE_CH5_8000	0
#endif

#ifdef	I2S_CH5_FS_11025
	#define	USE_RATE_CH5_11025	SNDRV_PCM_RATE_11025
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(11025)
	#endif
	#if (USE_RATE_MAX_CH5 < 11025)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(11025)
	#endif
#else
	#define	USE_RATE_CH5_11025	0
#endif

#ifdef	I2S_CH5_FS_16000
	#define	USE_RATE_CH5_16000	SNDRV_PCM_RATE_16000
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(16000)
	#endif
	#if (USE_RATE_MAX_CH5 < 16000)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(16000)
	#endif
#else
	#define	USE_RATE_CH5_16000	0
#endif

#ifdef	I2S_CH5_FS_22050
	#define	USE_RATE_CH5_22050	SNDRV_PCM_RATE_22050
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(22050)
	#endif
	#if (USE_RATE_MAX_CH5 < 22050)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(22050)
	#endif
#else
	#define	USE_RATE_CH5_22050	0
#endif

#ifdef	I2S_CH5_FS_32000
	#define	USE_RATE_CH5_32000	SNDRV_PCM_RATE_32000
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(32000)
	#endif
	#if (USE_RATE_MAX_CH5 < 32000)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(32000)
	#endif
#else
	#define	USE_RATE_CH5_32000	0
#endif

#ifdef	I2S_CH5_FS_44100
	#define	USE_RATE_CH5_44100	SNDRV_PCM_RATE_44100
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(44100)
	#endif
	#if (USE_RATE_MAX_CH5 < 44100)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(44100)
	#endif
#else
	#define	USE_RATE_CH5_44100	0
#endif

#ifdef	I2S_CH5_FS_48000
	#define	USE_RATE_CH5_48000	SNDRV_PCM_RATE_48000
	#ifndef	USE_RATE_MIN_CH5
		#define	USE_RATE_MIN_CH5	(48000)
	#endif
	#if (USE_RATE_MAX_CH5 < 48000)
		#undef	USE_RATE_MAX_CH5
		#define	USE_RATE_MAX_CH5	(48000)
	#endif
#else
	#define	USE_RATE_CH5_48000	0
#endif

#define	USE_RATE_CH5	(USE_RATE_CH5_8000|USE_RATE_CH5_11025 |		\
			 USE_RATE_CH5_16000|USE_RATE_CH5_22050 |	\
			 USE_RATE_CH5_32000|USE_RATE_CH5_44100 |	\
			 USE_RATE_CH5_48000)


#define I2S_CH5_64FS		(I2S_CH5_MCLK/64)
#define I2S_CH5_128FS		(I2S_CH5_MCLK/128)
#define I2S_CH5_192FS		(I2S_CH5_MCLK/192)
#define I2S_CH5_256FS		(I2S_CH5_MCLK/256)
#define I2S_CH5_384FS		(I2S_CH5_MCLK/384)
#define I2S_CH5_512FS		(I2S_CH5_MCLK/512)
#define I2S_CH5_768FS		(I2S_CH5_MCLK/768)
#define I2S_CH5_1024FS		(I2S_CH5_MCLK/1024)


#if (I2S_CH5_MSSEL == ioh_mssel_master)
#ifdef	I2S_CH5_FS_8000
	#if (I2S_CH5_64FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_128FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_192FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_256FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_384FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_512FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_768FS != I2S_CH5_FS_8000) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_8000)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 8000Hz can not generate.
	#endif
#endif

#ifdef	I2S_CH5_FS_11025
	#if (I2S_CH5_64FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_128FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_192FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_256FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_384FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_512FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_768FS != I2S_CH5_FS_11025) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_11025)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 11025Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH5_FS_16000
	#if (I2S_CH5_64FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_128FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_192FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_256FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_384FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_512FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_768FS != I2S_CH5_FS_16000) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_16000)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 16000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH5_FS_22050
	#if (I2S_CH5_64FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_128FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_192FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_256FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_384FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_512FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_768FS != I2S_CH5_FS_22050) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_22050)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 22050Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH5_FS_32000
	#if (I2S_CH5_64FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_128FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_192FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_256FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_384FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_512FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_768FS != I2S_CH5_FS_32000) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_32000)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 32000Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH5_FS_44100
	#if (I2S_CH5_64FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_128FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_192FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_256FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_384FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_512FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_768FS != I2S_CH5_FS_44100) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_44100)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 44100Hz can not generate.
	#endif
#endif
#ifdef	I2S_CH5_FS_48000
	#if (I2S_CH5_64FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_128FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_192FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_256FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_384FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_512FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_768FS != I2S_CH5_FS_48000) && \
		(I2S_CH5_1024FS != I2S_CH5_FS_48000)
		#error IOH_I2S_CH5_CONFIG Error : \
			Sampling frequency 48000Hz can not generate.
	#endif
#endif
#endif	/* end of [#if (I2S_CH5_MSSEL == ioh_mssel_master)] */



/* ######################################################################## */
/* ###		Parameter Table Data					### */
/* ######################################################################## */

#define	I2SCLKCNT_MSSEL_OFFSET		(0)
#define	I2SCLKCNT_BCLKPOL_OFFSET	(1)
#define	I2SCLKCNT_MASTERCLKSEL_OFFSET	(2)
#define	I2SCLKCNT_LRCKFMT_OFFSET	(4)
#define	I2SCLKCNT_MCLKFS_OFFSET		(8)
#define	I2SCLKCNT_BCLKFS_OFFSET		(12)

#define	I2SCNT_DABIT_OFFSET		(8)

#define	I2SCNTTX_TX_TEL_OFFSET		(0)
#define	I2SCNTTX_TX_DLYOFF_OFFSET	(12)
#define	I2SCNTTX_TX_LSB_OFFSET		(13)
#define	I2SCNTTX_TX_LRPOL_OFFSET	(14)
#define	I2SCNTTX_TX_AFT_OFFSET		(15)

#define	I2SCNTRX_RX_TEL_OFFSET		(0)
#define	I2SCNTRX_RX_DLYOFF_OFFSET	(12)
#define	I2SCNTRX_RX_LSB_OFFSET		(13)
#define	I2SCNTRX_RX_LRPOL_OFFSET	(14)
#define	I2SCNTRX_RX_AFT_OFFSET		(15)


#define	STEREO_OFFSET			0
#define	MONAURAL_OFFSET			MAX_I2S_CH
static const struct i2s_config_tab_t i2s_config_table[MAX_I2S_CH*2] = {
	/* CH0 Stereo */
	{
		(I2S_CH0_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH0_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH0_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH0_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH0_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH0_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH0_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH0_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH0_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH0_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH0_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH0_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH0_MCLK,
	},
	/* CH1 Stereo */
	{
		(I2S_CH1_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH1_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH1_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH1_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH1_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH1_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH1_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH1_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH1_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH1_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH1_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH1_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH1_MCLK,
	},
	/* CH2 Stereo */
	{
		(I2S_CH2_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH2_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH2_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH2_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH2_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH2_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH2_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH2_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH2_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH2_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH2_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH2_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH2_MCLK,
	},
	/* CH3 Stereo */
	{
		(I2S_CH3_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH3_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH3_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH3_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH3_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH3_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH3_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH3_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH3_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH3_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH3_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH3_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH3_MCLK,
	},
	/* CH4 Stereo */
	{
		(I2S_CH4_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH4_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH4_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH4_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH4_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH4_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH4_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH4_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH4_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH4_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH4_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH4_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH4_MCLK,
	},
	/* CH5 Stereo */
	{
		(I2S_CH5_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH5_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH5_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH5_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH5_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH5_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (I2S_CH5_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (I2S_CH5_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH5_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH5_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (I2S_CH5_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (I2S_CH5_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH5_MCLK,
	},


	/* CH0 Mono */
	{
		(I2S_CH0_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH0_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH0_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH0_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH0_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH0_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH0_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH0_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH0_MCLK,
	},
	/* CH1 Mono */
	{
		(I2S_CH1_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH1_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH1_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH1_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH1_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH1_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH1_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH1_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH1_MCLK,
	},
	/* CH2 Mono */
	{
		(I2S_CH2_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH2_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH2_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH2_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH2_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH2_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH2_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH2_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH2_MCLK,
	},
	/* CH3 Mono */
	{
		(I2S_CH3_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH3_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH3_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH3_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH3_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH3_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH3_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH3_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH3_MCLK,
	},
	/* CH4 Mono */
	{
		(I2S_CH4_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH4_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH4_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH4_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH4_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH4_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH4_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH4_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH4_MCLK,
	},
	/* CH5 Mono */
	{
		(I2S_CH5_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
		  (I2S_CH5_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
		  (I2S_CH5_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
		  (I2S_CH5_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),

		  (I2S_CH5_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
		  (I2S_CH5_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),

		  (I2S_CH5_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
		  (I2S_CH5_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),

		I2S_CH5_MCLK,
	},

};


#endif

--------------000506070709060806020102
Content-Type: text/plain;
 name="ml7213ioh-machine.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ml7213ioh-machine.c"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */
#include <linux/module.h>
#include <linux/platform_device.h>
#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/soc.h>

static struct snd_soc_dai_link ioh_i2s_dai = {
	.name = "I2S",
	.stream_name = "I2S HiFi",
	.cpu_dai_name = "ml7213ioh-i2s",
	.codec_dai_name = "ml7213ioh-hifi",
	.platform_name	= "ml7213ioh-pcm-audio",
	.codec_name	= "ml26124-codec",
};

static struct snd_soc_card ioh_i2s_card = {
	.name		= "ml7213ioh i2s",
	.dai_link	= &ioh_i2s_dai,
	.num_links	= 1,
};

static struct platform_device *soc_pdev;

static int __init ioh_i2s_probe(struct platform_device *pdev)
{
	int ret;

	soc_pdev = platform_device_alloc("soc-audio", -1);
	if (!soc_pdev)
		return -ENOMEM;
	platform_set_drvdata(soc_pdev, &ioh_i2s_card);
	ret = platform_device_add(soc_pdev);
	if (ret) {
		platform_device_put(soc_pdev);
		return ret;
	}

	return 0;
}

static int __exit ioh_i2s_remove(struct platform_device *pdev)
{
	platform_device_unregister(soc_pdev);
	return 0;
}

static struct platform_driver ioh_i2s_driver = {
	.remove = ioh_i2s_remove,
	.driver = {
		.name = "ml7213ioh-machine",
		.owner = THIS_MODULE,
	},
};

static int __init ioh_i2s_init(void)
{
	return platform_driver_probe(&ioh_i2s_driver,
				     ioh_i2s_probe);
}

static void __exit ioh_i2s_exit(void)
{
	platform_driver_unregister(&ioh_i2s_driver);
}

module_init(ioh_i2s_init);
module_exit(ioh_i2s_exit);

MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
MODULE_LICENSE("GPL");

--------------000506070709060806020102
Content-Type: text/plain;
 name="ml7213ioh-plat.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ml7213ioh-plat.c"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/platform_device.h>
#include <linux/scatterlist.h>
#include <linux/slab.h>
#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/pcm_params.h>
#include <sound/soc.h>
#include <sound/initval.h>

#include <linux/pci.h>
#include <linux/dma-mapping.h>

#include "ioh_i2s.h"
#include "ioh_i2s_config.h"
#include "ml7213ioh-plat.h"

#define USE_PERIODS_MIN		(I2S_DMA_SG_MAX)
#define USE_PERIODS_MAX		(I2S_DMA_SG_MAX)
#ifndef add_capture_constraints
#define add_capture_constraints(x) 0
#endif

#define	I2S_WRITE_MASTER_BIT	(0)
#define	I2S_READ_MASTER_BIT	(8)

#define	I2S_WRITE_ENABLE_BIT	(0)
#define	I2S_READ_ENABLE_BIT	(8)

/* RW flag */
#define	SND_CAPTURE_SUBSTREAM	0
#define	SND_PLAYBACK_SUBSTREAM	1

/* Codec Device Address */

#define	I2SCNTRX_RXTEL		BIT(0)
#define I2SCNTRX_RXDABIT_8BIT	0
#define I2SCNTRX_RXDABIT_14BIT	BIT(8)
#define I2SCNTRX_RXDABIT_16BIT	BIT(9)
#define I2SCNTRX_RXDABIT_18BIT	(BIT(8) | BIT(9))
#define I2SCNTRX_RXDABIT_20BIT	BIT(10)
#define I2SCNTRX_RXDABIT_24BIT	(BIT(8) | BIT(10))
#define	I2SCNTRX_RXDLYOFF	BIT(12)
#define	I2SCNTRX_RX_LSB		BIT(13)

#define	I2SCNTTX_TXTEL		I2SCNTRX_RXTEL
#define I2SCNTTX_TXDABIT_8BIT	I2SCNTRX_RXDABIT_8BIT
#define I2SCNTTX_TXDABIT_14BIT	I2SCNTRX_RXDABIT_14BIT
#define I2SCNTTX_TXDABIT_16BIT	I2SCNTRX_RXDABIT_16BIT
#define I2SCNTTX_TXDABIT_18BIT	I2SCNTRX_RXDABIT_18BIT
#define I2SCNTTX_TXDABIT_20BIT	I2SCNTRX_RXDABIT_20BIT
#define I2SCNTTX_TXDABIT_24BIT	I2SCNTRX_RXDABIT_24BIT
#define	I2SCNTTX_TXDLYOFF	I2SCNTRX_RXDLYOFF
#define	I2SCNTTX_TX_LSB		I2SCNTRX_RX_LSB

#define I2SCLKCNT_MCLKFS_64FS	0
#define I2SCLKCNT_MCLKFS_128FS	BIT(8)
#define I2SCLKCNT_MCLKFS_192FS	BIT(9)
#define I2SCLKCNT_MCLKFS_256FS	(BIT(8) | BIT(9))
#define I2SCLKCNT_MCLKFS_384FS	BIT(10)
#define I2SCLKCNT_MCLKFS_512FS	(BIT(8) | BIT(10))
#define I2SCLKCNT_MCLKFS_768FS	(BIT(9) | BIT(10))
#define I2SCLKCNT_MCLKFS_1024FS	(BIT(8) | BIT(9) | BIT(10))

#define I2SCLKCNT_BCLKFS_8FS	0
#define I2SCLKCNT_BCLKFS_16FS	BIT(12)
#define I2SCLKCNT_BCLKFS_32FS	BIT(13)
#define I2SCLKCNT_BCLKFS_64FS	(BIT(12) | BIT(13))

#define I2SCLKCNT_MSSEL		BIT(0)
#define I2SCLKCNT_BCLKPOL	BIT(1)

#define I2SCLKCNT_LRCKFMT_I2S	0
#define I2SCLKCNT_LRCKFMT_LONG	BIT(5)
#define I2SCLKCNT_LRCKFMT_SHORT	(BIT(4)|BIT(5))

#define DRV_NAME "ml7213_ioh_i2s"
#define PCI_VENDOR_ID_ROHM	0X10DB
#define PCI_DEVICE_ID_ML7213_I2S	0X8033

struct snd_ml7213i2s {
	struct snd_card *card;
	struct snd_pcm *pcm;
	struct ioh_i2s_data_pci *pci_dat;
};

struct cbdata {
	struct ioh_i2s_data *priv;
	int stop;
	int cnt;
};

struct snd_ml7213i2s_pcm {
	struct snd_ml7213i2s *ml7213i2s;
	spinlock_t lock;
	unsigned int irq_pos;
	unsigned int buf_pos;
	struct snd_pcm_substream *substream;
	struct cbdata cbd;              /* i2s callback info */
	unsigned int channels;
	unsigned int rw;
	unsigned int rate;
	unsigned int ch;
	unsigned int setup_flag;
	unsigned int format;
	unsigned int bclkfs;
	unsigned int master_mode;
	unsigned int enable_mode;
};

static struct snd_pcm_hardware snd_card_ml7213i2s_capture[MAX_I2S_CH] = {
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH0,
		.rate_min =		USE_RATE_MIN_CH0,
		.rate_max =		USE_RATE_MAX_CH0,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH1,
		.rate_min =		USE_RATE_MIN_CH1,
		.rate_max =		USE_RATE_MAX_CH1,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH2,
		.rate_min =		USE_RATE_MIN_CH2,
		.rate_max =		USE_RATE_MAX_CH2,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH3,
		.rate_min =		USE_RATE_MIN_CH3,
		.rate_max =		USE_RATE_MAX_CH3,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH4,
		.rate_min =		USE_RATE_MIN_CH4,
		.rate_max =		USE_RATE_MAX_CH4,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH5,
		.rate_min =		USE_RATE_MIN_CH5,
		.rate_max =		USE_RATE_MAX_CH5,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
};

static struct snd_pcm_hardware snd_card_ml7213i2s_playback[MAX_I2S_CH] = {
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH0,
		.rate_min =		USE_RATE_MIN_CH0,
		.rate_max =		USE_RATE_MAX_CH0,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH1,
		.rate_min =		USE_RATE_MIN_CH1,
		.rate_max =		USE_RATE_MAX_CH1,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH2,
		.rate_min =		USE_RATE_MIN_CH2,
		.rate_max =		USE_RATE_MAX_CH2,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH3,
		.rate_min =		USE_RATE_MIN_CH3,
		.rate_max =		USE_RATE_MAX_CH3,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH4,
		.rate_min =		USE_RATE_MIN_CH4,
		.rate_max =		USE_RATE_MAX_CH4,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
	{
		.info =			(SNDRV_PCM_INFO_MMAP |
					 SNDRV_PCM_INFO_INTERLEAVED |
					 SNDRV_PCM_INFO_RESUME |
					 SNDRV_PCM_INFO_MMAP_VALID),
		.formats =		SUPPORT_FORMAT,
		.rates =		USE_RATE_CH5,
		.rate_min =		USE_RATE_MIN_CH5,
		.rate_max =		USE_RATE_MAX_CH5,
		.channels_min =		USE_CHANNELS_MIN,
		.channels_max =		USE_CHANNELS_MAX,
		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
					 USE_PERIODS_MAX),
		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
		.periods_min =		USE_PERIODS_MIN,
		.periods_max =		USE_PERIODS_MAX,
		.fifo_size =		0,
	},
};

static int ignore_overrun = 1;
static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
module_param(ignore_overrun, int, 0444);
module_param(index, int, 0444);
MODULE_PARM_DESC(ignore_overrun, "ignore RX overruns (default=0)");
MODULE_PARM_DESC(index, "Index value for ML7213 IOH I2S Controller Reference");

/*****************************************************************************
 *	I2S HAL (Hardware Abstruction Layer)
 *****************************************************************************/
static void ioh_i2s_reset(struct ioh_i2s_data *priv)
{
	int channel = priv->ch;

	iowrite32(1 << channel, priv->iobase + I2SSRST_OFFSET);
	iowrite32(0, priv->iobase + I2SSRST_OFFSET);
}

static void ioh_i2s_enable_interrupts(struct ioh_i2s_data *priv,
				      enum dma_data_direction dir)
{
	int channel = priv->ch;
	unsigned int intr_lines;

	if (dir)
		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + channel);

	else
		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + channel);

	/*enable interrupts for specified channel */
	iowrite32(intr_lines, priv->iobase + I2SIMASKCLR_OFFSET);
}

static void ioh_i2s_disable_interrupts(struct ioh_i2s_data *priv,
				       enum dma_data_direction dir)
{
	int channel = priv->ch;
	unsigned int intr_lines;

	/*intr_lines&=I2S_ALL_INTERRUPT_BITS; */
	intr_lines = ioread32(priv->iobase + I2SIMASK_OFFSET);

	/*disable interrupts for specified channel */
	if (dir)
		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + channel);
	else
		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + channel);

	/*Mask the specific interrupt bits */
	iowrite32(intr_lines, priv->iobase + I2SIMASK_OFFSET);
}

/* Run FIFO */
static void ioh_i2s_run_tx_fifo(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
	val |= I2S_FIFO_TX_RUN;

	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
}

/* Clear TX FIFO */
static void ioh_i2s_clear_tx_fifo(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
	val |= I2S_FIFO_TX_FCLR;

	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
}

/* Clear interrupt status */
static void ioh_i2s_clear_tx_sts_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;

	iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
		priv->iobase + I2SISTTX_OFFSET + offset);
}

/* Run FIFO */
static void ioh_i2s_run_rx_fifo(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
	val |= I2S_FIFO_RX_RUN;
	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
}

/* Clear RX FIFO */
static void ioh_i2s_clear_rx_fifo(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
	val |= I2S_FIFO_RX_FCLR;
	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
}

/* Clear interrupt status */
static void ioh_i2s_clear_rx_sts_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;

	iowrite32(I2S_RX_FINT | I2S_RX_AFINT | I2S_RX_EINT | I2S_RX_AEINT,
		priv->iobase + I2SISTRX_OFFSET + offset);
}

/* Clear DMA mask setting */
static void ioh_i2s_tx_clear_dma_mask(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
	val &= ~TX_BIT_DMAMSK; /* Enable Tx DMA Request */

	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
}

/* Clear DMA mask setting */
static void ioh_i2s_rx_clear_dma_mask(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
	val &= ~RX_BIT_DMAMSK; /* Enable Rx DMA Request */
	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
}

/* Clear the mask setting of the corresponding interrupt source bit */
static void ioh_i2s_enable_tx_empty_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
	val &= ~TX_BIT_AEIMSK; /* Enable Almost empty interrupt */
	val &= ~TX_BIT_EIMSK; /* Enable Empty interrupt */

	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
}

/* Clear the mask setting of the corresponding interrupt source bit */
static void ioh_i2s_enable_rx_full_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;
	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);

	val &= ~RX_BIT_AFIMSK; /* Enable Almost empty interrupt */
	val &= ~RX_BIT_FIMSK; /* Enable Empty interrupt */

	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
}

static void ioh_i2s_disable_tx_empty_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
	val |= TX_BIT_AEIMSK; /* Disble Almost empty interrupt */
	val |= TX_BIT_EIMSK; /* Disble Empty interrupt */

	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
}

static void ioh_i2s_disable_rx_full_ir(struct ioh_i2s_data *priv)
{
	int ch = priv->ch;
	int offset = ch * 0x800;
	u32 val;

	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
	val |= RX_BIT_AFIMSK; /* Disble Almost full interrupt */
	val |= RX_BIT_FIMSK; /* Disble full interrupt */

	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
}

/*****************************************************************************
 *	I2S Middle ware
 *****************************************************************************/
static bool filter(struct dma_chan *chan, void *slave)
{
	struct pch_dma_slave *param = slave;

	if ((chan->chan_id == param->chan_id) && (param->dma_dev ==
						  chan->device->dev)) {
		chan->private = param;
		return true;
	} else {
		return false;
	}
}

static	struct dma_chan *ioh_request_dma_channel_common(
			struct ioh_i2s_data *priv,
			char *chan_name,
			enum dma_data_direction dir)
{
	dma_cap_mask_t mask;
	struct dma_chan *chan;
	struct pci_dev *dma_dev;

	dma_cap_zero(mask);
	dma_cap_set(DMA_SLAVE, mask);

	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0, 1)); /* Get DMA's dev
								information */

	if (dir == DMA_FROM_DEVICE) { /* Rx */
		priv->param_rx.width = priv->dma_rx_width;
		priv->param_rx.dma_dev = &dma_dev->dev;
		priv->param_rx.chan_id = priv->ch * 2 + 1; /* ch Rx=1,3,...11 */
		priv->param_rx.rx_reg = (dma_addr_t)(priv->mapbase +\
					priv->ch * 0x800 +\
					I2SDRRXMIRROR_OFFSET);
		chan = dma_request_channel(mask, filter, &priv->param_rx);
		if (chan == NULL) {
			dev_err(priv->dev, "Failed dma_request_channel %s for"
				" I2S %s\n", chan_name, priv->rx_name);
			return NULL;
		}
		priv->chan_rx = chan;

	} else if (dir == DMA_TO_DEVICE) { /* Tx */
		priv->param_tx.width = priv->dma_tx_width;
		priv->param_tx.dma_dev = &dma_dev->dev;
		priv->param_tx.chan_id = priv->ch * 2; /* DMA ch Tx=0,2,...10 */

		priv->param_tx.tx_reg = (dma_addr_t)(priv->mapbase +\
					priv->ch * 0x800 +\
					I2SDRTXMIRROR_OFFSET);

		priv->param_tx.tx_reg_list = NULL;

		chan = dma_request_channel(mask, filter, &priv->param_tx);
		if (chan == NULL) {
			dev_err(priv->dev, "Failed dma_request_channel %s for"
				" I2S %s\n", chan_name, priv->tx_name);
			return NULL;
		}
		priv->chan_tx = chan;
	} else {
		dev_err(priv->dev, "%s:Invalid direction (%d)\n",
			chan_name, dir);
		return NULL;
	}

	return chan;
}

static void ioh_setup_rx_dma(struct ioh_i2s_data *priv)
{
	ioh_request_dma_channel_common(
		priv,
		priv->dma_config->rx_chan,
		DMA_FROM_DEVICE);
}

static void ioh_setup_tx_dma(struct ioh_i2s_data *priv)
{
	ioh_request_dma_channel_common(
		priv,
		priv->dma_config->tx_chan,
		DMA_TO_DEVICE);
}

static void ioh_i2s_ignore_rx_overrun(struct ioh_i2s_data *priv)
{
	priv->ignore_rx_overrun = 1;
}

static void ioh_i2s_write(struct ioh_i2s_data *priv,
		       const void *data,
		       int len)
{
	int rem1;
	int rem2;
	int tx_index;
	struct scatterlist *sg = priv->sg_tx_p;
	int t_num = 0;
	int l;
	int *ptr_fmt;
	int *ptr32;
	short *ptr16;
	char *ptr8;

	if (priv->tx_avail >= INTER_BUFF_SIZE) {
		dev_err(priv->dev, "%s[%d]: internal buffer full\n",
			__func__, priv->ch);
		return;
	}

	dev_dbg(priv->dev, "%s: [ch%d] len=%d data_head=%p data_complete=%p",
		__func__, priv->ch, len, priv->tx_data_head, priv->tx_complete);

	if ((priv->tx_data_head + ((len/priv->dma_tx_unit)*4)) <=
	    priv->tx_tail) {
		tx_index = (int)(priv->tx_data_head - priv->tx_head) /
				(I2S_AEMPTY_THRESH * 4);
		sg = sg + tx_index;
		t_num = len/(I2S_AEMPTY_THRESH * priv->dma_tx_unit);
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);

		ptr_fmt = (int *)priv->tx_data_head;
		switch (priv->dma_tx_unit) {
		case 1:
			ptr8 = (char *)data;
			for (l = 0; l < (len/priv->dma_tx_unit); l++)
				*ptr_fmt++ = (int)*ptr8++;
			break;
		case 2:
			ptr16 = (short *)data;
			for (l = 0; l < (len/priv->dma_tx_unit); l++)
				*ptr_fmt++ = (int)*ptr16++;
			break;
		case 4:
			ptr32 = (int *)data;
			for (l = 0; l < (len/priv->dma_tx_unit); l++)
				*ptr_fmt++ = *ptr32++;
			break;
		}
		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
		priv->tx_data_head += (len/priv->dma_tx_unit)*4;
	} else {
		rem1 = (priv->tx_tail - priv->tx_data_head)/4;
		rem2 = (len/priv->dma_tx_unit) - rem1;
		tx_index = (int)(priv->tx_data_head-priv->tx_head) /
				(I2S_AEMPTY_THRESH * 4);
		sg = sg + tx_index;
		t_num = rem1/I2S_AEMPTY_THRESH;
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);
		ptr_fmt = (int *)priv->tx_data_head;
		switch (priv->dma_tx_unit) {
		case 1:
			ptr8 = (char *)data;
			for (l = 0; l < rem1; l++)
				*ptr_fmt++ = (int)*ptr8++;
			break;
		case 2:
			ptr16 = (short *)data;
			for (l = 0; l < rem1; l++)
				*ptr_fmt++ = (int)*ptr16++;
			break;
		case 4:
			ptr32 = (int *)data;
			for (l = 0; l < rem1; l++)
				*ptr_fmt++ = *ptr32++;
			break;
		}

		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
		priv->tx_data_head = priv->tx_head;
		sg = priv->sg_tx_p;
		t_num = rem2/I2S_AEMPTY_THRESH;
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);

		ptr_fmt = (int *)priv->tx_data_head;

		switch (priv->dma_tx_unit) {
		case 1:
			ptr8 = (char *)(data+rem1*priv->dma_tx_unit);
			for (l = 0; l < rem2; l++)
				*ptr_fmt++ = (int)*ptr8++;
			break;
		case 2:
			ptr16 = (short *)(data+rem1*priv->dma_tx_unit);
			for (l = 0; l < rem2; l++)
				*ptr_fmt++ = (int)*ptr16++;
			break;
		case 4:
			ptr32 = (int *)(data+rem1*priv->dma_tx_unit);
			for (l = 0; l < rem2; l++)
				*ptr_fmt++ = *ptr32++;
			break;
		}

		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
		priv->tx_data_head += rem2*4;
	}

	if (priv->tx_data_head >= priv->tx_tail)
		priv->tx_data_head = priv->tx_head;

	dev_dbg(priv->dev, "-->data_head=%p\n", priv->tx_data_head);

	priv->tx_avail += (len/priv->dma_tx_unit)*4;
}

static void ioh_i2s_stop_i2s_regs(struct ioh_i2s_data *priv,
			       unsigned long bitrate,
			       struct ioh_i2s_config_reg *config,
			       enum ioh_direction dir,
			       unsigned int flag)
{
	int ch = priv->ch;

	if (dir) {
		/* Interrupt stop */
		ioh_i2s_disable_rx_full_ir(priv);

		/* FIFO setting */
		ioh_i2s_clear_rx_fifo(priv);
		ioh_i2s_clear_rx_sts_ir(priv);
	} else {
		/* Interrupt stop */
		ioh_i2s_disable_tx_empty_ir(priv);

		/* FIFO setting */
		ioh_i2s_clear_tx_fifo(priv);
		ioh_i2s_clear_tx_sts_ir(priv);
	}

	/* Common register */
	if (!flag) {
		iowrite32(config->cmn.i2sclkcnt,
			  priv->iobase + I2SCLKCNT0_OFFSET + 0x10*ch);
	}
}

static void ioh_i2s_configure_i2s_regs(struct ioh_i2s_data *priv,
				    unsigned long bitrate,
				    struct ioh_i2s_config_reg *config,
				    enum ioh_direction dir,
				    unsigned int unit)
{
	int ch = priv->ch;
	int offset = ch * 0x800;

	/* Common register */
	iowrite32(config->cmn.i2sclkcnt,
		  priv->iobase + I2SCLKCNT0_OFFSET + 0x10*ch);

	if (dir) {
		priv->dma_rx_unit = unit;
		/* Rx register */
		iowrite32(config->rx.i2scntrx,
			  priv->iobase + I2SCNTRX_OFFSET + offset);
		iowrite32(config->rx.i2sfifocrx,
			  priv->iobase + I2SFIFOCRX_OFFSET + offset);
		iowrite32(config->rx.i2safrx,
			  priv->iobase + I2SAFRX_OFFSET + offset);
		iowrite32(config->rx.i2saerx,
			  priv->iobase + I2SAERX_OFFSET + offset);
		iowrite32(config->rx.i2smskrx,
			  priv->iobase + I2SMSKRX_OFFSET + offset);
		iowrite32(config->rx.i2sistrx,
			  priv->iobase + I2SISTRX_OFFSET + offset);

		/* FIFO setting */
		ioh_i2s_clear_rx_fifo(priv);
		ioh_i2s_run_rx_fifo(priv);

		/* Interrupt setting */
		ioh_i2s_clear_rx_sts_ir(priv);
		ioh_i2s_enable_rx_full_ir(priv);

	} else {
		priv->dma_tx_unit = unit;
		/* Tx register */
		iowrite32(config->tx.i2scnttx,
			  priv->iobase + I2SCNTTX_OFFSET + offset);
		iowrite32(config->tx.i2sfifoctx,
			  priv->iobase + I2SFIFOCTX_OFFSET + offset);
		iowrite32(config->tx.i2saftx,
			  priv->iobase + I2SAFTX_OFFSET + offset);
		iowrite32(config->tx.i2saetx,
			  priv->iobase + I2SAETX_OFFSET + offset);
		iowrite32(config->tx.i2smsktx,
			  priv->iobase + I2SMSKTX_OFFSET + offset);
		iowrite32(config->tx.i2sisttx,
			  priv->iobase + I2SISTTX_OFFSET + offset);

		/* FIFO setting */
		ioh_i2s_clear_tx_fifo(priv);
		ioh_i2s_run_tx_fifo(priv);

		/* Interrupt setting */
		ioh_i2s_clear_tx_sts_ir(priv);
		ioh_i2s_enable_tx_empty_ir(priv);
	}
}

static void i2s_rx_tasklet(unsigned long data)
{
	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
	int num = 0;

	if (priv->rxexe_flag) {
		if (priv->rx_done) {
			switch (priv->dma_rx_unit) {
			case 1:
				num = priv->rx_avail/4;
				break;
			case 2:
				num = priv->rx_avail/2;
				break;
			case 4:
				num = priv->rx_avail;
				break;
			}
			priv->rx_done(priv->rx_callback_data,
				      IOH_EOK, num, num);
		}
	}
}

static void i2s_tx_tasklet(unsigned long data)
{
	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
	int num = 0;
	int avail = 0;

	if (priv->txexe_flag) {
		if (priv->tx_done) {
			switch (priv->dma_tx_unit) {
			case 1:
				num = (INTER_BUFF_SIZE - priv->tx_avail)/4;
				avail = priv->tx_avail/4;
				break;
			case 2:
				num = (INTER_BUFF_SIZE - priv->tx_avail)/2;
				avail = priv->tx_avail/2;
				break;
			case 4:
				num = (INTER_BUFF_SIZE - priv->tx_avail);
				avail = priv->tx_avail;
				break;
			}
			priv->tx_done(priv->tx_callback_data,
				      IOH_EOK, num, avail);
		}
	}
}

static void ioh_i2s_release(struct ioh_i2s_data *priv, enum ioh_direction dir)
{
	if (!priv) {
		dev_err(priv->dev, "%s: i2s is NULL\n", __func__);
		return;
	}

	if (dir) {
		dma_sync_sg_for_cpu(priv->dev, priv->sg_rx_p, priv->rx_nent,
				    DMA_FROM_DEVICE);

		ioh_i2s_disable_interrupts(priv, IOH_CAPTURE);
		ioh_i2s_disable_rx_full_ir(priv);
		if (priv->chan_rx) {
			priv->chan_rx->device->device_control(priv->chan_rx,
							     DMA_TERMINATE_ALL,
							     0);
			dma_release_channel(priv->chan_rx);
			priv->chan_rx = NULL;
		}

		kfree(priv->sg_rx_p);
		if (priv->rxbuf_virt)
			dma_free_coherent(priv->dev, INTER_BUFF_SIZE,
					  priv->rxbuf_virt,
					  priv->rx_buf_dma);

		priv->rxbuf_virt = NULL;
		priv->rx_buf_dma = 0;
		atomic_dec(&priv->rx_busy);

		tasklet_disable(&priv->rx_tasklet);
		tasklet_kill(&priv->rx_tasklet);

	} else {
		dma_sync_sg_for_cpu(priv->dev, priv->sg_tx_p, priv->tx_nent,
				    DMA_TO_DEVICE);

		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
		ioh_i2s_disable_tx_empty_ir(priv);
		if (priv->chan_tx) {
			priv->chan_tx->device->device_control(priv->chan_tx,
							     DMA_TERMINATE_ALL,
							     0);
			dma_release_channel(priv->chan_tx);
			priv->chan_tx = NULL;
		}

		kfree(priv->sg_tx_p);
		if (priv->txbuf_virt)
			dma_free_coherent(priv->dev, INTER_BUFF_SIZE,
					  priv->txbuf_virt,
					  priv->tx_buf_dma);

		priv->txbuf_virt = NULL;
		priv->tx_buf_dma = 0;
		atomic_dec(&priv->tx_busy);

		tasklet_disable(&priv->tx_tasklet);
		tasklet_kill(&priv->tx_tasklet);
	}
}

static struct ioh_i2s_data *ioh_i2s_open(int ch, enum ioh_direction dir,
				     const char *name, void *cbd,
				     void (*cb)(void *cbd, int status,
						int num, int avail))
{
	struct ioh_i2s_data *obj = NULL;
	struct scatterlist *sg;
	int rx_size;
	int rx_num;
	int tx_size;
	int tx_num;
	int i;

	if (ch >= MAX_I2S_IF) {
		dev_err(obj->dev,
			"Tried to open i2s with number %d which is more then"
			" the available number\n", ch);
		return 0;
	}

	obj = kzalloc(sizeof(*obj), GFP_KERNEL);

	obj->ignore_rx_overrun = 0;

	obj->dma_tx_width = PCH_DMA_WIDTH_4_BYTES;
	obj->dma_rx_width = PCH_DMA_WIDTH_4_BYTES;

	obj->ch = ch;
	obj->dev = obj->dev;

	atomic_set(&obj->rx_busy, 0);
	atomic_set(&obj->tx_busy, 0);
	strcpy(obj->rx_name, "FREE");
	strcpy(obj->tx_name, "FREE");

	if (dir) {
		/* Rx configuration */
		if (atomic_read(&obj->rx_busy)) {
			dev_err(obj->dev, "rx i2s%d have already opened\n", ch);
			atomic_dec(&obj->rx_busy);
			return 0;
		}
		atomic_inc(&obj->rx_busy);

		strcpy(obj->rx_name, name);
		ioh_setup_rx_dma(obj);
		if (!obj->chan_rx) {
			dev_err(obj->dev, "%s:ioh_setup_rx_dma failed\n",
				__func__);
			return NULL;
		}

		obj->rxbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
						&obj->rx_buf_dma, GFP_KERNEL);
		if (!obj->rxbuf_virt) {
			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
			return NULL;
		}

		rx_size = I2S_AFULL_THRESH * 4;
		/* The number of scatter list (Franction area is not used) */
		rx_num = INTER_BUFF_SIZE / rx_size;

		dev_dbg(obj->dev, "%s: rx: scatter_num=%d scatter_size=%d\n",
			__func__, rx_num, rx_size);

		obj->sg_rx_p =\
		       kzalloc(sizeof(struct scatterlist) *rx_num, GFP_ATOMIC);

		sg = obj->sg_rx_p;
		sg_init_table(sg, rx_num); /* Initialize SG table */

		for (i = 0; i < rx_num; i++, sg++) {
			sg_set_page(sg, virt_to_page(obj->rxbuf_virt), rx_size,
				    rx_size * i);
			sg_dma_len(sg) = rx_size / 4;
			sg_dma_address(sg) = obj->rx_buf_dma + sg->offset;
		}

		obj->rx_head = (unsigned char *)obj->rxbuf_virt;
		obj->rx_tail = (unsigned char *)obj->rxbuf_virt +
			       rx_num * rx_size;
		obj->rx_data_head = (unsigned char *)obj->rxbuf_virt;
		obj->rx_complete = (unsigned char *)obj->rxbuf_virt;
		obj->rx_avail = 0;

		obj->rx_nent = rx_num;
		dma_sync_sg_for_device(obj->dev, obj->sg_rx_p, obj->rx_nent,
				       DMA_FROM_DEVICE);

		tasklet_init(&obj->rx_tasklet, i2s_rx_tasklet,
			     (unsigned long)obj);
	} else {
		/* Tx configuration */
		if (atomic_read(&obj->tx_busy)) {
			dev_err(obj->dev, "tx i2s%d have already opened\n", ch);
			atomic_dec(&obj->tx_busy);
			return 0;
		}
		atomic_inc(&obj->tx_busy);

		strcpy(obj->tx_name, name);
		ioh_setup_tx_dma(obj);
		if (!obj->chan_tx) {
			dev_err(obj->dev, "%s:ioh_setup_tx_dma failed\n",
				__func__);
			return NULL;
		}

		tx_size = I2S_AEMPTY_THRESH * 4;
		if (INTER_BUFF_SIZE % tx_size)
			/* tx_num = The number of scatter list */
			tx_num = INTER_BUFF_SIZE / tx_size + 1;
		else
			tx_num = INTER_BUFF_SIZE / tx_size;

		obj->txbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
						&obj->tx_buf_dma, GFP_KERNEL);

		if (!obj->txbuf_virt) {
			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
			return NULL;
		}

		obj->tx_head = (unsigned char *)obj->txbuf_virt;
		obj->tx_tail = (unsigned char *)obj->txbuf_virt +
			       INTER_BUFF_SIZE;
		obj->tx_data_head = (unsigned char *)obj->txbuf_virt;
		obj->tx_complete = (unsigned char *)obj->txbuf_virt;
		obj->tx_avail = 0;

		dev_dbg(obj->dev, "%s: tx: scatter_num=%d scatter_size=%d\n",
			__func__, tx_num, tx_size);

		obj->sg_tx_p =\
		       kzalloc(sizeof(struct scatterlist) *tx_num, GFP_ATOMIC);

		sg_init_table(obj->sg_tx_p, tx_num); /* Initialize SG table */
		sg = obj->sg_tx_p;

		for (i = 0; i < tx_num; i++, sg++) {
			if (i == (tx_num - 1)) {
				if (INTER_BUFF_SIZE % tx_size) {
					sg_set_page(sg,
						  virt_to_page(obj->txbuf_virt),
						  INTER_BUFF_SIZE % tx_size,
						  tx_size * i);
					sg_dma_len(sg) =
						  (INTER_BUFF_SIZE % tx_size)
						  / 4;
				} else {
					sg_set_page(sg,
						  virt_to_page(obj->txbuf_virt),
						  tx_size, tx_size * i);
					sg_dma_len(sg) = tx_size\
							/ 4;
				}
			} else {
				sg_set_page(sg, virt_to_page(obj->txbuf_virt),
					    tx_size, tx_size * i);
				sg_dma_len(sg) = tx_size / 4;
			}
			sg_dma_address(sg) = obj->tx_buf_dma + sg->offset;
		}
		obj->tx_nent = tx_num;
		dma_sync_sg_for_device(obj->dev, obj->sg_tx_p, obj->tx_nent,
				       DMA_TO_DEVICE);

		tasklet_init(&obj->tx_tasklet, i2s_tx_tasklet,
			     (unsigned long)obj);
	}

	return obj;
}

static void ioh_i2s_read(struct ioh_i2s_data *priv,
		      void *data,
		      int len)
{
	unsigned int rem1 = 0, rem2 = 0;
	struct scatterlist *sg = priv->sg_rx_p;
	int rx_index;
	int t_num = 0;
	int *ptr_fmt;
	int *ptr32;
	short *ptr16;
	char *ptr8;
	int l;

	switch (priv->dma_rx_unit) {
	case 1:
		t_num = priv->rx_avail/4;
		break;
	case 2:
		t_num = priv->rx_avail/2;
		break;
	case 4:
		t_num = priv->rx_avail;
		break;
	}

	if (t_num < len) {
		dev_err(priv->dev, "%s[%d]: internal buffer empty\n",
			__func__, priv->ch);
		return;
	}

	if ((priv->rx_complete + ((len/priv->dma_rx_unit)*4)) <=
	    priv->rx_tail) {
		rx_index = (int)(priv->rx_complete - priv->rx_head) /
				(I2S_AFULL_THRESH * 4);
		sg = sg + rx_index;
		t_num = len/(I2S_AFULL_THRESH * priv->dma_rx_unit);
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);

		ptr_fmt = (int *)priv->rx_complete;
		switch (priv->dma_rx_unit) {
		case 1:
			ptr8 = (char *)data;
			for (l = 0; l < (len/priv->dma_rx_unit); l++)
				*ptr8++ = (char)*ptr_fmt++;
			break;
		case 2:
			ptr16 = (short *)data;
			for (l = 0; l < (len/priv->dma_rx_unit); l++)
				*ptr16++ = (short)*ptr_fmt++;
			break;
		case 4:
			ptr32 = (int *)data;
			for (l = 0; l < (len/priv->dma_rx_unit); l++)
				*ptr32++ = *ptr_fmt++;
			break;
		}
		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
		priv->rx_complete += (len/priv->dma_rx_unit)*4;
	} else {
		rem1 = (priv->rx_tail - priv->rx_complete)/4;
		rem2 = (len/priv->dma_rx_unit) - rem1;
		rx_index = (int)(priv->rx_complete-priv->rx_head) /
				(I2S_AFULL_THRESH * 4);
		sg = sg + rx_index;
		t_num = rem1/I2S_AFULL_THRESH;
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);
		ptr_fmt = (int *)priv->rx_complete;
		switch (priv->dma_rx_unit) {
		case 1:
			ptr8 = (char *)data;
			for (l = 0; l < rem1; l++)
				*ptr8++ = (char)*ptr_fmt++;
			break;
		case 2:
			ptr16 = (short *)data;
			for (l = 0; l < rem1; l++)
				*ptr16++ = (short)*ptr_fmt++;
			break;
		case 4:
			ptr32 = (int *)data;
			for (l = 0; l < rem1; l++)
				*ptr32++ = *ptr_fmt++;
			break;
		}
		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
		priv->rx_complete = priv->rx_head;
		sg = priv->sg_rx_p;
		t_num = rem2/I2S_AFULL_THRESH;
		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);
		ptr_fmt = (int *)priv->rx_complete;
		switch (priv->dma_rx_unit) {
		case 1:
			ptr8 = (char *)(data+rem1*priv->dma_rx_unit);
			for (l = 0; l < rem2; l++)
				*ptr8++ = (char)*ptr_fmt++;
			break;
		case 2:
			ptr16 = (short *)(data+rem1*priv->dma_rx_unit);
			for (l = 0; l < rem2; l++)
				*ptr16++ = (short)*ptr_fmt++;
			break;
		case 4:
			ptr32 = (int *)(data+rem1*priv->dma_rx_unit);
			for (l = 0; l < rem2; l++)
				*ptr32++ = *ptr_fmt++;
			break;
		}
		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
		priv->rx_complete += rem2*4;
	}

	if (priv->rx_complete >= priv->rx_tail)
		priv->rx_complete = priv->rx_head;

	priv->rx_avail -= (len/priv->dma_rx_unit)*4;
}

static void i2s_dma_rx_complete(void *arg)
{
	struct ioh_i2s_data *priv = arg;
	struct scatterlist *sg = priv->sg_rx_cur;
	int num = priv->rx_num;
	int i;

	async_tx_ack(priv->desc_rx);

	for (i = 0; i < num; i++, sg++) {
		priv->rx_data_head += sg_dma_len(sg) * 4;
		priv->rx_avail += sg_dma_len(sg) * 4;
	}

	if (priv->rx_data_head >= priv->rx_tail)
		priv->rx_data_head = priv->rx_head;

	ioh_i2s_clear_rx_sts_ir(priv);
	ioh_i2s_enable_rx_full_ir(priv);
}

static void i2s_dma_tx_complete(void *arg)
{
	struct ioh_i2s_data *priv = arg;
	struct scatterlist *sg = priv->sg_tx_cur;
	int num = priv->tx_num;
	int i;

	async_tx_ack(priv->desc_tx);

	for (i = 0; i < num; i++, sg++) {
		priv->tx_complete += sg_dma_len(sg) * 4;
		priv->tx_avail -= sg_dma_len(sg) * 4;
	}

	if (priv->tx_complete >= priv->tx_tail)
		priv->tx_complete = priv->tx_head;
	ioh_i2s_clear_tx_sts_ir(priv);
	ioh_i2s_enable_tx_empty_ir(priv);
}

/*****************************************************************************
 *	Interrupt control
 *****************************************************************************/
static void i2s_tx_almost_empty_ir(struct ioh_i2s_data *priv)
{
	struct dma_async_tx_descriptor *desc;
	int num;
	int tx_comp_index;
	struct scatterlist *sg = priv->sg_tx_p;

	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p\n", __func__,
		priv->tx_data_head, priv->tx_complete);

	num = ((int)priv->tx_avail) / (I2S_AEMPTY_THRESH * 4);

	tx_comp_index = (((int)(priv->tx_complete - priv->tx_head))) /\
			(I2S_AEMPTY_THRESH * 4);

	if ((tx_comp_index + num) >= priv->tx_nent)
		num = priv->tx_nent - tx_comp_index;

	if (num > I2S_DMA_SG_NUM)
		num = I2S_DMA_SG_NUM;

	if (!num) {
		dev_err(priv->dev, "%s:Internal buffer empty\n",
			__func__);
		tasklet_schedule(&priv->tx_tasklet);
		return; /* No data to transmit */
	}

	sg = sg + tx_comp_index; /* Point head of sg must be sent */
	priv->sg_tx_cur = sg; /* Save tx condition */
	priv->tx_num = num; /* Save tx condition */

	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
					sg, num, DMA_TO_DEVICE,
					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);

	if (!desc) {
		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
			__func__);
		return;
	}

	/* To prevent this function from calling again before DMA completion */
	ioh_i2s_disable_tx_empty_ir(priv);

	priv->desc_tx = desc;
	desc->callback = i2s_dma_tx_complete;
	desc->callback_param = priv;

	atomic_inc(&priv->pending_tx);
	desc->tx_submit(desc);

	tasklet_schedule(&priv->tx_tasklet);
}

void i2s_tx_empty_ir(struct ioh_i2s_data *priv, int ch)
{
	dev_warn(priv->dev, "%s:I2S under flow occurs(ch=%d)\n", __func__, ch);
}

void i2s_rx_full_ir(struct ioh_i2s_data *priv, int ch)
{
	dev_warn(priv->dev, "%s:I2S overrun occurs(ch=%d)\n", __func__, ch);
}

static inline void ioh_i2s_interrupt_sub_tx(struct ioh_i2s_data *priv)
{
	unsigned int status;
	int channel = priv->ch;
	int offset = channel * 0x800;

	status = ioread32(priv->iobase + I2SISTTX_OFFSET + offset);
	if (status & I2S_TX_EINT)
		i2s_tx_empty_ir(priv, channel);
	if (status & I2S_TX_AEINT)
		i2s_tx_almost_empty_ir(priv);

	/*Clear the interrupt status */
	iowrite32(status, priv->iobase + I2SISTTX_OFFSET + offset);
}

static void i2s_rx_almost_full_ir(struct ioh_i2s_data *priv)
{
	struct dma_async_tx_descriptor *desc;
	struct scatterlist *sg;
	int rx_data_index;
	int num;

	num = (int)(INTER_BUFF_SIZE - priv->rx_avail) / (I2S_AFULL_THRESH * 4);
	if (num < 1) {
		dev_err(priv->dev, "%s:Internal buffer full\n",
			__func__);
		tasklet_schedule(&priv->rx_tasklet);
		return;
	}

	sg = priv->sg_rx_p;
	rx_data_index = ((int)(priv->rx_data_head - priv->rx_head)) /\
			(I2S_AFULL_THRESH * 4);

	if ((rx_data_index + num) >= priv->rx_nent)
		num = priv->rx_nent - rx_data_index;

	if (num > I2S_DMA_SG_NUM)
		num = I2S_DMA_SG_NUM;

	sg += rx_data_index;

	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
			sg, num, DMA_FROM_DEVICE,
			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
	if (!desc) {
		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
			__func__);
		return;
	}

	priv->sg_rx_cur = sg; /* Save rx condition */
	ioh_i2s_disable_rx_full_ir(priv);
	priv->rx_num = num;

	priv->desc_rx = desc;
	desc->callback = i2s_dma_rx_complete;
	desc->callback_param = priv;
	desc->tx_submit(desc);

	tasklet_schedule(&priv->rx_tasklet);
}

static inline void ioh_i2s_interrupt_sub_rx(struct ioh_i2s_data *priv)
{
	unsigned int status;
	int channel = priv->ch;
	int offset = channel * 0x800;

	status = ioread32(priv->iobase + I2SISTRX_OFFSET + offset);
	if (status & I2S_RX_FINT)
		i2s_rx_full_ir(priv, channel);
	if (status & I2S_RX_AFINT)
		i2s_rx_almost_full_ir(priv);

	/*Clear the interrupt status */
	iowrite32(status, priv->iobase + I2SISTRX_OFFSET + offset);
}

void ioh_i2s_event(struct ioh_i2s_data *priv, u32 idisp)
{
	unsigned long flags;

	spin_lock_irqsave(&priv->tx_lock, flags);

	if (idisp & BIT(priv->ch + 16)) {
		dev_dbg(priv->dev, "Rx%d interrupt occures\n", priv->ch);
		ioh_i2s_interrupt_sub_rx(priv);
	}

	if (idisp & BIT(priv->ch)) {
		dev_dbg(priv->dev, "Tx%d interrupt occures\n", priv->ch);
		ioh_i2s_interrupt_sub_tx(priv);
	}

	spin_unlock_irqrestore(&priv->tx_lock, flags);
	return;
}

static irqreturn_t ioh_i2s_irq(int irq, void *data)
{
	struct pci_dev *pdev = (struct pci_dev *)data;
	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
	int i;
	u32 idisp;
	struct ioh_i2s_data *priv;

	priv = &drvdata->devs[0];
	idisp = ioread32(priv->iobase + I2SIDISP_OFFSET);
	for (i = 0; i < MAX_I2S_IF; i++)
		ioh_i2s_event(&drvdata->devs[i], idisp);

	return IRQ_HANDLED;
}

/*****************************************************************************
 *	Sound Card
 *****************************************************************************/
static void i2s_read_period(struct snd_pcm_substream *substream)
{
	struct snd_ml7213i2s_pcm *dpcm;
	struct cbdata *cbd;
	int period;
	void *read_ptr;
	int read_size;

	dpcm = substream->runtime->private_data;
	cbd = &dpcm->cbd;

	if (!cbd->priv)
		return;

	period = substream->runtime->period_size;

	read_ptr = substream->runtime->dma_area
	  +(snd_pcm_lib_period_bytes(substream) * dpcm->irq_pos);
	read_size = period * (substream->runtime->sample_bits/8) *
		    (substream->runtime->channels);

	ioh_i2s_read(cbd->priv,
			 read_ptr,
			 read_size);

	dpcm->irq_pos = (dpcm->irq_pos + 1) % substream->runtime->periods;
}

static void read_done(void *callback_data, int status, int num, int avail)
{
	struct snd_pcm_substream *substream =
		(struct snd_pcm_substream *)callback_data;
	struct snd_ml7213i2s_pcm *dpcm;
	struct cbdata *cbd;
	dpcm = substream->runtime->private_data;

	if (num < snd_card_ml7213i2s_capture[dpcm->ch].period_bytes_max)
		return;

	cbd = &dpcm->cbd;
	switch (status) {
	case IOH_EOK:
		if (!cbd->stop) {
			i2s_read_period(substream);
			dpcm->buf_pos = (dpcm->buf_pos + 1) %
				substream->runtime->periods;
			snd_pcm_period_elapsed(dpcm->substream);
		}

		cbd->cnt++;
		break;
	case IOH_EDONE:
		pr_debug("Done stopping channel %d\n", cbd->stop);
		cbd->stop = 2;
		break;

	case IOH_EOVERRUN:
		if (ignore_overrun)
			pr_debug("overrun ignore\n");
		else {
			pr_err("RX overrun\n");
			cbd->stop = 2;
		}
		break;

	case IOH_EFRAMESYNC:
		pr_err("Frame sync error\n");
		cbd->stop = 2;
		break;
	}
	if (cbd->stop)
		pr_debug("stopping... %d\n", cbd->stop);
}

static int i2s_config_rate_reg(struct ioh_i2s_config_reg *config,
				    unsigned int rate,
				    struct snd_ml7213i2s_pcm *dpcm)
{
	unsigned int i2s_mclk;
	unsigned int ret;

	i2s_mclk = i2s_config_table[dpcm->ch+STEREO_OFFSET].i2s_mclk;
	if ((i2s_mclk/64) == rate)
		ret = ioh_mclkfs_64fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/128) == rate)
		ret = ioh_mclkfs_128fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/192) == rate)
		ret = ioh_mclkfs_192fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/256) == rate)
		ret = ioh_mclkfs_256fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/384) == rate)
		ret = ioh_mclkfs_384fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/512) == rate)
		ret = ioh_mclkfs_512fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/768) == rate)
		ret = ioh_mclkfs_768fs << I2SCLKCNT_MCLKFS_OFFSET;
	else if ((i2s_mclk/1024) == rate)
		ret = ioh_mclkfs_1024fs << I2SCLKCNT_MCLKFS_OFFSET;
	else
		ret = 0;

	return ret;
}

static int i2s_rx_configure_reg(struct ioh_i2s_config_reg *config,
				    unsigned int rate,
				    struct snd_ml7213i2s_pcm *dpcm)
{
	int ret = 0;

	memset(config, 0, sizeof(*config));

	/* Set ML7213 IOH register default value */
	config->cmn.i2simask = 0x003f003f;

	config->rx.i2saerx = 0x1F;
	config->rx.i2smskrx = 0x1F;
	config->rx.i2sistrx = 0xC;

	/* Configuration */
	if (dpcm->channels == 1) {
		config->rx.i2scntrx =
			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2scntrx |
			dpcm->format |
			(ioh_tel_tel_fmt << I2SCNTRX_RX_TEL_OFFSET);
		config->cmn.i2sclkcnt = dpcm->bclkfs |
			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2sclkcnt;
	} else {
		config->rx.i2scntrx =
			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2scntrx |
			dpcm->format |
			(ioh_tel_i2s_fmt << I2SCNTRX_RX_TEL_OFFSET);
		config->cmn.i2sclkcnt = dpcm->bclkfs |
			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2sclkcnt;
	}

	config->cmn.i2sclkcnt |= i2s_config_rate_reg(config, rate, dpcm);
	config->rx.i2safrx = I2S_AFULL_THRESH / 2; /* Almost full threshold */
	if (((config->cmn.i2sclkcnt & 0x3000) == 0x3000) &&
	    ((config->cmn.i2sclkcnt & 0x7) == 0x2)) {
		pr_err("%s: Failed not support setting\n", __func__);
		ret = -1;
	}
	return ret;
}

static int setup_i2s_read(struct snd_pcm_substream *substream, int ch)
{
	struct snd_ml7213i2s_pcm *dpcm;
	struct ioh_i2s_config_reg config;
	unsigned int master;
	int ret = 0;
	unsigned int byte;

	master = (i2s_config_table[ch].i2sclkcnt >> I2SCLKCNT_MSSEL_OFFSET) & 1;
	dpcm = substream->runtime->private_data;

	dpcm->cbd.priv = ioh_i2s_open(ch, IOH_CAPTURE, "radio-i2s-in",
					 substream,
					 read_done);
	dpcm->setup_flag = 1;

	if (!dpcm->cbd.priv) {
		pr_err("%s: Cannot open the device\n", __func__);
		return -1;
	}

	if (ignore_overrun)
		ioh_i2s_ignore_rx_overrun(dpcm->cbd.priv);

	ret = i2s_rx_configure_reg(&config, dpcm->rate, dpcm);
	if (master)
		dpcm->master_mode |= 1 << (ch + I2S_READ_MASTER_BIT);
	else
		dpcm->master_mode |= 0 << (ch + I2S_READ_MASTER_BIT);

	switch (dpcm->format) {
	case (ioh_dabit_8bit << I2SCNT_DABIT_OFFSET):
		byte = 1;
		break;
	case (ioh_dabit_16bit << I2SCNT_DABIT_OFFSET):
		byte = 2;
		break;
	case (ioh_dabit_24bit << I2SCNT_DABIT_OFFSET):
		byte = 4;
		break;
	default:
		pr_err("%s: format error\n", __func__);
		return -1;
		break;
	}

	ioh_i2s_configure_i2s_regs(dpcm->cbd.priv, 0, &config, IOH_CAPTURE,
				   byte);
	return ret;
}

static void i2s_write_period(struct snd_pcm_substream *substream)
{
	struct snd_ml7213i2s_pcm *dpcm;
	struct cbdata *cbd;
	int period;
	void *write_ptr;
	int write_size;

	dpcm = substream->runtime->private_data;
	cbd = &dpcm->cbd;

	if (!cbd->priv)
		return;

	period = substream->runtime->period_size;
	write_ptr = substream->runtime->dma_area
	  +(snd_pcm_lib_period_bytes(substream) * dpcm->irq_pos);
	write_size = period * (substream->runtime->sample_bits/8) *
		     (substream->runtime->channels);

	ioh_i2s_write(cbd->priv,
			 write_ptr,
			 write_size);

	dpcm->irq_pos = (dpcm->irq_pos + 1) % substream->runtime->periods;
}

static void write_done(void *callback_data, int status, int num, int avail)
{
	struct snd_pcm_substream *substream =
		(struct snd_pcm_substream *)callback_data;
	struct snd_ml7213i2s_pcm *dpcm;
	struct cbdata *cbd;

	dpcm = substream->runtime->private_data;

	if (num < snd_card_ml7213i2s_playback[dpcm->ch].period_bytes_max)
		return;
	if (avail >= snd_card_ml7213i2s_playback[dpcm->ch].period_bytes_max*2)
		return;

	if (!substream) {
		pr_debug("%s:!substream NULL\n", __func__);
		return;
	}
	if (!substream->runtime) {
		pr_debug("%s:!substream->runtime NULL\n", __func__);
		return;
	}
	if (!substream->runtime->private_data) {
		pr_debug("%s:!substream->runtime->private_data NULL\n",
			__func__);
		return;
	}
	cbd = &dpcm->cbd;

	switch (status) {
	case IOH_EOK:
		if (!cbd->stop) {
			i2s_write_period(substream);
			dpcm->buf_pos = (dpcm->buf_pos + 1) %
				substream->runtime->periods;
			snd_pcm_period_elapsed(dpcm->substream);
		}
		cbd->cnt++;
		break;
	case IOH_EDONE:
		pr_debug("Done stopping channel %d\n", cbd->stop);
		cbd->stop = 2;
		break;
	default:
		pr_debug("%s:default(%d)\n", __func__, status);
	break;
	}
}

static int i2s_tx_configure_reg(struct ioh_i2s_config_reg *config,
				    unsigned int rate,
				    struct snd_ml7213i2s_pcm *dpcm)
{
	int ret = 0;

	memset(config, 0, sizeof(*config));

	/* Set ML7213 IOH register default value */
	config->cmn.i2simask = 0x003f003f;

	config->tx.i2saftx = 0x0;
	config->tx.i2smsktx = 0x1F;
	config->tx.i2sisttx = 0xC;

	/* Configuration */
	if (dpcm->channels == 1) {
		config->tx.i2scnttx =
			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2scnttx |
			dpcm->format |
			(ioh_tel_tel_fmt << I2SCNTTX_TX_TEL_OFFSET);
		config->cmn.i2sclkcnt = dpcm->bclkfs |
			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2sclkcnt;
	} else {
		config->tx.i2scnttx =
			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2scnttx |
			dpcm->format |
			(ioh_tel_i2s_fmt << I2SCNTTX_TX_TEL_OFFSET);
		config->cmn.i2sclkcnt = dpcm->bclkfs |
			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2sclkcnt;
	}

	config->cmn.i2sclkcnt |= i2s_config_rate_reg(config, rate, dpcm);
	config->tx.i2saetx = I2S_AEMPTY_THRESH / 2; /* Almost empty threshold */
	if (((config->cmn.i2sclkcnt & 0x3000) == 0x3000) &&
	    ((config->cmn.i2sclkcnt & 0x7) == 0x2)) {
		pr_err("%s: Failed not support setting\n", __func__);
		ret = -1;
	}
	return ret;
}

static int setup_i2s_write(struct snd_pcm_substream *substream, int ch)
{
	struct snd_ml7213i2s_pcm *dpcm;
	struct ioh_i2s_config_reg config;
	unsigned int master;
	int ret = 0;
	unsigned int byte;

	master = (i2s_config_table[ch].i2sclkcnt >> I2SCLKCNT_MSSEL_OFFSET) & 1;
	dpcm = substream->runtime->private_data;

	dpcm->cbd.priv = ioh_i2s_open(ch, IOH_PLAYBACK, "radio-i2s-out",
					 substream,
					 write_done);
	dpcm->setup_flag = 1;

	if (!dpcm->cbd.priv) {
		pr_err("%s: Cannot open the device\n", __func__);
		return -1;
	}

	if (ignore_overrun)
		ioh_i2s_ignore_rx_overrun(dpcm->cbd.priv);

	ret = i2s_tx_configure_reg(&config, dpcm->rate, dpcm);
	if (master)
		dpcm->master_mode |= 1 << (ch + I2S_WRITE_MASTER_BIT);
	else
		dpcm->master_mode |= 0 << (ch + I2S_WRITE_MASTER_BIT);

	switch (dpcm->format) {
	case (ioh_dabit_8bit << I2SCNT_DABIT_OFFSET):
		byte = 1;
		break;
	case (ioh_dabit_16bit << I2SCNT_DABIT_OFFSET):
		byte = 2;
		break;
	case (ioh_dabit_24bit << I2SCNT_DABIT_OFFSET):
		byte = 4;
		break;
	default:
		pr_err("%s: format error\n", __func__);
		return -1;
		break;
	}

	ioh_i2s_configure_i2s_regs(dpcm->cbd.priv, 0, &config, IOH_PLAYBACK,
				   byte);
	return ret;
}

static void __snd_card_ml7213i2s_runtime_free(struct snd_pcm_runtime *runtime)
{
	struct snd_ml7213i2s_pcm *dpcm;
	static int cnt;

	dpcm = (struct snd_ml7213i2s_pcm *)runtime->private_data;
	/* FIXME: This is just a big ball of race right now...
	 */
	if (!dpcm->cbd.stop)
		dpcm->cbd.stop = 1;
	else {
		while (dpcm->cbd.stop != 2) {
			if (cnt++ > 100) {
				pr_debug("oops, failed to close ml7213i2s..\n");
				pr_debug("it's ok if i2s isn't running\n");
				break;
			}
			msleep(20);
		}
	}
}

static void snd_card_ml7213i2s_runtime_capture_free
					(struct snd_pcm_runtime *runtime)
{
	struct snd_ml7213i2s_pcm *dpcm;
	dpcm = (struct snd_ml7213i2s_pcm *)runtime->private_data;

	__snd_card_ml7213i2s_runtime_free(runtime);

	if (dpcm->setup_flag)
		ioh_i2s_release(dpcm->cbd.priv, IOH_CAPTURE);
	kfree(runtime->private_data);
}

static struct snd_ml7213i2s_pcm *
new_pcm_stream(struct snd_pcm_substream *substream)
{
	struct snd_ml7213i2s_pcm *dpcm;

	dpcm = kzalloc(sizeof(*dpcm), GFP_KERNEL);
	if (!dpcm)
		return dpcm;
	spin_lock_init(&dpcm->lock);
	dpcm->substream = substream;
	return dpcm;
}

static int snd_card_ml7213i2s_open(struct snd_pcm_substream *substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	struct snd_ml7213i2s_pcm *dpcm;
	int err;

	dpcm = new_pcm_stream(substream);
	if (dpcm == NULL)
		return -ENOMEM;

	runtime->private_data = dpcm;
	/* makes the infrastructure responsible for freeing dpcm */
	runtime->private_free = snd_card_ml7213i2s_runtime_capture_free;

	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
		dpcm->rw = SND_CAPTURE_SUBSTREAM;
		runtime->hw = snd_card_ml7213i2s_capture[substream->number];
	} else {
		dpcm->rw = SND_PLAYBACK_SUBSTREAM;
		runtime->hw = snd_card_ml7213i2s_playback[substream->number];
	}

	dpcm->setup_flag = 0;
	err = add_capture_constraints(runtime);
	if (err < 0)
		return err;

	return 0;
}

static int snd_card_ml7213i2s_close(struct snd_pcm_substream *substream)
{
	return 0;
}

static int snd_card_ml7213i2s_hw_params(struct snd_pcm_substream *substream,
				    struct snd_pcm_hw_params *hw_params)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
	unsigned int enable_flag = 0;
	unsigned int ch = substream->number;

	dpcm->channels = params_channels(hw_params);
	dpcm->ch = substream->number;
	dpcm->rate = params_rate(hw_params);
	switch (params_format(hw_params)) {
	case SNDRV_PCM_FORMAT_U8:
		dpcm->format = ioh_dabit_8bit << I2SCNT_DABIT_OFFSET;
		if (dpcm->channels == 1)
			dpcm->bclkfs = ioh_bclkfs_32fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		else
			dpcm->bclkfs = ioh_bclkfs_32fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		break;
	case SNDRV_PCM_FORMAT_S16_LE:
		dpcm->format = ioh_dabit_16bit << I2SCNT_DABIT_OFFSET;
		if (dpcm->channels == 1)
			dpcm->bclkfs = ioh_bclkfs_32fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		else
			dpcm->bclkfs = ioh_bclkfs_32fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		break;
	case SNDRV_PCM_FORMAT_S32_LE:
		dpcm->format = ioh_dabit_24bit << I2SCNT_DABIT_OFFSET;
		if (dpcm->channels == 1)
			dpcm->bclkfs = ioh_bclkfs_64fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		else
			dpcm->bclkfs = ioh_bclkfs_64fs <<
				       I2SCLKCNT_BCLKFS_OFFSET;
		break;
	default:
		pr_err("%s: Failed not support format\n", __func__);
		return -1;
		break;
	}

	switch (dpcm->rw) {
	case SND_CAPTURE_SUBSTREAM:
		if (setup_i2s_read(substream, substream->number))
			return -1;

		dpcm->enable_mode |= 1 << (ch + I2S_READ_ENABLE_BIT);
		enable_flag = (dpcm->enable_mode >> (ch+I2S_WRITE_ENABLE_BIT)) & 1;
		break;
	case SND_PLAYBACK_SUBSTREAM:
		if (setup_i2s_write(substream, substream->number))
			return -1;

		dpcm->enable_mode |= 1 << (ch + I2S_WRITE_ENABLE_BIT);
		enable_flag = (dpcm->enable_mode >> (ch+I2S_READ_ENABLE_BIT)) & 1;
		break;
	default:
		return -1;
	}

	return snd_pcm_lib_malloc_pages(substream,
					params_buffer_bytes(hw_params));
}

static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream)
{
	struct snd_ml7213i2s_pcm *dpcm = substream->runtime->private_data;
	struct ioh_i2s_config_reg config;
	unsigned int flag;
	unsigned int enable_flag = 0;
	unsigned int ch = substream->number;

	switch (dpcm->rw) {
	case SND_CAPTURE_SUBSTREAM:
		i2s_rx_configure_reg(&config, dpcm->rate, dpcm);
		config.cmn.i2sclkcnt &= ~I2SCLKCNT_MSSEL;

		dpcm->master_mode &= ~(1<<(ch+I2S_READ_MASTER_BIT));
		flag = (dpcm->master_mode >> (ch+I2S_WRITE_MASTER_BIT)) & 1;

		dpcm->enable_mode &= ~(1<<(ch+I2S_READ_ENABLE_BIT));
		enable_flag = (dpcm->enable_mode >> (ch+I2S_WRITE_ENABLE_BIT)) & 1;

		if (dpcm->setup_flag) {
			ioh_i2s_stop_i2s_regs(dpcm->cbd.priv, 0, &config,
					      IOH_CAPTURE, flag);
			kfree(dpcm->cbd.priv);
		}
		break;

	case SND_PLAYBACK_SUBSTREAM:
		i2s_tx_configure_reg(&config, dpcm->rate, dpcm);
		config.cmn.i2sclkcnt &= ~I2SCLKCNT_MSSEL;

		dpcm->master_mode &= ~(1<<(ch+I2S_WRITE_MASTER_BIT));
		flag = (dpcm->master_mode >> (ch+I2S_READ_MASTER_BIT)) & 1;

		dpcm->enable_mode &= ~(1<<(ch+I2S_WRITE_ENABLE_BIT));
		enable_flag = (dpcm->enable_mode >> (ch+I2S_READ_ENABLE_BIT)) & 1;

		if (dpcm->setup_flag) {
			ioh_i2s_stop_i2s_regs(dpcm->cbd.priv, 0, &config,
					      IOH_PLAYBACK, flag);
			kfree(dpcm->cbd.priv);
		}
		break;

	default:
		return -1;
	}

	if (!enable_flag) {
		pr_err("%s: enable_flag is NULL\n", __func__);
		return -1;
	}

	return snd_pcm_lib_free_pages(substream);
}

void ioh_i2s_irq_stop(struct ioh_i2s_data *priv, enum ioh_direction dir)
{
	if (!priv) {
		dev_err(priv->dev, "%s: i2s is NULL\n", __func__);
		return;
	}

	if (dir) {
		ioh_i2s_disable_interrupts(priv, IOH_CAPTURE);
		ioh_i2s_disable_rx_full_ir(priv);
		ioh_i2s_clear_rx_sts_ir(priv);
		priv->rxexe_flag = 0;

	} else {
		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
		ioh_i2s_disable_tx_empty_ir(priv);
		ioh_i2s_clear_tx_sts_ir(priv);
		priv->txexe_flag = 0;
	}
}

void ioh_i2s_write_start(struct ioh_i2s_data *priv, void *callback_data,
			 void (*done) (void *callback_data, int status,
				       int num, int avail))
{
	priv->txexe_flag = 1;

	priv->tx_data_head = priv->tx_head;
	priv->tx_complete = priv->tx_head;
	priv->tx_avail = 0;

	priv->tx_callback_data = callback_data;
	priv->tx_done = done;

	ioh_i2s_clear_tx_sts_ir(priv);
	ioh_i2s_tx_clear_dma_mask(priv);
	ioh_i2s_enable_interrupts(priv, IOH_PLAYBACK);
}

void ioh_i2s_read_start(struct ioh_i2s_data *priv, void *callback_data,
			void (*done) (void *callback_data, int status,
				      int num, int avail))
{
	priv->rxexe_flag = 1;

	priv->rx_data_head = priv->rx_head;
	priv->rx_complete = priv->rx_head;
	priv->rx_avail = 0;

	priv->rx_callback_data = callback_data;
	priv->rx_done = done;

	ioh_i2s_clear_rx_sts_ir(priv);
	ioh_i2s_rx_clear_dma_mask(priv);
	ioh_i2s_enable_interrupts(priv, IOH_CAPTURE);
}

static inline void
snd_card_ml7213i2s_pcm_i2s_start(struct snd_pcm_substream *substream)
{
	struct snd_ml7213i2s_pcm *dpcm;
	struct cbdata *cbd;
	dpcm = substream->runtime->private_data;
	cbd = &dpcm->cbd;

	if (!cbd->priv)
		return;

	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
		ioh_i2s_read_start(cbd->priv, substream, read_done);
	} else {
		ioh_i2s_write_start(cbd->priv, substream, write_done);
		i2s_write_period(substream);
	}
}

static int snd_card_ml7213i2s_pcm_trigger
				(struct snd_pcm_substream *substream, int cmd)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;
	int err = 0;

	spin_lock(&dpcm->lock);

	switch (cmd) {
	case SNDRV_PCM_TRIGGER_START:
	case SNDRV_PCM_TRIGGER_RESUME:
		dpcm->cbd.stop = 0;
		snd_card_ml7213i2s_pcm_i2s_start(substream);
		break;
	case SNDRV_PCM_TRIGGER_STOP:
	case SNDRV_PCM_TRIGGER_SUSPEND:
		pr_debug("stop..\n");
		if (!dpcm->cbd.stop)
			dpcm->cbd.stop = 1;
		else
			pr_debug("already stopped %d\n", dpcm->cbd.stop);
		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
			ioh_i2s_irq_stop(dpcm->cbd.priv, IOH_CAPTURE);
		else
			ioh_i2s_irq_stop(dpcm->cbd.priv, IOH_PLAYBACK);
		break;
	default:
		err = -EINVAL;
		break;
	}

	spin_unlock(&dpcm->lock);
	return 0;
}

static int snd_card_ml7213i2s_pcm_prepare(struct snd_pcm_substream *substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;

	dpcm->irq_pos = 0;
	dpcm->buf_pos = 0;

	snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
			bytes_to_samples(runtime, runtime->dma_bytes));

	return 0;
}

static snd_pcm_uframes_t
snd_card_ml7213i2s_pcm_pointer(struct snd_pcm_substream *substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	struct snd_ml7213i2s_pcm *dpcm = runtime->private_data;

	return substream->runtime->period_size*dpcm->buf_pos;
}

static struct snd_pcm_ops snd_card_ml7213i2s_capture_ops = {
	.open =			snd_card_ml7213i2s_open,
	.close =		snd_card_ml7213i2s_close,
	.ioctl =		snd_pcm_lib_ioctl,
	.hw_params =		snd_card_ml7213i2s_hw_params,
	.hw_free =		snd_card_ml7213i2s_hw_free,
	.prepare =		snd_card_ml7213i2s_pcm_prepare,
	.trigger =		snd_card_ml7213i2s_pcm_trigger,
	.pointer =		snd_card_ml7213i2s_pcm_pointer,
};

static int ml7213ioh_pcm_probe(struct snd_soc_platform *platform)
{
	return 0;
}

static int ml7213ioh_pcm_remove(struct snd_soc_platform *platform)
{
	return 0;
}

static struct snd_soc_platform_driver ml7213ioh_soc_platform = {
	.probe		= ml7213ioh_pcm_probe,
	.remove		= ml7213ioh_pcm_remove,
	.ops		= &snd_card_ml7213i2s_capture_ops,
};

static int __devinit snd_card_ml7213i2s_pcm(struct snd_ml7213i2s *ml7213i2s,
					     int device)
{
	struct snd_pcm *pcm;
	int err;

	/* The number of I2S interface is (Rx + Tx) x 6CH */
	err = snd_pcm_new(ml7213i2s->card, "ml7213i2s PCM", device,
			       MAX_I2S_TX_CH, MAX_I2S_RX_CH, &pcm);
	if (err < 0)
		return err;
	ml7213i2s->pcm = pcm;
	pcm->private_data = ml7213i2s;
	pcm->info_flags = 0;
	strcpy(pcm->name, "ml7213i2s PCM");

	snd_pcm_lib_preallocate_pages_for_all(
		pcm, SNDRV_DMA_TYPE_CONTINUOUS,
		snd_dma_continuous_data(GFP_KERNEL),
		0, 64*1024);
	return 0;
}

static struct snd_device_ops ops = {NULL};

/*****************************************************************************
 *	PCI functions
 *****************************************************************************/
DEFINE_PCI_DEVICE_TABLE(ioh_pci_tbl) = {
	{
		.vendor = PCI_VENDOR_ID_ROHM,
		.device = PCI_DEVICE_ID_ML7213_I2S,
		.subvendor = PCI_ANY_ID,
		.subdevice = PCI_ANY_ID,
	},
	{0,}
};

static int ioh_i2s_pci_probe(struct pci_dev *pdev,
				 const struct pci_device_id *id)
{
	int rv = 0;
	int i;
	int err;
	struct ioh_i2s_data_pci *drvdata;
	void __iomem *tbl;
	unsigned int mapbase;
	struct snd_card *card;
	struct snd_ml7213i2s *ml7213i2s;
	int dev = 0;

	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
	if (!drvdata)
		return -ENOMEM;

	pci_set_drvdata(pdev, drvdata);

	rv = pci_enable_device(pdev);
	if (rv)
		goto out_free;

	tbl = pci_iomap(pdev, 1, 0);
	if (!tbl) {
		rv = -ENOMEM;
		printk(KERN_ERR "pci_iomap failed\n");
		goto out_ipmap;
	}

	mapbase = pci_resource_start(pdev, 1);
	if (!mapbase) {
		rv = -ENOMEM;
		printk(KERN_ERR "pci_resource_start failed\n");
		goto out_pci_resource_start;
	}
	drvdata->membase = tbl;
	drvdata->mapbase = mapbase;
	drvdata->dev = &pdev->dev;

	for (i = 0; i < MAX_I2S_IF; i++) {
		drvdata->devs[i].iobase = tbl;
		drvdata->devs[i].mapbase = mapbase;
		spin_lock_init(&drvdata->devs[i].tx_lock);
		drvdata->devs[i].dma_config = &ioh_dma_config[i];
	}

	rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
			 pdev);
	if (rv != 0) {
		printk(KERN_ERR "Failed to allocate irq\n");
		goto out_irq;
	}

	err = snd_card_create(index, "ml7213i2s", THIS_MODULE,
			      sizeof(struct snd_ml7213i2s), &card);

	if (err < 0)
		goto out_snd_card_create;

	ml7213i2s = card->private_data;
	ml7213i2s->card = card;
	ml7213i2s->pci_dat = drvdata;
	err = snd_card_ml7213i2s_pcm(ml7213i2s, 0);
	if (err < 0)
		goto snd_card_ml7213i2s_pc;

	strcpy(card->driver, "ml7213i2s");
	strcpy(card->shortname, "ml7213i2s");
	sprintf(card->longname, "ml7213i2s %i", dev + 1);

	snd_card_set_dev(card, &pdev->dev);
	snd_device_new(card, SNDRV_DEV_LOWLEVEL, ml7213i2s, &ops);
	err = snd_card_register(card);
	if (err)
		goto out_snd_card_register;

	drvdata->card = card;

	snd_soc_register_platform(&pdev->dev, &ml7213ioh_soc_platform);

	return 0;

out_snd_card_register:
snd_card_ml7213i2s_pc:
	snd_card_free(card);
out_snd_card_create:
	free_irq(pdev->irq, pdev);
out_irq:
out_pci_resource_start:
	pci_iounmap(pdev, tbl);
out_ipmap:
	pci_disable_device(pdev);
out_free:
	kfree(drvdata);

	return rv;
}

static void ioh_i2s_pci_remove(struct pci_dev *pdev)
{
	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
	int i;

	for (i = 0; i < MAX_I2S_IF; i++)
		ioh_i2s_reset(&drvdata->devs[i]);

	snd_soc_unregister_platform(&pdev->dev);
	kfree(drvdata);
	pci_disable_device(pdev);
	pci_iounmap(pdev, drvdata->membase);
	free_irq(pdev->irq, pdev);
	snd_card_free(drvdata->card);
	pci_set_drvdata(pdev, NULL);
}

static void ioh_i2s_save_reg_conf(struct pci_dev *pdev)
{
	int i;
	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
	void *iobase;
	struct ioh_i2s_pm_ch_reg *save;
	int offset;

	for (i = 0, offset = 0; i < MAX_I2S_IF; i++, offset = i * 0x800) {
		iobase = drvdata->devs[i].iobase;
		save = &drvdata->devs[i].ch_reg_save;

		save->i2sdrtx = ioread32(iobase + offset + I2SDRTX_OFFSET);
		save->i2scnttx = ioread32(iobase + offset + I2SCNTTX_OFFSET);
		save->i2sfifoctx =
				ioread32(iobase + offset + I2SFIFOCTX_OFFSET);
		save->i2saftx = ioread32(iobase + offset + I2SAFTX_OFFSET);
		save->i2saetx = ioread32(iobase + offset + I2SAETX_OFFSET);
		save->i2smsktx = ioread32(iobase + offset + I2SMSKTX_OFFSET);
		save->i2sisttx = ioread32(iobase + offset + I2SISTTX_OFFSET);

		save->i2scntrx = ioread32(iobase + offset + I2SCNTRX_OFFSET);
		save->i2sfifocrx =
				ioread32(iobase + offset + I2SFIFOCRX_OFFSET);
		save->i2safrx = ioread32(iobase + offset + I2SAFRX_OFFSET);
		save->i2saerx = ioread32(iobase + offset + I2SAERX_OFFSET);
		save->i2smskrx = ioread32(iobase + offset + I2SMSKRX_OFFSET);
		save->i2sistrx = ioread32(iobase + offset + I2SISTRX_OFFSET);
	}

	for (i = 0; i < MAX_I2S_IF; i++) {
		drvdata->cmn_reg_save.i2sclkcnt[i] =
		ioread32(drvdata->devs[i].iobase + I2SCLKCNT0_OFFSET + 0x10*i);
	}
	drvdata->cmn_reg_save.i2simask =
			   ioread32(drvdata->devs[0].iobase + I2SIMASK_OFFSET);
}

static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
{
	int ret;

	ioh_i2s_save_reg_conf(pdev);
	ret = pci_save_state(pdev);
	if (ret) {
		dev_err(&pdev->dev,
			" %s -pci_save_state returns %d\n", __func__, ret);
		return ret;
	}
	pci_enable_wake(pdev, PCI_D3hot, 0);
	pci_disable_device(pdev);
	pci_set_power_state(pdev, pci_choose_state(pdev, state));

	return 0;
}

static void ioh_i2s_restore_reg_conf(struct pci_dev *pdev)
{
	int i;
	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
	void *iobase;
	struct ioh_i2s_pm_ch_reg *save;
	int offset;

	for (i = 0, offset = 0; i < MAX_I2S_IF; i++, offset = i * 0x800) {
		iobase = drvdata->devs[i].iobase;
		save = &drvdata->devs[i].ch_reg_save;

		iowrite32(save->i2sdrtx, iobase + offset + I2SDRTX_OFFSET);
		iowrite32(save->i2scnttx, iobase + offset + I2SCNTTX_OFFSET);
		iowrite32(save->i2sfifoctx,
			  iobase + offset + I2SFIFOCTX_OFFSET);
		iowrite32(save->i2saftx, iobase + offset + I2SAFTX_OFFSET);
		iowrite32(save->i2saetx, iobase + offset + I2SAETX_OFFSET);
		iowrite32(save->i2smsktx, iobase + offset + I2SMSKTX_OFFSET);
		iowrite32(save->i2sisttx, iobase + offset + I2SISTTX_OFFSET);

		iowrite32(save->i2scntrx, iobase + offset + I2SCNTRX_OFFSET);
		iowrite32(save->i2sfifocrx,
			  iobase + offset + I2SFIFOCRX_OFFSET);
		iowrite32(save->i2safrx, iobase + offset + I2SAFRX_OFFSET);
		iowrite32(save->i2saerx, iobase + offset + I2SAERX_OFFSET);
		iowrite32(save->i2smskrx, iobase + offset + I2SMSKRX_OFFSET);
		iowrite32(save->i2sistrx, iobase + offset + I2SISTRX_OFFSET);
	}

	for (i = 0; i < MAX_I2S_IF; i++) {
		iowrite32(drvdata->cmn_reg_save.i2sclkcnt[i],
			 drvdata->devs[i].iobase + I2SCLKCNT0_OFFSET + 0x10*i);
	}

	iowrite32(drvdata->cmn_reg_save.i2simask,
		  drvdata->devs[0].iobase + I2SIMASK_OFFSET);
}

static int ioh_i2s_pci_resume(struct pci_dev *pdev)
{
	int ret;

	pci_set_power_state(pdev, PCI_D0);
	pci_restore_state(pdev);
	ret = pci_enable_device(pdev);
	if (ret) {
		dev_err(&pdev->dev,
		"%s-pci_enable_device failed(ret=%d) ", __func__, ret);
		return ret;
	}

	pci_enable_wake(pdev, PCI_D3hot, 0);
	ioh_i2s_restore_reg_conf(pdev);

	return 0;
}

static struct pci_driver ioh_i2s_driver = {
	.name = DRV_NAME,
	.probe = ioh_i2s_pci_probe,
	.remove = __devexit_p(ioh_i2s_pci_remove),
	.id_table = ioh_pci_tbl,
#ifdef CONFIG_PM
	.suspend = ioh_i2s_pci_suspend,
	.resume = ioh_i2s_pci_resume,
#endif
};

static int __init ioh_i2s_init(void)
{
	return pci_register_driver(&ioh_i2s_driver);
}

static void __exit ioh_i2s_cleanup(void)
{
	pci_unregister_driver(&ioh_i2s_driver);
}

module_init(ioh_i2s_init);
module_exit(ioh_i2s_cleanup);

MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC platform driver");
MODULE_LICENSE("GPL");

--------------000506070709060806020102
Content-Type: text/plain;
 name="ml7213ioh-plat.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ml7213ioh-plat.h"

/*
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#ifndef ML7213IOH_PLAT_H
#define ML7213IOH_PLAT_H

#include <linux/interrupt.h>
#include <linux/pch_dma.h>

#define I2SCLKCNT0_OFFSET	0x3000
#define I2SCLKCNT1_OFFSET	0x3010
#define I2SCLKCNT2_OFFSET	0x3020
#define I2SCLKCNT3_OFFSET	0x3030
#define I2SCLKCNT4_OFFSET	0x3040
#define I2SCLKCNT5_OFFSET	0x3050
#define I2SISTATUS_OFFSET	0x3080
#define I2SIDISP_OFFSET		0x3084
#define I2SIMASK_OFFSET		0x3088
#define I2SIMASKCLR_OFFSET	0x308C
#define I2SSRST_OFFSET		0x3FFC
#define I2SDRTX_OFFSET		0x0
#define I2SCNTTX_OFFSET		0x4
#define I2SFIFOCTX_OFFSET	0x8
#define I2SAFTX_OFFSET		0xC
#define I2SAETX_OFFSET		0x10
#define I2SMSKTX_OFFSET		0x14
#define I2SISTTX_OFFSET		0x18
#define I2SMONTX_OFFSET		0x1C
#define I2SDRRX_OFFSET		0x20
#define I2SCNTRX_OFFSET		0x24
#define I2SFIFOCRX_OFFSET	0x28
#define I2SAFRX_OFFSET		0x2C
#define I2SAERX_OFFSET		0x30
#define I2SMSKRX_OFFSET		0x34
#define I2SISTRX_OFFSET		0x38
#define I2SMONRX_OFFSET		0x3C
#define FIRST_TX_OFFSET		0x0
#define FIRST_RX_OFFSET		0x0

#define I2SDRTXMIRROR_OFFSET	0x100
#define I2SDRRXMIRROR_OFFSET	0x400

#define TX_OFFSET_INCREMENT	0x800

#define I2S_ALL_INTERRUPT_BITS	0x3F003F
#define I2S_IDISP_BITS		0x3F003F
#define I2S_IDISP_TX_BITS	0x00003F
#define I2S_IDISP_RX_BITS	0x3F0000
#define TX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
#define TX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
#define TX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
#define TX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
#define TX_BIT_DMAMSK	0x10	/*Masks DMA*/
#define TX_BIT_DMATC	0x100
#define I2S_TX_ALL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK | TX_BIT_EIMSK \
							| TX_BIT_AEIMSK)
#define I2S_TX_NORMAL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK)
#define RX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
#define RX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
#define RX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
#define RX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
#define RX_BIT_DMAMSK	0x10	/*Masks DMA*/
#define RX_BIT_DMATC	0x100
#define I2S_RX_ALL_INTR_MASK_BITS (RX_BIT_FIMSK | RX_BIT_AFIMSK | RX_BIT_EIMSK \
							| RX_BIT_AEIMSK)
#define I2S_RX_NORMAL_INTR_MASK_BITS (RX_BIT_EIMSK | RX_BIT_AEIMSK)
#define I2S_TX_FINT	0x1	/*Full Interrupt*/
#define I2S_TX_AFINT	0x2	/*Almost full interrupt*/
#define I2S_TX_EINT	0x4	/*Empty interrupt*/
#define I2S_TX_AEINT	0x8	/*Almost empty interrupt*/
#define I2S_RX_FINT	0x1	/*Full Interrupt*/
#define I2S_RX_AFINT	0x2	/*Almost full interrupt*/
#define I2S_RX_EINT	0x4	/*Empty interrupt*/
#define I2S_RX_AEINT	0x8	/*Almost empty interrupt*/

#define I2S_FIFO_TX_FCLR	BIT(0)
#define I2S_FIFO_TX_RUN		BIT(4)
#define I2S_FIFO_RX_FCLR	BIT(0)
#define I2S_FIFO_RX_RUN		BIT(4)

#define FIFO_CTRL_BIT_TX_RUN	0x10
#define FIFO_CTRL_BIT_RX_RUN	0x10
#define I2S_CNT_BIT_TEL		0x1
#define I2S_IMASK_TX_BIT_START	0
#define I2S_IMASK_RX_BIT_START	16

#define MAX_I2S_IF	MAX_I2S_CH

/* DMA channel name configuration */
static struct ioh_dma_config {
	char rx_chan[8];
	char tx_chan[8];
} ioh_dma_config[] = {
	{ /* I2S0 */
		.tx_chan = "i2s_tx0",
		.rx_chan = "i2s_rx0",
	},
	{ /* I2S1 */
		.tx_chan = "i2s_tx1",
		.rx_chan = "i2s_rx1",
	},
	{ /* I2S2 */
		.tx_chan = "i2s_tx2",
		.rx_chan = "i2s_rx2",
	},
	{ /* I2S3 */
		.tx_chan = "i2s_tx3",
		.rx_chan = "i2s_rx3",
	},
	{ /* I2S4 */
		.tx_chan = "i2s_tx4",
		.rx_chan = "i2s_rx4",
	},
	{ /* I2S5 */
		.tx_chan = "i2s_tx5",
		.rx_chan = "i2s_rx5",
	},
};

struct ioh_i2s_data {
	struct device *dev;
	void *iobase;
	int ch;
	atomic_t rx_busy;
	atomic_t tx_busy;

	int ignore_rx_overrun;

	/* Transmit side DMA */
	atomic_t pending_tx;

	struct ioh_dma_config *dma_config;

	char rx_name[16];
	char tx_name[16];

	struct scatterlist	*sg_tx_p;
	struct scatterlist	*sg_rx_p;

	struct scatterlist	*sg_tx_cur; /* current head of tx sg */
	struct scatterlist	*sg_rx_cur; /* current head of tx sg */
	int tx_num;	/* The number of sent sg */
	int rx_num;	/* The number of sent sg */

	void *rxbuf_virt;
	void *txbuf_virt;
	unsigned char *tx_tail;
	unsigned char *tx_head;
	unsigned char *tx_data_head;
	unsigned char *tx_complete;
	unsigned int  tx_avail;
	unsigned char *rx_tail;
	unsigned char *rx_head;
	unsigned char *rx_data_head;
	unsigned char *rx_complete;
	unsigned int rx_avail;
	struct dma_chan			*chan_tx;
	struct dma_chan			*chan_rx;

	int rx_nent;	/* The number of rx scatter list  */
	int tx_nent;	/* The number of tx scatter list */

	struct dma_async_tx_descriptor	*desc_tx;
	struct dma_async_tx_descriptor	*desc_rx;

	dma_addr_t			tx_buf_dma;
	dma_addr_t			rx_buf_dma;

	spinlock_t tx_lock;

	struct pch_dma_slave		param_tx;
	struct pch_dma_slave		param_rx;
	unsigned int			mapbase;
	dma_addr_t			tx_reg_addr[2];

	void *rx_callback_data;
	void (*rx_done) (void *callback_data, int status, int num, int avail);
	void *tx_callback_data;
	void (*tx_done) (void *callback_data, int status, int num, int avail);

	unsigned int tx_lower_data_flag;

	int dma_tx_unit; /* 1Byte of 2Byte or 4Byte */
	int dma_rx_unit; /* 1Byte of 2Byte or 4Byte */
	int dma_tx_width;
	int dma_rx_width;

	int txexe_flag;
	int rxexe_flag;

	struct tasklet_struct	tx_tasklet;
	struct tasklet_struct	rx_tasklet;

	struct ioh_i2s_pm_ch_reg ch_reg_save;
};

struct ioh_i2s_data_pci {
	struct ioh_i2s_data devs[MAX_I2S_IF];
	void __iomem *membase;
	unsigned int mapbase;
	struct ioh_i2s_pm_common_reg cmn_reg_save;
	struct snd_card *card;
	struct device *dev;
};

#endif

--------------000506070709060806020102
Content-Type: text/plain;
 name="ml26124.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ml26124.h"

/*
 * Copyright (c) 2005 Openedhand Ltd.
 * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
 *
 * This code was derived from the WM8731 Soc Audio driver
 * by Richard Purdie <richard@openedhand.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 */

#ifndef _WM8731_H
#define _WM8731_H

/* WM8731 register space */

#define WM8731_LINVOL   0x00
#define WM8731_RINVOL   0x01
#define WM8731_LOUT1V   0x02
#define WM8731_ROUT1V   0x03
#define WM8731_APANA    0x04
#define WM8731_APDIGI   0x05
#define WM8731_PWR      0x06
#define WM8731_IFACE    0x07
#define WM8731_SRATE    0x08
#define WM8731_ACTIVE   0x09
#define WM8731_RESET	0x0f

#define WM8731_CACHEREGNUM 	10

#define WM8731_SYSCLK_XTAL 1
#define WM8731_SYSCLK_MCLK 2

#define WM8731_DAI		0

/* Clock Control Register */
#define ML26124_SMPLING_RATE		0x00
#define ML26124_PLLNL			0x02
#define ML26124_PLLNH			0x04
#define ML26124_PLLML			0x06
#define ML26124_PLLMH			0x08
#define ML26124_PLLDIV			0x0a
#define ML26124_CLK_EN			0x0c
#define ML26124_CLK_CTL			0x0e

/* System Control Register */
#define ML26124_SW_RST			0x10
#define ML26124_REC_PLYBAK_RUN		0x12
#define ML26124_MIC_TIM			0x14

/* Power Mnagement Register */
#define ML26124_PW_REF_PW_MNG		0x20
#define ML26124_PW_IN_PW_MNG		0x22
#define ML26124_PW_DAC_PW_MNG		0x24
#define ML26124_PW_SPAMP_PW_MNG		0x26
#define ML26124_PW_LOUT_PW_MNG		0x28
#define ML26124_PW_VOUT_PW_MNG		0x2a
#define ML26124_PW_ZCCMP_PW_MNG		0x2e

/* Analog Reference Control Register */
#define ML26124_PW_MICBIAS_VOL		0x30

/* Input/Output Amplifier Control Register */
#define ML26124_PW_MIC_IN_VOL		0x32
#define ML26124_PW_MIC_BOST_VOL		0x38
#define ML26124_PW_SPK_AMP_VOL		0x3a
#define ML26124_PW_AMP_VOL_FUNC		0x48
#define ML26124_PW_AMP_VOL_FADE		0x4a

/* Analog Path Control Register */
#define ML26124_SPK_AMP_OUT		0x54
#define ML26124_MIC_IF_CTL		0x5a
#define ML26124_MIC_SELECT		0xe8
//#define ML26124_CTL			0x

/* Audio Interface Control Register */
#define ML26124_SAI_TRANS_CTL		0x60
#define ML26124_SAI_RCV_CTL		0x62
#define ML26124_SAI_MODE_SEL		0x64

/* DSP Control Register */
#define ML26124_FILTER_EN		0x66
#define ML26124_VOL_CTL_EN		0x68
#define ML26124_MIXER_VOL_CTL		0x6a
#define ML26124_RECORD_DIG_VOL		0x6c
#define ML26124_PLBAK_DIG_VOL		0x70
#define ML26124_DIGI_BOOST_VOL		0x72
#define ML26124_EQ_GAIN_BRAND0		0x74
#define ML26124_EQ_GAIN_BRAND1		0x76
#define ML26124_EQ_GAIN_BRAND2		0x78
#define ML26124_EQ_GAIN_BRAND3		0x7a
#define ML26124_EQ_GAIN_BRAND4		0x7c
#define ML26124_HPF2_CUTOFF		0x7e
#define ML26124_EQBRAND0_F0L		0x80
#define ML26124_EQBRAND0_F0H		0x82
#define ML26124_EQBRAND0_F1L		0x84
#define ML26124_EQBRAND0_F1H		0x86
#define ML26124_EQBRAND1_F0L		0x88
#define ML26124_EQBRAND1_F0H		0x8a
#define ML26124_EQBRAND1_F1L		0x8c
#define ML26124_EQBRAND1_F1H		0x8e
#define ML26124_EQBRAND2_F0L		0x90
#define ML26124_EQBRAND2_F0H		0x92
#define ML26124_EQBRAND2_F1L		0x94
#define ML26124_EQBRAND2_F1H		0x96
#define ML26124_EQBRAND3_F0L		0x98
#define ML26124_EQBRAND3_F0H		0x9a
#define ML26124_EQBRAND3_F1L		0x9c
#define ML26124_EQBRAND3_F1H		0x9e
#define ML26124_EQBRAND4_F0L		0xa0
#define ML26124_EQBRAND4_F0H		0xa2
#define ML26124_EQBRAND4_F1L		0xa4
#define ML26124_EQBRAND4_F1H		0xa6

/* ALC Control Register */
#define ML26124_ALC_MODE		0xb0
#define ML26124_ALC_ATTACK_TIM		0xb2
#define ML26124_ALC_DECAY_TIM		0xb4
#define ML26124_ALC_HOLD_TIM		0xb6
#define ML26124_ALC_TARGET_LEV		0xb8
#define ML26124_ALC_MAXMIN_GAIN		0xba
#define ML26124_NOIS_GATE_THRSH		0xbc
#define ML26124_ALC_ZERO_TIMOUT		0xbe

/* Playback Limiter Control Register */
#define ML26124_PL_ATTACKTIME		0xc0
#define ML26124_PL_DECAYTIME		0xc2
#define ML26124_PL_TARGETTIME		0xc4
#define ML26124_PL_MAXMIN_GAIN		0xc6
#define ML26124_PLYBAK_BOST_VOL		0xc8
#define ML26124_PL_0CROSS_TIMOUT	0xca

/* Video Amplifer Control Register */
#define ML26124_VIDEO_AMP_GAIN_CTL	0xd0
#define ML26124_VIDEO_AMP_SETUP1	0xd2
#define ML26124_VIDEO_AMP_CTL2		0xd4

#endif

--------------000506070709060806020102--
