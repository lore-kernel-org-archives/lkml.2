Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0D1PVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:21:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50475 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0D1PVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:21:21 -0400
Date: Wed, 28 Apr 2010 10:21:18 -0500
From: Robin Holt <holt@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>, Stefani Seibold <stefani@seibold.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>
Subject: [Patch] Revert commit d899bf7b and its fixup commits -V1.
Message-ID: <20100428152118.GK5677@sgi.com>
References: <20100427185343.GR4920@sgi.com>
 <20100428085631.F835.A69D9226@jp.fujitsu.com>
 <20100428094516.GG5677@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428094516.GG5677@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Originally, commit d899bf7b attempted to introduce a new feature for
showing where the threadstack was located and how many pages are being
utilized by the stack.

Commit c44972f1 was applied to fix the NO_MMU case.

Commit 89240ba0 was applied to fix a bug in ia32 executables being loaded.

Commit 9ebd4eba7 was applied to fix a bug which had kernel threads
printing a userland stack address.

Commit 1306d603f was then applied to revert the stack pages being used
to solve a significant performance regression.

This patch nearly undoes the effect of all these patches.


The reason for reverting these is it provides an unusable value in
field 28.  For x86_64, a fork will result in the task->stack_start
value being updated to the current user top of stack and not the stack
start address.  This unpredictability of the stack_start value makes
it worthless.  That includes the intended use of showing how much stack
space a thread has.

Other architectures will get different values.  As an example, ia64
gets 0.  The do_fork() and copy_process() functions appear to treat the
stack_start and stack_size parameters as architecture specific.

I only partially reverted c44972f1.  If I had completely reverted it,
I would have had to change mm/Makefile only build pagewalk.o when
CONFIG_PROC_PAGE_MONITOR is configured.  Since I could not test the
builds without significant effort, I decided to not change mm/Makefile.

I only partially reverted 89240ba0.  I left the KSTK_ESP() change in
place as that seemed worthwhile.


Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

 Documentation/filesystems/proc.txt |    3 +--
 fs/compat.c                        |    2 --
 fs/exec.c                          |    2 --
 fs/proc/array.c                    |    3 +--
 fs/proc/task_mmu.c                 |   19 -------------------
 include/linux/sched.h              |    1 -
 kernel/fork.c                      |    2 --
 7 files changed, 2 insertions(+), 30 deletions(-)

Index: revert_stack_start_V1/Documentation/filesystems/proc.txt
===================================================================
--- revert_stack_start_V1.orig/Documentation/filesystems/proc.txt	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/Documentation/filesystems/proc.txt	2010-04-28 09:45:39.543654029 -0500
@@ -316,7 +316,7 @@ address           perms offset  dev   in
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [threadstack:001ff4b4]
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -352,7 +352,6 @@ is not associated with a file:
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
- [threadstack:xxxxxxxx]   = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
Index: revert_stack_start_V1/fs/compat.c
===================================================================
--- revert_stack_start_V1.orig/fs/compat.c	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/fs/compat.c	2010-04-28 09:45:39.547653405 -0500
@@ -1531,8 +1531,6 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->stack_start = current->mm->start_stack;
-
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
Index: revert_stack_start_V1/fs/exec.c
===================================================================
--- revert_stack_start_V1.orig/fs/exec.c	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/fs/exec.c	2010-04-28 09:45:39.575649084 -0500
@@ -1387,8 +1387,6 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->stack_start = current->mm->start_stack;
-
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
Index: revert_stack_start_V1/fs/proc/array.c
===================================================================
--- revert_stack_start_V1.orig/fs/proc/array.c	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/fs/proc/array.c	2010-04-28 09:45:39.611650788 -0500
@@ -81,7 +81,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
-#include <linux/swapops.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -495,7 +494,7 @@ static int do_task_stat(struct seq_file
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted && mm) ? task->stack_start : 0,
+		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
Index: revert_stack_start_V1/fs/proc/task_mmu.c
===================================================================
--- revert_stack_start_V1.orig/fs/proc/task_mmu.c	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/fs/proc/task_mmu.c	2010-04-28 09:45:39.643649777 -0500
@@ -247,25 +247,6 @@ static void show_map_vma(struct seq_file
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
 					name = "[stack]";
-				} else {
-					unsigned long stack_start;
-					struct proc_maps_private *pmp;
-
-					pmp = m->private;
-					stack_start = pmp->task->stack_start;
-
-					if (vma->vm_start <= stack_start &&
-					    vma->vm_end >= stack_start) {
-						pad_len_spaces(m, len);
-						seq_printf(m,
-						 "[threadstack:%08lx]",
-#ifdef CONFIG_STACK_GROWSUP
-						 vma->vm_end - stack_start
-#else
-						 stack_start - vma->vm_start
-#endif
-						);
-					}
 				}
 			} else {
 				name = "[vdso]";
Index: revert_stack_start_V1/include/linux/sched.h
===================================================================
--- revert_stack_start_V1.orig/include/linux/sched.h	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/include/linux/sched.h	2010-04-28 09:45:39.691648704 -0500
@@ -1497,7 +1497,6 @@ struct task_struct {
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-	unsigned long stack_start;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
Index: revert_stack_start_V1/kernel/fork.c
===================================================================
--- revert_stack_start_V1.orig/kernel/fork.c	2010-04-28 09:45:35.711399569 -0500
+++ revert_stack_start_V1/kernel/fork.c	2010-04-28 09:45:39.715648886 -0500
@@ -1114,8 +1114,6 @@ static struct task_struct *copy_process(
 
 	p->bts = NULL;
 
-	p->stack_start = stack_start;
-
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 
