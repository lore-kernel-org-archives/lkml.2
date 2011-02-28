Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1B1KWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:22:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1B1KWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:22:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oB84t6rLjPKE02uiRnZRRSRmVjD+Ru+r3mNiuEHS7kp32G/sQaCabobp1et7B5WnVj
         STVdIGPuhTJDlvsGX1b4vEmPOhQ944PCd/NFapeg8bWfHBfLfHjn0Y+7Xh+JBZm4H+OI
         WeSTYId8Qup5H3bOx/uolWZf9y1M1IbeNd/pk=
Date: Mon, 28 Feb 2011 11:22:15 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] percpu: Generic support for this_cpu_cmpxchg_double()
 this_cpu_cmpxchg_double
Message-ID: <20110228102215.GA8949@htj.dyndns.org>
References: <20110225173850.486326452@linux.com>
 <20110225174155.786331687@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225174155.786331687@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7c3343392172ba98d9d90a83edcc4c2e80897009 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <cl@linux.com>
Date: Mon, 28 Feb 2011 11:02:24 +0100

Introduce this_cpu_cmpxchg_double().  this_cpu_cmpxchg_double() allows
the comparison between two consecutive words and replaces them if
there is a match.

	bool this_cpu_cmpxchg_double(pcp1, pcp2,
		old_word1, old_word2, new_word1, new_word2)

this_cpu_cmpxchg_double does not return the old value (difficult since
there are two words) but a boolean indicating if the operation was
successful.

The first percpu variable must be double word aligned!

-tj: Updated to return bool instead of int, converted size check to
     BUILD_BUG_ON() instead of VM_BUG_ON() and other cosmetic changes.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to percpu:for-2.6.39 and pushed out to percpu:for-next.  Thank
you.

 include/linux/percpu.h |  128 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 27c3c6f..3a5c444 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -255,6 +255,30 @@ extern void __bad_size_call_parameter(void);
 	pscr2_ret__;							\
 })
 
+/*
+ * Special handling for cmpxchg_double.  cmpxchg_double is passed two
+ * percpu variables.  The first has to be aligned to a double word
+ * boundary and the second has to follow directly thereafter.
+ */
+#define __pcpu_double_call_return_bool(stem, pcp1, pcp2, ...)		\
+({									\
+	bool pdcrb_ret__;						\
+	__verify_pcpu_ptr(&pcp1);					\
+	BUILD_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
+	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
+	VM_BUG_ON((unsigned long)(&pcp2) !=				\
+		  (unsigned long)(&pcp1) + sizeof(pcp1));		\
+	switch(sizeof(pcp1)) {						\
+	case 1: pdcrb_ret__ = stem##1(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 2: pdcrb_ret__ = stem##2(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 4: pdcrb_ret__ = stem##4(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 8: pdcrb_ret__ = stem##8(pcp1, pcp2, __VA_ARGS__); break;	\
+	default:							\
+		__bad_size_call_parameter(); break;			\
+	}								\
+	pdcrb_ret__;							\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -501,6 +525,45 @@ do {									\
 #endif
 
 /*
+ * cmpxchg_double replaces two adjacent scalars at once.  The first
+ * two parameters are per cpu variables which have to be of the same
+ * size.  A truth value is returned to indicate success or failure
+ * (since a double register result is difficult to handle).  There is
+ * very limited hardware support for these operations, so only certain
+ * sizes may work.
+ */
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
+	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#endif
+
+/*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
  * responsibility of handling preemptions issues. Arch code can still
@@ -703,6 +766,39 @@ do {									\
 	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
 #endif
 
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
+	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#endif
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
@@ -823,4 +919,36 @@ do {									\
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
+	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#endif
+
 #endif /* __LINUX_PERCPU_H */
-- 
1.7.1

