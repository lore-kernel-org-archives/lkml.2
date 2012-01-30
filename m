Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2A3W1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:27:03 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54613 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2A3W05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:26:57 -0500
MIME-Version: 1.0
In-Reply-To: <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<1327706681-11959-2-git-send-email-wad@chromium.org>
	<c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
	<CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
	<13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
Date: Mon, 30 Jan 2012 16:26:55 -0600
Message-ID: <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
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

On Sun, Jan 29, 2012 at 8:37 PM, Indan Zupancic <indan@nul.nu> wrote:
>> On Sat, Jan 28, 2012 at 10:39 PM, Indan Zupancic <indan@nul.nu> wrote:
...
> Actually, now I think about it, the current networking BPF programs
> aren't binary portable either, because of the endianness of 32-bit
> integers. It's still cleaner to have one structure layout instead
> of two though.

I agree. I'm changing it all out now.
...
>>> If this is added, then this will be seccomp,
>>> and the old mode can be seen as a standard, very restrictive filter.
>>
>> This is totally true.  I originally did not pursue this because I
>> would have needed 1 hardcoded BPF filter per arch.  With the new
>> syntax, I believe it will be possible to define a 32-bit filter and a
>> 64-bit filter (and a compat filter) in one central place.
>
> I only meant conceptually, I don't think it's a good idea to actually
> do that with a hard-coded filter!

No fun :)


>> The network filtering code adds one function that is a switch
>> statement over the possible valid values.  This doesn't duplicate the
>> checking code.
>
> Yes, but that doesn't answer my question.

Sorry - it added approx 861 bytes.

> The advantage of using the network code would be to reduce the only impact
> this has for people not using it: Kernel binary size. So if you want it to
> be small enough that it's not worth a separate config option, then it has
> to be tiny.

I'm still in the process of reworking based on the discussions we've
had, but I've already dropped 3kB of bloat.  Relying on
net/core/filter.c dropped off the 861 and only increased its size 292
bytes.  Merging with seccomp.c and cleaning up the functions is
helping frop the rest.  The current changes to seccomp.o add 2148
bytes to a x86_32 build.  Hopefully when I'm done cleaning up, it'll
be smaller.

Do you think something along the lines of 2 kB is sane for a config-less change?

...
>> The reason that I am not merging upfront is because the load_pointer
>> and byte swapping behavior is hard-coded in the current versions.  I
>
> Just move the byte swapping into the networking load_pointer(), and
> add an extra function pointer argument which tells which load_pointer()
> function to call.

Doing exactly that.  I've been tinkering with the best way to minimize
the impact to the existing BPF evaluator.  Right now, I'm adding a
very small number of new instructions to the sk_buff specific code
path, but I haven't yet benchmarked - just disasssembled.

>> believe it will be possible to add a layer of abstraction that doesn't
>> induce additional overhead, but I didn't want to force that first.  If
>> that will really be a blocker, then I will go ahead and do that first.
>> I was just worried that the potential performance impact discussions
>> could lead this patch to a dead end before it got a chance.
>
> To know how much it is needed depends on what the difference in kernel
> size is with and without CONFIG_SECCOMP_FILTER. If it's 4kB then you
> may have a good point arguing that it may not be worth consolidating.
> But considering that you already depend on the networking checking code,
> it just seems cleaner to share everything and to make it explicit. This
> avoids problems in the future when people change the networking checking
> code without being aware that it is being used elsewhere too.

I agree. I will post the next series with a proposed integration. If
there is a lot of resistance, then the difference will be going from a
2kB changes to a 3kB change.

> And performance differences can and should be measured. You don't want
> to accidentally slow down all system calls, so it's good to double
> check that you don't.

Agreed.

>> Right now it requires asm/syscall.h which CONFIG_SECCOMP doesn't.
>> Some arches still haven't implemented that file so I thought it would
>> make sense to keep it separate.
>
> I think you should go on a quest to make sure (almost) all archs have that file,
> before this patch can be merged. At least the archs that have ptrace support.

I'm an idiot.  CONFIG_HAVE_ARCH_TRACEHOOK covers asm/syscall.h

So I have two choices:
1. allow seccomp with filtering on these platforms by fail if an
argument is accessed
2. return ENOSYS when a filter is attempted to be installed on
platforms with no tracehook support.

