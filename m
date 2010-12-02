Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0LBWGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:06:19 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:33315 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753059Ab0LBWGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:06:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AX5dapgVM1nT2amJ74iPPjU.uGmaUlV_rVhZsZ5jrVJp0aL
 javlNodM_pbf8DcqXw_Yp3uFIsbGUnhOZERU.BL9kEk3AZbUdRbovZieRSAw
 i.UNTAyS456Ur7JusFLPhT3y.UfygFpFSyL.Ir74B7gKF0aVBzm9qS_0aNqj
 oaNuBo7skkBymK9t3kslxaDv1EF3pkvRqAGoMa7NjT83aaynwIgWCPZrkG9Z
 cFdz7u2yHUT5gODtDc8OVmh73H0yTmKvrq9yRKQ0VVoApUqVN.FBp
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 2 Dec 2010 16:06:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: akpm@linux-foundation.org
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 2/8] Fallback to atomic xchg, cmpxchg
In-Reply-To: <20101202215400.031151691@linux.com>
Message-ID: <alpine.DEB.2.00.1012021604330.5395@router.home>
References: <20101202215340.562309713@linux.com> <20101202215400.031151691@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry this should have been:

Subject: this_cpu_xchg/cmpxchg: Fall back to atomic xchg, cmpxchg

It may be better if we fall back to the full operation instead of
simulation through irq disable etc.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/percpu.h |   31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

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
