Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0LBVyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:10 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29786 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758030Ab0LBVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ZrclsiYVM1mOiFLp2bAaxGK9vPQVCe63ntOiE3V1AKzfrV4
 8kQ2bWEoFl37qmA6nEw64s7lmeFHY3VVWOfsDewun83XLTKbcNs2JXM4WUrX
 rSrcfRgFeFnvRoRiW1udRK_WKKeCv4J2Fdb_tFpkOR_sJuQ2kPp6CrBpci5A
 i2m9WMFegpkHzASZXMvjHTF_ijaNThZ5M.WGhbulzYHt3fs54hJM0l65HNYR
 bTSLYh3hcxtGqrt5edCKtAuMDEIIgSWp6tixEooTHBdcpZ..N2BDW
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215359.439960472@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:41 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 1/8] percpu: generic this_cpu_cmpxchg() and this_cpu_cmpxchg_double support
References: <20101202215340.562309713@linux.com>
Content-Disposition: inline; filename=this_cpu_cmpxchg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide arch code to create the (local atomic) instructions.

V2->V3:
	- Clean up some parameters
	- Provide implementation of irqsafe_cpu_cmpxchg

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  258 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 257 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-11-30 14:06:56.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-11-30 14:21:43.000000000 -0600
@@ -259,6 +259,22 @@ extern void __bad_size_call_parameter(vo
 	ret__;								\
 })
 
