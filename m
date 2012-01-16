Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2APBkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 20:40:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56259 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2APBkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 20:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
	<addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
Date: Sun, 15 Jan 2012 19:40:14 -0600
Message-ID: <CABqD9hbBu8cEbArJWhSr-exFUDrnLSXskP1RrTATBczH2MYzFA@mail.gmail.com>
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

On Sat, Jan 14, 2012 at 9:40 PM, Indan Zupancic <indan@nul.nu> wrote:
> Hello,
>
> (I hoped everyone is CC'ed, emails forwarded via lkml truncate the CC list
> when it's too long.)
>
> On Sat, January 14, 2012 00:10, Will Drewry wrote:
>> On Fri, Jan 13, 2012 at 1:01 PM, Will Drewry <wad@chromium.org> wrote:
>>> On Fri, Jan 13, 2012 at 11:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>> On 01/12, Will Drewry wrote:
>>>>>
>>>>> On Thu, Jan 12, 2012 at 11:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>>> > On 01/12, Will Drewry wrote:
>>>>> >>
>>>>> >> On Thu, Jan 12, 2012 at 10:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>>> >> >> + � � �*/
>>>>> >> >> + � � regs = seccomp_get_regs(regs_tmp, &regs_size);
>>>>> >> >
>>>>> >> > Stupid question. I am sure you know what are you doing ;) and I know
>>>>> >> > nothing about !x86 arches.
>>>>> >> >
>>>>> >> > But could you explain why it is designed to use user_regs_struct ?
>>>>> >> > Why we can't simply use task_pt_regs() and avoid the (costly) regsets?
>>>>> >>
>>>>> >> So on x86 32, it would work since user_regs_struct == task_pt_regs
>>>>> >> (iirc), but on x86-64
>>>>> >> and others, that's not true.
>>>>> >
>>>>> > Yes sure, I meant that userpace should use pt_regs too.
>>>>> >
>>>>> >> If it would be appropriate to expose pt_regs to userspace, then I'd
>>>>> >> happily do so :)
>>>>> >
>>>>> > Ah, so that was the reason. But it is already exported? At least I see
>>>>> > the "#ifndef __KERNEL__" definition in arch/x86/include/asm/ptrace.h.
>>>>> >
>>>>> > Once again, I am not arguing, just trying to understand. And I do not
>>>>> > know if this definition is part of abi.
>>>>>
>>>>> I don't either :/ �My original idea was to operate on task_pt_regs(current),
>>>>> but I noticed that PTRACE_GETREGS/SETREGS only uses the
>>>>> user_regs_struct. So I went that route.
>>>>
>>>> Well, I don't know where user_regs_struct come from initially. But
>>>> probably it is needed to allow to access the "artificial" things like
>>>> fs_base. Or perhaps this struct mimics the layout in the coredump.
>>>
>>> Not sure - added Roland whose name was on many of the files :)
>>>
>>> I just noticed that ptrace ABI allows pt_regs access using the register
>>> macros (PTRACE_PEEKUSR) and user_regs_struct access (PTRACE_GETREGS).
>>>
>>> But I think the latter is guaranteed to have a certain layout while the macros
>>> for PEEKUSR can do post-processing fixup. �(Which could be done in the
>>> bpf evaluator load_pointer() helper if needed.)
>>>
>>>>> I'd love for pt_regs to be fair game to cut down on the copying!
>>>>
>>>> Me too. I see no point in using user_regs_struct.
>>>
>>> I'll rev the change to use pt_regs and drop all the helper code. �If
>>> no one says otherwise, that certainly seems ideal from a performance
>>> perspective, and I see pt_regs exported to userland along with ptrace
>>> abi register offset macros.
>>
>> On second thought, pt_regs is scary :)
>>
>> From looking at
>>   http://lxr.linux.no/linux+v3.2.1/arch/x86/include/asm/syscall.h#L97
>> and ia32syscall enty code, it appears that for x86, at least, the
>> pt_regs for compat processes will be 8 bytes wide per register on the
>> stack.  This means if a self-filtering 32-bit program runs on a 64-bit host in
>> IA32_EMU, its filters will always index into pt_regs incorrectly.
>>
>> I'm not 100% that I am reading the code right, but it means that I can either
>> keep using user_regs_struct or fork the code behavior based on compat. That
>> would need to be arch dependent then which is pretty rough.
>>
>> Any thoughts?
>>
>> I'll do a v5 rev for Eric's comments soon, but I'm not quite sure
>> about the pt_regs
>> change yet.  If the performance boost is worth the effort of having a
>> per-arch fixup,
>> I can go that route.  Otherwise, I could look at some alternate approach
>> for a faster-than-regview payload.
>
> I recommend not giving access to the registers at all, but to instead provide
> a fixed cross-platform ABI (a 32 bit version and one 64 bit version).

