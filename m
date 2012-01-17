Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2AQRhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:37:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38761 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2AQRhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <9642e1197443efe9716f418c4883489e.squirrel@webmail.greenhost.nl>
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
Date: Tue, 17 Jan 2012 11:37:12 -0600
Message-ID: <CABqD9haQq1a+36ZKn1y7S-RYDo+KQs0rKxH9iN1FBbQsbAL+TA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:46 AM, Indan Zupancic <indan@nul.nu> wrote:
> On Mon, January 16, 2012 21:12, Will Drewry wrote:
>> On Mon, Jan 16, 2012 at 12:49 AM, Indan Zupancic <indan@nul.nu> wrote:
>>> Hello,
>>>
>>> On Mon, January 16, 2012 02:40, Will Drewry wrote:
>>>> On Sat, Jan 14, 2012 at 9:40 PM, Indan Zupancic <indan@nul.nu> wrote:
>>>>> On Sat, January 14, 2012 00:10, Will Drewry wrote:
>>>>>> Any thoughts?
>>>>>>
>>>>>> I'll do a v5 rev for Eric's comments soon, but I'm not quite sure
>>>>>> about the pt_regs
>>>>>> change yet. �If the performance boost is worth the effort of having a
>>>>>> per-arch fixup,
>>>>>> I can go that route. �Otherwise, I could look at some alternate approach
>>>>>> for a faster-than-regview payload.
>>>>>
>>>>> I recommend not giving access to the registers at all, but to instead provide
>>>>> a fixed cross-platform ABI (a 32 bit version and one 64 bit version).
>>>>
>>>> I don't believe it is possible to create a fixed cross-platform ABI
>>>> that will be compat and future safe.
>>>
>>> The main problem is that BPF is inherently 32 bits while system call
>>> arguments can be 64 bits.
>>
>> Inefficient, but ok :)
>
> I hope you're right.
>
> If BPF is always 32 bits and people have to deal with the 64 bit pain
> anyway, you can as well have one fixed ABI that is always the same and
> cross-platform by just making the arguments always 64 bit, with lower
> and upper halves in a fixed order to avoid endianness problems. This
> would be compat and future safe.

What happens if unsigned long is no longer 64-bit in some distant future?

As to endianness, fixed endianess means that userland programs that
have a different endianness will need to translate their values.  It's
just shifting the work around.

>>> So considering that you seem to be stuck with running 32 bits BPF
>>> filters anyway, you can as well make the input always 32 bits or
>>> always 64 bits. 32 bits would lose information sometimes, so making
>>> it always 64 bits without sign extension seems logical.
>>
>> This is not fully formed logic.  BPF can operate on values that exceed
>> its "bus" width.  Just because it can't do a load/jump on a 64-bit
>> value doesn't mean you can't implement a jump based on a 64-bit value.
>>  You just split it up. Load the high order 32-bits, jump on failure,
>> fall through and load the next 32-bits and do the rest of the
>
> Yes, hence my proposal to just bite the bullet and provide a fixed,
> cross-platform 64 bit argument interface.
>
>> comparison. Extending Eric's python translator wouldn't be
>> particularly painful and then it would be transparent to an end user.
>
> Your end user uses your ABI directly, Eric's python translator is only
> one of them.

Sure, but how many people write BPF manually today versus those who
use ethereal/wireshark/tcpdump/libpcap?  And for network data, the
data protocols may vary per  packet.

>>> This would
>>> uglify the actual BPF filters immensely though, because then they
>>> often have to check the upper argument half too, usually just to
>>> make sure it's zero. They can't be sure that the kernel will ignore
>>> the upper half for 'int' arguments.
>>
>> Of course not!  This will uglify the filters until someday when BPF
>> grows 64-bit support (or never), but it's not that bad.  The BPF
>> doesn't need to be pretty, just effective.  And it could be made even
>> easier with JIT support enabled since it could provide better native
>> code behaviors.
>
> What JIT? If there is one I doubt it's smart enough to consolidate two
> 32 bit operations into one 64 bit operation.