I think #2 is the nicest user contract, but #1 allows working filters
even on less hospitable arches even if they can't user arguments
(yet).  I'm coding it up as #2, but it is easy to switch to #1.


>> Would it make sense to start with a config option then merge later or
>> should it be done upfront?
>
> Yes, I think that would make sense. But I also think no one will enable it
> if it's a separate option because it's just very obscure (especially because
> no one uses it yet). So if it's good enough it should be enabled by default,
> at least for the archs that are supported. If it's coupled to SECCOMP, you
> can bundle it with that (and networking).

I'm attempting to couple it now. If there are concerns, but not about
code size, then the config option could just control whether it
returns -ENOSYS or not.


>>>> +extern void seccomp_struct_fork(struct seccomp_struct *child,
>>>> +                             const struct seccomp_struct *parent);
>>>
>>> Lousy function name, what is it doing?
>>
>> Now it is called seccomp_fork() and it is called by fork when a task
>> fork()s :)  Naming suggestions welcome!
>
> That's better. My mind automatically associated the 'struct' with the fork,
> which didn't make sense.

After cleaning things up, I was going to change it to copy_seccomp()
to match other copy_process-called functions.  I can keep it
seccomp_fork() or whatever though :)

>> Neither are the networking code defines :)  They are exported to
>> userspace but I don't believe they've ever changed.
>
> Probably because they are useless as they can only be checked at compile time,
> while the kernel version they are run on can be different. But if you want to
> reuse the existing tools to create BPF filters, being compatible with the
> networking code would be handy.

I'm just going to try to go all out with a network merge right now. We'll see.

> Oh wait, I missed this before: Just use the existing networking filter.h
> instead of redefining anything, and only add seccomp specific stuff to
> your file, the seccomp_filter_data.

Doing that and I'll rename seccomp_filter_data to just seccomp_data.

> struct seccomp_filter_data {
>        int syscall_nr;
>        unsigned int arg_lo[6];
>        unsigned int arg_hi[6];
>        int __reserved[3];
> };
>
> I'm not sure what the advantage of using __u32 would be, I think we can count on
> unsigned int always being 32 bits?

Sure - bpf uses u32 as its accumulator value, so I was sticking with
the matching type. sock_filters also use u32 for k.

Since they should be the same, it doesn't matter, but I liked keeping
them the same.  I can change them if it is necessary.

> (Is my email client mangling tabs or is yours?)

Probably mine - sorry :/

>> It just means two copies for every system call argument instead of
>> one, but who knows, maybe the compiler will magic it away.
>> Regardless, any argument access will always be slightly slower than
>> just syscall number, so it doesn't hurt if the extra copy doesn't go
>> away.
>
> True. If you add 64 bit support to BPF then your way is much better of
> course. But as long as it is 32-bit I don't think it makes much sense
> to make it more complicated than necessary.

Yeah and BPF going 64-bit would be a complete change of user space
ABI, so if it went that route, it could also include an alternate
struct definition.

> Your way it's a lot harder to see what the actual data layout is, including
> offsets. My way the offset to the low bits is arg_nr * sizeof(int), if
> counting args at 1 instead of 0, which is usually done with args (at least
> by gcc).

Yeah -- it is cleaner across the board I think.

>> I just want an abi that is functional across platforms that people are
>> happy enough to merge.  The one I posted is fine with me and so is
>> your proposal.  So if no one else has strong opinions, I'll just use
>> yours :)
>
> I'm just giving my opinion of course, I would like to know what other
> people prefer as well.

It's appreciated.  Hopefully once the next changes settle down, we'll
see some more opinions.

...
>>>> +     seccomp_struct_fork(&p->seccomp, &current->seccomp);
>>>
>>> This can be moved above, before the first error goto.
>>
>> As in where seccomp_struct_init_task is or somewhere else?  (Where
>> seccomp_init_task is would make sense.)
>
> Around there yes. It needs to  be always executed, before free_task() may be called
> because of an error path.

Makes sense - thanks!

