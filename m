Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2JDKjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab2JDKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:39:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] perf x86_64: Fix rsp register for system call fast path
Date: Thu,  4 Oct 2012 12:38:44 +0200
Message-Id: <1349347125-5770-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349347125-5770-1-git-send-email-jolsa@redhat.com>
References: <20121003133007.GD945@krava.brq.redhat.com>
 <1349347125-5770-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user level rsp register value attached to the sample is crucial
for proper user stack dump and for proper dwarf backtrace post unwind.

But currently, if the event happens within the system call fast path,
we don't store proper rsp register value in the event sample.

The reason is that the syscall fast path stores just minimal set of
registers to the task's struct pt_regs area. The rsp itself is stored
in per cpu variable 'old_rsp'.

This patch fixes this rsp register value based on the:
- 'old_rsp' per cpu variable
(updated within the syscall fast path)
- guess on how we got into the kernel - syscall or interrupt
(via pt_regs::orig_ax value)
We can use 'old_rsp' value only if we are inside the syscall.
Thanks to Oleg who outlined this solution!

Above guess introduces 2 race windows (fully desccribed within the patch
comments), where we might get incorrect user level rsp value stored in
sample. However, in comparison with system call fast path length, we still
get much more precise rsp values than without the patch.

Note, that we use statically allocated pt_regs inside the sample data when
we need to change it. In other cases we still use the pt_regs pointer.

Example of syscall fast path dwarf backtrace unwind:
(perf record -e cycles -g dwarf ls; perf report --stdio)

Before the patch applied:

--23.76%-- preempt_schedule_irq
	 retint_kernel
	 tty_ldisc_deref
	 tty_write
	 vfs_write
	 sys_write
	 system_call_fastpath
	 __GI___libc_write
	 0x6

With the patch applied:

--12.37%-- finish_task_switch
	 __schedule
	 preempt_schedule
	 queue_work
	 schedule_work
	 tty_flip_buffer_push
	 pty_write
	 n_tty_write
	 tty_write
	 vfs_write
	 sys_write
	 system_call_fastpath
	 __GI___libc_write
	 _IO_file_write@@GLIBC_2.2.5
	 new_do_write
	 _IO_do_write@@GLIBC_2.2.5
	 _IO_file_overflow@@GLIBC_2.2.5
	 print_current_files
	 main
	 __libc_start_main
	 _start

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h       |    1 +
 kernel/events/core.c             |   10 ++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..834fe96 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -34,6 +34,7 @@
 #include <asm/timer.h>
 #include <asm/desc.h>
 #include <asm/ldt.h>
+#include <asm/syscall.h>
 
 #include "perf_event.h"
 
@@ -1699,6 +1700,42 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 }
 
+#ifdef CONFIG_X86_64
+void arch_sample_regs_user_fixup(struct perf_regs_user *uregs, int kernel)
+{
+	/*
+	 * If the perf event was triggered within the kernel code
+	 * path, then it was either syscall or interrupt. While
+	 * interrupt stores almost all user registers, the syscall
+	 * fast path does not. At this point we can at least set
+	 * rsp register right, which is crucial for dwarf unwind.
+	 *
+	 * The syscall_get_nr function returns -1 (orig_ax) for
+	 * interrupt, and positive value for syscall.
+	 *
+	 * We have two race windows in here:
+	 *
+	 * 1) Few instructions from syscall entry until old_rsp is
+	 *    set.
+	 *
+	 * 2) In syscall/interrupt path from entry until the orig_ax
+	 *    is set.
+	 *
+	 * Above described race windows are fractional opposed to
+	 * the syscall fast path, so we get much better results
+	 * fixing rsp this way.
+	 */
+	if (kernel && (syscall_get_nr(current, uregs->regs) >= 0)) {
+		/* Make a copy and link it to regs pointer. */
+		memcpy(&uregs->regs_copy, uregs->regs, sizeof(*uregs->regs));
+		uregs->regs = &uregs->regs_copy;
+
+		/* And fix the rsp. */
+		uregs->regs->sp = this_cpu_read(old_rsp);
+	}
+}
+#endif
+
 /*
  * callchain support
  */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 599afc4..817e192 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -697,6 +697,7 @@ struct perf_branch_stack {
 struct perf_regs_user {
 	__u64		abi;
 	struct pt_regs	*regs;
+	struct pt_regs  regs_copy;
 };
 
 struct task_struct;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b9df35..71329d6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3780,10 +3780,15 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
+__weak void
+arch_sample_regs_user_fixup(struct perf_regs_user *regs_user, int kernel) { }
+
 static void perf_sample_regs_user(struct perf_regs_user *regs_user,
-				  struct pt_regs *regs)
+				 struct pt_regs *regs)
 {
-	if (!user_mode(regs)) {
+	int kernel = !user_mode(regs);
+
+	if (kernel) {
 		if (current->mm)
 			regs = task_pt_regs(current);
 		else
@@ -3793,6 +3798,7 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 	if (regs) {
 		regs_user->regs = regs;
 		regs_user->abi  = perf_reg_abi(current);
+		arch_sample_regs_user_fixup(regs_user, kernel);
 	}
 }
 
-- 
1.7.7.6

