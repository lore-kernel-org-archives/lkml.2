Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0LNRtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:49:07 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:41140 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759787Ab0LNRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:49:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3c18zHQVM1nY38myr96XSm5b.eT0kBOm9O1BqP1t.n6dmcH
 2.430yRCVvX0.ScUEFmUCpMh.NYOq1sidoEGEqHKccc80.o.4xifxOg7_axe
 cgGHRtAswFLOXQHv1L5_Th3VYMQ5n.uIc5hNqmp1.xkvJcVdKtt8ViAvEUmf
 1LkO16QqBec6rfzo2m0RtvVY0miJxvFUM8sKuVDEfOU57b4qSlqrTURlSa5w
 g5tPhTWu0GzMkEXfEkBt8jf5895eRXlpllH1MFAow.1DJ8y7jdHLCGPmfjE1
 56jGRJMS9IIq7vwkhEeIYxW2DVY3RMnFBxAMPmT_x1k6rPkw-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214174900.058235985@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 11:48:48 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com>
Content-Disposition: inline; filename=cpuops_double_generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce this_cpu_cmpxchg_double. this_cpu_cmpxchg_double() allows the
comparision between two consecutive words and replaces them if there is
a match.

	bool this_cpu_cmpxchg(xx __percpu *p, old_word1, old_word2, new_word1, new_word2)

this_cpu_cmpxchg does not return the old value (difficult since there are two
words) but a boolean indicating if the operation was successful.

Also this_cpu_cmpxchg does take a per cpu pointer rather than a variable
reference like the other this_cpu_ops. This is because two words are compared.

The pointer passed must be double word aligned!

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  130 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-12-14 10:34:20.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-12-14 10:36:13.000000000 -0600
@@ -259,6 +259,27 @@ extern void __bad_size_call_parameter(vo
 	pscr2_ret__;							\
 })
 
+/*
+ * Special handling for cmpxchg_double. cmpxchg_double is passed a
+ * __percpu pointer and that pointer has to be aligned to a double
+ * word boundary
+ */
+#define __pcpu_double_call_return_int(stem, pcp, ...)			\
+({									\
+	int ret__;							\
+	__verify_pcpu_ptr(pcp);						\
+	VM_BUG_ON((unsigned long)(pcp) % (2 * sizeof(unsigned long)));	\
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
@@ -422,6 +443,82 @@ do {									\
 				__this_cpu_cmpxchg_, pcp, oval, nval)
 #endif
 
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
+	__pcpu_double_call_return_int(__this_cpu_cmpxchg_double_, (pcp),	\
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
+	__pcpu_double_call_return_int(this_cpu_cmpxchg_double_, (pcp),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	preempt_disable();						\
@@ -825,4 +922,37 @@ do {									\
 # define irqsafe_cpu_cmpxchg(pcp, oval, nval)	__pcpu_size_call_return2(irqsafe_cpu_cmpxchg_, (pcp), oval, nval)
 #endif
 
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
+	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
 #endif /* __LINUX_PERCPU_H */

