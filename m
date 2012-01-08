Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2AHI4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 03:56:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2AHI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 03:56:06 -0500
Date: Sun, 8 Jan 2012 00:55:29 -0800
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <tip-549c89b98c4530b278dde1a3f68ce5ebbb1e6304@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        fweisbec@gmail.com, rostedt@goodmis.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        fweisbec@gmail.com, rostedt@goodmis.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com>
References: <CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Do not schedule while still in NMI context
Git-Commit-ID: 549c89b98c4530b278dde1a3f68ce5ebbb1e6304
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 00:55:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  549c89b98c4530b278dde1a3f68ce5ebbb1e6304
Gitweb:     http://git.kernel.org/tip/549c89b98c4530b278dde1a3f68ce5ebbb1e6304
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Tue, 29 Nov 2011 12:44:55 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 21 Dec 2011 15:38:52 -0500

x86: Do not schedule while still in NMI context

The NMI handler uses the paranoid_exit routine that checks the
NEED_RESCHED flag, and if it is set and the return is for userspace,
then interrupts are enabled, the stack is swapped to the thread's stack,
and schedule is called. The problem with this is that we are still in an
NMI context until an iret is executed. This means that any new NMIs are
now starved until an interrupt or exception occurs and does the iret.

As NMIs can not be masked and can interrupt any location, they are
treated as a special case. NEED_RESCHED should not be set in an NMI
handler. The interruption by the NMI should not disturb the work flow
for scheduling. Any IPI sent to a processor after sending the
NEED_RESCHED would have to wait for the NMI anyway, and after the IPI
finishes the schedule would be called as required.

There is no reason to do anything special leaving an NMI. Remove the
call to paranoid_exit and do a simple return. This not only fixes the
bug of starved NMIs, but it also cleans up the code.

Link: http://lkml.kernel.org/r/CA+55aFzgM55hXTs4griX5e9=v_O+=ue+7Rj0PTD=M7hFYpyULQ@mail.gmail.com

Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index faf8d5e..3819ea9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1489,46 +1489,14 @@ ENTRY(nmi)
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* paranoidexit; without TRACE_IRQS_OFF */
-	/* ebx:	no swapgs flag */
-	DISABLE_INTERRUPTS(CLBR_NONE)
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
-	testl $3,CS(%rsp)
-	jnz nmi_userspace
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
 	jmp irq_return
-nmi_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz nmi_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz nmi_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	jmp nmi_userspace
-nmi_schedule:
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	jmp nmi_userspace
 	CFI_ENDPROC
-#else
-	jmp paranoid_exit
-	CFI_ENDPROC
-#endif
 END(nmi)
 
 ENTRY(ignore_sysret)
