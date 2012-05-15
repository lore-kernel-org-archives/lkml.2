Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966554Ab2EOXB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:01:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49030 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966441Ab2EOXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:01:54 -0400
Message-ID: <4FB2E04E.6000702@gmail.com>
Date: Wed, 16 May 2012 01:01:34 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, jfs-discussion@lists.sourceforge.net,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
CC: Steve French <sfrench@samba.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Petr Vandrovec <petr@vandrovec.name>,
        Anton Altaparmakov <anton@tuxera.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/8] Add some UTF-16 functions for convenience
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig3C529468453CE1A58EEAF38E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C529468453CE1A58EEAF38E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



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






--------------enig3C529468453CE1A58EEAF38E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4E8ACgkQNak7dOguQgkYCwEApe22ee6F2h2zx4sPLVt35b8A
CFAi4ZDOgu4R9f0M4uUA/0NT65bZwEJql0YBuYnU876X6VZDTPzo5Wbtag5Ck0u4
=cRtk
-----END PGP SIGNATURE-----

--------------enig3C529468453CE1A58EEAF38E--
