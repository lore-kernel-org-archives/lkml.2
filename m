Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab1C3VoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:44:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873Ab1C3VHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447661"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: schwidefsky@de.ibm.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [127/275] s390: remove task_show_regs
Message-Id: <20110330210607.69BDD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/s390/include/asm/processor.h |    5 -----
 arch/s390/kernel/traps.c          |   37 -------------------------------------
 fs/proc/array.c                   |    3 ---
 3 files changed, 45 deletions(-)

Index: linux-2.6.35.y/arch/s390/include/asm/processor.h
===================================================================
--- linux-2.6.35.y.orig/arch/s390/include/asm/processor.h	2011-03-29 22:51:17.188283363 -0700
+++ linux-2.6.35.y/arch/s390/include/asm/processor.h	2011-03-29 23:03:00.876277749 -0700
@@ -150,11 +150,6 @@
  */
 extern unsigned long thread_saved_pc(struct task_struct *t);
 
-/*
- * Print register of task into buffer. Used in fs/proc/array.c.
- */
-extern void task_show_regs(struct seq_file *m, struct task_struct *task);
-
 extern void show_code(struct pt_regs *regs);
 
 unsigned long get_wchan(struct task_struct *p);
Index: linux-2.6.35.y/arch/s390/kernel/traps.c
===================================================================
--- linux-2.6.35.y.orig/arch/s390/kernel/traps.c	2011-03-29 22:51:17.188283363 -0700
+++ linux-2.6.35.y/arch/s390/kernel/traps.c	2011-03-29 23:03:00.892277339 -0700
@@ -237,43 +237,6 @@
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
Index: linux-2.6.35.y/fs/proc/array.c
===================================================================
--- linux-2.6.35.y.orig/fs/proc/array.c	2011-03-29 22:51:17.188283363 -0700
+++ linux-2.6.35.y/fs/proc/array.c	2011-03-29 23:53:59.507015039 -0700
@@ -353,9 +353,6 @@
 	task_cap(m, task);
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
-#if defined(CONFIG_S390)
-	task_show_regs(m, task);
-#endif
 	task_context_switch_counts(m, task);
 	return 0;
 }
