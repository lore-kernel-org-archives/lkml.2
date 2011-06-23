Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab1FWBiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:38:14 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62188 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537Ab1FWBiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:38:12 -0400
Message-ID: <4E0298A7.9030802@metafoo.de>
Date: Thu, 23 Jun 2011 03:36:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/4] ASoC: Add ADAV80x codec driver
References: <1308776997-12959-1-git-send-email-lars@metafoo.de> <20110623012119.GC20949@opensource.wolfsonmicro.com>
In-Reply-To: <20110623012119.GC20949@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 03:21 AM, Mark Brown wrote:
> On Wed, Jun 22, 2011 at 11:09:54PM +0200, Lars-Peter Clausen wrote:
> 
>> diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
>> new file mode 100644
>> index 0000000..d2f3d08
> 
> This needs adding to MAINTAINERS.

Done in patch 3 of this series, but I can merge it into this one.

>> +	if (adav80x->deemph) {
>> +		switch (adav80x->rate) {
>> +		case 0:
>> +			val = ADAV80X_DAC_CTRL2_DEEMPH_NONE;
>> +			break;
>> +		case 32000:
>> +			val = ADAV80X_DAC_CTRL2_DEEMPH_32;
>> +			break;
>> +		case 44100:
>> +			val = ADAV80X_DAC_CTRL2_DEEMPH_44;
>> +			break;
>> +		case 48000:
>> +		default:
>> +			val = ADAV80X_DAC_CTRL2_DEEMPH_48;
>> +			break;
> 
> Really?  I'd have expected a check for the closest matching rate (which
> would get 32k for most low rates) or a requirement for an exact match.

Since the codec supports 32k, 44.1k, 48k, 64k, 48.2k and 96k this will select
the closest match.

> 
>> +	if (freq_out) {
> 
>> +	} else	{
>> +		if (adav80x->clk_src == new_src)
>> +			return 0;
>> +
>> +		adav80x->clk_src = new_src;
>> +
>> +		if (new_src == ADAV80X_CLK_XIN) {
>> +			/* DAC, ADC, ICLK clock source - XIN */
>> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x00);
>> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x00);
>> +		} else {
>> +			/* DAC, ADC, ICLK clock source - MCLKI */
>> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x25);
>> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x01);
>> +		}
>> +
>> +		pll_ctrl1 |= ADAV80X_PLL_CTRL1_PLL1PD;
>> +		snd_soc_write(codec, ADAV80X_PLL_CTRL1, pll_ctrl1);
> 
> What's this doing?  Setting the PLL output to zero means stop the PLL.

That's exactly what's it doing. Switching to an external clock and powering the
PLL down. Or what do you mean?

> 
>> +/* Enforce the same sample rate on all audio interfaces */
>> +static int adav80x_dai_startup(struct snd_pcm_substream *substream,
>> +	struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct adav80x *adav80x = snd_soc_codec_get_drvdata(codec);
>> +
>> +	if (!codec->active || !adav80x->rate)
>> +		return 0;
>> +
>> +	return snd_pcm_hw_constraint_minmax(substream->runtime,
>> +			SNDRV_PCM_HW_PARAM_RATE, adav80x->rate, adav80x->rate);
>> +}
> 
> This means playback and capture should always run at the same rate so...
> 
>> +static struct snd_soc_dai_driver adav80x_dais[] = {
>> +	{
> 
> ...the DAI should flag symmetric_rates, even if only for completeness.

I had it there first, but removed it since it would mean doing the same work twice.

> 
>> +static int adav80x_resume(struct snd_soc_codec *codec)
>> +{
>> +	return adav80x_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
>> +}
> 
> This doesn't appear to restore the register cache, nor does
> set_bias_level().

The register contents is not lost unless we'd cut external power, but I could
add restoring for completeness.
