Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2E1Dgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52104 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931Ab2E1D3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:44 -0400
Message-Id: <20120528031216.794239447@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 101/117] tile: fix bug where fls(0) was not returning 0
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 9f1d62bed7f015d11b9164078b7fea433b474114 upstream.

This is because __builtin_clz(0) returns 64 for the "undefined" case
of 0, since the builtin just does a right-shift 32 and "clz" instruction.
So, use the alpha approach of casting to u32 and using __builtin_clzll().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/include/asm/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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


