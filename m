Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2EHMke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:40:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2EHMkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:40:32 -0400
Date: Tue, 8 May 2012 05:40:22 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-fe844052bca4355bf1a1b078d3e7727800cf3c73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rkuo@codeaurora.org
In-Reply-To: <20120505150141.812612113@linutronix.de>
References: <20120505150141.812612113@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] hexagon: Use common threadinfo allocator
Git-Commit-ID: fe844052bca4355bf1a1b078d3e7727800cf3c73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:40:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe844052bca4355bf1a1b078d3e7727800cf3c73
Gitweb:     http://git.kernel.org/tip/fe844052bca4355bf1a1b078d3e7727800cf3c73
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

hexagon: Use common threadinfo allocator

The core now has a threadinfo allocator which uses a kmemcache when
THREAD_SIZE < PAGE_SIZE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
Link: http://lkml.kernel.org/r/20120505150141.812612113@linutronix.de
---
 arch/hexagon/include/asm/thread_info.h |    8 -------
 arch/hexagon/kernel/process.c          |   37 --------------------------------
 2 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index 9c2934f..4f936a7 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -31,15 +31,7 @@
 
 #define THREAD_SHIFT		12
 #define THREAD_SIZE		(1<<THREAD_SHIFT)
-
-#if THREAD_SHIFT >= PAGE_SHIFT
 #define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
-#else  /*  don't use standard allocator  */
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-extern struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node);
-extern void free_thread_info(struct thread_info *ti);
-#endif
-
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index ff02821..af51de6 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -234,43 +234,6 @@ unsigned long get_wchan(struct task_struct *p)
 }
 
 /*
- * Borrowed from PowerPC -- basically allow smaller kernel stacks if we
- * go crazy with the page sizes.
- */
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
-/*  Weak symbol; called by init/main.c  */
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
-/*
  * Required placeholder.
  */
 int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
