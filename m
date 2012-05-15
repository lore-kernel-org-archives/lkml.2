Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966606Ab2EOXDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:03:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53299 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966054Ab2EOXDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:03:33 -0400
Message-ID: <4FB2E0BB.8080906@gmail.com>
Date: Wed, 16 May 2012 01:03:23 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/8] Support non-BMP characters in JFS.
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig54C64D9018E1F85D1ED902AC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig54C64D9018E1F85D1ED902AC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/jfs/jfs_unicode.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/jfs_unicode.c b/fs/jfs/jfs_unicode.c
index 2d70cf1..70f667a 100644
--- a/fs/jfs/jfs_unicode.c
+++ b/fs/jfs/jfs_unicode.c
@@ -34,14 +34,23 @@ int jfs_strfromUCS_le(char *to, const __le16 * from,
 {
 	int i;
 	int outlen =3D 0;
+	int step;
 	static int warn_again =3D 5;	/* Only warn up to 5 times total */
 	int warn =3D !!warn_again;	/* once per string */
=20
 	if (codepage) {
-		for (i =3D 0; (i < len) && from[i]; i++) {
+		for (i =3D 0; (i < len) && from[i]; ) {
 			int charlen;
+			unicode_t uni;
+			step =3D utf16s_to_unicode(from + i, len - i,
+						 UTF16_LITTLE_ENDIAN,
+						 &uni);
+			if (!step)
+				break;
+			i +=3D step;
+
 			charlen =3D
-			    codepage->uni2char(le16_to_cpu(from[i]),
+			    codepage->uni2char(uni,
 					       &to[outlen],
 					       NLS_MAX_CHARSET_SIZE);
 			if (charlen > 0)
@@ -86,18 +95,26 @@ static int jfs_strtoUCS(wchar_t * to, const unsigned =
char *from, int len,
 	int i;
=20
 	if (codepage) {
-		for (i =3D 0; len && *from; i++, from +=3D charlen, len -=3D charlen)
+		for (i =3D 0; len && *from; from +=3D charlen, len -=3D charlen)
 		{
 			unicode_t uni;
+			int step;
 			charlen =3D codepage->char2uni(from, len, &uni);
-			to[i] =3D uni;
-			if (charlen < 1 || uni > 0xffff) {
+			if (charlen < 1) {
 				jfs_err("jfs_strtoUCS: char2uni returned %d.",
 					charlen);
 				jfs_err("charset =3D %s, char =3D 0x%x",
 					codepage->charset, *from);
 				return charlen;
 			}
+			step =3D unicode_to_utf16s(uni, UTF16_HOST_ENDIAN,
+					       to + i, MAX_UTF16_PER_UNICODE);
+			if (step < 0) {
+				jfs_err("jfs_strtoUCS: unicode_to_utf16s returned %d.",
+					step);
+				return step;
+			}
+			i +=3D step;
 		}
 	} else {
 		for (i =3D 0; (i < len) && from[i]; i++)
@@ -123,7 +140,8 @@ int get_UCSname(struct component_name * uniName, stru=
ct dentry *dentry)
 		return -ENAMETOOLONG;
=20
 	uniName->name =3D
-	    kmalloc((length + 1) * sizeof(wchar_t), GFP_NOFS);
+	    kmalloc((length * MAX_UTF16_PER_UNICODE + 1) * sizeof(wchar_t),
+		    GFP_NOFS);
=20
 	if (uniName->name =3D=3D NULL)
 		return -ENOMEM;
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig54C64D9018E1F85D1ED902AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4LsACgkQNak7dOguQgmSfwEAreUUGN341JngZzIvcskaVHF4
//VaHbjBsHJnCcF1++4A/jtVzDKM7QtBgZGqR1ZxDNOn3UhgGHSwo/Q/QPtYOSdw
=c4RP
-----END PGP SIGNATURE-----

--------------enig54C64D9018E1F85D1ED902AC--
