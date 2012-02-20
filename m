Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2BTVUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:20:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab2BTVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:20:14 -0500
Date: Mon, 20 Feb 2012 13:19:33 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-4pr1xnnksprt7t0h3w5fw4rv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x86: Factor out TIF_IA32 from 32-bit address space
Git-Commit-ID: 6bd330083e0e97b7ddc053459190bf3d5768ca83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:20:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bd330083e0e97b7ddc053459190bf3d5768ca83
Gitweb:     http://git.kernel.org/tip/6bd330083e0e97b7ddc053459190bf3d5768ca83
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 6 Feb 2012 13:03:09 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 20 Feb 2012 12:48:46 -0800

x86: Factor out TIF_IA32 from 32-bit address space

Factor out IA32 (compatibility instruction set) from 32-bit address
space in the thread_info flags; this is a precondition patch for x32
support.

Originally-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-4pr1xnnksprt7t0h3w5fw4rv@git.kernel.org
---
 arch/x86/include/asm/elf.h         |    4 ++--
 arch/x86/include/asm/processor.h   |    4 ++--
 arch/x86/include/asm/thread_info.h |    4 +++-
 arch/x86/kernel/process_64.c       |    2 ++
 arch/x86/kernel/sys_x86_64.c       |    6 +++---
 arch/x86/oprofile/backtrace.c      |    2 +-
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 5f962df..410fa6a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -287,7 +287,7 @@ do {									\
 #define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
 
 /* 1GB for 64bit, 8MB for 32bit */
-#define STACK_RND_MASK (test_thread_flag(TIF_IA32) ? 0x7ff : 0x3fffff)
+#define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
 
 #define ARCH_DLINFO							\
 do {									\
@@ -330,7 +330,7 @@ static inline int mmap_is_ia32(void)
 	return 1;
 #endif
 #ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
+	if (test_thread_flag(TIF_ADDR32))
 		return 1;
 #endif
 	return 0;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..9f748b5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -924,9 +924,9 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 #define IA32_PAGE_OFFSET	((current->personality & ADDR_LIMIT_3GB) ? \
 					0xc0000000 : 0xFFFFe000)
 
-#define TASK_SIZE		(test_thread_flag(TIF_IA32) ? \
+#define TASK_SIZE		(test_thread_flag(TIF_ADDR32) ? \
 					IA32_PAGE_OFFSET : TASK_SIZE_MAX)
-#define TASK_SIZE_OF(child)	((test_tsk_thread_flag(child, TIF_IA32)) ? \
+#define TASK_SIZE_OF(child)	((test_tsk_thread_flag(child, TIF_ADDR32)) ? \
 					IA32_PAGE_OFFSET : TASK_SIZE_MAX)
 
 #define STACK_TOP		TASK_SIZE
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index bc817cd..d1803a4 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -86,7 +86,7 @@ struct thread_info {
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
-#define TIF_IA32		17	/* 32bit process */
+#define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
@@ -95,6 +95,7 @@ struct thread_info {
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -116,6 +117,7 @@ struct thread_info {
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
+#define _TIF_ADDR32		(1 << TIF_ADDR32)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..0e900d0 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -508,6 +508,7 @@ void set_personality_64bit(void)
 
 	/* Make sure to be in 64bit mode */
 	clear_thread_flag(TIF_IA32);
+	clear_thread_flag(TIF_ADDR32);
 
 	/* Ensure the corresponding mm is not marked. */
 	if (current->mm)
@@ -526,6 +527,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
+	set_thread_flag(TIF_ADDR32);
 	current->personality |= force_personality32;
 
 	/* Mark the associated mm as containing 32-bit tasks. */
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 0514890..f921df8 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -98,7 +98,7 @@ out:
 static void find_start_end(unsigned long flags, unsigned long *begin,
 			   unsigned long *end)
 {
-	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT)) {
+	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT)) {
 		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
@@ -144,7 +144,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
-	if (((flags & MAP_32BIT) || test_thread_flag(TIF_IA32))
+	if (((flags & MAP_32BIT) || test_thread_flag(TIF_ADDR32))
 	    && len <= mm->cached_hole_size) {
 		mm->cached_hole_size = 0;
 		mm->free_area_cache = begin;
@@ -205,7 +205,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		return addr;
 
 	/* for MAP_32BIT mappings we force the legact mmap base */
-	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
+	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT))
 		goto bottomup;
 
 	/* requesting a specific address */
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index bff89df..d6aa6e8 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -67,7 +67,7 @@ x86_backtrace_32(struct pt_regs * const regs, unsigned int depth)
 {
 	struct stack_frame_ia32 *head;
 
-	/* User process is 32-bit */
+	/* User process is IA32 */
 	if (!current || !test_thread_flag(TIF_IA32))
 		return 0;
 
