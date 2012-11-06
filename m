Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2KFLtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:49:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46664 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2KFLtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:49:17 -0500
Date: Tue, 6 Nov 2012 13:43:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 0/7] usb: dwc3-omap: add dt support
Message-ID: <20121106114306.GI11931@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350307680-24938-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Content-Disposition: inline
In-Reply-To: <1350307680-24938-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 15, 2012 at 06:57:53PM +0530, Kishon Vijay Abraham I wrote:
> This patch series adds dt support to dwc3 core and fixes few minor
> stuff in dwc3-omap glue to get dwc3 working.
>=20
> While at that it also uses *of_platform* to create the child device
> (dwc3-core) and fixes to use runtime API's to enable clock and write
> to SYSCONFIG register.
>=20
> Changes from v3:
> * rebased to latest commit in balbi's tree
> * Fixed few typos in the commit log
> * Added *extern* keyword for dwc3_omap_mailbox function declaration
>=20
> Changes from v2:
> * Fixed Sergei comment to use of_property_read_u32 insted of of_get_prope=
rty
>=20
> Changes from v1:
> * made device_for_each_child() as a seperate patch
> * made all other minor fixes wrt typos and function renames
>=20
> This patch series is developed on:
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git dwc3

please rebase on my dwc3 branch. Because of commit belo, patches 1 and 2
won't apply:

commit 124dafde8f8174caf5cef1c3eaba001657d66f4f
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Mon Oct 29 18:09:53 2012 +0100

    usb: dwc3: remove custom unique id handling
   =20
    The lockless implementation of the unique id is quite impressive (:P)
    but dirver's core can handle it, we can remove it and make our code a
    little smaller.
   =20
    Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b923183..d8d327a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -66,45 +66,6 @@ MODULE_PARM_DESC(maximum_speed, "Maximum supported speed=
=2E");
=20
 /* -----------------------------------------------------------------------=
--- */
=20
-#define DWC3_DEVS_POSSIBLE	32
-
-static DECLARE_BITMAP(dwc3_devs, DWC3_DEVS_POSSIBLE);
-
-int dwc3_get_device_id(void)
-{
-	int		id;
-
-again:
-	id =3D find_first_zero_bit(dwc3_devs, DWC3_DEVS_POSSIBLE);
-	if (id < DWC3_DEVS_POSSIBLE) {
-		int old;
-
-		old =3D test_and_set_bit(id, dwc3_devs);
-		if (old)
-			goto again;
-	} else {
-		pr_err("dwc3: no space for new device\n");
-		id =3D -ENOMEM;
-	}
-
-	return id;
-}
-EXPORT_SYMBOL_GPL(dwc3_get_device_id);
-
-void dwc3_put_device_id(int id)
-{
-	int			ret;
-
-	if (id < 0)
-		return;
-
-	ret =3D test_bit(id, dwc3_devs);
-	WARN(!ret, "dwc3: ID %d not in use\n", id);
-	smp_mb__before_clear_bit();
-	clear_bit(id, dwc3_devs);
-}
-EXPORT_SYMBOL_GPL(dwc3_put_device_id);
-
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
 {
 	u32 reg;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 243affc..4999563 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -868,7 +868,4 @@ void dwc3_host_exit(struct dwc3 *dwc);
 int dwc3_gadget_init(struct dwc3 *dwc);
 void dwc3_gadget_exit(struct dwc3 *dwc);
=20
-extern int dwc3_get_device_id(void);
-extern void dwc3_put_device_id(int id);
-
 #endif /* __DRIVERS_USB_DWC3_CORE_H */
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index ca65978..586f105 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -94,7 +94,6 @@ static int __devinit dwc3_exynos_probe(struct platform_de=
vice *pdev)
 	struct dwc3_exynos	*exynos;
 	struct clk		*clk;
=20
-	int			devid;
 	int			ret =3D -ENOMEM;
=20
 	exynos =3D kzalloc(sizeof(*exynos), GFP_KERNEL);
@@ -105,20 +104,16 @@ static int __devinit dwc3_exynos_probe(struct platfor=
m_device *pdev)
=20
 	platform_set_drvdata(pdev, exynos);
=20
-	devid =3D dwc3_get_device_id();
-	if (devid < 0)
-		goto err1;
-
 	ret =3D dwc3_exynos_register_phys(exynos);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't register PHYs\n");
 		goto err1;
 	}
=20
-	dwc3 =3D platform_device_alloc("dwc3", devid);
+	dwc3 =3D platform_device_alloc("dwc3", PLATFORM_DEVID_AUTO);
 	if (!dwc3) {
 		dev_err(&pdev->dev, "couldn't allocate dwc3 device\n");
-		goto err2;
+		goto err1;
 	}
=20
 	clk =3D clk_get(&pdev->dev, "usbdrd30");
@@ -170,8 +165,6 @@ err4:
 	clk_put(clk);
 err3:
 	platform_device_put(dwc3);
-err2:
-	dwc3_put_device_id(devid);
 err1:
 	kfree(exynos);
 err0:
@@ -187,8 +180,6 @@ static int __devexit dwc3_exynos_remove(struct platform=
_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
=20
-	dwc3_put_device_id(exynos->dwc3->id);
-
 	if (pdata && pdata->phy_exit)
 		pdata->phy_exit(pdev, pdata->phy_type);
=20
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index ee57a10..900d435 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -272,7 +272,6 @@ static int __devinit dwc3_omap_probe(struct platform_de=
vice *pdev)
 	struct resource		*res;
 	struct device		*dev =3D &pdev->dev;
=20
-	int			devid;
 	int			size;
 	int			ret =3D -ENOMEM;
 	int			irq;
@@ -315,14 +314,10 @@ static int __devinit dwc3_omap_probe(struct platform_=
device *pdev)
 		return ret;
 	}
=20
-	devid =3D dwc3_get_device_id();
-	if (devid < 0)
-		return -ENODEV;
-
-	dwc3 =3D platform_device_alloc("dwc3", devid);
+	dwc3 =3D platform_device_alloc("dwc3", PLATFORM_DEVID_AUTO);
 	if (!dwc3) {
 		dev_err(dev, "couldn't allocate dwc3 device\n");
-		goto err1;
+		return -ENOMEM;
 	}
=20
 	context =3D devm_kzalloc(dev, resource_size(res), GFP_KERNEL);
@@ -423,10 +418,6 @@ static int __devinit dwc3_omap_probe(struct platform_d=
evice *pdev)
=20
 err2:
 	platform_device_put(dwc3);
-
-err1:
-	dwc3_put_device_id(devid);
-
 	return ret;
 }