There's a BPF JITer in the kernel now.  I doubt it does consolidation
either, but with a lightweight lookahead, it would be possible to
collapse known patterns for checking 64-bit values (not in all cases,
but in generic ones).

>>> So I suppose the question is: How do you expect people to use this on
>>> 64 bit systems?
>>
>> As mentioned above.  The whole point of using BPF and user_regs_struct
>> is to implement _less_ kernel magic instead of more.
>
> At the cost of making it cross-platform and harder to use. I think it is
> a bit sad that the code still ends up being so platform dependent while
> it is running in a virtual machine.

Not all virtual machines have the same goal.  The goal of BPF is to
provide a safe place to evaluate user-supplied instructions over a
fixed window of data to determine acceptance.  While BPF for socket
data is arch-independent, each BPF program needs to understand what
the packet data is being operated on.  In this case, the
user_regs_struct is the packet data and the BPF program needs to be
tailored to it.

> And you still have to fix up the compat case.

Not really.  I lock down the compat case.  _Even_ with fixed 64-bit
arguments, you still get system call number mismatches which mean you
need to keep independent filters for the same task. I had this in one
of my first implementations and it adds a nasty amount of implicit
logic during evaluation.

> [...]
>>>> If we do a new ABI, not only does that
>>>> have to be exported to userland, but it means we're still copying and
>>>> munging the data around (which was why I was trying to see if pt_regs
>>>> was a easier way to get a speed boost).
>>>
>>> The difference is that the register ABI uses the messy ptrace ABI which
>>> is a bit strange and not cross-platform, while simply exporting system
>>> call arguments is plain simple and what everyone tries to get out of the
>>> pt_regs anyway.
>>
>> user_regs_struct != pt_regs.  user_regs_struct is acquired using
>> regviews which is already provided by each arch for use by coredump
>> generation and PTRACE_[GS]ETREGS.  There is no messy ptrace ABI.
>
> How is exporting registers via a structure not messy? And if PEEKUSR
> uses a different ABI then ptrace's ABI is very messy. And it gets messy
> whenever you cross a 32/64 bit boundary.

I'm not following.

>> Also, the whole point of the patch series was to create filters that
>> were not cross-platform.  I don't believe that is the kernel's job.
>
> It's the kernel's job to provide an abstracted view of the hardware so
> user space has a consistent view. Not trying to make it cross-platform
> is just slacking.

I disagree. I believe it is overengineering and poor design to create
an brand new interface with new semantics to hide an ABI that userland
is already aware of.

>> system calls are inherently arch specific so why go to all the effort
>> to hide that?
>
> Because, although the numbers are certainly arch specific, the system calls
> themselves including the argument ordering are surprisingly consistent.
>
> The numbers are handled by the SYS_* defines, so when porting to a different
> arch people just have to check if the arguments they use still match and
> that's it. If you provide registers they have to put more effort into
> porting the code.

Yup the __NR_* defines are ABI and so is the argument ordering
(clearly).  Of course, userspace knows that the argument ordering is
based on registers since that's how it preps the registers before
calling the arch-specific system call trap.  This is why I believe it
makes sense to just store the arch reg mappings in a userland library
rather than do it kernel-side.

>>> But considering system call numbers are platform dependent anyway, it
>>> doesn't really matter that much. I think an array of syscall arguments
>>> would be a cleaner interface, but struct pt_regs would be acceptable.
>>
>> As I said, user_regs_struct is the portable pt_regs, so I don't see
>> why it's a problem. But, using syscall_get_arguments is doable too if
>> that's the route this goes.
>
> It's not portable because it is different for every arch.

I was describing the kernel code, not the data set.  By using
regviews, I get the consistent register view for the personality of
the process for the architecture it is running on.  This means that
the user_regs_struct will always be consistent _for the architecture_
when given to the user's BPF code.  It does not create a portable
userland ABI but instead uses the existing ABI in a way that is
arch-agnostic in the kernel (using the regviews interfaces for arch
fixup).