...
>>  if (!seccomp_test_filters(this_syscall))
>>    return;
>>
>> if that'd read better?
>
> Considering you're going to add more return values later, I would let
> seccomp_test_filters() return the filter code and stuff it in a temporary
> variable and work on that instead, and use SECCOMP_BPF_DENY/ALLOW to make
> clear what's happening. It's a bit more code, but it's clearer how we got
> to our decision.
>
> And perhaps rename seccomp_test_filters() to seccomp_run_filters(), for
> consistency with the networking code.
>
> But do whatever you prefer, it doesn't matter much.

Sounds good. I'll bubble it up some of the way, then if new error
codes come, those can be wired up easily.

>>> I guess the code will be clearer than the comment. Parent task or filter?
>>> Is it a reverse linked list or something? I'm confused.
>>
>> I'll try to rewrite it.  The parent filter is whatever filter was
>> installed on the task at the time the current filter was installed.
>> It may have been inherited or be part of a sequence of filters
>> installed by the same task.
>
> I think I would just call it 'next' or 'prev', but that's me. 'parent' is slightly
> confusing in task context. The filter may come from the parent process, but it could
> as well be installed by the same process.

Agreed.

...
>>>> +     struct {
>>>> +             uint32_t compat:1;
>>>> +     } flags;
>>>
>>> This flag isn't documented above.
>>
>> Oops dropped it for a rev - I'll re-add it. Thanks!
>
> And in case you missed my comment below, change it to a bool?

Thanks - I'll do that.

...
>>>> +struct seccomp_filter_metadata {
>>>> +     struct seccomp_filter_data data;
>>>> +     bool has_args;
>>>> +};
>>>
>>> Why use 'bool' instead of a nifty struct { uint32_t : 1 }?
>>>
>>> It seems that has_args is something that should be stored elsewhere,
>>> it doesn't seem to warrant its own structure.
>>
>> Well it would naturally live inside the BPF evaluator since the
>> loading is done in load_pointer.  This struct is just used to marshal
>> the state around.
>
> I think load_pointer() is better off being stateless.

Agreed and it is now -- exactly as you described -- simple switch statement.

>>>> +
>>>> +static unsigned int seccomp_run_filter(void *, uint32_t,
>>>> +                                    const struct sock_filter *);
>>>
>>> It almosts fits, just put it on one line.
>>
>> I'm just doing what checkpatch suggests :)  Would it read better if I
>> bumped all the args down a line?
>
> No, just ignore checkpatch and put it on one line.

Hehe

> If you can't live with the warning, change the return value to int or
> drop the seccomp_ bit, as it's a local static function anyway. Or just
> move the function above its first use so you don't need this.

It doesn't matter if I used the networking one, but I'll reorganize
the files to avoid needless prototypes.

