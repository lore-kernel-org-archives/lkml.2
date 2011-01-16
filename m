Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1APNNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:13:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1APNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MnBcm6FL3AEuVgZSyZs/S7G/tNuyIlJKoh56AL+InCpETddKzZKcKzxuv4VHNVUzB2
         3kqHYUsq0R5/LxyH5tPvhu9f9WBCZvayOVm0WM838k6vj5pzdzBB/DayGRb4DcapytmN
         LtsPQKnXlFf0CFHLTtwBibQlc1Jiy9Ggq3ffc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 04/24] s390: introduce little-endian bitops
Date: Sun, 16 Jan 2011 22:08:33 +0900
Message-Id: <1295183333-13802-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming native ext2 bit
operations.  The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

Change from v3:
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/

The whole series is available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

 arch/s390/include/asm/bitops.h |   59 +++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 2e05972..69217c8 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -742,18 +742,22 @@ static inline int sched_find_first_bit(unsigned long *b)
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
-#define ext2_set_bit(nr, addr)       \
-	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_set_bit_atomic(lock, nr, addr)       \
-	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit(nr, addr)     \
-	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)     \
-	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_test_bit(nr, addr)      \
-	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-
-static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
+#define __set_bit_le(nr, addr)	\
+	__set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __clear_bit_le(nr, addr)	\
+	__clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __test_and_set_bit_le(nr, addr)	\
+	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_and_set_bit_le(nr, addr)	\
+	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __test_and_clear_bit_le(nr, addr)	\
+	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_and_clear_bit_le(nr, addr)	\
+	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_bit_le(nr, addr)	\
+	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+
+static inline int find_first_zero_bit_le(void *vaddr, unsigned int size)
 {
 	unsigned long bytes, bits;
 
@@ -764,7 +768,7 @@ static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
+static inline int find_next_zero_bit_le(void *vaddr, unsigned long size,
 					  unsigned long offset)
 {
         unsigned long *addr = vaddr, *p;
@@ -790,11 +794,10 @@ static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
 		size -= __BITOPS_WORDSIZE;
 		p++;
         }
-	return offset + ext2_find_first_zero_bit(p, size);
+	return offset + find_first_zero_bit_le(p, size);
 }
 
-static inline unsigned long ext2_find_first_bit(void *vaddr,
-						unsigned long size)
+static inline unsigned long find_first_bit_le(void *vaddr, unsigned long size)
 {
 	unsigned long bytes, bits;
 
@@ -805,7 +808,7 @@ static inline unsigned long ext2_find_first_bit(void *vaddr,
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
+static inline int find_next_bit_le(void *vaddr, unsigned long size,
 				     unsigned long offset)
 {
 	unsigned long *addr = vaddr, *p;
@@ -831,9 +834,29 @@ static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
 		size -= __BITOPS_WORDSIZE;
 		p++;
 	}
-	return offset + ext2_find_first_bit(p, size);
+	return offset + find_first_bit_le(p, size);
 }
 
+#define ext2_set_bit(nr, addr)       \
+	__test_and_set_bit_le((nr), (unsigned long *)(addr))
+#define ext2_set_bit_atomic(lock, nr, addr)       \
+	test_and_set_bit_le((nr), (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr)     \
+	__test_and_clear_bit_le((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)     \
+	test_and_clear_bit_le((nr), (unsigned long *)(addr))
+#define ext2_test_bit(nr, addr)      \
+	test_bit_le((nr), (unsigned long *)(addr))
+
+#define ext2_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_bit_le((unsigned long *)(vaddr), (size))
+#define ext2_find_next_zero_bit(vaddr, size, offset)	\
+	find_next_zero_bit_le((unsigned long *)(vaddr), (size), (offset))
+#define ext2_find_first_bit(vaddr, size)	\
+	find_first_bit_le((unsigned long *)(vaddr), (size))
+#define ext2_find_next_bit(vaddr, size, offset)	\
+	find_next_bit_le((unsigned long *)(vaddr), (size), (offset))
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
-- 
1.7.3.4

