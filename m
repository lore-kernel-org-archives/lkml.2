Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2BJDhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:37:52 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:40759 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2BJDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:37:49 -0500
Message-ID: <281b99af510eb77040272903245f0256.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120210020255.GA8333@jl-vm1.vm.bytemark.co.uk>
References: <20120210020255.GA8333@jl-vm1.vm.bytemark.co.uk>
Date: Fri, 10 Feb 2012 04:37:19 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "Indan Zupancic" <indan@nul.nu>
To: "Jamie Lokier" <jamie@shareable.org>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Andrew Lutomirski" <luto@mit.edu>,
        "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: 699c009f32949d171c2fe23f2a18a2c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 10, 2012 03:02, Jamie Lokier wrote:
> Indan Zupancic wrote:
>> On Thu, January 26, 2012 12:47, Jamie Lokier wrote:
>> > Indan Zupancic wrote:
>> >> On Thu, January 26, 2012 11:31, Jamie Lokier wrote:
>> >> > Indan Zupancic wrote:
>> >> The jailer I wrote works pretty well as a simplistic strace replacement.
>> >> It can only print out the arguments we're checking, but that's usually
>> >> the more interesting info.
>> >
>> > In theory such a thing should be easy to write, but as we both found,
>> > ptrace() on Linux has a huge number of difficult quirks to deal with
>> > to trace reliably.  At least it's getting better with later kernels.
>>
>> It's not that bad, there are a few quirks, but not that many.
>> The ptrace specific code is less than 500 lines of code, with
>> a couple of hundred lines of header files. Linux ptrace specific
>> stuff creeps in elsewhere too though, like that execve mess.
>
> I count 720 lines *just* to read the syscall number and arguments in
> strace-git, for the Linux archs it supports.
>
> That's only the Linux code, I excluded non-Linux, and it's only a
> little bit of syscall.c, I didn't include generic ptracing,
> fork-following, threaded-exec-fixups, signal handling etc. nor other
> arch-specific functions and ABI fixups.  And it doesn't even have all
> archs currently in Linux mainline.

Well, I was talking about my own code, not strace. Counting strace lines
of code is tricky because of all the ifdefs.

I have to add threaded-exec-fixups, though that's not ptrace specific,
but Linux specific. Although I only support x86 at the moment, I try
to keep the per-arch code to a minimum. Currently it's 20 lines of x86
header file and 50 for x86_64 for the ptrace code. The real work is the
syscall info table, which is both system call and arch specific.

My code is written with cross-platform support in mind, I try to keep
the number of (Linux, ptrace or arch specific) assumptions as low as
possible. But if I added support for e.g. BSD then I would keep its
ptrace code totally separate from the Linux one.

>> >> It's not a 32 versus 64-bit issue though, so it will be something on
>> >> its own anyway. Can as well add an extra ARM specific ptrace command
>> >> to get that info, or hack it in some other way. For instance, ip is
>> >> (ab)used to tell if it is syscall entry or exit, so doing these tricks
>> >> isn't anything new in ARM either.
>> >
>> > In theory, aren't we supposed to know whether it's entry/exit anyway?
>> > Why does strace care?  Have there been kernel bugs in the past?  Maybe
>> > it was just to deal with SIGTRAP-after-exit in the past, which could
>> > be delivered at an unpredictable time if blocked and then unblocked by
>> > sigreturn().
>>
>> Maybe. I don't why ARM does that ip thing.
>>
>> Although in theory you know the entry/exits if you keep track, but one
>> mistake or unexpected behaviour (like execve for my code) and you can get
>> it wrong. So for robustness sake it's good if it can be double checked.
>
> I agree, and I think the PTRACE_EVENT_SYSCALL_ENTRY/EXIT events would
> be a clean way to represent that.

Yes, that would be perfect.

> I wonder if all archs report syscall-exit as the first event in traced
> fork children.  Looking at arch/hexagon I'm guessing it doesn't, but
> it's hard to be sure and no practical way to test it :-/

I would expect none of them to return syscall-exit for the child process.
It was the parent that called it, the child never did!

