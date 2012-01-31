Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2AaBnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:43:23 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:47221 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2AaBnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:43:21 -0500
Message-ID: <8a37c5805a9941a8616f1c28245a0880.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
    <1327706681-11959-2-git-send-email-wad@chromium.org>
    <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
    <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
    <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
    <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
Date: Tue, 31 Jan 2012 02:42:55 +0100
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
X-Scan-Signature: 503f1a2b1db20d3cc8283cfb339c155f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, January 30, 2012 23:26, Will Drewry wrote:
> Do you think something along the lines of 2 kB is sane for a config-less change?

Yes, especially if there is some way to get rid of it anyway,
like disabling SECCOMP or some option under CONFIG_EMBEDDED.
But it seems you need at least a hidden config option which
depends on the stuff you need.

>
> Doing exactly that.  I've been tinkering with the best way to minimize
> the impact to the existing BPF evaluator.  Right now, I'm adding a
> very small number of new instructions to the sk_buff specific code
> path, but I haven't yet benchmarked - just disasssembled.

I would do all the checking in sk_chk_filter(), so you know that when
you do run the filter, you can't hit the sk_buff paths. This doesn't
cause any slow down for the networking path.

> I agree. I will post the next series with a proposed integration. If
> there is a lot of resistance, then the difference will be going from a
> 2kB changes to a 3kB change.

Let's see how it goes.

>> I think you should go on a quest to make sure (almost) all archs have that file,
>> before this patch can be merged. At least the archs that have ptrace support.
>
> I'm an idiot.  CONFIG_HAVE_ARCH_TRACEHOOK covers asm/syscall.h
>
> So I have two choices:
> 1. allow seccomp with filtering on these platforms by fail if an
> argument is accessed
> 2. return ENOSYS when a filter is attempted to be installed on
> platforms with no tracehook support.

I vote for:

3. Add tracehook support to all archs.

Maybe not all archs, but at least some more. That way, every time someone
adds something tracehook specific, more archs support it.

syscall.h has no TRACEHOOK defines or anything though.

Only syscall_rollback() looks tricky. I have no clue what the difference
between syscall_get_error() and syscall_get_return_value() is. But you
only need to add syscall_get_nr() and syscall_[gs]et_arguments(), which
should be possible for all archs.

How many archs don't support tracehook?

>
> I think #2 is the nicest user contract, but #1 allows working filters
> even on less hospitable arches even if they can't user arguments
> (yet).  I'm coding it up as #2, but it is easy to switch to #1.

If you don't support the arch, don't compile any code at all, and
let prctl(2) return EINVAL. You don't want to return ENOSYS.

> I'm attempting to couple it now. If there are concerns, but not about
> code size, then the config option could just control whether it
> returns -ENOSYS or not.

If there are other concerns then it shouldn't be merged.

> After cleaning things up, I was going to change it to copy_seccomp()
> to match other copy_process-called functions.  I can keep it
> seccomp_fork() or whatever though :)

Nah.

> I'm just going to try to go all out with a network merge right now. We'll see.

Good.

>> Oh wait, I missed this before: Just use the existing networking filter.h
>> instead of redefining anything, and only add seccomp specific stuff to
>> your file, the seccomp_filter_data.
>
> Doing that and I'll rename seccomp_filter_data to just seccomp_data.

Good.

>> struct seccomp_filter_data {
>>        int syscall_nr;
>>        unsigned int arg_lo[6];
>>        unsigned int arg_hi[6];
>>        int __reserved[3];
>> };
>>
>> I'm not sure what the advantage of using __u32 would be, I think we can count on
>> unsigned int always being 32 bits?
>
> Sure - bpf uses u32 as its accumulator value, so I was sticking with
> the matching type. sock_filters also use u32 for k.
>
> Since they should be the same, it doesn't matter, but I liked keeping
> them the same.  I can change them if it is necessary.

Nah.

