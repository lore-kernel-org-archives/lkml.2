Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0CXJel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:34:41 -0400
Received: from vps.mortis.eu ([79.99.135.181]:46764 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0CXJek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:34:40 -0400
Date: Wed, 24 Mar 2010 10:34:37 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: properly acquire I/O regions while
 probing
Message-ID: <20100324093437.GF6368@salidar.me.mortis.eu>
References: <1269353535-23134-1-git-send-email-me@mortis.eu>
 <20100324102942.215ee413@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
In-Reply-To: <20100324102942.215ee413@hyperion.delvare>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 10:29:42AM +0100, Jean Delvare wrote:
> On Tue, 23 Mar 2010 15:12:15 +0100, Giel van Schijndel wrote:
>>  static u16 f71882fg_read_temp(struct f71882fg_data *data, int nr)
>> @@ -2184,6 +2178,13 @@ static int __init f71882fg_find(int sioaddr, unsi=
gned short *address,
>>  	int err =3D -ENODEV;
>>  	u16 devid;
>> =20
>> +	/* Don't step on other driver's I/O space by accident */
>> +	if (!request_region(sioaddr, 2, DRVNAME)) {
>> +		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
>> +				(int)sioaddr);
>> +		return -EIO;
>=20
> This is the wrong error code. This isn't an I/O error. You want -EBUSY.

Ack. New patch follows this line.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
hwmon: f71882fg: acquire I/O regions while we're working with them

Acquire the I/O region for the Super I/O chip while we're working on it.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index ca34e5c..537841e 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -2178,6 +2178,13 @@ static int __init f71882fg_find(int sioaddr, unsigne=
d short *address,
 	int err =3D -ENODEV;
 	u16 devid;
=20
+	/* Don't step on other drivers' I/O space by accident */
+	if (!request_region(sioaddr, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
+				(int)sioaddr);
+		return -EBUSY;
+	}
+
 	superio_enter(sioaddr);
=20
 	devid =3D superio_inw(sioaddr, SIO_REG_MANID);
@@ -2232,6 +2239,7 @@ static int __init f71882fg_find(int sioaddr, unsigned=
 short *address,
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
 exit:
 	superio_exit(sioaddr);
+	release_region(sioaddr, 2);
 	return err;
 }
=20
--=20
1.6.4.4

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkup3K0ACgkQZBYm/87l50L9RwCfWhU0CylEH9NWCC6Vdug5d/b2
PisAn0NUM+GV3cB+9Q2cT89dTBp00EwI
=J642
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
