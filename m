Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab0LNQ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:28:57 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:41526 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759506Ab0LNQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:55 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2wXLboYVM1kwtgASto9UNQ0Pk_aS0A26W70xkiMoniXWnAn
 k52VXgMoq4VOd8B9t8RLuwHPPWwB1K977sjvvtwyL8YA9YYqNJmSWHhpeOvn
 nrDGGloBJwYl20vnfVAUXyXloP7VRvjZ.hC.60nJUTwJhkhkAS1zHU4MdLGJ
 bs8khsT06iNHiQDcwMYp9nPdNWiX2MD7M8q5i_1_jBmDZhTaCWC06ABsk2FV
 LT5ovCFNoKLQ5wBv37DiRoITXylwR6eKWqsp0q0rMkAeM4H9C_pahhuNanOb
 WxuCjF3OKKavvnN9_ECgSnQIxjj2r3vJE4La4E6aT9vB4kMI-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214162853.057391047@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 10:28:43 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V2 1/5] percpu: Generic this_cpu_cmpxchg() and this_cpu_xchg support
References: <20101214162842.542421046@linux.com>
Content-Disposition: inline; filename=cpuops_cmpxchg_generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic code to provide new per cpu atomic features

	this_cpu_cmpxchg
	this_cpu_xchg

Fallback occurs to functions using interrupts disable/enable
to ensure correct per cpu atomicity.

Fallback to regular cmpxchg and xchg is not possible since per cpu atomic
semantics include the guarantee that the current cpus per cpu data is
accessed atomically. Use of regular cmpxchg and xchg requires the
determination of the address of the per cpu data before regular cmpxchg
or xchg which therefore cannot be atomically included in an xchg or
cmpxchg without segment override.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  142 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 135 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-12-08 13:16:22.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-12-08 14:43:46.000000000 -0600
@@ -242,21 +242,21 @@ extern void __bad_size_call_parameter(vo
 
 #define __pcpu_size_call_return2(stem, pcp, ...)			\
 ({									\
-	typeof(pcp) ret__;						\
+	typeof(pcp) pscr2_ret__;					\
 	__verify_pcpu_ptr(&(pcp));					\
 	switch(sizeof(pcp)) {						\
-	case 1: ret__ = stem##1(pcp, __VA_ARGS__);			\
+	case 1: pscr2_ret__ = stem##1(pcp, __VA_ARGS__);		\
 		break;							\
-	case 2: ret__ = stem##2(pcp, __VA_ARGS__);			\
+	case 2: pscr2_ret__ = stem##2(pcp, __VA_ARGS__);		\
 		break;							\
-	case 4: ret__ = stem##4(pcp, __VA_ARGS__);			\
+	case 4: pscr2_ret__ = stem##4(pcp, __VA_ARGS__);		\
 		break;							\
-	case 8: ret__ = stem##8(pcp, __VA_ARGS__);			\
+	case 8: pscr2_ret__ = stem##8(pcp, __VA_ARGS__);		\
 		break;							\
 	default:							\
 		__bad_size_call_parameter();break;			\
 	}								\
-	ret__;								\
+	pscr2_ret__;							\
 })
 
 #define __pcpu_size_call(stem, variable, ...)				\
@@ -322,6 +322,106 @@ do {									\
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
+# define this_cpu_cmpxchg(pcp, oval, nval)	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
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
+				__this_cpu_cmpxchg_, pcp, oval, nval)
+#endif
+
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	preempt_disable();						\
@@ -610,7 +710,7 @@ do {									\
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
  * processors (which one gets when using regular atomic operations)
- . They are guaranteed to be atomic vs. local interrupts and
+ * They are guaranteed to be atomic vs. local interrupts and
  * preemption only.
  */
 #define irqsafe_cpu_generic_to_op(pcp, val, op)				\
@@ -697,4 +797,32 @@ do {									\
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
 #endif /* __LINUX_PERCPU_H */

