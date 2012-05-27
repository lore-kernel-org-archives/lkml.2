Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437Ab2E0BM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:12:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab2E0BMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:12:54 -0400
Message-Id: <20120527010435.877046091@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:49 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 86/94] tile: fix bug where fls(0) was not returning 0
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 9f1d62bed7f015d11b9164078b7fea433b474114 upstream.

This is because __builtin_clz(0) returns 64 for the "undefined" case
of 0, since the builtin just does a right-shift 32 and "clz" instruction.
So, use the alpha approach of casting to u32 and using __builtin_clzll().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/include/asm/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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


