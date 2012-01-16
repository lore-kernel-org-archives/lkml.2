Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2APGtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:49:23 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:58267 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2APGtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:49:22 -0500
Message-ID: <293e9587acd158b91d7d1793c7e16f7c.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
    <1326302710-9427-2-git-send-email-wad@chromium.org>
    <20120112162231.GA23960@redhat.com>
    <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
    <20120112172315.GA26295@redhat.com>
    <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
    <addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
    <CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
Date: Mon, 16 Jan 2012 07:49:08 +0100
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
X-Scan-Signature: 3dd1f87d90bb9f003914be703903050d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, January 16, 2012 02:40, Will Drewry wrote:
> On Sat, Jan 14, 2012 at 9:40 PM, Indan Zupancic <indan@nul.nu> wrote:
>> On Sat, January 14, 2012 00:10, Will Drewry wrote:
>>> Any thoughts?
>>>
>>> I'll do a v5 rev for Eric's comments soon, but I'm not quite sure
>>> about the pt_regs
>>> change yet.  If the performance boost is worth the effort of having a
>>> per-arch fixup,
>>> I can go that route.  Otherwise, I could look at some alternate approach
>>> for a faster-than-regview payload.
>>
>> I recommend not giving access to the registers at all, but to instead provide
>> a fixed cross-platform ABI (a 32 bit version and one 64 bit version).
>
> I don't believe it is possible to create a fixed cross-platform ABI
> that will be compat and future safe.

The main problem is that BPF is inherently 32 bits while system call
arguments can be 64 bits.

You could change it so that all BPF programs are always 64 bits, which
would solve everything, except the when-to-sign-extend-and-when-not-to
problem. Luckily tgkill() is the only system call I'm aware of which
would have preferred sign extension, so never sign extending is fairly
safe. But this would require a new user space ABI as it's incompatible
with the current sock_filter.

You could make it work on "unsigned long" and solve all subtleties
that way. For 32 bits compat mode you execute the 32 bit version, if
you want to support it. This would require two seccomp_run_filter()
versions if compat mode is supported. Again, would change the BPF
filter ABI.

So considering that you seem to be stuck with running 32 bits BPF
filters anyway, you can as well make the input always 32 bits or
always 64 bits. 32 bits would lose information sometimes, so making
it always 64 bits without sign extension seems logical. This would
uglify the actual BPF filters immensely though, because then they
often have to check the upper argument half too, usually just to
make sure it's zero. They can't be sure that the kernel will ignore
the upper half for 'int' arguments.

So I suppose the question is: How do you expect people to use this on
64 bit systems?

> user_regs_struct (or even
> pt_regs) should always match whatever each arch is doing -- even weird
> personality-based changes.

I don't think weird personality-based changes are really relevant, no one
is going to write different versions of each filter depending on which
personality is being run. Perhaps weird personality changes should be
denied when a filter is installed, in case the filter forgets to do it.

So if the personality would change in a drastic way across an execve,
it should fail. That is something a filter can't check beforehand and
the only way to deal with it afterwards is by checking what the current
personality is for each system call.

All in all I think filters should be per personality, and if a process's
personality changes it is only allowed if there is also a filter installed
for the new personality too. Or just disallow personality changes, wasn't
that what your patch did anyway?

> If we do a new ABI, not only does that
> have to be exported to userland, but it means we're still copying and
> munging the data around (which was why I was trying to see if pt_regs
> was a easier way to get a speed boost).

The difference is that the register ABI uses the messy ptrace ABI which
is a bit strange and not cross-platform, while simply exporting system
call arguments is plain simple and what everyone tries to get out of the
pt_regs anyway.

But considering system call numbers are platform dependent anyway, it
doesn't really matter that much. I think an array of syscall arguments
would be a cleaner interface, but struct pt_regs would be acceptable.

> If there's consensus, I'll change it (and use syscall_get_arguments),
> but I don't believe it makes sense. (more below)

It's about system call filtering, I'd argue that giving anything else than
the arguments doesn't make sense. Yes, the registers are the current system
call ABI and reusing that is in a way simpler, but that ABI is about telling
the kernel what the arguments are, it's not the best way for the kernel to
tell userspace what the arguments are because for userspace it ends up in
some structure with its own ABI instead of in the actual registers.

>> As everyone dealing with system call is mostly interested in the same things:
>> The syscall number and the arguments. You can add some other potentially useful
>> info like instruction pointer as well, but keep it limited to cross-platform
>> things with a clear meaning that make sense for system call filtering.
>
> Well there are also clone/fork, sig_rt_return, etc related registers
> too.

What special clone/fork registers are you talking about?

I don't think anyone would want to ever filter sig_rt_return, you can as
well kill the process.

> I like not making the decision for each syscall filtering
> consumer.  We have an ABI so it seems like I'd be making work for the
> kernel to manage yet another one for system call calling conventions.

I think it's pretty much about the arguments and not much else. Even
adding instruction pointer was a bit of a stretch, but it's something
I can imagine people using to make decisions. But as the BPF filters
are stateless they can't really use much else than the syscall number
and arguments anyway, the rest is usually too context dependent.

