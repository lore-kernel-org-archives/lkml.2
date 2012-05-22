Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2EVPL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:11:27 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:33987 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2EVPLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:11:25 -0400
Date: Tue, 22 May 2012 17:11:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc32: use the common implementation of
	alloc_thread_info_node()
Message-ID: <20120522151123.GA10058@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 52d8a6d1b81a19e693a09df90275600f44293f43 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 22 May 2012 16:39:00 +0200
Subject: [PATCH] sparc32: use the common implementation of alloc_thread_info_node()

With sun4c removed we can fall-back to the common implementation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

This is not a "real" bug but I would like it applied anyway.
Thomas Gleixner <tglx@linutronix.de> consolidated all
alloc_thread_info_node() implmentations but sparc32 was
left out due to sun4c weirdness.

With sun4c gone we can align with the rest of the world.
(and I promised Thomas to follow-up on this when his patch-set was merged).

This patch is on top of:
bf67f3a5c456a18f2e8d062f7e88506ef2cd9837 ("Merge branch
'smp-hotplug-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

	Sam

 arch/sparc/Kconfig                      |    1 -
 arch/sparc/include/asm/thread_info_32.h |   11 ++---------
 arch/sparc/mm/srmmu.c                   |   27 ---------------------------
 3 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b2b9daf..5af013f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -37,7 +37,6 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
-	select ARCH_THREAD_INFO_ALLOCATOR
 
 config SPARC64
 	def_bool 64BIT
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 21a3894..5af6649 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -77,18 +77,11 @@ register struct thread_info *current_thread_info_reg asm("g6");
 /*
  * thread information allocation
  */
-#define THREAD_INFO_ORDER  1
-
-struct thread_info * alloc_thread_info_node(struct task_struct *tsk, int node);
-void free_thread_info(struct thread_info *);
+#define THREAD_SIZE_ORDER  1
 
 #endif /* __ASSEMBLY__ */
 
-/*
- * Size of kernel stack for each process.
- * Observe the order of get_free_pages() in alloc_thread_info_node().
- * The sun4 has 8K stack too, because it's short on memory, and 16K is a waste.
- */
+/* Size of kernel stack for each process */
 #define THREAD_SIZE		(2 * PAGE_SIZE)
 
 /*
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 8e97e03..256db6b 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -467,33 +467,6 @@ void srmmu_unmapiorange(unsigned long virt_addr, unsigned int len)
 	flush_tlb_all();
 }
 
-/*
- * On the SRMMU we do not have the problems with limited tlb entries
- * for mapping kernel pages, so we just take things from the free page
- * pool.  As a side effect we are putting a little too much pressure
- * on the gfp() subsystem.  This setup also makes the logic of the
- * iommu mapping code a lot easier as we can transparently handle
- * mappings on the kernel stack without any special code.
- */
-struct thread_info *alloc_thread_info_node(struct task_struct *tsk, int node)
-{
-	struct thread_info *ret;
-
-	ret = (struct thread_info *)__get_free_pages(GFP_KERNEL,
-						     THREAD_INFO_ORDER);
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	if (ret)
-		memset(ret, 0, PAGE_SIZE << THREAD_INFO_ORDER);
-#endif /* DEBUG_STACK_USAGE */
-
-	return ret;
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	free_pages((unsigned long)ti, THREAD_INFO_ORDER);
-}
-
 /* tsunami.S */
 extern void tsunami_flush_cache_all(void);
 extern void tsunami_flush_cache_mm(struct mm_struct *mm);
-- 
1.6.0.6

