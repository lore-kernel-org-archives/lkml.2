Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab2EWSC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:02:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42842 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483Ab2EWSC5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120523164503.GG26693@mudshark.cambridge.arm.com>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
	<20120523164503.GG26693@mudshark.cambridge.arm.com>
Date: Wed, 23 May 2012 13:02:55 -0500
Message-ID: <CABqD9hbops5d-panvjYJ_4Q52P2T2_Ecz+50_BS8xyaQS7uUkg@mail.gmail.com>
Subject: Re: New ARM asm/syscall.h incompatible? (commit bf2c9f9866928df60157bc4f1ab39f93a32c754e)
From: Will Drewry <wad@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "wade_farnsworth@mentor.com" <wade_farnsworth@mentor.com>,
        "stevenrwalter@gmail.com" <stevenrwalter@gmail.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:45 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, May 23, 2012 at 05:01:50PM +0100, Will Drewry wrote:
>> Hi Wade and Steven,
>
> Hi Will,
>
>> I don't believe the syscall_get_arguments/syscall_set_arguments
>> implementation that landed in 3.4 is correct or safe.  I didn't see it
>> get pulled in - sorry for not mailing sooner! :(
>
> Well, thanks for shouting anyway. It only went in during this merge window,
> so hopefully we can fix it before 3.5.

Ah cool - so I can't read doubly :)

>> The current implementation allows for _7_ arguments and allows the 0th
>> index to be the ARM_ORIG_r0 instead of starting with ARM_r0 == 0.  In
>> the global description of syscall_*_arguments it says:
>>
>>  * It's only valid to call this when @task is stopped for tracing on
>>  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
>>  * It's invalid to call this with @i + @n > 6; we only support system calls
>>  * taking up to 6 arguments.
>
> Hmm, where does this `6' come from? I see it's an open-coded constant in
> some of the trace code, but as Russell pointed out:

I don't know the origins of the "6" argument maximum, but it is what
is specified in the asm-generic/syscall.h describing the expected
values for the calls. I believe the glibc wrappers for syscall used to
enforce it with its _syscall helpers.

I've seen it elsewhere in the kernel too (and modeled the seccomp
filter code based on that explicit expectation).

> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/085509.html
>
> we have the unusual case of requiring 7 arguments for a particular syscall.
> Perhaps we could let the arch configure this?

It seems like it's a bit of a trap (pun not really intended).  The
goal of the tracehook and asm/syscall.h code is to create a portable
ABI on arch-specific details. If arch-specific behavior gets encoded
there, then the encapsulation is broken.

I don't think all is lost though :)  I'll explain what I'm thinking
below and you can tell me it's been thought of and written off :)


>> This means that the current implementation is broken when matching
>> system call arguments for ftrace (unless there is an arch specific
>> hack in there) and it breaks internal kernel API for any other
>> consumers without arch knowledge (like seccomp mode=2).  Is there a
>> reason to expose ARM_ORIG_r0 this way?  Am I misreading?
>>
>> My understanding of the arch register usage at syscall time is something like:
>> - ORIG_r0 gets the syscall number
>> - r0 becomes the first system call argument
>> - system call proceeds
>> - on return, r0 is the return value
>
> Aha, you're slightly off here. For ARM, ORIG_r0 is the first argument to the
> system call (we keep it here as part of the syscall restarting code, since
> the result of the interrupted syscall will sit in r0). The system call
> number is either in r7 or encoded as part of the instruction but when
> tracing we save it into the thread_info so we don't need to worry about
> where it came from.

That makes more sense :)

>> Even audit_syscall_entry() uses ARM_r0 for the first argument which
>> means that any future consumers doing syscall_get_arguments(..., 0, 6)
>> would get the wrong first argument.
>
> Thinking about it, I can't think of a scenario where the tracing code should
> see a different value for ARM_r0 and ARM_ORIG_r0 on the entry path. Maybe we
> should use ARM_r0 consistently for clarity.

I can't see the benefit of the ARM_ORIG_r0 since the syscall is cached
and I haven't seen any code that expects syscall_get_arguments(...,0,
1) to return the original arg 0.  I don't really know which is better
behavior -- showing the original values or showing the actual register
contents at that point.

>> I'm also curious why the system call argument getter/setters allow for
>> invalid requests instead of BUG_ON()ing?  All code that exposes
>> syscall arguments to userspace should be limiting the number to a
>> maximum of 6, and any other badness is a definite kernel bug.  Am I
>> just really confused?
>
> See the post from Russell linked above.
>
> So I think the conclusion is that the 7-argument syscall (sys_syscall with
> OABI) will have a truncated argument list when tracing.

greatly.  sys_syscall seems to be a very special case.  I'm curious
why sys_syscall needs to bubble up during tracing. Did you consider
just doing the sys_syscall remapping (as it is done in entry-common.S)
again in the syscall_trace why==0 code?  In particular, sys_syscall
looks like:

@ r0 = syscall number
@ r8 = syscall table
sys_syscall:
>------->-------bic>----scno, r0, #__NR_OABI_SYSCALL_BASE
>------->-------cmp>----scno, #__NR_syscall - __NR_SYSCALL_BASE
>------->-------cmpne>--scno, #NR_syscalls>-----@ check range
>------->-------stmloia>sp, {r5, r6}>--->-------@ shuffle args
>------->-------movlo>--r0, r1
>------->-------movlo>--r1, r2
>------->-------movlo>--r2, r3
>------->-------movlo>--r3, r4
>------->-------ldrlo>--pc, [tbl, scno, lsl #2]
>------->-------b>------sys_ni_syscall
ENDPROC(sys_syscall)

Would it make sense to just pre-handle the sys_syscall case when
entering syscall_trace (it's already the slow path)?  Trace will then
see the syscall that _is_ executed, so will ptrace, etc.  The only
downside is that strace and friends won't see that sys_syscall was the
originator.  The rest of ptrace, ftrace, and seccomp behavior would
work beautifully though ;)

Is that just more insanity?  I'd really love to see
syscall_*_arguments behavior stay uniform across the various
architectures.  That said, having the optional 7th argument doesn't
really affect the other arches if they always assume it maxes at 6, it
just means that that 7th argument will be routinely unreachable in
cross-arch code.

Thanks for the enlightening response!
will
