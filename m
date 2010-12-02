Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0LBVyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:07 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47124 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758023Ab0LBVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: IoNYES8VM1mJo2Njb1.GDyFQ.RCsHR8acAVqZbVn7TcyURI
 FkTqGGoa6MWLbKX.tT7ANqEyTXUOjjvV7mXj2.3h02P3z4BhYjXTd0TpzqOs
 H8nGeJjtkJyZFJZplRry0OhB3JotJ83HqudjTHkX5.04exTa4SKmFfcpd69g
 Hnlhwa0VYggP9iEqvm4V7WFCG7RWQysg4eXKETDV8a9jlQgLltcDwgLqtwE3
 z2Ucf9YP484I-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215400.031151691@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:42 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 2/8] --- include/linux/percpu.h | 31 +++---------------------------- 1 file changed, 3 insertions(+), 28 deletions(-)
References: <20101202215340.562309713@linux.com>
Content-Disposition: inline; filename=this_cpu_atomic_fallback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2010-12-02 12:17:14.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2010-12-02 12:17:30.000000000 -0600
@@ -361,14 +361,7 @@ do {									\
 # define __this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
 #endif
 
-#define _this_cpu_generic_xchg(pcp, nval)				\
-({	typeof(pcp) ret__;						\
-	preempt_disable();						\
-	ret__ = __this_cpu_read(pcp);					\
-	__this_cpu_write(pcp, nval);					\
-	preempt_enable();						\
-	ret__;								\
-})
+#define _this_cpu_generic_xchg(pcp, nval)	xchg(__this_cpu_ptr(&(pcp)), nval)
 
 #ifndef this_cpu_xchg
 # ifndef this_cpu_xchg_1
@@ -386,15 +379,7 @@ do {									\
 # define this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
 #endif
 
-#define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({	typeof(pcp) ret__;						\
-	preempt_disable();						\
-	ret__ = __this_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		__this_cpu_write(pcp, nval);				\
-	preempt_enable();						\
-	ret__;								\
-})
+#define _this_cpu_generic_cmpxchg(pcp, oval, nval)	cmpxchg(__this_cpu_ptr(&(pcp)), oval, nval);
 
 #ifndef this_cpu_cmpxchg
 # ifndef this_cpu_cmpxchg_1
@@ -892,17 +877,7 @@ do {									\
 # define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
 #endif
 
-#define irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	local_irq_save(flags);						\
-	ret__ = __this_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		__this_cpu_write(pcp, nval);				\
-	local_irq_restore(flags);					\
-	ret__;								\
-})
+#define irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)	cmpxchg(__this_cpu_ptr(&(pcp), oval, nval)
 
 #ifndef irqsafe_cpu_cmpxchg
 # ifndef irqsafe_cpu_cmpxchg_1

