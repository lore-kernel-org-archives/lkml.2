Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2EEPG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:06:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:33170 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2EEPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:48 -0400
Message-Id: <20120505150142.189348931@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [patch 15/18] sh: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline; filename=sh-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Deal with the xstate cleanup in the new arch_release_task_struct()
function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/thread_info.h |   10 --------
 arch/sh/kernel/process.c          |   46 +-------------------------------------
 2 files changed, 3 insertions(+), 53 deletions(-)

Index: tip/arch/sh/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/sh/include/asm/thread_info.h
+++ tip/arch/sh/include/asm/thread_info.h
@@ -88,21 +88,13 @@ static inline struct thread_info *curren
 	return ti;
 }
 
-/* thread information allocation */
-#if THREAD_SHIFT >= PAGE_SHIFT
-
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
-#endif
-
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern void arch_release_task_struct(struct task_struct *tsk);
 extern void init_thread_xstate(void);
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #endif /* __ASSEMBLY__ */
 
 /*
Index: tip/arch/sh/kernel/process.c
===================================================================
--- tip.orig/arch/sh/kernel/process.c
+++ tip/arch/sh/kernel/process.c
@@ -29,52 +29,10 @@ void free_thread_xstate(struct task_stru
 	}
 }
 
-#if THREAD_SHIFT < PAGE_SHIFT
-static struct kmem_cache *thread_info_cache;
-
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-	struct thread_info *ti;
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-
-	ti = kmem_cache_alloc_node(thread_info_cache, mask, node);
-	return ti;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	free_thread_xstate(ti->task);
-	kmem_cache_free(thread_info_cache, ti);
-}
-
-void thread_info_cache_init(void)
-{
-	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
-					      THREAD_SIZE, SLAB_PANIC, NULL);
-}
-#else
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
-
-	return page ? page_address(page) : NULL;
-}
-
-void free_thread_info(struct thread_info *ti)
+void arch_release_task_struct(struct task_struct *tsk)
 {
-	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	free_thread_xstate(tsk);
 }
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
 
 void arch_task_cache_init(void)
 {


