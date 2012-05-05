Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2EEPFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:33179 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2EEPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:49 -0400
Message-Id: <20120505150142.311126440@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 17/18] tile: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=tile-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the core allocator and deal with the extra cleanup in
arch_release_thread_info().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/thread_info.h |    6 ++----
 arch/tile/kernel/process.c          |   23 ++---------------------
 2 files changed, 4 insertions(+), 25 deletions(-)

Index: tip/arch/tile/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/tile/include/asm/thread_info.h
+++ tip/arch/tile/include/asm/thread_info.h
@@ -77,16 +77,14 @@ struct thread_info {
 
 #ifndef __ASSEMBLY__
 
+void arch_release_thread_info(struct thread_info *info);
+
 /* How to get the thread information struct from C. */
 register unsigned long stack_pointer __asm__("sp");
 
 #define current_thread_info() \
   ((struct thread_info *)(stack_pointer & -THREAD_SIZE))
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-extern struct thread_info *alloc_thread_info_node(struct task_struct *task, int node);
-extern void free_thread_info(struct thread_info *info);
-
 /* Sit on a nap instruction until interrupted. */
 extern void smp_nap(void);
 
Index: tip/arch/tile/kernel/process.c
===================================================================
--- tip.orig/arch/tile/kernel/process.c
+++ tip/arch/tile/kernel/process.c
@@ -114,27 +114,10 @@ void cpu_idle(void)
 	}
 }
 
-struct thread_info *alloc_thread_info_node(struct task_struct *task, int node)
-{
-	struct page *page;
-	gfp_t flags = GFP_KERNEL;
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	flags |= __GFP_ZERO;
-#endif
-
-	page = alloc_pages_node(node, flags, THREAD_SIZE_ORDER);
-	if (!page)
-		return NULL;
-
-	return (struct thread_info *)page_address(page);
-}
-
 /*
- * Free a thread_info node, and all of its derivative
- * data structures.
+ * Release a thread_info structure
  */
-void free_thread_info(struct thread_info *info)
+void arch_release_thread_info(struct thread_info *info)
 {
 	struct single_step_state *step_state = info->step_state;
 
@@ -169,8 +152,6 @@ void free_thread_info(struct thread_info
 		 */
 		kfree(step_state);
 	}
-
-	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
 }
 
 static void save_arch_state(struct thread_struct *t);


