Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab2DJAfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:35:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44685 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2DJAfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:35:04 -0400
Date: Tue, 10 Apr 2012 10:34:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tile tree with Linus' tree
Message-Id: <20120410103452.0783213f251d0c8302b4eec2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_10_34_52_+1000_ke9l4GIul9VKMv=p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_10_34_52_+1000_ke9l4GIul9VKMv=p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the tile tree got a conflict in
arch/tile/kernel/single_step.c between commit cdd8e16feba8 ("arch/tile:
return SIGBUS for addresses that are unaligned AND invalid") from Linus'
tree and commit 25c5acbdcc06 ("arch/tile: support building big-endian
kernel") from the tile tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/tile/kernel/single_step.c
index 9efbc13,8935deb..0000000
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@@ -153,28 -153,6 +153,25 @@@ static tile_bundle_bits rewrite_load_st
  	if (((unsigned long)addr % size) =3D=3D 0)
  		return bundle;
 =20
 +	/*
 +	 * Return SIGBUS with the unaligned address, if requested.
 +	 * Note that we return SIGBUS even for completely invalid addresses
 +	 * as long as they are in fact unaligned; this matches what the
 +	 * tilepro hardware would be doing, if it could provide us with the
 +	 * actual bad address in an SPR, which it doesn't.
 +	 */
 +	if (unaligned_fixup =3D=3D 0) {
 +		siginfo_t info =3D {
 +			.si_signo =3D SIGBUS,
 +			.si_code =3D BUS_ADRALN,
 +			.si_addr =3D addr
 +		};
 +		trace_unhandled_signal("unaligned trap", regs,
 +				       (unsigned long)addr, SIGBUS);
 +		force_sig_info(info.si_signo, &info, current);
 +		return (tilepro_bundle_bits) 0;
 +	}
 +
- #ifndef __LITTLE_ENDIAN
- # error We assume little-endian representation with copy_xx_user size 2 h=
ere
- #endif
  	/* Handle unaligned load/store */
  	if (mem_op =3D=3D MEMOP_LOAD || mem_op =3D=3D MEMOP_LOAD_POSTINCR) {
  		unsigned short val_16;

--Signature=_Tue__10_Apr_2012_10_34_52_+1000_ke9l4GIul9VKMv=p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg4AsAAoJEECxmPOUX5FEIAYP/RxYnp8J59OXoFpxQlaVgOvi
+s4IIvCRzbNZsJrqzNcEMF4gFyBnvdOfn5zYen2ECP5kdXwrxOmrhlWUMywTYPA8
b/WzA1QPvu6IpuL+ojekHz2bYiFWWZJ/valggX5+wcJnUzCZZi8Ijb9bHPSDJmjV
R2xUdSC/YPCTo0YU58qn+rog92qMNokhrBHeViSYLyQZmnFNic0jVJePNw7mZj4/
qUk5+gdAULxhIp7Z/JUJt4uTgOIYS49bQFeJxWNN6zZVd/wbR8/ObMr4SHsbKlW6
N/6g/rJbKV3vXz3vzNfRV4Uj7Ejta2Y5QyCxT1EwecKmCnutFsl28nMJWY4i6pwh
lcJpnjvpK/SqEKopvjP15sVEeT3p82UXSSv1fdqhBaD5HIe9wpmJN8qKb6YtVGGD
20WCIHv6ItRJU6K/iDm88NCuCyz0Kr6jZehLZkzX+6SIETfLH90uKEhH7N3RaHKn
97tTL+VevHRaFmiYnAv3vkTWs+9Gy3AmmOsYw6Ux7F/OycIJ47B7x3TY/p0SgyBA
GyjAHqqV764Sj99azHtSABKj2UdFKC8Mvapv2HXDVilQM9WWLfkNCiIVp3RBS8v6
QjViR7Gji0ZCaEgVjpVgdgefo9KtPZgYQDBX48oxFuatjCsDOp57825G+ZaKm/RB
pNhH1QXmM+I3l8Ab45st
=RkSf
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_10_34_52_+1000_ke9l4GIul9VKMv=p--
