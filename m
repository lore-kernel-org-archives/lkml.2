Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2EHMn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:43:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2EHMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:43:57 -0400
Date: Tue, 8 May 2012 05:43:43 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-df9a7b9b5d1a5ef8cd3474d0cea2c6428542e288@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20120505150142.189348931@linutronix.de>
References: <20120505150142.189348931@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sh-use-common-threadinfo-allocator
Git-Commit-ID: df9a7b9b5d1a5ef8cd3474d0cea2c6428542e288
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:43:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df9a7b9b5d1a5ef8cd3474d0cea2c6428542e288
Gitweb:     http://git.kernel.org/tip/df9a7b9b5d1a5ef8cd3474d0cea2c6428542e288
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

sh-use-common-threadinfo-allocator

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Deal with the xstate cleanup in the new arch_release_task_struct()
function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120505150142.189348931@linutronix.de
---
 arch/sh/include/asm/thread_info.h |   10 +-------
 arch/sh/kernel/process.c          |   46 +-----------------------------------
 2 files changed, 3 insertions(+), 53 deletions(-)

diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 09963d4..b690206 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -88,21 +88,13 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-/* thread information allocation */
-#if THREAD_SHIFT >= PAGE_SHIFT
-
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
-#endif
-
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
 extern void arch_task_cache_init(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern void arch_release_task_struct(struct task_struct *tsk);
 extern void init_thread_xstate(void);
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index 325f98b..f2621ab 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -29,52 +29,10 @@ void free_thread_xstate(struct task_struct *tsk)
 	}
 }
 
-#if THREAD_SHIFT < PAGE_SHIFT
-static struct kmem_cache *thread_info_cache;
-
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-	struct thread_info *ti;
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-
-	ti = kmem_cache_alloc_node(thread_info_cache, mask, node);
-	return ti;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	free_thread_xstate(ti->task);
-	kmem_cache_free(thread_info_cache, ti);
-}
-
-void thread_info_cache_init(void)
-{
-	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
-					      THREAD_SIZE, SLAB_PANIC, NULL);
-}
-#else
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
-
-	return page ? page_address(page) : NULL;
-}
-
-void free_thread_info(struct thread_info *ti)
+void arch_release_task_struct(struct task_struct *tsk)
 {
-	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	free_thread_xstate(tsk);
 }
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
 
 void arch_task_cache_init(void)
 {
