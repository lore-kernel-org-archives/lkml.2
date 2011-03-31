Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1CaMte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:49:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58395 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1CaMtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:49:33 -0400
Date: Thu, 31 Mar 2011 14:49:26 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110331124925.GA2202@pengutronix.de>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1301574600-4861-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
> Support OF support. "generic-uio" compatible property is used.

And exactly this was the issue last time (when I tried). This is a
generic property, which is linux-specific and not describing HW. The
agreement back then was to we probably need to add compatible-entries at
runtime (something like new_id for USB). So the uio-of-driver could be
matched against any device. Otherwise, we would collect a lot of
potential entries like "vendor,special-card1". Although I wonder
meanwhile if it is really going to be that bad; we don't have so much
UIO-driver in tree as well. Maybe worth a try?

> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  drivers/uio/uio_pdrv_genirq.c |   60 +++++++++++++++++++++++++++++++++++=
+++--
>  1 files changed, 57 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 7174d51..9e89806 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -23,6 +23,10 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> =20
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +
>  #define DRIVER_NAME "uio_pdrv_genirq"
> =20
>  struct uio_pdrv_genirq_platdata {
> @@ -92,11 +96,44 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info=
 *dev_info, s32 irq_on)
>  static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  {
>  	struct uio_info *uioinfo =3D pdev->dev.platform_data;
> -	struct uio_pdrv_genirq_platdata *priv;
> +	struct uio_pdrv_genirq_platdata *priv =3D NULL;

unrelated?

>  	struct uio_mem *uiomem;
>  	int ret =3D -EINVAL;
>  	int i;
> =20
> +	if (!uioinfo) {
> +		struct resource r_irq; /* Interrupt resources */
> +		int rc =3D 0;
> +
> +		rc =3D of_address_to_resource(pdev->dev.of_node, 0,
> +							&pdev->resource[0]);
> +		if (rc) {
> +			dev_err(&pdev->dev, "invalid address\n");
> +			goto bad2;
> +		}
> +		pdev->num_resources =3D 1;
> +
> +		/* alloc uioinfo for one device */
> +		uioinfo =3D kzalloc(sizeof(*uioinfo), GFP_KERNEL);
> +		if (!uioinfo) {
> +			ret =3D -ENOMEM;
> +			dev_err(&pdev->dev, "unable to kmalloc\n");
> +			goto bad2;
> +		}
> +		uioinfo->name =3D pdev->dev.of_node->name;
> +		/* Use version for storing full IP name for identification */
> +		uioinfo->version =3D pdev->dev.of_node->full_name;

I don't think this is apropriate, but will leave that to Hans.

> +		/* Get IRQ for the device */
> +		rc =3D of_irq_to_resource(pdev->dev.of_node, 0, &r_irq);
> +		if (rc =3D=3D NO_IRQ)
> +			dev_err(&pdev->dev, "no IRQ found\n");

No error, I think. Sometimes just mmaping the registers is enough.

> +		else {
> +			uioinfo->irq =3D r_irq.start;
> +			dev_info(&pdev->dev, "irq %d\n", (u32)uioinfo->irq);
> +		}
> +	}
> +
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
>  		goto bad0;
> @@ -176,10 +213,15 @@ static int uio_pdrv_genirq_probe(struct platform_de=
vice *pdev)
> =20
>  	platform_set_drvdata(pdev, priv);
>  	return 0;
> - bad1:
> +
> +bad1:

The spaces before labels are intentional, better keep them.

>  	kfree(priv);
>  	pm_runtime_disable(&pdev->dev);
> - bad0:
> +bad0:
> +	/* kfree uioinfo for CONFIG_OF */
> +	if (!pdev->dev.platform_data)
> +		kfree(uioinfo);
> +bad2:
>  	return ret;
>  }
> =20
> @@ -215,6 +257,17 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_p=
m_ops =3D {
>  	.runtime_resume =3D uio_pdrv_genirq_runtime_nop,
>  };
> =20
> +#ifdef CONFIG_OF
> +/* Match table for of_platform binding */
> +static const struct of_device_id __devinitconst uio_of_genirq_match[] =
=3D {
> +	{ .compatible =3D "generic-uio", },
> +	{ /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> +#else
> +# define uio_of_genirq_match NULL
> +#endif
> +
>  static struct platform_driver uio_pdrv_genirq =3D {
>  	.probe =3D uio_pdrv_genirq_probe,
>  	.remove =3D uio_pdrv_genirq_remove,
> @@ -222,6 +275,7 @@ static struct platform_driver uio_pdrv_genirq =3D {
>  		.name =3D DRIVER_NAME,
>  		.owner =3D THIS_MODULE,
>  		.pm =3D &uio_pdrv_genirq_dev_pm_ops,
> +		.of_match_table =3D uio_of_genirq_match,
>  	},
>  };
> =20
> --=20
> 1.5.5.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2UeFUACgkQD27XaX1/VRtdXgCffr1l6ifExt9UH4ROFvyBb9wq
npYAniyu1ReSjswVUCEP5MxUcuT6I8C3
=uAwA
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
