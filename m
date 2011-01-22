Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1AVNNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:13:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1AVNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jevTF+2iuqvk0MUUeTtEUm/tzh/Yw4oHVPNdc0ibRVZkQXG8UDFquY4g3Fqd869S4s
         WUIXIKEm5dco7sBm7IjMR3pecWWqCNcoz18AqDx82NyKDFeqUx4n/57xqlkFFUR/eYnc
         E002JdkLN4Y5ksJQZR9eKvCE0W+OiL0mbgd8s=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 03/27] bitops: merge little and big endian definisions in asm-generic/bitops/le.h
Date: Sat, 22 Jan 2011 22:13:35 +0900
Message-Id: <1295702039-23186-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
References: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces little-endian bit operations in asm/bitops.h
for all architectures and converts all ext2 non-atomic and minix bit
operations to use little-endian bit operations.  It enables us to remove
ext2 non-atomic and minix bit operations from asm/bitops.h.  The reason
they should be removed from asm/bitops.h is as follows:

For ext2 non-atomic bit operations, they are used for little-endian byte
order bitmap access by some filesystems and modules.  But using ext2_*()
functions on a module other than ext2 filesystem makes some feel strange.

For minix bit operations, they are only used by minix filesystem and are
useless by other modules.  Because byte order of inode and block bitmap is
different on each architecture.

This patch:

In order to make the forthcoming changes smaller, this merges macro
definisions in asm-generic/bitops/le.h for big-endian and little-endian as
much as possible.

This also removes unused BITOP_WORD macro.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v4:
 - no changes

The whole series is available in the git branch at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

 include/asm-generic/bitops/le.h |   46 +++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 80e3bf1..9085429 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -4,27 +4,33 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
-
 #if defined(__LITTLE_ENDIAN)
 
-#define generic_test_le_bit(nr, addr) test_bit(nr, addr)
-#define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
-#define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
-
-#define generic_test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
-#define generic_test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
-
-#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
-#define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
+#define BITOP_LE_SWIZZLE	0
 
-#define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
+#define generic_find_next_zero_le_bit(addr, size, offset) \
+	find_next_zero_bit(addr, size, offset)
 #define generic_find_next_le_bit(addr, size, offset) \
-			find_next_bit(addr, size, offset)
+	find_next_bit(addr, size, offset)
+#define generic_find_first_zero_le_bit(addr, size) \
+	find_first_zero_bit(addr, size)
 
 #elif defined(__BIG_ENDIAN)
 
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+#define generic_find_first_zero_le_bit(addr, size) \
+	generic_find_next_zero_le_bit((addr), (size), 0)
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
 #define generic_test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 #define generic___set_le_bit(nr, addr) \
@@ -42,16 +48,4 @@
 #define generic___test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#define generic_find_first_zero_le_bit(addr, size) \
-        generic_find_next_zero_le_bit((addr), (size), 0)
-
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
-- 
1.7.3.4

