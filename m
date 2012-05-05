Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2EEPIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:08:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:33147 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2EEPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:45 -0400
Message-Id: <20120505150141.812612113@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [patch 09/18] hexagon: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=hexagon-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/include/asm/thread_info.h |    8 -------
 arch/hexagon/kernel/process.c          |   37 ---------------------------------
 2 files changed, 45 deletions(-)

Index: tip/arch/hexagon/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/hexagon/include/asm/thread_info.h
+++ tip/arch/hexagon/include/asm/thread_info.h
@@ -31,15 +31,7 @@
 
 #define THREAD_SHIFT		12
 #define THREAD_SIZE		(1<<THREAD_SHIFT)
-
-#if THREAD_SHIFT >= PAGE_SHIFT
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
-#else  /*  don't use standard allocator  */
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
-#endif
-
 
 #ifndef __ASSEMBLY__
 
Index: tip/arch/hexagon/kernel/process.c
===================================================================
--- tip.orig/arch/hexagon/kernel/process.c
+++ tip/arch/hexagon/kernel/process.c
@@ -234,43 +234,6 @@ unsigned long get_wchan(struct task_stru
 }
 
 /*
- * Borrowed from PowerPC -- basically allow smaller kernel stacks if we
- * go crazy with the page sizes.
- */
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
-/*  Weak symbol; called by init/main.c  */
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
-/*
  * Required placeholder.
  */
 int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)


