Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab2DPGPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:15:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DPGPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:15:49 -0400
Date: Mon, 16 Apr 2012 08:15:31 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH 1/4] ohci-nxp: Device tree support
Message-ID: <20120416061531.GB3037@avionic-0098.adnet.avionic-design.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
 <1334400790-10892-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <1334400790-10892-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1R6kxHNfQ5A/fezcDxvCT0xjQVstjjYCDmt1KN/9Q78
 36eUh7d7taYB2CrXUG3dV1MTV1zg/oAgwsmEWmrFKhTXq3jcRi
 eo8ZiqMZqQLPu9k5hbREnd9uJ3p3HW+kOOj3fuxyt/F4kQmtRU
 4y2HfaucJuS0dj9TyWJrh8tcAD0KwOczwTFSSwoAfq4UhWtcmT
 tGWQ79RdXixcsZFQYer/KCZQX3xuW7MVa+28aTK1fUpIHFhZEr
 U0B2UttLS7Ygk03Ug9sw+N4zkmTU7KtQkJC5K5B2pTKoy0emZz
 sJxVcn55fq/cT5gKDhnHHJF/5bAg/cVRJnD4A2Jq4DH0VgqWFG
 Jf3sPQfOT56hevuHd9+DnF17UR9YpQSVMs8s+RMTRC0Bhq2bVl
 l8EjDx5PWJiwXfy+bMAi8wBbz5Dy3vZOW8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Roland Stigge wrote:
> This patch adds device tree support to ohci-nxp.c
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---
>=20
> Applies to v3.4-rc2
>=20
>  Documentation/devicetree/bindings/usb/ohci-nxp.txt |   16 ++++
>  drivers/usb/host/ohci-nxp.c                        |   68 ++++++++++++++=
-------
>  2 files changed, 64 insertions(+), 20 deletions(-)
>=20
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/usb/ohci-nxp.txt
> @@ -0,0 +1,16 @@
> +* OHCI controller, NXP ohci-nxp variant
> +
> +Required properties:
> +- compatible: must be "nxp,ohci-nxp"
> +- reg: physical base address of the controller and length of memory mapp=
ed
> +  region.
> +- interrupts: The OHCI interrupt
> +
> +Example (LPC32xx):
> +
> +	ohci@31020000 {
> +		compatible =3D "nxp,ohci-nxp";
> +		reg =3D <0x31020000 0x300>;
> +		interrupt-parent =3D <&mic>;
> +		interrupts =3D <0x3b 0>;
> +	};
> --- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
> +++ linux-2.6/drivers/usb/host/ohci-nxp.c
> @@ -22,6 +22,7 @@
>  #include <linux/clk.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c.h>
> +#include <linux/of.h>
> =20
>  #include <mach/hardware.h>
>  #include <asm/mach-types.h>
> @@ -29,7 +30,6 @@
> =20
>  #include <mach/platform.h>
>  #include <mach/irqs.h>
> -#include <asm/gpio.h>
> =20
>  #define USB_CONFIG_BASE		0x31020000
>  #define PWRMAN_BASE		0x40004000
> @@ -38,6 +38,7 @@
> =20
>  /* USB_CTRL bit defines */
>  #define USB_SLAVE_HCLK_EN	(1 << 24)
> +#define USB_DEV_NEED_CLK_EN	(1 << 22)
>  #define USB_HOST_NEED_CLK_EN	(1 << 21)
> =20
>  #define USB_OTG_CLK_CTRL	IO_ADDRESS(USB_CONFIG_BASE + 0xFF4)
> @@ -117,7 +118,6 @@ static struct i2c_driver isp1301_driver;
>  static struct i2c_client *isp1301_i2c_client;
> =20
>  extern int usb_disabled(void);
> -extern int ocpi_enable(void);
> =20
>  static struct clk *usb_clk;
> =20
> @@ -220,7 +220,7 @@ static void isp1301_configure_lpc32xx(vo
>  		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
> =20
>  	/* Enable usb_need_clk clock after transceiver is initialized */
> -	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
> +	__raw_writel((__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN), USB_CTRL);
> =20
>  	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n",
>  	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x00));
> @@ -266,7 +266,7 @@ static void nxp_stop_hc(void)
>  	__raw_writel(tmp, USB_OTG_STAT_CONTROL);
>  }
> =20

The above changes aren't related to the DT conversion. Should they perhaps =
go
into a separate patch?

> -static int __devinit ohci_nxp_start(struct usb_hcd *hcd)
> +static int ohci_nxp_start(struct usb_hcd *hcd)
>  {
>  	struct ohci_hcd *ohci =3D hcd_to_ohci(hcd);
>  	int ret;
> @@ -367,16 +367,20 @@ static void nxp_unset_usb_bits(void)
>  	}
>  }
> =20
> -static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
> +static int usb_hcd_nxp_probe(struct platform_device *pdev)

What's the reason for dropping __devinit?

