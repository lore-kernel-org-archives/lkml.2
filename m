Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2I0HyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:54:13 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40880 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab2I0HyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:54:12 -0400
Date: Thu, 27 Sep 2012 10:49:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
Message-ID: <20120927074912.GK12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr6OvWOSyJed8q4v"
Content-Disposition: inline
In-Reply-To: <1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yr6OvWOSyJed8q4v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 10:31:59AM +0300, Andy Shevchenko wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>=20
> This is the PCI part of the DesignWare DMAC driver. The controller is usu=
ally
> used in the Intel hardware such as Medfield.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig       |    9 ++++
>  drivers/dma/Makefile      |    1 +
>  drivers/dma/dw_dmac_pci.c |  126 +++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 136 insertions(+)
>  create mode 100644 drivers/dma/dw_dmac_pci.c
>=20
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index df32537..a5c7f64 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -89,6 +89,15 @@ config DW_DMAC
>  	  Support the Synopsys DesignWare AHB DMA controller.  This
>  	  can be integrated in chips such as the Atmel AT32ap7000.
> =20
> +config DW_DMAC_PCI
> +	tristate "Synopsys DesignWare AHB DMA support (PCI bus)"
> +	depends on PCI
> +	select DW_DMAC
> +	help
> +	  Support the Synopsys DesignWare AHB DMA controller on the platfroms
> +	  that provide it as a PCI device. For example, Intel Medfield has
> +	  integrated this GPDMA controller.
> +
>  config AT_HDMAC
>  	tristate "Atmel AHB DMA support"
>  	depends on ARCH_AT91
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 7428fea..15eef5f 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_FSL_DMA) +=3D fsldma.o
>  obj-$(CONFIG_MPC512X_DMA) +=3D mpc512x_dma.o
>  obj-$(CONFIG_MV_XOR) +=3D mv_xor.o
>  obj-$(CONFIG_DW_DMAC) +=3D dw_dmac.o
> +obj-$(CONFIG_DW_DMAC_PCI) +=3D dw_dmac_pci.o
>  obj-$(CONFIG_AT_HDMAC) +=3D at_hdmac.o
>  obj-$(CONFIG_MX3_IPU) +=3D ipu/
>  obj-$(CONFIG_TXX9_DMAC) +=3D txx9dmac.o
> diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
> new file mode 100644
> index 0000000..b7ad37f
> --- /dev/null
> +++ b/drivers/dma/dw_dmac_pci.c
> @@ -0,0 +1,126 @@
> +/*
> + * PCI driver for the Synopsys DesignWare DMA Controller
> + *
> + * Copyright (C) 2012 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/dw_dmac.h>
> +
> +static struct dw_dma_platform_data pdata =3D {

"pdata" looks like it wants a prefix.

> +	.is_private =3D 1,
> +	.chan_allocation_order =3D CHAN_ALLOCATION_ASCENDING,
> +	.chan_priority =3D CHAN_PRIORITY_ASCENDING,
> +};

This is the same for all of the PCI IDs listed below, looks like it's
best to just add it as platform_data of the dwc_dmac device directly,
rather than passing a pointer to this via driver->data.

> +
> +static int __devinit dw_pci_probe(struct pci_dev *pdev,
> +				  const struct pci_device_id *id)
> +{
> +	struct platform_device *pd;
> +	struct resource r[2];
> +	struct dw_dma_platform_data *driver =3D (void *)id->driver_data;

missing space after the cast... but it looks unnecessary

> +	static int instance;

this could be a IDA instead.

--=20
balbi

--yr6OvWOSyJed8q4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAT4AAoJEIaOsuA1yqREaSMP/0vr8/nCN/7/nG2oxpPTAw0a
UcAbb1go6tHdK4YK2EAzioeqGpXC70+BN/Wo3eRDx1mQv9yh/eU9ZniWIvkiePvl
pAHyBbZadFQ3a2bGjPodhzmh3KJXknydLdMSXY8DjtKmJOFDnOHkob0Jw9rOiqt4
fwTj29VWn4BN0IKBwEHwCUbyYxeXQIKC2DckwWxEGSRk5EKMgcS0HUjFntJ/+Dm3
MHEph7CPx8xVWaqENogkF9S6KZ2OdXe4BAKRUgxBGPWxm+tsgei8w9CgepgBZVyf
zbcuelgO9hiHGxYjpoRfwMn+F8DI4220PvCHAMilrwY82+ViGndKVj8g8sZAHv4J
OS/lHo/cQ9DEFOowc+wkiyG8xsgStMYk8wjTir4pQkiSC8dMb3Vpm/viLjChTX6D
ti72+ApOCnKlKwsxjSsfCN+XeoD8qkvileiXPFAbcw3wfVxqMa0k4pQ2NSe4Sp+N
xhcFiQ9OZ3SXkEPeZOXKGw1zQ9ZOU+NSa7DiQ4G7jNVTx+fFfSQqW5BcpuuBqnhO
SswJ4DcV2kjiLjYC2ktWF+9Yn/jDKgYc+2DHInEj598HyHKLoqX1sZT44PEj9Cwx
jwNy2HMi+HkXA2dbaK094qQlMv35gGaTgCFl8MYMVM/XVeCStKiWFGdXmtPaajnA
EnW3K2GMlbFf25fONBxF
=sMUG
-----END PGP SIGNATURE-----

--yr6OvWOSyJed8q4v--
