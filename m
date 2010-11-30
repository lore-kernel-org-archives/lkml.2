Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0K3TMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:12:16 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36735 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751260Ab0K3TIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nBjlWgoVM1mQezkMqV4mnW10fgmvz2xfkK.12hAJy9KX6WW
 lTzEa6ap.WHUJ6ytbrPlsyCnFvZUvRZWmmxapYzK5UrvWrhOVl9duC4dwDKA
 VoZTYBWmW0qIwEgplscUzacgjFHX3_tynWysSlN2Q7syJRvO7um_6qrbObBt
 0pAFArYQCJ1NPnHetJ89j.Oa0l7osDdyIE6.vT6IMjRkhxTGSB0AQXwIo_0u
 qPgYDT15Se_V9sVhuaoVnl082j1XCE0DW50wqMOd1vSXcBDDqNR4Y
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190843.437924198@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:11 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 04/18] x86: Support for this_cpu_add,sub,dec,inc_return
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_add_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supply an implementation for x86 in order to generate more efficient code.

V2->V3:
	- Cleanup
	- Remove strange type checking from percpu_add_return_op.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/percpu.h |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-29 14:29:13.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-30 08:42:02.000000000 -0600
@@ -177,6 +177,41 @@ do {									\
 	}								\
 } while (0)
 
+
+/*
+ * Add return operation
+ */
+#define percpu_add_return_op(var, val)					\
+({									\
+	typedef typeof(var) pao_T__;					\
+	typeof(var) ret__ = val;					\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("xaddb %0, "__percpu_arg(1)				\
+			    : "+q" (ret__), "+m" (var)			\
+			    : : "memory");				\
+		break;							\
+	case 2:								\
+		asm("xaddw %0, "__percpu_arg(1)				\
+			    : "+r" (ret__), "+m" (var)			\
+			    : : "memory");				\
+		break;							\
+	case 4:								\
+		asm("xaddl %0, "__percpu_arg(1)				\
+			    : "+r"(ret__), "+m" (var)			\
+			    : : "memory");				\
+		break;							\
+	case 8:								\
+		asm("xaddq %0, "__percpu_arg(1)				\
+			    : "+re" (ret__),  "+m" (var)		\
+			    : : "memory");				\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+	ret__ += val;							\
+	ret__;								\
+})
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -300,6 +335,14 @@ do {									\
 #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#ifndef CONFIG_M386
+#define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
+#define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
+#define __this_cpu_add_return_4(pcp, val)	percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
+#endif
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
  * 32 bit must fall back to generic operations.
@@ -324,6 +367,9 @@ do {									\
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
+#define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
+
 #endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */

