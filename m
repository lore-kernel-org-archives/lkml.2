Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1HVCCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:02:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50067 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab1HVCCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E51B56F.3080301@zytor.com>
References: <20110820201406.GF2203@ZenIV.linux.org.uk> <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
 <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 21 Aug 2011 22:01:40 -0400
X-Google-Sender-Auth: GJgoCtSBBZKPKbWIVXIKDkHB13g
Message-ID: <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 9:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/21/2011 06:41 PM, Linus Torvalds wrote:
>> If people are using syscall directly, we're pretty much stuck. No
>> amount of "that's hopelessly wrong" will ever matter. We don't break
>> existing binaries.
>>
>> That said, I'd *hope* that everybody uses the vdso32, simply because
>> user programs are not supposed to know which CPU they are running on
>> and if that CPU even *supports* the syscall instruction. In which case
>> it may be possible that we can play games with the vdso thing. But
>> that really would be conditional on "nobody ever reports a failure".
>
> I think we found that out with the vsyscall emulation issue last cycle.
>  It works, so it will have been used, somewhere...
>
>> But if that's possible, maybe we can increment the RIP by 2 for
>> 'syscall', and slip an "'int 0x80" after the syscall instruction in
>> the vdso there? Resulting in the same pseudo-solution I suggested for
>> sysenter...
>
> I think we have the above problem.
>
> The problem here is that the syscall state is actually more complex than
> we retain: the entire state is given by (entry point, register state);
> with that amount of state we have all the information needed to *either*
> extract the syscall arguments *or* the register contents.  Without
> those, we can only represent one of the two possible metalevels (right
> now we represent the higher-level metalevel, the argument vector), but
> we need both for different usages.

My understanding of the problem is the following:

 1. The SYSCALL 32-bit calling convention puts arg2 in ebp and arg6 on
the stack.

 2. The int 0x80 convention is different: arg2 is in ecx.

 3. We're worried that pt_regs-using compat syscalls might want the
regs to appear to match the actual arguments (why?)

 4. ptrace expects the "registers" when SYSCALL happens to match the
int 0x80 convention.  (This is, IMO, sick.)

 5. Syscall restart with the SYSCALL instruction must switch to
userspace and back to the kernel for reasons I don't understand that
presumably involve signal delivery.

 6. Existing ABI requires that the kernel not clobber syscall
arguments (except, of course, when ptrace or syscall restart
explicitly change those arguments).

So we're sort of screwed.  arg2 must be in ecx to keep ptrace happy
but SYSCALL clobbers ecx, so arg2 cannot be preserved.

So here are three strawman ideas:

a) Change #4.  Maybe it's too late to do this, though.

b) When SYSCALL happens, change RIP to point two bytes past an int
0x80 instruction in the vdso.  Make the next instruction there be a
"ret" that returns to the instruction after the original syscall.
Patch the stack in the kernel.

c) Disable syscall restart when SYSCALL happens from somewhere outside the vdso.

--Andy
