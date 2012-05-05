Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2EEPHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:07:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:33162 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2EEPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:47 -0400
Message-Id: <20120505150142.059161130@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 13/18] powerpc: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=powerpc-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/thread_info.h |   13 -------------
 arch/powerpc/kernel/process.c          |   31 -------------------------------
 2 files changed, 44 deletions(-)

Index: tip/arch/powerpc/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/powerpc/include/asm/thread_info.h
+++ tip/arch/powerpc/include/asm/thread_info.h
@@ -62,21 +62,8 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
-/* thread information allocation */
-
-#if THREAD_SHIFT >= PAGE_SHIFT
-
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
-#else /* THREAD_SHIFT < PAGE_SHIFT */
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
-
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
-
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
 {
Index: tip/arch/powerpc/kernel/process.c
===================================================================
--- tip.orig/arch/powerpc/kernel/process.c
+++ tip/arch/powerpc/kernel/process.c
@@ -1252,37 +1252,6 @@ void __ppc64_runlatch_off(void)
 }
 #endif /* CONFIG_PPC64 */
 
-#if THREAD_SHIFT < PAGE_SHIFT
-
-static struct kmem_cache *thread_info_cache;
-
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-	struct thread_info *ti;
-
-	ti = kmem_cache_alloc_node(thread_info_cache, GFP_KERNEL, node);
-	if (unlikely(ti == NULL))
-		return NULL;
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	memset(ti, 0, THREAD_SIZE);
-#endif
-	return ti;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	kmem_cache_free(thread_info_cache, ti);
-}
-
-void thread_info_cache_init(void)
-{
-	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
-					      THREAD_SIZE, 0, NULL);
-	BUG_ON(thread_info_cache == NULL);
-}
-
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
-
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)


