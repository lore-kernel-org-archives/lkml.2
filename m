Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab1FWB4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:56:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40946 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754341Ab1FWB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:56:52 -0400
Date: Thu, 23 Jun 2011 02:56:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/4] ASoC: Add ADAV80x codec driver
Message-ID: <20110623015648.GA21340@opensource.wolfsonmicro.com>
References: <1308776997-12959-1-git-send-email-lars@metafoo.de>
 <20110623012119.GC20949@opensource.wolfsonmicro.com>
 <4E0298A7.9030802@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0298A7.9030802@metafoo.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 03:36:39AM +0200, Lars-Peter Clausen wrote:
> On 06/23/2011 03:21 AM, Mark Brown wrote:

> >> +	if (adav80x->deemph) {
> >> +		switch (adav80x->rate) {
> >> +		case 0:
> >> +			val = ADAV80X_DAC_CTRL2_DEEMPH_NONE;
> >> +			break;
> >> +		case 32000:
> >> +			val = ADAV80X_DAC_CTRL2_DEEMPH_32;
> >> +			break;
> >> +		case 44100:
> >> +			val = ADAV80X_DAC_CTRL2_DEEMPH_44;
> >> +			break;
> >> +		case 48000:
> >> +		default:
> >> +			val = ADAV80X_DAC_CTRL2_DEEMPH_48;
> >> +			break;

> > Really?  I'd have expected a check for the closest matching rate (which
> > would get 32k for most low rates) or a requirement for an exact match.

> Since the codec supports 32k, 44.1k, 48k, 64k, 48.2k and 96k this will select
> the closest match.

It'd be better to write the code to say that.

> >> +	} else	{
> >> +		if (adav80x->clk_src == new_src)
> >> +			return 0;
> >> +
> >> +		adav80x->clk_src = new_src;
> >> +
> >> +		if (new_src == ADAV80X_CLK_XIN) {
> >> +			/* DAC, ADC, ICLK clock source - XIN */
> >> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x00);
> >> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x00);
> >> +		} else {
> >> +			/* DAC, ADC, ICLK clock source - MCLKI */
> >> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL1, 0x25);
> >> +			snd_soc_write(codec, ADAV80X_ICLK_CTRL2, 0x01);
> >> +		}
> >> +
> >> +		pll_ctrl1 |= ADAV80X_PLL_CTRL1_PLL1PD;
> >> +		snd_soc_write(codec, ADAV80X_PLL_CTRL1, pll_ctrl1);

> > What's this doing?  Setting the PLL output to zero means stop the PLL.

> That's exactly what's it doing. Switching to an external clock and powering the
> PLL down. Or what do you mean?

It really doesn't look like that - if it were just stopping the PLL it'd
not need to look at the clock source selection.  Perhaps some of this
should be in set_sysclk()?

> >> +static int adav80x_resume(struct snd_soc_codec *codec)
> >> +{
> >> +	return adav80x_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> >> +}

> > This doesn't appear to restore the register cache, nor does
> > set_bias_level().

> The register contents is not lost unless we'd cut external power, but I could
> add restoring for completeness.

Cutting external power is the sort of thing that one would expect to
happen over suspend on most systems, especially power sensitive ones.
