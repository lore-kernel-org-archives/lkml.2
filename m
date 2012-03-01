Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434Ab2CAV62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:58:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064Ab2CAVuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.219.130 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.516130478@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 14/34] crypto: sha512 - use standard ror64()
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit f2ea0f5f04c97b48c88edccba52b0682fbe45087 upstream.

Use standard ror64() instead of hand-written.
There is no standard ror64, so create it.

The difference is shift value being "unsigned int" instead of uint64_t
(for which there is no reason). gcc starts to emit native ROR instructions
which it doesn't do for some reason currently. This should make the code
faster.

Patch survives in-tree crypto test and ping flood with hmac(sha512) on.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/sha512_generic.c |   13 ++++---------
 include/linux/bitops.h  |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -31,11 +31,6 @@ static inline u64 Maj(u64 x, u64 y, u64
         return (x & y) | (z & (x | y));
 }
 
-static inline u64 RORu64(u64 x, u64 y)
-{
-        return (x >> y) | (x << (64 - y));
-}
-
 static const u64 sha512_K[80] = {
         0x428a2f98d728ae22ULL, 0x7137449123ef65cdULL, 0xb5c0fbcfec4d3b2fULL,
         0xe9b5dba58189dbbcULL, 0x3956c25bf348b538ULL, 0x59f111f1b605d019ULL,
@@ -66,10 +61,10 @@ static const u64 sha512_K[80] = {
         0x5fcb6fab3ad6faecULL, 0x6c44198c4a475817ULL,
 };
 
-#define e0(x)       (RORu64(x,28) ^ RORu64(x,34) ^ RORu64(x,39))
-#define e1(x)       (RORu64(x,14) ^ RORu64(x,18) ^ RORu64(x,41))
-#define s0(x)       (RORu64(x, 1) ^ RORu64(x, 8) ^ (x >> 7))
-#define s1(x)       (RORu64(x,19) ^ RORu64(x,61) ^ (x >> 6))
+#define e0(x)       (ror64(x,28) ^ ror64(x,34) ^ ror64(x,39))
+#define e1(x)       (ror64(x,14) ^ ror64(x,18) ^ ror64(x,41))
+#define s0(x)       (ror64(x, 1) ^ ror64(x, 8) ^ (x >> 7))
+#define s1(x)       (ror64(x,19) ^ ror64(x,61) ^ (x >> 6))
 
 static inline void LOAD_OP(int I, u64 *W, const u8 *input)
 {
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -46,6 +46,26 @@ static inline unsigned long hweight_long
 }
 
 /**
+ * rol64 - rotate a 64-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u64 rol64(__u64 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (64 - shift));
+}
+
+/**
+ * ror64 - rotate a 64-bit value right
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline __u64 ror64(__u64 word, unsigned int shift)
+{
+	return (word >> shift) | (word << (64 - shift));
+}
+
+/**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
  * @shift: bits to roll


