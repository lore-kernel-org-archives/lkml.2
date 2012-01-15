Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2AODke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 22:40:34 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45658 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2AODkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 22:40:32 -0500
Message-ID: <addf0ca0d9cc381436209af3afdf878f.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
    <1326302710-9427-2-git-send-email-wad@chromium.org>
    <20120112162231.GA23960@redhat.com>
    <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
    <20120112172315.GA26295@redhat.com> <CABqD9hZ
    <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
Date: Sun, 15 Jan 2012 04:40:18 +0100
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
X-Scan-Signature: 27b922e39ba943ef41a3b4c3f0284049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(I hoped everyone is CC'ed, emails forwarded via lkml truncate the CC list
when it's too long.)

On Sat, January 14, 2012 00:10, Will Drewry wrote:
> On Fri, Jan 13, 2012 at 1:01 PM, Will Drewry <wad@chromium.org> wrote:
>> On Fri, Jan 13, 2012 at 11:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 01/12, Will Drewry wrote:
>>>>
>>>> On Thu, Jan 12, 2012 at 11:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>> > On 01/12, Will Drewry wrote:
>>>> >>
>>>> >> On Thu, Jan 12, 2012 at 10:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>> >> >> + � � �*/
>>>> >> >> + � � regs = seccomp_get_regs(regs_tmp, &regs_size);
>>>> >> >
>>>> >> > Stupid question. I am sure you know what are you doing ;) and I know
>>>> >> > nothing about !x86 arches.
>>>> >> >
>>>> >> > But could you explain why it is designed to use user_regs_struct ?
>>>> >> > Why we can't simply use task_pt_regs() and avoid the (costly) regsets?
>>>> >>
>>>> >> So on x86 32, it would work since user_regs_struct == task_pt_regs
>>>> >> (iirc), but on x86-64
>>>> >> and others, that's not true.
>>>> >
>>>> > Yes sure, I meant that userpace should use pt_regs too.
>>>> >
>>>> >> If it would be appropriate to expose pt_regs to userspace, then I'd
>>>> >> happily do so :)
>>>> >
>>>> > Ah, so that was the reason. But it is already exported? At least I see
>>>> > the "#ifndef __KERNEL__" definition in arch/x86/include/asm/ptrace.h.
>>>> >
>>>> > Once again, I am not arguing, just trying to understand. And I do not
>>>> > know if this definition is part of abi.
>>>>
>>>> I don't either :/ �My original idea was to operate on task_pt_regs(current),
>>>> but I noticed that PTRACE_GETREGS/SETREGS only uses the
>>>> user_regs_struct. So I went that route.
>>>
>>> Well, I don't know where user_regs_struct come from initially. But
>>> probably it is needed to allow to access the "artificial" things like
>>> fs_base. Or perhaps this struct mimics the layout in the coredump.
>>
>> Not sure - added Roland whose name was on many of the files :)
>>
>> I just noticed that ptrace ABI allows pt_regs access using the register
>> macros (PTRACE_PEEKUSR) and user_regs_struct access (PTRACE_GETREGS).
>>
>> But I think the latter is guaranteed to have a certain layout while the macros
>> for PEEKUSR can do post-processing fixup. �(Which could be done in the
>> bpf evaluator load_pointer() helper if needed.)
>>
>>>> I'd love for pt_regs to be fair game to cut down on the copying!
>>>
>>> Me too. I see no point in using user_regs_struct.
>>
>> I'll rev the change to use pt_regs and drop all the helper code. �If
>> no one says otherwise, that certainly seems ideal from a performance
>> perspective, and I see pt_regs exported to userland along with ptrace
>> abi register offset macros.
>
> On second thought, pt_regs is scary :)
>
> From looking at
>   http://lxr.linux.no/linux+v3.2.1/arch/x86/include/asm/syscall.h#L97
> and ia32syscall enty code, it appears that for x86, at least, the
> pt_regs for compat processes will be 8 bytes wide per register on the
> stack.  This means if a self-filtering 32-bit program runs on a 64-bit host in
> IA32_EMU, its filters will always index into pt_regs incorrectly.
>
> I'm not 100% that I am reading the code right, but it means that I can either
> keep using user_regs_struct or fork the code behavior based on compat. That
> would need to be arch dependent then which is pretty rough.
>
> Any thoughts?
>
> I'll do a v5 rev for Eric's comments soon, but I'm not quite sure
> about the pt_regs
> change yet.  If the performance boost is worth the effort of having a
> per-arch fixup,
> I can go that route.  Otherwise, I could look at some alternate approach
> for a faster-than-regview payload.

I recommend not giving access to the registers at all, but to instead provide
a fixed cross-platform ABI (a 32 bit version and one 64 bit version).

As everyone dealing with system call is mostly interested in the same things:
The syscall number and the arguments. You can add some other potentially useful
info like instruction pointer as well, but keep it limited to cross-platform
things with a clear meaning that make sense for system call filtering.

So I propose an interface like the following instead of a register interface:

/* Currently 6, but to be future proof, make it 8 */
#define MAX_SC_ARGS	8

struct syscall_bpf_data {
	unsigned long syscall_nr;
	unsigned long flags;
	unsigned long instruction_pointer;
	unsigned long arg[MAX_SC_ARGS];
	unsigned long _reserved[5];
};

The flag argument can be used to e.g. tell if it is a compat 32 program
running on a 64 bit system.

This way the registers have to be interpreted only once by the kernel and all
filtering programs don't have to do that mapping themselves. It also avoids
doing unnecessary work fiddling/translating registers like the ptrace ABI does.

I missed if the original version was allowed to change the registers or not,
if it is then perhaps the BPF program should set a specific flag after changing
anything, to make it more explicit.

Greetings,

Indan


