Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2ALSxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 13:53:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37638 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2ALSxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 13:53:04 -0500
Date: Thu, 12 Jan 2012 18:52:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <David@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel]  [PATCH] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120112185257.GB9661@sirena.org.uk>
References: <1326371061.17726.30.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326371061.17726.30.camel@matrix>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 05:54:21PM +0530, Ashish Chavan wrote:

> Hi,

Remember this is a changelog...

> +/**
> + * da7210_set_dai_clkdiv: Set codec input clock divider
> + * @param codec_dai	: pointer to codec DAI
> + * @param div_id	: DA7210 has only one clk_div, so div_id is always zero
> + * @param div		: Divider value (configured via control reg MCLK_RANGE)
> + * @return int		: Zero for success, negative error code for error
> + *
> + */
> +static int da7210_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
> +				 int div_id, int div)

Why does the driver need the machine driver to manually configure clock
dividers?

> +	switch (fref) {
> +	case 12000000:
> +		mclk_offset = 0;
> +		break;

> +	switch (fout) {
> +	case 2822400:
> +		fsdm_offset = 0;
> +		break;

> +	if (da7210->master) {
> +		/* In PLL master mode, use Master mode PLL dividers */
> +		pll_div_offset = (mclk_offset * 2 + fsdm_offset) * 3;
> +		pll_div1 = da7210_pll_master_div[pll_div_offset];
> +		pll_div2 = da7210_pll_master_div[pll_div_offset + 1];
> +		pll_div3 = da7210_pll_master_div[pll_div_offset + 2];

This isn't great, you're indexing into a table of divisors using raw
numeric constants in a totally separate part of the code.  Worse, these
constants aren't even directly used but have a calculation applied to 
them apparently because this is really a multi dimensional array.  This
isn't great for either legibility or robustness.

Fix this to remove the use of magic numbers, for example by putting
fout and fref into the table and searching for them.
