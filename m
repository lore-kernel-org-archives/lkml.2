Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2LBTbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:31:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2LBTbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:31:03 -0500
Date: Sun, 2 Dec 2012 20:30:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace: fix
	the range check)
Message-ID: <20121202193058.GA4264@redhat.com>
References: <20121125225533.GA24905@redhat.com> <20121125234834.DAC34592076@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125234834.DAC34592076@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amnon, sorry for delay...

On 11/26, Amnon Shiloh wrote:
>
> > Why do you need to _prevent_, say, sys_gettimeofday()? Why we can't
> > change emulate_vsyscall() to respect PTRACE_SYSCALL and report
> > TRAP_VSYSCALL or PTRACE_EVENT_VSYSCALL as I tried to suggest in
> > http://marc.info/?l=linux-kernel&m=135343635523715 ?
> >
> > Oleg.
> >
>
> For my own application, I would be happy with this.

OK, good.

> But I suspect it might break current versions of "strace",
> ...
> I think it COULD work, but not based on PTRACE_SYSCALL
> (or PTRACE_SYSEMU) alone.  A new ptrace option will be needed, saying:
> "Yes, I am aware of TRAP_VSYSCALL and I know how to handle it."

Yes, that is why I said this needs the new option.

However. Of course it would be nice to avoid the new option. IMO it
would be better to do nothing ;) vsyscall is deprecated, and EMULATE
is x86-specific.


May be we could simply do something like the patch below? (Just in
case, this hack is only for illustration, it is not complete).

If the tracer does PTRACE_SYSCALL the tracee reports syscall exit
_after_ gettimeofday/etc. The tracer can look at regs->orig_ax == -1
and detect that this is not syscall but vsyscall, it can look at
regs->ip then (not with the patch below).

Denys, Jan, Pedro. Do you think this change can break/confuse
gdb/strace ?


> While for my own application, just fixing the range-check in
> arch_check_bp_in_kernelspace will do,

You forgot again that EMULATE does not execute the code in the
vsyscall page.

Oleg.

--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -186,6 +186,8 @@ static bool write_ok_or_segv(unsigned long ptr, size_t size)
 	}
 }
 
+#include <linux/tracehook.h>
+
 bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
@@ -312,6 +314,8 @@ do_ret:
 	regs->ip = caller;
 	regs->sp += 8;
 done:
+	if (test_thread_flag(TIF_SYSCALL_TRACE))
+		ptrace_report_syscall(regs);
 	return true;
 
 sigsegv:

