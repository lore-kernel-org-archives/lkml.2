Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0IWNv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:51:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60131 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0IWNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=bG5VpVd9sHrS/cTS1+US7lJzaBOVXldsO/JkOFqJtOMwruN1ZaKQJUQ4HEuRF4AXpG
         kOC7op+lRKhTIq70NYF0hVcgkkmVxswxxmexEZgYW0WeT/Yyx45F0cMFrqoFipePlNBd
         HsmcPUc3VUHA/7ROAAAFHbx/Eok4CkMuVyXDU=
Date: Thu, 23 Sep 2010 09:51:21 -0400 (EDT)
From: Bart Oldeman <bartoldeman@users.sourceforge.net>
X-X-Sender: bart@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: heukelum@fastmail.fm, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH] x86, vm86: fix preemption bug for int1 debug and int3
 breakpoint handlers.
Message-ID: <alpine.DEB.2.00.1009230949480.8587@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
preemption only needs to be disabled on x86_64 because a seperate 
stack is used, but it's nice to have things work the same way on
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
---
  arch/x86/kernel/traps.c   |    1 +
  arch/x86/kernel/vm86_32.c |   14 +++++---------
  2 files changed, 6 insertions(+), 9 deletions(-)

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
index 5ffb562..ad0830d 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -350,16 +350,12 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
  	/* we never return here */
  }

-static inline void return_to_32bit(struct kernel_vm86_regs *regs16, int retval)
+static inline void return_to_32bit(struct kernel_vm86_regs *regs, int retval)
  {
-	struct pt_regs *regs32;
-
-	regs32 = save_v86_state(regs16);
-	regs32->ax = retval;
-	__asm__ __volatile__("movl %0,%%esp\n\t"
-		"movl %1,%%ebp\n\t"
-		"jmp resume_userspace"
-		: : "r" (regs32), "r" (current_thread_info()));
+	KVM86->regs32->ax = retval;
+	/* setting this flag forces the code in entry_32.S to call
+	   save_v86_state() and change the stack pointer to KVM86->regs32 */
+	set_thread_flag(TIF_IRET);
  }

  static inline void set_IF(struct kernel_vm86_regs *regs)
