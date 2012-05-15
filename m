Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967048Ab2EOXOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:14:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57774 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966680Ab2EOXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:14:28 -0400
Message-ID: <4FB2E351.9070005@gmail.com>
Date: Wed, 16 May 2012 01:14:25 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Support non-BMP characters on FAT
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig5D9AE4514B3A694F2A8B0E1A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D9AE4514B3A694F2A8B0E1A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/fat/dir.c        |   18 ++++++++++++++++--
 fs/fat/namei_vfat.c |   23 ++++++++++++++++++++---
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 9bb16f3..d14ac9e 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -149,10 +149,24 @@ static int uni16_to_x8(struct super_block *sb, unsi=
gned char *ascii,
 	op =3D ascii;
=20
 	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
-		ec =3D *ip++;
-		if ((charlen =3D nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
+		unicode_t uni;
+		int is_sur =3D 0;
+
+		uni =3D ec =3D *ip++;
+
+		if ((ec & 0xfc00) =3D=3D 0xd800
+		    || (*ip & 0xfc00) =3D=3D 0xdc00) {
+			is_sur =3D 1;
+			uni =3D ((ec & 0x3ff) << 10) | (*ip & 0x3ff);
+			uni +=3D 0x10000;
+		}
+
+		charlen =3D nls->uni2char(uni, op, NLS_MAX_CHARSET_SIZE);
+		if (charlen > 0) {
 			op +=3D charlen;
 			len -=3D charlen;
+			if (is_sur)
+				ip++;
 		} else {
 			if (uni_xlate =3D=3D 1) {
 				*op++ =3D ':';
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6b9caa5..ad5abfd 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -552,12 +552,29 @@ xlate_to_uni(const unsigned char *name, int len, un=
signed char *outname,
 			} else {
 				unicode_t t;
 				charlen =3D nls->char2uni(ip, len - i, &t);
-				if (charlen < 0 || t > 0xffff)
+				if (charlen < 0)
 					return -EINVAL;
-				*(wchar_t *)op =3D t;
+				if (t > 0xffff) {
+					u16 h, l;
+
+					if (*outlen + 1 >=3D FAT_LFN_LEN)
+						break;
+
+					h =3D (((t - 0x10000) >> 10) & 0x3ff)
+						| 0xd800;
+					l =3D ((t - 0x10000) & 0x3ff)
+						| 0xdc00;
+					*(wchar_t *)op =3D h;
+					op +=3D 2;
+					*(wchar_t *)op =3D l;
+					op +=3D 2;
+					*outlen +=3D 1;
+				} else {
+					*(wchar_t *)op =3D t;
+					op +=3D 2;
+				}
 				ip +=3D charlen;
 				i +=3D charlen;
-				op +=3D 2;
 			}
 		}
 		if (i < len)
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig5D9AE4514B3A694F2A8B0E1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y41EACgkQNak7dOguQgnp4AD/dKcYZ5koGZbytapzl7m0MYkU
oWjHjgdd+tbpk1qCNJUBAKLkAOvrmVqeucSzJ0PQyvj1qtV18TW/nxFSlvygUR2Y
=x/J8
-----END PGP SIGNATURE-----

--------------enig5D9AE4514B3A694F2A8B0E1A--
