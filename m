Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1B1KX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:23:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1B1KXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mydXlYgpmDmsPDkmE/WNalPEAetuJaQLQgxpIL9nOXOcGOdONQppK8am6PwNKou9pC
         N1iVDuq+NP9yEC85t10lqouk1riyAw6G3udD/f1pPlYXtTBQo4u7DTbw8pOF2HDdY491
         bpvyPg0pmm3Am0InIRR/DfZuO44my00U1odEo=
Date: Mon, 28 Feb 2011 11:23:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] percpu, x86: Add arch-specific this_cpu_cmpxchg_double()
 support
Message-ID: <20110228102320.GA10156@htj.dyndns.org>
References: <20110225173850.486326452@linux.com>
 <20110225174156.967578131@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225174156.967578131@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9ec40af0e18fb7d02106be148036c2ea490fdf9 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux.com>
Date: Mon, 28 Feb 2011 11:02:24 +0100

Support this_cpu_cmpxchg_double() using the cmpxchg16b and cmpxchg8b
instructions.

-tj: s/percpu_cmpxchg16b/percpu_cmpxchg16b_double/ for consistency and
     other cosmetic changes.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to percpu:for-2.6.39 and pushed out to :for-next.  Thank you.

 arch/x86/include/asm/percpu.h |   48 +++++++++++++++++++++++++++++++++
 arch/x86/lib/Makefile         |    1 +
 arch/x86/lib/cmpxchg16b_emu.S |   59 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/lib/cmpxchg16b_emu.S

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3788f46..260ac7a 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -451,6 +451,26 @@ do {									\
 #define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #endif /* !CONFIG_M386 */
 
+#ifdef CONFIG_X86_CMPXCHG64
+#define percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	typeof(o2) __dummy = n2;					\
+	asm volatile("cmpxchg8b "__percpu_arg(1)"\n\tsetz %0\n\t"	\
+		    : "=a"(__ret), "=m" (pcp1), "=d"(__dummy)		\
+		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+#define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
+#endif /* CONFIG_X86_CMPXCHG64 */
+
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -480,6 +500,34 @@ do {									\
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+/*
+ * Pretty complex macro to generate cmpxchg16 instruction.  The instruction
+ * is not supported on early AMD64 processors so we must be able to emulate
+ * it in software.  The address used in the cmpxchg16 instruction must be
+ * aligned to a 16 byte boundary.
+ */
+#define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	typeof(o2) __dummy;						\
+	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
+		       "cmpxchg16b %%gs:(%%rsi)\n\tsetz %0\n\t",	\
+		       X86_FEATURE_CX16,				\
+		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
+		       "S" (&pcp1), "b"(__n1), "c"(__n2),		\
+		       "a"(__o1), "d"(__o2));				\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
+#define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index e10cf07..f2479f1 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -42,4 +42,5 @@ else
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
+	lib-y += cmpxchg16b_emu.o
 endif
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
new file mode 100644
index 0000000..3e8b08a
--- /dev/null
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -0,0 +1,59 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ */
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+.text
+
+/*
+ * Inputs:
+ * %rsi : memory location to compare
+ * %rax : low 64 bits of old value
+ * %rdx : high 64 bits of old value
+ * %rbx : low 64 bits of new value
+ * %rcx : high 64 bits of new value
+ * %al  : Operation successful
+ */
+ENTRY(this_cpu_cmpxchg16b_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
+# via the ZF.  Caller will access %al to get result.
+#
+# Note that this is only useful for a cpuops operation.  Meaning that we
+# do *not* have a fully atomic operation but just an operation that is
+# *atomic* on a single cpu (as provided by the this_cpu_xx class of
+# macros).
+#
+this_cpu_cmpxchg16b_emu:
+	pushf
+	cli
+
+	cmpq %gs:(%rsi), %rax
+	jne not_same
+	cmpq %gs:8(%rsi), %rdx
+	jne not_same
+
+	movq %rbx, %gs:(%rsi)
+	movq %rcx, %gs:8(%rsi)
+
+	popf
+	mov $1, %al
+	ret
+
+ not_same:
+	popf
+	xor %al,%al
+	ret
+
+CFI_ENDPROC
+
+ENDPROC(this_cpu_cmpxchg16b_emu)
-- 
1.7.1

