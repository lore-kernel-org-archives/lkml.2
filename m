Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2EYQq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:46:28 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31043 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2EYQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:46:26 -0400
Message-ID: <201205251646.q4PGkPkJ022227@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 May 2012 12:32:09 -0400
Subject: [PATCH] tile: fix bug where fls(0) was not returning 0
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is because __builtin_clz(0) returns 64 for the "undefined" case
of 0, since the builtin just does a right-shift 32 and "clz" instruction.
So, use the alpha approach of casting to u32 and using __builtin_clzll().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/bitops.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index 16f1fa5..bd186c4 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -77,6 +77,11 @@ static inline int ffs(int x)
 	return __builtin_ffs(x);
 }
 
+static inline int fls64(__u64 w)
+{
+	return (sizeof(__u64) * 8) - __builtin_clzll(w);
+}
+
 /**
  * fls - find last set bit in word
  * @x: the word to search
@@ -90,12 +95,7 @@ static inline int ffs(int x)
  */
 static inline int fls(int x)
 {
-	return (sizeof(int) * 8) - __builtin_clz(x);
-}
-
-static inline int fls64(__u64 w)
-{
-	return (sizeof(__u64) * 8) - __builtin_clzll(w);
+	return fls64((unsigned int) x);
 }
 
 static inline unsigned int __arch_hweight32(unsigned int w)
-- 
1.6.5.2

