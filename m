Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2EEPFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:33181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2EEPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:49 -0400
Message-Id: <20120505150142.371309416@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>
Subject: [patch 18/18] task_allocator: Use config switches instead of magic
 defines
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=task_allocator-use-config-switches-instead-of-magic-defines.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __HAVE_ARCH_TASK_ALLOCATOR and __HAVE_ARCH_THREAD_ALLOCATOR
with proper config switches.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/Kconfig                            |    8 ++++++++
 arch/ia64/Kconfig                       |    2 ++
 arch/ia64/include/asm/thread_info.h     |    3 ---
 arch/sparc/Kconfig                      |    1 +
 arch/sparc/include/asm/thread_info_32.h |    2 --
 kernel/fork.c                           |    7 +++----
 6 files changed, 14 insertions(+), 9 deletions(-)

Index: tip/arch/Kconfig
===================================================================
--- tip.orig/arch/Kconfig
+++ tip/arch/Kconfig
@@ -152,6 +152,14 @@ config GENERIC_SMP_IDLE_THREAD
 config ARCH_INIT_TASK
        bool
 
+# Select if arch has its private alloc_task_struct() function
+config ARCH_TASK_STRUCT_ALLOCATOR
+	bool
+
+# Select if arch has its private alloc_thread_info() function
+config ARCH_THREAD_INFO_ALLOCATOR
+	bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
Index: tip/arch/ia64/Kconfig
===================================================================
--- tip.orig/arch/ia64/Kconfig
+++ tip/arch/ia64/Kconfig
@@ -35,6 +35,8 @@ config IA64
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_INIT_TASK
+	select ARCH_TASK_STRUCT_ALLOCATOR
+	select ARCH_THREAD_INFO_ALLOCATOR
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: tip/arch/ia64/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/ia64/include/asm/thread_info.h
+++ tip/arch/ia64/include/asm/thread_info.h
@@ -54,8 +54,6 @@ struct thread_info {
 	},					\
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #ifndef ASM_OFFSETS_C
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *) ((char *) current + IA64_TASK_SIZE))
@@ -84,7 +82,6 @@ struct thread_info {
 #endif
 #define end_of_stack(p) (unsigned long *)((void *)(p) + IA64_RBS_OFFSET)
 
-#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
 #define alloc_task_struct_node(node)						\
 ({										\
 	struct page *page = alloc_pages_node(node, GFP_KERNEL | __GFP_COMP,	\
Index: tip/arch/sparc/Kconfig
===================================================================
--- tip.orig/arch/sparc/Kconfig
+++ tip/arch/sparc/Kconfig
@@ -36,6 +36,7 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select ARCH_THREAD_INFO_ALLOCATOR
 
 config SPARC64
 	def_bool 64BIT
Index: tip/arch/sparc/include/asm/thread_info_32.h
===================================================================
--- tip.orig/arch/sparc/include/asm/thread_info_32.h
+++ tip/arch/sparc/include/asm/thread_info_32.h
@@ -80,8 +80,6 @@ register struct thread_info *current_thr
  */
 #define THREAD_INFO_ORDER  1
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info_node, int)
 #define alloc_thread_info_node(tsk, node) BTFIXUP_CALL(alloc_thread_info_node)(node)
 
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -111,7 +111,7 @@ int nr_processes(void)
 	return total;
 }
 
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static struct kmem_cache *task_struct_cachep;
 
 static inline struct task_struct *alloc_task_struct_node(int node)
@@ -128,8 +128,7 @@ static inline void free_task_struct(stru
 }
 #endif
 
-#ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
+#ifndef CONFIG_ARCH_THREAD_INFO_ALLOCATOR
 void __weak arch_release_thread_info(struct thread_info *ti) { }
 
 /*
@@ -243,7 +242,7 @@ void __init __weak arch_task_cache_init(
 
 void __init fork_init(unsigned long mempages)
 {
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif


