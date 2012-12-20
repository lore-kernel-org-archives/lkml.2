Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab2LTJLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:11:50 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33968 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2LTJLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:11:47 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 1/5] perf tools: Add some functions to bitops.h to support more bitmap operations.
Date: Thu, 20 Dec 2012 17:05:15 +0800
Message-Id: <1355994316-13583-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bitmap_copy() & find_first_zero_bit() to the 'util/include/linux/bitops.h'.
These functions could be need if we want to change the thread_map or any other
mechanism with bitmap.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
---
 tools/perf/util/include/linux/bitops.h |   85 ++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index a55d8cf..644504a 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -4,6 +4,12 @@
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <asm/hweight.h>
+#include <string.h>
+
+typedef unsigned long	BITMAP;
+
+#define PID_MAX_DEFAULT 0x8000
+#define CPU_MAX_DEFAULT 0x40
 
 #ifndef __WORDSIZE
 #define __WORDSIZE (__SIZEOF_LONG__ * 8)
@@ -26,36 +32,57 @@
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-static inline void set_bit(int nr, unsigned long *addr)
+static inline void set_bit(int nr, BITMAP *addr)
 {
 	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
 }
 
-static inline void clear_bit(int nr, unsigned long *addr)
+static inline void clear_bit(int nr, BITMAP *addr)
 {
 	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
 }
 
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+static __always_inline int test_bit(unsigned int nr, const BITMAP *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+		(((BITMAP *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-static inline unsigned long hweight_long(unsigned long w)
+static inline BITMAP hweight_long(BITMAP w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
+static inline void bitmap_copy(BITMAP *dst, const BITMAP *src,
+			       int nbits)
+{
+	int len = BITS_TO_LONGS(nbits) * sizeof(BITMAP);
+	memcpy(dst, src, len);
+}
+
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
+/*
+ * ffz - find first zero bit in word
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static __always_inline BITMAP ffz(BITMAP word)
+{
+	asm("rep; bsf %1,%0"
+		: "=r" (word)
+		: "r" (~word));
+	return word;
+}
+
 /**
  * __ffs - find first bit in word.
  * @word: The word to search
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static __always_inline unsigned long __ffs(unsigned long word)
+static __always_inline BITMAP __ffs(BITMAP word)
 {
 	int num = 0;
 
@@ -87,14 +114,40 @@ static __always_inline unsigned long __ffs(unsigned long word)
 }
 
 /*
+ * Find the first cleared bit in a memory region.
+ */
+static inline BITMAP
+find_first_zero_bit(const BITMAP *addr, BITMAP size)
+{
+	const BITMAP *p = addr;
+	BITMAP result = 0;
+	BITMAP tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if (~(tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) | (~0UL << size);
+	if (tmp == ~0UL)        /* Are any bits zero? */
+		return result + size;   /* Nope. */
+found:
+	return result + __ffs(~tmp);
+}
+
+/*
  * Find the first set bit in a memory region.
  */
-static inline unsigned long
-find_first_bit(const unsigned long *addr, unsigned long size)
+static inline BITMAP
+find_first_bit(const BITMAP *addr, BITMAP size)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
-	unsigned long tmp;
+	const BITMAP *p = addr;
+	BITMAP result = 0;
+	BITMAP tmp;
 
 	while (size & ~(BITS_PER_LONG-1)) {
 		if ((tmp = *(p++)))
@@ -115,12 +168,12 @@ found:
 /*
  * Find the next set bit in a memory region.
  */
-static inline unsigned long
-find_next_bit(const unsigned long *addr, unsigned long size, unsigned long offset)
+static inline BITMAP
+find_next_bit(const BITMAP *addr, BITMAP size, BITMAP offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
+	const BITMAP *p = addr + BITOP_WORD(offset);
+	BITMAP result = offset & ~(BITS_PER_LONG-1);
+	BITMAP tmp;
 
 	if (offset >= size)
 		return size;
-- 
1.7.9.5

