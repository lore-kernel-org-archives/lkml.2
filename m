Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab2GZFUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:20:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40140 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2GZFUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:20:00 -0400
Date: Thu, 26 Jul 2012 10:49:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Cc: benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, michael@ellerman.id.au,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Subject: [PATCH 1/2] powerpc: Add trap_nr to thread_struct
Message-ID: <20120726051902.GA29466@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072605-5930-0000-0000-00000A37F3CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Add thread_struct.trap_nr and use it to store the last exception
the thread experienced. In this patch, we populate the field at
various places where we force_sig_info() to the process.

This is also used in uprobes to determine if the probed instruction
caused an exception.

Patch applies on the current master branch of Linus' tree (bdc0077af)

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/powerpc/include/asm/processor.h |    1 +
 arch/powerpc/kernel/process.c        |    2 ++
 arch/powerpc/kernel/traps.c          |    1 +
 arch/powerpc/mm/fault.c              |    1 +
 4 files changed, 5 insertions(+)

Index: linux-26jul/arch/powerpc/include/asm/processor.h
===================================================================
--- linux-26jul.orig/arch/powerpc/include/asm/processor.h
+++ linux-26jul/arch/powerpc/include/asm/processor.h
@@ -219,6 +219,7 @@ struct thread_struct {
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 #endif
 	unsigned long	dabr;		/* Data address breakpoint register */
+	unsigned long	trap_nr;	/* last trap # on this thread */
 #ifdef CONFIG_ALTIVEC
 	/* Complete AltiVec register set */
 	vector128	vr[32] __attribute__((aligned(16)));
Index: linux-26jul/arch/powerpc/kernel/process.c
===================================================================
--- linux-26jul.orig/arch/powerpc/kernel/process.c
+++ linux-26jul/arch/powerpc/kernel/process.c
@@ -258,6 +258,7 @@ void do_send_trap(struct pt_regs *regs, 
 {
 	siginfo_t info;
 
+	current->thread.trap_nr = signal_code;
 	if (notify_die(DIE_DABR_MATCH, "dabr_match", regs, error_code,
 			11, SIGSEGV) == NOTIFY_STOP)
 		return;
@@ -275,6 +276,7 @@ void do_dabr(struct pt_regs *regs, unsig
 {
 	siginfo_t info;
 
+	current->thread.trap_nr = TRAP_HWBKPT;
 	if (notify_die(DIE_DABR_MATCH, "dabr_match", regs, error_code,
 			11, SIGSEGV) == NOTIFY_STOP)
 		return;
Index: linux-26jul/arch/powerpc/kernel/traps.c
===================================================================
--- linux-26jul.orig/arch/powerpc/kernel/traps.c
+++ linux-26jul/arch/powerpc/kernel/traps.c
@@ -251,6 +251,7 @@ void _exception(int signr, struct pt_reg
 	if (arch_irqs_disabled() && !arch_irq_disabled_regs(regs))
 		local_irq_enable();
 
+	current->thread.trap_nr = code;
 	memset(&info, 0, sizeof(info));
 	info.si_signo = signr;
 	info.si_code = code;
Index: linux-26jul/arch/powerpc/mm/fault.c
===================================================================
--- linux-26jul.orig/arch/powerpc/mm/fault.c
+++ linux-26jul/arch/powerpc/mm/fault.c
@@ -133,6 +133,7 @@ static int do_sigbus(struct pt_regs *reg
 	up_read(&current->mm->mmap_sem);
 
 	if (user_mode(regs)) {
+		current->thread.trap_nr = BUS_ADRERR;
 		info.si_signo = SIGBUS;
 		info.si_errno = 0;
 		info.si_code = BUS_ADRERR;

