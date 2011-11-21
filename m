Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1KUPPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:15:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47465 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752151Ab1KUPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:15:14 -0500
Date: Mon, 21 Nov 2011 10:15:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, NamJae Jeon <linkinjeon@gmail.com>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Clemens Ladisch <clemens@ladisch.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] NLS: raname "maxlen" to "maxout" in UTF conversion routines
In-Reply-To: <CAKYAXd-sZrF0DD=cuRVAX3Uoivi6fYhpM5P=awaUUU=oQ8ZVow@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111211012550.1848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by NamJae Jeon, this patch (as1503) changes the name of
the "maxlen" parameters to "maxout" in the various UTF conversion
routines.  This should make the role of that parameter more clear.

The patch also renames the "len" parameters to "inlen", for the same
reason.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

NamJae, I hope you like this better.  Since Greg has already accepted 
the first patch, I decided it was easier to write a new patch to change 
the variable names.


 fs/nls/nls_base.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

Index: usb-3.2/fs/nls/nls_base.c
===================================================================
--- usb-3.2.orig/fs/nls/nls_base.c
+++ usb-3.2/fs/nls/nls_base.c
@@ -52,7 +52,7 @@ static const struct utf8_table utf8_tabl
 #define SURROGATE_LOW	0x00000400
 #define SURROGATE_BITS	0x000003ff
 
-int utf8_to_utf32(const u8 *s, int len, unicode_t *pu)
+int utf8_to_utf32(const u8 *s, int inlen, unicode_t *pu)
 {
 	unsigned long l;
 	int c0, c, nc;
@@ -71,7 +71,7 @@ int utf8_to_utf32(const u8 *s, int len, 
 			*pu = (unicode_t) l;
 			return nc;
 		}
-		if (len <= nc)
+		if (inlen <= nc)
 			return -1;
 		s++;
 		c = (*s ^ 0x80) & 0xFF;
@@ -83,7 +83,7 @@ int utf8_to_utf32(const u8 *s, int len, 
 }
 EXPORT_SYMBOL(utf8_to_utf32);
 
-int utf32_to_utf8(unicode_t u, u8 *s, int maxlen)
+int utf32_to_utf8(unicode_t u, u8 *s, int maxout)
 {
 	unsigned long l;
 	int c, nc;
@@ -97,7 +97,7 @@ int utf32_to_utf8(unicode_t u, u8 *s, in
 		return -1;
 
 	nc = 0;
-	for (t = utf8_table; t->cmask && maxlen; t++, maxlen--) {
+	for (t = utf8_table; t->cmask && maxout; t++, maxout--) {
 		nc++;
 		if (l <= t->lmask) {
 			c = t->shift;
@@ -129,24 +129,24 @@ static inline void put_utf16(wchar_t *s,
 	}
 }
 
-int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
-		wchar_t *pwcs, int maxlen)
+int utf8s_to_utf16s(const u8 *s, int inlen, enum utf16_endian endian,
+		wchar_t *pwcs, int maxout)
 {
 	u16 *op;
 	int size;
 	unicode_t u;
 
 	op = pwcs;
-	while (len > 0 && maxlen > 0 && *s) {
+	while (inlen > 0 && maxout > 0 && *s) {
 		if (*s & 0x80) {
-			size = utf8_to_utf32(s, len, &u);
+			size = utf8_to_utf32(s, inlen, &u);
 			if (size < 0)
 				return -EINVAL;
 			s += size;
-			len -= size;
+			inlen -= size;
 
 			if (u >= PLANE_SIZE) {
-				if (maxlen < 2)
+				if (maxout < 2)
 					break;
 				u -= PLANE_SIZE;
 				put_utf16(op++, SURROGATE_PAIR |
@@ -156,15 +156,15 @@ int utf8s_to_utf16s(const u8 *s, int len
 						SURROGATE_LOW |
 						(u & SURROGATE_BITS),
 						endian);
-				maxlen -= 2;
+				maxout -= 2;
 			} else {
 				put_utf16(op++, u, endian);
-				maxlen--;
+				maxout--;
 			}
 		} else {
 			put_utf16(op++, *s++, endian);
-			len--;
-			maxlen--;
+			inlen--;
+			maxout--;
 		}
 	}
 	return op - pwcs;
@@ -183,27 +183,27 @@ static inline unsigned long get_utf16(un
 	}
 }
 
-int utf16s_to_utf8s(const wchar_t *pwcs, int len, enum utf16_endian endian,
-		u8 *s, int maxlen)
+int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
+		u8 *s, int maxout)
 {
 	u8 *op;
 	int size;
 	unsigned long u, v;
 
 	op = s;
-	while (len > 0 && maxlen > 0) {
+	while (inlen > 0 && maxout > 0) {
 		u = get_utf16(*pwcs, endian);
 		if (!u)
 			break;
 		pwcs++;
-		len--;
+		inlen--;
 		if (u > 0x7f) {
 			if ((u & SURROGATE_MASK) == SURROGATE_PAIR) {
 				if (u & SURROGATE_LOW) {
 					/* Ignore character and move on */
 					continue;
 				}
-				if (len <= 0)
+				if (inlen <= 0)
 					break;
 				v = get_utf16(*pwcs, endian);
 				if ((v & SURROGATE_MASK) != SURROGATE_PAIR ||
@@ -214,18 +214,18 @@ int utf16s_to_utf8s(const wchar_t *pwcs,
 				u = PLANE_SIZE + ((u & SURROGATE_BITS) << 10)
 						+ (v & SURROGATE_BITS);
 				pwcs++;
-				len--;
+				inlen--;
 			}
-			size = utf32_to_utf8(u, op, maxlen);
+			size = utf32_to_utf8(u, op, maxout);
 			if (size == -1) {
 				/* Ignore character and move on */
 			} else {
 				op += size;
-				maxlen -= size;
+				maxout -= size;
 			}
 		} else {
 			*op++ = (u8) u;
-			maxlen--;
+			maxout--;
 		}
 	}
 	return op - s;

