Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0KWXwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:05 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:29401 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754354Ab0KWXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:00 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pBMo8m8VM1nUXbp9hjAzaYF5wwVCyWQGgdJSKF6MKbHJoDe
 M_85Fm_CRP_iQolnAtU_bo7oN6pUiCjsGpiIDitwNxa8vJbUiK5ZLT2V5.pL
 5Ul8Ui2ODN0mcxXnyUCWfl8drefdYPSv.OJyiw8k0wFXw_5cwFkygBR.EYeD
 ZFl6MOObRucF6SBUHeOxtQHc2Sx9mZLEoZS1brGtI7kFKyFmIyFWMYxzUJac
 VWFM_bnDaC3i_FZyZCCj3sajgKyB_dRaPWi7_n9oqkYnruLS2XiuL
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235158.236495885@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:43 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 04/10] x86: Support for this_cpu_add,sub,dec,inc_return
References: <20101123235139.908255844@linux.com>
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

