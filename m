Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1BYRl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:41:59 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:25371 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754734Ab1BYRl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:41:58 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: YAYf6VkVM1nt.tIcQpsCx.q1EezBfmsu8R.Ak_tE_QtvweJ
 .mwUxtrvIeDZUMxz7kXYbMiiunBXBrwcYKnAoK4kGqenq6__2Ufp6U24d3FY
 rmkuy8_fn5CqOWZQaLNi6SvBXknnEYsszdmxejziDU8oBPxJNDWI7PNmebPz
 R1UVdART8S6TGqJSfCmKVhf.WM60owMX7zMRX_Pg22MUq990fE95Dbc5twzB
 ZdtCQ_IGLPQDdWcL_DllxMp8iCmeygUOD2Uf0zJuiOB6OJQrSPe.FGwtE3n_
 XeRdJfuS804pSYyG7xXytKw1wNmcZNFSyoOSXgBjbXAxBMm0-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110225174155.786331687@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 25 Feb 2011 11:38:53 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V3 3/5] Generic support for this_cpu_cmpxchg_double
References: <20110225173850.486326452@linux.com>
Content-Disposition: inline; filename=cpuops_double_generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce this_cpu_cmpxchg_double. this_cpu_cmpxchg_double() allows the
comparision between two consecutive words and replaces them if there is
a match.

	bool this_cpu_cmpxchg_double(pcp1, pcp2,
		old_word1, old_word2, new_word1, new_word2)

this_cpu_cmpxchg_double does not return the old value (difficult since
there are two words) but a boolean indicating if the operation was
successful.

The first percpu variable must be double word aligned!

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  130 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2011-01-10 10:22:35.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2011-01-10 10:26:43.000000000 -0600
@@ -255,6 +255,29 @@ extern void __bad_size_call_parameter(vo
 	pscr2_ret__;							\
 })
 
+/*
+ * Special handling for cmpxchg_double. cmpxchg_double is passed two
+ * percpu variables. The first has to be aligned to a double word
+ * boundary and the second has to follow directly thereafter.
+ */
+#define __pcpu_double_call_return_int(stem, pcp1, pcp2, ...)		\
+({									\
+	int ret__;							\
+	__verify_pcpu_ptr(&pcp1);					\
+	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
+	VM_BUG_ON((unsigned long)(&pcp2) != (unsigned long)(&pcp1) + sizeof(pcp1));\
+	VM_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
+	switch(sizeof(pcp1)) {						\
+	case 1: ret__ = stem##1(pcp1, pcp2, __VA_ARGS__);break;		\
+	case 2: ret__ = stem##2(pcp1, pcp2, __VA_ARGS__);break;		\
+	case 4: ret__ = stem##4(pcp1, pcp2, __VA_ARGS__);break;		\
+	case 8: ret__ = stem##8(pcp1, pcp2, __VA_ARGS__);break;		\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	ret__;								\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -318,6 +341,80 @@ do {									\
 # define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
 #endif
 
+/*
+ * cmpxchg_double replaces two adjacent scalars at once. The first two
+ * parameters are per cpu variables which have to be of the same size.
+ * A truth value is returned to indicate success or
+ * failure (since a double register result is difficult to handle).
+ * There is very limited hardware support for these operations. So only certain
+ * sizes may work.
+ */
+#define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+({									\
+	int __ret = 0;							\
+	if (__this_cpu_read(pcp1) == (oval1) &&				\
+			 __this_cpu_read(pcp2)  == (oval2)) {		\
+		__this_cpu_write(pcp1, (nval1));			\
+		__this_cpu_write(pcp2, (nval2));			\
+		__ret = 1;						\
+	}								\
+	(__ret);							\
+})
+
+#ifndef __this_cpu_cmpxchg_double
+# ifndef __this_cpu_cmpxchg_double_1
+#  define __this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_2
+#  define __this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_4
+#  define __this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef __this_cpu_cmpxchg_double_8
+#  define __this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_int(__this_cpu_cmpxchg_double_, (pcp1), (pcp2)	\
+					 oval1, oval2, nval1, nval2)
+#endif
+
+#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+({									\
+	int ret__;							\
+	preempt_disable();						\
+	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+			oval1, oval2, nval1, nval2);			\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_cmpxchg_double
+# ifndef this_cpu_cmpxchg_double_1
+#  define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_2
+#  define this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_4
+#  define this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_8
+#  define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_int(this_cpu_cmpxchg_double_, (pcp1), (pcp2),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	preempt_disable();						\
@@ -823,4 +920,37 @@ do {									\
 	__pcpu_size_call_return2(irqsafe_cpu_cmpxchg_, (pcp), oval, nval)
 #endif
 
+#define irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+({									\
+	int ret__;							\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
+	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+			oval1, oval2, nval1, nval2);			\
+	local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#ifndef irqsafe_cpu_cmpxchg_double
+# ifndef irqsafe_cpu_cmpxchg_double_1
+#  define irqsafe_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_2
+#  define irqsafe_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_4
+#  define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_double_8
+#  define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2),	\
+		oval1, oval2, nval1, nval2)
+#endif
+
 #endif /* __LINUX_PERCPU_H */

