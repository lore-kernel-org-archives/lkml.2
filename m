Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0JWPFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:05:05 -0400
Received: from www.tglx.de ([62.245.132.106]:49081 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0JWPFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:05:03 -0400
Date: Sat, 23 Oct 2010 17:04:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 vm86 for 2.6.37
Message-ID: <alpine.LFD.2.00.1010231704270.5231@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vm86-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vm86-for-linus

Thanks,

	tglx

------------------>
Bart Oldeman (1):
      x86, vm86: Fix preemption bug for int1 debug and int3 breakpoint handlers.


 arch/x86/kernel/traps.c   |    1 +
 arch/x86/kernel/vm86_32.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 60788de..9f4edeb 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -575,6 +575,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
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