+/* Special handling for cmpxchg_double */
+#define __pcpu_size_call_return_int(stem, pcp, ...)			\
+({									\
+	int ret__;							\
+	__verify_pcpu_ptr(pcp);						\
+	switch(sizeof(*pcp)) {						\
+	case 1: ret__ = stem##1(pcp, __VA_ARGS__);break;		\
+	case 2: ret__ = stem##2(pcp, __VA_ARGS__);break;		\
+	case 4: ret__ = stem##4(pcp, __VA_ARGS__);break;		\
+	case 8: ret__ = stem##8(pcp, __VA_ARGS__);break;		\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	ret__;								\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -322,6 +338,185 @@ do {									\
 # define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
 #endif
 
+#define __this_cpu_generic_xchg(pcp, nval)				\
+({	typeof(pcp) ret__;						\
+	ret__ = __this_cpu_read(pcp);					\
+	__this_cpu_write(pcp, nval);					\
+	ret__;								\
+})
+
+#ifndef __this_cpu_xchg
+# ifndef __this_cpu_xchg_1
+#  define __this_cpu_xchg_1(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef __this_cpu_xchg_2
+#  define __this_cpu_xchg_2(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef __this_cpu_xchg_4
+#  define __this_cpu_xchg_4(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef __this_cpu_xchg_8
+#  define __this_cpu_xchg_8(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# endif
+# define __this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+#endif
+
+#define _this_cpu_generic_xchg(pcp, nval)				\
+({	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	ret__ = __this_cpu_read(pcp);					\
+	__this_cpu_write(pcp, nval);					\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_xchg
+# ifndef this_cpu_xchg_1
+#  define this_cpu_xchg_1(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_2
+#  define this_cpu_xchg_2(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_4
+#  define this_cpu_xchg_4(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_8
+#  define this_cpu_xchg_8(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# define this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
+#endif
+
+#define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
+({	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	ret__ = __this_cpu_read(pcp);					\
+	if (ret__ == (oval))						\
+		__this_cpu_write(pcp, nval);				\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_cmpxchg
+# ifndef this_cpu_cmpxchg_1
+#  define this_cpu_cmpxchg_1(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_2
+#  define this_cpu_cmpxchg_2(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_4
+#  define this_cpu_cmpxchg_4(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_8
+#  define this_cpu_cmpxchg_8(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# define this_cpu_cmpxchg(pcp, oval, nval)	__pcpu_size_call_return2(this_cpu_cmpxchg_, (pcp), oval, nval)
+#endif
+
+#define __this_cpu_generic_cmpxchg(pcp, oval, nval)			\
+({									\
+	typeof(pcp) ret__;						\
+	ret__ = __this_cpu_read(pcp);					\
+	if (ret__ == (oval))						\
+		__this_cpu_write(pcp, nval);				\
+	ret__;								\
+})
+
+#ifndef __this_cpu_cmpxchg
+# ifndef __this_cpu_cmpxchg_1
+#  define __this_cpu_cmpxchg_1(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef __this_cpu_cmpxchg_2
+#  define __this_cpu_cmpxchg_2(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef __this_cpu_cmpxchg_4
+#  define __this_cpu_cmpxchg_4(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef __this_cpu_cmpxchg_8
+#  define __this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# define __this_cpu_cmpxchg(pcp, oval, nval)	__pcpu_size_call_return2(\
+				__this_cpu_cmpxchg_, (pcp), oval, nval)
+#endif
+
+/*
+ * cmpxchg_double replaces two adjacent scalars at once. The first parameter
+ * passed is a percpu pointer, not a scalar like the other this_cpu
+ * operations. This is so because the function operates on two scalars
+ * (must be of same size). A truth value is returned to indicate success or
+ * failure (since a double register result is difficult to handle).
+ * There is very limited hardware support for these operations. So only certain
+ * sizes may work.
+ */
+#define __this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+({									\
+	typeof(oval2) * __percpu pcp2 = (typeof(oval2) *)((pcp) + 1);	\
+	int __ret = 0;							\
+	if (__this_cpu_read(*pcp) == (oval1) &&				\
+			 __this_cpu_read(*pcp2)  == (oval2)) {		\
+		__this_cpu_write(*pcp, (nval1));			\
+		__this_cpu_write(*pcp2, (nval2));			\
+		__ret = 1;						\
+	}								\
+	(__ret);							\
+})
+
+#ifndef __this_cpu_cmpxchg_double
+# ifndef __this_cpu_cmpxchg_double_1
+#  define __this_cpu_cmpxchg_double_1(pcp, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_2
+#  define __this_cpu_cmpxchg_double_2(pcp, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_4
+#  define __this_cpu_cmpxchg_double_4(pcp, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_8
+#  define __this_cpu_cmpxchg_double_8(pcp, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# define __this_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+	__pcpu_size_call_return_int(__this_cpu_cmpxchg_double_, (pcp),	\
+					 oval1, oval2, nval1, nval2)
+#endif
+
+#define _this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+({									\
+	int ret__;							\
+	preempt_disable();						\
+	ret__ = __this_cpu_generic_cmpxchg_double(pcp,			\
+			oval1, oval2, nval1, nval2);			\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_cmpxchg_double
+# ifndef this_cpu_cmpxchg_double_1
+#  define this_cpu_cmpxchg_double_1(pcp, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_2
+#  define this_cpu_cmpxchg_double_2(pcp, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_4
+#  define this_cpu_cmpxchg_double_4(pcp, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_8
+#  define this_cpu_cmpxchg_double_8(pcp, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# define this_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+	__pcpu_size_call_return_int(this_cpu_cmpxchg_double_, (pcp),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
+
+
+
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	preempt_disable();						\
@@ -610,7 +805,7 @@ do {									\
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
  * processors (which one gets when using regular atomic operations)
- . They are guaranteed to be atomic vs. local interrupts and
+ * They are guaranteed to be atomic vs. local interrupts and
  * preemption only.
  */
 #define irqsafe_cpu_generic_to_op(pcp, val, op)				\
@@ -697,4 +892,65 @@ do {									\
 # define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
 #endif
 
+#define irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)			\
+({									\
+	typeof(pcp) ret__;						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
+	ret__ = __this_cpu_read(pcp);					\
+	if (ret__ == (oval))						\
+		__this_cpu_write(pcp, nval);				\
+	local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#ifndef irqsafe_cpu_cmpxchg
+# ifndef irqsafe_cpu_cmpxchg_1
+#  define irqsafe_cpu_cmpxchg_1(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_2
+#  define irqsafe_cpu_cmpxchg_2(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_4
+#  define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_8
+#  define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# define irqsafe_cpu_cmpxchg(pcp, oval, nval)	__pcpu_size_call_return2(irqsafe_cpu_cmpxchg_, (pcp), oval, nval)
+#endif
+
+#define irqsafe_generic_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+({									\
+	int ret__;							\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
+	ret__ = __this_cpu_generic_cmpxchg_double(pcp,			\
+			oval1, oval2, nval1, nval2);			\
+	local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#ifndef irqsafe_cpu_cmpxchg_double
+# ifndef irqsafe_cpu_cmpxchg_double_1
+#  define irqsafe_cpu_cmpxchg_double_1(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_2
+#  define irqsafe_cpu_cmpxchg_double_2(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_4
+#  define irqsafe_cpu_cmpxchg_double_4(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_8
+#  define irqsafe_cpu_cmpxchg_double_8(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# define irqsafe_cpu_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+	__pcpu_size_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
 #endif /* __LINUX_PERCPU_H */

