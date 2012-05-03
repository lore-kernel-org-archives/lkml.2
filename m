Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab2ECJLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:11:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:49887 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab2ECJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:50 -0400
Message-Id: <20120503085034.032327158@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: [patch V2 03/31] task_allocator: Use config switches instead of magic
 defines
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=task-alloc-use-config-switch.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __HAVE_ARCH_TASK_ALLOCATOR and __HAVE_ARCH_THREAD_ALLOCATOR
with proper config switches.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/Kconfig                        |    6 ++++++
 arch/frv/Kconfig                    |    1 +
 arch/frv/include/asm/thread_info.h  |    2 --
 arch/ia64/Kconfig                   |    2 ++
 arch/ia64/include/asm/thread_info.h |    3 ---
 kernel/fork.c                       |    6 +++---
 6 files changed, 12 insertions(+), 8 deletions(-)

Index: tip/arch/Kconfig
===================================================================
--- tip.orig/arch/Kconfig
+++ tip/arch/Kconfig
@@ -219,4 +219,10 @@ config HAVE_CMPXCHG_DOUBLE
 config ARCH_WANT_OLD_COMPAT_IPC
 	bool
 
+config ARCH_TASK_STRUCT_ALLOCATOR
+	bool
+
+config ARCH_THREAD_INFO_ALLOCATOR
+	bool
+
 source "kernel/gcov/Kconfig"
Index: tip/arch/frv/Kconfig
===================================================================
--- tip.orig/arch/frv/Kconfig
+++ tip/arch/frv/Kconfig
@@ -9,6 +9,7 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
+	select ARCH_THREAD_INFO_ALLOCATOR
 
 config ZONE_DMA
 	bool
Index: tip/arch/frv/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/frv/include/asm/thread_info.h
+++ tip/arch/frv/include/asm/thread_info.h
@@ -80,8 +80,6 @@ register struct thread_info *__current_t
 
 #define current_thread_info() ({ __current_thread_info; })
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info_node(tsk, node)			\
Index: tip/arch/ia64/Kconfig
===================================================================
--- tip.orig/arch/ia64/Kconfig
+++ tip/arch/ia64/Kconfig
@@ -34,6 +34,8 @@ config IA64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
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
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -111,7 +111,7 @@ int nr_processes(void)
 	return total;
 }
 
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 # define alloc_task_struct_node(node)		\
 		kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node)
 # define free_task_struct(tsk)			\
@@ -119,7 +119,7 @@ int nr_processes(void)
 static struct kmem_cache *task_struct_cachep;
 #endif
 
-#ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+#ifndef CONFIG_ARCH_THREAD_INFO_ALLOCATOR
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
@@ -213,7 +213,7 @@ EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif


