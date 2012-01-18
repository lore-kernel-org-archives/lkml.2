Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2AREG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:06:57 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45060 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab2AREG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:06:56 -0500
Message-ID: <d65770456424301eb0537673e4eba48b.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9haQq1a+36ZKn1y7S-RYDo+KQs0rKxH9iN1FBbQsbAL+TA@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
    <1326302710-9427-2-git-send-email-wad@chromium.org>
    <20120112162231.GA23960@redhat.com>
    <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
    <20120112172315.GA26295@redhat.com>
    <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
    <addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
    <CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
    <293e9587acd158b91d7d1793c7e16f7c.squirrel@webmail.greenhost.nl>
    <CABqD9hY2Uhc2Gzy05+Q+_NrZAq+126+avAO0Kd81zDnEi3EXjQ@mail.gmail.com>
    <9642e1197443efe9716f418c4883489e.squirrel@webmail.greenhost.nl>
    <CABqD9haQq1a+36ZKn1y7S-RYDo+KQs0rKxH9iN1FBbQsbAL+TA@mail.gmail.com>
Date: Wed, 18 Jan 2012 05:06:42 +0100
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
 BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: "Oleg Nesterov" <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: f73583079177d89c64161eca494d2c2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'll try to reduce the vebrosity level a bit, for everyone's sake.

On Tue, January 17, 2012 18:37, Will Drewry wrote:
>> If BPF is always 32 bits and people have to deal with the 64 bit pain
>> anyway, you can as well have one fixed ABI that is always the same and
>> cross-platform by just making the arguments always 64 bit, with lower
>> and upper halves in a fixed order to avoid endianness problems. This
>> would be compat and future safe.
>
> What happens if unsigned long is no longer 64-bit in some distant future?

It won't matter, because unsigned long is not used directly and system calls
will stay 64 bit anyway.

Besides that, I don't think unsigned long will ever be bigger than 64-bit.
And if it did, by that time, we can only hope that BPF has gained 64-bit
support and hence a new ABI.

> As to endianness, fixed endianess means that userland programs that
> have a different endianness will need to translate their values.  It's
> just shifting the work around.

No, they never need to translate values. BPF is 32 bit, it doesn't work
on longs directly. If you make it explicit where the upper half of a
64-bit value goes, it can be set and read directly. Only when you access
one half of a 64-bit value through a pointer do you need to worry about
endianness. That doesn't happen with my proposal, it does if the data
you expose contains longs.

> Not really.  I lock down the compat case.  _Even_ with fixed 64-bit
> arguments, you still get system call number mismatches which mean you
> need to keep independent filters for the same task. I had this in one
> of my first implementations and it adds a nasty amount of implicit
> logic during evaluation.

Well, that's why I proposed to have a way to set filters per personality.
Then applications can just blindly install both the 32 and the 64 bit
filters and be assured the kernel picks up the right one. A -1 means
"use current personality", anything else uses the personality given.

Without a persona option you can only install filters for the current
personality, which can be a hassle, especially if the task gets killed
if it changes mode and calls a system call.

>> It's not portable because it is different for every arch.
>
> I was describing the kernel code, not the data set.  By using
> regviews, I get the consistent register view for the personality of
> the process for the architecture it is running on.  This means that
> the user_regs_struct will always be consistent _for the architecture_
> when given to the user's BPF code.  It does not create a portable
> userland ABI but instead uses the existing ABI in a way that is
> arch-agnostic in the kernel (using the regviews interfaces for arch
> fixup).

I argue from user space's point of view, which probably explains most
of our disagreements. :-)