>>>> If there's consensus, I'll change it (and use syscall_get_arguments),
>>>> but I don't believe it makes sense. (more below)
>>>
>>> It's about system call filtering, I'd argue that giving anything else than
>>> the arguments doesn't make sense. Yes, the registers are the current system
>>> call ABI and reusing that is in a way simpler, but that ABI is about telling
>>> the kernel what the arguments are, it's not the best way for the kernel to
>>> tell userspace what the arguments are because for userspace it ends up in
>>> some structure with its own ABI instead of in the actual registers.
>>
>> I don't see this disconnect.  The ABI is as expected by userspace.
>> Giving an array of arguments and a system call number will work fine,
>> but it is not a known ABI.  We can create a new one, but I don't
>> believe this argument justifies it.  It's not what the kernel is
>> telling user space, it's what is safe to evaluate in the kernel using
>> what userspace knows without adding another new interface.  If a new
>> interface is what it takes to get this merged, then I'll clearly do
>> it, but I'm still not sold that it is actually better.
>
> You are adding a new interface anyway with this feature. Using user_regs_struct
> is not something expected by userspace, except if it are hardcore ptrace users.

And anything that parses coredumps.

> And they will get the offsets wrong if they are on 64 bits because those are
> different than for ptrace. The ptrace ABI uses longs, BPF is fixed to 32 bits,
> it's just not a good fit.

That's not true on x86-64:

 http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L945

PEEKUSR uses the offsetof() the 32-bit register struct for compat
calls and, with that macro, maps it to the proper entry in pt_regs.
For non-compat, it just uses the offset into pt_regs:
  http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L475
  lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L170

As there is significant overlap in the contents of user_regs_struct
and pt_regs on the platform. While it's possible for another arch to
use a different set of ptrace ABI offsets, using offsetof(struct
user_regs_struct, ...) will always work.  It is not long-based.

If you want to convince me this isn't a good fit, I need you to meet
me halfway and make sure your assertions match the code! :)

> Put another way, why isn't user_regs_struct passed on to each system call
> implementation in the kernel instead of the arguments? It's exactly the
> same reason as why passing arguments is better for BPF too.

This is silly.  When you call a system call, what do you do?  You
prepare the register state such that the arguments are in the right
positioning.  user_regs_struct is the snapshot of the registers the
program-itself prepared.

If you think it is more pleasing to have [syscall_nr|args0|...|args6],
then I can respect that.  But so far, the technical arguments have not
backed up that direction.

>>>>> As everyone dealing with system call is mostly interested in the same things:
>>>>> The syscall number and the arguments. You can add some other potentially useful
>>>>> info like instruction pointer as well, but keep it limited to cross-platform
>>>>> things with a clear meaning that make sense for system call filtering.
>>>>
>>>> Well there are also clone/fork, sig_rt_return, etc related registers
>>>> too.
>>>
>>> What special clone/fork registers are you talking about?
>>
>> On x86, si is used to indicate the tls area:
>>   http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/process_32.c#L238
>> (and r8 on 64-bit).  Also segment registers, etc.
>
> si is just the 4th (5th for x86_64) system call argument, it's nothing special.

True - arguably though fork() takes no arguments.  Now
syscall_get_arguments() won't know that, so si/r8 and all will still
be exposed for filtering.  For some reason, I thought some other
pieces were used (EFLAGS?), but I can't back that up in the source.

> System calls never use segment registers directly, do they? It's not part
> of the system call ABI, so why would you want to use them in filtering?

On x86-32, you may be using segmentation for isolation purposes.  If
you do so, it may be of interest where the call comes from.  Nothing
truly relevant, just another possibility.  *shrug*

>>> I don't think anyone would want to ever filter sig_rt_return, you can as
>>> well kill the process.
>>
>> Why make that decision for them?
>
> I don't, I'm just saying it doesn't make sense to filter it. Based on what
> would anyone ever want to filter it? It's just a kernel helper thing to
> implement signal handlers.

What if you want the process to die if it returns from any signals?

> But now you mention it, it won't be bad to enforce this in the kernel,
> otherwise everyone has to add code to allow it. Same for exit(_group).
> Because if those are denied, there's nothing else to run instead.

The process will be do_exit()d.  I don't know why it matters?

