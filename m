Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2BCOeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:34:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65409 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab2BCOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:34:00 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>, joe@perches.com,
        linux-mtd@lists.infradead.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] string: memchr_inv speed improvements
Date: Fri,  3 Feb 2012 23:34:17 +0900
Message-Id: <1328279657-9054-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Generate a 64-bit pattern more efficiently

memchr_inv needs to generate a 64-bit pattern filled with a target
character.  The operation can be done by more efficient way.

- Don't call the slow check_bytes() if the memory area is 64-bit aligned

memchr_inv compares contiguous 64-bit words with the 64-bit pattern as
much as possible.  The outside of the region is checked by check_bytes()
that scans for each byte.  Unfortunately, the first 64-bit word is
unexpectedly scanned by check_bytes() even if the memory area is aligned
to a 64-bit boundary.

Both changes were originally suggested by Eric Dumazet.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 lib/string.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index dc4a863..3a03782 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -785,12 +785,24 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
 
-	value64 = value | value << 8 | value << 16 | value << 24;
-	value64 = (value64 & 0xffffffff) | value64 << 32;
-	prefix = 8 - ((unsigned long)start) % 8;
+	value64 = value;
+#if defined(ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
+	value64 *= 0x0101010101010101;
+#elif defined(ARCH_HAS_FAST_MULTIPLIER)
+	value64 *= 0x01010101;
+	value64 |= value64 << 32;
+#else
+	value64 |= value64 << 8;
+	value64 |= value64 << 16;
+	value64 |= value64 << 32;
+#endif
 
+	prefix = (unsigned long)start % 8;
 	if (prefix) {
-		u8 *r = check_bytes8(start, value, prefix);
+		u8 *r;
+
+		prefix = 8 - prefix;
+		r = check_bytes8(start, value, prefix);
 		if (r)
 			return r;
 		start += prefix;
-- 
1.7.4.4

