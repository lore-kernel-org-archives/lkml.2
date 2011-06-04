Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1FDPqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:46:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48507 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab1FDPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:48 -0400
Date: Sat, 4 Jun 2011 17:36:54 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@au1.ibm.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Milton Miller <miltonm@bga.com>, Scott Wood <scottwood@freescale.com>,
        Meador Inge <meador_inge@mentor.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 7/8] arch/powerpc: use printk_ratelimited instead of
 printk_ratelimit
Message-ID: <0a33dcef54742947f0460d44b9d8ce94feba806b.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 arch/powerpc/kernel/signal_32.c |   57 +++++++++++++++++++++-----------------
 arch/powerpc/kernel/signal_64.c |   17 ++++++-----
 arch/powerpc/kernel/traps.c     |   22 +++++++--------
 arch/powerpc/mm/fault.c         |   10 +++---
 arch/powerpc/sysdev/mpic.c      |   11 +++----
 5 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index b96a3a0..78b76dc 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/elf.h>
 #include <linux/ptrace.h>
+#include <linux/ratelimit.h>
 #ifdef CONFIG_PPC64
 #include <linux/syscalls.h>
 #include <linux/compat.h>
@@ -892,11 +893,12 @@ badframe:
 	printk("badframe in handle_rt_signal, regs=%p frame=%p newsp=%lx\n",
 	       regs, frame, newsp);
 #endif
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(KERN_INFO "%s[%d]: bad frame in handle_rt_signal32: "
-			"%p nip %08lx lr %08lx\n",
-			current->comm, current->pid,
-			addr, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(KERN_INFO
+				   "%s[%d]: bad frame in handle_rt_signal32: "
+				   "%p nip %08lx lr %08lx\n",
+				   current->comm, current->pid,
+				   addr, regs->nip, regs->link);
 
 	force_sigsegv(sig, current);
 	return 0;
@@ -1058,11 +1060,12 @@ long sys_rt_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 	return 0;
 
  bad:
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(KERN_INFO "%s[%d]: bad frame in sys_rt_sigreturn: "
-			"%p nip %08lx lr %08lx\n",
-			current->comm, current->pid,
-			rt_sf, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(KERN_INFO
+				   "%s[%d]: bad frame in sys_rt_sigreturn: "
+				   "%p nip %08lx lr %08lx\n",
+				   current->comm, current->pid,
+				   rt_sf, regs->nip, regs->link);
 
 	force_sig(SIGSEGV, current);
 	return 0;
@@ -1149,12 +1152,12 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 	 * We kill the task with a SIGSEGV in this situation.
 	 */
 	if (do_setcontext(ctx, regs, 1)) {
-		if (show_unhandled_signals && printk_ratelimit())
-			printk(KERN_INFO "%s[%d]: bad frame in "
-				"sys_debug_setcontext: %p nip %08lx "
-				"lr %08lx\n",
-				current->comm, current->pid,
-				ctx, regs->nip, regs->link);
+		if (show_unhandled_signals)
+			printk_ratelimited(KERN_INFO "%s[%d]: bad frame in "
+					   "sys_debug_setcontext: %p nip %08lx "
+					   "lr %08lx\n",
+					   current->comm, current->pid,
+					   ctx, regs->nip, regs->link);
 
 		force_sig(SIGSEGV, current);
 		goto out;
@@ -1236,11 +1239,12 @@ badframe:
 	printk("badframe in handle_signal, regs=%p frame=%p newsp=%lx\n",
 	       regs, frame, newsp);
 #endif
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(KERN_INFO "%s[%d]: bad frame in handle_signal32: "
-			"%p nip %08lx lr %08lx\n",
-			current->comm, current->pid,
-			frame, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(KERN_INFO
+				   "%s[%d]: bad frame in handle_signal32: "
+				   "%p nip %08lx lr %08lx\n",
+				   current->comm, current->pid,
+				   frame, regs->nip, regs->link);
 
 	force_sigsegv(sig, current);
 	return 0;
@@ -1288,11 +1292,12 @@ long sys_sigreturn(int r3, int r4, int r5, int r6, int r7, int r8,
 	return 0;
 
 badframe:
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(KERN_INFO "%s[%d]: bad frame in sys_sigreturn: "
-			"%p nip %08lx lr %08lx\n",
-			current->comm, current->pid,
-			addr, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(KERN_INFO
+				   "%s[%d]: bad frame in sys_sigreturn: "
+				   "%p nip %08lx lr %08lx\n",
+				   current->comm, current->pid,
+				   addr, regs->nip, regs->link);
 
 	force_sig(SIGSEGV, current);
 	return 0;
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index da989ff..e91c736 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -24,6 +24,7 @@
 #include <linux/elf.h>
 #include <linux/ptrace.h>
 #include <linux/module.h>
+#include <linux/ratelimit.h>
 
 #include <asm/sigcontext.h>
 #include <asm/ucontext.h>
@@ -380,10 +381,10 @@ badframe:
 	printk("badframe in sys_rt_sigreturn, regs=%p uc=%p &uc->uc_mcontext=%p\n",
 	       regs, uc, &uc->uc_mcontext);
 #endif
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(regs->msr & MSR_64BIT ? fmt64 : fmt32,
-			current->comm, current->pid, "rt_sigreturn",
-			(long)uc, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(regs->msr & MSR_64BIT ? fmt64 : fmt32,
+				   current->comm, current->pid, "rt_sigreturn",
+				   (long)uc, regs->nip, regs->link);
 
 	force_sig(SIGSEGV, current);
 	return 0;
@@ -468,10 +469,10 @@ badframe:
 	printk("badframe in setup_rt_frame, regs=%p frame=%p newsp=%lx\n",
 	       regs, frame, newsp);
 #endif
-	if (show_unhandled_signals && printk_ratelimit())
-		printk(regs->msr & MSR_64BIT ? fmt64 : fmt32,
-			current->comm, current->pid, "setup_rt_frame",
-			(long)frame, regs->nip, regs->link);
+	if (show_unhandled_signals)
+		printk_ratelimited(regs->msr & MSR_64BIT ? fmt64 : fmt32,
+				   current->comm, current->pid, "setup_rt_frame",
+				   (long)frame, regs->nip, regs->link);
 
 	force_sigsegv(signr, current);
 	return 0;
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 0ff4ab9..7929aef 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -34,6 +34,7 @@
 #include <linux/bug.h>
 #include <linux/kdebug.h>
 #include <linux/debugfs.h>
+#include <linux/ratelimit.h>
 
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
@@ -197,12 +198,11 @@ void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 		if (die("Exception in kernel mode", regs, signr))
 			return;
 	} else if (show_unhandled_signals &&
-		    unhandled_signal(current, signr) &&
-		    printk_ratelimit()) {
-			printk(regs->msr & MSR_64BIT ? fmt64 : fmt32,
-				current->comm, current->pid, signr,
-				addr, regs->nip, regs->link, code);
-		}
+		   unhandled_signal(current, signr)) {
+		printk_ratelimited(regs->msr & MSR_64BIT ? fmt64 : fmt32,
+				   current->comm, current->pid, signr,
+				   addr, regs->nip, regs->link, code);
+	}
 
 	memset(&info, 0, sizeof(info));
 	info.si_signo = signr;
@@ -1342,9 +1342,8 @@ void altivec_assist_exception(struct pt_regs *regs)
 	} else {
 		/* didn't recognize the instruction */
 		/* XXX quick hack for now: set the non-Java bit in the VSCR */
-		if (printk_ratelimit())
-			printk(KERN_ERR "Unrecognized altivec instruction "
-			       "in %s at %lx\n", current->comm, regs->nip);
+		printk_ratelimited(KERN_ERR "Unrecognized altivec instruction "
+				   "in %s at %lx\n", current->comm, regs->nip);
 		current->thread.vscr.u[3] |= 0x10000;
 	}
 }
@@ -1548,9 +1547,8 @@ u32 ppc_warn_emulated;
 
 void ppc_warn_emulated_print(const char *type)
 {
-	if (printk_ratelimit())
-		pr_warning("%s used emulated %s instruction\n", current->comm,
-			   type);
+	pr_warn_ratelimited("%s used emulated %s instruction\n", current->comm,
+			    type);
 }
 
 static int __init ppc_warn_emulated_init(void)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 54f4fb9..ad35f66 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -31,6 +31,7 @@
 #include <linux/kdebug.h>
 #include <linux/perf_event.h>
 #include <linux/magic.h>
+#include <linux/ratelimit.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -346,11 +347,10 @@ bad_area_nosemaphore:
 		return 0;
 	}
 
-	if (is_exec && (error_code & DSISR_PROTFAULT)
-	    && printk_ratelimit())
-		printk(KERN_CRIT "kernel tried to execute NX-protected"
-		       " page (%lx) - exploit attempt? (uid: %d)\n",
-		       address, current_uid());
+	if (is_exec && (error_code & DSISR_PROTFAULT))
+		printk_ratelimited(KERN_CRIT "kernel tried to execute NX-protected"
+				   " page (%lx) - exploit attempt? (uid: %d)\n",
+				   address, current_uid());
 
 	return SIGSEGV;
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 3a8de5b..58d7a53 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
+#include <linux/ratelimit.h>
 
 #include <asm/ptrace.h>
 #include <asm/signal.h>
@@ -1648,9 +1649,8 @@ static unsigned int _mpic_get_one_irq(struct mpic *mpic, int reg)
 		return NO_IRQ;
 	}
 	if (unlikely(mpic->protected && test_bit(src, mpic->protected))) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING "%s: Got protected source %d !\n",
-			       mpic->name, (int)src);
+		printk_ratelimited(KERN_WARNING "%s: Got protected source %d !\n",
+				   mpic->name, (int)src);
 		mpic_eoi(mpic);
 		return NO_IRQ;
 	}
@@ -1688,9 +1688,8 @@ unsigned int mpic_get_coreint_irq(void)
 		return NO_IRQ;
 	}
 	if (unlikely(mpic->protected && test_bit(src, mpic->protected))) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING "%s: Got protected source %d !\n",
-			       mpic->name, (int)src);
+		printk_ratelimited(KERN_WARNING "%s: Got protected source %d !\n",
+				   mpic->name, (int)src);
 		return NO_IRQ;
 	}
 
-- 
1.7.1