>>>> I like not making the decision for each syscall filtering
>>>> consumer. �We have an ABI so it seems like I'd be making work for the
>>>> kernel to manage yet another one for system call calling conventions.
>>>
>>> I think it's pretty much about the arguments and not much else. Even
>>> adding instruction pointer was a bit of a stretch, but it's something
>>> I can imagine people using to make decisions. But as the BPF filters
>>> are stateless they can't really use much else than the syscall number
>>> and arguments anyway, the rest is usually too context dependent.
>>>
>>> In order of exponentially less likelihood to filter on:
>>> - syscall number
>>> - syscall arguments
>>> - Instruction pointer
>>> - Stack pointer
>>> - ...?!
>>>
>>> Keep in mind that x86 only has a handful registers, 6 of them are used
>>> for the arguments, one is the syscall number and return value, one is
>>> the instruction pointer and there's the stack pointer. There just isn't
>>> much room for much else.
>>>
>>> Adding the instruction and stack pointers is quite a stretch already and
>>> should cover pretty much any need. If there is any other information that
>>> might be useful for filtering system calls I'd like to hear about it.
>>
>> At this point, why create a new ABI?  Just use the existing fully
>> support register views expressed via user_regs_struct.
>
> It's the difference between 6 args + a couple extras versus 17 registers
> for a register starved arch like x86.
>
> But yeah, better to not provide the instruction or stack pointers indeed.
> At least the instruction pointer gives some system call related information
> (from where it is called).

Yup - it's nice to have that.

>> That said, I can imagine filtering on other registers as being useful
>> for tentative research.
>
> They can use ptrace for that.

And it will stay research forever.

>> Think of the past work where control flow
>> integrity was done by XORing the system call number with a run-time
>> selected value.  Instead of doing that, you could populate a
>> non-argument register with the xor of the syscall number and the
>> secret (picked and then added to the BPF program before install).
>
> What non-argument register would you like to use on x86? I think all
> are used up already. All you got left is the segment registers, and
> using those seems a bad idea.

There are other arches where this would be feasible.

> It also seems a bad idea to promote non-portable BPF filtering programs.

Why?  If it's possible to make a userland abstraction layer, why do we
force the kernel to take on more work?

> If you support modifying arguments and syscall nr then people can keep
> doing the XORing trick with BPF. Another advantage of allowing that is
> that unsafe old system calls can be replaced with secure ones on the
> fly transparently.
>
> Really, disallowing modifications is much more limiting than not providing
> all registers. But allowing modifications is a lot harder to get right
> with a register interface.

I'm not going to make the change to support BPF making the data
mutable or using scratch space as an output vector. If that is
something that makes sense to the networking stack, then we could
benefit from it, but I don't want to go there.

>> I'm not saying this is a good idea, but it seems silly to exclude it
>> when there doesn't seem to be any specific gain and only added
>> kernel-side complexity.  It may also be useful to know what other
>> saved registers (segment, etc) depending on what sort of sandboxing is
>> being done.  The PC/IP is fun for that one since you could limit all
>> syscalls to only come from the vdso or vsyscall locations.
>
> Problem is that that is less useful than it seems because malicious code
> can always just jump to a syscall entry instruction. Randomization helps
> a bit, but it gives no guarantees. Better to store an XORed secret in the
> syscall nr and arguments, that gives up to 224 bits of security.

Yup, but rewriting the system call number or arguments would require a
ptrace supervisor without changing the nature of BPF.  Also, if
something like this were crafted, a XOR-guess failure would result in
immediate process termination.  This allows for lower entropy to still
provide a robust mechanism.

>>> BTW, the width of the fields depends on how you want to resolve
>>> the 64 bit issue. As BPF is always 32 bits, it doesn't make much
>>> sense to use longs. And as offsets are used anyway, it probably
>>> makes more sense to define those instead of a structure.
>>
>> Yup. I'm still not sold on needing a standalone ABI for this when it
>> is some combination of syscall_get_arguments and KSTK_EIP, since
>> user_regs_struct already handles the right type widths, etc.  In fact,
>> it gets a bit more challenging.
>
> I would go for system call number + arguments only, and forget about the
> EIP and stack, except if people really want it. But if you do add it then
> it's barely any less limiting than a register view.

