Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0KSWPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:15:54 -0500
Received: from kroah.org ([198.145.64.141]:52921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0KSWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:14 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220124.144057056@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Oldeman <bartoldeman@users.sourceforge.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "K.Prasad" <prasad@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [24/66] x86, vm86: Fix preemption bug for int1 debug and int3 breakpoint handlers.
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bart Oldeman <bartoldeman@gmail.com>

commit 6554287b1de0448f1e02e200d02b43914e997d15 upstream.

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
preempt_conditional_cli(regs); is necessary in traps.c to correct the
bug.

[ hpa: This is technically a regression, but because:
  1. the regression is so old,
  2. the patch seems relatively high risk, justifying more testing, and
  3. we're late in the 2.6.36-rc cycle,

  I'm queuing it up for the 2.6.37 merge window.  It might, however,
  justify as a -stable backport at a latter time, hence Cc: stable. ]

Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>
LKML-Reference: <alpine.DEB.2.00.1009231312330.4732@localhost.localdomain>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/traps.c   |    1 +
 arch/x86/kernel/vm86_32.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -575,6 +575,7 @@ dotraplinkage void __kprobes do_debug(st
 	if (regs->flags & X86_VM_MASK) {
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
+		preempt_conditional_cli(regs);
 		return;
 	}
 
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


