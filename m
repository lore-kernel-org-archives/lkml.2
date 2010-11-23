Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0KWNjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:39:15 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:57507 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0KWNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rbeS9CHY4lMzWc+7FmDVAviHB45gMjA7f/mk1thCcy+IkG2k88J2vA3rMn6DY9eByP
         uxdX9FJpXB+OUs3s6W3/i98HOkMXJslKQKzq6gvpu6Qbw8NQAF4o5gj/2LTtBjk4tlK5
         DdDsok19s988yKhfPvCgUlRk4F+JY/JJQelxI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 03/22] s390: introduce little-endian bitops
Date: Tue, 23 Nov 2010 22:38:05 +0900
Message-Id: <1290519504-3958-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce little-endian bit operations by renaming native ext2 bit
operations. The ext2 bit operations are kept as wrapper macros using
little-endian bit operations to maintain bisectability until the
conversions are finished.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
No change from previous submission
 arch/s390/include/asm/bitops.h |   59 +++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 2e05972..e10b81e 100644
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
+#define __set_le_bit(nr, addr)	\
+	__set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __clear_le_bit(nr, addr)	\
+	__clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __test_and_set_le_bit(nr, addr)	\
+	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_and_set_le_bit(nr, addr)	\
+	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define __test_and_clear_le_bit(nr, addr)	\
+	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_and_clear_le_bit(nr, addr)	\
+	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+#define test_le_bit(nr, addr)	\
+	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
+
+static inline int find_first_zero_le_bit(void *vaddr, unsigned int size)
 {
 	unsigned long bytes, bits;
 
@@ -764,7 +768,7 @@ static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
+static inline int find_next_zero_le_bit(void *vaddr, unsigned long size,
 					  unsigned long offset)
 {
         unsigned long *addr = vaddr, *p;
@@ -790,11 +794,10 @@ static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
 		size -= __BITOPS_WORDSIZE;
 		p++;
         }
-	return offset + ext2_find_first_zero_bit(p, size);
+	return offset + find_first_zero_le_bit(p, size);
 }
 
-static inline unsigned long ext2_find_first_bit(void *vaddr,
-						unsigned long size)
+static inline unsigned long find_first_le_bit(void *vaddr, unsigned long size)
 {
 	unsigned long bytes, bits;
 
@@ -805,7 +808,7 @@ static inline unsigned long ext2_find_first_bit(void *vaddr,
 	return (bits < size) ? bits : size;
 }
 
-static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
+static inline int find_next_le_bit(void *vaddr, unsigned long size,
 				     unsigned long offset)
 {
 	unsigned long *addr = vaddr, *p;
@@ -831,9 +834,29 @@ static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
 		size -= __BITOPS_WORDSIZE;
 		p++;
 	}
-	return offset + ext2_find_first_bit(p, size);
+	return offset + find_first_le_bit(p, size);
 }
 
+#define ext2_set_bit(nr, addr)       \
+	__test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define ext2_set_bit_atomic(lock, nr, addr)       \
+	test_and_set_le_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit(nr, addr)     \
+	__test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)     \
+	test_and_clear_le_bit((nr), (unsigned long *)(addr))
+#define ext2_test_bit(nr, addr)      \
+	test_le_bit((nr), (unsigned long *)(addr))
+
+#define ext2_find_first_zero_bit(vaddr, size)	\
+	find_first_zero_le_bit((unsigned long *)(vaddr), (size))
+#define ext2_find_next_zero_bit(vaddr, size, offset)	\
+	find_next_zero_le_bit((unsigned long *)(vaddr), (size), (offset))
+#define ext2_find_first_bit(vaddr, size)	\
+	find_first_le_bit((unsigned long *)(vaddr), (size))
+#define ext2_find_next_bit(vaddr, size, offset)	\
+	find_next_le_bit((unsigned long *)(vaddr), (size), (offset))
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
-- 
1.7.3.2

