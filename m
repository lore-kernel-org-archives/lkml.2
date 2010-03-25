Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0CYKkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:40:22 -0400
Received: from vps.mortis.eu ([79.99.135.181]:35328 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab0CYKkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:40:19 -0400
Date: Thu, 25 Mar 2010 11:40:15 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for
 F71808E and F71889
Message-ID: <20100325104014.GC20126@salidar.me.mortis.eu>
References: <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
 <1269385936-3440-4-git-send-email-me@mortis.eu>
 <4BA9CF57.4030504@redhat.com>
 <20100324093651.GG6368@salidar.me.mortis.eu>
 <4BA9EA5C.9060506@redhat.com>
 <20100324153550.GK6368@salidar.me.mortis.eu>
 <20100324155151.2482952f@lxorguk.ukuu.org.uk>
 <20100325085450.GA20126@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <20100325085450.GA20126@salidar.me.mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2010 at 09:54:50AM +0100, Giel van Schijndel wrote:
> On Wed, Mar 24, 2010 at 03:51:51PM +0000, Alan Cox wrote:
>>> hold on the SIO port range. This would thus interfere with the
>>> operation of the f71882fg driver. I.e. it would prevent the device
>>> probing stage from working, thus preventing it from loading *after*
>>> my in-development watchdog driver.
>>=20
>> There are two ways to deal with that really
>>=20
>> ... snip ...
>>
>> 2. Fix the kernel request_resource stuff to support a sleeping non
>> exclusive resource so request/free of regions can be used as a resource
>> semaphore by co-operative devices.
>>=20
>> #2 is actually not hard but when I did the patch originally it then
>> wasn't needed by the driver I had in mind for other reasons.
>>=20
>> See http://groups.google.com/group/linux.kernel/msg/1425fc2aad32e6ea
>>=20
>> Maybe its worth resurrecting ?
>=20
> In this particular case I most definitely think it's worth resurrecting.
> Using your patch (I had to change the IORESOURCE_MUXED constant's value
> though) I can completely solve the I/O sharing issue for the f71882fg +
> watchdog case with only a single line modification to the f71882fg
> driver.
>=20
> ... snip ...

Using Alan's patch and the one following the dashed line I can implement
(and have already done so) a separate watchdog driver for the Fintek
F71808E.

Should I just ask for this patch to be applied together with Alan's?
Then submit the new driver? (I'm a bit new to the non-technical aspects
of Linux kernel development).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
hwmon: f71882fg: use a muxed resource lock for the Super I/O port

Sleep while acquiring a resource lock on the Super I/O port. This should
prevent collisions from causing the hardware probe to fail with -EBUSY.
---
 drivers/hwmon/f71882fg.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 7857ed3..e09416d 100644
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
@@ -2239,17 +2249,10 @@ static int f71882fg_remove(struct platform_device *=
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
@@ -2306,7 +2309,6 @@ static int __init f71882fg_find(int sioaddr, unsigned=
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

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkurPY4ACgkQZBYm/87l50LdLwCeMIThd8aDVCc1F/Dvpu2rjEgT
3GcAoJULDnvL0Xwic5mMFRcVSUzulW4Y
=zL/H
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
