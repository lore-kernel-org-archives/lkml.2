Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab2FABKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:10:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2FABKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:10:19 -0400
Message-ID: <4FC81678.5040106@gmail.com>
Date: Fri, 01 Jun 2012 03:10:16 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4] Add UTF-16 convenience functions
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigB177611B00DFA770A73EE1E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB177611B00DFA770A73EE1E8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This is used for UDF and some other FS non-BMP support.
This series requires my previously sent
[PATCH 1/8] Support full unicode in uni2char and char2uni
Can resend if needed.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/nls/nls_base.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
 fs/nls/nls_utf8.c   |    2 +-
 include/linux/nls.h |    6 +++++
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 4f6d1ae..0c1ad5b 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -171,6 +171,32 @@ int utf8s_to_utf16s(const u8 *s, int inlen, enum utf=
16_endian endian,
 }
 EXPORT_SYMBOL(utf8s_to_utf16s);
=20
+int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
+		      wchar_t *pwcs, int maxout)
+{
+	u16 *op =3D pwcs;
+
+	op =3D pwcs;
+
+	if (u >=3D PLANE_SIZE) {
+		if (maxout < 2)
+			return -1;
+		u -=3D PLANE_SIZE;
+		put_utf16(op++, SURROGATE_PAIR |
+			  ((u >> 10) & SURROGATE_BITS),
+			  endian);
+		put_utf16(op++, SURROGATE_PAIR |
+			  SURROGATE_LOW |
+			  (u & SURROGATE_BITS),
+			  endian);
+		return 2;
+	} else {
+		put_utf16(op++, u, endian);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(unicode_to_utf16s);
+
 static inline unsigned long get_utf16(unsigned c, enum utf16_endian endi=
an)
 {
 	switch (endian) {
@@ -232,6 +258,43 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, =
enum utf16_endian endian,
 }
 EXPORT_SYMBOL(utf16s_to_utf8s);
=20
+int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian =
endian,
+		      unicode_t *uni)
+{
+	unsigned long u, v;
+	const wchar_t *pwcs0 =3D pwcs;
+
+	while (inlen > 0) {
+		u =3D get_utf16(*pwcs, endian);
+		if (!u)
+			break;
+		pwcs++;
+		inlen--;
+		if ((u & SURROGATE_MASK) =3D=3D SURROGATE_PAIR) {
+			if (u & SURROGATE_LOW) {
+				/* Ignore character and move on */
+				continue;
+			}
+			if (inlen <=3D 0)
+				break;
+			v =3D get_utf16(*pwcs, endian);
+			if ((v & SURROGATE_MASK) !=3D SURROGATE_PAIR ||
+			    !(v & SURROGATE_LOW)) {
+				/* Ignore character and move on */
+				continue;
+			}
+			u =3D PLANE_SIZE + ((u & SURROGATE_BITS) << 10)
+				+ (v & SURROGATE_BITS);
+			pwcs++;
+			inlen--;
+		}
+		*uni =3D u;
+		return pwcs - pwcs0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(utf16s_to_unicode);
+
 int register_nls(struct nls_table * nls)
 {
 	struct nls_table ** tmp =3D &tables;
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index eb6392e..a3b3de0 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -37,7 +37,7 @@ static int char2uni(const unsigned char *rawstring, int=
 boundlen,
 		*uni =3D 0x003f;	/* ? */
 		return -EINVAL;
 	}
-	*uni =3D (wchar_t) u;
+	*uni =3D u;
 	return n;
 }
=20
diff --git a/include/linux/nls.h b/include/linux/nls.h
index c0292dd..7de1765 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -50,12 +50,18 @@ extern struct nls_table *load_nls(char *);
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
=20
+#define MAX_UTF16_PER_UNICODE 2
+
 extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
 extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
 extern int utf8s_to_utf16s(const u8 *s, int len,
 		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
+int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
+		      wchar_t *pwcs, int maxout);
+int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian =
endian,
+		      unicode_t *uni);
=20
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned ch=
ar c)
 {
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigB177611B00DFA770A73EE1E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/IFngACgkQNak7dOguQgk4BwEAudEudGG8xsqcznW7m8/W2hVI
QFYfkYY7cJqnV2riu3UA/16yXnuwg7moYrBy0niw9iNUn0kGynzOlNdOVFzKmNY7
=Vu1w
-----END PGP SIGNATURE-----

--------------enigB177611B00DFA770A73EE1E8--