What do you think of Oleg's proposal? I like it a lot!  If I can just
use pt_regs for all but compat tasks, then it means there _no_ copy
needed to evaluate the BPF.  This saves on more than just the
user_regs_struct registers but a lot more.  It also avoids
syscall_get_arguments, etc. I'm looking into how to best implement
this, but I think it may be a real option.

It does mean BPF is per-arch, per syscall-convention, but you know I
am fine with that :)  I do think the performance gains could be well
worth avoiding any copying.  (Perf gains are the strongest argument I
think for your proposal and the thing that would likely lead me to do
it.)

>> If you look at syscall_get_arguments for x86, it always uses unsigned
>> long even when it is a TS_COMPAT task:
>>   lxr.linux.no/linux+v3.2.1/arch/x86/include/asm/syscall.h#L97
>> That means that the BPF exposed types would either always need to be
>> unsigned long, irrespective of is_compat_task, or seccomp filter would
>> need additional per-arch fixups (which is what regviews already do :/
>> ).
>
> If compat tasks are involved you are screwed anyway and have to fiddle
> with data, it's unavoidable.

Well I was letting the existing code do that for me.

> Arguments exposed to BPF should always be 64 bits even on 32 bit archs,
> that solves all compat and portability problems.

Not really. It means that if there is ever a 128-bit register arch, a
new ABI would be spawned for it.  But I don't know what else would be
broken in the kernel by that, so it's hard to tell if that argument
makes sense.

> I really don't see the problem of copying 6 arguments to a fixed place.

I was indicating the need to truncate them for compat.

> If that is tricky then you're either trying to use the wrong function
> or doing it at the wrong place in the kernel. I'd expect that passing on
> the arguments is highly optimised in the kernel, all system calls have
> easy access to them, why would it be hard for the BPF code to get it?

See the source. They are static inlines but there are still memory
copies.  I would then need to copy a second time to truncate them to
the correct width (or some other fanciness).

> If you use syscall_get_arguments you have to call it once for each arg
> instead of calling it once and trying to fix up the 32/64 bit and
> endianness afterwards.

You - or call it once and then iterate over the emitted array doing fixups.

> So call it once and store the value in a long. Then copy the low half
> to the right place and then the upper half when on 64 bits. It may not
> look too pretty, but the compiler should be able to optimise almost all
> overhead away and end up with 6 (or 12) int copies. Something like this:
>
> struct bpf_data {
>        uint32 syscall_nr;
>        uint32 arg_low[MAX_SC_ARGS];
>        uint32 arg_high[MAX_SC_ARGS];
> };
>
> void fill_bpf_data(struct task_struct *t, struct pt_regs *r, struct bpf_data *d)
> {
>        int i;
>        unsigned long arg;
>
>        d->syscall_nr = syscall_get_nr(t, r);
>        for (i = 0; i < MAX_SC_ARGS; ++i){
>                syscall_get_arguments(t, r, i, 1, &arg);
>                d->arg_low[i] = arg;
>                d->arg_high[i] = arg >> 32;
>        }
> }

Sure, but it seems weird to keep the arguments high and low not
adjacent, but I realize you want an arch-independent interface. I
guess in that world, you could do this:

{
  int32_t nr;
  uint32_t arg32[MAX_SC_ARGS];
  uint32_t arg64[MAX_SC_ARGS];
  /* room for future expansion is here */
};

If no one else sees the benefit of keeping this out of the kernel,
then I can do this. I hope Oleg's idea works though because I think ti
addresses the performance problems even if it means the userspace
tooling work is higher to achieve good portability.

