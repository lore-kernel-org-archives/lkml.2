Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2JCMac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab2JCMaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:30:30 -0400
Date: Wed, 3 Oct 2012 14:29:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCHv3] perf x86_64: Fix rsp register for system call fast path
Message-ID: <20121003122947.GB945@krava.brq.redhat.com>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
 <1349174644.7780.23.camel@twins>
 <20121002145815.GH6379@krava.brq.redhat.com>
 <20121002154914.GC10605@somewhere>
 <20121002160626.GA26598@krava.brq.redhat.com>
 <20121002161633.GF10605@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002161633.GF10605@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:16:47PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 02, 2012 at 06:06:26PM +0200, Jiri Olsa wrote:
> > On Tue, Oct 02, 2012 at 05:49:26PM +0200, Frederic Weisbecker wrote:
> > > On Tue, Oct 02, 2012 at 04:58:15PM +0200, Jiri Olsa wrote:

SNIP

> > could be.. I guess I thought that having the regs retrieval
> > plus the fixup at the same place feels better/compact ;)
> > 
> > but could change that if needed
> 
> Yeah please.

attached new version

> Actually it's more hacky because it's less deterministic.
> But it's more simple, and doesn't hurt performances.

new version does the regs copy only if it recognize the syscall,
so it should be little faster than previous version ;)

thanks,
jirka


---
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

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   38 ++++++++++++++++++++
 include/linux/perf_event.h       |    5 ++-
 kernel/events/core.c             |   73 ++++++++++++++++++++------------------
 3 files changed, 79 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..0ba525b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -34,6 +34,7 @@
 #include <asm/timer.h>
 #include <asm/desc.h>
 #include <asm/ldt.h>
+#include <asm/syscall.h>
 
 #include "perf_event.h"
 
@@ -1699,6 +1700,43 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 }
 
+#ifdef CONFIG_X86_64
+__weak void
+arch_sample_regs_user_fixup(struct perf_regs_user *uregs, int kernel)
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
index 599afc4..d8ad615 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -697,6 +697,7 @@ struct perf_branch_stack {
 struct perf_regs_user {
 	__u64		abi;
 	struct pt_regs	*regs;
+	struct pt_regs	regs_copy;
 };
 
 struct task_struct;
@@ -1190,8 +1191,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
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
index 7b9df35..aa4e2fc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3780,10 +3780,15 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
-				  struct pt_regs *regs)
+__weak void
+arch_sample_regs_user_fixup(struct perf_regs_user *regs_user, int kernel) { }
+
+static int perf_sample_regs_user(struct perf_regs_user *regs_user,
+				 struct pt_regs *regs)
 {
-	if (!user_mode(regs)) {
+	int kernel = !user_mode(regs);
+
+	if (kernel) {
 		if (current->mm)
 			regs = task_pt_regs(current);
 		else
@@ -3793,7 +3798,10 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 	if (regs) {
 		regs_user->regs = regs;
 		regs_user->abi  = perf_reg_abi(current);
+		arch_sample_regs_user_fixup(regs_user, kernel);
 	}
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
+		sp = perf_user_stack_pointer(uregs->regs);
 		rem = __output_copy_user(handle, (void *) sp, dump_size);
 		dyn_size = dump_size - rem;
 
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
@@ -4247,14 +4246,18 @@ void perf_prepare_sample(struct perf_event_header *header,
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
+		if (uregs->abi) {
+			stack_size = perf_sample_ustack_size(sample_stack_user,
+							     header->size,
+							     uregs->regs);
+		}
 
 		/*
 		 * If there is something to dump, add space for the dump
-- 
1.7.7.6

