Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1KUL0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:26:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57438 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110Ab1KUL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:26:10 -0500
Date: Mon, 21 Nov 2011 11:26:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111121112607.GB3784@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Don't get to bragging.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 01:08:50PM +0900, Tomoya MORINAGA wrote:

> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply
> rejection

So, in general the big overall issue with this code is that it's really
not following the general coding styles and standards for a modern ASoC
driver.  I've pointed out some issues below but there's rather a lot of
them.  In general you should always try to ensure that the code you're
submitting looks like other code for the relevant subsystem.

The big thing that's sticking out at me is the register write sequence
you've got in the middle of the driver - it looks awfully like it's hard
coding a particular use case.

> +struct ml26124_priv {
> +	enum snd_soc_control_type control_type;
> +	spinlock_t lock;
> +	struct snd_pcm_substream *substream;
> +	unsigned int rate;
> +	unsigned int ch;
> +	struct mutex i2c_mutex;

What are these locks for?  Especially the spinlock looks highly
suspicous.

> +static const char *ml26124_lrmcon[] = {"Use L", "Use R", "Use (L+R)", "Use (L+R)/2"};

The "Use" isn't terribly idomatic, remove it.

> +static const struct soc_enum ml26124_enum[] = {
> +/* #define SOC_ENUM_SINGLE(xreg, xshift, xmax, xtexts) */
> +	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 0, 4, ml26124_lrmcon),
> +	SOC_ENUM_SINGLE(ML26124_MIXER_VOL_CTL, 4, 15, ml26124_dvfconcon),

Don't use a big table of enums, indexing into it is illegible and error
prone.

> +static const struct snd_kcontrol_new ml26124_snd_controls[] = {
> +	SOC_SINGLE_TLV("Record Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),

Capture, not Record.

> +	SOC_SINGLE_TLV("EQ Band1 Gain Setting",  ML26124_EQ_GAIN_BRAND1, 0, 0xff, 1, eq_band_gain),

Volume not Gain Setting.  As a rule anything with TLV information should
be a Volume.

> +static const struct snd_kcontrol_new ml26124_dsp_controls[] = {
> +	SOC_SINGLE("Play Limitter ON/OFF", ML26124_FILTER_EN, 0, 1, 0),

Switch.

> +	SOC_SINGLE("Ditital Volume MUTE", ML26124_FILTER_EN, 4, 1, 0),

Switch.

> +	SOC_SINGLE("Set ALC position", ML26124_FILTER_EN, 5, 1, 0),

What does this actually do?  From the name it *really* doesn't look like
a mixer input.

> +	SND_SOC_DAPM_SPK("Speaker", NULL),
> +	SND_SOC_DAPM_LINE("LINEOUT", NULL),

These should be _OUTPUT() pins - SPK and LINE widgets should only be
used by machine drivers.

> +#define	CODEC_DEV_ADDR		(0x1A)

> +static struct i2c_board_info ioh_hwmon_info[] = {
> +	{I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR + 1)},
> +	{I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR + 2)},
> +	{I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR + 3)},
> +	{I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR + 4)},
> +	{I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR + 5)},
> +	{I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
> +};

Absolutely no.  Your driver should be a standard I2C driver, device
registration should be done by the board not the chip driver.

> +static const struct snd_soc_dapm_route intercon[] = {
> +};

I can't see how any of the DAPM widgets you specify will ever work with
no interconnections.

