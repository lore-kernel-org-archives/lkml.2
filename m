Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0DPShY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 14:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab0DPShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 14:37:22 -0400
Date: Fri, 16 Apr 2010 14:37:19 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
       anderson@redhat.com, esandeen@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100416183719.8100.12732.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: Write STACK_END_MAGIC to the init_task's stack
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tasks set STACK_END_MAGIC at the end of the stack to catch stack overruns and
corruption of the stack.  The only task that does not set the magic value is
the init_task.

Set the init_task's end of stack to the magic value and remove the conditional
in no_context().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f627779..8f4e2ac 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -659,7 +659,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
+	if (*stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
diff --git a/include/linux/stackprotector.h b/include/linux/stackprotector.h
index 6f3e54c..fefdfdd 100644
--- a/include/linux/stackprotector.h
+++ b/include/linux/stackprotector.h
@@ -13,4 +13,5 @@ static inline void boot_init_stack_canary(void)
 }
 #endif
 
+void task_stack_end_magic(struct task_struct *tsk);
 #endif
diff --git a/init/main.c b/init/main.c
index 5c85402..a054403 100644
--- a/init/main.c
+++ b/init/main.c
@@ -530,6 +530,7 @@ asmlinkage void __init start_kernel(void)
 	char * command_line;
 	extern struct kernel_param __start___param[], __stop___param[];
 
+	task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..66b8928 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -65,6 +65,7 @@
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
+#include <linux/stackprotector.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -227,11 +228,18 @@ int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+void task_stack_end_magic(struct task_struct *tsk)
+{
+	unsigned long *stackend;
+
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+}
+
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
-	unsigned long *stackend;
 
 	int err;
 
@@ -259,8 +267,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
-	stackend = end_of_stack(tsk);
-	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+	task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
