Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2EEPJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:09:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:33125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab2EEPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:42 -0400
Message-Id: <20120505150141.491002124@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 04/18] fork: Provide kmemcache based thread_info allocator
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=fork-provide-kmemcache-based-thread-info-allocator.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures have their own kmemcache based thread allocator
because THREAD_SIZE is smaller than PAGE_SIZE. Add it to the core code
conditionally on THREAD_SIZE < PAGE_SIZE so the private copies can go.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/fork.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -132,6 +132,11 @@ static inline void free_task_struct(stru
 
 void __weak arch_release_thread_info(struct thread_info *ti) { }
 
+/*
+ * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
+ * kmemcache based allocator.
+ */
+# if THREAD_SIZE >= PAGE_SIZE
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
@@ -146,6 +151,28 @@ static inline void free_thread_info(stru
 	arch_release_thread_info(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
+# else
+static struct kmem_cache *thread_info_cache;
+
+static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
+						  int node)
+{
+	return kmem_cache_alloc_node(thread_info_cache, THREADINFO_GFP, node);
+}
+
+static void free_thread_info(struct thread_info *ti)
+{
+	arch_release_thread_info(ti);
+	kmem_cache_free(thread_info_cache, ti);
+}
+
+void thread_info_cache_init(void)
+{
+	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
+					      THREAD_SIZE, 0, NULL);
+	BUG_ON(thread_info_cache == NULL);
+}
+# endif
 #endif
 
 /* SLAB cache for signal_struct structures (tsk->signal) */


