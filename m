Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2GNQPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:15:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59216 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GNQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
 <1342279974-26917-2-git-send-email-wad@chromium.org> <CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
 <CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com> <CABqD9hYz3410CE7cwfzw7zAXD3k2kT2PNfSmFLiaf+sbRTnfmQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 14 Jul 2012 09:15:27 -0700
X-Google-Sender-Auth: EWcR6yf6GHRRrUk-PrDeauu959M
Message-ID: <CAObL_7EQH6KQCU-iWOt9SKn49p2K3n3GV1QS4ZDvnjhhLyXCeA@mail.gmail.com>
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

On Sat, Jul 14, 2012 at 8:57 AM, Will Drewry <wad@chromium.org> wrote:
> On Sat, Jul 14, 2012 at 10:50 AM, Will Drewry <wad@chromium.org> wrote:
>> On Sat, Jul 14, 2012 at 10:44 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> I think I'd prefer if changing to something other than whatever value is
>>> used to cancel the syscall resulted in a crash rather than just being
>>> ignored.
>>
>> I was trying to keep as much seccomp-ptrace behavior intact rather
>> than making it terminal in this special case.  Is there a reason why
>> it'd make more sense to crash?
>
> Unless you meant something the tracer could catch?  That may make
> sense, but they could also use singlestep or whatever else to get
> similar behavior.  But maybe I'm missing the bigger picture!

I think it would be nice to not introduce any special behavior that
things might rely on if we do this better in the future.  Similarly,
for almost all purposes, a tracer could change gettimeofday to write,
but there would be a silent behavior change if gettimeofday were
entered via vsyscall.

What's the standard way of skipping a syscall?  sigreturn?  (I don't
know off the top of my head what sigreturn does.)  sys_ni_syscall?
I'd be all for making those continue to work but making anything that
can't be emulated correctly do something sufficiently unpleasant that
people won't do it.  Is there a syscall that does nothing at all?

I wish we could just increment rip by 7 and set a flag to allow the
vsyscall page instructions to be fully emulated until one of the ret
instructions happens, but I don't know how to do that without
monkeying with the entry assembly -- the do_page_fault path doesn't
look enough like system_call to pull it off easily.

In any case, can you change the docs to indicate that the special
behavior only happens iff rip & ~0x0c00 == 0xffffffffff600000?  That
way a hypothetical future emulator could add better emulation
(incrementing rip by 7, for example) and everything would still work.
(There's no need to check the syscall number.)

FWIW, this crap is why I'm sort of tempted to say that seccomp should
just ignore vsyscalls entirely (except in mode 1).  None of them
actually do anything other than querying things that can be read out
of the vsyscall page (for the most part) without any kernel entry.
(Making *that* part of the ABI would be bad, though.)  Better ideas
are welcome.

--Andy
