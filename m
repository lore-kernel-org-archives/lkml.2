Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2EaCGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:06:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40282 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2EaCGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:06:47 -0400
Date: Thu, 31 May 2012 12:06:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: linux-next: manual merge of the drivers-x86 tree with Linus' tree
Message-Id: <20120531120635.209266aabe1b08ebc4595249@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_12_06_35_+1000_hlq+kNlJ9kQg/HSH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_12_06_35_+1000_hlq+kNlJ9kQg/HSH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/toshiba_acpi.c between commit f5f4fd451634
("backlight: initialize struct backlight_properties properly") from
Linus' tree and commit 7d307fbdefbf ("toshiba_acpi: Only register
backlight device when interface is read/write") from the drivers-x86 tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/toshiba_acpi.c
index 57787d8,bde32de..0000000
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@@ -1020,6 -1069,54 +1069,55 @@@ static int __devinit toshiba_acpi_setup
  	return error;
  }
 =20
+ static int __devinit toshiba_acpi_setup_backlight(struct toshiba_acpi_dev=
 *dev)
+ {
+ 	struct backlight_properties props;
+ 	int brightness;
+ 	int ret;
+ 	bool enabled;
+=20
+ 	/*
+ 	 * Some machines don't support the backlight methods at all, and
+ 	 * others support it read-only. Either of these is pretty useless,
+ 	 * so only register the backlight device if the backlight method
+ 	 * supports both reads and writes.
+ 	 */
+ 	brightness =3D __get_lcd_brightness(dev);
+ 	if (brightness < 0)
+ 		return 0;
+ 	ret =3D set_lcd_brightness(dev, brightness);
+ 	if (ret) {
+ 		pr_debug("Backlight method is read-only, disabling backlight support\n"=
);
+ 		return 0;
+ 	}
+=20
+ 	/* Determine whether or not BIOS supports transflective backlight */
+ 	ret =3D get_tr_backlight_status(dev, &enabled);
+ 	dev->tr_backlight_supported =3D !ret;
+=20
++	memset(&props, 0, sizeof(props));
+ 	props.type =3D BACKLIGHT_PLATFORM;
+ 	props.max_brightness =3D HCI_LCD_BRIGHTNESS_LEVELS - 1;
+=20
+ 	/* adding an extra level and having 0 change to transflective mode */
+ 	if (dev->tr_backlight_supported)
+ 		props.max_brightness++;
+ 	dev->backlight_dev =3D backlight_device_register("toshiba",
+ 						       &dev->acpi_dev->dev,
+ 						       dev,
+ 						       &toshiba_backlight_data,
+ 						       &props);
+ 	if (IS_ERR(dev->backlight_dev)) {
+ 		ret =3D PTR_ERR(dev->backlight_dev);
+ 		pr_err("Could not register toshiba backlight device\n");
+ 		dev->backlight_dev =3D NULL;
+ 		return ret;
+ 	}
+=20
+ 	dev->backlight_dev->props.brightness =3D brightness;
+ 	return 0;
+ }
+=20
  static int toshiba_acpi_remove(struct acpi_device *acpi_dev, int type)
  {
  	struct toshiba_acpi_dev *dev =3D acpi_driver_data(acpi_dev);

--Signature=_Thu__31_May_2012_12_06_35_+1000_hlq+kNlJ9kQg/HSH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxtIrAAoJEECxmPOUX5FELsMP/j81dgr3nkcw4rtyXqT3TEfC
0Xo1sgH6Jd1r9DCGNX1K+ccSF5/9Tm9kGJWjjsZv6WmSc3nFSZDr+O+vOsITb6s9
J35kYRtE6TJlJwwXJZ1kcny9wmml34UoqdSZypnbKZy3Dbr4YNfiTS5smMAUUT8y
sJTS+0tkThU5fFPAkFJid/8UhFmbDkBXymtSCmLEWJybOv7BYM7PZ2U1tCb1eV2F
uXw2etDIQinadvdyMeuXjiAy/CV2/kOiHIOO8uJ7u0K8MyiwYdCPaSiJlg3MzaRO
fATaMlbWK1N+rkSldYodwcdhWd7SLO66ACGgVPZ+yeVsGPE4QXF3KPAaasrao+SJ
1u/hnrRlzWnOF3yvX/nlYnnP+GjvawtLDgVOcFrQ5RjIRyNVHXx0HiZMT0q9LMdT
3BsIVVUF5SM735C9lBRZPf27fuilihYhXtQPgNUjOXNtHcB68931yC0NEsvS0Ne2
73YaeIFpe8/9uK8W7FkrQanQmMv8loHQ8wArc7Yxz/1HdPXcdMSCZzrmzUSTsDWY
rHGHzrMMnKLxj3n9WJUCSqn7cr6PzVlouA3YeoiUOvqkzJ/frZe6ywkOtxC5Y/eY
fGDxMst1j3bhtYEjcQ3wFGV5G/VPE4vx5XymfZxX6/ZwfMyWOn1LMktO+Do2dQkR
YkxQT0OL3PAD7Z5+P69t
=YQol
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_12_06_35_+1000_hlq+kNlJ9kQg/HSH--
