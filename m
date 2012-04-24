Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2DXMRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:17:37 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:54009 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab2DXMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:17:35 -0400
Date: Tue, 24 Apr 2012 15:16:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120424121619.GF8444@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZkK3DH7HIvxYLwhR"
Content-Disposition: inline
In-Reply-To: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZkK3DH7HIvxYLwhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
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
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> Update:
> - Use platform_device to get info from dt dynamically.(Felipe/Arnd)
> ---
>  arch/arm/mach-tegra/Makefile    |    1 +
>  arch/arm/mach-tegra/tegra-ahb.c |  285 +++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 286 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index 2eb4445..f6c8237 100644
> --- a/arch/arm/mach-tegra/Makefile
> +++ b/arch/arm/mach-tegra/Makefile
> @@ -1,3 +1,4 @@
> +obj-y                                   +=3D tegra-ahb.o
>  obj-y                                   +=3D board-pinmux.o
>  obj-y                                   +=3D common.o
>  obj-y                                   +=3D devices.o
> diff --git a/arch/arm/mach-tegra/tegra-ahb.c b/arch/arm/mach-tegra/tegra-=
ahb.c
> new file mode 100644
> index 0000000..71b5950
> --- /dev/null
> +++ b/arch/arm/mach-tegra/tegra-ahb.c
> @@ -0,0 +1,285 @@
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
> +
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
> +struct __tegra_ahb {
> +	void __iomem	*regs;
> +	struct device	*dev;
> +};
> +
> +static struct __tegra_ahb *tegra_ahb;
> +
> +static inline unsigned long gizmo_readl(unsigned long offset)

pass void __iomem *base as argument here

> +{
> +	return readl(tegra_ahb->regs + offset);

this should become readl(base + offset);

> +}
> +
> +static inline void gizmo_writel(unsigned long value, unsigned long offse=
t)

ditto for void __iomem *base

> +struct __ahb_gizmo {
> +	unsigned long offset;
> +	unsigned long data;
> +};
> +
> +static struct __ahb_gizmo ahb_gizmo[] =3D {
> +	{ .offset =3D AHB_ARBITRATION_DISABLE, },
> +	{ .offset =3D AHB_ARBITRATION_PRIORITY_CTRL, },
> +	{ .offset =3D AHB_GIZMO_AHB_MEM, },
> +	{ .offset =3D AHB_GIZMO_APB_DMA, },
> +	{ .offset =3D AHB_GIZMO_IDE, },
> +	{ .offset =3D AHB_GIZMO_USB, },
> +	{ .offset =3D AHB_GIZMO_AHB_XBAR_BRIDGE, },
> +	{ .offset =3D AHB_GIZMO_CPU_AHB_BRIDGE, },
> +	{ .offset =3D AHB_GIZMO_COP_AHB_BRIDGE, },
> +	{ .offset =3D AHB_GIZMO_XBAR_APB_CTLR, },
> +	{ .offset =3D AHB_GIZMO_VCP_AHB_BRIDGE, },
> +	{ .offset =3D AHB_GIZMO_NAND, },
> +	{ .offset =3D AHB_GIZMO_SDMMC4, },
> +	{ .offset =3D AHB_GIZMO_XIO, },
> +	{ .offset =3D AHB_GIZMO_BSEV, },
> +	{ .offset =3D AHB_GIZMO_BSEA, },
> +	{ .offset =3D AHB_GIZMO_NOR, },
> +	{ .offset =3D AHB_GIZMO_USB2, },
> +	{ .offset =3D AHB_GIZMO_USB3, },
> +	{ .offset =3D AHB_GIZMO_SDMMC1, },
> +	{ .offset =3D AHB_GIZMO_SDMMC2, },
> +	{ .offset =3D AHB_GIZMO_SDMMC3, },
> +	{ .offset =3D AHB_MEM_PREFETCH_CFG_X, },
> +	{ .offset =3D AHB_ARBITRATION_XBAR_CTRL, },
> +	{ .offset =3D AHB_MEM_PREFETCH_CFG3, },
> +	{ .offset =3D AHB_MEM_PREFETCH_CFG4, },
> +	{ .offset =3D AHB_MEM_PREFETCH_CFG1, },
> +	{ .offset =3D AHB_MEM_PREFETCH_CFG2, },
> +	{ .offset =3D AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID, },
> +};
> +
> +static int tegra_ahb_suspend(struct device *dev)
> +{
> +	int i;

struct tegra_ahb	*ahb =3D dev_get_drvdata(dev);

> +	for (i =3D 0; i < ARRAY_SIZE(ahb_gizmo); i++)
> +		ahb_gizmo[i].data =3D gizmo_readl(ahb_gizmo[i].offset);

+		ahb_gizmo[i].data =3D gizmo_readl(ahb->regs, ahb_gizmo[i].offset);

> +	return 0;
> +}
> +
> +static int tegra_ahb_resume(struct device *dev)
> +{
> +	int i;

struct tegra_ahb	*ahb =3D dev_get_drvdata(dev);

> +	for (i =3D 0; i < ARRAY_SIZE(ahb_gizmo); i++)
> +		gizmo_writel(ahb_gizmo[i].data, ahb_gizmo[i].offset);

+		ahb_gizmo[i].data =3D gizmo_readl(ahb->regs, ahb_gizmo[i].offset);

> +	return 0;
> +}
> +
> +static void tegra_ahb_gizmo_init(void)

