Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab2FABK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:10:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41259 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab2FABKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:10:23 -0400
Message-ID: <4FC8167C.5040508@gmail.com>
Date: Fri, 01 Jun 2012 03:10:20 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] Add unaligned UTF-16 access
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigD50DE149B77B400966F69A42"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD50DE149B77B400966F69A42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Used for reading and writing UTF-16 on UDF and Joliet.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/nls_base.c   |   31 +++++++++++++++++++++----------
 include/linux/nls.h |    4 +++-
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 0c1ad5b..e941a80 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -16,6 +16,7 @@
 #include <linux/kmod.h>
 #include <linux/spinlock.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
=20
 static struct nls_table default_table;
 static struct nls_table *tables =3D &default_table;
@@ -114,7 +115,7 @@ int utf32_to_utf8(unicode_t u, u8 *s, int maxout)
 }
 EXPORT_SYMBOL(utf32_to_utf8);
=20
-static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian e=
ndian)
+static inline void put_utf16(u16 *s, unsigned c, enum utf16_endian endia=
n)
 {
 	switch (endian) {
 	default:
@@ -126,11 +127,17 @@ static inline void put_utf16(wchar_t *s, unsigned c=
, enum utf16_endian endian)
 	case UTF16_BIG_ENDIAN:
 		*s =3D __cpu_to_be16(c);
 		break;
+	case UTF16_LITTLE_ENDIAN_UNALIGNED:
+		put_unaligned_le16 (c, s);
+		break;
+	case UTF16_BIG_ENDIAN_UNALIGNED:
+		put_unaligned_be16 (c, s);
+		break;
 	}
 }
=20
 int utf8s_to_utf16s(const u8 *s, int inlen, enum utf16_endian endian,
-		wchar_t *pwcs, int maxout)
+		    wchar_t *pwcs, int maxout)
 {
 	u16 *op;
 	int size;
@@ -197,15 +204,19 @@ int unicode_to_utf16s(unicode_t u, enum utf16_endia=
n endian,
 }
 EXPORT_SYMBOL(unicode_to_utf16s);
=20
-static inline unsigned long get_utf16(unsigned c, enum utf16_endian endi=
an)
+static inline unsigned long get_utf16(const u16 *c, enum utf16_endian en=
dian)
 {
 	switch (endian) {
 	default:
-		return c;
+		return *c;
 	case UTF16_LITTLE_ENDIAN:
-		return __le16_to_cpu(c);
+		return __le16_to_cpu(*c);
 	case UTF16_BIG_ENDIAN:
-		return __be16_to_cpu(c);
+		return __be16_to_cpu(*c);
+	case UTF16_LITTLE_ENDIAN_UNALIGNED:
+		return get_unaligned_le16 (c);
+	case UTF16_BIG_ENDIAN_UNALIGNED:
+		return get_unaligned_be16 (c);
 	}
 }
=20
@@ -218,7 +229,7 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, e=
num utf16_endian endian,
=20
 	op =3D s;
 	while (inlen > 0 && maxout > 0) {
-		u =3D get_utf16(*pwcs, endian);
+		u =3D get_utf16(pwcs, endian);
 		if (!u)
 			break;
 		pwcs++;
@@ -231,7 +242,7 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, e=
num utf16_endian endian,
 				}
 				if (inlen <=3D 0)
 					break;
-				v =3D get_utf16(*pwcs, endian);
+				v =3D get_utf16(pwcs, endian);
 				if ((v & SURROGATE_MASK) !=3D SURROGATE_PAIR ||
 						!(v & SURROGATE_LOW)) {
 					/* Ignore character and move on */
@@ -265,7 +276,7 @@ int utf16s_to_unicode(const wchar_t *pwcs, int inlen,=
 enum utf16_endian endian,
 	const wchar_t *pwcs0 =3D pwcs;
=20
 	while (inlen > 0) {
-		u =3D get_utf16(*pwcs, endian);
+		u =3D get_utf16(pwcs, endian);
 		if (!u)
 			break;
 		pwcs++;
@@ -277,7 +288,7 @@ int utf16s_to_unicode(const wchar_t *pwcs, int inlen,=
 enum utf16_endian endian,
 			}
 			if (inlen <=3D 0)
 				break;
-			v =3D get_utf16(*pwcs, endian);
+			v =3D get_utf16(pwcs, endian);
 			if ((v & SURROGATE_MASK) !=3D SURROGATE_PAIR ||
 			    !(v & SURROGATE_LOW)) {
 				/* Ignore character and move on */
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 7de1765..bb35d2b 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -40,7 +40,9 @@ struct nls_table {
 enum utf16_endian {
 	UTF16_HOST_ENDIAN,
 	UTF16_LITTLE_ENDIAN,
-	UTF16_BIG_ENDIAN
+	UTF16_BIG_ENDIAN,
+	UTF16_LITTLE_ENDIAN_UNALIGNED,
+	UTF16_BIG_ENDIAN_UNALIGNED
 };
=20
 /* nls_base.c */
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigD50DE149B77B400966F69A42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/IFnwACgkQNak7dOguQgnQPAEAqIuuzxPBYKjunuMnEMIUhodZ
C67Mple0sZeu3FlahrAA/2qfwqbq0qipz0Xzv3wJmwg3rD9YgR5rE/1xD9ZsGsD+
=I7JS
-----END PGP SIGNATURE-----

--------------enigD50DE149B77B400966F69A42--
