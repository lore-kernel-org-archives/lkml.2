Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0F1Kae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:30:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48301 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266Ab0F1Kad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:30:33 -0400
Date: Mon, 28 Jun 2010 11:30:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: DaVinci: Added support for cpu clocking I2S
Message-ID: <20100628103030.GB14247@rakim.wolfsonmicro.main>
References: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277707487-3371-1-git-send-email-lamiaposta71@gmail.com>
X-Cookie: Motorized vehicles only.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 08:44:46AM +0200, Raffaele Recalcati wrote:
> From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

It's still very hard to understand what this patch is supposed to do.
As previously mentioned this would probably be a lot clearer if you
split this into multiple patches, for example one adding support for the
fast clock mode, one adding support for selecting the pin used for any
external clock and then further patches with any other changes.

I strongly suggest looking at the commit messages for other patches in
the kernel and trying to follow a similar style.

>     Added audio playback support with [frame sync master - clock master] mode
>     and with [frame sync master - clock slave].

What are these modes - which clock are you talking about?

>        i2s_fast_clock switch can be used to have better approximate or
>        symmetric waveforms.

Why would someone choose not to use this?

>        clk_input_pin board info can be used to select it depending on hw
>        connections

>     3. We haven't changed the evmdm365 support (due also to CPLD that doesn't
>                                                 help to understand)
>         We don't know in this mode if audio stereo works on evmdm365.
>         Probably it does.

This is what makes me unsure if you're trying to add new modes or not -
if you're adding new modes then I'd expect that existing boards would be
unaffected with any changes to use the new feature being easily
seperable.

> +	/*
> +	 * This define works when both clock and FS are output for the cpu
> +	 * and makes clock very fast (FS is not simmetrical, but sampling

symmetrical.

> +	 * frequency is better approximated
> +	 */
> +	int i2s_fast_clock;

Is this a bool?

> +	/* To be used when cpu gets clock from extenal pin */
> +	int clk_input_pin;
> +

How would one use this?

>  	case SND_SOC_DAIFMT_CBM_CFS:
> -		/* McBSP CLKR pin is the input for the Sample Rate Generator.
> -		 * McBSP FSR and FSX are driven by the Sample Rate Generator. */
> -		pcr = DAVINCI_MCBSP_PCR_SCLKME |
> -			DAVINCI_MCBSP_PCR_FSXM |
> -			DAVINCI_MCBSP_PCR_FSRM;
> +		pcr = DAVINCI_MCBSP_PCR_FSRM | DAVINCI_MCBSP_PCR_FSXM;
> +		if (dev->clk_input_pin == MCBSP_CLKS)
> +			pcr |= DAVINCI_MCBSP_PCR_CLKXM |
> +				DAVINCI_MCBSP_PCR_CLKRM;
> +		else
> +			/*
> +			 * McBSP CLKR pin is the input for the Sample Rate
> +			 * Generator.
> +			 * McBSP FSR and FSX are driven by the Sample Rate
> +			 * Generator.
> +			 */
> +			pcr |= DAVINCI_MCBSP_PCR_SCLKME;

This looks like you need a switch statement for the clock selection.

> +static int davinci_i2s_dai_set_clkdiv(struct snd_soc_dai *cpu_dai,
> +				int div_id, int div)
> +{
> +	struct davinci_mcbsp_dev *dev = cpu_dai->private_data;
> +	int srgr;
> +
> +	dev->clk_div = div;
> +	return 0;
> +}
> +

I would add a clock ID here in case someone wants to configure another
clock in the patch.

> +	if (master == SND_SOC_DAIFMT_CBS_CFS) {

Use a switch staetment for this too.

> +		clk = clk_get(NULL, "pll1_sysclk6");

You're doing a clk_get() every time you go through here but never
freeing it - it would seem better to just do the clk_get() at startup.
I'd also expect this to be doing a clk_get() using the struct device for
the DAI so that the driver can function even if the clock tree for a new
SoC is different.

> +		if (clk)
> +			freq = clk_get_rate(clk);

clk_get() returns an error pointer on error, not NULL, and...

> +		freq = 122000000; /* FIXME ask to Texas */

...this presumably ought to be in an else clause (or perhaps just not
using this clocking at all if you can't find the clock?).

> +	} else if (master == SND_SOC_DAIFMT_CBM_CFS) {
> +		/* Clock given on CLKS */

What if the user selected a different clock source?

> +		if (master == SND_SOC_DAIFMT_CBS_CFS ||
> +				master == SND_SOC_DAIFMT_CBS_CFM) {

Again, switch statement.

> +	if (master == SND_SOC_DAIFMT_CBS_CFS ||
> +			master == SND_SOC_DAIFMT_CBS_CFM) {

Here too.
