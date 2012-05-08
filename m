Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2EHMq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:46:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2EHMq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:46:27 -0400
Date: Tue, 8 May 2012 05:46:13 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-f5e10287367dcffb5504d19c83e85ca041ca2596@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, tony.luck@intel.com
In-Reply-To: <20120505150142.371309416@linutronix.de>
References: <20120505150142.371309416@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] task_allocator:
  Use config switches instead of magic defines
Git-Commit-ID: f5e10287367dcffb5504d19c83e85ca041ca2596
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:46:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5e10287367dcffb5504d19c83e85ca041ca2596
Gitweb:     http://git.kernel.org/tip/f5e10287367dcffb5504d19c83e85ca041ca2596
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:46 +0200

task_allocator: Use config switches instead of magic defines

Replace __HAVE_ARCH_TASK_ALLOCATOR and __HAVE_ARCH_THREAD_ALLOCATOR
with proper config switches.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20120505150142.371309416@linutronix.de
---
 arch/Kconfig                            |    8 ++++++++
 arch/ia64/Kconfig                       |    2 ++
 arch/ia64/include/asm/thread_info.h     |    3 ---
 arch/sparc/Kconfig                      |    1 +
 arch/sparc/include/asm/thread_info_32.h |    2 --
 kernel/fork.c                           |    7 +++----
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 597b132..bd265a2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -152,6 +152,14 @@ config GENERIC_SMP_IDLE_THREAD
 config ARCH_INIT_TASK
        bool
 
+# Select if arch has its private alloc_task_struct() function
+config ARCH_TASK_STRUCT_ALLOCATOR
+	bool
+
+# Select if arch has its private alloc_thread_info() function
+config ARCH_THREAD_INFO_ALLOCATOR
+	bool
+
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 022ea3a..ba667b6 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -35,6 +35,8 @@ config IA64
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_INIT_TASK
+	select ARCH_TASK_STRUCT_ALLOCATOR
+	select ARCH_THREAD_INFO_ALLOCATOR
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index e054bcc..310d973 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -54,8 +54,6 @@ struct thread_info {
 	},					\
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #ifndef ASM_OFFSETS_C
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *) ((char *) current + IA64_TASK_SIZE))
@@ -84,7 +82,6 @@ struct thread_info {
 #endif
 #define end_of_stack(p) (unsigned long *)((void *)(p) + IA64_RBS_OFFSET)
 
-#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
 #define alloc_task_struct_node(node)						\
 ({										\
 	struct page *page = alloc_pages_node(node, GFP_KERNEL | __GFP_COMP,	\
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e417f35..ec0347a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -36,6 +36,7 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select ARCH_THREAD_INFO_ALLOCATOR
 
 config SPARC64
 	def_bool 64BIT
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index c2a1080..b29498d 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -80,8 +80,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
  */
 #define THREAD_INFO_ORDER  1
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info_node, int)
 #define alloc_thread_info_node(tsk, node) BTFIXUP_CALL(alloc_thread_info_node)(node)
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 7590bd6..a1793e4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -111,7 +111,7 @@ int nr_processes(void)
 	return total;
 }
 
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 static struct kmem_cache *task_struct_cachep;
 
 static inline struct task_struct *alloc_task_struct_node(int node)
@@ -128,8 +128,7 @@ static inline void free_task_struct(struct task_struct *tsk)
 }
 #endif
 
-#ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
+#ifndef CONFIG_ARCH_THREAD_INFO_ALLOCATOR
 void __weak arch_release_thread_info(struct thread_info *ti) { }
 
 /*
@@ -243,7 +242,7 @@ void __init __weak arch_task_cache_init(void) { }
 
 void __init fork_init(unsigned long mempages)
 {
-#ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+#ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
