Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2LBXzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:55:05 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:37489 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2LBXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:55:03 -0500
Message-ID: <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com>
In-Reply-To: <20121202193058.GA4264@redhat.com>
References: <20121125225533.GA24905@redhat.com>
    <20121125234834.DAC34592076@miso.sublimeip.com>
    <20121202193058.GA4264@redhat.com>
Date: Mon, 3 Dec 2012 10:54:58 +1100
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
From: u3557@miso.sublimeip.com
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Amnon Shiloh" <u3557@miso.sublimeip.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Pedro Alves" <palves@redhat.com>,
        "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Reply-To: mosix@mosix.com.au
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> However. Of course it would be nice to avoid the new option. IMO it
> would be better to do nothing ;) vsyscall is deprecated, and EMULATE
> is x86-specific.

The problem is that the current static glibc invokes the vsyscall page,
so statically-linked 3rd-party executables that were distributed only
in binary form are not going to stop using vsyscall even in 100 years.

Note also that even now, while the dynamic glibc library uses vDSO
for "gettimeofday()" it still uses the vsyscall page for "time()",
so even when fixed, it would still take years in any case until all
Linux distributions are free of references to the vsyscall page.

> You forgot again that EMULATE does not execute the code in the
> vsyscall page.

The beauty of using the x86 debug-registers, is that they do not
trap the instruction, but rather the fact that the program-counter
has a given value.  They work like single-stepping, so the condition
of attempting to access the vsyscall page is detected in hardware
BEFORE attempting to access the vsyscall page itself, BEFORE even
discovering that the vsyscall page is inaccessible (in EMULATE mode).

Once trapped of course, the program-counter will be changed by the ptracer,
so neither NATIVE nor EMULATE will ever be invoked.

Current versions of "strace" and "gdb" will not automatically benefit
from this, but wouldn't be harmed either.  Future versions can then
be written to make use of the debug-registers to detect a vsyscall.

Best Regards,
Amnon.

> Amnon, sorry for delay...
>
> On 11/26, Amnon Shiloh wrote:
>>
>> > Why do you need to _prevent_, say, sys_gettimeofday()? Why we can't
>> > change emulate_vsyscall() to respect PTRACE_SYSCALL and report
>> > TRAP_VSYSCALL or PTRACE_EVENT_VSYSCALL as I tried to suggest in
>> > http://marc.info/?l=linux-kernel&m=135343635523715 ?
>> >
>> > Oleg.
>> >
>>
>> For my own application, I would be happy with this.
>
> OK, good.
>
>> But I suspect it might break current versions of "strace",
>> ...
>> I think it COULD work, but not based on PTRACE_SYSCALL
>> (or PTRACE_SYSEMU) alone.  A new ptrace option will be needed, saying:
>> "Yes, I am aware of TRAP_VSYSCALL and I know how to handle it."
>
> Yes, that is why I said this needs the new option.
>
> However. Of course it would be nice to avoid the new option. IMO it
> would be better to do nothing ;) vsyscall is deprecated, and EMULATE
> is x86-specific.
>
>
> May be we could simply do something like the patch below? (Just in
> case, this hack is only for illustration, it is not complete).
>
> If the tracer does PTRACE_SYSCALL the tracee reports syscall exit
> _after_ gettimeofday/etc. The tracer can look at regs->orig_ax == -1
> and detect that this is not syscall but vsyscall, it can look at
> regs->ip then (not with the patch below).
>
> Denys, Jan, Pedro. Do you think this change can break/confuse
> gdb/strace ?
>
>
>> While for my own application, just fixing the range-check in
>> arch_check_bp_in_kernelspace will do,
>
> You forgot again that EMULATE does not execute the code in the
> vsyscall page.
>
> Oleg.
>
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -186,6 +186,8 @@ static bool write_ok_or_segv(unsigned long ptr, size_t
> size)
>  	}
>  }
>
> +#include <linux/tracehook.h>
> +
>  bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>  {
>  	struct task_struct *tsk;
> @@ -312,6 +314,8 @@ do_ret:
>  	regs->ip = caller;
>  	regs->sp += 8;
>  done:
> +	if (test_thread_flag(TIF_SYSCALL_TRACE))
> +		ptrace_report_syscall(regs);
>  	return true;
>
>  sigsegv:
>
>


