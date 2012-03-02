Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2CBQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:39:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43530 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab2CBQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:39:18 -0500
Date: Fri, 2 Mar 2012 16:39:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120302163915.GD6056@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Never reveal your best argument.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 23, 2012 at 02:46:50PM +0900, Tomoya MORINAGA wrote:
> This driver is for LAPIS Semiconductor ML7213 IOH I2S.

I just merged Lars-Peter's dmaengine library code which has been on the
list for a week or so - this should be updated to use that next time
it's posted.  That should save a lot of code from the driver and make
sure it's following best practices for dmaengine use.

> +static struct ioh_i2s_data *i2s_data;
> +static struct ioh_i2s_dma dmadata[MAX_I2S_CH];

Why are these needed, aren't they dynamically allocated by the driver?

> +	case SNDRV_PCM_STREAM_CAPTURE:
> +		offset =\
> +		    ioh_rtd->dma->rx_cur_period * ioh_rtd->dma->period_bytes;

Drop the continuations, line breaks are just whitespace in C outside of
macros and strings.

> +	case SNDRV_PCM_FORMAT_S32_LE:
> +		byte = 24;
> +		break;

That looks wrong...  are you sure you don't support S24_LE or something?

> +		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
> +		case SND_SOC_DAIFMT_NB_NF:
> +			cmn_reg[i] &= ~ML7213I2S_BCLKPOL;
> +			break;
> +		default:
> +			return -EINVAL;

Looking at that code I suspect at least IB_NF is supported too...

> +static int ml7213i2s_dai_set_clkdiv(struct snd_soc_dai *dai,
> +				  int div_id, int div)
> +{

> +	switch (div_id) {
> +	case ML7213IOH_BCLKFS0:

This all looks like BCLK/sample calculations that the driver should
really be able to figure out for itself rather than forcing every user
to replicate the code to do the calculation, calculation in hw_params
would be more normal.

> +#ifdef CONFIG_PM
> +static void ioh_i2s_save_reg_conf(void)

This stuff has exactly one caller, just inline it.  It's also *very*
suspicious that it's not taking an argument specifying the device...

> +#else
> +#define ml7213i2s_soc_suspend NULL
> +#define spdif_soc_resume NULL

Hrm?

> +#ifdef CONFIG_PM
> +	.suspend = ml7213i2s_soc_suspend,
> +	.resume = ml7213i2s_soc_resume,
> +#endif

The whole point with defining the functions to NULL above is to avoid
the ifdef here.

> +static struct platform_driver ioh_i2s_driver_plat = {

> +static struct platform_driver ioh_dai_driver_plat = {

> +static int ioh_i2s_pci_probe(struct pci_dev *pdev,
> +			     const struct pci_device_id *id)

Why are you creating these platform devices?  I don't understand the
function they serve.  The code handling them looks to have quite a few
problems but I'm not clear they should be there in the first place.

> +	rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
> +			 pdev);
> +	if (rv != 0) {
> +		printk(KERN_ERR "Failed to allocate irq\n");
> +		goto out_irq;
> +	}

Are you *sure* you're ready to handle interrupts at this point?

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUPetAAoJEBus8iNuMP3dbmgP/jQ2KO/VGHKo7VZYPKH8RxDU
noq7qYJa7xPGs6N4w/XflVtz6xeMZ+Rl5Vpq0It7tHGr81xYu+F/bNDntFm2wxsv
Q7jjEJ3m6q/GOsiVgIPzoEn0YTs9WKYu2tE90bthumOcOCS6pI9ZsdOAhGsz6yNm
YvDAECyfcDlBq8YnRZetM4pu3XWzf6m2VdATDIG79XjrKVVM5N5VS+YKCZJ0QtKw
Z1oyGpiA9rbc+HtCKZNcza2qJ/FCS5DaKCa82+gh+j3pgvbxs1NZawpFvvT4/1un
nMaCRegEE+r+bIiMeUlk1fQcUpxHtnb2TfZ9fepGLtzHbvk9P5pD2xlz8onSSV93
Aa188eYJAouxwotfVfzCZ1cCdUsvHbOIYCrxyY0t5mzp0oolMgbMZVzNs17dQCOQ
YOIB65rNTAy3KwtFTZmVkl17md8XHrCzmUDXOaDXiu7DizjJnYGY9nshoRR+Wq9t
AoOWfPz9d6LFe+rC1TY37UeaIXgBIJJB9DIw+30gfGNneWIfKblODZUpjbe8iwej
ipod61T/tsR72PRd58yROhMhBzrDxIbvQXQJC4GXsvLxJ5n70k/outb7gOnSxw8m
o5MRnRrp7IXX3NdiVG3mwb7mHSK6etAiv6U6/8pPyD9gC9kA6zmTRUbhcgGvZips
A5309SLK/jIfkHePvfqT
=ns+l
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
