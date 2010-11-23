Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0KWXwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:02 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48860 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754201Ab0KWXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:51:59 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vOBT4rEVM1m04YQceh5J7eDKp8v0gnEFwgl1vYw_YS3G0Dq
 dR2kJV0wHs2OK9xlPTkCJEErQEvRbQzKCLjHNBi2ogozCcUXxYOvDHZ9hb1c
 BT6OL8pqY3.MW2W.Prpoc4Ih.tNdDTtnkwhRcNe3yzcSWu5YKNpFRvDcSVvW
 u_ydftnSRvFBuAnbN72.1MQM05GcTacaF6TmGcUgrZw0EqoQ5.vYJ.ijb3wa
 B7crRWhF.g9nrwSO.HSeRCl8ftJVi1wVzZZ55MkjXGaRzBe.K.Bp_
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235157.644134695@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:42 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 03/10] percpu: Generic support for this_cpu_add,sub,dec,inc_return
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=this_cpu_add_dec_return
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic support for this_cpu_add_return etc.

The fallback is to realize these operations with __this_cpu_ops.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-11-23 17:29:46.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-11-23 17:31:14.000000000 -0600
@@ -240,6 +240,20 @@ extern void __bad_size_call_parameter(vo
 	pscr_ret__;							\
 })
 
+#define __pcpu_size_call_return2(stem, variable, ...)			\
+({	typeof(variable) pscr_ret__;					\
+	__verify_pcpu_ptr(&(variable));					\
+	switch(sizeof(variable)) {					\
+	case 1: pscr_ret__ = stem##1(variable, __VA_ARGS__);break;	\
+	case 2: pscr_ret__ = stem##2(variable, __VA_ARGS__);break;	\
+	case 4: pscr_ret__ = stem##4(variable, __VA_ARGS__);break;	\
+	case 8: pscr_ret__ = stem##8(variable, __VA_ARGS__);break;	\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	pscr_ret__;							\
+})
+
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	__verify_pcpu_ptr(&(variable));					\
@@ -529,6 +543,62 @@ do {									\
 # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
 #endif
 
+#define _this_cpu_generic_add_return(pcp, val)				\
+({	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	__this_cpu_add((pcp), val);					\
+	ret__ = __this_cpu_read((pcp));					\
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
+# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, (pcp), val)
+#endif
+
+#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
+#define __this_cpu_generic_add_return(pcp, val)				\
+({	typeof(pcp) ret__;						\
+	__this_cpu_add((pcp), val);					\
+	ret__ = __this_cpu_read((pcp));					\
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
+# define __this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, (pcp), val)
+#endif
+
+#define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
+#define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another

