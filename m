Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2AMXKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:10:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45505 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2AMXKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:10:44 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
	<CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
	<20120113173153.GA24273@redhat.com>
	<CABqD9hYYJMNtupTiD48sE5wz6RKaFi9J3DpVRyV4X2FpnT3Mnw@mail.gmail.com>
Date: Fri, 13 Jan 2012 17:10:41 -0600
Message-ID: <CABqD9hbhcEr0idfBVb9sXiAP1rBVUtzWmORq0WL1MF-eWW-nvQ@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 1:01 PM, Will Drewry <wad@chromium.org> wrote:
> On Fri, Jan 13, 2012 at 11:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 01/12, Will Drewry wrote:
>>>
>>> On Thu, Jan 12, 2012 at 11:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> > On 01/12, Will Drewry wrote:
>>> >>
>>> >> On Thu, Jan 12, 2012 at 10:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> >> >> +      */
>>> >> >> +     regs = seccomp_get_regs(regs_tmp, &regs_size);
>>> >> >
>>> >> > Stupid question. I am sure you know what are you doing ;) and I know
>>> >> > nothing about !x86 arches.
>>> >> >
>>> >> > But could you explain why it is designed to use user_regs_struct ?
>>> >> > Why we can't simply use task_pt_regs() and avoid the (costly) regsets?
>>> >>
>>> >> So on x86 32, it would work since user_regs_struct == task_pt_regs
>>> >> (iirc), but on x86-64
>>> >> and others, that's not true.
>>> >
>>> > Yes sure, I meant that userpace should use pt_regs too.
>>> >
>>> >> If it would be appropriate to expose pt_regs to userspace, then I'd
>>> >> happily do so :)
>>> >
>>> > Ah, so that was the reason. But it is already exported? At least I see
>>> > the "#ifndef __KERNEL__" definition in arch/x86/include/asm/ptrace.h.
>>> >
>>> > Once again, I am not arguing, just trying to understand. And I do not
>>> > know if this definition is part of abi.
>>>
>>> I don't either :/  My original idea was to operate on task_pt_regs(current),
>>> but I noticed that PTRACE_GETREGS/SETREGS only uses the
>>> user_regs_struct. So I went that route.
>>
>> Well, I don't know where user_regs_struct come from initially. But
>> probably it is needed to allow to access the "artificial" things like
>> fs_base. Or perhaps this struct mimics the layout in the coredump.
>
> Not sure - added Roland whose name was on many of the files :)
>
> I just noticed that ptrace ABI allows pt_regs access using the register
> macros (PTRACE_PEEKUSR) and user_regs_struct access (PTRACE_GETREGS).
>
> But I think the latter is guaranteed to have a certain layout while the macros
> for PEEKUSR can do post-processing fixup.  (Which could be done in the
> bpf evaluator load_pointer() helper if needed.)
>
>>> I'd love for pt_regs to be fair game to cut down on the copying!
>>
>> Me too. I see no point in using user_regs_struct.
>
> I'll rev the change to use pt_regs and drop all the helper code.  If
> no one says otherwise, that certainly seems ideal from a performance
> perspective, and I see pt_regs exported to userland along with ptrace
> abi register offset macros.

On second thought, pt_regs is scary :)

>From looking at
  http://lxr.linux.no/linux+v3.2.1/arch/x86/include/asm/syscall.h#L97
and ia32syscall enty code, it appears that for x86, at least, the
pt_regs for compat processes will be 8 bytes wide per register on the
stack.  This means if a self-filtering 32-bit program runs on a 64-bit host in
IA32_EMU, its filters will always index into pt_regs incorrectly.

I'm not 100% that I am reading the code right, but it means that I can either
keep using user_regs_struct or fork the code behavior based on compat. That
would need to be arch dependent then which is pretty rough.

Any thoughts?

I'll do a v5 rev for Eric's comments soon, but I'm not quite sure
about the pt_regs
change yet.  If the performance boost is worth the effort of having a
per-arch fixup,
I can go that route.  Otherwise, I could look at some alternate approach for a
faster-than-regview payload.

Thanks!
