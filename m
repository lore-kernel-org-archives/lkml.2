Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2JARcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2JARc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:32:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] perf x86_64: Fix rsp register for system call fast path
Date: Mon,  1 Oct 2012 19:31:52 +0200
Message-Id: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
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

Note that as we are now changing the pt_regs, we use statically allocated
pt_regs inside the sample data instead of task pt_regs pointer.

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

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   47 ++++++++++++++++++++++
 include/linux/perf_event.h       |    6 +-
 kernel/events/core.c             |   80 +++++++++++++++++++------------------
 3 files changed, 91 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..11d62ff 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -34,6 +34,7 @@
 #include <asm/timer.h>
 #include <asm/desc.h>
 #include <asm/ldt.h>
+#include <asm/syscall.h>
 
 #include "perf_event.h"
 
@@ -1699,6 +1700,52 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 }
 
+#ifdef CONFIG_X86_64
+__weak int arch_sample_regs_user(struct pt_regs *oregs, struct pt_regs *regs)
+{
+	int kernel = !user_mode(regs);
+
+	if (kernel) {
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	if (regs) {
+		memcpy(oregs, regs, sizeof(*regs));
+
+		/*
+		 * If the perf event was triggered within the kernel code
+		 * path, then it was either syscall or interrupt. While
+		 * interrupt stores almost all user registers, the syscall
+		 * fast path does not. At this point we can at least set
+		 * rsp register right, which is crucial for dwarf unwind.
+		 *
+		 * The syscall_get_nr function returns -1 (orig_ax) for
+		 * interrupt, and positive value for syscall.
+		 *
+		 * We have two race windows in here:
+		 *
+		 * 1) Few instructions from syscall entry until old_rsp is
+		 *    set.
+		 *
+		 * 2) In syscall/interrupt path from entry until the orig_ax
+		 *    is set.
+		 *
+		 * Above described race windows are fractional opposed to
+		 * the syscall fast path, so we get much better results
+		 * fixing rsp this way.
+		 */
+		if (kernel && (syscall_get_nr(current, regs) >= 0))
+			oregs->sp = this_cpu_read(old_rsp);
+
+	}
+
+	return regs ? 1 : 0;
+}
+#endif
+
 /*
  * callchain support
  */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 599afc4..451dcc5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -696,7 +696,7 @@ struct perf_branch_stack {
 
 struct perf_regs_user {
 	__u64		abi;
-	struct pt_regs	*regs;
+	struct pt_regs	regs;
 };
 
 struct task_struct;
@@ -1190,8 +1190,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->raw  = NULL;
 	data->br_stack = NULL;
 	data->period = period;
-	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
-	data->regs_user.regs = NULL;
+	/* Sets abi to PERF_SAMPLE_REGS_ABI_NONE. */
+	memset(&data->regs_user, 0, sizeof(data->regs_user));
 	data->stack_user_size = 0;
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b9df35..5beb963 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3780,8 +3780,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
-				  struct pt_regs *regs)
+__weak int arch_sample_regs_user(struct pt_regs *oregs, struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
 		if (current->mm)
@@ -3790,10 +3789,19 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 			regs = NULL;
 	}
 
-	if (regs) {
-		regs_user->regs = regs;
-		regs_user->abi  = perf_reg_abi(current);
-	}
+	if (regs)
+		memcpy(oregs, regs, sizeof(*regs));
+
+	return regs ? 1 : 0;
+}
+
+static int perf_sample_regs_user(struct perf_regs_user *regs_user,
+				 struct pt_regs *regs)
+{
+	if (arch_sample_regs_user(&regs_user->regs, regs))
+		regs_user->abi = perf_reg_abi(current);
+
+	return regs_user->abi;
 }
 
 /*
@@ -3819,10 +3827,6 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 {
 	u64 task_size;
 
-	/* No regs, no stack pointer, no dump. */
-	if (!regs)
-		return 0;
-
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -3854,33 +3858,30 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 
 static void
 perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
-			  struct pt_regs *regs)
+			  struct perf_regs_user *uregs)
 {
-	/* Case of a kernel thread, nothing to dump */
-	if (!regs) {
-		u64 size = 0;
-		perf_output_put(handle, size);
-	} else {
+	/*
+	 * We dump:
+	 * static size
+	 *   - the size requested by user or the best one we can fit
+	 *     in to the sample max size
+	 *   - zero (and final data) if there's nothing to dump
+	 * data
+	 *   - user stack dump data
+	 * dynamic size
+	 *   - the actual dumped size
+	 */
+
+	/* Static size. */
+	perf_output_put(handle, dump_size);
+
+	if (dump_size) {
 		unsigned long sp;
 		unsigned int rem;
 		u64 dyn_size;
 
-		/*
-		 * We dump:
-		 * static size
-		 *   - the size requested by user or the best one we can fit
-		 *     in to the sample max size
-		 * data
-		 *   - user stack dump data
-		 * dynamic size
-		 *   - the actual dumped size
-		 */
-
-		/* Static size. */
-		perf_output_put(handle, dump_size);
-
 		/* Data. */
-		sp = perf_user_stack_pointer(regs);
+		sp = perf_user_stack_pointer(&uregs->regs);
 		rem = __output_copy_user(handle, (void *) sp, dump_size);
 		dyn_size = dump_size - rem;
 
@@ -4164,7 +4165,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 		if (abi) {
 			u64 mask = event->attr.sample_regs_user;
 			perf_output_sample_regs(handle,
-						data->regs_user.regs,
+						&data->regs_user.regs,
 						mask);
 		}
 	}
@@ -4172,7 +4173,7 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		perf_output_sample_ustack(handle,
 					  data->stack_user_size,
-					  data->regs_user.regs);
+					  &data->regs_user);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4229,9 +4230,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_user(&data->regs_user, regs);
-
-		if (data->regs_user.regs) {
+		if (perf_sample_regs_user(&data->regs_user, regs)) {
 			u64 mask = event->attr.sample_regs_user;
 			size += hweight64(mask) * sizeof(u64);
 		}
@@ -4247,14 +4246,17 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * up the rest of the sample size.
 		 */
 		struct perf_regs_user *uregs = &data->regs_user;
-		u16 stack_size = event->attr.sample_stack_user;
+		u64 sample_stack_user = event->attr.sample_stack_user;
+		u16 stack_size = 0;
 		u16 size = sizeof(u64);
 
 		if (!uregs->abi)
 			perf_sample_regs_user(uregs, regs);
 
-		stack_size = perf_sample_ustack_size(stack_size, header->size,
-						     uregs->regs);
+		if (uregs->abi)
+			stack_size = perf_sample_ustack_size(sample_stack_user,
+							     header->size,
+							     &uregs->regs);
 
 		/*
 		 * If there is something to dump, add space for the dump
-- 
1.7.7.6

