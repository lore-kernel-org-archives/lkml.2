Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2KTXQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:16:52 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:61957 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:16:51 -0500
Message-ID: <3501c254c970c4dbd933022651622f79.squirrel@mail.sublimeip.com>
In-Reply-To: <20121120183243.GA31290@redhat.com>
References: <20121109182943.GA2789@redhat.com>
    <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com>
    <1353349500.6276.9.camel@gandalf.local.home>
    <20121120154824.GA17534@redhat.com>
    <20121120183243.GA31290@redhat.com>
Date: Wed, 21 Nov 2012 10:16:48 +1100
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
From: u3557@miso.sublimeip.com
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Amnon Shiloh" <u3557@miso.sublimeip.com>,
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

> Or. Perhaps we can define TRAP_VSYSCALL and change emulate_vsyscall() to
> do
>
>
> 	if (current->ptrace && test_thread_flag(TIF_SYSCALL_TRACE))
> 		send_sigtrap(TRAP_VSYSCALL, ...);
>
> if it returns true?
>

I wish it were possible, but the vsyscall page is entered in user-mode,
where it is not possible to read either "current" or the per-thread flags.

One nice alternative, however, is to take away the execute permission from
the vsyscall page of the traced process, so it will incur a SIGSEGV (which
the ptracer can easily handle and cancel).

The drawbacks of this nice-to-have alternative are:
1) It may require a bigger patch.
2) It needs to use a separate ptrace option, because current applications
   that use PTRACE_SYSCALL (or PTRACE_SYSEMU), including "strace", will not
   be aware of this new feature, so they can be broken.

> Yes, the tracee won't report _before_ it calls the function, but perhaps
> this is enough? Amnon?

The vsyscall page was designed in order to avoid user/kernel context
switches, which is possible when a system-call is only reading kernel
global information, not modifying any.  In most cases therefore (with
a few exceptions, such as when the hardware clock is broken or
misconfigured), system-calls in the vsyscall page never invoke the kernel
at all - so no trap would be generated either before or after.

Best Regards,
Amnon.

> On 11/20, Oleg Nesterov wrote:
>>
>> On 11/19, Steven Rostedt wrote:
>> >
>> > Is this really what we want?
>>
>> I am not sure, that is why I am asking.
>
> Yes.
>
> And,
>
>> Well yes, with the new implementation __vsyscall_page simply does
>> syscall, so I guess (say) strace will "just work". But, afaics, only
>> if vsyscall_mode == NATIVE.
>>
>> So perhaps bp in vsyscall_page still makes sense...
>
> Or. Perhaps we can define TRAP_VSYSCALL and change emulate_vsyscall() to
> do
>
>
> 	if (current->ptrace && test_thread_flag(TIF_SYSCALL_TRACE))
> 		send_sigtrap(TRAP_VSYSCALL, ...);
>
> if it returns true?
>
> This way the debugger doesn't need to play with the debug registers,
> it can use ptrace(PTRACE_SYSCALL). The tracee will report SIGTRAP after
> vsyscall, debugger can detect this case looking at info->si_code.
>
> Yes, the tracee won't report _before_ it calls the function, but perhaps
> this is enough? Amnon?
>
> Oleg.
>
>


