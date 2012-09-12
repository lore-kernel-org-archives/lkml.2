Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab2ILN4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:56:13 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:59482 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab2ILN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:56:12 -0400
Date: Wed, 12 Sep 2012 16:51:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: host: tegra: code clean up
Message-ID: <20120912135121.GS5732@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aJ74fq0Y6SrIeKCM"
Content-Disposition: inline
In-Reply-To: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aJ74fq0Y6SrIeKCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 12, 2012 at 12:32:42PM +0530, Venu Byravarasu wrote:
> As part of code clean up, used devm counterparts for the APIs
> possible.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

EHCI is Alan's domain.

> ---
>  drivers/usb/host/ehci-tegra.c |   46 ++++++++++++++---------------------=
-----
>  1 files changed, 16 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index c0d4732..532db04 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -634,7 +634,8 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
> =20
>  	setup_vbus_gpio(pdev, pdata);
> =20
> -	tegra =3D kzalloc(sizeof(struct tegra_ehci_hcd), GFP_KERNEL);
> +	tegra =3D devm_kzalloc(&pdev->dev, sizeof(struct tegra_ehci_hcd),
> +			     GFP_KERNEL);
>  	if (!tegra)
>  		return -ENOMEM;
> =20
> @@ -642,13 +643,12 @@ static int tegra_ehci_probe(struct platform_device =
*pdev)
>  					dev_name(&pdev->dev));
>  	if (!hcd) {
>  		dev_err(&pdev->dev, "Unable to create HCD\n");
> -		err =3D -ENOMEM;
> -		goto fail_hcd;
> +		return -ENOMEM;
>  	}
> =20
>  	platform_set_drvdata(pdev, tegra);
> =20
> -	tegra->clk =3D clk_get(&pdev->dev, NULL);
> +	tegra->clk =3D devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(tegra->clk)) {
>  		dev_err(&pdev->dev, "Can't get ehci clock\n");
>  		err =3D PTR_ERR(tegra->clk);
> @@ -657,9 +657,9 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
> =20
>  	err =3D clk_prepare_enable(tegra->clk);
>  	if (err)
> -		goto fail_clken;
> +		goto fail_clk;
> =20
> -	tegra->emc_clk =3D clk_get(&pdev->dev, "emc");
> +	tegra->emc_clk =3D devm_clk_get(&pdev->dev, "emc");
>  	if (IS_ERR(tegra->emc_clk)) {
>  		dev_err(&pdev->dev, "Can't get emc clock\n");
>  		err =3D PTR_ERR(tegra->emc_clk);
> @@ -677,7 +677,7 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
>  	}
>  	hcd->rsrc_start =3D res->start;
>  	hcd->rsrc_len =3D resource_size(res);
> -	hcd->regs =3D ioremap(res->start, resource_size(res));
> +	hcd->regs =3D devm_ioremap(&pdev->dev, res->start, resource_size(res));
>  	if (!hcd->regs) {
>  		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
>  		err =3D -ENOMEM;
> @@ -701,8 +701,8 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
>  			break;
>  		default:
>  			err =3D -ENODEV;
> -			dev_err(&pdev->dev, "unknown usb instance\n");
> -			goto fail_phy;
> +			dev_err(&pdev->dev, "unknown usb inst:%d\n", instance);
> +			goto fail_io;
>  		}
>  	}
> =20
> @@ -712,7 +712,7 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
>  	if (IS_ERR(tegra->phy)) {
>  		dev_err(&pdev->dev, "Failed to open USB phy\n");
>  		err =3D -ENXIO;
> -		goto fail_phy;
> +		goto fail_io;
>  	}
> =20
>  	usb_phy_init(&tegra->phy->u_phy);
> @@ -735,7 +735,8 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
> =20
>  #ifdef CONFIG_USB_OTG_UTILS
>  	if (pdata->operating_mode =3D=3D TEGRA_USB_OTG) {
> -		tegra->transceiver =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +		tegra->transceiver =3D
> +			devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>  		if (!IS_ERR_OR_NULL(tegra->transceiver))
>  			otg_set_host(tegra->transceiver->otg, &hcd->self);
>  	}
> @@ -743,7 +744,7 @@ static int tegra_ehci_probe(struct platform_device *p=
dev)
> =20
>  	err =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
>  	if (err) {
> -		dev_err(&pdev->dev, "Failed to add USB HCD\n");
> +		dev_err(&pdev->dev, "usb_add_hcd failed with err 0x%x\n", err);
>  		goto fail;
>  	}
> =20
> @@ -752,32 +753,23 @@ static int tegra_ehci_probe(struct platform_device =
*pdev)
> =20
>  	/* Don't skip the pm_runtime_forbid call if wakeup isn't working */
>  	/* if (!pdata->power_down_on_bus_suspend) */
> -		pm_runtime_forbid(&pdev->dev);
> +	pm_runtime_forbid(&pdev->dev);
>  	pm_runtime_enable(&pdev->dev);
>  	pm_runtime_put_sync(&pdev->dev);
>  	return err;
> =20
>  fail:
>  #ifdef CONFIG_USB_OTG_UTILS
> -	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
> +	if (!IS_ERR_OR_NULL(tegra->transceiver))
>  		otg_set_host(tegra->transceiver->otg, NULL);
> -		usb_put_phy(tegra->transceiver);
> -	}
>  #endif
>  	usb_phy_shutdown(&tegra->phy->u_phy);
> -fail_phy:
> -	iounmap(hcd->regs);
>  fail_io:
>  	clk_disable_unprepare(tegra->emc_clk);
> -	clk_put(tegra->emc_clk);
>  fail_emc_clk:
>  	clk_disable_unprepare(tegra->clk);
> -fail_clken:
> -	clk_put(tegra->clk);
>  fail_clk:
>  	usb_put_hcd(hcd);
> -fail_hcd:
> -	kfree(tegra);
>  	return err;
>  }
> =20
> @@ -794,26 +786,20 @@ static int tegra_ehci_remove(struct platform_device=
 *pdev)
