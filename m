Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0KWXwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:36 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:43701 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754586Ab0KWXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YRFgxpgVM1m5_I1jzMHJqGIIz.fRsdctRUz_ygvE71g8IL2
 Vrlvxk8bQJA433b9nxOWX_.P.05L.h_1h4tDgWkWwNfO9bOq.HxsVUvR220K
 6wYAReWdGoKy.k1OtPaWNc0wOSJg4uGSXtCDxZx07fEeXluV4CX91k7U6CfN
 XtG0DMWdwie97oW0xdeiMUd3p0pIlf3yxv7bXFT.46glgKZo.2AzOJF7efAB
 3qUb0sKuk7sKwq972KLLdbYtR_51AdQc8NANtwTY3l72J2fVJPVuq_3Ut1kb
 7_LysmGnVyokRl4R_x18e
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235201.146063796@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:48 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 09/10] x86: this_cpu_cmpxchg and this_cpu_cmpxchg_double operations
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=this_cpu_cmpxchg_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support as far as the hardware capabilities of the x86 cpus
allow.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |  100 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-23 16:50:58.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-23 16:56:48.000000000 -0600
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
@@ -346,7 +381,52 @@ do {									\
 #define this_cpu_add_return_1(pcp, val)		percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_2(pcp, val)		percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_4(pcp, val)		percpu_add_return_op((pcp), val)
+
+#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+
+#define percpu_cmpxchg8b_double(pcp, o1, o2, n1, n2)			\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	asm("cmpxchg8b "__percpu_arg(1)"\n\tsetz %0\n\t"		\
+		    : "=a"(__ret), "=m" (*pcp)				\
+		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2) percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+#define irqsafe_cmpxchg_double_4(pcp, o1, o2, n1, n2)	percpu_cmpxchg8b_double((pcp), o1, o2, n1, n2)
+
+#ifndef CONFIG_X86_64
+
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
+#endif
 #endif
+
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -374,6 +454,26 @@ do {									\
 #define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
 
+#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op((pcp), oval, nval)
+
+#define percpu_cmpxchg16b(pcp, o1, o2, n1, n2)				\
+({									\
+	char __ret;							\
+	typeof(o1) __o1 = o1;						\
+	typeof(o1) __n1 = n1;						\
+	typeof(o2) __o2 = o2;						\
+	typeof(o2) __n2 = n2;						\
+	asm("cmpxchg16b "__percpu_arg(1)"\n\tsetz %0\n\t"		\
+		    : "=a"(__ret), "=m" (*pcp)				\
+		    :  "b"(__n1), "c"(__n2), "a"(__o1), "d"(__o2));	\
+	__ret;								\
+})
+
+#define __this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2) percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+#define this_cpu_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+#define irqsafe_cmpxchg_double_8(pcp, o1, o2, n1, n2)	percpu_cmpxchg16b((pcp), o1, o2, n1, n2)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */

