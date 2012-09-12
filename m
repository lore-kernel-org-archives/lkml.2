Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab2ILC5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:57:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2ILC5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:57:19 -0400
Date: Wed, 12 Sep 2012 10:57:10 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
Message-ID: <20120912025709.GD9162@opensource.wolfsonmicro.com>
References: <1347375823.12329.14.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347375823.12329.14.camel@matrix>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 08:33:43PM +0530, Ashish Chavan wrote:

> +/* LDO voltage level value */
> +static const char * const da9055_ldo_lvl_select_txt[] = {
> +	"1.05V", "1.1V", "1.2V", "1.4V"
> +};

> +static const struct soc_enum da9055_ldo_lvl_select =
> +	SOC_ENUM_SINGLE(DA9055_LDO_CTRL, 4, 4, da9055_ldo_lvl_select_txt);

There's a regulator API, if configuration is required we should be using
that.

> +/* Digital MIC clock rate select */
> +static const char * const da9055_dmic_clk_rate_txt[] = {
> +	"3MHz", "1.5MHz"
> +};
> +
> +static const struct soc_enum da9055_dmic_clk_rate =
> +	SOC_ENUM_SINGLE(DA9055_MIC_CONFIG, 2, 2, da9055_dmic_clk_rate_txt);
> +
> +/* Digital MIC sample phase select */
> +static const char * const da9055_dmic_phase_txt[] = {
> +	"Sample on DMICCLK edges", "Sample between DMICCLK edges"
> +};
> +
> +static const struct soc_enum da9055_dmic_phase =
> +	SOC_ENUM_SINGLE(DA9055_MIC_CONFIG, 1, 2, da9055_dmic_phase_txt);
> +
> +/* Digital MIC channel select */
> +static const char * const da9055_dmic_channel_select_txt[] = {
> +	"Rising Left Falling Right", "Falling Left Rising Right"
> +};

Why is any of this being exposed to userspace?  If this should be
configured I'd expect it to be static platform data, not something that
gets changed at runtime.

> +/* MIC bias voltage level select */
> +static const char * const da9055_mic_bias_level_txt[] = {
> +	"1.6V", "1.8V", "2.1V", "2.2V"
> +};

Again, why is this being exposed to userspace/  I'm fairly sure we went
through similar stuff with your last driver...

> +	SOC_DOUBLE_R_TLV("HeadPhone Volume",
> +			 DA9055_HP_L_GAIN, DA9055_HP_R_GAIN,
> +			 0, 0x3f, 0, hp_vol_tlv),

Headphone.

> +	/* Mute controls */
> +	SOC_DOUBLE_R("Mic Mute Switch", DA9055_MIC_L_CTRL,
> +		     DA9055_MIC_R_CTRL, 6, 1, 0),
> +	SOC_DOUBLE_R("Aux Mute Switch", DA9055_AUX_L_CTRL,
> +		     DA9055_AUX_R_CTRL, 6, 1, 0),
> +	SOC_DOUBLE_R("Mixin PGA Mute Switch", DA9055_MIXIN_L_CTRL,
> +		     DA9055_MIXIN_R_CTRL, 6, 1, 0),
> +	SOC_DOUBLE_R("ADC Mute Switch", DA9055_ADC_L_CTRL,
> +		     DA9055_ADC_R_CTRL, 6, 1, 0),
> +	SOC_DOUBLE_R("HeadPhone Mute Switch", DA9055_HP_L_CTRL,
> +		     DA9055_HP_R_CTRL, 6, 1, 0),
> +	SOC_SINGLE("Lineout Mute Switch", DA9055_LINE_CTRL, 6, 1, 0),
> +	SOC_SINGLE("DAC Soft Mute Switch", DA9055_DAC_FILTERS5, 7, 1, 0),

No "Mute".  Again, I'm fairly sure we had the same issue last time.

> +	/* LDO control */
> +	SOC_SINGLE("LDO Enable", DA9055_LDO_CTRL, 7, 1, 0),
> +	SOC_ENUM("LDO Level Select", da9055_ldo_lvl_select),

The LDO enable should absolutely not be being exposed to userspace!

> +	/* DMIC controls */
> +	SOC_DOUBLE_R("DMIC Enable", DA9055_MIXIN_L_SELECT,
> +		     DA9055_MIXIN_R_SELECT, 7, 1, 0),

Switch if this is a mute.

> +	/* MIC PGA input selection controls */
> +	SOC_ENUM("Mic Left Input Select", da9055_mic_l_select),
> +	SOC_ENUM("Mic Right Input Select", da9055_mic_r_select),

DAPM.

> +
> +	/* ALC Controls */
> +	SOC_DOUBLE_EXT("ALC Enable", DA9055_ALC_CTRL1, 3, 7, 1, 0,
> +		       snd_soc_get_volsw, da9055_put_alc_sw),

ALC Switch.  All enable controls should be switches.

> +static int da9055_hw_params(struct snd_pcm_substream *substream,
> +			    struct snd_pcm_hw_params *params,
> +			    struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct da9055_priv *da9055 = snd_soc_codec_get_drvdata(codec);
> +	u8 aif_ctrl, fs;
> +	u32 sysclk;
> +
> +	/* Set AIF source to Left and Right ADC */
> +	snd_soc_write(codec, DA9055_DIG_ROUTING_AIF,
> +		      DA9055_AIF_L_SRC | DA9055_AIF_R_SRC);

This should be in DAPM.

> +	aif_ctrl = snd_soc_read(codec, DA9055_AIF_CTRL) & 0xf3;

Use snd_soc_update_bits() later on.

> +	aif_ctrl |= (DA9055_AIF_OE | DA9055_AIF_EN);

DAPM.

> +	/* In slave mode, there is only one set of divisors */
> +	if (!da9055->master)
> +		fout = 2822400;

Should check the user supplied this value - also, what happens if the
user sets the device to slave mode after setting up the PLL?

> +	/* Enable VMID reference & master bias */
> +	snd_soc_write(codec, DA9055_REFERENCES,
> +		      DA9055_VMID_EN | DA9055_BIAS_EN);

set_bias_level()

> +	/* Enable Mic Bias */
> +	snd_soc_write(codec, DA9055_MIC_BIAS_CTRL, DA9055_MIC_BIAS_EN);

DAPM for this and most of the rest of this funciton.

> +	da9055->regmap = regmap_init_i2c(i2c, &da9055_regmap_config);

devm_regmap_init_i2c()
