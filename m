Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1AUUhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:37:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44406 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1AUUhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:37:08 -0500
Message-Id: <20110121203642.725191236@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 15:36:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Richard Mortimer <richm@oldelvet.org.uk>, ben@decadent.org.uk,
        sparclinux@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 1/3] introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections (v3)
References: <20110121203630.725922272@efficios.com>
Content-Disposition: inline; filename=introduce-u64-aligned.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Fri, 21 Jan 2011 20:36:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem description:

gcc happily align on 32-byte structures defined statically. Ftrace trace events
and Tracepoints both statically define structures into custom sections (using
the "section" attribute), to then assign these to symbols with the linker
scripts to iterate the these sections as an array.

However, gcc uses different alignments for these structures when they are
defined statically than when they are globally visible and/or in an array.
Therefore iteration on these arrays sees "holes" of padding. gcc is within its
rights to increase the alignment of the statically defined structures because,
normally, there should be no other accesses to them than in the local object. We
are actually iterating on the generated structures as if they were an array
without letting gcc knowing anything about it.

This patch introduces __u64_aligned to force gcc to use the u64 type and
variable alignment, up-aligning or down-aligning the target type if necessary.
The memory accesses to the target structure are efficient (does not require
bytewise memory accesses) and the atomic pointer update guarantees required by
RCU are kept. u64 is considered as the largest type that can generate a trap for
unaligned accesses (u64 on sparc32 needs to be aligned on 64-bit).

This alignment should be used for both structure definitions and declarations
(as *both* the type and variable attribute) when using the "section"
attribute to generate arrays of structures. Given that gcc only uses the type
attribute "aligned" as a lower-bound for alignment, the structures should not
contain types which require alignment larger than that of u64. The "aligned"
variable attribute, on the other hand, forces gcc to use exactly the specified
alignment.

Also introduce the linker script U64_ALIGN() macro for specification of custom
section alignment that matches that of __u64_aligned.

Changelog since v2:
- Drop the "packed" type attribute, because it causes gcc to drop the padding
  between consecutive "int" and "pointer"/"long" fields, which leads to
  unaligned accesses on sparc64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Miller <davem@davemloft.net>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/vmlinux.lds.h |    6 ++++
 include/linux/align-section.h     |   54 ++++++++++++++++++++++++++++++++++++++
 include/linux/compiler.h          |    2 +
 3 files changed, 62 insertions(+)

Index: linux-2.6-lttng/include/linux/compiler.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/compiler.h
+++ linux-2.6-lttng/include/linux/compiler.h
@@ -57,6 +57,8 @@ extern void __chk_io_ptr(const volatile
 # include <linux/compiler-intel.h>
 #endif
 
+#include <linux/align-section.h>
+
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
@@ -69,6 +69,12 @@
  */
 #define STRUCT_ALIGN() . = ALIGN(32)
 
+/*
+ * Align to a 8 byte boundary. For use with custom section made from structures
+ * declared and defined with __u64_aligned.
+ */
+#define U64_ALIGN() . = ALIGN(8)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
Index: linux-2.6-lttng/include/linux/align-section.h
===================================================================
--- /dev/null
+++ linux-2.6-lttng/include/linux/align-section.h
@@ -0,0 +1,54 @@
+#ifndef _LINUX_ALIGN_SECTION_H
+#define _LINUX_ALIGN_SECTION_H
+
+/*
+ * __u64_aligned:
+ *
+ * __u64_aligned should be used as type and variable attribute for structure
+ * definitions when using the "section" attribute to generate arrays of
+ * structures. U64_ALIGN() must be used prior to these section definitions in
+ * the linker script.
+ *
+ * It forces the compiler to use the u64 type alignment, up-aligning or
+ * down-aligning the target type if necessary. The memory accesses to the target
+ * structure are efficient (does not require bytewise memory accesses) and the
+ * atomic pointer update guarantees required by RCU are kept. u64 is considered
+ * as the largest type that can generate a trap for unaligned accesses (u64 on
+ * sparc32 needs to be aligned on 64-bit).
+ *
+ * Given that gcc only uses the type attribute "aligned" as a lower-bound for
+ * alignment, the structures should not contain types which require alignment
+ * larger than that of u64. The "aligned" variable attribute, on the other hand,
+ * forces gcc to use exactly the specified alignment.
+ */
+
+/*
+ * Use __u64_aligned as type and variable attribute for custom section structure
+ * declaration and definition.  It should also be applied to any static or
+ * extern definition of the structure that would override the definition to
+ * which the "section" attribute is applied, e.g.
+ *
+ * struct custom {
+ *         unsigned long field;
+ *         ...
+ * } __u64_aligned;
+ *
+ * extern struct __u64_aligned custom;
+ * struct custom  __u64_aligned __attribute__((section("__custom")) identifier;
+ *
+ * The array can then be defined with:
+ *
+ * extern struct custom __start___custom[];
+ * extern struct custom __stop___custom[];
+ *
+ * With linking performed by the linker script:
+ *
+ * U64_ALIGN();
+ * VMLINUX_SYMBOL(__start___custom) = .;
+ * *(__custom)
+ * VMLINUX_SYMBOL(__stop___custom) = .;
+ */
+
+#define __u64_aligned	__attribute__((__aligned__(__alignof__(long long))))
+
+#endif /* _LINUX_ALIGN_SECTION_H */

