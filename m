Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2EHMnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:43:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2EHMnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:43:05 -0400
Date: Tue, 8 May 2012 05:42:54 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c03a6a7ba6f456663e4b254cdde460b24c0852e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120505150141.996582377@linutronix.de>
References: <20120505150141.996582377@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mn10300: Use common threadinfo allocator
Git-Commit-ID: c03a6a7ba6f456663e4b254cdde460b24c0852e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:42:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c03a6a7ba6f456663e4b254cdde460b24c0852e1
Gitweb:     http://git.kernel.org/tip/c03a6a7ba6f456663e4b254cdde460b24c0852e1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:45 +0200

mn10300: Use common threadinfo allocator

Let the core code allocate and handle the kgdb cleanup with the
arch_release_thread_info() function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120505150141.996582377@linutronix.de
---
 arch/mn10300/include/asm/thread_info.h |   17 +++--------------
 arch/mn10300/kernel/kgdb.c             |    3 +--
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 28cf521..08251d6 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -20,8 +20,10 @@
 
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE		(4096)
+#define THREAD_SIZE_ORDER	(0)
 #else
 #define THREAD_SIZE		(8192)
+#define THREAD_SIZE_ORDER	(1)
 #endif
 
 #define STACK_WARN		(THREAD_SIZE / 8)
@@ -120,21 +122,8 @@ static inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info_node(tsk, node)			\
-		kzalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#else
-#define alloc_thread_info_node(tsk, node)			\
-		kmalloc_node(THREAD_SIZE, GFP_KERNEL, node)
-#endif
-
 #ifndef CONFIG_KGDB
-#define free_thread_info(ti)	kfree((ti))
-#else
-extern void free_thread_info(struct thread_info *);
+void arch_release_thread_info(struct thread_info *ti)
 #endif
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)
diff --git a/arch/mn10300/kernel/kgdb.c b/arch/mn10300/kernel/kgdb.c
index f6c981d..9977082 100644
--- a/arch/mn10300/kernel/kgdb.c
+++ b/arch/mn10300/kernel/kgdb.c
@@ -397,7 +397,7 @@ static bool kgdb_arch_undo_singlestep(struct pt_regs *regs)
  * single-step state is cleared.  At this point the breakpoints should have
  * been removed by __switch_to().
  */
-void free_thread_info(struct thread_info *ti)
+void arch_release_thread_info(struct thread_info *ti)
 {
 	if (kgdb_sstep_thread == ti) {
 		kgdb_sstep_thread = NULL;
@@ -407,7 +407,6 @@ void free_thread_info(struct thread_info *ti)
 		 * so force immediate reentry */
 		kgdb_breakpoint();
 	}
-	kfree(ti);
 }
 
 /*
