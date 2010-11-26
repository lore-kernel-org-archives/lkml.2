Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab0KZVMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:12:13 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32165 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751611Ab0KZVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:53 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5uAJer8VM1lDqVf0Fzu.GsMWllM3.WfFEWrkprHRe4KjZDq
 TpD.aft3_1jcwvKdh.4vjeHvQ8.iFw_mi6g8lfVFhBRF6is4iC5K9P4qzUG7
 12jE5QYEqROvgL4r_FEwNNX7FfMo.rLRmcUhhnQtgiKtEELkRc0Y3ePWHZ7.
 basWvIquE8e23KwIF1uPB97QPdSYCfkHSXLKBaaAjCXMReAriNkBZUWLWU1q
 ggVY0S6Nf9bsAQpN_ulgku4LPwhLRYUduILX.XQEd3q8W_qGYLoq5
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210951.303044608@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:41 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 04/10] x86: Support for this_cpu_add,sub,dec,inc_return
References: <20101126210937.383047168@linux.com>
Content-Disposition: inline; filename=this_cpu_add_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply an implementation for x86 in order to generate more efficient code.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-23 16:35:19.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-23 16:36:05.000000000 -0600
@@ -177,6 +177,45 @@ do {									\
 	}								\
 } while (0)
 
+
+/*
+ * Add return operation
+ */
+#define percpu_add_return_op(var, val)					\
+({									\
+	typedef typeof(var) pao_T__;					\
+	typeof(var) pfo_ret__ = val;					\
+	if (0) {							\
+		pao_T__ pao_tmp__;					\
+		pao_tmp__ = (val);					\
+		(void)pao_tmp__;					\
+	}								\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xaddb %0, "__percpu_arg(1)				\
+			    : "+q" (pfo_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xaddw %0, "__percpu_arg(1)				\
+			    : "+r" (pfo_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xaddl %0, "__percpu_arg(1)				\
+			    : "+r"(pfo_ret__), "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xaddq %0, "__percpu_arg(1)				\
+			    : "+re" (pfo_ret__),  "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	pfo_ret__ + (val);						\
+})
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -300,6 +339,14 @@ do {									\
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#ifndef CONFIG_M386
+#define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op((pcp), val)
+#define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op((pcp), val)
+#define __this_cpu_add_return_4(pcp, val)	percpu_add_return_op((pcp), val)
+#define this_cpu_add_return_1(pcp, val)		percpu_add_return_op((pcp), val)
+#define this_cpu_add_return_2(pcp, val)		percpu_add_return_op((pcp), val)
+#define this_cpu_add_return_4(pcp, val)		percpu_add_return_op((pcp), val)
+#endif
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -324,6 +371,9 @@ do {									\
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
+#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */

