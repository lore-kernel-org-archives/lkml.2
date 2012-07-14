Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab2GNEF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:05:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39215 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2GNEF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:05:28 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hZRyjjb_xxF=_5u=RF+FKNheW=yJOWU=srEan_XqgBjhw@mail.gmail.com>
References: <1342156672-7369-1-git-send-email-wad@chromium.org>
	<1342199195-2078-1-git-send-email-wad@chromium.org>
	<CAObL_7GaPDNops_cL2u4yU9Afj14f6ju_ZW7qRjhSy25qsbfkw@mail.gmail.com>
	<CABqD9hZRyjjb_xxF=_5u=RF+FKNheW=yJOWU=srEan_XqgBjhw@mail.gmail.com>
Date: Fri, 13 Jul 2012 23:05:26 -0500
Message-ID: <CABqD9hbL8PU5wV5U6AdtAufhMVFLy77pvBvyf1qYQj4k-8aCEQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/vsyscall: allow seccomp filter in vsyscall=emulate
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        qmewlo@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 7:48 PM, Will Drewry <wad@chromium.org> wrote:
> On Fri, Jul 13, 2012 at 6:00 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Fri, Jul 13, 2012 at 10:06 AM, Will Drewry <wad@chromium.org> wrote:
>>> If a seccomp filter program is installed, older static binaries and
>>> distributions with older libc implementations (glibc 2.13 and earlier)
>>> that rely on vsyscall use will be terminated regardless of the filter
>>> program policy when executing time, gettimeofday, or getcpu.  This is
>>> only the case when vsyscall emulation is in use (vsyscall=emulate is the
>>> default).
>>>
>>> This patch emulates system call entry inside a vsyscall=emulate by
>>> populating regs->ax and regs->orig_ax with the system call number prior
>>> to calling into seccomp such that all seccomp-dependencies function
>>> normally.  Additionally, system call return behavior is emulated in line
>>> with other vsyscall entrypoints for the trace/trap cases.
>>>
>>> Reported-by: Owen Kibel <qmewlo@gmail.com>
>>> Signed-off-by: Will Drewry <wad@chromium.org>
>>>
>>> v2: - fixed ip and sp on SECCOMP_RET_TRAP/TRACE (thanks to luto@mit.edu)
>>
>>> @@ -253,6 +273,12 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>>>
>>>         current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
>>>
>>> +       if (skip) {
>>> +               if ((long)regs->ax <= 0L) /* seccomp errno emulation */
>>> +                       goto do_ret;
>>> +               goto done; /* seccomp trace/trap */
>>> +       }
>>> +
>>>         if (ret == -EFAULT) {
>>>                 /* Bad news -- userspace fed a bad pointer to a vsyscall. */
>>>                 warn_bad_vsyscall(KERN_INFO, regs,
>>> @@ -271,10 +297,11 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>>>
>>>         regs->ax = ret;
>>>
>>> +do_ret:
>>>         /* Emulate a ret instruction. */
>>>         regs->ip = caller;
>>>         regs->sp += 8;
>>> -
>>> +done:
>>>         return true;
>>>
>>>  sigsegv:
>>> --
>>> 1.7.9.5
>>>
>>
>> This has the same odd property as the sigsegv path that the faulting
>> instruction will appear to be the mov, not the syscall.  That seems to
>> be okay, though -- various pieces of code that try to restart the segv
>> are okay with that.
>
> Yeah - I would otherwise do
>   regs->ip += 9;
> but I wanted to match the code that was therefor SIGSEGV.  If regs->ip
> += 9 _just_ for the SIGSYS case is fine, then I'll make that change
> shortly.  Since any code that sees the vsyscall address should be wise
> enough to avoid it, perhaps that's why the SIGSEGV hasn't had a
> problem so far.

I dashed this off without more thought. It's best to leave it as is
because any return to the emulated page will cause a vsyscall fault
event.

>> Is there any code that assumes that changing rax (i.e. the syscall
>> number) and restarting a syscall after SIGSYS will invoke the new
>> syscall?  (The RET_TRACE path might be similar -- does the
>> ptrace_event(PTRACE_EVENT_SECCOMP, data) in seccomp.c give a debugger
>> a chance to synchronously cancel or change the syscall?
>
> Unfortunately, it does in normal interception. I don't see any way out
> of that quirk with vsyscall=emulate.  As is without seccomp,
> vsyscall=emulate doesn't allow ptrace interception (or syscall
> auditing for that matter) while vsyscall=native does.   So the option
> here is to document the quirky interaction in
> Documentation/prctl/seccomp_filter.txt.  In particular, if the tracer
> sees either (time|gettimeofday|getcpu) and rip in the vsyscall page,
> it will know it can't rewrite or bypass the call.    Is there a better
> option?
>
> Given that, I will include a tweak to the documentation to indicate
> that behavior so that userspace authors of BPF programs that use
> SECCOMP_RET_TRACE will be aware of the behavior.
>
>> If those issues aren't problems, then:
>>
>> Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>>
>> (If the syscall number needs to change after the fact in the
>> SECCOMP_RET_TRAP case, it'll be a mess.)
>
> Nah - traps are delivered like the forced sigsegv path.
>
> I'll spin a v3 soon including the documentation tweak and the ip
> offset to match vsyscall=native behavior (regs->ip += 9 _just_ for the
> skip case).  Of course, any better ideas for the trace-case will be
> more than welcome, but it seems to me to be an acceptable tradeoff - I
> hope others agree.
>
> I'll make the changes and then put it through its paces to see if any
> other little idiosyncrasies emerge.

I've written up a documentation patch to accompany this one. It
reflects one more change I've made in a v3 of the patch, but it is
optional.  I've added support for SECCOMP_RET_TRACE to still
skip/emulate the system call if it desires.  In v2 it can't.  Either
way is fine in practice, but I'd need to change the accompanying
documentation.

thanks again!
will
