Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2EEPJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:09:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2EEPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:44 -0400
Message-Id: <20120505150141.559556763@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: [patch 05/18] x86: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline; filename=x86-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference is the free_thread_info function, which frees
xstate.

Use the new arch_release_task_struct() function instead and switch
over to the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/include/asm/boot.h          |    2 +-
 arch/x86/include/asm/page_32_types.h |    4 ++--
 arch/x86/include/asm/page_64_types.h |    4 ++--
 arch/x86/include/asm/thread_info.h   |   20 +-------------------
 arch/x86/kernel/irq_32.c             |    8 ++++----
 arch/x86/kernel/process.c            |    5 ++---
 6 files changed, 12 insertions(+), 31 deletions(-)

Index: tip/arch/x86/include/asm/boot.h
===================================================================
--- tip.orig/arch/x86/include/asm/boot.h
+++ tip/arch/x86/include/asm/boot.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_X86_64
 #define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
 #else
-#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_ORDER)
+#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_SIZE_ORDER)
 #endif
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
Index: tip/arch/x86/include/asm/page_32_types.h
===================================================================
--- tip.orig/arch/x86/include/asm/page_32_types.h
+++ tip/arch/x86/include/asm/page_32_types.h
@@ -15,8 +15,8 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
-#define THREAD_ORDER	1
-#define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 #define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
Index: tip/arch/x86/include/asm/page_64_types.h
===================================================================
--- tip.orig/arch/x86/include/asm/page_64_types.h
+++ tip/arch/x86/include/asm/page_64_types.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
-#define THREAD_ORDER	1
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
 #define EXCEPTION_STACK_ORDER 0
Index: tip/arch/x86/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/x86/include/asm/thread_info.h
+++ tip/arch/x86/include/asm/thread_info.h
@@ -155,24 +155,6 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
-#endif
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#define alloc_thread_info_node(tsk, node)				\
-({									\
-	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
-					     THREAD_ORDER);		\
-	struct thread_info *ret = page ? page_address(page) : NULL;	\
-									\
-	ret;								\
-})
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
@@ -282,7 +264,7 @@ static inline bool is_ia32_task(void)
 
 #ifndef __ASSEMBLY__
 extern void arch_task_cache_init(void);
-extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern void arch_release_task_struct(struct task_struct *tsk);
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
Index: tip/arch/x86/kernel/irq_32.c
===================================================================
--- tip.orig/arch/x86/kernel/irq_32.c
+++ tip/arch/x86/kernel/irq_32.c
@@ -127,8 +127,8 @@ void __cpuinit irq_ctx_init(int cpu)
 		return;
 
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+					       THREADINFO_GFP,
+					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
@@ -137,8 +137,8 @@ void __cpuinit irq_ctx_init(int cpu)
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+					       THREADINFO_GFP,
+					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -76,10 +76,9 @@ void free_thread_xstate(struct task_stru
 	fpu_free(&tsk->thread.fpu);
 }
 
-void free_thread_info(struct thread_info *ti)
+void arch_release_task_struct(struct task_struct *tsk)
 {
-	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, THREAD_ORDER);
+	free_thread_xstate(tsk);
 }
 
 void arch_task_cache_init(void)


