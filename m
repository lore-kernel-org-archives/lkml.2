Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1CXKPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:15:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46333 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754483Ab1CXKPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:15:17 -0400
Date: Thu, 24 Mar 2011 10:15:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Add max98095 CODEC driver
Message-ID: <20110324101514.GA28306@opensource.wolfsonmicro.com>
References: <B2150E1E4418E1438554A300EA5040E40DAC511079@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DAC511079@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 08:57:41PM -0700, Peter Hsiang wrote:
> This patch adds the MAX98095 CODEC driver.
> 
> Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
> 
> Please see the attached patch file 0001-ASoC-Add-max98095-CODEC-driver.patch

Please submit patches in-line rather than as attachments as covered in
SubmittingPatches.

> +	SOC_DOUBLE_R("Headphone Volume", M98095_064_LVL_HP_L,
> +		M98095_065_LVL_HP_R, 0, 31, 0),
> +	SOC_DOUBLE_R("Speaker Volume", M98095_067_LVL_SPK_L,
> +		M98095_068_LVL_SPK_R, 0, 39, 0),
> +	SOC_SINGLE("Receiver Volume", M98095_066_LVL_RCV,
> +		0, 31, 0),
> +	SOC_DOUBLE_R("Lineout Volume", M98095_062_LVL_LINEOUT1,
> +		M98095_063_LVL_LINEOUT2, 0, 31, 0),

> +	SOC_SINGLE("MIC1 Volume", M98095_05F_LVL_MIC1, 0, 31, 1),
> +	SOC_SINGLE("MIC2 Volume", M98095_060_LVL_MIC2, 0, 31, 1),

> +	SOC_SINGLE("Linein Volume", M98095_061_LVL_LINEIN, 0, 7, 1),
> +
> +	SOC_SINGLE("ADCL Volume", M98095_05D_LVL_ADC_L, 0, 15, 0),
> +	SOC_SINGLE("ADCR Volume", M98095_05E_LVL_ADC_R, 0, 15, 0),
> +
> +	SOC_SINGLE("ADCL Boost Volume", M98095_05D_LVL_ADC_L, 4, 3, 0),
> +	SOC_SINGLE("ADCR Boost Volume", M98095_05E_LVL_ADC_R, 4, 3, 0),

No TLV information for these?

> +static int max98095_add_widgets(struct snd_soc_codec *codec)
> +{
> +	struct snd_soc_dapm_context *dapm = &codec->dapm;
> +
> +	snd_soc_dapm_new_controls(dapm, max98095_dapm_widgets,
> +				  ARRAY_SIZE(max98095_dapm_widgets));
> +
> +	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
> +

It'd be better to switch these over to using the the driver structure to
set them up - dapm_widgets in the driver.

> +	/* Configure NI when operating as master */
> +	if (snd_soc_read(codec, M98095_02A_DAI1_FORMAT)
> +		& M98095_DAI_MAS) {

That'd all fit on one line?

> +static void max98095_sync_cache(struct snd_soc_codec *codec)
> +{
> +	struct max98095_priv *max98095 = snd_soc_codec_get_drvdata(codec);
> +	int i;
> +
> +	if (!codec->cache_sync)
> +		return;
> +
> +	codec->cache_only = 0;
> +
> +	/* write back cached values if they're writeable and
> +	 * different from the hardware default.
> +	 */
> +	for (i = 1; i < ARRAY_SIZE(max98095->reg_cache); i++) {
> +		if (!max98095_access[i].writable)
> +			continue;
> +
> +		if (max98095->reg_cache[i] == max98095_reg[i])
> +			continue;
> +
> +		snd_soc_write(codec, i, max98095->reg_cache[i]);
> +	}

The generic snd_soc_cache_sync() should be able to do this for you.

> +	snd_soc_write(codec, M98095_010_HOST_INT_CFG, 0x00);
> +	snd_soc_write(codec, M98095_011_HOST_INT_EN, 0x00);
> +	snd_soc_write(codec, M98095_012_CODEC_INT_EN, 0x00);
> +	snd_soc_write(codec, M98095_013_JACK_INT_EN, 0x00);
> +	snd_soc_write(codec, M98095_014_JACK_INT_EN, 0x00);

Some documentation as to what these are doing would be useful.  Looks
like most of these just disable all interrupts which is fine.

> +	snd_soc_write(codec, M98095_093_BIAS_CTRL, 0xF0);
> +	snd_soc_write(codec, M98095_096_PWR_DAC_CK, 0x3F);
> +
> +	snd_soc_write(codec, M98095_04E_MIX_HP_CFG, 0x30);
> +	snd_soc_write(codec, M98095_092_PWR_EN_OUT, 0x10);
> +	snd_soc_write(codec, M98095_045_DSP_CFG, 0x50);

Similarly for all of these, what are the writes doing?  Some of them
look like they belong in the bais configuration or similar.

> +	snd_soc_update_bits(codec, M98095_097_PWR_SYS, M98095_SHDNRUN,
> +		M98095_SHDNRUN);

This too.
