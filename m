Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2EEPFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:33133 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2EEPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:44 -0400
Message-Id: <20120505150141.681236240@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 07/18] cris: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=cris-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no functional difference. __get_free_pages() ends up calling
alloc_pages_node().

This also allocates only one page which matches THREAD_SIZE instead of
an extra page for nothing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/asm/processor.h   |    5 ++---
 arch/cris/include/asm/thread_info.h |    6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

Index: tip/arch/cris/include/asm/processor.h
===================================================================
--- tip.orig/arch/cris/include/asm/processor.h
+++ tip/arch/cris/include/asm/processor.h
@@ -25,13 +25,12 @@ struct task_struct;
  */
 #define TASK_UNMAPPED_BASE      (PAGE_ALIGN(TASK_SIZE / 3))
 
-/* THREAD_SIZE is the size of the task_struct/kernel_stack combo.
+/* THREAD_SIZE is the size of the thread_info/kernel_stack combo.
  * normally, the stack is found by doing something like p + THREAD_SIZE
  * in CRIS, a page is 8192 bytes, which seems like a sane size
  */
-
 #define THREAD_SIZE       PAGE_SIZE
-#define KERNEL_STACK_SIZE PAGE_SIZE
+#define THREAD_SIZE_ORDER (0)
 
 /*
  * At user->kernel entry, the pt_regs struct is stacked on the top of the kernel-stack.
Index: tip/arch/cris/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/cris/include/asm/thread_info.h
+++ tip/arch/cris/include/asm/thread_info.h
@@ -65,12 +65,6 @@ struct thread_info {
 
 #define init_thread_info	(init_thread_union.thread_info)
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-/* thread information allocation */
-#define alloc_thread_info_node(tsk, node)	\
-	((struct thread_info *) __get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
-
 #endif /* !__ASSEMBLY__ */
 
 /*


