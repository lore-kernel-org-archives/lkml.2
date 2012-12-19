Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2LSUXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:23:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2LSUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:23:17 -0500
Date: Wed, 19 Dec 2012 12:22:58 -0800
Message-Id: <201212192022.qBJKMw3a021950@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86/nuke386 for v3.8-rc1
Cc: Alan Cox <alan@linux.intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One final 386 removal patch.

The following changes since commit 11af32b69ef7ee64c7d8848cad71a6f3749d9e37:

  x86, 386 removal: Document Nx586 as a 386 and thus unsupported (2012-11-29 13:28:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/nuke386

The head of this tree is bc3eba60682750dd7b45ea616d65c926fc3b8be8.

H. Peter Anvin (1):
      x86, 386 removal: Remove support for IRQ 13 FPU error reporting

 arch/x86/kernel/cpu/proc.c |  7 +------
 arch/x86/kernel/irqinit.c  | 40 ----------------------------------------
 arch/x86/kernel/traps.c    |  6 ------
 3 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index fbd8955..3286a92 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -26,11 +26,6 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 #ifdef CONFIG_X86_32
 static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 {
-	/*
-	 * We use exception 16 if we have hardware math and we've either seen
-	 * it or the CPU claims it is internal
-	 */
-	int fpu_exception = c->hard_math && (ignore_fpu_irq || cpu_has_fpu);
 	seq_printf(m,
 		   "fdiv_bug\t: %s\n"
 		   "hlt_bug\t\t: %s\n"
@@ -45,7 +40,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->f00f_bug ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
-		   fpu_exception ? "yes" : "no",
+		   c->hard_math ? "yes" : "no",
 		   c->cpuid_level,
 		   c->wp_works_ok ? "yes" : "no");
 }
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 6e03b0d..7dc4e45 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -42,39 +42,6 @@
  * (these are usually mapped into the 0x30-0xff vector range)
  */
 
-#ifdef CONFIG_X86_32
-/*
- * Note that on a 486, we don't want to do a SIGFPE on an irq13
- * as the irq is unreliable, and exception 16 works correctly
- * (ie as explained in the intel literature). On a 386, you
- * can't use exception 16 due to bad IBM design, so we have to
- * rely on the less exact irq13.
- *
- * Careful.. Not only is IRQ13 unreliable, but it is also
- * leads to races. IBM designers who came up with it should
- * be shot.
- */
-
-static irqreturn_t math_error_irq(int cpl, void *dev_id)
-{
-	outb(0, 0xF0);
-	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
-		return IRQ_NONE;
-	math_error(get_irq_regs(), 0, X86_TRAP_MF);
-	return IRQ_HANDLED;
-}
-
-/*
- * New motherboards sometimes make IRQ 13 be a PCI interrupt,
- * so allow interrupt sharing.
- */
-static struct irqaction fpu_irq = {
-	.handler = math_error_irq,
-	.name = "fpu",
-	.flags = IRQF_NO_THREAD,
-};
-#endif
-
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
@@ -242,13 +209,6 @@ void __init native_init_IRQ(void)
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
-	/*
-	 * External FPU? Set up irq13 if so, for
-	 * original braindamaged IBM FERR coupling.
-	 */
-	if (boot_cpu_data.hard_math && !cpu_has_fpu)
-		setup_irq(FPU_IRQ, &fpu_irq);
-
 	irq_ctx_init(smp_processor_id());
 #endif
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8276dc6..4e1478c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -69,9 +69,6 @@
 
 asmlinkage int system_call(void);
 
-/* Do we ignore FPU interrupts ? */
-char ignore_fpu_irq;
-
 /*
  * The IDT has to be page-aligned to simplify the Pentium
  * F0 0F bug workaround.
@@ -564,9 +561,6 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-#ifdef CONFIG_X86_32
-	ignore_fpu_irq = 1;
-#endif
 	exception_enter(regs);
 	math_error(regs, error_code, X86_TRAP_MF);
 	exception_exit(regs);
