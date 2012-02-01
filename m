Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2BABgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:36:52 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:58861 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2BABgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:36:47 -0500
Message-ID: <bd6c07e54f2a86916550f69013e4dcc6.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
    <1327706681-11959-2-git-send-email-wad@chromium.org>
    <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
    <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
    <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
    <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
    <8a37c5805a9941a8616f1c28245a0880.squirrel@webmail.greenhost.nl>
    <CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com>
Date: Wed, 1 Feb 2012 02:36:17 +0100
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 7a6051f01481ae3e55b4de4b051228fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 31, 2012 12:04, Will Drewry wrote:
> On Mon, Jan 30, 2012 at 7:42 PM, Indan Zupancic <indan@nul.nu> wrote:
>>> I vote for:
>>>
>>> 3. Add tracehook support to all archs.
>
> I don't see these #3 as mutually exclusive :)

They are if you really add tracehook support to all archs. ;-)

> tracehook requires:
> - task_pt_regs()          in asm/processor.h or asm/ptrace.h
> - arch_has_single_step()  if there is hardware single-step support
> - arch_has_block_step()   if there is hardware block-step support
> - asm/syscall.h           supplying asm-generic/syscall.h interface
> - linux/regset.h          user_regset interfaces
> - CORE_DUMP_USE_REGSET    #define'd in linux/elf.h
> -TIF_SYSCALL_TRACE       calls tracehook_report_syscall_{entry,exit}
> - TIF_NOTIFY_RESUME       calls tracehook_notify_resume()
> - signal delivery         calls tracehook_signal_handler()

Okay, that's a bit fuzzier than I expected. I suppose the archs implement
some of that in another way currently?

>>> Maybe not all archs, but at least some more. That way, every time someone
>>> adds something tracehook specific, more archs support it.
>
> Well the other arch I want this on specifically for my purposes is
> arm, but someone recently posted a partial asm/syscall.h for arm, but
> I didn't see that one go anywhere just yet.  (I know syscall_get_nr
> can be tricky on arm because it doesn't (didn't) have a way of
> tracking in-syscall state.)
>
> ref: https://lkml.org/lkml/2011/12/1/131

That totally ignores OABI, it should depend on CONFIG_AEABI and
on !CONFIG_OABI_COMPAT.

>>> syscall.h has no TRACEHOOK defines or anything though.
>
> Nope - it is just part of what is expected.
>
>>> Only syscall_rollback() looks tricky. I have no clue what the difference
>>> between syscall_get_error() and syscall_get_return_value() is. But you
>>> only need to add syscall_get_nr() and syscall_[gs]et_arguments(), which
>>> should be possible for all archs.
>
> It seems even syscall_get_nr can have some wrinkles :)
>
> ref: http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/00096.html

That's 2009! I wonder why no progress happened since then.

At least for SECCOMP you get the syscall nr directly as a parameter,
so you at least don't actually need syscall_get_nr(). Same for ptrace.
That doesn't help for /proc/$PID/syscall or coredumps though.

One solution I can think of for the OABI compat problem is to let the
OABI entry path store the syscall nr in thread_info->syscall and set
an OABI task flag somewhere. Then syscall_get_nr() can check that to
decide between r7 or the stored value. This would help /proc and doesn't
cause any overhead for non-compat syscalls.

Another ugly way of doing it would be to store the trap instruction for
OABI calls, and when user space does a PTRACE_PEEK_TEXT on that it returns
the saved instruction instead of rereading the actual memory. This avoids
races and lets current user space work without modifications. Problem is
that user space can't easily check if it's running on a fixed kernel.

All in all I propose to only support this stuff for kernels not having OABI
support, as that keeps things nice and simple, which was probably the point
of moving to a new ARM ABI anyway. Tough, but that's what you get when you
change ABIs.

>>> How many archs don't support tracehook?
>
> 14 out of 26.  However, 5 of those still have asm/syscall.h

That's a lot of tricky work.

>>> Well, the thing is, this recursion is controlled by user space depending
>>> on how many filters they have installed. What is preventing them to force
>>> you out of stack?
>
> Hrm true.  The easiest option is to just convert it to iterative by
> not using kref_t, but I'll look more closely.

