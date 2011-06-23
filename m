Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1FWBVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:21:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50061 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758406Ab1FWBVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:21:22 -0400
Date: Thu, 23 Jun 2011 02:21:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/4] ASoC: Add ADAV80x codec driver
Message-ID: <20110623012119.GC20949@opensource.wolfsonmicro.com>
References: <1308776997-12959-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308776997-12959-1-git-send-email-lars@metafoo.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:09:54PM +0200, Lars-Peter Clausen wrote:

> diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
> new file mode 100644
> index 0000000..d2f3d08

This needs adding to MAINTAINERS.

> +static const struct soc_enum adav80x_mux_enum[] = {
> +	ADAV80X_MUX_ENUM(ADAV80X_DPATH_CTRL1, 0),
> +	ADAV80X_MUX_ENUM(ADAV80X_DPATH_CTRL1, 3),
> +	ADAV80X_MUX_ENUM(ADAV80X_DPATH_CTRL2, 3),
> +};

No, don't use arrays...

> +static const struct snd_kcontrol_new adav80x_mux_ctrl[] = {
> +	SOC_DAPM_VALUE_ENUM("Route", adav80x_mux_enum[0]),
> +	SOC_DAPM_VALUE_ENUM("Route", adav80x_mux_enum[1]),
> +	SOC_DAPM_VALUE_ENUM("Route", adav80x_mux_enum[2]),
> +};

...since referencing them is so error prone...

> +#define ADAV80X_MUX(name, num) \
> +	SND_SOC_DAPM_VALUE_MUX(name, SND_SOC_NOPM, 0, 0, &adav80x_mux_ctrl[num])

...and illegible due to the magic numbers.

> +	if (adav80x->deemph) {
> +		switch (adav80x->rate) {
> +		case 0:
> +			val = ADAV80X_DAC_CTRL2_DEEMPH_NONE;
> +			break;
> +		case 32000:
> +			val = ADAV80X_DAC_CTRL2_DEEMPH_32;
> +			break;
> +		case 44100:
> +			val = ADAV80X_DAC_CTRL2_DEEMPH_44;
> +			break;
> +		case 48000:
> +		default:
> +			val = ADAV80X_DAC_CTRL2_DEEMPH_48;
> +			break;

Really?  I'd have expected a check for the closest matching rate (which
would get 32k for most low rates) or a requirement for an exact match.

> +	if (freq_out) {

> +	} else	{
> +		if (adav80x->clk_src == new_src)
> +			return 0;
> +
> +		adav80x->clk_src = new_src;
> +
> +		if (new_src == ADAV80X_CLK_XIN) {
> +			/* DAC, ADC, ICLK clock source - XIN */
> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x00);
> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x00);
> +		} else {
> +			/* DAC, ADC, ICLK clock source - MCLKI */
> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x25);
> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x01);
> +		}
> +
> +		pll_ctrl1 |= ADAV80X_PLL_CTRL1_PLL1PD;
> +		snd_soc_write(codec, ADAV80X_PLL_CTRL1, pll_ctrl1);

What's this doing?  Setting the PLL output to zero means stop the PLL.

> +/* Enforce the same sample rate on all audio interfaces */
> +static int adav80x_dai_startup(struct snd_pcm_substream *substream,
> +	struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
> +
> +	if (!codec->active || !adav80x->rate)
> +		return 0;
> +
> +	return snd_pcm_hw_constraint_minmax(substream->runtime,
> +			SNDRV_PCM_HW_PARAM_RATE, adav80x->rate, adav80x->rate);
> +}

This means playback and capture should always run at the same rate so...

> +static struct snd_soc_dai_driver adav80x_dais[] = {
> +	{

...the DAI should flag symmetric_rates, even if only for completeness.

> +static int adav80x_resume(struct snd_soc_codec *codec)
> +{
> +	return adav80x_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> +}

This doesn't appear to restore the register cache, nor does
set_bias_level().
