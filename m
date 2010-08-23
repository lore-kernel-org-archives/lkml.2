Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0HWIjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:39:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57198 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0HWIjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:39:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Blackfin: fix hweight breakage
Date: Mon, 23 Aug 2010 04:40:03 -0400
Message-Id: <1282552805-18989-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
References: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit to add constant optimization to hweight implicitly broke
the Blackfin arch.  Seems we were missed when all the other arches were
fixed with renames.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/bitops.h |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index d5872cd..3f7ef4d 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -22,7 +22,9 @@
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
+
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
@@ -115,7 +117,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
  * of bits set) of a N-bit word
  */
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -125,19 +127,20 @@ static inline unsigned int hweight32(unsigned int w)
 	return res;
 }
 
-static inline unsigned int hweight64(__u64 w)
+static inline unsigned int __arch_hweight64(__u64 w)
 {
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __arch_hweight32((unsigned int)(w >> 32)) +
+	       __arch_hweight32((unsigned int)w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight32(w & 0xffff);
+	return __arch_hweight32(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight32(w & 0xff);
+	return __arch_hweight32(w & 0xff);
 }
 
 #endif				/* _BLACKFIN_BITOPS_H */
-- 
1.7.2

