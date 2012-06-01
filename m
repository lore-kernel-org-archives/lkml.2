Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab2FABKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:10:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39891 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2FABKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:10:15 -0400
Message-ID: <4FC81673.7060405@gmail.com>
Date: Fri, 01 Jun 2012 03:10:11 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/4] Support non-BMP characters on UDF
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig2FD3A52774A99AF652EBB691"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FD3A52774A99AF652EBB691
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Replace UCS-2 with proper UTF-16.
Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/udf/unicode.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 7df644d..0d1c93c 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -106,9 +106,20 @@ int udf_CS0toNLS(struct nls_table *nls, struct ustr =
*utf_o,
 	utf_o->u_len =3D 0;
 	for (i =3D 0; (i < ocu_len) && (utf_o->u_len <=3D (UDF_NAME_LEN - 3));)=
 {
 		/* Expand OSTA compressed Unicode to Unicode */
-		uint32_t c =3D ocu[i++];
-		if (cmp_id =3D=3D 16)
-			c =3D (c << 8) | ocu[i++];
+		unicode_t c;
+		if (cmp_id =3D=3D 8)
+			c =3D ocu[i++];
+		else {
+			int s =3D utf16s_to_unicode((u16 *) (ocu + i),
+						  (ocu_len - i) / 2,
+						  UTF16_BIG_ENDIAN_UNALIGNED,
+						  &c);
+			if (s <=3D 0) {
+				c =3D (ocu[i] << 8) | ocu[i+1];
+				s =3D 1;
+			}
+			i +=3D 2 * s;
+		}
=20
 		len =3D nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
 				    UDF_NAME_LEN - utf_o->u_len);
@@ -142,20 +153,28 @@ try_again:
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
+		if (max_val =3D=3D 0x10ffffU) {
+			int s;
+			s =3D unicode_to_utf16s(uni_char,
+					      UTF16_BIG_ENDIAN_UNALIGNED,
+					      (u16 *) (ocu + u_len + 1),
+					      (length - (u_len + 1)) / 2);
+			if (s <=3D 0)
+				break;
+			u_len +=3D 2 * s;
+		} else
+			ocu[++u_len] =3D (uint8_t)(uni_char & 0xffU);
 		i +=3D len - 1;
 	}
=20
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig2FD3A52774A99AF652EBB691
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/IFnMACgkQNak7dOguQgm4UAD+OSUAYnRD7cYqljOxmnbAVUC0
7x974wU8/jpTbCNzNPMA/AhJ/fELKgba0U4oRB+0/nDv7gxc4+OlMb5RGcywUtpp
=h1kg
-----END PGP SIGNATURE-----

--------------enig2FD3A52774A99AF652EBB691--
