Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2GBUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:25:39 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57662 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2GBUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:25:37 -0400
Date: Mon, 2 Jul 2012 13:25:34 -0700
From: Andrew Hunter <ahh@google.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] core-kernel: use multiply instead of shifts in hash_64
Message-ID: <20120702202534.GC844@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hash_64(val) = val * (a 64-bit constant).  It is "optimized" by
replacing the multiply by a bunch of shifts and adds.  On modern
machines, this is not an optimization; remove it.

Running this hash function in a independent benchmark, it's about three times
as fast (1ns vs 3ns) with a multiply as with a shift on Westmere. It's also
considerably smaller (and since we inline this function often, that matters.)

Signed-off-by: Andrew Hunter <ahh@google.com>
Reviewed-by: Paul Turner <pjt@google.com>
---
 include/linux/hash.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/hash.h b/include/linux/hash.h
index b80506b..daabc3d 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -34,7 +34,9 @@
 static inline u64 hash_64(u64 val, unsigned int bits)
 {
 	u64 hash = val;
-
+#if BITS_PER_LONG == 64
+	hash *= GOLDEN_RATIO_PRIME_64;
+#else
 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
 	u64 n = hash;
 	n <<= 18;
@@ -49,7 +51,7 @@ static inline u64 hash_64(u64 val, unsigned int bits)
 	hash += n;
 	n <<= 2;
 	hash += n;
-
+#endif
 	/* High bits are more random, so use them. */
 	return hash >> (64 - bits);
 }
-- 
1.7.7.3
