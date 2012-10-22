Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2JVBgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:36:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35700 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab2JVBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:36:03 -0400
Date: Mon, 22 Oct 2012 12:35:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the modules tree with the  tree
Message-Id: <20121022123553.240d9ddf05cd5e2c8fee0ab3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Oct_2012_12_35_53_+1100_cwZ1CIE6qF.Uj_/K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Oct_2012_12_35_53_+1100_cwZ1CIE6qF.Uj_/K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the modules tree got a conflict in
kernel/module.c between commit caabe240574a ("MODSIGN: Move the magic
string to the end of a module and eliminate the search") from Linus' tree
and commit 0250abdeec54 ("module: add syscall to load module from fd")
from the modules tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

I do wonder why the above change in Linus' tree seems to have bypassed
the modules maintainer.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/module.c
index 6085f5e,261bf82..0000000
--- a/kernel/module.c
+++ b/kernel/module.c
@@@ -2420,18 -2422,27 +2422,18 @@@ static inline void kmemleak_load_module
  #endif
 =20
  #ifdef CONFIG_MODULE_SIG
- static int module_sig_check(struct load_info *info,
- 			    const void *mod, unsigned long *_len)
+ static int module_sig_check(struct load_info *info)
  {
  	int err =3D -ENOKEY;
- 	unsigned long markerlen =3D sizeof(MODULE_SIG_STRING) - 1;
- 	unsigned long len =3D *_len;
+ 	const unsigned long markerlen =3D sizeof(MODULE_SIG_STRING) - 1;
+ 	const void *mod =3D info->hdr;
 -	const void *p =3D mod, *end =3D mod + info->len;
++	unsigned long len =3D info->len;
 =20
 -	/* Poor man's memmem. */
 -	while ((p =3D memchr(p, MODULE_SIG_STRING[0], end - p))) {
 -		if (p + markerlen > end)
 -			break;
 -
 -		if (memcmp(p, MODULE_SIG_STRING, markerlen) =3D=3D 0) {
 -			const void *sig =3D p + markerlen;
 -			/* Truncate module up to signature. */
 -			info->len =3D p - mod;
 -			err =3D mod_verify_sig(mod, info->len,
 -					     sig, end - sig);
 -			break;
 -		}
 -		p++;
 +	if (len > markerlen &&
 +	    memcmp(mod + len - markerlen, MODULE_SIG_STRING, markerlen) =3D=3D 0=
) {
 +		/* We truncate the module to discard the signature */
- 		*_len -=3D markerlen;
- 		err =3D mod_verify_sig(mod, _len);
++		info->len -=3D markerlen;
++		err =3D mod_verify_sig(mod, &info->len);
  	}
 =20
  	if (!err) {

--Signature=_Mon__22_Oct_2012_12_35_53_+1100_cwZ1CIE6qF.Uj_/K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhKL5AAoJEECxmPOUX5FE9kQQAJO5JbV85NMC4R4AwDHtvtZA
g8p2Rx3KUILtK5CRy64hJx4I5vQTcnGinUceIXxFCEwQyJgjM5G72Ulf3R4xf6ai
lm1SzpEd8qcSpZdXltEAR7YeymDwGUsudpKkMr+pSk4TRyZsJ2kIlbDf8DhxYpxW
gD/Qm6T36yi0atYRbhKqWDQwtbhhKgAy1QSvoe6QHI0nhxR8aVX5yR3rDngWeZoz
G55LhGY6hTx54QLxlIoTBZUUwX2wAvLCddIeWfDM9j+xkqV/7uRFczPsVoxAjnj3
+auJiSszo/yEExBS/7tZZluag7w+h9D+Cp3PYJoIECuTsS2/UlOSXBvpJgyQCDRa
2Lj6dUR38JD7HOMRoJ4U5EZpQE6oSppO1ER0lRHoK50DDOl6NYjYwmuKXs0F4O6K
8u4pW68e4DkPet4JVVRVvzDPxd9resps/QesToxpX810vudjRF/qdYAPcx1ylaJt
VyrYT85q3NEuKxciyy7O7cq7dbbDdLB0l94e3uIH1Me7/l/LduMF8TTB7OHqNdO4
hzl6q1L/OSHRCUKc1Lm9jl+d3xvMdsr8cN5091Udj5+ezRBz+xa2v0W8y4SR6jT/
c6RND+AW9XpKQLaKQDaejjr+cQO32ZbEvZbKHcv2cLsyrmhccalNsQiEP/0TB8Dl
ONtXVNK9HxDKUJ0B3k/r
=16aX
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Oct_2012_12_35_53_+1100_cwZ1CIE6qF.Uj_/K--
