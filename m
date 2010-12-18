Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0LRPYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:24:34 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:62457 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0LRPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:24:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=t5Bw1MxO2BuJ00FD9hNNVqpB1iF2YE4AqF2AxCiETD6+Ns/q+zT7Z3f1fCZ8ZcrODL
         3qJh5DlqFqQxXiq0JfHyzW8w6gKhkVL8bZVwv+GTTrLST00hk03Tj07/0DJF8CV0tdZU
         ou3Ji1R6NE/3T9VqggYMab6kMlB329e2SikFI=
From: Tejun Heo <tj@kernel.org>
To: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, hpa@zytor.com,
        mathieu.desnoyers@efficios.com
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 3/6] percpu,x86: relocate this_cpu_add_return() and friends
Date: Sat, 18 Dec 2010 16:24:09 +0100
Message-Id: <1292685852-12469-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292685852-12469-1-git-send-email-tj@kernel.org>
References: <1292685852-12469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- include/linux/percpu.h: this_cpu_add_return() and friends were
  located next to __this_cpu_add_return().  However, the overall
  organization is to first group by preemption safeness.  Relocate
  this_cpu_add_return() and friends to preemption-safe area.

- arch/x86/include/asm/percpu.h: Relocate percpu_add_return_op() after
  other more basic operations.  Relocate [__]this_cpu_add_return_8()
  so that they're first grouped by preemption safeness.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---
 arch/x86/include/asm/percpu.h |   71 ++++++++++++++++++++---------------------
 include/linux/percpu.h        |   60 +++++++++++++++++-----------------
 2 files changed, 65 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 38f9e96..dd0cd4b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -177,39 +177,6 @@ do {									\
 	}								\
 } while (0)
 
-/*
- * Add return operation
- */
-#define percpu_add_return_op(var, val)					\
-({									\
-	typeof(var) paro_ret__ = val;					\
-	switch (sizeof(var)) {						\
-	case 1:								\
-		asm("xaddb %0, "__percpu_arg(1)				\
-			    : "+q" (paro_ret__), "+m" (var)		\
-			    : : "memory");				\
-		break;							\
-	case 2:								\
-		asm("xaddw %0, "__percpu_arg(1)				\
-			    : "+r" (paro_ret__), "+m" (var)		\
-			    : : "memory");				\
-		break;							\
-	case 4:								\
-		asm("xaddl %0, "__percpu_arg(1)				\
-			    : "+r" (paro_ret__), "+m" (var)		\
-			    : : "memory");				\
-		break;							\
-	case 8:								\
-		asm("xaddq %0, "__percpu_arg(1)				\
-			    : "+re" (paro_ret__), "+m" (var)		\
-			    : : "memory");				\
-		break;							\
-	default: __bad_percpu_size();					\
-	}								\
-	paro_ret__ += val;						\
-	paro_ret__;							\
-})
-
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -263,6 +230,39 @@ do {									\
 })
 
 /*
+ * Add return operation
+ */
+#define percpu_add_return_op(var, val)					\
+({									\
+	typeof(var) paro_ret__ = val;					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xaddb %0, "__percpu_arg(1)				\
+			    : "+q" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xaddw %0, "__percpu_arg(1)				\
+			    : "+r" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xaddl %0, "__percpu_arg(1)				\
+			    : "+r" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xaddq %0, "__percpu_arg(1)				\
+			    : "+re" (paro_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	paro_ret__ += val;						\
+	paro_ret__;							\
+})
+
+/*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
  * percpu_read_stable() is more efficient and can be used if its value
@@ -352,6 +352,7 @@ do {									\
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -359,14 +360,12 @@ do {									\
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 
 #define irqsafe_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
-
-#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
-#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 4d593de..3484e88 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -417,6 +417,36 @@ do {									\
 # define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif
 
+#define _this_cpu_generic_add_return(pcp, val)				\
+({									\
+	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	__this_cpu_add(pcp, val);					\
+	ret__ = __this_cpu_read(pcp);					\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#ifndef this_cpu_add_return
+# ifndef this_cpu_add_return_1
+#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_2
+#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_4
+#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_8
+#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#endif
+
+#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
 /*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
@@ -544,36 +574,6 @@ do {									\
 # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
 #endif
 
-#define _this_cpu_generic_add_return(pcp, val)				\
-({									\
-	typeof(pcp) ret__;						\
-	preempt_disable();						\
-	__this_cpu_add(pcp, val);					\
-	ret__ = __this_cpu_read(pcp);					\
-	preempt_enable();						\
-	ret__;								\
-})
-
-#ifndef this_cpu_add_return
-# ifndef this_cpu_add_return_1
-#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_2
-#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_4
-#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_8
-#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
-#endif
-
-#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
-#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
-#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
-
 #define __this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	__this_cpu_add(pcp, val);					\
-- 
1.7.1

