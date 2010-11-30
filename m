Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0K3TLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:11:32 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47670 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752638Ab0K3TIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:47 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5J4KcU8VM1kbxnHMx8PIBRUrsEeG5NCq1Cr978jCLcVSt23
 _k8pjuHX442a1qZxF5Q.xNiTqYSOAvhT69gugebjdxbuSsJOnCcBK4w4v2qS
 gkqRE9cdIo0hmC5EGw.xRwRDSjl3CL3V9rsEHdx2EZN.CO12_3Q.Xn32ER2J
 GkFfdU7IcUWrEZSm3qn5oFDGy1KgCVotkk07zT92ADwfnf6_lS_bgzCwwq3f
 7g_W3qZIDN2HWxkjQfa79bFP1n.aECc6vVUe51AaeKi6D2Mj..Eru
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190845.216537525@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:14 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 07/18] highmem: Use this_cpu_xx_return() operations
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_highmem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu operations to optimize access primitives for highmem.

The main effect is the avoidance of address calculations through the
use of a segment prefix.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

