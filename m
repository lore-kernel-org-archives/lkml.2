Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2AaPSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:18:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52473 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2AaPSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:18:53 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
	<CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
	<13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
	<CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
	<8a37c5805a9941a8616f1c28245a0880.squirrel@webmail.greenhost.nl>
	<CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com>
Date: Tue, 31 Jan 2012 08:18:51 -0700
Message-ID: <CABqD9ha9g-8zE6bTt=67LFCbt-y3nGvOOatZoDbFxn=mM0Fy_g@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 4:04 AM, Will Drewry <wad@chromium.org> wrote:
> On Mon, Jan 30, 2012 at 7:42 PM, Indan Zupancic <indan@nul.nu> wrote:
>> On Mon, January 30, 2012 23:26, Will Drewry wrote:
>>> Do you think something along the lines of 2 kB is sane for a config-less change?
>>
>> Yes, especially if there is some way to get rid of it anyway,
>> like disabling SECCOMP or some option under CONFIG_EMBEDDED.
>> But it seems you need at least a hidden config option which
>> depends on the stuff you need.
>
> Disabling SECCOMP would definitely do it.
>
>>>
>>> Doing exactly that.  I've been tinkering with the best way to minimize
>>> the impact to the existing BPF evaluator.  Right now, I'm adding a
>>> very small number of new instructions to the sk_buff specific code
>>> path, but I haven't yet benchmarked - just disasssembled.
>>
>> I would do all the checking in sk_chk_filter(), so you know that when
>> you do run the filter, you can't hit the sk_buff paths. This doesn't
>> cause any slow down for the networking path.
>
> Ah sorry - I was referring to the intrusion of a load_pointer function
> pointer.  I want to leave the current networking path as untouched as
> possible.  For checking, I agree -- a quick change to sk_chk_filter or
> even just a small helper function that scans for any codes in the
> ancillary range will do the trick.

I see now. I can do all the fixup in sk_chk_filter. Clever!  Sorry for
not catching on faster :)

