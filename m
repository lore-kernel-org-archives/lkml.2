Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967025Ab2EOXKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:10:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42424 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966182Ab2EOXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:10:30 -0400
Message-ID: <4FB2E25E.900@gmail.com>
Date: Wed, 16 May 2012 01:10:22 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/8] Support non-BMP characters in UDF
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig574E486D3C37546F58BF5A05"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig574E486D3C37546F58BF5A05
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I also have a counterpart for mkudffs/udf-tools but sourceforge homepage =
seems to be abandoned does anybody know if there is a new homepage for mk=
udffs?

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/udf/unicode.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 9b1b2de..2d8cc12 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -280,6 +280,14 @@ static int udf_CS0toNLS(struct nls_table *nls, struc=
t ustr *utf_o,
 		if (cmp_id =3D=3D 16)
 			c =3D (c << 8) | ocu[i++];
=20
+		if (cmp_id =3D=3D 16 && (c & 0xfc00) =3D=3D 0xd800
+		    && i + 1 < ocu_len && ((ocu[i] & 0xfc) =3D=3D 0xdc)) {
+			uint16_t l;
+			l =3D ocu[i++] << 8;
+			l |=3D ocu[i++];
+			c =3D (((c & 0x3ff) << 10) | (l & 0x3ff)) + 0x10000;
+		}
+
 		len =3D nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
 				    UDF_NAME_LEN - utf_o->u_len);
 		/* Valid character? */
@@ -312,20 +320,30 @@ try_again:
 		if (!len)
 			continue;
 		/* Invalid character, deal with it */
-		if (len < 0 || uni_char > 0xffff) {
+		if (len < 0 || uni_char > 0x10ffff) {
 			len =3D 1;
 			uni_char =3D '?';
 		}
=20
 		if (uni_char > max_val) {
-			max_val =3D 0xffffU;
+			max_val =3D 0x10ffffU;
 			ocu[0] =3D (uint8_t)0x10U;
 			goto try_again;
 		}
=20
-		if (max_val =3D=3D 0xffffU)
-			ocu[++u_len] =3D (uint8_t)(uni_char >> 8);
-		ocu[++u_len] =3D (uint8_t)(uni_char & 0xffU);
+		if (uni_char > 0xffff) {
+			u16 h, l;
+			h =3D 0xd800 | (((uni_char - 0x10000) >> 10) & 0x3ff);
+			l =3D 0xdc00 | ((uni_char - 0x10000) & 0x3ff);
+			ocu[++u_len] =3D (uint8_t)(h >> 8);
+			ocu[++u_len] =3D (uint8_t)(h & 0xffU);
+			ocu[++u_len] =3D (uint8_t)(l >> 8);
+			ocu[++u_len] =3D (uint8_t)(l & 0xffU);
+		} else {
+			if (max_val =3D=3D 0x10ffffU)
+				ocu[++u_len] =3D (uint8_t)(uni_char >> 8);
+			ocu[++u_len] =3D (uint8_t)(uni_char & 0xffU);
+		}
 		i +=3D len - 1;
 	}
=20
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig574E486D3C37546F58BF5A05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4l4ACgkQNak7dOguQgm2zgD/Xpgbw+nL7gCyFpeTfwa+6ElT
CF5aiwYkQBssJjLewMYA+wSOktcHuHkQsEiZLn0Th1huCbZ+zfjpqV1xuR+flm38
=jglW
-----END PGP SIGNATURE-----

--------------enig574E486D3C37546F58BF5A05--
