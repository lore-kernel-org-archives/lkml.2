Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2GNQzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:55:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52115 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2GNQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7HDQVmLxpU4YH66uFPHD_ZmK02DwCXZHuzO9EY9eP07zA@mail.gmail.com>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
	<1342279974-26917-2-git-send-email-wad@chromium.org>
	<CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
	<CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com>
	<CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com>
	<CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com>
	<CAObL_7HDQVmLxpU4YH66uFPHD_ZmK02DwCXZHuzO9EY9eP07zA@mail.gmail.com>
Date: Sat, 14 Jul 2012 11:55:10 -0500
Message-ID: <CABqD9hYoVNo34oqGh7mCmGZF7nKDC3-d2LD=BLhEUJtM7GbFvQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Kees Cook <keescook@chromium.org>, james.l.morris@oracle.com,
        rob@landley.net, linux-doc@vger.kernel.org, cevans@chromium.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, eparis@redhat.com, fengxj325@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 11:21 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sat, Jul 14, 2012 at 9:15 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Sat, Jul 14, 2012 at 8:57 AM, Will Drewry <wad@chromium.org> wrote:
>>> On Sat, Jul 14, 2012 at 10:50 AM, Will Drewry <wad@chromium.org> wrote:
>>>> On Sat, Jul 14, 2012 at 10:44 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>>> I think I'd prefer if changing to something other than whatever value is
>>>>> used to cancel the syscall resulted in a crash rather than just being
>>>>> ignored.
>>>>
>>>> I was trying to keep as much seccomp-ptrace behavior intact rather
>>>> than making it terminal in this special case.  Is there a reason why
>>>> it'd make more sense to crash?
>>>
>>> Unless you meant something the tracer could catch?  That may make
>>> sense, but they could also use singlestep or whatever else to get
>>> similar behavior.  But maybe I'm missing the bigger picture!
>>
>> I think it would be nice to not introduce any special behavior that
>> things might rely on if we do this better in the future.  Similarly,
>> for almost all purposes, a tracer could change gettimeofday to write,
>> but there would be a silent behavior change if gettimeofday were
>> entered via vsyscall.
>>
>> What's the standard way of skipping a syscall?  sigreturn?  (I don't
>> know off the top of my head what sigreturn does.)  sys_ni_syscall?

Most implementations I've seen just set orig_rax to -1, but in
practice any system call that is invalid will result in the system
call being skipped in the normal syscall path.  So I could tweak it to
check <0 > __NR_syscalls and add a sigsys generator if it is valid.

Do you think that'd be the most correct move? (As you say below, the
impact of _any_ changes here are very minor :)

>> I'd be all for making those continue to work but making anything that
>> can't be emulated correctly do something sufficiently unpleasant that
>> people won't do it.  Is there a syscall that does nothing at all?
>
> Here's my suggestion for now: any attempt by the seccomp filter to do
> anything other than executing the syscall unchanged, skipping it
> entirely, or killing results in a trap or sigsys with the syscall
> number unchanged.
>
> In the RET_TRACE case, the SIGSYS restarts at the mov nr,%rax
> instruction.  The tracer can deal with it accordingly (via checking
> the rip) -- if the tracer changes rax, it'll get changed right back by
> the emulated mov nr,%rax.  If this results in an infinite loop, so be
> it.
>
> In the RET_TRAP case, do the same thing but via the special ptrace
> event instead of SIGSYS.

You've lost me here.  The flow of a RET_TRAP is:
- enter vsyscall at 0xffffffffff600[]00
- run seccomp
- get ret_trap
- queue up a synchronous trap
- skip the vsyscall
- return

Even if the trap were to interrupt the current vsyscall trap handler,
the skip value would still be -1 and the syscall would still get
skipped without touching sp or ip.

Traps cannot provide kernel-side arbitration of allowed syscalls, they
can just emulate them in userspace before "returning" to the original
callsite.  In this case, vsyscall makes returning there harder and the
quirk is to return to the prior address if the ip is in vsyscall's
range.

> This way, the special rip & ~0x0c00 == 0xffffffffff600000 handling
> becomes part of the ABI, but it looks like the mov instruction
> trapped, which it more or less did.  If we want RET_TRAP to be able to
> skip the syscall, let it happen the normal way.

I *think* trap is ok?

> This stuff probably barely matters.  For example, ptrace currently
> doesn't work right when vsyscalls are being emulated.  No one appears
> to care.

Agreed :) I don't mind making tweaks to get it right, but this only
matters to users that want to:
- use seccomp filter
- with ptrace (or trap with resumption and not sigreturn)
- of time, gettimeofday, and getcpu
since they will then have to include quirk management _just_ in case
their code is linked against something using vsyscall and
vsyscall=emulate is in effect!

thanks!
will
