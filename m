Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0LHRzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:55:49 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:38357 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755117Ab0LHRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:55:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xxQAaI0VM1mteUPQOT75K6ySjJTGBLOISMYXeZY6bzuEfXF
 UF37YgUiiJ3wwSu0nDjjPneeQZsKYn.6TB3AdsaK8Gd6hD18JQ1QgMBdAzJE
 z9yMeo9xNN8xNQAgFd7ebEnKGh8UJUXXEOQCeDowtZXzfWB8iw6vGqIq.Eoo
 ZFUadfDyiMO.0M_ntxzsCNuD3OUVtfWAMI6kQoze49anKaa3jcZIIfNSxhIO
 hCGLRn.CUYrkp2gF4VeyXtCP8qpWD6wT7rWfRFWMkuauEHEadSPle
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101208175542.416922260@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 08 Dec 2010 11:55:21 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V1 1/4] percpu: Generic this_cpu_cmpxchg() and this_cpu_xchg support
References: <20101208175520.456864019@linux.com>
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
accessed. Use of regular cmpxchg and xchg requires the determination of
the address of the per cpu data which cannot be atomically included in
the xchg or cmpxchg.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |  130 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-12-06 12:21:16.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-12-06 13:45:01.000000000 -0600
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

