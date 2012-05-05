Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2EEPJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:09:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33122 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab2EEPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:42 -0400
Message-Id: <20120505150141.428211694@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 03/18] fork: Move thread info gfp flags to header
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=fork-move-thread-info-gfp-flags-to-header.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These flags can be useful for extra allocations outside of the core
code.

Add __GFP_NOTRACE to them, so the archs which have kmemcheck do
not have to provide extra allocators just for that reason.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/thread_info.h |    6 ++++++
 kernel/fork.c               |    8 ++------
 2 files changed, 8 insertions(+), 6 deletions(-)

Index: tip/include/linux/thread_info.h
===================================================================
--- tip.orig/include/linux/thread_info.h
+++ tip/include/linux/thread_info.h
@@ -54,6 +54,12 @@ extern long do_no_restart_syscall(struct
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACE | __GFP_ZERO)
+#else
+# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACE)
+#endif
+
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -135,12 +135,8 @@ void __weak arch_release_thread_info(str
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
+	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
+					     THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
 }