>
>>> I agree. I will post the next series with a proposed integration. If
>>> there is a lot of resistance, then the difference will be going from a
>>> 2kB changes to a 3kB change.
>>
>> Let's see how it goes.
>>
>>>> I think you should go on a quest to make sure (almost) all archs have that file,
>>>> before this patch can be merged. At least the archs that have ptrace support.
>>>
>>> I'm an idiot.  CONFIG_HAVE_ARCH_TRACEHOOK covers asm/syscall.h
>>>
>>> So I have two choices:
>>> 1. allow seccomp with filtering on these platforms by fail if an
>>> argument is accessed
>>> 2. return ENOSYS when a filter is attempted to be installed on
>>> platforms with no tracehook support.
>>
>> I vote for:
>>
>> 3. Add tracehook support to all archs.
>
> I don't see these #3 as mutually exclusive :)  tracehook requires:
> - task_pt_regs()          in asm/processor.h or asm/ptrace.h
> - arch_has_single_step()  if there is hardware single-step support
> - arch_has_block_step()   if there is hardware block-step support
> - asm/syscall.h           supplying asm-generic/syscall.h interface
> - linux/regset.h          user_regset interfaces
> - CORE_DUMP_USE_REGSET    #define'd in linux/elf.h
> -TIF_SYSCALL_TRACE       calls tracehook_report_syscall_{entry,exit}
> - TIF_NOTIFY_RESUME       calls tracehook_notify_resume()
> - signal delivery         calls tracehook_signal_handler()
>
>> Maybe not all archs, but at least some more. That way, every time someone
>> adds something tracehook specific, more archs support it.
>
> Well the other arch I want this on specifically for my purposes is
> arm, but someone recently posted a partial asm/syscall.h for arm, but
> I didn't see that one go anywhere just yet.  (I know syscall_get_nr
> can be tricky on arm because it doesn't (didn't) have a way of
> tracking in-syscall state.)
>
> ref: https://lkml.org/lkml/2011/12/1/131
>
>> syscall.h has no TRACEHOOK defines or anything though.
>
> Nope - it is just part of what is expected.
>
>> Only syscall_rollback() looks tricky. I have no clue what the difference
>> between syscall_get_error() and syscall_get_return_value() is. But you
>> only need to add syscall_get_nr() and syscall_[gs]et_arguments(), which
>> should be possible for all archs.
>
> It seems even syscall_get_nr can have some wrinkles :)
>
> ref: http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/00096.html
>
>> How many archs don't support tracehook?
>
> 14 out of 26.  However, 5 of those still have asm/syscall.h
>
>>> I think #2 is the nicest user contract, but #1 allows working filters
>>> even on less hospitable arches even if they can't user arguments
>>> (yet).  I'm coding it up as #2, but it is easy to switch to #1.
>>
>> If you don't support the arch, don't compile any code at all, and
>> let prctl(2) return EINVAL. You don't want to return ENOSYS.
>
> I was thinking of the inline prctl handler, but EINVAL makes sense.
>
>>>> Yeah, I figured that out later on. It's quite nifty, but I find the recursion
>>>> within kref_put() slightly worrisome. Perhaps the code would be cleaner if this
>>>> was avoided and done differently, but I can't think of a good alternative. I'll
>>>> wait for the new version to see if I can find a way.
>>>
>>> Thanks - sure.  Since kref_put is just an atomic_dec_and_test followed
>>> by a call to the function pointer, I wasn't too concerned.  Without
>>> changing how the relationships are handled, I'm not sure how to
>>> approach it differently (and still avoid races). IIRC, this isn't much
>>> different to how namespaces work, they just use their own atomic
>>> counters.
>>
>> Well, the thing is, this recursion is controlled by user space depending
>> on how many filters they have installed. What is preventing them to force
>> you out of stack?
>
> Hrm true.  The easiest option is to just convert it to iterative by
> not using kref_t, but I'll look more closely.
>
>> So perhaps add at least some arbitrary filter limit to avoid this?
>
> Definitely possible -- probably as a sysctl.  I'm not quite sure what
> number makes sense yet, but I'll look at breaking the recursion first.
>  Thanks!
>
>>> I'll clarify a bit.  My original ptrace integration worked such that a
>>> tracer may only intercept syscall failures if it attached prior to the
>>> failing filter being installed.  I did it this way to avoid using
>>> ptrace to escape system call filtering.  However, since I don't have
>>> that as part of the patch series, it doesn't make sense to keep it. (I
>>> tracked a tracer pid_struct in the filters.)  If it needs to come back
>>> with later patchsets, then it can be tackled then!
>>
>> The problem of that is that filters can be shared between processes with
>> different ptracers. And you have all the hassle of keeping it up to date.
>>
>> I think seccomp should always come first and just trust ptrace. This
>> because it can deny all ptrace() calls for filtered tasks, so the only
>> untrusted tasks doing ptrace() are outside of seccomp's filtering control.
>> And those could do the same system calls themselves.
>>
>> The case where there is one task being filtered and allowed to do ptrace,
>> but not some other syscall, ptracing another filtered task which isn't
>> allowed to do ptrace, but allowed to do that other syscall, is quite far
>> fetched I think. If you really want to handle this, then you could run
>> the ptracer's filters against the tracee's post-ptrace syscall state.
>> This is best done in the ptracer's context, just before continuing the
>> system call. (You really want Oleg's SIKILL immediate patch then.)
>>
>> What about:
>>
>> 1) Seccomp filters can deny a syscall by killing the task.
>>
>> 2) Seccomp can deny a syscall and let it return an error value.
>>
>>   I know you're not fond of this one. It's just a performance
>>   optimisation as sometimes a lot of denied but harmless syscalls
>>   are called by glibc all the time, like getxattr(). Hardcoding
>>   the kill policy seems wrong when it can be avoided. If this is
>>   too hard then skip it, but if it's easy to add then please do.
>>   I'll take a look at this with your next patch version.
>
> It's easy on x86 harder on other arches.  I would suggest saving
> changing the __secure_computing signature until after the core
> functionality lands, but that's just me.
>
>> 3) Seccomp can allow a syscall to proceed normally.
>>
>> 4) Seccomp can set a hint to skip ptrace syscall events for this syscall.
>>   A filter sets this by returning a specific value.
>>
>> 5) Ptrace always gets a syscall event when it asked for it.
>>
>> 6) Ptrace can set an option to honour seccomp's hint and to not get all
>>   syscall events.
>>
>> This way all seccomp needs to do is to set some flags which ptrace can check.
>
> I like the use of flags/options to trigger ptrace handling.  If I were
> to stack rank these for pursuit after the core functionality lands,
> it'd be to add #6 (and its deps) then #2.  With #6, #2 can be
> simulated (by having a supervisor that changes the syscall number to
> -1), but that is much less ideal than just returning SECCOMP_ERROR
> instead of SECCOMP_ALLOW/DENY and letting an error code get bubbled
> up.
>
> thanks!
> will
