Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2GNQWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:22:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43006 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2GNQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
 <1342279974-26917-2-git-send-email-wad@chromium.org> <CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
 <CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com>
 <CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com> <CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 14 Jul 2012 09:21:50 -0700
X-Google-Sender-Auth: fAZnaAiZfY3bIG7OPldGYUMAN-g
Message-ID: <CAObL_7HDQVmLxpU4YH66uFPHD_ZmK02DwCXZHuzO9EY9eP07zA@mail.gmail.com>
Subject: Re: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
To: Will Drewry <wad@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, james.l.morris@oracle.com,
        rob@landley.net, linux-doc@vger.kernel.org, cevans@chromium.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, eparis@redhat.com, fengxj325@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 9:15 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sat, Jul 14, 2012 at 8:57 AM, Will Drewry <wad@chromium.org> wrote:
>> On Sat, Jul 14, 2012 at 10:50 AM, Will Drewry <wad@chromium.org> wrote:
>>> On Sat, Jul 14, 2012 at 10:44 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>> I think I'd prefer if changing to something other than whatever value is
>>>> used to cancel the syscall resulted in a crash rather than just being
>>>> ignored.
>>>
>>> I was trying to keep as much seccomp-ptrace behavior intact rather
>>> than making it terminal in this special case.  Is there a reason why
>>> it'd make more sense to crash?
>>
>> Unless you meant something the tracer could catch?  That may make
>> sense, but they could also use singlestep or whatever else to get
>> similar behavior.  But maybe I'm missing the bigger picture!
>
> I think it would be nice to not introduce any special behavior that
> things might rely on if we do this better in the future.  Similarly,
> for almost all purposes, a tracer could change gettimeofday to write,
> but there would be a silent behavior change if gettimeofday were
> entered via vsyscall.
>
> What's the standard way of skipping a syscall?  sigreturn?  (I don't
> know off the top of my head what sigreturn does.)  sys_ni_syscall?
> I'd be all for making those continue to work but making anything that
> can't be emulated correctly do something sufficiently unpleasant that
> people won't do it.  Is there a syscall that does nothing at all?

Here's my suggestion for now: any attempt by the seccomp filter to do
anything other than executing the syscall unchanged, skipping it
entirely, or killing results in a trap or sigsys with the syscall
number unchanged.

In the RET_TRACE case, the SIGSYS restarts at the mov nr,%rax
instruction.  The tracer can deal with it accordingly (via checking
the rip) -- if the tracer changes rax, it'll get changed right back by
the emulated mov nr,%rax.  If this results in an infinite loop, so be
it.

In the RET_TRAP case, do the same thing but via the special ptrace
event instead of SIGSYS.

This way, the special rip & ~0x0c00 == 0xffffffffff600000 handling
becomes part of the ABI, but it looks like the mov instruction
trapped, which it more or less did.  If we want RET_TRAP to be able to
skip the syscall, let it happen the normal way.

This stuff probably barely matters.  For example, ptrace currently
doesn't work right when vsyscalls are being emulated.  No one appears
to care.

--Andy
