Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698Ab1JENMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:12:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934332Ab1JENMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:12:19 -0400
Subject: Re: [PATCH] mm, arch: Complete pagefault_disable abstraction
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 05 Oct 2011 15:12:14 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317820334.6766.23.camel@twins>
Mime-Version: 1.0
X-Bad-Reply: 'Re:' in Subject but no References or In-Reply-To headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those with a strong stomach, here's what we do with kmap_atomic:

---
Subject: mm, rt: kmap_atomic scheduling
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 28 Jul 2011 10:43:51 +0200

In fact, with migrate_disable() existing one could play games with
kmap_atomic. You could save/restore the kmap_atomic slots on context
switch (if there are any in use of course), this should be esp easy now
that we have a kmap_atomic stack.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[dvhart@linux.intel.com: build fix]
Link: http://lkml.kernel.org/r/1311842631.5890.208.camel@twins
---
 arch/x86/kernel/process_32.c |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    5 +++++
 mm/memory.c                  |    2 ++
 3 files changed, 43 insertions(+)

Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c
+++ linux-2.6/arch/x86/kernel/process_32.c
@@ -38,6 +38,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/highmem.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -346,6 +347,41 @@ __switch_to(struct task_struct *prev_p, 
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+	/*
+	 * Save @prev's kmap_atomic stack
+	 */
+	prev_p->kmap_idx = __this_cpu_read(__kmap_atomic_idx);
+	if (unlikely(prev_p->kmap_idx)) {
+		int i;
+
+		for (i = 0; i < prev_p->kmap_idx; i++) {
+			int idx = i + KM_TYPE_NR * smp_processor_id();
+
+			pte_t *ptep = kmap_pte - idx;
+			prev_p->kmap_pte[i] = *ptep;
+			kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
+		}
+
+		__this_cpu_write(__kmap_atomic_idx, 0);
+	}
+
+	/*
+	 * Restore @next_p's kmap_atomic stack
+	 */
+	if (unlikely(next_p->kmap_idx)) {
+		int i;
+
+		__this_cpu_write(__kmap_atomic_idx, next_p->kmap_idx);
+
+		for (i = 0; i < next_p->kmap_idx; i++) {
+			int idx = i + KM_TYPE_NR * smp_processor_id();
+
+			set_pte(kmap_pte - idx, next_p->kmap_pte[i]);
+		}
+	}
+#endif
+
 	/* If we're going to preload the fpu context, make sure clts
 	   is run while we're batching the cpu state updates. */
 	if (preload_fpu)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -63,6 +63,7 @@ struct sched_param {
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
 
+#include <asm/kmap_types.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -1594,6 +1595,10 @@ struct task_struct {
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
 #endif
+#if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+	int kmap_idx;
+	pte_t kmap_pte[KM_TYPE_NR];
+#endif
 };
 
 #ifdef CONFIG_PREEMPT_RT_FULL
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -3431,6 +3431,7 @@ unlock:
 #ifdef CONFIG_PREEMPT_RT_FULL
 void pagefault_disable(void)
 {
+	migrate_disable();
 	current->pagefault_disabled++;
 	/*
 	 * make sure to have issued the store before a pagefault
@@ -3448,6 +3449,7 @@ void pagefault_enable(void)
 	 */
 	barrier();
 	current->pagefault_disabled--;
+	migrate_enable();
 }
 EXPORT_SYMBOL_GPL(pagefault_enable);
 #endif

