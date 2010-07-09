Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0GIXoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:44:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0GIXoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:44:03 -0400
Message-Id: <20100709225814.855827624@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Shishkin <virtuoso@slind.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
       Jamie Lokier <jamie@shareable.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 01/20] Create generic alignment API (v8)
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=create-generic-alignment-api.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than re-doing the "alignment on a type size" trick all over again at
different levels, import the "ltt_align" from LTTng into kernel.h and make this
available to everyone. Renaming to:

- object_align()
- object_align_floor()
- offset_align()
- offset_align_floor()

Changelog since v7:
- Add missing include/linux/Kconfig header-y.

Changelog since v6:
- Adapt to changes introduced by
  commit a79ff731a1b277d0e92d9453bdf374e04cec717a
- Use __alignof__() instead of sizeof() to support compound types.

Changelog since v5:
- moved alignment apis to a separate header file so that it is possible
  to use them from other header files which are, for example, included
  from kernel.h.

Changelog since v4:
- add missing ( ) around parameters within object_align() and
  object_align_floor().
- More coding style cleanups to ALIGN() (checkpatch.pl is happy now).

Changelog since v3:
- optimize object_align*() so fewer instructions are needed for alignment of
  addresses known dynamically. Use the (already existing) "ALIGN()", and create
  the "ALIGN_FLOOR()" macro.
- While we are there, let's clean up the ALIGN() macros wrt coding style. e.g.
  missing parenthesis around the first use of the "x" parameter in ALIGN().

Changelog since v2:
- Fix object_align*(): should use object size alignment, not pointer alignment.

Changelog since v1:
- Align on the object natural alignment
    (rather than min(arch word alignment, natural alignment))

The advantage of separating the API in "object alignment" and "offset alignment"
is that it gives more freedom to play with offset alignment. Very useful to
implement a tracer ring-buffer alignment. (hint hint)

Typical users will use "object alignment", but infrastructures like tracers
which need to perform alignment of statically known base+offsets will typically
use "offset alignment", because it allows to align with respect to a base rather
than to pass an absolute address.

We use "sizeof(object)" rather than "__alignof__()" object because alignof
returns "recommended" object alignment for the architecture, which can be
sub-optimal on some architectures. By ensuring alignment on the object size, we
are sure to make the right choice.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
CC: Imre Deak <imre.deak@nokia.com>
CC: Jamie Lokier <jamie@shareable.org>
CC: rostedt@goodmis.org
CC: mingo@elte.hu
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/Kbuild   |    1 
 include/linux/align.h  |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |    8 -------
 3 files changed, 58 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/align.h

Index: linux.trees.git/include/linux/align.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/align.h	2010-07-01 11:54:43.000000000 -0400
@@ -0,0 +1,56 @@
+#ifndef _LINUX_ALIGN_H
+#define _LINUX_ALIGN_H
+
+#define __ALIGN_KERNEL(x, a)	__ALIGN_KERNEL_MASK((x), (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask) \
+				(((x) + (mask)) & ~(mask))
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
+#define PTR_ALIGN(p, a)		((typeof(p)) ALIGN((unsigned long) (p), (a)))
+#define ALIGN_FLOOR(x, a)	__ALIGN_FLOOR_MASK((x), (typeof(x)) (a) - 1)
+#define __ALIGN_FLOOR_MASK(x, mask)	((x) & ~(mask))
+#define PTR_ALIGN_FLOOR(p, a) \
+			((typeof(p)) ALIGN_FLOOR((unsigned long) (p), (a)))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x)) (a) - 1)) == 0)
+
+/*
+ * Align pointer on natural object alignment. Object size must be power of two.
+ */
+#define object_align(obj)	PTR_ALIGN((obj), __alignof__(*(obj)))
+#define object_align_floor(obj)	PTR_ALIGN_FLOOR((obj), __alignof__(*(obj)))
+
+/**
+ * offset_align - Calculate the offset needed to align an object on its natural
+ *                alignment towards higher addresses.
+ * @align_drift:  object offset from an "alignment"-aligned address.
+ * @alignment:    natural object alignment. Must be non-zero, power of 2.
+ *
+ * Returns the offset that must be added to align towards higher
+ * addresses.
+ */
+static inline size_t offset_align(size_t align_drift, size_t alignment)
+{
+	return (alignment - align_drift) & (alignment - 1);
+}
+
+/**
+ * offset_align_floor - Calculate the offset needed to align an object
+ *                      on its natural alignment towards lower addresses.
+ * @align_drift:  object offset from an "alignment"-aligned address.
+ * @alignment:    natural object alignment. Must be non-zero, power of 2.
+ *
+ * Returns the offset that must be substracted to align towards lower addresses.
+ */
+static inline size_t offset_align_floor(size_t align_drift, size_t alignment)
+{
+	return (align_drift - alignment) & (alignment - 1);
+}
+
+#endif /* __KERNEL__ */
+
+#endif
Index: linux.trees.git/include/linux/kernel.h
===================================================================
--- linux.trees.git.orig/include/linux/kernel.h	2010-07-01 11:54:43.000000000 -0400
+++ linux.trees.git/include/linux/kernel.h	2010-07-01 12:29:05.000000000 -0400
@@ -4,8 +4,7 @@
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#include <linux/align.h>
 
 #ifdef __KERNEL__
 
@@ -39,11 +38,6 @@ extern const char linux_proc_banner[];
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
-#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
-#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
-
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 /*
Index: linux.trees.git/include/linux/Kbuild
===================================================================
--- linux.trees.git.orig/include/linux/Kbuild	2010-07-01 12:29:13.000000000 -0400
+++ linux.trees.git/include/linux/Kbuild	2010-07-01 12:29:40.000000000 -0400
@@ -18,6 +18,7 @@ header-y += usb/
 
 header-y += affs_hardblocks.h
 header-y += aio_abi.h
+header-y += align.h
 header-y += arcfb.h
 header-y += atmapi.h
 header-y += atmarp.h