...
>>>> +static void seccomp_filter_free(struct seccomp_filter *filter)
>>>> +{
>>>> +     if (!filter)
>>>> +             return;
>>>> +     put_seccomp_filter(filter->parent);
>>>
>>> Why do put on the parent here?
>>
>> filters may be shared across tasks and there may be multiple filters
>> per-task.  The references keep them alive beyond the life of the
>> originating task_struct or if they are not hanging off of the
>> task_struct directly.  In order for them to ever die, the reference to
>> them needs to be dropped and that's done here.
>
> Yeah, I figured that out later on. It's quite nifty, but I find the recursion
> within kref_put() slightly worrisome. Perhaps the code would be cleaner if this
> was avoided and done differently, but I can't think of a good alternative. I'll
> wait for the new version to see if I can find a way.

Thanks - sure.  Since kref_put is just an atomic_dec_and_test followed
by a call to the function pointer, I wasn't too concerned.  Without
changing how the relationships are handled, I'm not sure how to
approach it differently (and still avoid races). IIRC, this isn't much
different to how namespaces work, they just use their own atomic
counters.

>> I'm using what the bpf code specifies already.  Otherwise I would use
>> an unsigned int. I guess I could cast.
>
> The networking code uses negative indices to get to ancillary data.
>
> I would make it unsigned from the start or make just the 'offset' argument unsigned.

Makes sense.  I just cast it locally unsigned and let the compiler
handle it.  (And for my current build it even saved an extra 20 bytes
:)

>>> Wasn't the idea that arguments would be loaded on demand?
>>
>> Yes and they are and then cached.
>
> I mean individually loaded on demand, not all or nothing. Usually only one
> or two args are checked, and never rechecked, so caching doesn't make sense.

I've done it that way now. I still need to test both the functionality
and the performance.

>>> And as arguments are usually only checked once and not twice, caching the
>>> values isn't really needed. So perhaps get rid of the (meta)data structure
>>> and just have a switch that returns the right data directly depending on
>>> the offset? It seems the over all code would be simpler that way.
>>
>> Not really. You can make a case statement per range of offsets that
>> overlap with an argument, but that doesn't account for size.  You
>> could load a long across two arguments.  We're not enforcing alignment
>> as the networking code doesn't either.  I could have it fail if the
>> request is not 32-bit aligned.  I don't prefer that, but it would
>> simplify the code.  It's certainly easier to change the ABI later to
>> provide unaligned access then it is to make it aligned later, so I can
>> change to aligned requests only that return the appropriate 32-bit
>> slice of the data.
>
> I would go for forcing alignment, unaligned accesses on arguments don't make
> much sense. Only unaligned access that makes sense is reading the two middle
> bytes of an int. So I would force all accesses to fall within 32 bits. This
> avoids the unaligned loading problem and would make load_pointer() stateless.

Works for me and how I've changed it now.  It's always easy to relax
this restriction later if it is really needed.

...
>>>> +     /* Only allow a system call if it is allowed in all ancestors. */
>>>> +     ret = 0;
>>>> +     for ( ; filter != NULL; filter = filter->parent) {
>>>> +             /* Allowed if return value is SECCOMP_BPF_ALLOW */
>>>> +             if (seccomp_run_filter(&metadata, sizeof(metadata.data),
>>>> +                                     filter->insns) != SECCOMP_BPF_ALLOW)
>>>> +                     ret = -EACCES;
>>>
>>> Why keep checking filters if one of them fails? Just return -EACCES?
>>
>> Why optimize for a failure mode?  Since fails are terminal, I don't
>> see any reason to rush :) That said, this was more relevant when I had
>> ptrace integration that depended on knowing which filter the failure
>> occurred in. I'll change it.
>
> I'd guess that would be easier if any failure would break the loop.
> But I don't think there's a good way to tell ptrace which filter
> it is because there is no way to identify them. And filters may be
> installed before the ptrace process, so numbering them doesn't always
> work either. And ptrace has all the same info as the filters, so it
> could figure it out for itself.

I'll clarify a bit.  My original ptrace integration worked such that a
tracer may only intercept syscall failures if it attached prior to the
failing filter being installed.  I did it this way to avoid using
ptrace to escape system call filtering.  However, since I don't have
that as part of the patch series, it doesn't make sense to keep it. (I
tracked a tracer pid_struct in the filters.)  If it needs to come back
with later patchsets, then it can be tackled then!

...
>>>> +     /*
>>>> +      * If there is an existing filter, make it the parent
>>>> +      * and reuse the existing task-based ref.
>>>
>>> You're not reusing the existing task-based ref, are you?
>>>
>>> You can't reuse it anyway. Perhaps and old leftover comment?
>>
>> I am reusing it.  When current->seccomp.filter is installed -- via
>> fork or attach -- a get_ is done.  That is for the task.  Here, we are
>> bumping current->seccomp.filter to filter->parent without calling
>> put_.  This reuses the task ref for the older filter.  The new filter
>> has a ref already from during alloc and that is transferred for use by
>> the task.
>
> I would expect "reusing" to mean that you start with the old reference count,
> or use an existing kref instead of a new one. Neither happens. What you're
> doing seems more like just using it.

Works for me either way.

...
>>> All in all it seems fairly easy to consolidate this with the networking code.
>>> The only big change would be that the load_pointer() function pointer needs to
>>> be passed, that way the same code can be used for both versions. The filter
>>> checking code needs be expanded to check for network-only ops and reject the
>>> filter if it's a seccomp one.
>>
>> Also byteswapping.  I think this can be done by adding pointer to the
>> accumulator to load_pointer, then let that do the byteswapping too.  I
>
> I would change load_pointer() to return the (byteswapped) value instead.
> It gets all the info it needs to know what to do via 'size'. Oh bugger,
> that messes up the error checking. Oh well.

Yeah - you end up needing to return something to indicate success or
failure along with populating the accumulator.  I've added a generic
call into the evaluator with a fallback to the network path - to keep
it on as fast a path as possible.


Thanks!
will
