Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2EHMmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:42:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2EHMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:42:14 -0400
Date: Tue, 8 May 2012 05:42:04 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-96c951179736eb59c5f66de2ac85af9e7a6a8b15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <20120505150142.059161130@linutronix.de>
References: <20120505150142.059161130@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] powerpc: Use common threadinfo allocator
Git-Commit-ID: 96c951179736eb59c5f66de2ac85af9e7a6a8b15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:42:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96c951179736eb59c5f66de2ac85af9e7a6a8b15
Gitweb:     http://git.kernel.org/tip/96c951179736eb59c5f66de2ac85af9e7a6a8b15
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

powerpc: Use common threadinfo allocator

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20120505150142.059161130@linutronix.de
---
 arch/powerpc/include/asm/thread_info.h |   13 -------------
 arch/powerpc/kernel/process.c          |   31 -------------------------------
 2 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 4a741c7..1a1bb00 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -62,21 +62,8 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
-/* thread information allocation */
-
-#if THREAD_SHIFT >= PAGE_SHIFT
-
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
-#else /* THREAD_SHIFT < PAGE_SHIFT */
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
-
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
-
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
 {
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 4937c96..aa05935 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1252,37 +1252,6 @@ void __ppc64_runlatch_off(void)
 }
 #endif /* CONFIG_PPC64 */
 
-#if THREAD_SHIFT < PAGE_SHIFT
-
-static struct kmem_cache *thread_info_cache;
-
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-	struct thread_info *ti;
-
-	ti = kmem_cache_alloc_node(thread_info_cache, GFP_KERNEL, node);
-	if (unlikely(ti == NULL))
-		return NULL;
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	memset(ti, 0, THREAD_SIZE);
-#endif
-	return ti;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	kmem_cache_free(thread_info_cache, ti);
-}
-
-void thread_info_cache_init(void)
-{
-	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
-					      THREAD_SIZE, 0, NULL);
-	BUG_ON(thread_info_cache == NULL);
-}
-
-#endif /* THREAD_SHIFT < PAGE_SHIFT */
-
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
