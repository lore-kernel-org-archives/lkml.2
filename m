Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0KDPji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41999 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0KDPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:35 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 12/20] perf: Export generic kernel utils to library
Date: Thu,  4 Nov 2010 16:36:48 +0100
Message-Id: <1288885016-18295-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move all bitops-related stuff together.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile                  |    5 ++
 tools/lib/lk/bitmap.c                  |   21 ++++++
 tools/lib/lk/bitmap.h                  |   35 ++++++++++
 tools/lib/lk/bitops.h                  |   30 +++++++++
 tools/lib/lk/hweight.c                 |   31 +++++++++
 tools/lib/lk/kernel.h                  |  113 ++++++++++++++++++++++++++++++++
 tools/perf/Makefile                    |    6 --
 tools/perf/util/bitmap.c               |   21 ------
 tools/perf/util/build-id.c             |    2 +-
 tools/perf/util/event.h                |    1 +
 tools/perf/util/header.c               |    2 +-
 tools/perf/util/header.h               |    2 +-
 tools/perf/util/hweight.c              |   31 ---------
 tools/perf/util/include/asm/hweight.h  |    8 --
 tools/perf/util/include/linux/bitmap.h |   35 ----------
 tools/perf/util/include/linux/bitops.h |   27 --------
 tools/perf/util/include/linux/kernel.h |  111 -------------------------------
 tools/perf/util/map.h                  |    4 +-
 tools/perf/util/parse-options.h        |    2 +-
 tools/perf/util/pstack.c               |    2 +-
 tools/perf/util/session.c              |    2 +-
 tools/perf/util/strlist.h              |    1 +
 tools/perf/util/trace-event-info.c     |    2 +-
 23 files changed, 247 insertions(+), 247 deletions(-)
 create mode 100644 tools/lib/lk/bitmap.c
 create mode 100644 tools/lib/lk/bitmap.h
 create mode 100644 tools/lib/lk/bitops.h
 create mode 100644 tools/lib/lk/hweight.c
 create mode 100644 tools/lib/lk/kernel.h
 delete mode 100644 tools/perf/util/bitmap.c
 delete mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/hweight.h
 delete mode 100644 tools/perf/util/include/linux/bitmap.h
 delete mode 100644 tools/perf/util/include/linux/bitops.h
 delete mode 100644 tools/perf/util/include/linux/kernel.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 32cf118..f074216 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -10,6 +10,9 @@ LIB_H += types.h
 LIB_H += cpumap.h
 LIB_H += ../../../include/linux/rbtree.h
 LIB_H += rbtree.h
+LIB_H += bitops.h
+LIB_H += bitmap.h
+LIB_H += kernel.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
@@ -17,6 +20,8 @@ LIB_OBJS += util.o
 LIB_OBJS += cpumap.o
 LIB_OBJS += ctype.o
 LIB_OBJS += rbtree.o
+LIB_OBJS += hweight.o
+LIB_OBJS += bitmap.o
 
 LIBFILE = $(LIB_OUTPUT)lklib.a
 
