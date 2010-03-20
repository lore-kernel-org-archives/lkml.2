Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0CTRRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:17:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54284 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab0CTRR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:17:28 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Airlie <airlied@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, 570321@bugs.debian.org,
       571003@bugs.debian.org, 548090@bugs.debian.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9ieCTxOFKHqnoHSAf1hj"
Date: Sat, 20 Mar 2010 17:17:15 +0000
Message-ID: <1269105436.18314.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: amd64-agp conflicts with sis-agp
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9ieCTxOFKHqnoHSAf1hj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This code in agp_amd64_init() can optionally bind to devices
generically, and it does this without going through the device core:

		/* Look for any AGP bridge */
		dev =3D NULL;
		err =3D -ENODEV;
		for_each_pci_dev(dev) {
			if (!pci_find_capability(dev, PCI_CAP_ID_AGP))
				continue;
			/* Only one bridge supported right now */
			if (agp_amd64_probe(dev, NULL) =3D=3D 0) {
				err =3D 0;
				break;
			}
		}

This is causing crashes on some systems where sis-agp is already bound
to the device.  It could even race with binding of another driver when
they are both built-in.  I think it should be using something like the
following instead of directly calling agp_amd64_probe():

			down(&dev->dev.sem);
			if (!dev->dev.driver &&
			    driver_probe_device(&drv->driver, &dev->dev) =3D=3D 0)
				err =3D 0;
			up(&dev->dev.sem);
			if (err =3D=3D 0)
				break;

Ben.

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-9ieCTxOFKHqnoHSAf1hj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6UDFue/yOyVhhEJAQKfehAAoDYCphbORckl0fB579wmI9t6kBV5R1GB
ZOv8sgsB3v0aLLG2OedOhkYxPm7WQgiKNfFv9UC0AIhoPoRBffGDolzAmjdXGPgD
4hX0zbUhoNoCnc9S7Kfax9dD6D62gDIbYp1W9ZsTVfPhP+5mQSpSxjNZyk8R0UF5
+6Q9dQy8hR/kytTshUa87wM/A0aIJr8jL9rp9fa8y9anjhfK0Pl7N++xvJM1Jm+0
gPRKT1JZfuV3cC8V8XGq4u3PXVHhFxNZxZb3fs4vfBMqT5QW570nKb8UlFwrydAw
hZJyNK8VrSlEnNjkIC7jTGTK7iQsFggu7UJTXOU5q53n75vUJqRYZzci0fXVFddX
clCBq2gpCgB5DHmRxmcJPoiNbcFLdURecVxkawJMZyh9MKoMRiSNn60leaCaWVqc
wBjdK5NE35qujcXK7QQs3uOKY/X/QyIh1TLUTAgp85XUN9DHQYBYPK+xzeTtgwqf
ZWF+WocUg8bU+XxCnCkrJnqWAAQXJtm4qoUFS3bevw7qzX6caFPY/ciy+sXvkD4r
6lHRp1LhTMpk/uiw+xnlS4310HznA5mE/6erW3NMATFH2/XIr93oZ4R6scZhpSwy
aOVFPbHsoXQ2ircX3zDiUmX7hufPWwGazlrH1KEXVqdc5iFr0BoXN3vydUvYo+bx
0X4YIuUpXzQ=
=/cD2
-----END PGP SIGNATURE-----

--=-9ieCTxOFKHqnoHSAf1hj--
