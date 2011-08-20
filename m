Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1HTVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 17:40:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38850 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1HTVkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 17:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
References: <E1Qu7nv-0007OP-3E@ZenIV.linux.org.uk> <4E4D642F.3010909@nod.at>
 <20110818191946.GW2203@ZenIV.linux.org.uk> <20110819043120.GY2203@ZenIV.linux.org.uk>
 <4E4E2427.9080602@nod.at> <20110820011845.GC2203@ZenIV.linux.org.uk>
 <4E4FD12F.70508@nod.at> <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at> <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 20 Aug 2011 17:40:03 -0400
X-Google-Sender-Auth: rK8cQkSCgMMnA3cdh0XPEIToaQA
Message-ID: <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
Subject: Re: [RFC] weird crap with vdso on uml/i386
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 5:26 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sat, Aug 20, 2011 at 4:55 PM, Richard Weinberger <richard@nod.at> wrote:

> I'm missing a bit of the background.  Is the user-on-UML app calling
> into a vdso entry provided by UML or into a vdso entry provided by the
> host?
>
> Why does anything care whether ecx is saved?  Doesn't the default
> calling convention allow the callee to clobber ecx?
>
> But my guess is that the 64-bit host sysret code might be buggy (or
> the value in gs:whatever is wrong). Can you get gdb to breakpoint at
> the beginning of __kernel_vsyscall before the crash?
>

This is suspicious:

ENTRY(ia32_cstar_target)
        CFI_STARTPROC32 simple
        CFI_SIGNAL_FRAME
        CFI_DEF_CFA     rsp,KERNEL_STACK_OFFSET
        CFI_REGISTER    rip,rcx
        /*CFI_REGISTER  rflags,r11*/
        SWAPGS_UNSAFE_STACK
        movl    %esp,%r8d
        CFI_REGISTER    rsp,r8
        movq    PER_CPU_VAR(kernel_stack),%rsp
        /*
         * No need to follow this irqs on/off section: the syscall
         * disabled irqs and here we enable it straight after entry:
         */
        ENABLE_INTERRUPTS(CLBR_NONE)
        SAVE_ARGS 8,0,0
        movl    %eax,%eax       /* zero extension */
        movq    %rax,ORIG_RAX-ARGOFFSET(%rsp)
        movq    %rcx,RIP-ARGOFFSET(%rsp)
        CFI_REL_OFFSET rip,RIP-ARGOFFSET
        movq    %rbp,RCX-ARGOFFSET(%rsp) /* this lies slightly to ptrace */

The entry code looks something like:

The text of __kernel_vsyscall() is
	0xffffe420 <__kernel_vsyscall+0>:       push   %ebp
	0xffffe421 <__kernel_vsyscall+1>:       mov    %ecx,%ebp
	0xffffe423 <__kernel_vsyscall+3>:       syscall
	0xffffe425 <__kernel_vsyscall+5>:       mov    $0x2b,%ecx
	0xffffe42a <__kernel_vsyscall+10>:      mov    %ecx,%ss
	0xffffe42c <__kernel_vsyscall+12>:      mov    %ebp,%ecx
	0xffffe42e <__kernel_vsyscall+14>:      pop    %ebp
	0xffffe42f <__kernel_vsyscall+15>:      ret

so the line:

movq    %rbp,RCX-ARGOFFSET(%rsp) /* this lies slightly to ptrace */

will cause iret (if iret happens) to restore the original rbp in rcx
(why? -- it seems okay if syscall is hit in __kernel_vsyscall but not
if something else does the syscall).  I don't see what saves rbp to
the stack frame.

This is also suspicious:

        movq    %r11,EFLAGS-ARGOFFSET(%rsp)

that's inconsistent with my reading of the AMD manual.

How well is the compat syscall entry tested through both the fast and
slow paths?  UML is unusual in that it uses ptrace to trap all system
calls, right?  That means that syscalls will enter through the cstar
target but return through the iret path.

--Andy
