Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2BNCtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:49:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab2BNCtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:49:22 -0500
Message-ID: <1329187753.3048.44.camel@deadeye>
Subject: Re: [PATCH v2] kbuild: Fix link to headers in 'make deb-pkg'
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org
Date: Tue, 14 Feb 2012 02:49:13 +0000
In-Reply-To: <1329144538-21444-1-git-send-email-joerg.roedel@amd.com>
References: <1329144538-21444-1-git-send-email-joerg.roedel@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rSN6HFuXI7pcwX3bMymI"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rSN6HFuXI7pcwX3bMymI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-13 at 15:48 +0100, Joerg Roedel wrote:
> The Link to the kernel header files in the debian packages
> point to the original build directory. This is a bad choice
> if the packages were installed on a different machine. Fix
> this in by manually re-creating the link in the builddeb
> script.
>=20
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: maximilian attems <max@stro.at>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: debian-kernel@lists.debian.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

This looks good for !UML.

I wonder about the UML case though.  Did you test it?  In 3.3-rc3,
'make headers_install' is broken.  But if I suppress the header check,
the resulting packages have links in the right places.

I'm also unconvinced that anyone will be interested in building an OOT
module for UML; and if they do their build script or makefile will use
'make -C /lib/modules/<version>/build' which won't work.  Maybe for UML
we should only build the 'image' package?

Ben.

> ---
>  scripts/package/builddeb |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index f6cbc3d..fc3f76a 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -97,6 +97,7 @@ mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
>  mkdir -p "$libc_headers_dir/usr/share/doc/$libc_headers_packagename"
>  mkdir -m 755 -p "$kernel_headers_dir/DEBIAN"
>  mkdir -p "$kernel_headers_dir/usr/share/doc/$kernel_headers_packagename"
> +mkdir -p "$kernel_headers_dir/lib/modules/$version/"
>  if [ "$ARCH" =3D "um" ] ; then
>  	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
>  fi
> @@ -121,6 +122,8 @@ fi
> =20
>  if grep -q '^CONFIG_MODULES=3Dy' .config ; then
>  	INSTALL_MOD_PATH=3D"$tmpdir" make KBUILD_SRC=3D modules_install
> +	rm -f "$tmpdir/lib/modules/$version/build"
> +	rm -f "$tmpdir/lib/modules/$version/source"
>  	if [ "$ARCH" =3D "um" ] ; then
>  		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$vers=
ion/"
>  		rmdir "$tmpdir/lib/modules/$version"
> @@ -245,6 +248,12 @@ destdir=3D$kernel_headers_dir/usr/src/linux-headers-=
$version
>  mkdir -p "$destdir"
>  (cd $srctree; tar -c -f - -T /tmp/files$$) | (cd $destdir; tar -xf -)
>  (cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
> +ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/module=
s/$version/build"
> +if [ "$ARCH" =3D "um" ] ; then
> +	mkdir -p "$kernel_headers_dir/usr/lib/uml/modules/$version/"
> +	mv "$kernel_headers_dir/lib/modules/$version"/* "$kernel_headers_dir/us=
r/lib/uml/modules/$version/"
> +	rmdir "$kernel_headers_dir/lib/modules/$version"
> +fi
>  rm -f /tmp/files$$ /tmp/objfiles$$
>  arch=3D$(dpkg --print-architecture)
> =20

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-rSN6HFuXI7pcwX3bMymI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATznLqee/yOyVhhEJAQox8hAA1Pa2wUuvU5068xH3wBwtmv+LUHaEh9Qd
ogsWBu0/1ZCd8q0Mm4U5fHhYIsXaxPmrU/tzJ87T3pCDJFJ4373iYUMLaCbJktS3
RaYd7uS6NUgQkGQ4eWCQIM2GeZAYsy+ZhFzHKfGDwahX78IaHFDOCGAacCRgHLrF
bBN4uuoz/83uEmx4XZZ1aAA3jxXnsGGaSqok6sZoCMW+A66851wQCg97eKnLYcbh
QvTtyWFX7kJ/d2UIgvfG591MJDDLOKIT5/AUUWoQ9qO/bO4t/iwOh63Mdq048PKX
JLfwOKy2P781bh5EayeJKZXhY4XW1vk5Z79c27W9dllzS5sj9fjG1nPzWuqq4xEd
1dQE12Vm0pVxHZ8oG0u5YML534crWG7HC1T+3kNEjaXnUP2lYuhbMXB/zmwNIWGB
qDbwQXG9uPeBuSogKt4PLPaWntFruiwTERADTaxGUrFwQz++kYLxwvwM3Ma4FAZM
139yHZHXTiIjhCWMk+LNJtRL6c1Ip6HiQ77GfPRgbXnydXaUCmczSahtq/Jh8zcR
DcYVhmphNae3PoEl6XdXEYBrY1lBpcvxDoWFf3vnc7iJ75v/JerdG8EF/xhSqRNs
0SZt4Pud4/zsQYcll8OJ+H7ddT9MkaW+VRN6+I5r26wONAGWs0wwm4jdY0/B0+7c
YMJZF1DYWQs=
=wEvK
-----END PGP SIGNATURE-----

--=-rSN6HFuXI7pcwX3bMymI--
