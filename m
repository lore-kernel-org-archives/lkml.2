Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2KTKdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:33:46 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:20215 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2KTKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:33:45 -0500
Message-ID: <ffbad99ce24a54ce51dbcd9557f3a993.squirrel@mail.sublimeip.com>
In-Reply-To: <1353349500.6276.9.camel@gandalf.local.home>
References: <20121109182943.GA2789@redhat.com>
    <20121109183026.GA2719@redhat.com> <20121119174728.GA11365@redhat.com>
    <1353349500.6276.9.camel@gandalf.local.home>
Date: Tue, 20 Nov 2012 21:33:42 +1100
Subject: Re: [PATCH] arch_check_bp_in_kernelspace: fix the range check
From: u3557@miso.sublimeip.com
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Oleg Nesterov" <oleg@redhat.com>,
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

Dear Steve,

> But here, there's no prejudice between tasks. All tasks will now hit the
> breakpoint regardless of if it is being traced or not.

Just to clarify, there is no intention to allow conventional breakpoints
in the vsyscall page - that would indeed be a disaster affecting all other
processes.

The aim of this patch is to allow ptracers to set the x86 debug-registers
of their traced process, so that it stops when it reaches the entry points
of those (few) system-calls that are in the vsyscall page.  Note that those
debug registers are anyway swapped at context-switch, so no other processes
are affected.

> Is this really what we want? I mean, isn't syscall tracing in the kernel
> done by a flag set to the task's structure. If the task has a flag set,
> then it does the slow (ptrace) path which handles the breakpoint for the
> user.

Most system-calls can be trapped by the PTRACE_SYSCALL option (and the
later PTRACE_SYSEMU), but those few system-calls on the vsyscall page
defy the intention to trap ALL system-calls.  They also cannot be
checkpointed by inserting a trap-instruction (as that, if allowed, would
break all other processes), hence the only alternative left is to have
this patch that fixes the oversight in the design of
PTRACE_SYSCALL/PTRACE_SYSEMU in the presence of a vsyscall page.

Best Regards,
Amnon.

> On Mon, 2012-11-19 at 18:47 +0100, Oleg Nesterov wrote:
>> On 11/09, Oleg Nesterov wrote:
>> >
>> > On 11/09, Oleg Nesterov wrote:
>> > >
>> > > Note: TASK_SIZE doesn't look right at least on x86, I think it
>> should
>> > > be replaced by TASK_SIZE_MAX.
>> > > ...
>> > > --- x/arch/x86/kernel/hw_breakpoint.c
>> > > +++ x/arch/x86/kernel/hw_breakpoint.c
>> > > @@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct
>> > >  	va = info->address;
>> > >  	len = get_hbp_len(info->len);
>> > >
>> > > -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
>> > > +	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
>> >
>> > But actully I'd like to ask another question.
>> >
>> > Can't we add the additional !in_gate_area_no_mm() check to allow
>> > the hw breakpoints in vsyscall?
>> >
>> > Quoting Amnon:
>> >
>> > 	My service needs to catch the system-calls of its traced son.
>> > 	Almost all system-calls are caught with PTRACE_SYSCALL, but not those
>> > 	using the vsyscall page - especially "gettimeofday()" and "time()".
>> >
>> > 	...> Is this really what we want? I mean, isn't syscall tracing in
the kernel
> done by a flag set to the task's structure. If the task has a flag set,
> then it does the slow (ptrace) path which handles the breakpoint for the
> user.
>> >
>> > 	However, the code in "arch/x86/kernel/ptrace.c" forbids catching
>> kernel
>> > 	addresses.
>> >
>> > I tend to agree with Amnon...
>> >
>> > What do you think?
>>
>> ping ;)
>>
>> I agree the patch I sent is very minor (although it looks like the
>> trivial
>> bugfix to me).
>>
>> Just I think Amnon has a point, shouldn't we change this change like
>> below?
>> (on top of this fixlet).
>>
>> Oleg.
>>
>> --- x/arch/x86/kernel/hw_breakpoint.c
>> +++ x/arch/x86/kernel/hw_breakpoint.c
>> @@ -188,6 +188,11 @@ static int get_hbp_len(u8 hbp_len)
>>  	return len_in_bytes;
>>  }
>>
>> +static inline bool bp_in_gate(unsigned long start, unsigned long end)
>> +{
>> +	return in_gate_area_no_mm(start) && in_gate_area_no_mm(end);
>> +}
>> +
>>  /*
>>   * Check for virtual address in kernel space.
>>   */
>> @@ -200,7 +205,8 @@ int arch_check_bp_in_kernelspace(struct
>>  	va = info->address;
>>  	len = get_hbp_len(info->len);
>>
>> -	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
>> +	return ((va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE)) &&
>> +		!bp_in_gate(va, va + len - 1);
>
> So we want to allow non privileged to add a breakpoint in a vsyscall
> area even if it happens to lay in kernel space?
>
> Is this really what we want? I mean, isn't syscall tracing in the kernel
> done by a flag set to the task's structure. If the task has a flag set,
> then it does the slow (ptrace) path which handles the breakpoint for the
> user.
>
> But here, there's no prejudice between tasks. All tasks will now hit the
> breakpoint regardless of if it is being traced or not.
>
> -- Steve
>
>
>>  }
>>
>>  int arch_bp_generic_fields(int x86_len, int x86_type,
>
>
>