>> And they will get the offsets wrong if they are on 64 bits because those are
>> different than for ptrace. The ptrace ABI uses longs, BPF is fixed to 32 bits,
>> it's just not a good fit.
>
> That's not true on x86-64:
>
>  http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L945
>
> PEEKUSR uses the offsetof() the 32-bit register struct for compat
> calls and, with that macro, maps it to the proper entry in pt_regs.
> For non-compat, it just uses the offset into pt_regs:
>   http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L475
>   lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L170
>
> As there is significant overlap in the contents of user_regs_struct
> and pt_regs on the platform. While it's possible for another arch to
> use a different set of ptrace ABI offsets, using offsetof(struct
> user_regs_struct, ...) will always work.  It is not long-based.
>
> If you want to convince me this isn't a good fit, I need you to meet
> me halfway and make sure your assertions match the code! :)

You're right, the offset is in bytes, not words.

I was looking at my own code, which uses an array of longs and indexes
into that, and got defines for the register indices. So it's my own
abstraction layer that's long-based, not ptrace. with ptrace I use
PTRACE_GETREGS, so I don't use offsets there.

>>>> What special clone/fork registers are you talking about?
>>>
>>> On x86, si is used to indicate the tls area:
>>>   http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/process_32.c#L238
>>> (and r8 on 64-bit).  Also segment registers, etc.
>>
>> si is just the 4th (5th for x86_64) system call argument, it's nothing special.
>
> True - arguably though fork() takes no arguments.  Now
> syscall_get_arguments() won't know that, so si/r8 and all will still
> be exposed for filtering.  For some reason, I thought some other
> pieces were used (EFLAGS?), but I can't back that up in the source.

si is only used when the CLONE_SETTLS flag is set. Fork doesn't set flag,
it comes from a clone argument.

>> System calls never use segment registers directly, do they? It's not part
>> of the system call ABI, so why would you want to use them in filtering?
>
> On x86-32, you may be using segmentation for isolation purposes.  If
> you do so, it may be of interest where the call comes from.  Nothing
> truly relevant, just another possibility.  *shrug*

Isn't EIP an absolute address, corrected for any segmentation?
Or relative to fixed segment registers user space can't change?
Doesn't really matter I suppose.

>
>>>> I don't think anyone would want to ever filter sig_rt_return, you can as
>>>> well kill the process.
>>>
>>> Why make that decision for them?
>>
>> I don't, I'm just saying it doesn't make sense to filter it. Based on what
>> would anyone ever want to filter it? It's just a kernel helper thing to
>> implement signal handlers.
>
> What if you want the process to die if it returns from any signals?

Why would you want that? You can as well send it a SIGKILL at random moments.

>> But now you mention it, it won't be bad to enforce this in the kernel,
>> otherwise everyone has to add code to allow it. Same for exit(_group).
>> Because if those are denied, there's nothing else to run instead.
>
> The process will be do_exit()d.  I don't know why it matters?

Ah, yes, because you kill the process if the filter fails.

Won't it change the return value and exit state?

And in the case of exit_group, do you kill just the thread or the whole
process? Whatever you choose, it either won't be possible to exit one
thread anymore, or any thread exiting kills all threads.

Seems better to always allow it. You may not like the overhead of checking
specific system calls, but it's either hardcoded or done in every filter.
I suppose it doesn't really matter. If it can be done easily in the kernel,
then just do it there. If it's too much of a hassle, push it to the filters.

>> But yeah, better to not provide the instruction or stack pointers indeed.
>> At least the instruction pointer gives some system call related information
>> (from where it is called).
>
> Yup - it's nice to have that.

And it would round up the total of data to 8 fields. My main concern would be
that people try to use it for simplistic security checks and trust it too
much.

>>> That said, I can imagine filtering on other registers as being useful
>>> for tentative research.
>>
>> They can use ptrace for that.
>
> And it will stay research forever.

Speaking from experience, you're probably right. But in our case we really
want to be able to modify registers too, mostly the args. We use the EIP
for system call restarting. But that's not in a performance sensitive path
(one per execve). Modifying the registers in filters is not that useful
for our case because we can't get copy paths to read-only memory from the
BPF anyway.

>> What non-argument register would you like to use on x86? I think all
>> are used up already. All you got left is the segment registers, and
>> using those seems a bad idea.
>
> There are other arches where this would be feasible.

Yes. Like I said:
>> It also seems a bad idea to promote non-portable BPF filtering programs.

