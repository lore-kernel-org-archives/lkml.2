Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1DSKVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:21:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51405 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1DSKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:21:06 -0400
Date: Tue, 19 Apr 2011 12:21:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 4/5] mmc: sdhci: consolidate sdhci-of-esdhc and
 sdhci-esdhc-imx
Message-ID: <20110419102110.GE4164@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Content-Disposition: inline
In-Reply-To: <1301042931-4869-5-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>  config MMC_SDHCI_ESDHC_IMX
> -	bool "SDHCI platform support for the Freescale eSDHC i.MX controller"
> +	bool "SDHCI support for the Freescale eSDHC i.MX controller"
>  	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
>  	depends on MMC_SDHCI
> -	select MMC_SDHCI_PLTFM
> +	select MMC_SDHCI_ESDHC
>  	select MMC_SDHCI_IO_ACCESSORS
>  	help
> -	  This selects the Freescale eSDHC controller support on the platform
> -	  bus, found on platforms like mx35/51.
> +	  This selects the Freescale eSDHC controller support on platforms
> +	  like mx35/51.

While we are at it, mx25 could be added and mx53 (and you know better
what else will be coming ;))

> diff --git a/drivers/mmc/host/sdhci-esdhc.c b/drivers/mmc/host/sdhci-esdh=
c.c
> new file mode 100644
> index 0000000..b3d1bc1
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-esdhc.c
> @@ -0,0 +1,413 @@
> +/*
> + * Freescale eSDHC controller driver for MPCxxx and i.MX.
> + *
> + * Copyright (c) 2007 Freescale Semiconductor, Inc.
> + *   Author: Xiaobo Xie <X.Xie@freescale.com>
> + *
> + * Copyright (c) 2009 MontaVista Software, Inc.
> + *   Author: Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * Copyright (c) 2010 Pengutronix e.K.
> + *   Author: Wolfram Sang <w.sang@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/sdhci-pltfm.h>
> +#ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
> +#include <mach/hardware.h>
> +#endif
> +#include "sdhci.h"
> +#include "sdhci-pltfm.h"
> +
> +/*
> + * Ops and quirks for the Freescale eSDHC controller.
> + */
> +
> +#define ESDHC_DEFAULT_QUIRKS	(SDHCI_QUIRK_FORCE_BLK_SZ_2048 | \
> +				SDHCI_QUIRK_BROKEN_CARD_DETECTION | \
> +				SDHCI_QUIRK_NO_BUSY_IRQ | \
> +				SDHCI_QUIRK_NONSTANDARD_CLOCK | \
> +				SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK | \
> +				SDHCI_QUIRK_PIO_NEEDS_DELAY | \
> +				SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET | \
> +				SDHCI_QUIRK_NO_CARD_NO_RESET)

These are not the current quirks. Meanwhile BROKEN_CARD_DETECTION is
gone as well as NO_CARD_NO_RESET (at least for imx). My additions to use
GPIOs for card detect and write protect are also not in this version.

[...]

> +static struct sdhci_pltfm_data sdhci_esdhc_mpc_pdata =3D {
> +	.quirks =3D ESDHC_DEFAULT_QUIRKS,
> +	.ops =3D &sdhci_esdhc_mpc_ops,
> +};
> +#endif

Please mark the #endif with comments of the expression they are
depending on, e.g.

#endif /* CONFIG_MMC_SDHCI_ESDHC_MPC */

if it is not immediately visible. That helps readability.

[...]

Phew, due to all these hardware bugs, the driver will get messy, even if
we try hard. Any chances that future revisions of the core will be
updated? :)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2tYhUACgkQD27XaX1/VRtMpACgvd33e+O/nMFWpnZOp5ptskMF
e0gAmwdL+4iU5R+jV+/AX03kUkcFzXms
=ET2u
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