> That wouldn't matter if the events were robust.

Yes. It's a lot better to not worry about all these kind of details which
may or may not change between archs and kernel versions.

> I read somewhere about a bug report where syscall-exit was seen after
> attach, but I don't remember where now.

Well, if you attach at a random moment you can get a syscall-exit first,
I guess. I suppose you have to wait till you get the SIGSTOP notification
before you can be sure that the next syscall event will be an entry one.

>> I don't know anything about OABI, can you link an OABI program against
>> an EABI library? If you can then libc can be EABI and the kernel doesn't
>> need OABI support.
>
> That's not the point.  If you're writing a ptrace jailer (as you are)
> a program can deliberately use OABI calls to subvert the tracer, even
> if it's using EABI for normal calls.

I know, but I can say that kernels supporting OABI aren't supported
because they are unsafe. Just like a 32-bit only jailer running on
x86_64 is unsafe. Best would be if I checked it at startup too.

Right now I have to add very paranoid code to support compat32 on
x86_64 anyway.

> For linking, you are mostly right.  Ideally everything would be open
> and recompilable anyway, but that's sadly not always possible.  OABI
> and EABI have different struct layouts among other changes, and EABI
> being newer tends to accompany other libc changes; embedded libc.
> aren't always as drop-in backward-compatible as glibc.

Russell King told me about PTRACE_SET_SYSCALL on ARM, that would solve
the reading memory problem, as we can always set the expected syscall
number to make sure it wasn't changed behind our back. The system call
number are the same for EABI and OABI, so it's not as bad as int 0x80
from 64-bit.

The alignment changes hopefully don't make a difference for my jailer.
If they do then I have to add specific code to handle it, which I don't
like doing. But looking at sys_oabi-compat.c it doesn't seem too bad.

>> >> And then there's the whole confusion what that flag says, some might think
>> >> it says in what mode the tracee is instead of what mode the system call is.
>> >> That those two can be different is not obvious at all and seems very x86_64
>> >> specific.
>> >
>> > My rough read of PARISC entry code suggests it has two entry methods,
>> > similar to ARM and x86_64, but I'm not really familiar with PARISC and
>> > I don't have a machine handy to try it out :-)
>>
>> It has a unified syscall table, so does it really matter?
>
> I don't know if the 32/64 matters.  For security or accurate tracing,
> I wouldn't like to assume without checking if there are 64-on-32
> argument alignment fixups.

I thought it was just ARM passing a 64-bit arg in two 32-bit regs.
But yes, it's something that needs to be checked. That's most of
the work of adding a new arch, checking all system calls.

> PARISC has a second set of HPUX-compatible system call numbers,
> handled in arch/parisc/hpux/*.  I don't know if those are available to
> all programs and can be used to subvert a ptracer.  Looking at
> hpux/gate.S I think they bypass ptrace entirely; maybe they can subvert it.

That's only set when CONFIG_HPUX is set. If they bypass ptrace entirely
then such kernels can't be supported anyway, except if they have some
other mechanism for syscall interception. But the obscurer the setup,
the less worried I am about supporting it.

>> > I have a script in progress which extracts all the
>> > per-arch and per-ABI syscall numbers, syscall argument layouts and
>> > kernel function names to keep track of arch-specific fixups, from a
>> > Linux source tree.  It currently works on all archs except it breaks
>> > on x86 which insists on being diferent ;-)
>>
>> That's handy, but I thought strace had such a script already?
>> See HACKING-scripts in strace source. Or is yours much better?
>
> The strace script only gets the syscall numbers (so doesn't help
> cross-check I've applied all arch-specific syscall fixups), doesn't
> work for all arch/ABI combinations without editing unistd.h, and
> requires a configured and partly built kernel for some archs.  It's
> only really useful for getting new syscall numbers which you then
> hand-edit into the real table.  You still have to set the number of
> arguments and check carefully you haven't missed any arch-specific
> fixups.

Your script sounds quite useful then. I might ask for it when I'm
adding support for more archs.

Greetings,

Indan


