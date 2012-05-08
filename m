Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2EHMhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:37:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2EHMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:37:10 -0400
Date: Tue, 8 May 2012 05:37:00 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-38e7c572ce7310def003d8bb7c34260f5d8118cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120505150141.559556763@linutronix.de>
References: <20120505150141.559556763@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] x86: Use common threadinfo allocator
Git-Commit-ID: 38e7c572ce7310def003d8bb7c34260f5d8118cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:37:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38e7c572ce7310def003d8bb7c34260f5d8118cb
Gitweb:     http://git.kernel.org/tip/38e7c572ce7310def003d8bb7c34260f5d8118cb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:44 +0200

x86: Use common threadinfo allocator

The only difference is the free_thread_info function, which frees
xstate.

Use the new arch_release_task_struct() function instead and switch
over to the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120505150141.559556763@linutronix.de
Cc: x86@kernel.org
---
 arch/x86/include/asm/boot.h          |    2 +-
 arch/x86/include/asm/page_32_types.h |    4 ++--
 arch/x86/include/asm/page_64_types.h |    4 ++--
 arch/x86/include/asm/thread_info.h   |   20 +-------------------
 arch/x86/kernel/irq_32.c             |    8 ++++----
 arch/x86/kernel/process.c            |    5 ++---
 6 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 5e1a2ee..b13fe63 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_X86_64
 #define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
 #else
-#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_ORDER)
+#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT + THREAD_SIZE_ORDER)
 #endif
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index ade619f..ef17af0 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -15,8 +15,8 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
-#define THREAD_ORDER	1
-#define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 #define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 7639dbf..320f7bb 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
-#define THREAD_ORDER	1
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
 #define EXCEPTION_STACK_ORDER 0
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8692a16..73cfe0d 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -155,24 +155,6 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
-#else
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
-#endif
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#define alloc_thread_info_node(tsk, node)				\
-({									\
-	struct page *page = alloc_pages_node(node, THREAD_FLAGS,	\
-					     THREAD_ORDER);		\
-	struct thread_info *ret = page ? page_address(page) : NULL;	\
-									\
-	ret;								\
-})
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
@@ -282,7 +264,7 @@ static inline bool is_ia32_task(void)
 
 #ifndef __ASSEMBLY__
 extern void arch_task_cache_init(void);
-extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern void arch_release_task_struct(struct task_struct *tsk);
 #endif
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 58b7f27..344faf8 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -127,8 +127,8 @@ void __cpuinit irq_ctx_init(int cpu)
 		return;
 
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+					       THREADINFO_GFP,
+					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
@@ -137,8 +137,8 @@ void __cpuinit irq_ctx_init(int cpu)
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
 	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+					       THREADINFO_GFP,
+					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 8215458..e817315 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -76,10 +76,9 @@ void free_thread_xstate(struct task_struct *tsk)
 	fpu_free(&tsk->thread.fpu);
 }
 
-void free_thread_info(struct thread_info *ti)
+void arch_release_task_struct(struct task_struct *tsk)
 {
-	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, THREAD_ORDER);
+	free_thread_xstate(tsk);
 }
 
 void arch_task_cache_init(void)
