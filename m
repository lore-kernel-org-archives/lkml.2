Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0KWXxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:53:06 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:44238 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754507Ab0KWXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:02 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: QmODBIQVM1mE7I3f6CtYsruGeLnIiJef05VqJX3_JApdPFT
 RhZDiZH48nOpPzgZYLkgNE.DXUIPSc1Dd7UUPNH5h5AXcIgl8vPYUJlnMnB0
 Z2..iNtU_cBKLfLakbiCjp_K66sUtXY3StdfZnYIaECZ0PpYJpemGVSINcdy
 sJlSZkOB9z.DfiN98vx9Nx6HuSQtF.VXA.FKxpYLy2csbmweWoWJaAAWv9sl
 7RhTnjfMmPLUQUKESvyUltluPxvCwwyqJ7ryE2btsrGlUDT_Pfqxi
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235159.990165715@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:46 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 07/10] highmem: Use this_cpu_xx_return() operations
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=highmem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu operations to optimize access primitives for highmem.

The main effect is the avoidance of address calculations through the
use of a segment prefix.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/highmem.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2010-11-22 14:43:40.000000000 -0600
+++ linux-2.6/include/linux/highmem.h	2010-11-22 14:45:02.000000000 -0600
@@ -81,7 +81,8 @@ DECLARE_PER_CPU(int, __kmap_atomic_idx);
 
 static inline int kmap_atomic_idx_push(void)
 {
-	int idx = __get_cpu_var(__kmap_atomic_idx)++;
+	int idx = __this_cpu_inc_return(__kmap_atomic_idx) - 1;
+
 #ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
 	BUG_ON(idx > KM_TYPE_NR);
@@ -91,12 +92,12 @@ static inline int kmap_atomic_idx_push(v
 
 static inline int kmap_atomic_idx(void)
 {
-	return __get_cpu_var(__kmap_atomic_idx) - 1;
+	return __this_cpu_read(__kmap_atomic_idx) - 1;
 }
 
 static inline int kmap_atomic_idx_pop(void)
 {
-	int idx = --__get_cpu_var(__kmap_atomic_idx);
+	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(idx < 0);
 #endif