diff --git a/tools/lib/lk/bitmap.c b/tools/lib/lk/bitmap.c
new file mode 100644
index 0000000..502340d
--- /dev/null
+++ b/tools/lib/lk/bitmap.c
@@ -0,0 +1,21 @@
+/*
+ * From lib/bitmap.c
+ * Helper functions for bitmap.h.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+#include "bitmap.h"
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
diff --git a/tools/lib/lk/bitmap.h b/tools/lib/lk/bitmap.h
new file mode 100644
index 0000000..9e9b619
--- /dev/null
+++ b/tools/lib/lk/bitmap.h
@@ -0,0 +1,35 @@
+#ifndef __LK_BITMAP_H
+#define __LK_BITMAP_H
+
+#include <string.h>
+#include <lk/bitops.h>
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
+#endif /* __LK_BITMAP_H */
diff --git a/tools/lib/lk/bitops.h b/tools/lib/lk/bitops.h
new file mode 100644
index 0000000..fabefb6
--- /dev/null
+++ b/tools/lib/lk/bitops.h
@@ -0,0 +1,30 @@
+#ifndef __LK_BITOPS_H
+#define __LK_BITOPS_H
+
+#include "kernel.h"
+#include "types.h"
+
+#define BITS_PER_LONG		__WORDSIZE
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+
+extern unsigned int hweight32(unsigned int w);
+extern unsigned long hweight64(u64 w);
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+}
+
+static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
+{
+	return ((1UL << (nr % BITS_PER_LONG)) &
+		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
+}
+
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
+
+#endif
diff --git a/tools/lib/lk/hweight.c b/tools/lib/lk/hweight.c
new file mode 100644
index 0000000..12aba74
--- /dev/null
+++ b/tools/lib/lk/hweight.c
@@ -0,0 +1,31 @@
+#include "bitops.h"
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
+unsigned long hweight64(u64 w)
+{
+#if BITS_PER_LONG == 32
+	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+#elif BITS_PER_LONG == 64
+	u64 res = w - ((w >> 1) & 0x5555555555555555ul);
+	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
+	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
+	res = res + (res >> 8);
+	res = res + (res >> 16);
+	return (res + (res >> 32)) & 0x00000000000000FFul;
+#endif
+}
diff --git a/tools/lib/lk/kernel.h b/tools/lib/lk/kernel.h
new file mode 100644
index 0000000..6c73c043
--- /dev/null
+++ b/tools/lib/lk/kernel.h
@@ -0,0 +1,113 @@
+#ifndef __LK_KERNEL_H
+#define __LK_KERNEL_H
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <assert.h>
+
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
+#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+#ifndef container_of
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#ifndef BUILD_BUG_ON_ZERO
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#endif
+
+#ifndef max
+#define max(x, y) ({				\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	(void) (&_max1 == &_max2);		\
+	_max1 > _max2 ? _max1 : _max2; })
+#endif
+
+#ifndef min
+#define min(x, y) ({				\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	(void) (&_min1 == &_min2);		\
+	_min1 < _min2 ? _min1 : _min2; })
+#endif
+
+#ifndef BUG_ON
+#define BUG_ON(cond) assert(!(cond))
+#endif
+
+/*
+ * Both need more care to handle endianness
+ * (Don't use bitmap_copy_le() for now)
+ */
+#define cpu_to_le64(x)	(x)
+#define cpu_to_le32(x)	(x)
+
+static inline int
+vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	int i;
+	ssize_t ssize = size;
+
+	i = vsnprintf(buf, size, fmt, args);
+
+	return (i >= ssize) ? (ssize - 1) : i;
+}
+
+static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
+{
+	va_list args;
+	ssize_t ssize = size;
+	int i;
+
+	va_start(args, fmt);
+	i = vsnprintf(buf, size, fmt, args);
+	va_end(args);
+
+	return (i >= ssize) ? (ssize - 1) : i;
+}
+
+static inline unsigned long
+simple_strtoul(const char *nptr, char **endptr, int base)
+{
+	return strtoul(nptr, endptr, base);
+}
+
+int eprintf(int level,
+	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_err(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug(fmt, ...) \
+	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debugN(n, fmt, ...) \
+	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
+
+#endif /* __LK_KERNEL_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2c82537..6a4a4f5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -334,11 +334,8 @@ LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
-LIB_H += util/include/linux/bitmap.h
-LIB_H += util/include/linux/bitops.h
 LIB_H += util/include/linux/compiler.h
 LIB_H += util/include/linux/ctype.h
-LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/module.h
 LIB_H += util/include/linux/poison.h
@@ -348,7 +345,6 @@ LIB_H += util/include/linux/types.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += util/include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
@@ -396,8 +392,6 @@ LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
 LIB_OBJS += $(OUTPUT)util/path.o
-LIB_OBJS += $(OUTPUT)util/bitmap.o
-LIB_OBJS += $(OUTPUT)util/hweight.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
 LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
diff --git a/tools/perf/util/bitmap.c b/tools/perf/util/bitmap.c
deleted file mode 100644
index 5e230ac..0000000
--- a/tools/perf/util/bitmap.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * From lib/bitmap.c
- * Helper functions for bitmap.h.
- *
- * This source code is licensed under the GNU General Public License,
- * Version 2.  See the file COPYING for more details.
- */
-#include <linux/bitmap.h>
-
-int __bitmap_weight(const unsigned long *bitmap, int bits)
-{
-	int k, w = 0, lim = bits/BITS_PER_LONG;
-
-	for (k = 0; k < lim; k++)
-		w += hweight_long(bitmap[k]);
-
-	if (bits % BITS_PER_LONG)
-		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
-
-	return w;
-}
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index ce89873..ce4c7d3 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -11,7 +11,7 @@
 #include "build-id.h"
 #include "event.h"
 #include "symbol.h"
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 #include "debug.h"
 
 static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8e790da..05587ce 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -2,6 +2,7 @@
 #define __PERF_RECORD_H
 
 #include <limits.h>
+#include <lk/kernel.h>
 
 #include "../perf.h"
 #include "map.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0ebd301..c64df23 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -6,7 +6,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <linux/list.h>
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 
 #include <lk/util.h>
 #include "header.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index fb6f0eb..274a829 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -7,7 +7,7 @@
 #include <lk/types.h>
 #include "event.h"
 
-#include <linux/bitmap.h>
+#include <lk/bitmap.h>
 
 struct perf_header_attr {
 	struct perf_event_attr attr;
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
deleted file mode 100644
index 5c1d0d0..0000000
--- a/tools/perf/util/hweight.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <linux/bitops.h>
-
-/**
- * hweightN - returns the hamming weight of a N-bit word
- * @x: the word to weigh
- *
- * The Hamming Weight of a number is the total number of bits set in it.
- */
-
-unsigned int hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned long hweight64(__u64 w)
-{
-#if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
-#elif BITS_PER_LONG == 64
-	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
-	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
-	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
-	res = res + (res >> 8);
-	res = res + (res >> 16);
-	return (res + (res >> 32)) & 0x00000000000000FFul;
-#endif
-}
diff --git a/tools/perf/util/include/asm/hweight.h b/tools/perf/util/include/asm/hweight.h
deleted file mode 100644
index 36cf26d..0000000
--- a/tools/perf/util/include/asm/hweight.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef PERF_HWEIGHT_H
-#define PERF_HWEIGHT_H
-
-#include <linux/types.h>
-unsigned int hweight32(unsigned int w);
-unsigned long hweight64(__u64 w);
-
-#endif /* PERF_HWEIGHT_H */
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
deleted file mode 100644
index eda4416..0000000
--- a/tools/perf/util/include/linux/bitmap.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef _PERF_BITOPS_H
-#define _PERF_BITOPS_H
-
-#include <string.h>
-#include <linux/bitops.h>
-
-int __bitmap_weight(const unsigned long *bitmap, int bits);
-
-#define BITMAP_LAST_WORD_MASK(nbits)					\
-(									\
-	((nbits) % BITS_PER_LONG) ?					\
-		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
-)
-
-#define small_const_nbits(nbits) \
-	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
-
-static inline void bitmap_zero(unsigned long *dst, int nbits)
-{
-	if (small_const_nbits(nbits))
-		*dst = 0UL;
-	else {
-		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
-		memset(dst, 0, len);
-	}
-}
-
-static inline int bitmap_weight(const unsigned long *src, int nbits)
-{
-	if (small_const_nbits(nbits))
-		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
-	return __bitmap_weight(src, nbits);
-}
-
-#endif /* _PERF_BITOPS_H */
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
deleted file mode 100644
index bb4ac2e..0000000
--- a/tools/perf/util/include/linux/bitops.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef _PERF_LINUX_BITOPS_H_
-#define _PERF_LINUX_BITOPS_H_
-
-#include <linux/kernel.h>
-#include <asm/hweight.h>
-
-#define BITS_PER_LONG __WORDSIZE
-#define BITS_PER_BYTE           8
-#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-
-static inline void set_bit(int nr, unsigned long *addr)
-{
-	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
-}
-
-static __always_inline int test_bit(unsigned int nr, const unsigned long *addr)
-{
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
-}
-
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
-
-#endif
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
deleted file mode 100644
index 1eb804f..0000000
--- a/tools/perf/util/include/linux/kernel.h
+++ /dev/null
@@ -1,111 +0,0 @@
-#ifndef PERF_LINUX_KERNEL_H_
-#define PERF_LINUX_KERNEL_H_
-
-#include <stdarg.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <assert.h>
-
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
-
-#ifndef offsetof
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
-
-#ifndef container_of
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof(((type *)0)->member) * __mptr = (ptr);	\
-	(type *)((char *)__mptr - offsetof(type, member)); })
-#endif
-
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-
-#ifndef max
-#define max(x, y) ({				\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
-#endif
-
-#ifndef min
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-#endif
-
-#ifndef BUG_ON
-#define BUG_ON(cond) assert(!(cond))
-#endif
-
-/*
- * Both need more care to handle endianness
- * (Don't use bitmap_copy_le() for now)
- */
-#define cpu_to_le64(x)	(x)
-#define cpu_to_le32(x)	(x)
-
-static inline int
-vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
-{
-	int i;
-	ssize_t ssize = size;
-
-	i = vsnprintf(buf, size, fmt, args);
-
-	return (i >= ssize) ? (ssize - 1) : i;
-}
-
-static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
-{
-	va_list args;
-	ssize_t ssize = size;
-	int i;
-
-	va_start(args, fmt);
-	i = vsnprintf(buf, size, fmt, args);
-	va_end(args);
-
-	return (i >= ssize) ? (ssize - 1) : i;
-}
-
-static inline unsigned long
-simple_strtoul(const char *nptr, char **endptr, int base)
-{
-	return strtoul(nptr, endptr, base);
-}
-
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
-
-#ifndef pr_fmt
-#define pr_fmt(fmt) fmt
-#endif
-
-#define pr_err(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug(fmt, ...) \
-	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debugN(n, fmt, ...) \
-	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
-
-#endif
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 4219466..a00d888 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -3,10 +3,12 @@
 
 #include <linux/compiler.h>
 #include <linux/list.h>
-#include <lk/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
+#include <sys/types.h>
 #include <lk/types.h>
+#include <lk/rbtree.h>
+#include <lk/kernel.h>
 
 enum map_type {
 	MAP__FUNCTION = 0,
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index c7d72dc..dbcdf33 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_PARSE_OPTIONS_H
 #define __PERF_PARSE_OPTIONS_H
 
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 #include <stdbool.h>
 
 enum parse_opt_type {
diff --git a/tools/perf/util/pstack.c b/tools/perf/util/pstack.c
index aacedb8..12f5221 100644
--- a/tools/perf/util/pstack.c
+++ b/tools/perf/util/pstack.c
@@ -6,7 +6,7 @@
 
 #include <lk/util.h>
 #include "pstack.h"
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 #include <stdlib.h>
 
 struct pstack {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 73cac6a..ddeef41 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,6 +1,6 @@
 #define _FILE_OFFSET_BITS 64
 
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 
 #include <byteswap.h>
 #include <unistd.h>
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 649eae3..964da20 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_STRLIST_H
 #define __PERF_STRLIST_H
 
+#include <lk/kernel.h>
 #include <lk/rbtree.h>
 #include <stdbool.h>
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 44831be..fadc2c0 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -34,7 +34,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
-#include <linux/kernel.h>
+#include <lk/kernel.h>
 
 #include <lk/debugfs.h>
 
-- 
1.7.3.1

