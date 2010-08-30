Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0H3MD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:03:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42670 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754097Ab0H3MD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:03:57 -0400
Date: Mon, 30 Aug 2010 08:03:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: ltt-dev@lists.casi.polymtl.ca, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
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
Subject: [GIT PULL for -tip] Create generic alignment API (v11)
Message-ID: <20100830120348.GA1687@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:59:29 up 219 days, 14:36,  4 users,  load average: 0.02, 0.05,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I'm resubmitting this for inclusion in -tip. You can pull it from

git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git
branch: tip-pull-queue

Thanks,

Mathieu


Rather than re-doing the "alignment on a type size" trick all over again at
different levels, import the "ltt_align" from LTTng into kernel.h and make this
available to everyone. Renaming to:

- object_align()
- object_align_floor()
- offset_align()
- offset_align_floor()

Changelog since v10:
- Remove stale comment.
- Fix parenthesis in the MAYBE_BUILD_BUG_ON test.

Changelog since v9:
- Hardcode MAYBE_BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0)) rather than
  creating a helper macro in kernel.h, by popular request.
- Remove unneeded log2.h include.
- Now that offset_align_floor and offset_align are macros (needed for
  MAYBE_BUILD_BUG_ON()), add the appropriate braces around parameters used.

Changelog since v8:
- Remove unnecessary braces.
- Update object_align/object_align_floor comments.

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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
CC: Imre Deak <imre.deak@nokia.com>
CC: Jamie Lokier <jamie@shareable.org>
CC: mingo@elte.hu
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/Kbuild   |    1 
 include/linux/align.h  |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |    9 +------
 3 files changed, 63 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/align.h

Index: linux.trees.git/include/linux/align.h
===================================================================
--- /dev/null
+++ linux.trees.git/include/linux/align.h
@@ -0,0 +1,60 @@
+#ifndef _LINUX_ALIGN_H
+#define _LINUX_ALIGN_H
+
+#define __ALIGN_KERNEL(x, a)	__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask) \
+				(((x) + (mask)) & ~(mask))
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+
+#define ALIGN(x, a)		__ALIGN_KERNEL(x, a)
+#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK(x, mask)
+#define PTR_ALIGN(p, a)		((typeof(p)) ALIGN((unsigned long) (p), a))
+#define ALIGN_FLOOR(x, a)	__ALIGN_FLOOR_MASK(x, (typeof(x)) (a) - 1)
+#define __ALIGN_FLOOR_MASK(x, mask)	((x) & ~(mask))
+#define PTR_ALIGN_FLOOR(p, a) \
+			((typeof(p)) ALIGN_FLOOR((unsigned long) (p), a))
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x)) (a) - 1)) == 0)
+
+/*
+ * Align pointer on natural object alignment.
+ */
+#define object_align(obj)	PTR_ALIGN(obj, __alignof__(*(obj)))
+#define object_align_floor(obj)	PTR_ALIGN_FLOOR(obj, __alignof__(*(obj)))
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
+#define offset_align(align_drift, alignment)				       \
+	({								       \
+		MAYBE_BUILD_BUG_ON((alignment) == 0			       \
+				   || ((alignment) & ((alignment) - 1)));      \
+		(((alignment) - (align_drift)) & ((alignment) - 1));	       \
+	})
+
+/**
+ * offset_align_floor - Calculate the offset needed to align an object
+ *                      on its natural alignment towards lower addresses.
+ * @align_drift:  object offset from an "alignment"-aligned address.
+ * @alignment:    natural object alignment. Must be non-zero, power of 2.
+ *
+ * Returns the offset that must be substracted to align towards lower addresses.
+ */
+#define offset_align_floor(align_drift, alignment)			       \
+	({								       \
+		MAYBE_BUILD_BUG_ON((alignment) == 0			       \
+				   || ((alignment) & ((alignment) - 1)));      \
+		(((align_drift) - (alignment)) & ((alignment) - 1);	       \
+	})
+
+#endif /* __KERNEL__ */
+
+#endif
Index: linux.trees.git/include/linux/kernel.h
===================================================================
--- linux.trees.git.orig/include/linux/kernel.h
+++ linux.trees.git/include/linux/kernel.h
@@ -4,8 +4,8 @@
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#include <linux/align.h>
 
 #ifdef __KERNEL__
 
@@ -39,11 +39,6 @@ extern const char linux_proc_banner[];
 
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
--- linux.trees.git.orig/include/linux/Kbuild
+++ linux.trees.git/include/linux/Kbuild
@@ -38,6 +38,7 @@ header-y += adfs_fs.h
 header-y += affs_hardblocks.h
 header-y += agpgart.h
 header-y += aio_abi.h
+header-y += align.h
 header-y += apm_bios.h
 header-y += arcfb.h
 header-y += atalk.h
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