>>
>> Agreed -- except that, as I mentioned above, there are still
>> significant complexities kernel-side if anything other than regviews
>> are used.
>
> I'm missing what those complexities are.
>
>>
>>>>> This way the registers have to be interpreted only once by the kernel and all
>>>>> filtering programs don't have to do that mapping themselves. It also avoids
>>>>> doing unnecessary work fiddling/translating registers like the ptrace ABI does.
>>>>
>>>> The kernel does only interpret them once (after entry to
>>>> __secure_computing).
>>>
>>> Not if data shuffling is needed for compat related stuff.
>>
>> I agree!  user_regs_struct get rid of the data shuffling.  pt_regs and
>> syscall_get_arguments all seem to induced data shuffling for compat
>> junk.  I just wish pt_regs was compat-width appropriate, but it makes
>> sense that a 64-bit kernel with a 32-bit program would use 64-bit
>> registers on its side.  Just frustrating.
>
> Are user_regs_struct entries 32-bit for 32-bit tasks or is it 64-bit if
> the kernel is 64-bit? If they're 64-bit then you didn't get rid of the
> data shuffling.

They are appropriate to the process personality as I said and linked
to in the ptrace code. Take a look at my patch - no data shuffling is
needed.

>>>> It gets the regview and has it populate a
>>>> user_regs_struct. �All the register info is per-arch and matches
>>>> PTRACE_GETREGS, but not PTRACE_PEEKUSR.
>>>
>>> GETREGS seems to be a subset of PEEKUSR. That is, both start with
>>> a struct pt_regs/user_regs_struct (seems to be the same thing?)
>>
>>
>> Not quite.  on x86-32, pt_regs and user_regs_struct are identical.
>> Power PC as well, I think.  They diverge on pretty much every other
>> platform.  Also, x86 compat has some trickiness.  pt_regs is 64-bit on
>> x86-64 even with compat processes.  Instead what happens is the naming
>> is  kept if __KERNEL__ such that there aren't different struct member
>> names in all the syscall.h and ptrace code.  The
>> IA32_EMULATION/TS_COMPAT stuff can then just use the reordered member
>> names without even more #ifdef madness.
>
> It was a surprise to me to find out that the pt_regs a 64-bit ptrace user
> gets for a 32 bit tracee differs from the pt_regs when both are 32 bits.
>
>> user_regs_struct will use the correct width according to the process
>> personality.  On all arches with is_compat_task support, this matches
>> -- except x86.  With x86, you can force a 32-bit syscall entry from a
>> 64-bit process resulting in a temporary setting of TS_COMPAT but with
>> a personality that is still 64-bit.  This is an edge case and one I
>> think forcing compat and personality to not-change addresses.
>
> How's that possible? Setting CS to 0x23? Can userspace do that?

int 0x80 will do the trick or setting the CS which I believe can be done.

>>> PEEKUSR only has extra access to debugging registers.
>>
>> GETREGS uses a regview:
>>   http://lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L1153
>> PEEKUSR uses getreg or getreg32 directly (on x86).  compat_arch_ptrace
>> on x86 will then grab a specified register based on the 32-bit offsets
>> out of a 64-bit pt_regs and can return any register offset, like
>> ORIG_EAX:
>>   lxr.linux.no/linux+v3.2.1/arch/x86/kernel/ptrace.c#L1026
>>
>> It's this magic fixup that allows ptrace to just use pt_regs for
>> PEEKUSR while GETREGS is forced to do the full register copy.
>>
>>> That is another problem of giving a register view: Which registers
>>> are you going to give access to?
>>
>> Always the general set.  This is the set denoted by core_note_type
>> NT_PRSTATUS on all architectures as far as I can tell.
>>
>>>> All the weird stuff is in
>>>> PEEKUSR to deal with the fact that compat pt_regs members are not
>>>> actually the same width as userspace would expect.
>>>>
>>>> If we populated an ABI as you've proposed, we'd at least need to
>>>> build that data set and give it syscall_get_arguments() output.
>>>
>>> Yes, but that's all you have to do, nothing more.
>>
>> I do even less now! :)
>
> You have to do more for the compat case.

No. Please look at the code.


>>> The pt_regs a 64 bit kernel builds for a 32 bit compat process is
>>> different than one from a 32 bit kernel, so you have to do some kind
>>> of data shuffling anyway.
>>
>> Yes - that's why I use user_regs_struct.
>
> But there are different versions of user_regs_struct, depending on the
> situation. This implies that the BPF filters have to be different too,
> while they could be exactly the same (except for the syscall nr).

