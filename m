Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1HKRpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:45:21 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:64425 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab1HKRpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:45:20 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=869cbtyjxWwA:10 a=YVLsNpA127UA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=iLNU1ar6AAAA:8 a=azj6Gt-4AAAA:8 a=GnrU4FOAv6Xi4jKNTWwA:9 a=8AJwdd3fgT1_ZJxjtTUA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=-XwJ49_kmwcA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E44152E.1070607@systemfabricworks.com>
Date: Thu, 11 Aug 2011 12:45:18 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, joakim.tjernlund@transmode.se,
        akpm@linux-foundation.org, linux@horizon.com,
        fzago@systemfabricworks.com
Subject: [patches v5 resending 8/8] crc32: final-cleanup.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some final cleanup changes

	- added a comment at the top of crc32.c
	- moved macros ahead of function prototype
	- replaced loops with for (i = 0; i < xxx; i++) which
	  requires fewer instructions on x86 since the
	  buffer lookups can use i as an index.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |   89 ++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was
@@ -45,45 +49,41 @@ MODULE_LICENSE("GPL");

 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8

-/* implements slicing-by-4 or slicing-by-8 algorithm */
-static inline u32
-crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
-{
 # ifdef __LITTLE_ENDIAN
 #  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
-#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
-			t2[(crc >> 8) & 255] ^ \
-			t1[(crc >> 16) & 255] ^ \
-			t0[(crc >> 24) & 255]
-#  define DO_CRC8a (t7[(q) & 255] ^ \
-			t6[(q >> 8) & 255] ^ \
-			t5[(q >> 16) & 255] ^ \
-			t4[(q >> 24) & 255])
-#  define DO_CRC8b (t3[(q) & 255] ^ \
+#  define DO_CRC4 (t3[(q) & 255] ^ \
 			t2[(q >> 8) & 255] ^ \
 			t1[(q >> 16) & 255] ^ \
 			t0[(q >> 24) & 255])
+#  define DO_CRC8 (t7[(q) & 255] ^ \
+			t6[(q >> 8) & 255] ^ \
+			t5[(q >> 16) & 255] ^ \
+			t4[(q >> 24) & 255])
 # else
 #  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
-#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
-			t1[(crc >> 8) & 255] ^ \
-			t2[(crc >> 16) & 255] ^ \
-			t3[(crc >> 24) & 255]
-#  define DO_CRC8a (t4[(q) & 255] ^ \
-			t5[(q >> 8) & 255] ^ \
-			t6[(q >> 16) & 255] ^ \
-			t7[(q >> 24) & 255])
-#  define DO_CRC8b (t0[(q) & 255] ^ \
+#  define DO_CRC4 (t0[(q) & 255] ^ \
 			t1[(q >> 8) & 255] ^ \
 			t2[(q >> 16) & 255] ^ \
 			t3[(q >> 24) & 255])
+#  define DO_CRC8 (t4[(q) & 255] ^ \
+			t5[(q >> 8) & 255] ^ \
+			t6[(q >> 16) & 255] ^ \
+			t7[(q >> 24) & 255])
 # endif
+
+/* implements slicing-by-4 or slicing-by-8 algorithm */
+static inline u32 crc32_body(u32 crc, unsigned char const *buf,
+			     size_t len, const u32 (*tab)[256])
+{
 	const u32 *b;
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+	u8 *p;
+	u32 q;
 	size_t init_len;
 	size_t middle_len;
 	size_t rem_len;
+	size_t i;

 	/* break buf into init_len bytes before and
 	 * rem_len bytes after a middle section with
@@ -99,37 +99,34 @@ crc32_body(u32 crc, unsigned char const
 	rem_len = (len - init_len) & 7;
 # endif

-	/* Align it */
-	if (unlikely(init_len)) {
-		do {
-			DO_CRC(*buf++);
-		} while (--init_len);
-	}
-	b = (const u32 *)buf;
-	for (--b; middle_len; --middle_len) {
+	/* process unaligned initial bytes */
+	for (i = 0; i < init_len; i++)
+		DO_CRC(*buf++);
+
+	/* process aligned words */
+	b = (const u32 *)(buf - 4);
+
+	for (i = 0; i < middle_len; i++) {
 # if CRC_LE_BITS == 32
-		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
+		/* slicing-by-4 algorithm */
+		q = crc ^ *++b; /* use pre increment for speed */
+		crc = DO_CRC4;
 # else
-		u32 q;
+		/* slicing-by-8 algorithm */
 		q = crc ^ *++b;
-		crc = DO_CRC8a;
+		crc = DO_CRC8;
 		q = *++b;
-		crc ^= DO_CRC8b;
+		crc ^= DO_CRC4;
 # endif
 	}
-	/* And the last few bytes */
-	if (rem_len) {
-		u8 *p = (u8 *)(b + 1) - 1;
-		do {
-			DO_CRC(*++p); /* use pre increment for speed */
-		} while (--rem_len);
-	}
+
+	/* process unaligned remaining bytes */
+	p = (u8 *)(b + 1) - 1;
+
+	for (i = 0; i < rem_len; i++)
+		DO_CRC(*++p); /* use pre increment for speed */
+
 	return crc;
-#undef DO_CRC
-#undef DO_CRC4
-#undef DO_CRC8a
-#undef DO_CRC8b
 }
 #endif