pass tegra_ahb as argument here

> +static int __devinit tegra_ahb_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +
> +	if (tegra_ahb)
> +		return -ENODEV;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	res =3D devm_request_mem_region(&pdev->dev, res->start,
> +				      resource_size(res), dev_name(&pdev->dev));

there's a nicer helper which you can use: devm_request_and_ioremap()

> +	if (!res)
> +		return -EBUSY;
> +
> +	tegra_ahb =3D devm_kzalloc(&pdev->dev, sizeof(*tegra_ahb), GFP_KERNEL);
> +	if (!tegra_ahb)
> +		return -ENOMEM;
> +	tegra_ahb->dev =3D &pdev->dev;
> +	tegra_ahb->regs =3D devm_ioremap(&pdev->dev,
> +				       res->start, resource_size(res));
> +	if (!tegra_ahb->regs) {
> +		tegra_ahb =3D NULL;
> +		return -ENOMEM;
> +	}
> +	platform_set_drvdata(pdev, tegra_ahb);
> +	tegra_ahb_gizmo_init();

pass tegra_ahb as argument.

> +	return 0;
> +}
> +
> +static int __devexit tegra_ahb_remove(struct platform_device *pdev)
> +{
> +	platform_set_drvdata(pdev, NULL);
> +	tegra_ahb =3D NULL;

this global pointer isn't needed at all.

> +static const struct of_device_id tegra_ahb_of_match[] __devinitconst =3D=
 {
> +	{ .compatible =3D "nvidia,tegra30-ahb", },
> +	{ .compatible =3D "nvidia,tegra20-ahb", },
> +	{},
> +};
> +
> +static const struct dev_pm_ops tegra_ahb_pm_ops __devinitconst =3D {
> +	SET_RUNTIME_PM_OPS(tegra_ahb_suspend, tegra_ahb_resume, NULL)
> +};

what about system suspend ? Should you be using UNIVERSAL_DEV_PM_OPS()
instead ?

> +static struct platform_driver tegra_ahb_driver =3D {
> +	.probe =3D tegra_ahb_probe,
> +	.remove =3D __devexit_p(tegra_ahb_remove),
> +	.driver =3D {
> +		.name =3D DRV_NAME,
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D tegra_ahb_of_match,
> +		.pm =3D &tegra_ahb_pm_ops,
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

please use module_platform_driver();

--=20
balbi

--ZkK3DH7HIvxYLwhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlpmTAAoJEIaOsuA1yqRE5VUP/0MIXRHW/b5jtGRbwuYWV4Vo
rtE37w7yuNgiuHS1TScU9y2eCLhnIH2hxaJycL5/56+mgWLrBsqhmaRwUumxzwti
JMFwQjKjf0kjTFPjj3VaU7Y1OaiDGOLTnOjCOgC8UjGe8+vOLjhwEMrSPvhfmbqa
ZkSL1d0OtQoELFavqAweMs4V6f7HOr38m33lXZzto8lVbN7l9MZ/dgbdxYFthD/K
biKVq8TZ+tdfP6IaDb+eabxqZJo10LUUtdM+vM8P9bo+f41ORTzu5tdzaC9L/vfD
nNL5sOnqnd10woiCgg1M6VwRZULSr5azoj405PbDiG7xOZZIBzqGUBDrbdNeFKH1
gZUEZNIhd4UQyAQ3M/K+Uqns+9Nu1onBvODyT/RfWRUCmAfM4YqGsOIuQvjdKBjT
nqxbjR5MbHNMzFB9UMWILetg5c4t2CiCRlKAqHgcrV5afFSdupDmZALrdd6S13uq
UF/YYycE2mx7h2uhzPOZT/Mz9AMOplKmuwNbP9mN88P+OORTmWOAakgZSj3k98mN
TafS5n8/p6WV23ismFoEzpueoE47TalQtLOhGMDVkxil7oDQk9r0xEJT7FBDaK3X
PnoRM22Yc+YDd4/JhdY20KiMq1rLNqFqlyqItJRUMiBD8ciYGV6HFFdyXObiYKmR
69PHR1Zon1QmNOlApWa2
=ZyeZ
-----END PGP SIGNATURE-----

--ZkK3DH7HIvxYLwhR--
