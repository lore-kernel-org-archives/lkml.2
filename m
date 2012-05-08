Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2EHMem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:34:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2EHMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:34:41 -0400
Date: Tue, 8 May 2012 05:34:28 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-d909a81b198a397593495508c4a5755fe95552fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de
In-Reply-To: <20120505150142.311126440@linutronix.de>
References: <20120505150142.311126440@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] tile: Use common threadinfo allocator
Git-Commit-ID: d909a81b198a397593495508c4a5755fe95552fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:34:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d909a81b198a397593495508c4a5755fe95552fb
Gitweb:     http://git.kernel.org/tip/d909a81b198a397593495508c4a5755fe95552fb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 13:55:20 +0200

tile: Use common threadinfo allocator

Use the core allocator and deal with the extra cleanup in
arch_release_thread_info().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20120505150142.311126440@linutronix.de
---
 arch/tile/include/asm/thread_info.h |    6 ++----
 arch/tile/kernel/process.c          |   23 ++---------------------
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index bc4f562..c1cf8a8 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -77,16 +77,14 @@ struct thread_info {
 
 #ifndef __ASSEMBLY__
 
+void arch_release_thread_info(struct thread_info *info);
+
 /* How to get the thread information struct from C. */
 register unsigned long stack_pointer __asm__("sp");
 
 #define current_thread_info() \
   ((struct thread_info *)(stack_pointer & -THREAD_SIZE))
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-extern struct thread_info *alloc_thread_info_node(struct task_struct *task, int node);
-extern void free_thread_info(struct thread_info *info);
-
 /* Sit on a nap instruction until interrupted. */
 extern void smp_nap(void);
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 2d5ef61..efb9833 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -114,27 +114,10 @@ void cpu_idle(void)
 	}
 }
 
-struct thread_info *alloc_thread_info_node(struct task_struct *task, int node)
-{
-	struct page *page;
-	gfp_t flags = GFP_KERNEL;
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	flags |= __GFP_ZERO;
-#endif
-
-	page = alloc_pages_node(node, flags, THREAD_SIZE_ORDER);
-	if (!page)
-		return NULL;
-
-	return (struct thread_info *)page_address(page);
-}
-
 /*
- * Free a thread_info node, and all of its derivative
- * data structures.
+ * Release a thread_info structure
  */
-void free_thread_info(struct thread_info *info)
+void arch_release_thread_info(struct thread_info *info)
 {
 	struct single_step_state *step_state = info->step_state;
 
@@ -169,8 +152,6 @@ void free_thread_info(struct thread_info *info)
 		 */
 		kfree(step_state);
 	}
-
-	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
 }
 
 static void save_arch_state(struct thread_struct *t);
