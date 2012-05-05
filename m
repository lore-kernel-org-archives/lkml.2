Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2EEPIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:08:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:33156 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2EEPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:46 -0400
Message-Id: <20120505150141.996582377@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 12/18] mn10300: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=mn10300-use-common-threadinfo-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core code allocate and handle the kgdb cleanup with the
arch_release_thread_info() function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/include/asm/thread_info.h |   17 +++--------------
 arch/mn10300/kernel/kgdb.c             |    3 +--
 2 files changed, 4 insertions(+), 16 deletions(-)

Index: tip/arch/mn10300/include/asm/thread_info.h
===================================================================
--- tip.orig/arch/mn10300/include/asm/thread_info.h
+++ tip/arch/mn10300/include/asm/thread_info.h
@@ -20,8 +20,10 @@
 
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		(4096)
+#define THREAD_SIZE_ORDER	(0)
 #else
 #define THREAD_SIZE		(8192)
+#define THREAD_SIZE_ORDER	(1)
 #endif
 
 #define STACK_WARN		(THREAD_SIZE / 8)
@@ -120,21 +122,8 @@ static inline unsigned long current_stac
 	return sp;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info_node(tsk, node)			\
-		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#else
-#define alloc_thread_info_node(tsk, node)			\
-		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#endif
-
 #ifndef CONFIG_KGDB
-#define free_thread_info(ti)	kfree((ti))
-#else
-extern void free_thread_info(struct thread_info *);
+void arch_release_thread_info(struct thread_info *ti)
 #endif
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
Index: tip/arch/mn10300/kernel/kgdb.c
===================================================================
--- tip.orig/arch/mn10300/kernel/kgdb.c
+++ tip/arch/mn10300/kernel/kgdb.c
@@ -397,7 +397,7 @@ static bool kgdb_arch_undo_singlestep(st
  * single-step state is cleared.  At this point the breakpoints should have
  * been removed by __switch_to().
  */
-void free_thread_info(struct thread_info *ti)
+void arch_release_thread_info(struct thread_info *ti)
 {
 	if (kgdb_sstep_thread == ti) {
 		kgdb_sstep_thread = NULL;
@@ -407,7 +407,6 @@ void free_thread_info(struct thread_info
 		 * so force immediate reentry */
 		kgdb_breakpoint();
 	}
-	kfree(ti);
 }
 
 /*


