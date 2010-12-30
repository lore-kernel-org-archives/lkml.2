Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0L3OeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 09:34:21 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:46052 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0L3OeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 09:34:18 -0500
Date: Thu, 30 Dec 2010 15:34:06 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101230143406.GA23219@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
References: <4D1A8200.4010609@lwfinger.net>
 <20101229195440.GD5838@darkside.kls.lan>
 <4D1BD2B0.4020101@lwfinger.net>
 <20101230012003.GA2665@darkside.kls.lan>
 <4D1BF056.3060909@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <4D1BF056.3060909@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 29, 2010 at 08:37:10PM -0600, Larry Finger wrote:
> No, don't bother. I do have a different request. The byte counts for my 3=
2-bit
> system do not match yours. Could you please use the following command to =
find
> the instructions that are failing?
>=20
> objdump -l -d drivers/char/hw_random/core.o | less
>=20
> Use the search to find the start of hwrng_register, then add 0x4c to the
> starting address. Once I see hte instruction that is failing, I should be=
 able
> to find where the failure occurs.

Alright, here we go...

[   30.012695] BUG: unable to handle kernel paging request at 4b28f458
[   30.012708] IP: [<f90703cc>] hwrng_register+0x4c/0x139 [rng_core]

00000380 <hwrng_register>:
hwrng_register():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:299
 380:   56                      push   %esi
 381:   53                      push   %ebx
=2E..
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:312
 3c6:   8b 76 1c                mov    0x1c(%esi),%esi
 3c9:   83 ee 1c                sub    $0x1c,%esi
prefetch():
/tmp/1/linux-source-2.6.37-rc7/arch/x86/include/asm/processor.h:837
 3cc:   8b 46 1c                mov    0x1c(%esi),%eax
 3cf:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
hwrng_register():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:312
 3d3:   81 fe f8 ff ff ff       cmp    $0xfffffff8,%esi
 3d9:   75 d4                   jne    3af <hwrng_register+0x2f>
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:319

   312		list_for_each_entry(tmp, &rng_list, list) {
   313			if (strcmp(tmp->name, rng->name) =3D=3D 0)
   314				goto out_unlock;
   315		}

This is btw. the same data that is accessed in the cat rng_available
crash via hwrng_attr_available_show():

[  389.303538] BUG: unable to handle kernel paging request at 288dcb5b     =
                        =20
[  389.303553] IP: [<f8dda34c>] hwrng_attr_available_show+0x5c/0x90 [rng_co=
re]                     =20

000002f0 <hwrng_attr_available_show>:
hwrng_attr_available_show():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:236
 2f0:   55                      push   %ebp
=2E..
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:245
 346:   8b 5b 1c                mov    0x1c(%ebx),%ebx
 349:   83 eb 1c                sub    $0x1c,%ebx
prefetch():
/tmp/1/linux-source-2.6.37-rc7/arch/x86/include/asm/processor.h:837
 34c:   8b 43 1c                mov    0x1c(%ebx),%eax
 34f:   8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
hwrng_attr_available_show():
/tmp/1/linux-source-2.6.37-rc7/drivers/char/hw_random/core.c:245

   245		list_for_each_entry(rng, &rng_list, list) {
   246			strncat(buf, rng->name, PAGE_SIZE - ret - 1);
   247			ret +=3D strlen(rng->name);
   248			strncat(buf, " ", PAGE_SIZE - ret - 1);
   249			ret++;
   250		}


regards
   Mario
--=20
The problem in the world today is communication. Too much communication.
                                                     -- Homer J. Simpson

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTRyYXhS+e2HeSPbpAQIO4Qf/bA1zCVqmFfz4ZA+Q0B7T2I4I2OFKfFIb
VCt4azZ4ZOm5rIKvRM41wHh0ZKjUkXtkDiqshCkigbv7Iki/yvOT+I9Nr75KDOXe
cxuSnNjXhPDDB2iJfS4P5Pxf+6YvCXoLGw/MneDXSlQPodXnhQI8zCRFCxNqnh7x
p/YDoAJs6uPiVFLg/UFKPeABgh6OdhcnXWlyZq/biTUXQzwFdS3muPu22tDmUOO+
Use49s04/4Gdiv1HUP73r2cBcVp2cSdHZGsCbKRB0dPHpsDhRYPTzpP5XeAzeCvg
Z1k66xr/HNvJzs7EHmBuOXuB6VhM68DjRuHs5a0A13K0q4YEmhYyFA==
=AaAg
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
