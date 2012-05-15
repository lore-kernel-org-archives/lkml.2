Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966975Ab2EOXHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:07:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39361 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966054Ab2EOXHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:07:08 -0400
Message-ID: <4FB2E192.3080004@gmail.com>
Date: Wed, 16 May 2012 01:06:58 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@tuxera.com>,
        Anton Salikhmetov <alexo@tuxera.com>
Subject: [PATCH 4/8] Support non-BMP characters on HFS+.
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigAA9F57C280501F9E29224BED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA9F57C280501F9E29224BED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This one is little bit tricky since HFS+ transforms UTF-16 but since it w=
as designed without any attention to non-BMP characters, they are not dec=
omposed or case-folded.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/hfsplus/unicode.c |   76 ++++++++++++++++++++++++++++++++++++++++----=
------
 1 file changed, 62 insertions(+), 14 deletions(-)

diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index 5b2c8de..161a23b 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -97,6 +97,11 @@ int hfsplus_strcmp(const struct hfsplus_unistr *s1,
 #define Hangul_TCount	28
 #define Hangul_NCount	(Hangul_VCount * Hangul_TCount)
=20
+#define SURROGATE_MASK	0xfffff800
+#define SURROGATE_PAIR	0x0000d800
+#define SURROGATE_LOW	0x00000400
+#define SURROGATE_BITS	0x000003ff
+
=20
 static u16 *hfsplus_compose_lookup(u16 *p, u16 cc)
 {
@@ -189,6 +194,9 @@ int hfsplus_uni2asc(struct super_block *sb,
 				c0 =3D ':';
 				break;
 			}
+
+			if ((c0 & SURROGATE_MASK) =3D=3D SURROGATE_PAIR)
+				goto same;
 			res =3D nls->uni2char(c0, op, len);
 			if (res < 0) {
 				if (res =3D=3D -ENAMETOOLONG)
@@ -232,7 +240,19 @@ same:
 			cc =3D c0;
 		}
 done:
-		res =3D nls->uni2char(cc, op, len);
+		if ((cc & SURROGATE_MASK) =3D=3D SURROGATE_PAIR
+		    && !(cc & SURROGATE_LOW)
+		    && ustrlen
+		    && (be16_to_cpu(*ip) & SURROGATE_MASK) =3D=3D SURROGATE_PAIR
+		    && (be16_to_cpu(*ip) & SURROGATE_LOW)) {
+			unicode_t complete;
+			complete =3D (c0 & SURROGATE_BITS) << 10;
+			complete |=3D (be16_to_cpu(*ip++) & SURROGATE_BITS);
+			complete +=3D 0x10000;
+			ustrlen--;
+			res =3D nls->uni2char(complete, op, len);
+		} else
+			res =3D nls->uni2char(cc, op, len);
 		if (res < 0) {
 			if (res =3D=3D -ENAMETOOLONG)
 				goto out;
@@ -256,7 +276,7 @@ static inline int asc2unichar(struct super_block *sb,=
 const char *astr, int len,
 			      unicode_t *uc)
 {
 	int size =3D HFSPLUS_SB(sb)->nls->char2uni(astr, len, uc);
-	if (size <=3D 0 || *uc > 0xffff) {
+	if (size <=3D 0) {
 		*uc =3D '?';
 		size =3D 1;
 	}
@@ -272,10 +292,13 @@ static inline int asc2unichar(struct super_block *s=
b, const char *astr, int len,
 }
=20
 /* Decomposes a single unicode character. */
-static inline u16 *decompose_unichar(wchar_t uc, int *size)
+static inline u16 *decompose_unichar(unicode_t uc, int *size)
 {
 	int off;
=20
+	if (uc >=3D 0x10000)
+		return NULL;
+
 	off =3D hfsplus_decompose_table[(uc >> 12) & 0xf];
 	if (off =3D=3D 0 || off =3D=3D 0xffff)
 		return NULL;
@@ -316,8 +339,16 @@ int hfsplus_asc2uni(struct super_block *sb, struct h=
fsplus_unistr *ustr,
 			do {
 				ustr->unicode[outlen++] =3D cpu_to_be16(*dstr++);
 			} while (--dsize > 0);
-		} else
-			ustr->unicode[outlen++] =3D cpu_to_be16(c);
+		} else {
+			int s;
+			s =3D unicode_to_utf16s(c, UTF16_BIG_ENDIAN,
+					      ustr->unicode + outlen,
+					      HFSPLUS_MAX_STRLEN - outlen);
+			if (s <=3D 0)
+				break;
+
+			outlen +=3D s;
+		}
=20
 		astr +=3D size;
 		len -=3D size;
@@ -342,7 +373,7 @@ int hfsplus_hash_dentry(const struct dentry *dentry, =
const struct inode *inode,
 	int casefold, decompose, size, len;
 	unsigned long hash;
 	unicode_t c;
-	u16 c2;
+	unicode_t c2;
=20
 	casefold =3D test_bit(HFSPLUS_SB_CASEFOLD, &HFSPLUS_SB(sb)->flags);
 	decompose =3D !test_bit(HFSPLUS_SB_NODECOMPOSE, &HFSPLUS_SB(sb)->flags)=
;
@@ -369,9 +400,17 @@ int hfsplus_hash_dentry(const struct dentry *dentry,=
 const struct inode *inode,
 			} while (--dsize > 0);
 		} else {
 			c2 =3D c;
-			if (casefold)
+			if (casefold && c2 < 0x10000)
 				c2 =3D case_fold(c2);
-			if (!casefold || c2)
+			if (c2 >=3D 0x10000) {
+				int i, s;
+				u16 tmp[2];
+				s =3D unicode_to_utf16s(c2,
+						      UTF16_HOST_ENDIAN,
+						      tmp, 2);
+				for (i =3D 0; i < s; i++)
+					hash =3D partial_name_hash(tmp[i], hash);
+			} else if (!casefold || c2)
 				hash =3D partial_name_hash(c2, hash);
 		}
 	}
@@ -395,6 +434,7 @@ int hfsplus_compare_dentry(const struct dentry *paren=
t,
 	int dsize1, dsize2, len1, len2;
 	const u16 *dstr1, *dstr2;
 	const char *astr1, *astr2;
+	u16 buf1[2], buf2[2];
 	u16 c1, c2;
 	unicode_t c;
=20
@@ -416,9 +456,13 @@ int hfsplus_compare_dentry(const struct dentry *pare=
nt,
 			if (decompose)
 				dstr1 =3D decompose_unichar(c, &dsize1);
 			if (!decompose || !dstr1) {
-				c1 =3D c;
-				dstr1 =3D &c1;
-				dsize1 =3D 1;
+				int s;
+				s =3D unicode_to_utf16s(c, UTF16_HOST_ENDIAN,
+						      buf1, 2);
+				if (s <=3D 0)
+					s =3D 0;
+				dstr1 =3D buf1;
+				dsize1 =3D s;
 			}
 		}
=20
@@ -430,9 +474,13 @@ int hfsplus_compare_dentry(const struct dentry *pare=
nt,
 			if (decompose)
 				dstr2 =3D decompose_unichar(c, &dsize2);
 			if (!decompose || !dstr2) {
-				c2 =3D c;
-				dstr2 =3D &c2;
-				dsize2 =3D 1;
+				int s;
+				s =3D unicode_to_utf16s(c, UTF16_HOST_ENDIAN,
+						      buf2, 2);
+				if (s <=3D 0)
+					s =3D 0;
+				dstr2 =3D buf2;
+				dsize2 =3D s;
 			}
 		}
=20
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigAA9F57C280501F9E29224BED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4ZIACgkQNak7dOguQgkd2wEAha010x4q2go8nRPyg38CJIQj
pYaMauVgrDfMLilI5KEBAIdVs1eswCOUdimF31de7gYCtmHIX7pngFapod72YoPL
=NDTf
-----END PGP SIGNATURE-----

--------------enigAA9F57C280501F9E29224BED--
