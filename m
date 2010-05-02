Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab0EBW7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 18:59:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab0EBW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 18:59:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] perf tools: Don't use code surrounded by __KERNEL__
Date: Sun,  2 May 2010 19:58:58 -0300
Message-Id: <1272841142-26029-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272841142-26029-1-git-send-email-acme@infradead.org>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to refactor code to be explicitely shared by the kernel and at
least the tools/ userspace programs, so, till we do that, copy the bare
minimum bitmap/bitops code needed by tools/perf.

Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                    |   16 +------------
 tools/perf/util/bitmap.c               |   21 +++++++++++++++++
 tools/perf/util/hweight.c              |   31 ++++++++++++++++++++++++++
 tools/perf/util/include/asm/bitops.h   |   18 ---------------
 tools/perf/util/include/asm/hweight.h  |    8 ++++++
 tools/perf/util/include/linux/bitmap.h |   38 +++++++++++++++++++++++++++++--
 tools/perf/util/include/linux/bitops.h |   20 +++++++---------
 7 files changed, 105 insertions(+), 47 deletions(-)
 create mode 100644 tools/perf/util/bitmap.c
 create mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/bitops.h
 create mode 100644 tools/perf/util/include/asm/hweight.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 739c441..c5ac0a9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -377,9 +377,9 @@ LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/asm/asm-offsets.h
-LIB_H += util/include/asm/bitops.h
 LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
+LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
@@ -435,7 +435,6 @@ LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
 LIB_OBJS += $(OUTPUT)util/hweight.o
-LIB_OBJS += $(OUTPUT)util/find_next_bit.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
@@ -948,19 +947,6 @@ $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-# some perf warning policies can't fit to lib/bitmap.c, eg: it warns about variable shadowing
-# from <string.h> that comes from kernel headers wrapping.
-KBITMAP_FLAGS=`echo $(ALL_CFLAGS) | sed s/-Wshadow// | sed s/-Wswitch-default// | sed s/-Wextra//`
-
-$(OUTPUT)util/bitmap.o: ../../lib/bitmap.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(KBITMAP_FLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/find_next_bit.o: ../../lib/find_next_bit.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
diff --git a/tools/perf/util/bitmap.c b/tools/perf/util/bitmap.c
new file mode 100644
index 0000000..5e230ac
--- /dev/null
+++ b/tools/perf/util/bitmap.c
@@ -0,0 +1,21 @@
+/*
+ * From lib/bitmap.c
+ * Helper functions for bitmap.h.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+#include <linux/bitmap.h>
+
+int __bitmap_weight(const unsigned long *bitmap, int bits)
+{
+	int k, w = 0, lim = bits/BITS_PER_LONG;
+
+	for (k = 0; k < lim; k++)
+		w += hweight_long(bitmap[k]);
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w;
+}
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
new file mode 100644
index 0000000..5c1d0d0
--- /dev/null
+++ b/tools/perf/util/hweight.c
@@ -0,0 +1,31 @@
+#include <linux/bitops.h>
+
+/**
+ * hweightN - returns the hamming weight of a N-bit word
+ * @x: the word to weigh
+ *
+ * The Hamming Weight of a number is the total number of bits set in it.
+ */
+
+unsigned int hweight32(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
+unsigned long hweight64(__u64 w)
+{
+#if BITS_PER_LONG == 32
+	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+#elif BITS_PER_LONG == 64
+	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
+	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
+	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
+	res = res + (res >> 8);
+	res = res + (res >> 16);
+	return (res + (res >> 32)) & 0x00000000000000FFul;
+#endif
+}
diff --git a/tools/perf/util/include/asm/bitops.h b/tools/perf/util/include/asm/bitops.h
deleted file mode 100644
index 58e9817..0000000
--- a/tools/perf/util/include/asm/bitops.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _PERF_ASM_BITOPS_H_
-#define _PERF_ASM_BITOPS_H_
-
-#include <sys/types.h>
-#include "../../types.h"
-#include <linux/compiler.h>
-
-/* CHECKME: Not sure both always match */
-#define BITS_PER_LONG	__WORDSIZE
-
-#include "../../../../include/asm-generic/bitops/__fls.h"
-#include "../../../../include/asm-generic/bitops/fls.h"
-#include "../../../../include/asm-generic/bitops/fls64.h"
-#include "../../../../include/asm-generic/bitops/__ffs.h"
-#include "../../../../include/asm-generic/bitops/ffz.h"
-#include "../../../../include/asm-generic/bitops/hweight.h"
-
-#endif
diff --git a/tools/perf/util/include/asm/hweight.h b/tools/perf/util/include/asm/hweight.h
new file mode 100644
index 0000000..36cf26d
--- /dev/null
+++ b/tools/perf/util/include/asm/hweight.h
@@ -0,0 +1,8 @@
+#ifndef PERF_HWEIGHT_H
+#define PERF_HWEIGHT_H
+
+#include <linux/types.h>
+unsigned int hweight32(unsigned int w);
+unsigned long hweight64(__u64 w);
+
+#endif /* PERF_HWEIGHT_H */
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index 9450763..eda4416 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -1,3 +1,35 @@
-#include "../../../../include/linux/bitmap.h"
-#include "../../../../include/asm-generic/bitops/find.h"
-#include <linux/errno.h>
+#ifndef _PERF_BITOPS_H
+#define _PERF_BITOPS_H
+
+#include <string.h>
+#include <linux/bitops.h>
+
+int __bitmap_weight(const unsigned long *bitmap, int bits);
+
+#define BITMAP_LAST_WORD_MASK(nbits)					\
+(									\
+	((nbits) % BITS_PER_LONG) ?					\
+		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
+)
+
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+
+static inline void bitmap_zero(unsigned long *dst, int nbits)
+{
+	if (small_const_nbits(nbits))
+		*dst = 0UL;
+	else {
+		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		memset(dst, 0, len);
+	}
+}
+
+static inline int bitmap_weight(const unsigned long *src, int nbits)
+{
+	if (small_const_nbits(nbits))
+		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
+	return __bitmap_weight(src, nbits);
+}
+
+#endif /* _PERF_BITOPS_H */
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 8d63116..bb4ac2e 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -1,13 +1,12 @@
 #ifndef _PERF_LINUX_BITOPS_H_
 #define _PERF_LINUX_BITOPS_H_
 
-#define __KERNEL__
+#include <linux/kernel.h>
+#include <asm/hweight.h>
 
-#define CONFIG_GENERIC_FIND_NEXT_BIT
-#define CONFIG_GENERIC_FIND_FIRST_BIT
-#include "../../../../include/linux/bitops.h"
-
-#undef __KERNEL__
+#define BITS_PER_LONG __WORDSIZE
+#define BITS_PER_BYTE           8
+#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 
 static inline void set_bit(int nr, unsigned long *addr)
 {
@@ -20,10 +19,9 @@ static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr, unsigned
-		long size, unsigned long offset);
-
-unsigned long generic_find_next_le_bit(const unsigned long *addr, unsigned
-		long size, unsigned long offset);
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
 
 #endif
-- 
1.6.2.5

