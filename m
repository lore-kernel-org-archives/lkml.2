Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0DYKfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 06:35:47 -0400
Received: from vps.mortis.eu ([79.99.135.181]:33044 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0DYKfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 06:35:46 -0400
Date: Sun, 25 Apr 2010 12:35:40 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hwmon: f71882fg: use a muxed resource lock for the
 Super I/O port
Message-ID: <20100425103540.GA5185@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <1269523063-30346-2-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1269523063-30346-2-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2010 at 02:17:42PM +0100, Giel van Schijndel wrote:
> Sleep while acquiring a resource lock on the Super I/O port. This should
> prevent collisions from causing the hardware probe to fail with -EBUSY.

Fix a bug which caused f71882fg_find() to pretend to be succesfull on
Super I/O ports which didn't have a Fintek chip attached.  This was
caused by returning 0 instead of -ENODEV, adding several 'err =3D -ENODEV'
statements preceding the 'goto exit' statements fixed this.

Patch follows this line:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sleep while acquiring a resource lock on the Super I/O port. This should
prevent collisions from causing the hardware probe to fail with -EBUSY.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 7857ed3..85512a7 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -113,7 +113,7 @@ static struct platform_device *f71882fg_pdev;
 /* Super-I/O Function prototypes */
 static inline int superio_inb(int base, int reg);
 static inline int superio_inw(int base, int reg);
-static inline void superio_enter(int base);
+static inline int superio_enter(int base);
 static inline void superio_select(int base, int ld);
 static inline void superio_exit(int base);
=20
@@ -883,11 +883,20 @@ static int superio_inw(int base, int reg)
 	return val;
 }
=20
-static inline void superio_enter(int base)
+static inline int superio_enter(int base)
 {
+	/* Don't step on other drivers' I/O space by accident */
+	if (!request_muxed_region(base, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
+				(int)base);
+		return -EBUSY;
+	}
+
 	/* according to the datasheet the key must be send twice! */
 	outb(SIO_UNLOCK_KEY, base);
 	outb(SIO_UNLOCK_KEY, base);
+
+	return 0;
 }
=20
 static inline void superio_select(int base, int ld)
@@ -899,6 +908,7 @@ static inline void superio_select(int base, int ld)
 static inline void superio_exit(int base)
 {
 	outb(SIO_LOCK_KEY, base);
+	release_region(base, 2);
 }
=20
 static inline int fan_from_reg(u16 reg)
@@ -2239,21 +2249,15 @@ static int f71882fg_remove(struct platform_device *=
pdev)
 static int __init f71882fg_find(int sioaddr, unsigned short *address,
 	struct f71882fg_sio_data *sio_data)
 {
-	int err =3D -ENODEV;
 	u16 devid;
-
-	/* Don't step on other drivers' I/O space by accident */
-	if (!request_region(sioaddr, 2, DRVNAME)) {
-		printk(KERN_ERR DRVNAME ": I/O address 0x%04x already in use\n",
-				(int)sioaddr);
-		return -EBUSY;
-	}
-
-	superio_enter(sioaddr);
+	int err =3D superio_enter(sioaddr);
+	if (err)
+		return err;
=20
 	devid =3D superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid !=3D SIO_FINTEK_ID) {
 		pr_debug(DRVNAME ": Not a Fintek device\n");
+		err =3D -ENODEV;
 		goto exit;
 	}
=20
@@ -2280,6 +2284,7 @@ static int __init f71882fg_find(int sioaddr, unsigned=
 short *address,
 	default:
 		printk(KERN_INFO DRVNAME ": Unsupported Fintek device: %04x\n",
 		       (unsigned int)devid);
+		err =3D -ENODEV;
 		goto exit;
 	}
=20
@@ -2290,12 +2295,14 @@ static int __init f71882fg_find(int sioaddr, unsign=
ed short *address,
=20
 	if (!(superio_inb(sioaddr, SIO_REG_ENABLE) & 0x01)) {
 		printk(KERN_WARNING DRVNAME ": Device not activated\n");
+		err =3D -ENODEV;
 		goto exit;
 	}
=20
 	*address =3D superio_inw(sioaddr, SIO_REG_ADDR);
 	if (*address =3D=3D 0) {
 		printk(KERN_WARNING DRVNAME ": Base address not set\n");
+		err =3D -ENODEV;
 		goto exit;
 	}
 	*address &=3D ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
@@ -2306,7 +2313,6 @@ static int __init f71882fg_find(int sioaddr, unsigned=
 short *address,
 		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
 exit:
 	superio_exit(sioaddr);
-	release_region(sioaddr, 2);
 	return err;
 }
=20
--=20
1.6.4.4


--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvUGvkACgkQZBYm/87l50LoEACgvHp5cu65SHygI2QXkUzGCk6/
PAYAn1itfNFGLs+oipvX353DDK5Y7q0u
=3gy2
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