Probably.

>>> So perhaps add at least some arbitrary filter limit to avoid this?
>
> Definitely possible -- probably as a sysctl.  I'm not quite sure what
> number makes sense yet, but I'll look at breaking the recursion first.
>  Thanks!

Please no sysctl. The point of arbitrary limits is that they are
arbitrarily high, but low enough to avoid any problems. A limit
of 1K filters should be plenty for user space, but still put a
limit on the total (memory) overhead of filters.

>>>> I'll clarify a bit.  My original ptrace integration worked such that a
>>>> tracer may only intercept syscall failures if it attached prior to the
>>>> failing filter being installed.  I did it this way to avoid using
>>>> ptrace to escape system call filtering.  However, since I don't have
>>>> that as part of the patch series, it doesn't make sense to keep it. (I
>>>> tracked a tracer pid_struct in the filters.)  If it needs to come back
>>>> with later patchsets, then it can be tackled then!
>>>
>>> The problem of that is that filters can be shared between processes with
>>> different ptracers. And you have all the hassle of keeping it up to date.
>>>
>>> I think seccomp should always come first and just trust ptrace. This
>>> because it can deny all ptrace() calls for filtered tasks, so the only
>>> untrusted tasks doing ptrace() are outside of seccomp's filtering control.
>>> And those could do the same system calls themselves.
>>>
>>> The case where there is one task being filtered and allowed to do ptrace,
>>> but not some other syscall, ptracing another filtered task which isn't
>>> allowed to do ptrace, but allowed to do that other syscall, is quite far
>>> fetched I think. If you really want to handle this, then you could run
>>> the ptracer's filters against the tracee's post-ptrace syscall state.
>>> This is best done in the ptracer's context, just before continuing the
>>> system call. (You really want Oleg's SIKILL immediate patch then.)
>>>
>>> What about:
>>>
>>> 1) Seccomp filters can deny a syscall by killing the task.
>>>
>>> 2) Seccomp can deny a syscall and let it return an error value.
>>>
>>>   I know you're not fond of this one. It's just a performance
>>>   optimisation as sometimes a lot of denied but harmless syscalls
>>>   are called by glibc all the time, like getxattr(). Hardcoding
>>>   the kill policy seems wrong when it can be avoided. If this is
>>>   too hard then skip it, but if it's easy to add then please do.
>>>   I'll take a look at this with your next patch version.
>
> It's easy on x86 harder on other arches.  I would suggest saving
> changing the __secure_computing signature until after the core
> functionality lands, but that's just me.

The only problem of that is that you will have two versions of seccomp
filtering in the wild: One that does support this, and one that doesn't.

It seems cleaner to consolidate the seccomp entry path with the ptrace path,
and do the seccomp check first in there. This saves a few instructions on
some archs for the seccomp check too and would simplify the entry code of
most archs.

Ptrace is expected to change the syscall nr already, so that can be used
to set it to -1 or something. A different return value than -ENOSYS can
be set in the syscall exit path, if required. All this can be shared with
PTRACE_SYSEMU.

I don't know.

>>> 3) Seccomp can allow a syscall to proceed normally.
>>>
>>> 4) Seccomp can set a hint to skip ptrace syscall events for this syscall.
>>>   A filter sets this by returning a specific value.
>>>
>>> 5) Ptrace always gets a syscall event when it asked for it.
>>>
>>> 6) Ptrace can set an option to honour seccomp's hint and to not get all
>>>   syscall events.
>>>
>>> This way all seccomp needs to do is to set some flags which ptrace can check.
>
> I like the use of flags/options to trigger ptrace handling.  If I were
> to stack rank these for pursuit after the core functionality lands,
> it'd be to add #6 (and its deps) then #2.  With #6, #2 can be
> simulated (by having a supervisor that changes the syscall number to
> -1), but that is much less ideal than just returning SECCOMP_ERROR
> instead of SECCOMP_ALLOW/DENY and letting an error code get bubbled
> up.

But it would require two filter versions and hence make it more difficult
to generally support BPF syscall filtering.

Greetings,

Indan


