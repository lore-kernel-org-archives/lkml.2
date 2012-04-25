Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2DYL1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:27:14 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:52339 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758690Ab2DYL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:26:38 -0400
Date: Wed, 25 Apr 2012 14:25:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Message-ID: <20120425112519.GB3564@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 25, 2012 at 02:07:36PM +0300, Hiroshi DOYU wrote:
> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> High-performance Bus (AHB) architecture.
>=20
> The AHB Arbiter controls AHB bus master arbitration. This effectively
> forms a second level of arbitration for access to the memory
> controller through the AHB Slave Memory device. The AHB pre-fetch
> logic can be configured to enhance performance for devices doing
> sequential access. Each AHB master is assigned to either the high or
> low priority bin. Both Tegra20/30 have this AHB bus.
>=20
> Some of configuration param could be passed from DT too.
>=20
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> v4:
> Fixed the comments from Felipe/Russell.
> This is now located under drivers/platform/arm.
> v3:
> Use platform_device to get info from dt dynamically.(Felipe/Arnd)
>=20
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Just one thing, you seem to have missed Russell's comment about this
driver being generic. You still add a TEGRA_AHB driver, also, you don't
need <mach/iomap.h>. Apart from those, you can add:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/platform/Kconfig         |    5 +
>  drivers/platform/Makefile        |    1 +
>  drivers/platform/arm/Kconfig     |    8 +
>  drivers/platform/arm/Makefile    |    5 +
>  drivers/platform/arm/tegra-ahb.c |  278 ++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 297 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
> index 8390dca..8b96a77 100644
> --- a/drivers/platform/Kconfig
> +++ b/drivers/platform/Kconfig
> @@ -1,3 +1,8 @@
>  if X86
>  source "drivers/platform/x86/Kconfig"
>  endif
> +
> +if ARM
> +source "drivers/platform/arm/Kconfig"
> +endif
> +
> diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
> index 782953a..7a2b16f 100644
> --- a/drivers/platform/Makefile
> +++ b/drivers/platform/Makefile
> @@ -3,3 +3,4 @@
>  #
> =20
>  obj-$(CONFIG_X86)		+=3D x86/
> +obj-$(CONFIG_ARM)		+=3D arm/
> diff --git a/drivers/platform/arm/Kconfig b/drivers/platform/arm/Kconfig
> new file mode 100644
> index 0000000..0af31db
> --- /dev/null
> +++ b/drivers/platform/arm/Kconfig
> @@ -0,0 +1,8 @@
> +config TEGRA_AHB
> +	bool "Enable AHB driver for NVIDIA Tegra SoCs"
> +	depends on ARCH_TEGRA
> +	default y
> +	help
> +	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
> +	  which controls AHB bus master arbitration and some
> +	  perfomance parameters(priority, prefech size).
> diff --git a/drivers/platform/arm/Makefile b/drivers/platform/arm/Makefile
> new file mode 100644
> index 0000000..3535f56
> --- /dev/null
> +++ b/drivers/platform/arm/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for linux/drivers/platform/arm
> +# ARM Platform-Specific Drivers
> +#
> +obj-$(CONFIG_TEGRA_AHB)		+=3D tegra-ahb.o
> diff --git a/drivers/platform/arm/tegra-ahb.c b/drivers/platform/arm/tegr=
a-ahb.c
> new file mode 100644
> index 0000000..dcad2ec
> --- /dev/null
> +++ b/drivers/platform/arm/tegra-ahb.c
> @@ -0,0 +1,278 @@
> +/*
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * Author:
> + *	Jay Cheng <jacheng@nvidia.com>
> + *	James Wylder <james.wylder@motorola.com>
> + *	Benoit Goby <benoit@android.com>
> + *	Colin Cross <ccross@android.com>
> + *	Hiroshi DOYU <hdoyu@nvidia.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +
> +#include <mach/iomap.h>

why do you need mach/iomap.h ?

> +#define DRV_NAME "tegra-ahb"
> +
> +#define AHB_ARBITRATION_DISABLE		0x00
> +#define AHB_ARBITRATION_PRIORITY_CTRL	0x04
> +#define   AHB_PRIORITY_WEIGHT(x)	(((x) & 0x7) << 29)
> +#define   PRIORITY_SELECT_USB BIT(6)
> +#define   PRIORITY_SELECT_USB2 BIT(18)
> +#define   PRIORITY_SELECT_USB3 BIT(17)
> +
> +#define AHB_GIZMO_AHB_MEM		0x0c
> +#define   ENB_FAST_REARBITRATE BIT(2)
> +#define   DONT_SPLIT_AHB_WR     BIT(7)
> +
> +#define AHB_GIZMO_APB_DMA		0x10
> +#define AHB_GIZMO_IDE			0x18
> +#define AHB_GIZMO_USB			0x1c
> +#define AHB_GIZMO_AHB_XBAR_BRIDGE	0x20
> +#define AHB_GIZMO_CPU_AHB_BRIDGE	0x24
> +#define AHB_GIZMO_COP_AHB_BRIDGE	0x28
> +#define AHB_GIZMO_XBAR_APB_CTLR		0x2c
> +#define AHB_GIZMO_VCP_AHB_BRIDGE	0x30
> +#define AHB_GIZMO_NAND			0x3c
> +#define AHB_GIZMO_SDMMC4		0x44
> +#define AHB_GIZMO_XIO			0x48
> +#define AHB_GIZMO_BSEV			0x60
> +#define AHB_GIZMO_BSEA			0x70
> +#define AHB_GIZMO_NOR			0x74
> +#define AHB_GIZMO_USB2			0x78
> +#define AHB_GIZMO_USB3			0x7c
> +#define   IMMEDIATE	BIT(18)
> +
> +#define AHB_GIZMO_SDMMC1		0x80
> +#define AHB_GIZMO_SDMMC2		0x84
> +#define AHB_GIZMO_SDMMC3		0x88
> +#define AHB_MEM_PREFETCH_CFG_X		0xd8
> +#define AHB_ARBITRATION_XBAR_CTRL	0xdc
> +#define AHB_MEM_PREFETCH_CFG3		0xe0
> +#define AHB_MEM_PREFETCH_CFG4		0xe4
> +#define AHB_MEM_PREFETCH_CFG1		0xec
> +#define AHB_MEM_PREFETCH_CFG2		0xf0
> +#define   PREFETCH_ENB	BIT(31)
> +#define   MST_ID(x)	(((x) & 0x1f) << 26)
> +#define   AHBDMA_MST_ID	MST_ID(5)
> +#define   USB_MST_ID	MST_ID(6)
> +#define   USB2_MST_ID	MST_ID(18)
> +#define   USB3_MST_ID	MST_ID(17)
> +#define   ADDR_BNDRY(x)	(((x) & 0xf) << 21)
> +#define   INACTIVITY_TIMEOUT(x)	(((x) & 0xffff) << 0)
> +
> +#define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
> +
> +static u32 tegra_ahb_gizmo[] =3D {
> +	AHB_ARBITRATION_DISABLE,
> +	AHB_ARBITRATION_PRIORITY_CTRL,
> +	AHB_GIZMO_AHB_MEM,
> +	AHB_GIZMO_APB_DMA,
> +	AHB_GIZMO_IDE,
> +	AHB_GIZMO_USB,
> +	AHB_GIZMO_AHB_XBAR_BRIDGE,
> +	AHB_GIZMO_CPU_AHB_BRIDGE,
> +	AHB_GIZMO_COP_AHB_BRIDGE,
> +	AHB_GIZMO_XBAR_APB_CTLR,
> +	AHB_GIZMO_VCP_AHB_BRIDGE,
> +	AHB_GIZMO_NAND,
> +	AHB_GIZMO_SDMMC4,
> +	AHB_GIZMO_XIO,
> +	AHB_GIZMO_BSEV,
> +	AHB_GIZMO_BSEA,
> +	AHB_GIZMO_NOR,
> +	AHB_GIZMO_USB2,
> +	AHB_GIZMO_USB3,
> +	AHB_GIZMO_SDMMC1,
> +	AHB_GIZMO_SDMMC2,
> +	AHB_GIZMO_SDMMC3,
> +	AHB_MEM_PREFETCH_CFG_X,
> +	AHB_ARBITRATION_XBAR_CTRL,
> +	AHB_MEM_PREFETCH_CFG3,
> +	AHB_MEM_PREFETCH_CFG4,
> +	AHB_MEM_PREFETCH_CFG1,
> +	AHB_MEM_PREFETCH_CFG2,
> +	AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID,
> +};
> +
> +struct tegra_ahb {
> +	void __iomem	*regs;
> +	void		*ctx;
> +	struct device	*dev;
> +};
> +
> +static inline u32 gizmo_readl(struct tegra_ahb *ahb, u32 offset)
> +{
> +	return readl(ahb->regs + offset);
> +}
> +
> +static inline void gizmo_writel(struct tegra_ahb *ahb, u32 value, u32 of=
fset)
> +{
> +	writel(value, ahb->regs + offset);
> +}
> +
> +static int tegra_ahb_suspend(struct device *dev)
> +{
> +	int i;
> +	struct tegra_ahb *ahb =3D dev_get_drvdata(dev);
> +	u32 *p =3D ahb->ctx;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra_ahb_gizmo); i++)
> +		p[i] =3D gizmo_readl(ahb, tegra_ahb_gizmo[i]);
> +	return 0;
> +}
> +
> +static int tegra_ahb_resume(struct device *dev)
> +{
> +	int i;
> +	struct tegra_ahb *ahb =3D dev_get_drvdata(dev);
> +	u32 *p =3D ahb->ctx;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra_ahb_gizmo); i++)
> +		gizmo_writel(ahb, p[i], tegra_ahb_gizmo[i]);
> +	return 0;
> +}
> +
> +static UNIVERSAL_DEV_PM_OPS(tegra_ahb_pm,
> +			    tegra_ahb_suspend,
> +			    tegra_ahb_resume, NULL);
> +
> +static void tegra_ahb_gizmo_init(struct tegra_ahb *ahb)
> +{
> +	u32 val;
> +
> +	val =3D gizmo_readl(ahb, AHB_GIZMO_AHB_MEM);
> +	val |=3D ENB_FAST_REARBITRATE | IMMEDIATE | DONT_SPLIT_AHB_WR;
> +	gizmo_writel(ahb, val, AHB_GIZMO_AHB_MEM);
> +
> +	val =3D gizmo_readl(ahb, AHB_GIZMO_USB);
> +	val |=3D IMMEDIATE;
> +	gizmo_writel(ahb, val, AHB_GIZMO_USB);
> +
> +	val =3D gizmo_readl(ahb, AHB_GIZMO_USB2);
> +	val |=3D IMMEDIATE;
> +	gizmo_writel(ahb, val, AHB_GIZMO_USB2);
> +
> +	val =3D gizmo_readl(ahb, AHB_GIZMO_USB3);
> +	val |=3D IMMEDIATE;
> +	gizmo_writel(ahb, val, AHB_GIZMO_USB3);
> +
> +	val =3D gizmo_readl(ahb, AHB_ARBITRATION_PRIORITY_CTRL);
> +	val |=3D PRIORITY_SELECT_USB |
> +		PRIORITY_SELECT_USB2 |
> +		PRIORITY_SELECT_USB3 |
> +		AHB_PRIORITY_WEIGHT(7);
> +	gizmo_writel(ahb, val, AHB_ARBITRATION_PRIORITY_CTRL);
> +
> +	val =3D gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG1);
> +	val &=3D ~MST_ID(~0);
> +	val |=3D PREFETCH_ENB |
> +		AHBDMA_MST_ID |
> +		ADDR_BNDRY(0xc) |
> +		INACTIVITY_TIMEOUT(0x1000);
> +	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG1);
> +
> +	val =3D gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG2);
> +	val &=3D ~MST_ID(~0);
> +	val |=3D PREFETCH_ENB |
> +		USB_MST_ID |
> +		ADDR_BNDRY(0xc) |
> +		INACTIVITY_TIMEOUT(0x1000);
> +	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG2);
> +
> +	val =3D gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG3);
> +	val &=3D ~MST_ID(~0);
> +	val |=3D PREFETCH_ENB |
> +		USB3_MST_ID |
> +		ADDR_BNDRY(0xc) |
> +		INACTIVITY_TIMEOUT(0x1000);
> +	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG3);
> +
> +	val =3D gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG4);
> +	val &=3D ~MST_ID(~0);
> +	val |=3D PREFETCH_ENB |
> +		USB2_MST_ID |
> +		ADDR_BNDRY(0xc) |
> +		INACTIVITY_TIMEOUT(0x1000);
> +	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG4);
> +}
> +
> +static int __devinit tegra_ahb_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct tegra_ahb *ahb;
> +	size_t bytes;
> +
> +	bytes =3D sizeof(*ahb) + sizeof(u32) * ARRAY_SIZE(tegra_ahb_gizmo);
> +	ahb =3D devm_kzalloc(&pdev->dev, bytes, GFP_KERNEL);
> +	if (!ahb)
> +		return -ENOMEM;
> +	ahb->ctx =3D ahb + 1;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +	ahb->regs =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (!ahb->regs)
> +		return -EBUSY;
> +
> +	ahb->dev =3D &pdev->dev;
> +	platform_set_drvdata(pdev, ahb);
> +	tegra_ahb_gizmo_init(ahb);
> +	return 0;
> +}
> +
> +static int __devexit tegra_ahb_remove(struct platform_device *pdev)
> +{
> +	platform_set_drvdata(pdev, NULL);
> +	return 0;
> +}
> +
> +static const struct of_device_id tegra_ahb_of_match[] __devinitconst =3D=
 {
> +	{ .compatible =3D "nvidia,tegra30-ahb", },
> +	{ .compatible =3D "nvidia,tegra20-ahb", },
> +	{},
> +};
> +
> +static struct platform_driver tegra_ahb_driver =3D {
> +	.probe =3D tegra_ahb_probe,
> +	.remove =3D __devexit_p(tegra_ahb_remove),
> +	.driver =3D {
> +		.name =3D DRV_NAME,
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D tegra_ahb_of_match,
> +		.pm =3D &tegra_ahb_pm,
> +	},
> +};
> +
> +static int __init tegra_ahb_init(void)
> +{
> +	return platform_driver_register(&tegra_ahb_driver);
> +}
> +postcore_initcall(tegra_ahb_init);
> +
> +static void __exit tegra_ahb_exit(void)
> +{
> +	platform_driver_unregister(&tegra_ahb_driver);
> +}
> +module_exit(tegra_ahb_exit);
> +
> +MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
> +MODULE_DESCRIPTION("Tegra AHB driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DRV_NAME);
> --=20
> 1.7.5.4
>=20

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl98fAAoJEIaOsuA1yqRE9xMQAImGOA8WTQT1t3Q2jYF4wYkw
PTBsy6rwitnznqh2AmyS1beXmtuYzGJ0mYpx1Xpn4ssMoq8ISI1IyhpLLyqb6yzz
4BXi26yJuGLTi5IJuAne7nkkZPtx0lmfAXS/sOTqqv0hSkb05HpixZYviOgPMvRI
pgkRArK+duFtYQuixYQnIk4oaCsblwSa/P5HwGcER5KgCRwaOenKUi6hiWsKpkeQ
K15VJA52aNJaFbEdVBJ3bL8GUwQLieTEz9kB652Jr3waGIxEuGBCD87OmYhvRmbd
IC0JijpopmUlKE0PT5Ulesw7FUZ5mSiGpa/tM+SC8O3ZyMuNoKnRorM+wpaSnGE1
F/iBo2naY/Dzyace0PpqP6mjBbmSsiGWaQTCCcZB4tAtGWdDHO02GPmyxI7rXtfz
80n33kMTIUJE5CBp8Gp4iWyWVLwlc61PydaYx3jZHpTUsRcTPimsymQdEJYLx1pk
KjV/V93CAh5bsdE47RBp/hbrrupD5lobpp6wHKctaoiRcL2FAbfXUTDzYVCCwgSK
p1Opj2Jm2y1WEuPhkhNd8qcDS+soFnLQ4ObpXCOv3puVSZM1B4Ftt9PGq9YJ1TeB
3fEad+4kcdq6Ga02RWHrJ3MT00RC/IbBSvUFoyzsoGYDP9cqUbJ1abK7osURAUGt
i/Iw9W2N2MS5P6rSkPwL
=lwnY
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
