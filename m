Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2D2S7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:59:21 -0400
Received: from [12.216.194.151] ([12.216.194.151]:53770 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2D2S7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:59:18 -0400
Message-ID: <201204291859.q3TIxHBU007274@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 28 Apr 2012 15:41:39 -0400
Subject: [PATCH v2 5/6] arch/tile: break out the "csum a long" function to <asm/checksum.h>
To: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204101042.39877.arnd@arndb.de> <4F8763E1.1020605@tilera.com> <201204131034.03544.arnd@arndb.de> <4F9C6A0A.5090109@tilera.com> <201204291856.q3TIusXq007168@farm-0027.internal.tilera.com>
In-Reply-To: <201204291856.q3TIusXq007168@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it available to the tilegx network driver.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/checksum.h |   18 ++++++++++++++++++
 arch/tile/lib/checksum.c         |   15 +--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/tile/include/asm/checksum.h b/arch/tile/include/asm/checksum.h
index a120766..b21a2fd 100644
--- a/arch/tile/include/asm/checksum.h
+++ b/arch/tile/include/asm/checksum.h
@@ -21,4 +21,22 @@
 __wsum do_csum(const unsigned char *buff, int len);
 #define do_csum do_csum
 
+/*
+ * Return the sum of all the 16-bit subwords in a long.
+ * This sums two subwords on a 32-bit machine, and four on 64 bits.
+ * The implementation does two vector adds to capture any overflow.
+ */
+static inline unsigned int csum_long(unsigned long x)
+{
+	unsigned long ret;
+#ifdef __tilegx__
+	ret = __insn_v2sadu(x, 0);
+	ret = __insn_v2sadu(ret, 0);
+#else
+	ret = __insn_sadh_u(x, 0);
+	ret = __insn_sadh_u(ret, 0);
+#endif
+	return ret;
+}
+
 #endif /* _ASM_TILE_CHECKSUM_H */
diff --git a/arch/tile/lib/checksum.c b/arch/tile/lib/checksum.c
index e4bab5b..c3ca3e6 100644
--- a/arch/tile/lib/checksum.c
+++ b/arch/tile/lib/checksum.c
@@ -16,19 +16,6 @@
 #include <net/checksum.h>
 #include <linux/module.h>
 
-static inline unsigned int longto16(unsigned long x)
-{
-	unsigned long ret;
-#ifdef __tilegx__
-	ret = __insn_v2sadu(x, 0);
-	ret = __insn_v2sadu(ret, 0);
-#else
-	ret = __insn_sadh_u(x, 0);
-	ret = __insn_sadh_u(ret, 0);
-#endif
-	return ret;
-}
-
 __wsum do_csum(const unsigned char *buff, int len)
 {
 	int odd, count;
@@ -94,7 +81,7 @@ __wsum do_csum(const unsigned char *buff, int len)
 	}
 	if (len & 1)
 		result += *buff;
-	result = longto16(result);
+	result = csum_long(result);
 	if (odd)
 		result = swab16(result);
 out:
-- 
1.6.5.2

