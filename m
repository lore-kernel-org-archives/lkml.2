Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2GQOIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:08:20 -0400
Received: from lake.fysh.org ([81.94.195.195]:55106 "EHLO lake.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2GQOIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:08:17 -0400
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 10:08:17 EDT
Date: Tue, 17 Jul 2012 14:52:01 +0100
From: Athanasius <link@miggy.org>
To: =?utf-8?Q?Adri=C3=A1n?= <adrianbn@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Setreuid distinction about (uid_t)-1
Message-ID: <20120717135201.GF1638@fysh.org>
Mail-Followup-To: =?utf-8?Q?Adri=C3=A1n?= <adrianbn@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 17, 2012 at 10:27:55AM +0100, Adri=C3=A1n wrote:
>         uid =3D atoi(argv[1]);
>         printf("%u\n",uid);
>         if (setreuid(uid,uid)=3D=3D-1){
>                 printf("Setreuid to %u failed\n ",uid);
>                 perror("E");
>                 exit(1);
>         }
>         execve("/bin/sh",args,NULL);
>=20
> I've been calling this binary with a bunch of different uid numbers,
> and I came across this weird behaviour with the (uid_t) -1 value:

  From the man page:

       Supplying a value of -1 for either the real or effective user ID for=
ces
       the system to leave that ID unchanged.
=09
> adrian@home-pc:~$ /tmp/suid-tests
> Usage: /tmp/suid-tests target_uid
> adrian@home-pc:~$ /tmp/suid-tests 0
> 0
> Setreuid to 0 failed
> E: Operation not permitted
> adrian@home-pc:~$ /tmp/suid-tests -1
> 4294967295

  So this succeeded, by actually doing nothing.

> $ id
> uid=3D1000(adrian) gid=3D1000(adrian)
> groups=3D1000(adrian),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmi=
n),110(sambashare),111(admin)
> adrian@home-pc:~$ /tmp/suid-tests -2
> 4294967294
> Setreuid to 4294967294 failed
> E: Operation not permitted
> adrian@home-pc:~$ /tmp/suid-tests -3
> 4294967293
> Setreuid to 4294967293 failed
> E: Operation not permitted
>=20
> If the binary is setuid, the -1 call effectively rises the euid to
> root (0), although other arbitrary values are properly being set:

  Because, again, -1 asks to leave things as is.  And as you've made
the binary setuid and owned by root when you run it euid is set to 0, and
the -1 leaves it alone.

> adrian@home-pc:~$ ls -hl /tmp/suid-tests
> -rwsr-x--- 1 root adrian 8,5K 2012-07-17 10:53 /tmp/suid-tests
> adrian@home-pc:~$ /tmp/suid-tests -1
> 4294967295
> # id
> uid=3D1000(adrian) gid=3D1000(adrian) euid=3D0(root)
> groups=3D0(root),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),11=
0(sambashare),111(admin),1000(adrian)

  Yup, totally as expected.

> adrian@home-pc:~$ /tmp/suid-tests -2
> 4294967294
> $ id
> uid=3D4294967294 gid=3D1000(adrian)
> groups=3D4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambas=
hare),111(admin),1000(adrian)

  -2 isn't a magic value, but as you're euid =3D=3D 0 the kernel will do
what you asked and set uid to '-2', with some signed/unsigned conversion
going on you get 4294967294.

--=20
- Athanasius =3D Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlAFbgAACgkQSEDmQuIYzh2dSACfT+xjClQw/I68T7PnaF1W32B6
kNcAmQHtVTb0S+oc2TIwy0uVZAO6K2Vc
=7GG0
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