=20
@@ -437,9 +428,6 @@ static int __devexit dwc3_omap_remove(struct platform_d=
evice *pdev)
 	platform_device_unregister(omap->dwc3);
 	platform_device_unregister(omap->usb2_phy);
 	platform_device_unregister(omap->usb3_phy);
-
-	dwc3_put_device_id(omap->dwc3->id);
-
 	return 0;
 }
=20
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 94f550e..1396259 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -119,7 +119,6 @@ static int __devinit dwc3_pci_probe(struct pci_dev *pci,
 	struct platform_device	*dwc3;
 	struct dwc3_pci		*glue;
 	int			ret =3D -ENOMEM;
-	int			devid;
 	struct device		*dev =3D &pci->dev;
=20
 	glue =3D devm_kzalloc(dev, sizeof(*glue), GFP_KERNEL);
@@ -145,13 +144,7 @@ static int __devinit dwc3_pci_probe(struct pci_dev *pc=
i,
 		return ret;
 	}
=20
-	devid =3D dwc3_get_device_id();
-	if (devid < 0) {
-		ret =3D -ENOMEM;
-		goto err1;
-	}
-
-	dwc3 =3D platform_device_alloc("dwc3", devid);
+	dwc3 =3D platform_device_alloc("dwc3", PLATFORM_DEVID_AUTO);
 	if (!dwc3) {
 		dev_err(dev, "couldn't allocate dwc3 device\n");
 		ret =3D -ENOMEM;
@@ -172,7 +165,7 @@ static int __devinit dwc3_pci_probe(struct pci_dev *pci,
 	ret =3D platform_device_add_resources(dwc3, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(dev, "couldn't add resources to dwc3 device\n");
-		goto err2;
+		goto err1;
 	}
=20
 	pci_set_drvdata(pci, glue);
@@ -195,10 +188,6 @@ static int __devinit dwc3_pci_probe(struct pci_dev *pc=
i,
 err3:
 	pci_set_drvdata(pci, NULL);
 	platform_device_put(dwc3);
-
-err2:
-	dwc3_put_device_id(devid);
-
 err1:
 	pci_disable_device(pci);
=20
@@ -211,7 +200,6 @@ static void __devexit dwc3_pci_remove(struct pci_dev *p=
ci)
=20
 	platform_device_unregister(glue->usb2_phy);
 	platform_device_unregister(glue->usb3_phy);
-	dwc3_put_device_id(glue->dwc3->id);
 	platform_device_unregister(glue->dwc3);
 	pci_set_drvdata(pci, NULL);
 	pci_disable_device(pci);

--=20
balbi

--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmPfKAAoJEIaOsuA1yqRE3OoQAJEMWvzD1RHWLLZxleoYRUHd
dV4vZsFAMhHPCaOPk7X7iu7U5kVn5tynpNgjzi4/xQrpSDwsEYf4V9NqjfmV3M+c
PjKCc0M2ThYxsWlgIfdTs4OuWTH6swK0tRsQLj1ZNb8QZ0wFpbJVluF0ckdBOKR2
Waon4jaNGHyeV1QKzIcTmjgXMfYENP2QylmywKXtFObGd5yqBvLKVe2/H/YTLGEh
itajRC/R2ECOznAQh+l4nN1bl93o+e5UMYGzGqb0ZRA6IMJHqaNO4ovXiBU/Sfpu
Hv+C50r8tZP1FKDiMCaXKZR63pThKk4Nk77PJwpVTla2ti9IY/TTf5vKKnubjkb3
OAVhZP61QBi0DxrBSSJKPswmt4rxSIVgBEmHAXuNGkWuLLsR/Ja6CTnKGYUN2Ggv
BfHPnZmo6M1O8Fbx+a6VYENNu4V52ikAR+ua+hm7BM0MTOVT4vE0YcRZj/pFmN7x
fEjQIj2uiq+yC99QvFWHSb8BIrHfn0TdNjSiNEEULoBb19oLmf9n887/wowqy6GG
inI8JsYHsO60CxEv7YyDDsrAwX7G3OGUXDNGtiFSbOYNENAKrYUDH6Zd7Js/u9Na
Z9mtBG+e9A8cir7ym32WUQR8c4fiCpslyS9bj7uIW+kSXfpS4X65nXfDGpcxwGvW
9MmHSLcPWDpr9s9W70z5
=3eF1
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