> +
> +static int snd_card_codec_reg_read(struct ml26124_priv *priv,
> +				   unsigned char reg, unsigned char *val)
> +{
> +	unsigned char data;
> +	struct i2c_client *i2c;

Use the standard register access code, don't open code things in your
driver unless there's a good reason to.  Current best practice for most
I2C or SPI devices is to use regmap, see any recently added driver for
examples.

> +static int snd_card_codec_set(int number, struct ml26124_priv *priv)
> +{

Namespacing - this isn't a generic ALSA or ASoC function.

> +	unsigned char data;
> +	unsigned int rate = priv->rate;
> +	unsigned int channels = priv->ch;
> +
> +	snd_card_codec_reg_read(priv, 0x30, &data);	 /* Read MICVIAS Voltage */
> +
> +	snd_card_codec_reg_write(priv, 0x10, 0x01);	/* soft reset assert */
> +	snd_card_codec_reg_write(priv, 0x10, 0x00);	/* soft reset negate */
> +
> +	snd_card_codec_reg_write(priv, 0x0c, 0x00);	/* Stop clock  */ 

Use snd_soc_update_bits() and the other standard register access
functions.

> +	switch (rate) {
> +	case 16000:
> +		snd_card_codec_reg_write(priv, 0x00, 0x03);
> +		snd_card_codec_reg_write(priv, 0x02, 0x0c);
> +		snd_card_codec_reg_write(priv, 0x04, 0x00);
> +		snd_card_codec_reg_write(priv, 0x06, 0x20);
> +		snd_card_codec_reg_write(priv, 0x08, 0x00);
> +		snd_card_codec_reg_write(priv, 0x0a, 0x04);
> +		break;

This sort of magic number based code without even registers being named
isn't really of the standard required for maintainability or review.

> +	default:
> +		pr_err("%s:this rate is no support for ml26124\n", __func__);
> +		break;
> +	}

If the driver has detected an error it should return an error; printing
the rate that was requested as part of the error message would also be
useful.

> +	snd_card_codec_reg_write(priv, 0x64, 0x00); /* master/slave set slave */

This looks like it should be in set_dai_fmt().

> +
> +	snd_card_codec_reg_write(priv, 0x20, 0x02); /* VMID on. normal mode */
> +	msleep(50);

This and much of the code looks like it should be in set_bias_level().

> +	snd_card_codec_reg_write(priv, 0x26, 0x1f); /* Speaker Amplified Poer Management */
> +	snd_card_codec_reg_write(priv, 0x28, 0x02); /* LOUT Control Regsister */
> +
> +	snd_card_codec_reg_write(priv, 0x54, 0x02); /* Speaker Amplifier output Control */
> +	snd_card_codec_reg_write(priv, 0x5a, 0x00); /* Mic Interface Control Register */

This looks awfully like it's supposed to be DAPM.

> +static int ml26124_hw_params(struct snd_pcm_substream *substream,
> +			    struct snd_pcm_hw_params *hw_params,
> +			    struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +
> +	if (snd_card_codec_set(substream->number, priv))
> +		return -1;

Return real error codes if you're going to detect errors.

> +
> +	return snd_pcm_lib_malloc_pages(substream,
> +					params_buffer_bytes(hw_params));

Why is a CODEC driver allocing memory to buffer audio?

> +static int ml26124_pcm_prepare(struct snd_pcm_substream *substream,
> +			      struct snd_soc_dai *dai)
> +{
> +	return 0;
> +}

Remove empty functions.

> +static int ml26124_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +
> +	if (mute)
> +		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
> +					 DVOL_CTL_DVMUTE_ON);
> +	else
> +		snd_card_codec_reg_write(priv, ML26124_DVOL_CTL,
> +					 DVOL_CTL_DVMUTE_OFF);

I suspect you mean to use snd_soc_update_bits() here.

> +static int ml26124_set_bias_level(struct snd_soc_codec *codec,
> +		enum snd_soc_bias_level level)
> +{
> +	struct ml26124_priv *priv = snd_soc_codec_get_drvdata(codec);
> +
> +	switch (level) {
> +	case SND_SOC_BIAS_ON:
> +	case SND_SOC_BIAS_PREPARE:
> +	case SND_SOC_BIAS_STANDBY:
> +		snd_card_codec_reg_write(priv, ML26124_REF_PM, REF_PM_VMID_ON);
> +		msleep(50);
> +		snd_card_codec_reg_write(priv, ML26124_REF_PM,
> +					 REF_PM_VMID_ON | REF_PM_MICBEN);

This looks much more like what I'd expect in terms of coding style -
meaingful defines and use of set_bias_level().  Also note that during
audio startup you'll transition STANDBY->PREPARE->ON and the reverse on
shutdown, I really don't think you want to be doing this for anything
except STANDBY.

I also can't see how this will play nicely with the above register write
sequence - you probably want to just remove the register write sequence.

> +static int ml26124_probe(struct snd_soc_codec *codec)
> +{
> +	snd_soc_add_controls(codec, ml26124_snd_controls,
> +			     ARRAY_SIZE(ml26124_snd_controls));
> +
> +	snd_soc_dapm_new_controls(codec, ml26124_dapm_widgets,
> +				  ARRAY_SIZE(ml26124_dapm_widgets));

Initialise these from your codec driver structure.

> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +static __devinit int ml26124_i2c_probe(struct i2c_client *i2c,
> +				      const struct i2c_device_id *id)

Since there's no visible SPI support just unconditionally use I2C.

> +static struct i2c_driver ml26124_i2c_driver = {
> +	.driver = {
> +		.name = "ml26124-codec",

Remove the -codec, it's redundant.