In order of exponentially less likelihood to filter on:
- syscall number
- syscall arguments
- Instruction pointer
- Stack pointer
- ...?!

Keep in mind that x86 only has a handful registers, 6 of them are used
for the arguments, one is the syscall number and return value, one is
the instruction pointer and there's the stack pointer. There just isn't
much room for much else.

Adding the instruction and stack pointers is quite a stretch already and
should cover pretty much any need. If there is any other information that
might be useful for filtering system calls I'd like to hear about it.

>> So I propose an interface like the following instead of a register interface:
>>
>> /* Currently 6, but to be future proof, make it 8 */
>> #define MAX_SC_ARGS     8
>>
>> struct syscall_bpf_data {
>>        unsigned long syscall_nr;
>>        unsigned long flags;
>>        unsigned long instruction_pointer;
>>        unsigned long arg[MAX_SC_ARGS];
>>        unsigned long _reserved[5];
>> };

BTW, the width of the fields depends on how you want to resolve
the 64 bit issue. As BPF is always 32 bits, it doesn't make much
sense to use longs. And as offsets are used anyway, it probably
makes more sense to define those instead of a structure.

>>
>> The flag argument can be used to e.g. tell if it is a compat 32 program
>> running on a 64 bit system.
>
> I certainly considered this, but I don't think this is a practical
> idea.  Firstly, CONFIG_COMPAT is meant to be compatibility mode.  We
> can't assume a program knows about it.  Second, if we assume any new
> program will be "smart" and check @flags, then the first few
> instruction of _every_ (32-bit) seccomp filter program will be
> checking compat mode - a serious waste :(  I'm also not sure if
> is_compat_task actually covers all random personality-based changes --
> just 32-bit v 64-bit.

Yeah, bad idea. Forget about the flag thing.

> I _really_ wanted to make compat a flag and push that logic out of the
> kernel, but I don't think it makes sense to burden all ABI consumers
> with a "just in case" compat flag check.  Also, what happens if a new,
> weird architecture comes along where that flag doesn't make the same
> sense?  We can fix all the internal kernel stuff, but we'd end up with
> an ABI change to boot :/  Using regviews, we stay consistent
> regardless of whatever the new craziness is.  I just wish there was a
> way to make it speedier.

Better to have filters per personality. That solves this whole issue,
independently of regviews or argument list ABI.

>> This way the registers have to be interpreted only once by the kernel and all
>> filtering programs don't have to do that mapping themselves. It also avoids
>> doing unnecessary work fiddling/translating registers like the ptrace ABI does.
>
> The kernel does only interpret them once (after entry to
> __secure_computing).

Not if data shuffling is needed for compat related stuff.

> It gets the regview and has it populate a
> user_regs_struct.  All the register info is per-arch and matches
> PTRACE_GETREGS, but not PTRACE_PEEKUSR.

GETREGS seems to be a subset of PEEKUSR. That is, both start with
a struct pt_regs/user_regs_struct (seems to be the same thing?)
PEEKUSR only has extra access to debugging registers.

That is another problem of giving a register view: Which registers
are you going to give access to?

> All the weird stuff is in
> PEEKUSR to deal with the fact that compat pt_regs members are not
> actually the same width as userspace would expect.
>
> If we populated an ABI as you've proposed, we'd at least need to
> build that data set and give it syscall_get_arguments() output.

Yes, but that's all you have to do, nothing more.

The pt_regs a 64 bit kernel builds for a 32 bit compat process is
different than one from a 32 bit kernel, so you have to do some kind
of data shuffling anyway.

Worse, once you pick this ABI you're stuck with it and can't get rid
of compat horrors like you have now with ptrace(). Do you really want
to reuse an obscure ptrace ABI instead of creating a simpler new one?

> I was hoping I could just hand over pt_regs and avoid any processing,
> but it doesn't look promising.  In theory, all the same bit-twiddling
> compat_ptrace does could be done during load_pointer in the patch
> series, but it seems wrong to go that route.

Your problem is worse because BPF programs are 32 bits but registers/args
can be 64 bit. Compared to that, running 32 bits on top of 64 bits seems
easy.

Do you propose that people not only know about 64 bitness, but also
about endianness when grabbing bits and pieces of 64 bit registers?
Because that seems like a fun source of bugs.

>> I missed if the original version was allowed to change the registers or not,
>> if it is then perhaps the BPF program should set a specific flag after changing
>> anything, to make it more explicit.
>
> Registers are const from the BPF perspective (just like with socket
> filters).   Adding support for tracehook interception later could
> allow for supervisor guided register mutation.

If the ABI gives access to arguments instead of registers you don't have
to do anything tricky: No security checks, no need for fixing up register
values to their original value after the system call returns or any other
subtleties. BPF filters can just change the values without side effects.

I would prefer if it would work nicely with a ptrace supervisor, because
to me it seems that if something can't be resolved in the BPF filter, more
context and direct control is needed. The main downside of ptrace for
jailing is its overhead (and some quirks). If that can be taken away for
most system calls by using BPF then it would be useful for my use case.

Greetings,

Indan