>  {
>  	struct usb_hcd *hcd =3D 0;
>  	struct ohci_hcd *ohci;
>  	const struct hc_driver *driver =3D &ohci_nxp_hc_driver;
>  	struct i2c_adapter *i2c_adap;
>  	struct i2c_board_info i2c_info;
> +	struct resource *res;
> =20
>  	int ret =3D 0, irq;
> =20
> +	pdev->dev.coherent_dma_mask =3D 0xFFFFFFFF;

DMA_BIT_MASK(32)?

> +	pdev->dev.dma_mask =3D &pdev->dev.coherent_dma_mask;
> +
>  	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (nxp)\n", hcd_name);
>  	if (usb_disabled()) {
>  		err("USB is disabled");
> @@ -384,16 +388,10 @@ static int __devinit usb_hcd_nxp_probe(s
>  		goto out;
>  	}
> =20
> -	if (pdev->num_resources !=3D 2
> -	    || pdev->resource[0].flags !=3D IORESOURCE_MEM
> -	    || pdev->resource[1].flags !=3D IORESOURCE_IRQ) {
> -		err("Invalid resource configuration");
> -		ret =3D -ENODEV;
> -		goto out;
> -	}
> -
>  	/* Enable AHB slave USB clock, needed for further USB clock control */
> -	__raw_writel(USB_SLAVE_HCLK_EN | (1 << 19), USB_CTRL);
> +	__raw_writel(__raw_readl(USB_CTRL) | USB_SLAVE_HCLK_EN, USB_CTRL);
> +	__raw_writel(__raw_readl(USB_CTRL) & ~(1 << 20), USB_CTRL);
> +	__raw_writel(__raw_readl(USB_CTRL) | (1 << 19), USB_CTRL);

You're already adding a define for bit 22 (USB_DEV_NEED_CLK_EN) above, why
not add one for bits 19 and 20 as well?

> =20
>  	ret =3D i2c_add_driver(&isp1301_driver);
>  	if (ret < 0) {
> @@ -401,6 +399,11 @@ static int __devinit usb_hcd_nxp_probe(s
>  		goto out;
>  	}
>  	i2c_adap =3D i2c_get_adapter(2);
> +	if (!i2c_adap) {
> +		err("failed on i2c_get_adapter");
> +		goto out_i2c_driver;
> +	}
> +
>  	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
>  	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
>  	isp1301_i2c_client =3D i2c_new_probed_device(i2c_adap, &i2c_info,
> @@ -435,6 +438,7 @@ static int __devinit usb_hcd_nxp_probe(s
>  	}
> =20
>  	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
> +	__raw_writel(__raw_readl(USB_CTRL) & ~USB_DEV_NEED_CLK_EN, USB_CTRL);
> =20
>  	/* Set to enable all needed USB clocks */
>  	__raw_writel(USB_CLOCK_MASK, USB_OTG_CLK_CTRL);
> @@ -442,7 +446,7 @@ static int __devinit usb_hcd_nxp_probe(s
>  	while ((__raw_readl(USB_OTG_CLK_STAT) & USB_CLOCK_MASK) !=3D
>  	       USB_CLOCK_MASK) ;
> =20
> -	hcd =3D usb_create_hcd (driver, &pdev->dev, dev_name(&pdev->dev));
> +	hcd =3D usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
>  	if (!hcd) {
>  		err("Failed to allocate HC buffer");
>  		ret =3D -ENOMEM;
> @@ -452,19 +456,30 @@ static int __devinit usb_hcd_nxp_probe(s
>  	/* Set all USB bits in the Start Enable register */
>  	nxp_set_usb_bits();
> =20
> -	hcd->rsrc_start =3D pdev->resource[0].start;
> -	hcd->rsrc_len =3D pdev->resource[0].end - pdev->resource[0].start + 1;
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "Failed to get MEM resource");
> +		ret =3D  -ENOMEM;
> +		goto out4;
> +	}
> +	hcd->rsrc_start =3D IO_ADDRESS(res->start);

This looks wrong.

> +	hcd->rsrc_len =3D resource_size(res);
>  	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		dev_dbg(&pdev->dev, "request_mem_region failed\n");
> +		dev_err(&pdev->dev, "request_mem_region failed\n");
>  		ret =3D  -ENOMEM;
>  		goto out4;
>  	}
> -	hcd->regs =3D (void __iomem *)pdev->resource[0].start;
> +	hcd->regs =3D ioremap(res->start, hcd->rsrc_len);
> +	if (!hcd->regs) {
> +		err("Failed to ioremap");
> +		ret =3D  -ENOMEM;
> +		goto out5;
> +	}

Since this is pretty much boilerplate, can you not replace it by
devm_request_and_ioremap()?

> =20
>  	irq =3D platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		ret =3D -ENXIO;
> -		goto out4;
> +		goto out6;
>  	}
> =20
>  	nxp_start_hc();
> @@ -478,6 +493,10 @@ static int __devinit usb_hcd_nxp_probe(s
>  		return ret;
> =20
>  	nxp_stop_hc();
> +out6:
> +	iounmap(hcd->regs);
> +out5:
> +	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);

If you use devm_request_and_ioremap() this cleanup is no longer necessary.

>  out4:
>  	nxp_unset_usb_bits();
>  	usb_put_hcd(hcd);
> @@ -517,10 +536,19 @@ static int usb_hcd_nxp_remove(struct pla
>  /* work with hotplug and coldplug */
>  MODULE_ALIAS("platform:usb-ohci");
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id usb_hcd_nxp_match[] =3D {
> +	{ .compatible =3D "nxp,ohci-nxp" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, usb_hcd_nxp_match);
> +#endif
> +
>  static struct platform_driver usb_hcd_nxp_driver =3D {
>  	.driver =3D {
>  		.name =3D "usb-ohci",
>  		.owner	=3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(usb_hcd_nxp_match),
>  	},
>  	.probe =3D usb_hcd_nxp_probe,
>  	.remove =3D usb_hcd_nxp_remove,

This hunk and the binding documentation are the only DT related changes, the
rest should go into a separate patch because they're really only cleanups.

Thierry

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+LuQMACgkQZ+BJyKLjJp/lzACfdXPvGU+sSigECdnyFq+xgf+Q
IIYAoIOJKXEviHKeRFUTb4HL5qjA9TOD
=zY/1
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
