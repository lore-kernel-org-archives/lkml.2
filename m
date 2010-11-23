Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0KWXwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:38 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:41058 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754572Ab0KWXwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DXzgLsMVM1lKHifvdgboyXAv0y8AEyhsJjStEq4bhOQ_6IH
 jZdWQEb55Cf4mN7TM8FLgTY26UgcExpkl05iuw6XwIeRtr7k0Qsdf.166VBm
 ZXzNl1m5AMMyygXKEOYjSuug7dgQ7vKZndEMWD25kaOM45pctGtvFS8A8BTA
 CPkmMGj610dmUsaQH3YSRx5p9sz0s9lVSlHeGB5ip6A4JglaUe5JwAwF2bqM
 It7qREZdP.nYXXsVIwYGG.pKqcSTG2V8ywxWGDkc0Yggv1ZquNTQm
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235200.582485207@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:47 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 08/10] percpu: generic this_cpu_cmpxchg() and this_cpu_cmpxchg_double support
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=this_cpu_cmpxchg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide arch code to create the (local atomic) instructions.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  179 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-11-23 16:49:02.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-11-23 16:50:45.000000000 -0600
@@ -254,6 +254,21 @@ extern void __bad_size_call_parameter(vo
 	pscr_ret__;							\
 })
 
+/* Special handling for cmpxchg_double */
+#define __pcpu_size_call_return_int(stem, pcp, ...)			\
+({	int pscr_ret__;							\
+	__verify_pcpu_ptr(pcp);						\
+	switch(sizeof(*pcp)) {						\
+	case 1: pscr_ret__ = stem##1(pcp, __VA_ARGS__);break;		\
+	case 2: pscr_ret__ = stem##2(pcp, __VA_ARGS__);break;		\
+	case 4: pscr_ret__ = stem##4(pcp, __VA_ARGS__);break;		\
+	case 8: pscr_ret__ = stem##8(pcp, __VA_ARGS__);break;		\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	pscr_ret__;							\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -599,6 +614,134 @@ do {									\
 #define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
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
+({	typeof(pcp) ret__;						\
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
+({	typeof(oval2) * __percpu pcp2 = (typeof(oval2) *)((pcp) + 1);	\
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
+({	int ret__;							\
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
@@ -610,7 +753,7 @@ do {									\
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
  * processors (which one gets when using regular atomic operations)
- . They are guaranteed to be atomic vs. local interrupts and
+ * They are guaranteed to be atomic vs. local interrupts and
  * preemption only.
  */
 #define irqsafe_cpu_generic_to_op(pcp, val, op)				\
@@ -697,4 +840,38 @@ do {									\
 # define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
 #endif
 
+#define irqsafe_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+({	int ret__;							\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
+	ret__ = __this_cpu_generic_cmpxchg_double(pcp,			\
+			oval1, oval2, nval1, nval2);			\
+	local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#ifndef irqsafe_cmpxchg_double
+# ifndef irqsafe_cmpxchg_double_1
+#  define irqsafe_cmpxchg_double_1(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cmpxchg_double_2
+#  define irqsafe_cmpxchg_double_2(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cmpxchg_double_4
+#  define irqsafe_cmpxchg_double_4(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cmpxchg_double_8
+#  define irqsafe_cmpxchg_double_8(pcp, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)
+# endif
+# define irqsafe_cmpxchg_double(pcp, oval1, oval2, nval1, nval2)	\
+	__pcpu_size_call_return_int(irqsafe_cmpxchg_double_, (pcp),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
+
+
 #endif /* __LINUX_PERCPU_H */