>> (Is my email client mangling tabs or is yours?)
>
> Probably mine - sorry :/

Mine didn't use to do it, so I was quite confused by the whitespace changes.

> Yeah and BPF going 64-bit would be a complete change of user space
> ABI, so if it went that route, it could also include an alternate
> struct definition.

True.

>> I'm just giving my opinion of course, I would like to know what other
>> people prefer as well.
>
> It's appreciated.  Hopefully once the next changes settle down, we'll
> see some more opinions.

Looking forward to it!

>> Yeah, I figured that out later on. It's quite nifty, but I find the recursion
>> within kref_put() slightly worrisome. Perhaps the code would be cleaner if this
>> was avoided and done differently, but I can't think of a good alternative. I'll
>> wait for the new version to see if I can find a way.
>
> Thanks - sure.  Since kref_put is just an atomic_dec_and_test followed
> by a call to the function pointer, I wasn't too concerned.  Without
> changing how the relationships are handled, I'm not sure how to
> approach it differently (and still avoid races). IIRC, this isn't much
> different to how namespaces work, they just use their own atomic
> counters.

Well, the thing is, this recursion is controlled by user space depending
on how many filters they have installed. What is preventing them to force
you out of stack?

So perhaps add at least some arbitrary filter limit to avoid this?

> I've done it that way now. I still need to test both the functionality
> and the performance.

Considering the alternative is ptrace, I wouldn't worry too much about
performance. But I think the networking people would really dislike a
slowdown, so focus on that first.

>> I would go for forcing alignment, unaligned accesses on arguments don't make
>> much sense. Only unaligned access that makes sense is reading the two middle
>> bytes of an int. So I would force all accesses to fall within 32 bits. This
>> avoids the unaligned loading problem and would make load_pointer() stateless.
>
> Works for me and how I've changed it now.  It's always easy to relax
> this restriction later if it is really needed.

Indeed.

> I'll clarify a bit.  My original ptrace integration worked such that a
> tracer may only intercept syscall failures if it attached prior to the
> failing filter being installed.  I did it this way to avoid using
> ptrace to escape system call filtering.  However, since I don't have
> that as part of the patch series, it doesn't make sense to keep it. (I
> tracked a tracer pid_struct in the filters.)  If it needs to come back
> with later patchsets, then it can be tackled then!

The problem of that is that filters can be shared between processes with
different ptracers. And you have all the hassle of keeping it up to date.

I think seccomp should always come first and just trust ptrace. This
because it can deny all ptrace() calls for filtered tasks, so the only
untrusted tasks doing ptrace() are outside of seccomp's filtering control.
And those could do the same system calls themselves.

The case where there is one task being filtered and allowed to do ptrace,
but not some other syscall, ptracing another filtered task which isn't
allowed to do ptrace, but allowed to do that other syscall, is quite far
fetched I think. If you really want to handle this, then you could run
the ptracer's filters against the tracee's post-ptrace syscall state.
This is best done in the ptracer's context, just before continuing the
system call. (You really want Oleg's SIKILL immediate patch then.)

What about:

1) Seccomp filters can deny a syscall by killing the task.

2) Seccomp can deny a syscall and let it return an error value.

   I know you're not fond of this one. It's just a performance
   optimisation as sometimes a lot of denied but harmless syscalls
   are called by glibc all the time, like getxattr(). Hardcoding
   the kill policy seems wrong when it can be avoided. If this is
   too hard then skip it, but if it's easy to add then please do.
   I'll take a look at this with your next patch version.

3) Seccomp can allow a syscall to proceed normally.

4) Seccomp can set a hint to skip ptrace syscall events for this syscall.
   A filter sets this by returning a specific value.

5) Ptrace always gets a syscall event when it asked for it.

6) Ptrace can set an option to honour seccomp's hint and to not get all
   syscall events.

This way all seccomp needs to do is to set some flags which ptrace can check.

Greetings,

Indan


