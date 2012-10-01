Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab2JAR3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:29:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45553 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JAR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:29:07 -0400
Date: Mon, 1 Oct 2012 18:29:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Add a codec driver for SI476X MFD
Message-ID: <20121001172906.GB25335@sirena.org.uk>
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1347576013-28832-4-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347576013-28832-4-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: Androphobia:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 03:40:13PM -0700, Andrey Smirnov wrote:
> This commit add a sound codec driver for Silicon Laboratories 476x
> series of AM/FM radio chips.

*Always* CC both maintainers and lists on patches.  There's a few
problems here, though none of them terribly substantial.

>  	select SND_SOC_UDA1380 if I2C
>  	select SND_SOC_WL1273 if MFD_WL1273_CORE
> +	select SND_SOC_SI476X if MFD_SI476X_CORE
>  	select SND_SOC_WM1250_EV1 if I2C


Keep the Makefile and Kconfig sorted.

> +struct si476x_codec {
> +	struct si476x_core *core;
> +};

control_data.

> +static int si476x_codec_set_daudio_params(struct snd_soc_codec *codec,
> +					  int width, int rate)
> +{

Just inline this into the one user.

> +	int err;
> +	u16 digital_io_output_format = \
> +		snd_soc_read(codec,
> +			     SI476X_DIGITAL_IO_OUTPUT_FORMAT);

Throughout the driver you're randomly using \ for no visible reason -
don't do that.

> +	if ((rate < 32000) || (rate > 48000)) {
> +		dev_dbg(codec->dev, "Rate: %d is not supported\n", rate);

dev_err.

> +	digital_io_output_format &= SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK;
> +	digital_io_output_format |= (width << 11) | (width << 8);
> +
> +	return snd_soc_write(codec, SI476X_DIGITAL_IO_OUTPUT_FORMAT,
> +			     digital_io_output_format);

snd_soc_update_bits().

> +static int si476x_codec_volume_get(struct snd_kcontrol *kcontrol,
> +				   struct snd_ctl_elem_value *ucontrol)
> +{
> +	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
> +
> +	ucontrol->value.integer.value[0] =
> +		snd_soc_read(codec, SI476X_AUDIO_VOLUME);
> +	return 0;
> +}

Why are you open coding this?  Looks like a standard register...

> +static int si476x_codec_digital_mute(struct snd_soc_dai *codec_dai, int mute)
> +{
> +	if (mute)
> +		snd_soc_write(codec_dai->codec, SI476X_AUDIO_MUTE, 0x3);
> +
> +	return 0;
> +}

This will never disable the mute once it's been activated; are you sure
this code has been tested?

> +	switch (params_format(params)) {
> +	case SNDRV_PCM_FORMAT_S8:
> +		width = SI476X_PCM_FORMAT_S8;
> +	case SNDRV_PCM_FORMAT_S16_LE:

Missing break;

> +static int si476x_codec_probe(struct snd_soc_codec *codec)
> +{
> +	struct si476x_core **core = codec->dev->platform_data;
> +	struct si476x_codec *si476x;
> +
> +	if (!core) {
> +		dev_err(codec->dev, "Platform data is missing.\n");
> +		return -EINVAL;
> +	}

You should use dev->parent to find the parent rather than use platform
data like this.

> +	si476x = kzalloc(sizeof(*si476x), GFP_KERNEL);
> +	if (si476x == NULL) {

devm_kzalloc(), and this should be in the device level probe (as should
the previous check for the core).  Though as the struct ought to be
empty now this'll presumably go away.

> +static int __init si476x_init(void)
> +{
> +	return platform_driver_register(&si476x_platform_driver);
> +}
> +module_init(si476x_init);

module_platform_driver()
