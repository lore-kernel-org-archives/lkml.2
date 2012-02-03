Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2BCB6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:58:34 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:47784 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2BCB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:58:33 -0500
Message-ID: <351fa912f66bddd04792fec8dafe72ee.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120203003220.GC14129@n2100.arm.linux.org.uk>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
    <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
    <4F2A55B6.4030006@hitachi.com>
    <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl>
    <20120202111007.GF889@n2100.arm.linux.org.uk>
    <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
    <20120203003220.GC14129@n2100.arm.linux.org.uk>
Date: Fri, 3 Feb 2012 02:58:25 +0100
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
From: "Indan Zupancic" <indan@nul.nu>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Takuo Koguchi" <takuo.koguchi.sw@hitachi.com>,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com, mcgrathr@google.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 01ccc3eb840dc35651f50b798cb06ae8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 3, 2012 01:32, Russell King - ARM Linux wrote:
> On Fri, Feb 03, 2012 at 12:38:58AM +0100, Indan Zupancic wrote:
>> On Thu, February 2, 2012 12:10, Russell King - ARM Linux wrote:
>> > On Thu, Feb 02, 2012 at 12:00:30PM +0100, Indan Zupancic wrote:
>> >> On Thu, February 2, 2012 10:21, Takuo Koguchi wrote:
>> >> > Right.  As Russel King suggested, this patch depends on those configs
>> >> > until very large NR_syscalls is properly handled by ftrace.
>> >>
>> >> It has nothing to do with large NR_syscalls. Supporting OABI is hard,
>> >
>> > That's rubbish if you're doing things correctly, where correctly is
>> > defined as 'not assuming that the syscall number is in r7, but reading
>> > it from the thread_info->syscall member.
>>
>> It was my impression that thread_info->syscall is only set in the ptrace
>> path.
>
> Well, as ptrace is the only syscall tracing we have at the moment in
> the kernel, then that's how its done.

Fair enough.

> What we don't have there for ptrace is a method to read that, so
> tools such as strace have had to fiddle about to discover the syscall
> number.  That's something I have had a patch for some time to 'fix'
> (a PTRACE_GET_SYSCALL to complement PTRACE_SET_SYSCALL) but haven't
> had the motivation to try to fix that.
>
>> Of course this can be changed, but it's tricky to do without adding
>> instructions to the syscall entry path. One way would be to have a
>> flag somewhere saying whether r7 or thread_info->syscall should be
>> used, and also set thread_info->syscall for OABI calls. That at least
>> won't slow down the EABI path.
>
> Why would you need to change the entry path?  We already have a hook
> out of the syscall path for doing tracing (via syscall_trace()) but
> the fact that it sits in ptrace.c isn't an argument to create something
> new.

Will Drewry has a seccomp BPF syscall filtering patch which needs syscall.h,
and then there's /proc/$PID/syscall, coredumps and ftrace that need a way
to get the syscall number. So yes, right now it's just ptrace, but a few
features would benefit from having a way to know the current syscall number
outside of the ptrace path.

>> > Notice how the EABI case is a lot more complicated by the alignment
>> > rules than the OABI - not only do you need something like the above
>>
>> Only when you go through the args sequentially like that.
>
> If you don't go through the args sequentially, then your only way of
> deciding EABI args is via a table which describes the location of each
> argument in the register set.

But you need something like that anyway, even if you do go sequentially
through the args. If you do anything with the args, you need to know what
they mean, and that is system call specific. If you store the meaning of
an arg then you automatically know its location. Having 64-bit args on a
32-bit system isn't something you can handle automatically and generally
without lookup tables or some other info.

syscall.h is the wrong place to handle 64-bit args specially, it should
just expose the raw syscall interface without interpretation.

>> If only EABI is supported everything is simple, because everyone knows
>> what to expect. If OABI is also supported then more changes are needed:
>> The above, but also some way to tell ptrace and other users if it was
>> an EABI or OABI system call. And currently with ptrace there is no race
>> free way of figuring out the OABI system call number from user space.
>
> Absolute tosh, that really is.  Of course there's a way of figuring it
> out.  Tools such as strace have been doing it for _years_ and have been
> doing it extremely well.

I said "race free". Reading processs memory isn't race free. Other than
that detail, yes it can be done.

> Sure, some other thread may stamp over the syscall after you've entered
> the kernel, but that's a bug in any case - if programs are doing that
> then they're racy, and can't predict what system call they're going to
> invoke.  So really that kind of race is not one to be concerned about.

Except if you use ptrace for anything security sensitive, like process
jailing.

> And, in any case, using what's already there in syscall_trace() already
> gives you a way to store and manipulate the syscall number.  So really
> there's no argument over obtaining the syscall number from OABI at all.

That would at least fix the race: Just read the info from user memory, and
afterwards set the system call to the expected one. Only problem left is
assuring that it is an EABI call or an OABI call. System call arguments
are sometimes different, if they are different in a security sensitive way
then there's still a problem. But looking at the affected system calls it
seems it's fine. So you're right that no extra OABI info needs to be passed
on. For the rare security sensitive software where it would matter it can
always not support CONFIG_OABI_COMPAT kernels.

Greetings,

Indan


