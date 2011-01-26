Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1AZHN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:13:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:32899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZHN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:13:28 -0500
Date: Wed, 26 Jan 2011 07:12:55 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110121203642.725191236@efficios.com>
References: <20110121203642.725191236@efficios.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
Message-ID: <tip-3b2c9e246ff913c74d0a11768435845e6106e966@git.kernel.org>
Git-Commit-ID: 3b2c9e246ff913c74d0a11768435845e6106e966
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:12:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b2c9e246ff913c74d0a11768435845e6106e966
Gitweb:     http://git.kernel.org/tip/3b2c9e246ff913c74d0a11768435845e6106e966
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Fri, 21 Jan 2011 15:36:31 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 21 Jan 2011 22:02:52 -0500

Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections

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
