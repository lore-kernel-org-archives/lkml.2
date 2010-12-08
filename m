Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0LHSIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:08:21 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:35955 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755747Ab0LHSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:08:19 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Jcvul2cVM1mNqAiB4zpOvDEhOvp3gQmhQK9XoXvBr01lU7.
 lRzMU4c.ZndI950X_E4EEWIdooSoD46UbZz9UGGhxjh6Wg7R7W8F_DYRilgc
 H39u_eTkXf8KWsKEOKVFVqq8M9OhZCYVXRAOEa4kfO_L5VBNa6pnaltiSheZ
 GiJxnpSwbVN0a0EdvPM7pdI64KDNv.Z.Etct2Y4R.4BgWL3.4tmTQw283a1Z
 pbLhGC9nFqaB17A4F9KJc5MEPipRSbjOe5vi4hakWYOqKWMhkDoic
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 12:08:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and this_cpu_xchg
 operations
In-Reply-To: <20101208175543.000201149@linux.com>
Message-ID: <alpine.DEB.2.00.1012081207250.26943@router.home>
References: <20101208175520.456864019@linux.com> <20101208175543.000201149@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alternate approach: Could also use cmpxchg for xchg..


Subject: cpuops: Use cmpxchg for xchg to avoid lock semantics

Cmpxchg has a lower cycle count due to the implied lock semantics of xchg.

Simulate the xchg through cmpxchg for the cpu ops.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   68 +++++++-----------------------------------
 1 file changed, 12 insertions(+), 56 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-08 11:43:50.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-08 12:00:21.000000000 -0600
@@ -212,48 +212,6 @@ do {									\
 	ret__;								\
 })

-/*
- * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
- * full lock semantics even though they are not needed.
- */
-#define percpu_xchg_op(var, nval)					\
-({									\
-	typeof(var) __ret;						\
-	typeof(var) __new = (nval);					\
-	switch (sizeof(var)) {						\
-	case 1:								\
-		asm("xchgb %2, "__percpu_arg(1)			\
-			    : "=a" (__ret), "+m" (var)			\
-			    : "q" (__new)				\
-			    : "memory");				\
-		break;							\
-	case 2:								\
-		asm("xchgw %2, "__percpu_arg(1)			\
-			    : "=a" (__ret), "+m" (var)			\
-			    : "r" (__new)				\
-			    : "memory");				\
-		break;							\
-	case 4:								\
-		asm("xchgl %2, "__percpu_arg(1)			\
-			    : "=a" (__ret), "+m" (var)			\
-			    : "r" (__new)				\
-			    : "memory");				\
-		break;							\
-	case 8:								\
-		asm("xchgq %2, "__percpu_arg(1)			\
-			    : "=a" (__ret), "+m" (var)			\
-			    : "r" (__new)				\
-			    : "memory");				\
-		break;							\
-	default: __bad_percpu_size();					\
-	}								\
-	__ret;								\
-})
-
-/*
- * cmpxchg has no such implied lock semantics as a result it is much
- * more efficient for cpu local operations.
- */
 #define percpu_cmpxchg_op(var, oval, nval)				\
 ({									\
 	typeof(var) __ret;						\
@@ -412,16 +370,6 @@ do {									\
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)

-#define __this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-
 #ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
@@ -489,16 +437,24 @@ do {									\
 #define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)

-#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-
 #define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 #endif

+#define this_cpu_xchg(pcp, val) \
+({									\
+	typeof(val) __o;						\
+	do {								\
+	 	__o = __this_cpu_read(pcp);				\
+	} while (this_cpu_cmpxchg(pcp, __o, val) != __o);		\
+	__o;								\
+})
+
+#define __this_cpu_xchg this_cpu_xchg
+#define irqsafe_cpu_xchg this_cpu_xchg
+
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\
 ({									\

