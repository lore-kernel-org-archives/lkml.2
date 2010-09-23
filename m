Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0IWRdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:33:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42539 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0IWRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=PLNV+NT0bBaX2D/+1HjkOKXY7b3BB9viFaEdyoZBXvfMTU/yzbInJbWAf7btxouRmZ
         nBP3PDQLbGatI9pNwtsMkZI0un5Po4NPf5EKAWW+SyySkswmegcomXgWBcG0X1WhUPAu
         t0FjslyyVf9EUkixYUBVORnyjj2kyX2q24C4s=
Date: Thu, 23 Sep 2010 13:16:58 -0400 (EDT)
From: Bart Oldeman <bartoldeman@gmail.com>
To: Bart Oldeman <bartoldeman@users.sourceforge.net>
cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] x86, vm86: fix preemption bug for int1 debug and int3
 breakpoint handlers.
In-Reply-To: <alpine.DEB.2.00.1009230949480.8587@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1009231312330.4732@localhost.localdomain>
References: <alpine.DEB.2.00.1009230949480.8587@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a more minimal and more correct version of the patch I sent 
earlier today. Changing return_to_32bit() to not JMP is desirable but 
needs more careful checking of return statements in vm86_32.c.

Impact: fix kernel bug such as:
BUG: scheduling while atomic: dosemu.bin/19680/0x00000004
See also Ubuntu bug 455067 at 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/455067

Commits 4915a35e35a037254550a2ba9f367a812bc37d40
("Use preempt_conditional_sti/cli in do_int3, like on x86_64.")
and 3d2a71a596bd9c761c8487a2178e95f8a61da083
("x86, traps: converge do_debug handlers")
started disabling preemption in int1 and int3 handlers on i386.
The problem with vm86 is that the call to handle_vm86_trap() may jump
straight to entry_32.S and never returns so preempt is never enabled
again, and there is an imbalance in the preempt count.

Commit be716615fe596ee117292dc615e95f707fb67fd1 ("x86, vm86:
fix preemption bug"), which was later (accidentally?) reverted by commit
08d68323d1f0c34452e614263b212ca556dae47f ("hw-breakpoints: modifying
generic debug exception to use thread-specific debug registers")
fixed the problem for debug exceptions but not for breakpoints.

There are three solutions to this problem.

1. Reenable preemption before calling handle_vm86_trap(). This
was the approach that was later reverted.

2. Do not disable preemption for i386 in breakpoint and debug handlers.
This was the situation before October 2008. As far as I understand
preemption only needs to be disabled on x86_64 because a seperate stack is 
used, but it's nice to have things work the same way on
i386 and x86_64.

3. Let handle_vm86_trap() return instead of jumping to assembly code.
By setting a flag in _TIF_WORK_MASK, either TIF_IRET or TIF_NOTIFY_RESUME,
the code in entry_32.S is instructed to return to 32 bit mode from
V86 mode. The logic in entry_32.S was already present to handle signals.
(I chose TIF_IRET because it's slightly more efficient in
do_notify_resume() in signal.c, but in fact TIF_IRET can probably be
replaced by TIF_NOTIFY_RESUME everywhere.)

I'm submitting approach 3, because I believe it is the most elegant
and prevents future confusion. Still, an obvious 
preempt_conditional_cli(regs);
is necessary in traps.c to correct the bug.

Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>

  arch/x86/kernel/traps.c   |    1 +
  arch/x86/kernel/vm86_32.c |   10 ++++++++--
  2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 725ef4d..4d0f3ed 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -568,6 +568,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
  	if (regs->flags & X86_VM_MASK) {
  		handle_vm86_trap((struct kernel_vm86_regs *) regs,
  				error_code, 1);
+		preempt_conditional_cli(regs);
  		return;
  	}

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 5ffb562..61fb985 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -551,8 +551,14 @@ cannot_handle:
  int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
  {
  	if (VMPI.is_vm86pus) {
-		if ((trapno == 3) || (trapno == 1))
-			return_to_32bit(regs, VM86_TRAP + (trapno << 8));
+		if ((trapno == 3) || (trapno == 1)) {
+			KVM86->regs32->ax = VM86_TRAP + (trapno << 8);
+			/* setting this flag forces the code in entry_32.S to
+			   call save_v86_state() and change the stack pointer
+			   to KVM86->regs32 */
+			set_thread_flag(TIF_IRET);
+			return 0;
+		}
  		do_int(regs, trapno, (unsigned char __user *) (regs->pt.ss << 4), SP(regs));
  		return 0;
  	}