>  	pm_runtime_put_noidle(&pdev->dev);
> =20
>  #ifdef CONFIG_USB_OTG_UTILS
> -	if (!IS_ERR_OR_NULL(tegra->transceiver)) {
> +	if (!IS_ERR_OR_NULL(tegra->transceiver))
>  		otg_set_host(tegra->transceiver->otg, NULL);
> -		usb_put_phy(tegra->transceiver);
> -	}
>  #endif
> =20
>  	usb_remove_hcd(hcd);
> =20
>  	usb_phy_shutdown(&tegra->phy->u_phy);
> -	iounmap(hcd->regs);
> =20
>  	usb_put_hcd(hcd);
> =20
>  	clk_disable_unprepare(tegra->clk);
> -	clk_put(tegra->clk);
> =20
>  	clk_disable_unprepare(tegra->emc_clk);
> -	clk_put(tegra->emc_clk);
> =20
> -	kfree(tegra);
>  	return 0;
>  }
> =20
> --=20
> 1.7.1.1
>=20

--=20
balbi

--aJ74fq0Y6SrIeKCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUJNYAAoJEIaOsuA1yqREnbkP/RvXFI6X1+FKtOXQRUybiZXj
0rfQ8msoOO8+sgGNAb4Dtb4CC9E3AJUxHfnDz6sHuZAild9eTu1nW6kHZR09dhk7
lohyAVt3dbVk6Ni/GY4sWiGrw7l4kXzrg3/og2jVW5p5f8xH+qkFftGgfXmk+p/r
Fh3Yz6LmbAkgScfLSsIWBHqYW5S62ZIdrrta0fCmCWzyZ2juULBIV9TPSmIIL2PP
SV5isRBdwEVGTR5ix/6rRt9MfnVc+vVPYNkd1nZt3oho8r8mx21/GLJeQsdjomNs
1rQYNHLT/TI5KzYeaDwN/fmRdUaYkfiMI1/BCn8lEUR3DkVVarQUl1pdG1w9D6D3
9I2MUwCs9ABH2DpZQs3i62zj8hNge3MG2Iw3Lj9UeuVVjlHEru9+KrN1/+e3q3uF
mdzfHX0Twjjyw183XqQbfSeefjM//sI2Yr3NQaDwBCsW+dra3UJ/8SmYDbV4H6qB
B6DzIo3Ljjp9OVUqICzg8SkFJoz6ICpXnPhkbKeKqTq6pNYnBhvgGthKCuawz0vf
K9DSHFDhppjwUBn4DnN5hnZ1DsjnJnFwaba8x9+bcTIL0RtUCGgq5ZPItwRgqjJP
Cov7+4iWsvZo5X3Xke/cOzgknr3ODNPen5LphalJEtIItFtN46BjyoYGyuAiMYHo
a7wcR4PljKXiUMgwvkMP
=nHo8
-----END PGP SIGNATURE-----

--aJ74fq0Y6SrIeKCM--
