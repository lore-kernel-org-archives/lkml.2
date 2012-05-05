Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2EEPKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:10:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:33119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2EEPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:42 -0400
Message-Id: <20120505150141.366461660@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 02/18] fork: Provide weak
 arch_release_[task_struct|thread_info] functions
References: <20120505150007.543515803@linutronix.de>
Content-Disposition: inline;
 filename=fork-provide-arch-release-task-struct.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions allow us to move most of the duplicated thread_info
allocators to the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/fork.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: tip/kernel/fork.c
===================================================================
--- tip.orig/kernel/fork.c
+++ tip/kernel/fork.c
@@ -112,14 +112,26 @@ int nr_processes(void)
 }
 
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-# define alloc_task_struct_node(node)		\
-		kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node)
-# define free_task_struct(tsk)			\
-		kmem_cache_free(task_struct_cachep, (tsk))
 static struct kmem_cache *task_struct_cachep;
+
+static inline struct task_struct *alloc_task_struct_node(int node)
+{
+	return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
+}
+
+void __weak arch_release_task_struct(struct task_struct *tsk) { }
+
+static inline void free_task_struct(struct task_struct *tsk)
+{
+	arch_release_task_struct(tsk);
+	kmem_cache_free(task_struct_cachep, tsk);
+}
 #endif
 
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+void __weak arch_release_thread_info(struct thread_info *ti) { }
+
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
@@ -135,6 +147,7 @@ static struct thread_info *alloc_thread_
 
 static inline void free_thread_info(struct thread_info *ti)
 {
+	arch_release_thread_info(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 #endif