Yes - per-arch. If you're already doing per-arch fixup, why ius
mapping 6 extra registers such a burden?  If the code can't do that in
userspace, it is slacking.

>>> Worse, once you pick this ABI you're stuck with it and can't get rid
>>> of compat horrors like you have now with ptrace(). Do you really want
>>> to reuse an obscure ptrace ABI instead of creating a simpler new one?
>>
>> Exactly why I'm using user_regs_struct.  I think we've been having
>> some cross-talk, but I'm not sure.  The only edge case I can find with
>> user_regs_struct across all platforms is the nasty x86 32-bit entry
>> from 64-bit personality.  Perhaps someday we can just nuke that path
>> :)  But even so, it is tightly constrained by saving the personality
>> and compat flag in the filter program metadata and checking it at each
>> syscall.
>
> I think it's a good idea to nuke that path, it seems like a security hole
> waiting to happen.

Agreed. And yet we can't (yet?).


>>
>>>> I was hoping I could just hand over pt_regs and avoid any processing,
>>>> but it doesn't look promising. �In theory, all the same bit-twiddling
>>>> compat_ptrace does could be done during load_pointer in the patch
>>>> series, but it seems wrong to go that route.
>>>
>>> Your problem is worse because BPF programs are 32 bits but registers/args
>>> can be 64 bit. Compared to that, running 32 bits on top of 64 bits seems
>>> easy.
>>>
>>> Do you propose that people not only know about 64 bitness, but also
>>> about endianness when grabbing bits and pieces of 64 bit registers?
>>> Because that seems like a fun source of bugs.
>>
>> Endianness calling convention specific.  For arches that allow
>> endianness changes, that should be personality based.  I believe that
>> "people" don't need to know anything unless they are crafting BPF
>> filters by hand, but I do believe that the userland software they rely
>> on should understand the current endianness and system call
>> conventions.  glibc already has to know this stuff, and so does any
>> other piece of userland code directly interacting with the kernel, so
>> I don't believe it is an hardship on userland.  It certainly isn't
>> shiny and isn't naturally intuitive, but those don't seem like the
>> only guiding requirements.  Making it cross-arch and future-friendly
>> using what user-space is already aware of seems like it will result in
>> a robust ABI less afflicted by bit rot or the addition of a crazy new
>> 128-bit architecture :)  But who knows.
>
> If your ABI is too hard to use directly, it won't be used at all.
> Any excuse that people won't use this ABI directly is a sign that
> it is not good enough.

That is blatantly untrue. Have you ever used tcpdump's expression
language for filtering packets? Wireshark?

> And the more complicated you make it, the less likely it is that
> anyone will use this.

Unless there is a nice library that makes it work well.

>>>>> I missed if the original version was allowed to change the registers or not,
>>>>> if it is then perhaps the BPF program should set a specific flag after changing
>>>>> anything, to make it more explicit.
>>>>
>>>> Registers are const from the BPF perspective (just like with socket
>>>> filters). � Adding support for tracehook interception later could
>>>> allow for supervisor guided register mutation.
>>>
>>> If the ABI gives access to arguments instead of registers you don't have
>>> to do anything tricky: No security checks, no need for fixing up register
>>> values to their original value after the system call returns or any other
>>> subtleties. BPF filters can just change the values without side effects.
>>
>> BPF programs should never change any filters.  BPF does not have the
>> capability to modify the data it is evaluating.  Doing that would
>> require a BPF change and alter its very nature, imo.
>
> It could if you make the data part of the scratch memory. If you put the
> data at the top, just after BPF_MEMWORDS, then it's all compatible with
> the read-only version. Except the sk_chk_filter() code. But if you ever
> want to consolidate with the networking version, then you already need
> new non-byteswapping instructions. You can as well add a special modify
> instruction too then. Making it very explicit seems better anyway.

I am not going to go this route right now.  If you want to, be my
guest. We can add BPF instructions later, but I am not going down that
rabbit hole now.