> Why?  If it's possible to make a userland abstraction layer, why do we
> force the kernel to take on more work?

Non-portable implies that it is not possible to make a userspace abstraction
layer. Letting the kernel take on slightly more work avoids non-portable
filter programs. Yes, this is limiting, but I think limiting filters isn't
a bad idea.

>
>> If you support modifying arguments and syscall nr then people can keep
>> doing the XORing trick with BPF. Another advantage of allowing that is
>> that unsafe old system calls can be replaced with secure ones on the
>> fly transparently.
>>
>> Really, disallowing modifications is much more limiting than not providing
>> all registers. But allowing modifications is a lot harder to get right
>> with a register interface.
>
> I'm not going to make the change to support BPF making the data
> mutable or using scratch space as an output vector. If that is
> something that makes sense to the networking stack, then we could
> benefit from it, but I don't want to go there.

It doesn't make sense for the networking stack, but it would make BPF
usable for more use cases when used for system call filtering, like
that XOR thing. For our jailer it's not very useful because we need
to copy data to read-only memory. Only other cases where we modify
data are replacing (v)fork with clone with CLONE_PTRACE set for 2.4
kernels, and system call restarting once per execve.

I don't have strong feelings about it, but not supporting it is more
limiting than not providing all registers. That's all.

> It does mean BPF is per-arch, per syscall-convention, but you know I
> am fine with that :)  I do think the performance gains could be well
> worth avoiding any copying.  (Perf gains are the strongest argument I
> think for your proposal and the thing that would likely lead me to do
> it.)

Aesthetics is my main argument against using register views.

>> So call it once and store the value in a long. Then copy the low half
>> to the right place and then the upper half when on 64 bits. It may not
>> look too pretty, but the compiler should be able to optimise almost all
>> overhead away and end up with 6 (or 12) int copies. Something like this:
>>
>> struct bpf_data {
>>        uint32 syscall_nr;
>>        uint32 arg_low[MAX_SC_ARGS];
>>        uint32 arg_high[MAX_SC_ARGS];
>> };
>>
>> void fill_bpf_data(struct task_struct *t, struct pt_regs *r, struct bpf_data *d)
>> {
>>        int i;
>>        unsigned long arg;
>>
>>        d->syscall_nr = syscall_get_nr(t, r);
>>        for (i = 0; i < MAX_SC_ARGS; ++i){
>>                syscall_get_arguments(t, r, i, 1, &arg);
>>                d->arg_low[i] = arg;
>>                d->arg_high[i] = arg >> 32;
>>        }
>> }
>
> Sure, but it seems weird to keep the arguments high and low not
> adjacent, but I realize you want an arch-independent interface.

Yes, that was the idea.

You can achieve the same with an adjacent layout, but then it's easier
to get endianness wrong.

> I guess in that world, you could do this:
>
> {
>   int32_t nr;
>   uint32_t arg32[MAX_SC_ARGS];
>   uint32_t arg64[MAX_SC_ARGS];
>   /* room for future expansion is here */
> };

Isn't that the same?

> Yes - per-arch. If you're already doing per-arch fixup, why ius
> mapping 6 extra registers such a burden?  If the code can't do that in
> userspace, it is slacking.

Fair enough.

>>> Exactly why I'm using user_regs_struct.  I think we've been having
>>> some cross-talk, but I'm not sure.  The only edge case I can find with
>>> user_regs_struct across all platforms is the nasty x86 32-bit entry
>>> from 64-bit personality.  Perhaps someday we can just nuke that path
>>> :)  But even so, it is tightly constrained by saving the personality
>>> and compat flag in the filter program metadata and checking it at each
>>> syscall.
>>
>> I think it's a good idea to nuke that path, it seems like a security hole
>> waiting to happen.
>
> Agreed. And yet we can't (yet?).

Apparently unwritten obscure behaviour may not be broken, in case someone
counts on it. I disagree, because any users can't be sure that compat mode
is supported anyway, so the behaviour is no different than a 64 bit kernel
without compat mode. Oh well.

