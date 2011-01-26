Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1AZEKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:10:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1AZEKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:10:17 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=-_m9h8qEwWMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=J1Y8HTJGAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=ao5gq6kFr-_jeupmMxUA:9 a=tUFag2iwX4LFik-bP2EA:7 a=d3WxkLYRgbl3eEygJoK5cJkNBEcA:4 a=D6-X0JM3zdQA:10 a=4N9Db7Z2_RYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110126041014.361098357@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 Jan 2011 23:05:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/3] Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
References: <20110126040459.289776311@goodmis.org>
Content-Disposition: inline; filename=0001-Introduce-__u64_aligned-and-U64_ALIGN-for-structure-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Problem description:

gcc happily align on 32-byte structures defined statically. Ftrace trace events
and Tracepoints both statically define structures into custom sections (using
the "section" attribute), to then assign these to symbols with the linker
scripts to iterate these sections as an array.

However, gcc uses different alignments for these structures when they are
defined statically than when they are globally visible and/or in an array.
Therefore iteration on these arrays sees "holes" of padding. gcc is within its
rights to increase the alignment of the statically defined structures because,
normally, there should be no other accesses to them than in the local object. We
are actually iterating on the generated structures as if they were an array
without letting gcc know anything about it.

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
LKML-Reference: <20110121203642.725191236@efficios.com>
Acked-by: David Miller <davem@davemloft.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    6 ++++
 include/linux/align-section.h     |   54 +++++++++++++++++++++++++++++++++++++
 include/linux/compiler.h          |    2 +
 3 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/align-section.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6864933..bdc1688 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -70,6 +70,12 @@
 #define STRUCT_ALIGNMENT 32
 #define STRUCT_ALIGN() . = ALIGN(STRUCT_ALIGNMENT)
 
+/*
+ * Align to a 8 byte boundary. For use with custom section made from structures
+ * declared and defined with __u64_aligned.
+ */
+#define U64_ALIGN() . = ALIGN(8)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
diff --git a/include/linux/align-section.h b/include/linux/align-section.h
new file mode 100644
index 0000000..6822a4a
--- /dev/null
+++ b/include/linux/align-section.h
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
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..5036024 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -57,6 +57,8 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # include <linux/compiler-intel.h>
 #endif
 
+#include <linux/align-section.h>
+
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
-- 
1.7.2.3


