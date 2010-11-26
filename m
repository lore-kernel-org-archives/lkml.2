Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0KZVLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:11:12 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:39695 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752072Ab0KZVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hIuGjAUVM1kQ8u6bGDuWZ6e0c1qhRVOt0ICrbKJ9ADok2Rc
 N3fL.uEZhew.UQrfjIq5uOS.GQfh5sCQMqrgD5d.CG8VQRh1Kbs9FMszYmCR
 yIJ4VHDVbxDu_naFAM.8oIq_ZaBWu7zsjejhPzmNMUJo_a5J4lWdi6lh5NG1
 rR820ednJgW40oc4ODDFtfnRB3T8ftNr.gUk2pzWr7GVkW0gXwJdyoH6pWC6
 Ts1rKZv88UeA08ur0ok0_AZs1vIHxI7qaixVZssCEq3E0RZe_esqUt1eV5EY
 Jlr.baVZ6oZBLBBmN_oOa
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210954.166783984@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:46 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 09/10] x86: this_cpu_cmpxchg and this_cpu_cmpxchg_double operations
References: <20101126210937.383047168@linux.com>
Content-Disposition: inline; filename=this_cpu_cmpxchg_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support as far as the hardware capabilities of the x86 cpus
allow.

V1->V2:
	- Mark %rdx clobbering during cmpxchg16b
	- Provide emulation of cmpxchg16b for early AMD processors

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |  122 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/lib/Makefile         |    1 
 arch/x86/lib/cmpxchg16b_emu.S |   55 ++++++++++++++++++
 3 files changed, 177 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-26 12:37:37.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-26 14:42:49.000000000 -0600
@@ -216,6 +216,41 @@ do {									\
 	pfo_ret__ + (val);						\
 })
 
+#define percpu_cmpxchg_op(var, oval, nval)				\
+({									\
+	typeof(var) __ret;						\
+	typeof(var) __old = (oval);					\
+	typeof(var) __new = (nval);					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("cmpxchgb %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (&var)			\
+			    : "q" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 2:								\
+		asm("cmpxchgw %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (&var)			\
+			    : "r" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 4:								\
+		asm("cmpxchgl %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (&var)			\
+			    : "r" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 8:								\
+		asm("cmpxchgq %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (&var)			\
+			    : "r" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	__ret;								\
+})
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -346,7 +381,56 @@ do {									\
 #define this_cpu_add_return_1(pcp, val)		percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_2(pcp, val)		percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_4(pcp, val)		percpu_add_return_op((pcp), val)
-#endif
+
+#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#endif /* !CONFIG_M386 */
+
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
+#endif /* CONFIG_X86_CMPXCHG64 */
+
+#define __this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2) percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define irqsafe_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+
+#ifndef CONFIG_X86_64
+#ifdef CONFIG_X86_CMPXCHG64
+/* We can support a 8 byte cmpxchg with a special instruction on 32 bit */
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)				\
+({									\
+	typeof(var) __ret;						\
+	typeof(var) __old = (oval);					\
+	typeof(var) __new = (nval);					\
+	asm("cmpxchg8b %2, "__percpu_arg(1)				\
+	    : "=A" (__ret), "+m" (&pcp)					\
+	    : "b" (((u32)new), "c" ((u32)(new >> 32)),  "0" (__old)	\
+	    : "memory");						\
+	__ret;								\
+})
+
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_cmpxchg_8(pcp, oval, nval)
+#define irqsafe_cmpxchg_8(pcp, oval, nval)	__this_cpu_cmpxchg_8(pcp, oval, nval)
+
+#endif /* CONFIG_X86_CMPXCHG64 */
+#endif /* !CONFIG_X86_64 */
+
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -374,6 +458,42 @@ do {									\
 #define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
 
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+
+/*
+ * Pretty complex macro to generate cmpxchg16 instruction. The instruction
+ * is not supported on early AMD64 processors so we must be able to emulate
+ * it in software. The address used in the cmpxchg16 instruction must be
+ * aligned to a 16 byte boundary.
+ */
+
+/*
+ * Something is screwed up with alternate instruction creation. This one
+ * fails with a mysterious asm error about a byte val > 255.
+ */
+#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	typeof(o2) __dummy;						\
+	VM_BUG_ON(((unsigned long)pcp) % 16);				\
+	alternative_io("call cmpxchg16b_local\n\t" P6_NOP4,		\
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
+#define irqsafe_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
Index: linux-2.6/arch/x86/lib/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/lib/Makefile	2010-11-26 12:08:33.000000000 -0600
+++ linux-2.6/arch/x86/lib/Makefile	2010-11-26 12:50:50.000000000 -0600
@@ -42,4 +42,5 @@ else
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
+	lib-y += cmpxchg16b_emu.o
 endif
Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2010-11-26 13:14:02.000000000 -0600
@@ -0,0 +1,55 @@
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
+ENTRY(cmpxchg16b_local_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
+# al not via the ZF. Caller will access al to get result.
+#
+cmpxchg16b_local_emu:
+	pushf
+	cli
+
+	cmpq  %gs:(%rsi), %rax
+	jne not_same
+	cmpq %gs:8(%rsi), %rdx
+	jne not_same
+
+	movq %rbx,  %gs:(%esi)
+	movq %rcx, %gs:8(%esi)
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
+ENDPROC(cmpxchg16b_local_emu)

