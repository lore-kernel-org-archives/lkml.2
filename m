Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0D0Mxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:53:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59486 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0D0Mxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:53:45 -0400
Date: Tue, 27 Apr 2010 14:53:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Message-ID: <20100427125334.GE1775@pengutronix.de>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk> <1272316279-12042-2-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <1272316279-12042-2-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 26, 2010 at 11:11:16PM +0200, Nicolas Palix wrote:
> Four targets are added. Each one generates a different
> output kind: context, patch, org, report.
> Every SmPL file in 'scripts/smpl' is given to the spatch frontend
> (located in the 'scripts' directory), and applied to the entire
> source tree.
>=20
> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> ---
>  MAINTAINERS       |   10 ++++++++++
>  Makefile          |    9 +++++++++
>  scripts/spatch.sh |   14 ++++++++++++++
>  3 files changed, 33 insertions(+), 0 deletions(-)
>  create mode 100755 scripts/spatch.sh
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d29fa3..2aab763 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1533,6 +1533,16 @@ L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/classmate-laptop.c
> =20
> +COCCINELLE
> +M:	Julia Lawall <julia@diku.dk>
> +M:	Gilles Muller <Gilles.Muller@lip6.fr>
> +M:	Nicolas Palix <npalix@diku.dk>
> +L:	cocci@diku.dk
> +W:	http://coccinelle.lip6.fr/
> +S:	Supported
> +F:	scripts/smpl/
> +F:	scripts/spatch.sh
> +
>  CODA FILE SYSTEM
>  M:	Jan Harkes <jaharkes@cs.cmu.edu>
>  M:	coda@cs.cmu.edu
> diff --git a/Makefile b/Makefile
> index 67c1001..293c88b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -325,6 +325,7 @@ INSTALLKERNEL  :=3D installkernel
>  DEPMOD		=3D /sbin/depmod
>  KALLSYMS	=3D scripts/kallsyms
>  PERL		=3D perl
> +SPATCH          =3D spatch
>  CHECK		=3D sparse
> =20
>  CHECKFLAGS     :=3D -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
> @@ -1424,6 +1425,14 @@ versioncheck:
>  		-name '*.[hcS]' -type f -print | sort \
>  		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
> =20
> +coccicheck-context coccicheck-patch coccicheck-org coccicheck-report:
> +	@echo "\nPlease, check for false positive in the output before submitti=
ng a patch.\n\n"\
> +		"Take particularly attention when using the \"patch\" mode\n"\
> +		"and carefully review the patch YOU are about to submit.\n"
> +	@find $(srctree)/scripts/smpl/                        \
> +		-name '*.cocci' -type f                       \
> +		-exec $(srctree)/scripts/spatch.sh $(SPATCH) $(@:coccicheck-%=3D%) \{}=
 $(srctree) \;
> +
>  namespacecheck:
>  	$(PERL) $(srctree)/scripts/namespace.pl
> =20
> diff --git a/scripts/spatch.sh b/scripts/spatch.sh
> new file mode 100755
> index 0000000..bdcca15
> --- /dev/null
> +++ b/scripts/spatch.sh
> @@ -0,0 +1,14 @@
> +#!/bin/sh
> +
> +SPATCH=3D"$1"
> +MODE=3D"$2"
> +COCCI=3D"$3"
> +DIR=3D"$4"
> +
> +OPT=3D`grep "Option" $COCCI | cut -d':' -f2`
> +FILE=3D`echo $COCCI | sed "s|$DIR/||"`
> +
> +echo Processing `basename $COCCI` with \"$OPT\"
> +echo Message example to submit a patch:
> +grep "^///" $COCCI | sed "s|///||" | sed "s|THISFILE|$FILE|"

I think the part containing "THISFILE" the patches should be generated here=
 at
runtime. Also, the grep-command can be done via sed.

> +$SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
> --=20
> 1.6.3.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvW3k4ACgkQD27XaX1/VRsFAACffbIqdnDKBpPH6QFens9VvuQ4
SykAn0spAWdEoWEafJDulDtKXYA8O+kn
=bomk
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
