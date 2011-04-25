Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab1DYUvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:51:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34096 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab1DYUY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:29 -0400
Message-Id: <20110425200235.117646313@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 049/173] s390: remove task_show_regs
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 261cd298a8c363d7985e3482946edb4bfedacf98 upstream.

task_show_regs used to be a debugging aid in the early bringup days
of Linux on s390. /proc/<pid>/status is a world readable file, it
is not a good idea to show the registers of a process. The only
correct fix is to remove task_show_regs.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/include/asm/processor.h |    5 -----
 arch/s390/kernel/traps.c          |   37 -------------------------------------
 fs/proc/array.c                   |    3 ---
 3 files changed, 45 deletions(-)

--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -150,11 +150,6 @@ extern int kernel_thread(int (*fn)(void
  */
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
-/*
- * Print register of task into buffer. Used in fs/proc/array.c.
- */
-extern void task_show_regs(struct seq_file *m, struct task_struct *task);
-
 extern void show_code(struct pt_regs *regs);
 
 unsigned long get_wchan(struct task_struct *p);
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -243,43 +243,6 @@ void show_regs(struct pt_regs *regs)
 	show_last_breaking_event(regs);
 }
 
-/* This is called from fs/proc/array.c */
-void task_show_regs(struct seq_file *m, struct task_struct *task)
-{
-	struct pt_regs *regs;
-
-	regs = task_pt_regs(task);
-	seq_printf(m, "task: %p, ksp: %p\n",
-		       task, (void *)task->thread.ksp);
-	seq_printf(m, "User PSW : %p %p\n",
-		       (void *) regs->psw.mask, (void *)regs->psw.addr);
-
-	seq_printf(m, "User GPRS: " FOURLONG,
-			  regs->gprs[0], regs->gprs[1],
-			  regs->gprs[2], regs->gprs[3]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[4], regs->gprs[5],
-			  regs->gprs[6], regs->gprs[7]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[8], regs->gprs[9],
-			  regs->gprs[10], regs->gprs[11]);
-	seq_printf(m, "           " FOURLONG,
-			  regs->gprs[12], regs->gprs[13],
-			  regs->gprs[14], regs->gprs[15]);
-	seq_printf(m, "User ACRS: %08x %08x %08x %08x\n",
-			  task->thread.acrs[0], task->thread.acrs[1],
-			  task->thread.acrs[2], task->thread.acrs[3]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[4], task->thread.acrs[5],
-			  task->thread.acrs[6], task->thread.acrs[7]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[8], task->thread.acrs[9],
-			  task->thread.acrs[10], task->thread.acrs[11]);
-	seq_printf(m, "           %08x %08x %08x %08x\n",
-			  task->thread.acrs[12], task->thread.acrs[13],
-			  task->thread.acrs[14], task->thread.acrs[15]);
-}
-
 static DEFINE_SPINLOCK(die_lock);
 
 void die(const char * str, struct pt_regs * regs, long err)
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -336,9 +336,6 @@ int proc_pid_status(struct seq_file *m,
 	task_sig(m, task);
 	task_cap(m, task);
 	cpuset_task_status_allowed(m, task);
-#if defined(CONFIG_S390)
-	task_show_regs(m, task);
-#endif
 	task_context_switch_counts(m, task);
 	return 0;
 }


