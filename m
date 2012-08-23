Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab2HWPjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:39:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42834 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2HWPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:39:13 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v2] fork: fix oops after fork failure
Date: Thu, 23 Aug 2012 19:36:08 +0400
Message-Id: <1345736168-1990-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to duplicate a new process, dup_task_struct() will undergo
a series of allocations. If alloc_thread_info_node() fails, we call
free_task_struct() and return.

This seems right, but it is not. free_task_struct() will not only free
the task struct from the kmem_cache, but will also call
arch_release_task_struct(). The problem is that this function is
supposed to undo whatever arch-specific work done by
arch_dup_task_struct(), that is not yet called at this point.  The
particular problem I ran accross was that in x86, we will arrive at
fpu_free() without having ever allocated it.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Frederic Weisbecker <fweisbec@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/asm/thread_info.h | 2 +-
 kernel/fork.c                       | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index f7ee853..62452bd 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -90,7 +90,7 @@ struct thread_info {
 										\
 	ret;									\
 })
-#define free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
+#define __free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
 
 #endif /* !__ASSEMBLY */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 152d023..76acb1a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -124,10 +124,15 @@ static inline struct task_struct *alloc_task_struct_node(int node)
 
 void __weak arch_release_task_struct(struct task_struct *tsk) { }
 
+static inline void __free_task_struct(struct task_struct *tsk)
+{
+	kmem_cache_free(task_struct_cachep, tsk);
+}
+
 static inline void free_task_struct(struct task_struct *tsk)
 {
 	arch_release_task_struct(tsk);
-	kmem_cache_free(task_struct_cachep, tsk);
+	__free_task_struct(tsk);
 }
 #endif
 
@@ -299,7 +304,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	ti = alloc_thread_info_node(tsk, node);
 	if (!ti) {
-		free_task_struct(tsk);
+		__free_task_struct(tsk);
 		return NULL;
 	}
 
-- 
1.7.11.4