I don't believe it is possible to create a fixed cross-platform ABI
that will be compat and future safe.  user_regs_struct (or even
pt_regs) should always match whatever each arch is doing -- even weird
personality-based changes.  If we do a new ABI, not only does that
have to be exported to userland, but it means we're still copying and
munging the data around (which was why I was trying to see if pt_regs
was a easier way to get a speed boost).

If there's consensus, I'll change it (and use syscall_get_arguments),
but I don't believe it makes sense. (more below)

> As everyone dealing with system call is mostly interested in the same things:
> The syscall number and the arguments. You can add some other potentially useful
> info like instruction pointer as well, but keep it limited to cross-platform
> things with a clear meaning that make sense for system call filtering.

Well there are also clone/fork, sig_rt_return, etc related registers
too.  I like not making the decision for each syscall filtering
consumer.  We have an ABI so it seems like I'd be making work for the
kernel to manage yet another one for system call calling conventions.

> So I propose an interface like the following instead of a register interface:
>
> /* Currently 6, but to be future proof, make it 8 */
> #define MAX_SC_ARGS     8
>
> struct syscall_bpf_data {
>        unsigned long syscall_nr;
>        unsigned long flags;
>        unsigned long instruction_pointer;
>        unsigned long arg[MAX_SC_ARGS];
>        unsigned long _reserved[5];
> };
>
> The flag argument can be used to e.g. tell if it is a compat 32 program
> running on a 64 bit system.

I certainly considered this, but I don't think this is a practical
idea.  Firstly, CONFIG_COMPAT is meant to be compatibility mode.  We
can't assume a program knows about it.  Second, if we assume any new
program will be "smart" and check @flags, then the first few
instruction of _every_ (32-bit) seccomp filter program will be
checking compat mode - a serious waste :(  I'm also not sure if
is_compat_task actually covers all random personality-based changes --
just 32-bit v 64-bit.

I _really_ wanted to make compat a flag and push that logic out of the
kernel, but I don't think it makes sense to burden all ABI consumers
with a "just in case" compat flag check.  Also, what happens if a new,
weird architecture comes along where that flag doesn't make the same
sense?  We can fix all the internal kernel stuff, but we'd end up with
an ABI change to boot :/  Using regviews, we stay consistent
regardless of whatever the new craziness is.  I just wish there was a
way to make it speedier.

> This way the registers have to be interpreted only once by the kernel and all
> filtering programs don't have to do that mapping themselves. It also avoids
> doing unnecessary work fiddling/translating registers like the ptrace ABI does.

The kernel does only interpret them once (after entry to
__secure_computing). It gets the regview and has it populate a
user_regs_struct.  All the register info is per-arch and matches
PTRACE_GETREGS, but not PTRACE_PEEKUSR.  All the weird stuff is in
PEEKUSR to deal with the fact that compat pt_regs members are not
actually the same width as userspace would expect.  If we populated an
ABI as you've proposed, we'd at least need to build that data set and
give it syscall_get_arguments() output.

I was hoping I could just hand over pt_regs and avoid any processing,
but it doesn't look promising.  In theory, all the same bit-twiddling
compat_ptrace does could be done during load_pointer in the patch
series, but it seems wrong to go that route.

> I missed if the original version was allowed to change the registers or not,
> if it is then perhaps the BPF program should set a specific flag after changing
> anything, to make it more explicit.

Registers are const from the BPF perspective (just like with socket
filters).   Adding support for tracehook interception later could
allow for supervisor guided register mutation.

Thanks!
will
