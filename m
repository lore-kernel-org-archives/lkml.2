Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0LHR41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:56:27 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:40493 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755125Ab0LHRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:55:46 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gfyg7_IVM1lgK82NiWcHKJ.dG8OQI5Kl6qLLpLULxpuGXFu
 vWWxRgv7eEXsUW0cCWp80DfH1Z92GOKH6TfCRWKFzgNR26D6oR4ITaaHVmEH
 q2YKH4KltCEerkkbzi1qJXRD4gkazlomEJ4Y9BuEdSO9Qbq7TXANWYUH8pg.
 kxX42u0U.dCnOB0bV4ElEcYfZFwqOQnGDCtv8uvIQP3Zwfdb4dQ1H5ho6Tc3
 4_cpxg_GdiLF88m5sd_kWTkke3NXCeF.FJci4PsTT3WZmf.mqsAn_BEISlEB
 Ux6QbGD_TjT2TVP8ziUyr
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101208175543.000201149@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Dec 2010 11:55:22 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and this_cpu_xchg operations
References: <20101208175520.456864019@linux.com>
Content-Disposition: inline; filename=cpuops_cmpxchg_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support as far as the hardware capabilities of the x86 cpus
allow.

Define CONFIG_CMPXCHG_LOCAL in Kconfig.cpu to allow core code to test for
fast cpuops implementations.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/Kconfig.cpu          |    3 
 arch/x86/include/asm/percpu.h |  129 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 131 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-08 11:33:48.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-08 11:34:44.000000000 -0600
@@ -212,6 +212,83 @@ do {									\
 	ret__;								\
 })
 
+/*
+ * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
+ * full lock semantics even though they are not needed.
+ */
+#define percpu_xchg_op(var, nval)					\
+({									\
+	typeof(var) __ret;						\
+	typeof(var) __new = (nval);					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xchgb %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "q" (__new)				\
+			    : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xchgw %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "r" (__new)				\
+			    : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xchgl %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "r" (__new)				\
+			    : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xchgq %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "r" (__new)				\
+			    : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	__ret;								\
+})
+
+/*
+ * cmpxchg has no such implied lock semantics as a result it is much
+ * more efficient for cpu local operations.
+ */
+#define percpu_cmpxchg_op(var, oval, nval)				\
+({									\
+	typeof(var) __ret;						\
+	typeof(var) __old = (oval);					\
+	typeof(var) __new = (nval);					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("cmpxchgb %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "q" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 2:								\
+		asm("cmpxchgw %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "r" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 4:								\
+		asm("cmpxchgl %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
+			    : "r" (__new), "0" (__old)			\
+			    : "memory");				\
+		break;							\
+	case 8:								\
+		asm("cmpxchgq %2, "__percpu_arg(1)			\
+			    : "=a" (__ret), "+m" (var)			\
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
@@ -335,6 +412,16 @@ do {									\
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#define __this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define __this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define __this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
+
 #ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
@@ -342,7 +429,39 @@ do {									\
 #define this_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
-#endif
+
+#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#endif /* !CONFIG_M386 */
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
@@ -370,6 +489,14 @@ do {									\
 #define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 
+#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu	2010-12-08 11:33:48.000000000 -0600
+++ linux-2.6/arch/x86/Kconfig.cpu	2010-12-08 11:33:53.000000000 -0600
@@ -310,6 +310,9 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
 
+config CMPXCHG_LOCAL
+	def_bool X86_64 || (X86_32 && !M386)
+
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC

