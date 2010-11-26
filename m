Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0KZVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:09:59 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:23907 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751938Ab0KZVJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:55 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9b7YwBcVM1kGbo2Kh15P5ZzFQF9Bd6UykKFIVdCWt36nkJ.
 owbGA9kbaL_RNL6e1KiBSUZ2AEyaFACNTqhIeaMJPx3AubzA5GuG7bmceCl_
 G9piNJshmlPvK6qdyxZWazCL65tjHGZxEmWIMUjVetVzxKo6YKIVGuriDQqI
 oBwGiibmXKadXdLDrtnz.hxuXp6A.iGe3QGLoeNTj8LHaRpivZYgs4Dy6fq2
 yX5aKixN6H9Bdu8lNpG_zzg9ugUn16JNYOOVuzF2ulXYvCE.LhoqKGa5RDKv
 T_jV5xHM23XngDGTVfKBq
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210953.017559817@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:44 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 07/10] highmem: Use this_cpu_xx_return() operations
References: <20101126210937.383047168@linux.com>
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

