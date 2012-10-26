Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2JZGy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:54:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44008 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2JZGy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:54:26 -0400
Date: Fri, 26 Oct 2012 09:48:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <arnd@arndb.de>, <olof@lixom.net>, <rdunlap@xenotime.net>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121026064829.GB22206@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1349675983-23803-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2012 at 11:29:41AM +0530, Kishon Vijay Abraham I wrote:
> ocp2scp was not having pdata support which makes *musb* fail for non-dt
> boot in OMAP platform. The pdata will have information about the devices
> that is connected to ocp2scp. ocp2scp driver will now make use of this
> information to create the devices that is attached to ocp2scp.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/bus/omap-ocp2scp.c                 |   67 ++++++++++++++++++++++=
++++--
>  include/linux/platform_data/omap_ocp2scp.h |   31 +++++++++++++
>  2 files changed, 95 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/platform_data/omap_ocp2scp.h
>=20
> diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
> index ff63560..5db8297 100644
> --- a/drivers/bus/omap-ocp2scp.c
> +++ b/drivers/bus/omap-ocp2scp.c
> @@ -22,6 +22,26 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/platform_data/omap_ocp2scp.h>
> +
> +/**
> + * _count_resources - count for the number of resources
> + * @res: struct resource *
> + *
> + * Count and return the number of resources populated for the device tha=
t is
> + * connected to ocp2scp.
> + */
> +static unsigned _count_resources(struct resource *res)
> +{
> +	int cnt	=3D 0;
> +
> +	while (res->start !=3D res->end) {
> +		cnt++;
> +		res++;
> +	}
> +
> +	return cnt;
> +}
> =20
>  static int ocp2scp_remove_devices(struct device *dev, void *c)
>  {
> @@ -34,20 +54,61 @@ static int ocp2scp_remove_devices(struct device *dev,=
 void *c)
> =20
>  static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
>  {
> -	int			ret;
> -	struct device_node	*np =3D pdev->dev.of_node;
> +	int ret;
> +	unsigned res_cnt, i;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct platform_device *pdev_child;
> +	struct omap_ocp2scp_platform_data *pdata =3D pdev->dev.platform_data;
> +	struct omap_ocp2scp_dev *dev;
> =20
>  	if (np) {
>  		ret =3D of_platform_populate(np, NULL, NULL, &pdev->dev);
>  		if (ret) {
> -			dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
> +			dev_err(&pdev->dev,
> +			    "failed to add resources for ocp2scp child\n");
>  			goto err0;
>  		}
> +	} else if (pdata) {
> +		for (i =3D 0, dev =3D *pdata->devices; i < pdata->dev_cnt; i++,
> +		    dev++) {
> +			res_cnt =3D _count_resources(dev->res);
> +
> +			pdev_child =3D platform_device_alloc(dev->drv_name, -1);
> +			if (!pdev_child) {
> +				dev_err(&pdev->dev,
> +				  "failed to allocate mem for ocp2scp child\n");
> +				goto err0;
> +			}
> +
> +			ret =3D platform_device_add_resources(pdev_child,
> +			    dev->res, res_cnt);
> +			if (ret) {
> +				dev_err(&pdev->dev,
> +				 "failed to add resources for ocp2scp child\n");
> +				goto err1;
> +			}
> +
> +			pdev_child->dev.parent	=3D &pdev->dev;
> +
> +			ret =3D platform_device_add(pdev_child);
> +			if (ret) {
> +				dev_err(&pdev->dev,
> +				   "failed to register ocp2scp child device\n");
> +				goto err1;
> +			}
> +		}
> +	} else {
> +		dev_err(&pdev->dev, "OCP2SCP initialized without plat data\n");
> +		return -EINVAL;
>  	}
> +
>  	pm_runtime_enable(&pdev->dev);
> =20
>  	return 0;
> =20
> +err1:
> +	platform_device_put(pdev_child);
> +
>  err0:
>  	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
> =20
> diff --git a/include/linux/platform_data/omap_ocp2scp.h b/include/linux/p=
latform_data/omap_ocp2scp.h
> new file mode 100644
> index 0000000..5c6c393
> --- /dev/null
> +++ b/include/linux/platform_data/omap_ocp2scp.h
> @@ -0,0 +1,31 @@
> +/*
> + * omap_ocp2scp.h -- ocp2scp header file
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __DRIVERS_OMAP_OCP2SCP_H
> +#define __DRIVERS_OMAP_OCP2SCP_H
> +
> +struct omap_ocp2scp_dev {
> +	const char			*drv_name;
> +	struct resource			*res;
> +};
> +
> +struct omap_ocp2scp_platform_data {
> +	int				dev_cnt;
> +	struct omap_ocp2scp_dev		**devices;
> +};
> +#endif /* __DRIVERS_OMAP_OCP2SCP_H */
> --=20
> 1.7.9.5
>=20

--=20
balbi

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQijI9AAoJEIaOsuA1yqRE4A4QAINeOPlSX5Bz2iQOOKt4Ovfi
Fpelp9V4kl4mtq04iaNtG0AF/S3DkyP6z/7jv4gbzrID6zb+bGYzgWW5tPrAl3Km
MRS1dNKG61jH8QaGZyn4mCyTlZdbKmQzdmNSincdrWkipnpZB/Di2M12ajbFCVJo
lScJ9pb6hxHQFEvIhvR+2bxsj8tXvypgZ1JHD+vMx+hqLeUpdTm5m0wT3zjCqDfB
dBGECs/Cwhw3EHWooE2Ko0vzzJINbMS4/KWLfEFoblezpt04Gr5jvyzBMRriDh5F
oR2LusC4xPZVaEd4c46e6Phb4Goba8go/2kAtVfK37ilMNEgWpvuln+Qgxu+815M
N/rOJltt/+I/lAM7yHGQZX4I2xWLGnFidwdCmH8DhDUCAt4tsNfCa8CIh37W21Rr
KVGlFTjCDhM6LvIHjOoiI67SbXvGwDfNz3FMcMznDgCP/CSMcEzlAsMdkX/3uBAO
qNIdIFaybe5ucNLaG/VmOKN5n2ZpHZtVTzz2LrhDuS3BHIWOJry6nsRA36oLq1OQ
Gsb0c7B/sywdhAh72uQ+WJPMU0BC67xtvOgCtg8QUD0NMpsOjpjFOdB7GtRz1N2b
mVeCS4AgEfUwCY2WncLGROpEHzKUjzzydWtIH2UDtx1bs99H19cZHPC5NG6jxA2s
dHW+bqOyVAcnHg4/IcKj
=tBrJ
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
