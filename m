Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0JANcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:32:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44629 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0JANcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Xh2lPNBIaLrbH55vB+Qx4IgQG+89t8gH5DVVxz6rfjrmh7LsaDxsYywB2yFN4R2H/y
         3A3yYwYyuJJ5Wy42CgLuBkLJZTtJF/TkOIwSFh/O737BPoSpEfgX7gec2gFslaIW1GPe
         4dU2vxgHLxCVvDKYCpMs1A6PUjFjczHifrl88=
Date: Fri, 1 Oct 2010 09:32:09 -0400 (EDT)
From: Bart Oldeman <bartoldeman@users.sourceforge.net>
X-X-Sender: bart@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Brian Gerst <brgerst@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Subject: [PATCH] x86, vm86: Eliminate jump to assembly code when
 returning from vm86().
Message-ID: <alpine.DEB.2.00.1010010929210.25021@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The direct jump to the code in entry_32.S from return_to_32bit() caused
confusion in the callers of handle_vm86_trap() and handle_vm86_fault(),
giving rise to preempt bugs (now fixed in commit
6554287b1de0448f1e02e200d02b43914e997d15). This patch eliminates the
jump entirely by setting TIF_IRET, which causes the code in entry_32.S to
adjust the stack correctly and return to 32-bit user space. Callers of
return_to_32bit() are adjusted to return immediately.

Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>

  arch/x86/kernel/vm86_32.c |   39 +++++++++++++++++++++------------------
  1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 61fb985..16cb513 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -350,23 +350,18 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
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
+	/* setting this flag forces the code in entry_32.S to
+	   call save_v86_state() and change the stack pointer
+	   to KVM86->regs32 */
+	set_thread_flag(TIF_IRET);
  }

  static inline void set_IF(struct kernel_vm86_regs *regs)
  {
  	VEFLAGS |= X86_EFLAGS_VIF;
-	if (VEFLAGS & X86_EFLAGS_VIP)
-		return_to_32bit(regs, VM86_STI);
  }

  static inline void clear_IF(struct kernel_vm86_regs *regs)
@@ -552,11 +547,7 @@ int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int trapno)
  {
  	if (VMPI.is_vm86pus) {
  		if ((trapno == 3) || (trapno == 1)) {
-			KVM86->regs32->ax = VM86_TRAP + (trapno << 8);
-			/* setting this flag forces the code in entry_32.S to
-			   call save_v86_state() and change the stack pointer
-			   to KVM86->regs32 */
-			set_thread_flag(TIF_IRET);
+			return_to_32bit(regs, VM86_TRAP + (trapno << 8));
  			return 0;
  		}
  		do_int(regs, trapno, (unsigned char __user *) (regs->pt.ss << 4), SP(regs));
@@ -584,7 +575,7 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
  #define VM86_FAULT_RETURN do { \
  	if (VMPI.force_return_for_pic  && (VEFLAGS & (X86_EFLAGS_IF | X86_EFLAGS_VIF))) \
  		return_to_32bit(regs, VM86_PICRETURN); \
-	if (orig_flags & X86_EFLAGS_TF) \
+	else if (orig_flags & X86_EFLAGS_TF)	       \
  		handle_vm86_trap(regs, 0, 1); \
  	return; } while (0)

@@ -644,6 +635,8 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
  			set_vflags_long(newflags, regs);
  		else
  			set_vflags_short(newflags, regs);
+		if (newflags & X86_EFLAGS_IF)
+			goto sti_return;

  		VM86_FAULT_RETURN;
  		}
@@ -653,8 +646,11 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
  		int intno = popb(csp, ip, simulate_sigsegv);
  		IP(regs) = ip;
  		if (VMPI.vm86dbg_active) {
-			if ((1 << (intno & 7)) & VMPI.vm86dbg_intxxtab[intno >> 3])
+			if ((1 << (intno & 7)) &
+			    VMPI.vm86dbg_intxxtab[intno >> 3]) {
  				return_to_32bit(regs, VM86_INTx + (intno << 8));
+				return;
+			}
  		}
  		do_int(regs, intno, ssp, sp);
  		return;
@@ -685,6 +681,8 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
  		} else {
  			set_vflags_short(newflags, regs);
  		}
+		if (newflags & X86_EFLAGS_IF)
+			goto sti_return;
  		VM86_FAULT_RETURN;
  		}

@@ -704,6 +702,11 @@ void handle_vm86_fault(struct kernel_vm86_regs *regs, long error_code)
  	case 0xfb:
  		IP(regs) = ip;
  		set_IF(regs);
+sti_return:
+		if (VEFLAGS & X86_EFLAGS_VIP) {
+			return_to_32bit(regs, VM86_STI);
+			return;
+		}
  		VM86_FAULT_RETURN;

  	default:
-- 
1.7.1