> Using BPF for system call filtering changes its very nature already.

No it doesn't.  user_regs_struct becomes another data protocol.

> I must say that until your patch came up, I've never heard of BPF filters
> before. I think I'm going to use it in our ptrace jailer for network
> filtering, if it's possible to get the peer address for normal TCP/UDP
> sockets. Documentation is quite vague.

Cool!

>> While arguments seem tidy, we still end up with the nasty compat pain
>> and it is only worse kernel-side since there'd be no arch-independent
>> way to get the correct width system call arguments.  I'd need to guess
>> they were 32-bit and downgrade them if compat.  That or add a new arch
>> callout.  Very fiddly :/
>
> See code above. It seems fairly tidy to me.
>
> You could also do the BPF filtering later in the system call entry path
> when the arguments are passed directly, but then it's harder to interact
> well with ptrace.

Where? Interpose it into each system call?  The later I put it, the
less attack surface reduction I get.  The whole point of this
framework is to reduce the kernel's attack surface by doing minimal
kernel-side work before making a policy decision.

Also, I've already gone the ftrace route. As I said in the writeup, I
don't think it is the right path for this sort of functionality.

>>
>>> I would prefer if it would work nicely with a ptrace supervisor, because
>>> to me it seems that if something can't be resolved in the BPF filter, more
>>> context and direct control is needed. The main downside of ptrace for
>>> jailing is its overhead (and some quirks). If that can be taken away for
>>> most system calls by using BPF then it would be useful for my use case.
>>
>> I could not agree more.  I have a patch already in existence that adds
>> a call to tracehook_syscall_entry on failure under certain conditions,
>> but I didn't want to bog down discussion of the core feature with that
>> discussion too.  I think supporting a ptrace supervisor would allow
>> for better debugging and sandbox development.  (Then I think most of
>> the logic could move directly to BPF.  E.g., only allow pointer
>> arguments for open() to live in this known read-only memory, etc.)
>
> That is very hard to do in practise except for very limited sandboxing
> cases. In the general case you want to check all paths, but knowing
> beforehand where those are stored is hard when running arbitrary stuff.
> And it doesn't guarantee that it are safe path, because they can start
> in the middle of a stored path and turn an absolute path into a relative
> one.

Yeah - you'd need a lookup table in the BPF, etc. It'd be pretty ugly :)

> And updating the filters on the run all the time is a hassle too. So
> I think most logic will stay out of BPF, especially because it is the
> more tricky stuff to do. But open() is not that performance critical
> compared to stuff that happens all the time and where you really don't
> want the ptrace overhead, like gettimeofday().

yeah definitely.

> By the way, I think you want the filter to decide with what error code
> the system call fails instead of hard coding it to EACCESS. So just use
> the return value instead of checking against regs_size, which doesn't
> make much sense anyway. Then you also have a way for the filter to tell
> whether the system call should be passed on to ptrace or not.

EACCES is never passed to userspace.  As far as ptrace is concerned, I
don't think the filter needs any awareness of whether there is a
tracer or not.

That said, I'm happy to change the return value semantic.  Right now
it matches how it works in the networking stack.  It returns the data
size to be accepted.

What would make sense? 0 is success and any other value is a failure.
Then specify that the ABI failure return code is _some value_ and then
populate the other later?  I was planning on doing that with
regs_size.  reg_size is reserved, but the other return values could be
exported and used if they ever came into existence.  I'm open to what
everyone thinks makes the most sense!


> Ideally, the BPF filter should be able to deny the system call with a
> specific error code, deny the call and kill the task, have a way to
> defer to ptrace, and a way to allow it.

Not happening (by my hand :).  I'm not changing seccomp to allow it to
cause a system call to fail with an error code. I'll add support for
tracehook integration if this patch can get merged, but I'm not going
to change the basic semantics of seccomp.  The nice thing is, if we
reserve return values, this functionality can be layered on later
without it causing any ABI breakage and with proper consideration
independent of whether the basic functionality gets merged. Then, if
you want retool the entire seccomp path on all architectures to allow
graceful system call failure, it'd be totally doable.

Thanks!
will
