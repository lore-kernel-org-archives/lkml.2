Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1DBI0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 04:26:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57999 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1DBI0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:26:09 -0400
Date: Sat, 2 Apr 2011 09:26:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Prchal Ji?? <jiri.prchal@aksignal.cz>
Cc: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        vbarinov@embeddedalley.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2] ALSA: ASoc: TLV320AIC3X: ad SPI and
	clock on GPIO2 or BCLK
Message-ID: <20110402082604.GE21737@sirena.org.uk>
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B1AFD.5060508@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B1AFD.5060508@aksignal.cz>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:20:45AM +0100, Prchal Ji?? wrote:
> Hi,
> this patch ads SPI communication for codecs TLV320AIC3X and clock input on GPIO2 or BCLK.
> Tested on TLV320AIC3106 and AT91SAM9260.
> TODO: Set the model in SPI probe the right way. I don't know how.

Register two SPI drivers with different names.

> This codec communicates on SPI in 1st byte: 7 MSB is register address, 1 LSB is read/write, 2nd byte data. For this
> reason there is new functions in soc-cache.c snd_soc_7_8_*.

This looks mostly good but there's some cleanups needed, mostly from
extra stuff which snuck in there, and you need to rebase against current
code.

As covered in SubmittingPatches you should always CC maintainers on
patches.

>  config SND_SOC_AD73311
>  	tristate
> -
> +

Random whitespace change, should be removed.

>   * Author:      Vladimir Barinov, <vbarinov@embeddedalley.com>
> + *              Jiri Prchal, <jiri.prchal@aksignal.cz

If you're going to do this you probably want a > in there.

>  {
>  	struct snd_soc_codec *codec = codec_dai->codec;
>  	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
> +	u8 data;
> +
> +	/* set external clock on GPIO2 or BCLK */
> +	data = snd_soc_read(codec, AIC3X_CLKGEN_CTRL_REG);
> +	data &= 0x0f;
> +	data |= ((clk_id << PLLCLK_IN_SHIFT) | (clk_id << CLKDIV_IN_SHIFT));
> +	snd_soc_write(codec, AIC3X_CLKGEN_CTRL_REG, data);

This looks like an unrelated change which is specific to your board.
You should add an interface for configuring this functionality .

>  	if (ret != 0) {
> -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> +		dev_err(codec->dev, "failed to set cache I/O: %d\n", ret);

Why are you decapitalising th estart of the sentance here?

> +static struct spi_driver aic3x_spi_driver = {
> +	.driver = {
> +		.name	= "tlv320aic3x-codec",
> +		.owner	= THIS_MODULE,

Remove the -codec from the driver name.

> +/* special functions for codecs with 7 bit register address and LSB read/write (like TLV320AIC3X) */
> +static unsigned int snd_soc_7_8_read(struct snd_soc_codec *codec,
> +				     unsigned int reg)
> +{
> +	int ret;
> +	unsigned int val;

This won't apply against the current kernel and should be a separate
patch, it's a generic thing rather than part of the CODEC driver.
