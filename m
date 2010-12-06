Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0LFRkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:40:22 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:31672 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753894Ab0LFRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:40:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Cy.U5KEVM1mN5RKX101HhK.qUo1W.aMLlug6_eXSdk4x3wG
 JQnXLjuOcrHmbu9pW1rwnPQhlTD5udlp7fzn1zjbB15.NH5BlmEFbG_leEf4
 N7uq9T4mmLW8nKyx0jsPmjybZSz2xGQvncZLaW6meheKkKVGVMxb_sBHkC_Q
 Y.s0k_ltKdM_xHseZu1nnDahaHFoUfSLERp9Lm_oeq2rokzYVXOxkyAIQnx5
 LcVaplrHXScw8MEUJH3suOgARS8UpJNmhupNPyfXqS3TlhfKSHw0N
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206174015.961454797@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:40:03 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops inc_return V1 5/9] highmem: Use this_cpu_xx_return() operations
References: <20101206173958.685460926@linux.com>
Content-Disposition: inline; filename=cpuops_inc_return_highmem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu operations to optimize access primitives for highmem.

The main effect is the avoidance of address calculations through the
use of a segment prefix.

V3->V4
	- kmap_atomic_idx: Do not return a value.
	- Use __this_cpu_dec without HIGHMEM_DEBUG

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/highmem.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2010-12-01 09:47:58.000000000 -0600
+++ linux-2.6/include/linux/highmem.h	2010-12-01 09:48:16.000000000 -0600
@@ -81,7 +81,8 @@ DECLARE_PER_CPU(int, __kmap_atomic_idx);
 
 static inline int kmap_atomic_idx_push(void)
 {
-	int idx = __get_cpu_var(__kmap_atomic_idx)++;
+	int idx = __this_cpu_inc_return(__kmap_atomic_idx) - 1;
+
 #ifdef CONFIG_DEBUG_HIGHMEM
 	WARN_ON_ONCE(in_irq() && !irqs_disabled());
 	BUG_ON(idx > KM_TYPE_NR);
@@ -91,16 +92,18 @@ static inline int kmap_atomic_idx_push(v
 
 static inline int kmap_atomic_idx(void)
 {
-	return __get_cpu_var(__kmap_atomic_idx) - 1;
+	return __this_cpu_read(__kmap_atomic_idx) - 1;
 }
 
-static inline int kmap_atomic_idx_pop(void)
+static inline void kmap_atomic_idx_pop(void)
 {
-	int idx = --__get_cpu_var(__kmap_atomic_idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
+	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
+
 	BUG_ON(idx < 0);
+#else
+	__this_cpu_dec(__kmap_atomic_idx);
 #endif
-	return idx;
 }
 
 #endif

