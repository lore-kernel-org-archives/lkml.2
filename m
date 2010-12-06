Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0LFRkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:17 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32012 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752646Ab0LFRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:15 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: F9WItjwVM1n4b1SAtCKdOI5n7gxxz9T.9elODP_cqMZ86Rf
 DPmIF.Yk1zfs5L50ybjuz_vVlC79UiPQKFyDsyH4SAQEXFecZNBrW4fkLkqI
 21r2mD4xzRMONUALjDd_7E.p5Vu0luZ2qJqgx8c_hgmnheHKKUNkWSEpAZOO
 FYSc4fgrRiPnPDrZNEg_4gXj_KFCysphbLYNqhawdyoQb6dHJfK5_aTxFQKK
 Y9DRx595L7S3me4yq7z5V95YV8cFaIH1VmfZnXNWnbtyVXgdpHjosNK_YEVB
 DEzlLV6yk1AzKyg8rytzY
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174013.646729489@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:39:59 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 1/9] percpu: Generic support for this_cpu_add,sub,dec,inc_return
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_generic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic support for this_cpu_add_return etc.

The fallback is to realize these operations with simpler __this_cpu_ops.

Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |   77 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-11-29 10:19:28.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-11-29 10:24:57.000000000 -0600
@@ -240,6 +240,25 @@ extern void __bad_size_call_parameter(vo
 	pscr_ret__;							\
 })
 
+#define __pcpu_size_call_return2(stem, pcp, ...)			\
+({									\
+	typeof(pcp) ret__;						\
+	__verify_pcpu_ptr(&(pcp));					\
+	switch(sizeof(pcp)) {						\
+	case 1: ret__ = stem##1(pcp, __VA_ARGS__);			\
+		break;							\
+	case 2: ret__ = stem##2(pcp, __VA_ARGS__);			\
+		break;							\
+	case 4: ret__ = stem##4(pcp, __VA_ARGS__);			\
+		break;							\
+	case 8: ret__ = stem##8(pcp, __VA_ARGS__);			\
+		break;							\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	ret__;								\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -529,6 +548,64 @@ do {									\
 # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
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
+#define __this_cpu_generic_add_return(pcp, val)				\
+({									\
+	typeof(pcp) ret__;						\
+	__this_cpu_add(pcp, val);					\
+	ret__ = __this_cpu_read(pcp);					\
+	ret__;								\
+})
+
+#ifndef __this_cpu_add_return
+# ifndef __this_cpu_add_return_1
+#  define __this_cpu_add_return_1(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_2
+#  define __this_cpu_add_return_2(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_4
+#  define __this_cpu_add_return_4(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef __this_cpu_add_return_8
+#  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# endif
+# define __this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#endif
+
+#define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another

