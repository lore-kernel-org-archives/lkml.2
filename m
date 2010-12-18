Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0LRPZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:25:06 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40252 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab0LRPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mXVPZ0ixJojshwugEH0G01vs2JvmTgRKGF79EuT2WPbYtylCMBrGSuUub8RV2/9Ejq
         36Jt4+HNIJc3iZzjom+480e0yVaj4OH6WtJs7tvaMGHPutc0WhyuKDzDrcG3u0O0E4ke
         Cln2FwhcNNg67nQ575+STjxrv1QyjjT73BNkk=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] percpu: Generic this_cpu_cmpxchg() and this_cpu_xchg support
Date: Sat, 18 Dec 2010 16:24:10 +0100
Message-Id: <1292685852-12469-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

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

tj: - Relocated new ops to conform better to the general organization.
    - This patch contains a trivial comment fix.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |  134 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 133 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 3484e88..27c3c6f 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -447,6 +447,59 @@ do {									\
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
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
+# define this_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
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
+# define this_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
+#endif
+
 /*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
@@ -600,11 +653,61 @@ do {									\
 #define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
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
+# define __this_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
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
+# define __this_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+#endif
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
  * processors (which one gets when using regular atomic operations)
- . They are guaranteed to be atomic vs. local interrupts and
+ * They are guaranteed to be atomic vs. local interrupts and
  * preemption only.
  */
 #define irqsafe_cpu_generic_to_op(pcp, val, op)				\
@@ -691,4 +794,33 @@ do {									\
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
+# define irqsafe_cpu_cmpxchg(pcp, oval, nval)		\
+	__pcpu_size_call_return2(irqsafe_cpu_cmpxchg_, (pcp), oval, nval)
+#endif
+
 #endif /* __LINUX_PERCPU_H */
-- 
1.7.1

