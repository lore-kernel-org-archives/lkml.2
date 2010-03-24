Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0CXPfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:35:55 -0400
Received: from vps.mortis.eu ([79.99.135.181]:54926 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab0CXPfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:35:54 -0400
Date: Wed, 24 Mar 2010 16:35:51 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for
 F71808E and F71889
Message-ID: <20100324153550.GK6368@salidar.me.mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
 <1269385936-3440-4-git-send-email-me@mortis.eu>
 <4BA9CF57.4030504@redhat.com>
 <20100324093651.GG6368@salidar.me.mortis.eu>
 <4BA9EA5C.9060506@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLfjTIIQuAzj8yil"
Content-Disposition: inline
In-Reply-To: <4BA9EA5C.9060506@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLfjTIIQuAzj8yil
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 24, 2010 at 11:33:00AM +0100, Hans de Goede wrote:
> On 03/24/2010 10:36 AM, Giel van Schijndel wrote:
>>On Wed, Mar 24, 2010 at 09:37:43AM +0100, Hans de Goede wrote:
>>> Nack:
>>> As the watchdog has its own SIO logical device number, it should
>>> have a separate driver, not have support glued to the hwmon driver.
>>
>> Thus, if I understand correctly, you would suggest for me to
>> implement a new driver in drivers/watchdog/ to implement this
>> feature?
>=20
> Yes, correct.

So I've now started out working on moving the watchdog code to a
separate driver.

  I/O port conflict

However, this driver would have to lock the SIO port range as well.
Unlike the hardware monitor, however, the watchdog (VID controller on
some datasheets) doesn't appear to provide for an alternative I/O port
mapping. Meaning the wathdog driver would have to maintain a permanent
hold on the SIO port range. This would thus interfere with the operation
of the f71882fg driver. I.e. it would prevent the device probing stage
=66rom working, thus preventing it from loading *after* my in-development
watchdog driver.

  Alternative logical device port mapping

Regarding address mapping: the 16 bit SIO_REG_ADDR(0x60) register does
exist for this logical device, though according to the datasheet it is
set to 0x0000 by default. Reading the value from hardware it claims to
be mapped on 0x0AE0, trying to read from that port range (using
f71882fg_read8) yields nothing more than 0xFF for any register mentioned
in the datasheet.

  Hardware monitor alternate port range

Further, when looking at the way that SIO_REG_ADDR is currently used by
the f71882fg driver I get more confused:
> *hwmon_addr =3D superio_inw(sioaddr, SIO_REG_ADDR);
>     /* error checking: *hwmon_addr !=3D 0 */
> *hwmon_addr &=3D ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */

For the F71808E and F71889, which both have 0x295, for hardware monitor
base address that code ^^ combined with the addition of ADDR_REG_OFFSET
and DATA_REG_OFFSET (see f71882fg_(read|write)8) all of this basically
amounts to mangling 0x295 -> 0x290 -> (0x295,0x296).

So my question: is there any particular reason for performing this
address mangling? Mostly: is there anything there that I should try
replicating in order to get mapping of the watchdog device on an
alternate port range working?

PS Perhaps this would be easier to converse about if you had the
   datasheet?

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--SLfjTIIQuAzj8yil
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuqMVYACgkQZBYm/87l50LeyQCgm0bD6ZaLA5SyokG9J5Vrxldr
r6MAoKE9cW4LifwRb9H/U+qb4/wt7nSa
=ZRlK
-----END PGP SIGNATURE-----

--SLfjTIIQuAzj8yil--
