Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab0LNRtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:49:06 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:34953 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752332Ab0LNRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:49:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UoPLcxQVM1lJFk6acVoakvzSIeKYUjA4YW1m3BnwdgDzW3n
 XC.UbGKMq2sx3ZlFbfZHbq0mie6T2owCmuiHLl9wnW2azWEu6RzmqBiplv2D
 kj0RVdjM3g_M9_DiSGjKjZeYx3qtdRT.DXW0OzcmClY18OVEbreOz_NUQSg7
 .Uec5Y3FUWoQbFDxAEY97mmNE807d9g4uCe5GM5Eh0DbzaGDAJeL8v9ssHlZ
 Q7BkFctN8CrND7M72npahwFiC59__OuPPw2RED0cGu5sfPAEe3nSENjjhmXy
 t.m_os8LkW49qf19NBlqYAvBGhFpVgXFUPqc6LeR3JWP2d5E-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214174900.659284593@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 11:48:49 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double() support
References: <20101214174847.887713690@linux.com>
Content-Disposition: inline; filename=cpuops_double_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support this_cpu_cmpxchg_double using the cmpxchg16b and cmpxchg8b instructions.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   47 ++++++++++++++++++++++++++++++++++
 arch/x86/lib/Makefile         |    1 
 arch/x86/lib/cmpxchg16b_emu.S |   58 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-14 10:31:33.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-14 10:39:04.000000000 -0600
@@ -451,6 +451,26 @@ do {									\
 #define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #endif /* !CONFIG_M386 */
 
+#ifdef CONFIG_X86_CMPXCHG64
+#define percpu_cmpxchg8b_double(pcp, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	typeof(o2) __dummy = n2;						\
+	asm("cmpxchg8b "__percpu_arg(1)"\n\tsetz %0\n\t"		\
+		    : "=a"(__ret), "=m" (*pcp), "=d"(__dummy)		\
+		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2) percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define irqsafe_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#endif /* CONFIG_X86_CMPXCHG64 */
+
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -486,6 +506,33 @@ do {									\
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
+/*
+ * Pretty complex macro to generate cmpxchg16 instruction. The instruction
+ * is not supported on early AMD64 processors so we must be able to emulate
+ * it in software. The address used in the cmpxchg16 instruction must be
+ * aligned to a 16 byte boundary.
+ */
+#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	typeof(o2) __dummy;						\
+	alternative_io("call cmpxchg16b_cpuops_emu\n\t" P6_NOP4,		\
+			"cmpxchg16b %%gs:(%%rsi)\n\tsetz %0\n\t",	\
+			X86_FEATURE_CX16,				\
+		    	ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),	\
+		        "S" (pcp), "b"(__n1), "c"(__n2),		\
+			 "a"(__o1), "d"(__o2));				\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2) percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+#define irqsafe_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
Index: linux-2.6/arch/x86/lib/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/lib/Makefile	2010-12-10 12:16:27.000000000 -0600
+++ linux-2.6/arch/x86/lib/Makefile	2010-12-14 10:36:50.000000000 -0600
@@ -42,4 +42,5 @@ else
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
+	lib-y += cmpxchg16b_emu.o
 endif
Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2010-12-14 10:36:50.000000000 -0600
@@ -0,0 +1,58 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
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
+ENTRY(cmpxchg16b_cpuops_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
+# al not via the ZF. Caller will access al to get result.
+#
+cmpxchg16b_cpuops_emu:
+	pushf
+	cli
+
+	cmpq  %gs:(%rsi), %rax
+	jne not_same
+	cmpq %gs:8(%rsi), %rdx
+	jne not_same
+
+	movq %rbx,  %gs:(%rsi)
+	movq %rcx, %gs:8(%rsi)
+
+	popf
+	mov $1, %al
+	ret
+
+ not_same:
+	popf
+	xor  %al,%al
+	ret
+
+CFI_ENDPROC
+
+ENDPROC(cmpxchg16b_cpuops)
+
+

