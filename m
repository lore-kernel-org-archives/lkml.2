Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab2CMXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:09:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760410Ab2CMXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:09:42 -0400
Date: Tue, 13 Mar 2012 23:09:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        Peter Hsiang <cdefgab1288@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: max98095: add jack detection
Message-ID: <20120313230939.GO3177@opensource.wolfsonmicro.com>
References: <1331667848-8168-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1HuzLmPZrG5RH6bG"
Content-Disposition: inline
In-Reply-To: <1331667848-8168-1-git-send-email-rklein@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1HuzLmPZrG5RH6bG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 12:44:08PM -0700, Rhyland Klein wrote:

> This change adds the logic to support using the jack detect mechanism built
> in to the codec to detect both when a jack was inserted and what type of
> jack is present.

This looks mostly good, a few things below.

> @@ -51,6 +52,9 @@ struct max98095_priv {
>  	u8 lin_state;
>  	unsigned int mic1pre;
>  	unsigned int mic2pre;
> +	int irq;

You can just get the irq from the I2C device.

> +	if (max98095->headphone_jack == max98095->mic_jack)
> +		snd_soc_jack_report(max98095->headphone_jack,
> +					hp_report | mic_report,
> +					SND_JACK_HEADSET);
> +	else {

Braces on both sides of the if for clarity.

> +static irqreturn_t max98095_jack_handler(int irq, void *data)
> +{
> +	struct snd_soc_codec *codec = data;
> +	int ret;
> +
> +	ret = max98095_report_jack(codec);
> +
> +	return ret ? IRQ_NONE : IRQ_HANDLED;

There is no point in having a separate function here, this function has
no contents.  Just inline it.  Please also avoid the use of the ternery
operator.

> +	/* configure jack detection: slew is calculated as 4 * (delay + 1)
> +	 * The default is 24 (0x18) to get 100ms delay.
> +	 */
> +	ret = snd_soc_write(codec, M98095_08E_JACK_DC_SLEW,
> +				M98095_DEFAULT_SLEW_DELAY);
> +	if (ret < 0) {
> +		dev_err(codec->dev, "Failed to cfg auto detect %d\n", ret);
> +		return ret;
> +	}

Platform data?

> +	enable_irq(max98095->irq);

You shouldn't be fiddling around with enable_irq() and disable_irq().
Why are you doing this?

--1HuzLmPZrG5RH6bG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9OtAAoJEBus8iNuMP3deCQP/RN1o6j/vjrZf43Y/Nw/iik9
ja5uoUWE7K3AoF0gqIeEm2Qk7RI1lUiKPQiAMGXppJvSlMDr+2kWWJiKejxhGU5W
GLkfDiUAHvfXT4m4r+GPYwTdQPyJF5kX3uQUEd13jEQHz2Mbq/I5646n1d5EQ2T0
KVnCQGlIutqYj1p+j6eHTKS2u8fRwuw1WMJoJr03+VS3b3Uw9C2wu82LmvNN8O0x
GMyiIhwwH/xwNasSeYzO85RKkB8nnmvNWhLK1oZKo6Wux6YWs+iKaBV0E+ZpXheV
sjmvfLnoTXyycZjPxL6Xq6JJAba9yTKermG0kTK/BnFWbEh6FtFHsTE0ejPARjqg
u25+CvtyzHAP0MVUlvgqbWw21fEN0VhtCdQiUCqkw5vnXEQJh4YOwE96gBHdl4Gh
/1ZP5f1Wdbh2xIOLBmGzZCiGl1wM/oaegheNXje6h5u39iD6fc6wxKnCQz7a8moV
jHRxH7o8n8Qs5rSfalXb/HY2P2on5gN3EvcowGftRIgBxbEISei/S9z5h0jUfRY4
kMEPg7YYfmDvLr8V/yVViTLGiJBOZ9yeiT3yNMU3Q7C5R+kAN7iFK5yxnS+qwX4W
uVJur8sLOJk2ymWxbKcfQU5WRG34mHA3UI6cBxVr5CdAL7ChuAbGNIY6s/ntqqQi
wg28OGVf233EG78bk4bD
=fepc
-----END PGP SIGNATURE-----

--1HuzLmPZrG5RH6bG--
