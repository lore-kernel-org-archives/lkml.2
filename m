Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2BJQZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:25:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab2BJQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:25:15 -0500
Date: Fri, 10 Feb 2012 16:25:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi or
 simliar devices
Message-ID: <20120210162512.GF6472@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-6-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrJd9p1Ce66CJMxE"
Content-Disposition: inline
In-Reply-To: <1328856038-21912-6-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mrJd9p1Ce66CJMxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 03:40:38PM +0900, MyungJoo Ham wrote:
> External connector devices that decides connection information based on
> ADC values may use adc-jack device driver. The user simply needs to
> provide a table of adc range and connection states. Then, extcon
> framework will automatically notify others.

This really should be done in terms of the IIO in-kernel framework.

> +	/* Check the length of array and set num_cables */
> +	for (i = 0; data->edev.supported_cable[i]; i++)
> +		;
> +	if (i == 0 || i > SUPPORTED_CABLE_MAX) {

Can we not avoid the hard limit?

> +	/* Check the length of array and set num_conditions */
> +	for (i = 0; data->adc_condition[i].state; i++)
> +		;
> +	data->num_conditions = i;

It'd seem nicer to just specify the length in the parameters, less error
prone.

> +	if (pdata->irq) {
> +		data->irq = pdata->irq;
> +
> +		err = request_threaded_irq(data->irq, NULL,
> +					   adc_jack_irq_thread,
> +					   pdata->irq_flags, pdata->name,
> +					   data);

Since all this does is schedule a delayed work there's no reason to
bother with a threaded IRQ and this could be request_any_context_irq().

> +	err = extcon_dev_register(&data->edev, &pdev->dev);
> +	if (err)
> +		goto err_irq;

What happens if the interrupt fires prior to this...

> +	data->ready = true;

...ah, that's what this is about.  It'd seem cleaner to just reverse the
request and registration.

> +	goto out;

More idiomatic to have a return statement here.

> +static int __devexit adc_jack_remove(struct platform_device *pdev)
> +{
> +	struct adc_jack_data *data = platform_get_drvdata(pdev);
> +
> +	extcon_dev_unregister(&data->edev);
> +	if (data->irq)
> +		free_irq(data->irq, data);

The interrupt needs to be freed prior to the device unregistration
otherwise they may race.

> +static int __init adc_jack_init(void)
> +{
> +	return platform_driver_register(&adc_jack_driver);
> +}
> +
> +static void __exit adc_jack_exit(void)
> +{
> +	platform_driver_unregister(&adc_jack_driver);
> +}

module_platform_driver().

> +	unsigned long handling_delay; /* in jiffies */

I'd suggest calling this "debounce" instead, it seems more idiomatic.

--mrJd9p1Ce66CJMxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNUThAAoJEBus8iNuMP3dO40P/j1Yk7bHsuusJPzgAFrG0u2M
f5IuwgZcZT6ax486tnETlavbHHRURD2LSHj7d+zrsOKQaa+2iuoFYX0sZZkMk0SL
VfdFZNutDtpxum7zrwRtb2fS/EPnNtPUv7wBNlKmI14HKapXzJGojJNGsE9/v/iP
oIDcHVvHwZwIwWjOt67SQQDIG9w4Rd6JOcX8aphOI3tn4lD7pPjkNTFmKn/NEZ/V
OL7BcZZHgfoeDmsJeSQWRLkf5PZ6y7rYvmNkoWM8QhDpZoJKIFij8bLV8oi0Ef6j
USD2Abm1ZYzEHUoPqVvSd9AwV1Z+kzCymKw60svBovW9VFw934bI19TEi/iudCt/
k1fMnkkEp986vZ6oC+QtREBRqChO2kBwQzQ+rbRnACDdj47sxRMhGUdO+UpXhWCQ
ICkma/+1GgSuAzPJ+YkWv1/PeRgFYysQPOnrPS/5Nea3rx4BzJgzeyOaXh/Jow2s
OnMohdckG1AqJDaLbot7I2DGFtDzytd9pG+RXLx88G2uahIDZdaXMiXVKdRuyYZE
MyLtmUIvKnmEDTYH+rv9GtLJQ13ueQnb82qtj+kULjOUS5dhYRGYm502Ke/ysRIa
ve0Of5s5XHmbWZ3dF4lXdXBD1dbXW9YAAthZbM/7sKebtRSczH0IEcxrpThiE5/3
qeVlZiuInW2z1I9JCQEf
=NSLZ
-----END PGP SIGNATURE-----

--mrJd9p1Ce66CJMxE--
