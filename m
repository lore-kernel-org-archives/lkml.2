Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1HVAof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:44:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40749 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1HVAoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110821164124.GL2203@ZenIV.linux.org.uk>
References: <20110820011845.GC2203@ZenIV.linux.org.uk> <4E4FD12F.70508@nod.at>
 <20110820201406.GF2203@ZenIV.linux.org.uk> <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 21 Aug 2011 20:44:12 -0400
X-Google-Sender-Auth: GxBFarzcGlwVKLzDbEldNqxDxJQ
Message-ID: <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 12:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Aug 21, 2011 at 03:43:52PM +0100, Al Viro wrote:
>
>> We do not lie to ptrace and iret.  At all.  We do just what you have
>> described.  And fuck up when restart returns us to the SYSCALL / SYSENTER
>> instruction again, which expects the different calling conventions,
>> so the values arranged in registers in the way int 0x80 would expect
>> do us no good.
>
> FWIW, what really happens (for 32bit task on amd64) is this:

I think I believe your analysis...

>        * Both codepaths start with arranging the same thing on the kernel
> stack frame; one 64bit int 0x80 would create.  For the good and simple
> reason: they all have to be able to leave via IRET.  Stack layout is the
> same, but we need to fill it accordingly to calling conventions we are
> stuck with.  I.e. ->cx should be initialized with arg2 and ->bp with
> arg6, wherever those currently are on given codepath.  _That_ is what
> "lying to ptrace" is about - we store there registers according to how
> they were when we entered __kernel_vsyscall(), not as they are at the
> moment of actual SYSCALL insn.  Which is precisely the right thing to do,
> since if we *are* ptraced, the tracer expects to find the syscall argument
> in the same places, whichever variant of syscall tracee happens to be using.

This is, IMO, gross -- if the values in pt_regs matched what they were
when sysenter / syscall was issued, then we'd be fine -- we could
restart the syscall and everything would work.  Apparently ptrace
users have a problem with that, so we're stuck with the "lie" (i.e.
reporting values as of __kernel_vsyscall, not as of the actual kernel
entry).

>        * If there *was* a syscall restart to be done, we are guaranteed to
> have left via IRET path.  In all cases the syscall arguments end up in
> registers, in the same way int 0x80 expected them.  What happens afterwards
> depends on how we entered, though.
>                + int 0x80: all registers are restored (with ptrace
> manipulations, if any, having left their effect) as they'd been the last
> time around.  In we go and that's it.

Which suggests an easy-ish fix: if sysenter is used or if syscall is
entered from the EIP is is supposed to be entered from, then just
change ip in the argument save to point to the int 0x80 instruction.
This might also require tweaking the userspace stack.  That way,
restart would hit int 0x80 instead of syscall/sysenter and the
registers are exactly as expected.

Getting this right in the case where ptrace attaches during the
syscall might be tricky, though.

--Andy