>> If your ABI is too hard to use directly, it won't be used at all.
>> Any excuse that people won't use this ABI directly is a sign that
>> it is not good enough.
>
> That is blatantly untrue. Have you ever used tcpdump's expression
> language for filtering packets? Wireshark?

Okay, "at all" was stretching it a bit.

>> And the more complicated you make it, the less likely it is that
>> anyone will use this.
>
> Unless there is a nice library that makes it work well.

I beg you, please don't count on this.

BPF will be used for security sensitive code, you really want to keep it simple
and easy to use, otherwise you're just encouraging bugs to happen. Using registers
only adds subtleties for just a tiny performance gain, at best.

>> It could if you make the data part of the scratch memory. If you put the
>> data at the top, just after BPF_MEMWORDS, then it's all compatible with
>> the read-only version. Except the sk_chk_filter() code. But if you ever
>> want to consolidate with the networking version, then you already need
>> new non-byteswapping instructions. You can as well add a special modify
>> instruction too then. Making it very explicit seems better anyway.
>
> I am not going to go this route right now.  If you want to, be my
> guest. We can add BPF instructions later, but I am not going down that
> rabbit hole now.

Agreed.

>> Using BPF for system call filtering changes its very nature already.
>
> No it doesn't.  user_regs_struct becomes another data protocol.

I can't decide whether I agree or disagree. In a way it makes perfect sense,
while yet something inside me screams it's not the same at all.

>> I must say that until your patch came up, I've never heard of BPF filters
>> before. I think I'm going to use it in our ptrace jailer for network
>> filtering, if it's possible to get the peer address for normal TCP/UDP
>> sockets. Documentation is quite vague.
>
> Cool!

I might be the first one to use it on regular sockets instead of raw or
packet sockets though. I fear I'll only get the packet data and no IP
header. But I haven't tried it yet.

>> You could also do the BPF filtering later in the system call entry path
>> when the arguments are passed directly, but then it's harder to interact
>> well with ptrace.
>
> Where? Interpose it into each system call?  The later I put it, the
> less attack surface reduction I get.  The whole point of this
> framework is to reduce the kernel's attack surface by doing minimal
> kernel-side work before making a policy decision.

Agreed.

> Also, I've already gone the ftrace route. As I said in the writeup, I
> don't think it is the right path for this sort of functionality.

Indeed.

>> Ideally, the BPF filter should be able to deny the system call with a
>> specific error code, deny the call and kill the task, have a way to
>> defer to ptrace, and a way to allow it.
>
> Not happening (by my hand :).  I'm not changing seccomp to allow it to
> cause a system call to fail with an error code. I'll add support for
> tracehook integration if this patch can get merged, but I'm not going
> to change the basic semantics of seccomp.

I guess the difference is that you have a somewhat controlled environment
and aren't trying to run arbitrary programs in your jail. Because standard
programs are trying to do stuff they don't really have to all the time,
and killing them for each silly offence would make the jail useless.

It is also crucial in handling new system calls. Glibc does that all the
time, it tries the new version, and if it's not supported, it falls back
to the old one. That's why we return ENOSYS for denied system calls and
that seems to work pretty well.

I guess it would be okay if BPF could somehow defer to ptrace instead of
killing. But without that, this BPF filtering is useless for our generic
jail.

I don't know anything about tracehooks, is that related to ftrace?

> The nice thing is, if we
> reserve return values, this functionality can be layered on later
> without it causing any ABI breakage and with proper consideration
> independent of whether the basic functionality gets merged.

That seems like a good idea.

> Then, if
> you want retool the entire seccomp path on all architectures to allow
> graceful system call failure, it'd be totally doable.

It's trivial if ENOSYS is always returned, then you just change the syscall
nr (that's what I do now). But specific return values are indeed harder
and maybe not worth the trouble.

If this gets in and no one else does it, I'll try to add ptrace support
so they work nicely together.

Greetings,

Indan


