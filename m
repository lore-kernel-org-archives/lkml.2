Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2BQDQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:16:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49728 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab2BQDQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:16:53 -0500
Message-ID: <1329448597.3258.28.camel@deadeye>
Subject: Re: [RFC PATCH] kbuild: Build linux-tools package with 'make
 deb-pkg'
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>
Date: Fri, 17 Feb 2012 03:16:37 +0000
In-Reply-To: <1329418664-1750-1-git-send-email-joerg.roedel@amd.com>
References: <1329418664-1750-1-git-send-email-joerg.roedel@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mlPPGaCA8kQTqq445apW"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mlPPGaCA8kQTqq445apW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-16 at 19:57 +0100, Joerg Roedel wrote:
> Also build a linux-tools package for installation so that
> common tools run without issues (e.g. perf).
>=20
> [RFC note: This may break with x-compilation when the
>            x-compilation environment is not set up to
> 	   compile user-space programs. Is that acceptable?
> 	   I also thought about a compile-time parameter
> 	   such as 'make TOOLS=3D1 deb-pkg' or a special
> 	   'make deb-tools-pkg' target.	Opinions? ]
>=20
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: maximilian attems <max@stro.at>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: debian-kernel@lists.debian.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  scripts/package/builddeb |   55 ++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 files changed, 54 insertions(+), 1 deletions(-)
>=20
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index eee5f8e..8466380 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -78,17 +78,19 @@ tmpdir=3D"$objtree/debian/tmp"
>  fwdir=3D"$objtree/debian/fwtmp"
>  kernel_headers_dir=3D"$objtree/debian/hdrtmp"
>  libc_headers_dir=3D"$objtree/debian/headertmp"
> +tools_dir=3D"$objtree/debian/toolstmp"
>  packagename=3Dlinux-image-$version
>  fwpackagename=3Dlinux-firmware-image
>  kernel_headers_packagename=3Dlinux-headers-$version
>  libc_headers_packagename=3Dlinux-libc-dev
> +tools_packagename=3Dlinux-tools-$version

The advice I got from one of the perf developers - possibly Peter
Zijlstra - was that changes to the perf kernel interface are backward-
compatible but newer versions of the perf tool may depend on newer
kernel features.  New features involve a bump to the 2nd (at the time,
it was the 3rd) version component unless you're building from a perf
development branch.

So to avoid package proliferation the package name should be
linux-tools-$VERSION.$PATCHLEVEL and the executable filenames should be
something like perf_$VERSION.$PATCHLEVEL-$subcommand.  This is what we
do in Debian.

However, Ubuntu uses the full kernel release string (as do several
RPM-based distributions).  So at the moment you can't build a versioned
perf that's going to work in both.  But that is fixable if one of the
perf wrappers is changed to fall back to the alternate naming scheme.

[...]
> +# Build the tools
> +num_tools=3D"0"
> +tools_flavour_abi=3D${version#*-}
> +tools_flavour=3D${tools_flavour_abi#*-}
> +tools_version=3D${version%-$tools_flavour}
> +if grep -q '^CONFIG_PERF_EVENTS=3Dy' .config ; then
> +	# Build perf
> +	(
> +	 mkdir -p $objtree/tools/perf
> +	 cd "$srctree/tools/perf"
> +	 $MAKE LDFLAGS=3D O=3D$O/tools/perf
> +	 cp $objtree/tools/perf/perf "$tools_dir/usr/bin/perf_$tools_version"
[...]

What about the manual pages and scripting support?

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-mlPPGaCA8kQTqq445apW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATz3Glee/yOyVhhEJAQrNshAAsdBhGsk/fejROEveJIfJCZljdBIM8m0U
Y+atVJNWMirPaYzbGK2hlssgZ75U0cvQEzeSM+fow8+7OrdRIOq2Y9S1wCENUoT+
t/NIH6f8YwBzRPZp7AwHw1Ss8/Aw9UYvVOxCSU5CUqOKCLFL28uE1WkxU45OCwFS
HoW8pWzF1VKL/owOCj74IjfxmJp3RuikqETywFU4tNYiNZbKX6U+f2BoUMwn/5vr
XzFkdLkTJkTo8i0BEjDdWV6r54JMO4TpjI/BFad42bXm1oay64brfvKN+ZiX+dQc
YCdnRuFlYFgJGzOPWC4eozY02KUfst6Iyo0pC8jNYTSEGcNFZI1kE9vcbGCJTGjN
eFZxDMxZKZm+SUGNN17TPlXj7vWKfjO/Hws8QnGZ7kZEl1DA+Vgt43sbTWJl+nvR
xfdmKqhIQzSWsP0BPZJF4vQnrCqF4fD+oFK6XsD8B+Mf3ZK49fUAhvSDxOZES0Zn
OHw6vuXwXuFMQoCa/TM8DgmE0i7v2PwzdK94YRfwRn1QsVxddIuvB+Je7JfQKVIZ
Q+9gm2KNc/dXNG2zh6szFyuWWeQK9cbmyyyHpTXmNjO9mOZ6jpONzy1MHL73IAwG
vZXha/OWPBDoe+5p3lh+eaOg420EH3n4OItavP2qtVO6IEp43Q1g0rnvu87xIP7G
f2HSqkV3s10=
=tsV+
-----END PGP SIGNATURE-----

--=-mlPPGaCA8kQTqq445apW--
