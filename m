Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0K3TIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:08:46 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47651 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752638Ab0K3TIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:45 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cslmgisVM1kgC2keoogPzC54eay0CPkF3LoavUQqVpjAxZl
 Jil0TEPjYJb04FU2nzJZhVU0qxLJspEqLQCbxVpF48L0ZNbuS5lzikkYtL8n
 xUD48DEqe0wSwaMmbZH.cHo0DoCLTc5Xp.rNr.rnwNMHfTqiR0UG9nFL3lQG
 .HxHyaAyhgCkKQpGZQlar3384._7wnkP52OOz94OWjjpO86eBSEZ2_HV2JW9
 U2Pi4ZpIYoqR42A9gkRZGEI5vTiGLeyTsV8hMXG596FABuyLHyURI
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190842.869940433@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:10 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 03/18] percpu: Generic support for this_cpu_add,sub,dec,inc_return
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_add_dec_return
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

