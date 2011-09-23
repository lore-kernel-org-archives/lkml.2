Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1IWTTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1IWTTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:19:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V6][PATCH 1/6] x86, nmi: split out nmi from traps.c
Date: Fri, 23 Sep 2011 15:17:10 -0400
Message-Id: <1316805435-14832-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nmi stuff is changing a lot and adding more functionality.  Split it
out from the traps.c file so it doesn't continue to pollute that file.

This makes it easier to find and expand all the future nmi related work.

No real functional changes here.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/nmi.c    |  178 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c  |  155 ----------------------------------------
 3 files changed, 179 insertions(+), 156 deletions(-)
 create mode 100644 arch/x86/kernel/nmi.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 82f2912..8baca3c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -19,7 +19,7 @@ endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-obj-y			+= time.o ioport.o ldt.o dumpstack.o
+obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
new file mode 100644
index 0000000..68d758a
--- /dev/null
+++ b/arch/x86/kernel/nmi.c
@@ -0,0 +1,178 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ *
+ *  Pentium III FXSR, SSE support
+ *	Gareth Hughes <gareth@valinux.com>, May 2000
+ */
+
+/*
+ * Handle hardware traps and faults.
+ */
+#include <linux/spinlock.h>
+#include <linux/kprobes.h>
+#include <linux/kdebug.h>
+#include <linux/nmi.h>
+
+#if defined(CONFIG_EDAC)
+#include <linux/edac.h>
+#endif
+
+#include <linux/atomic.h>
+#include <asm/traps.h>
+#include <asm/mach_traps.h>
+
+static int ignore_nmis;
+
+int unknown_nmi_panic;
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
+
+static int __init setup_unknown_nmi_panic(char *str)
+{
+	unknown_nmi_panic = 1;
+	return 1;
+}
+__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
+
+static notrace __kprobes void
+pci_serr_error(unsigned char reason, struct pt_regs *regs)
+{
+	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+
+	/*
+	 * On some machines, PCI SERR line is used to report memory
+	 * errors. EDAC makes use of it.
+	 */
+#if defined(CONFIG_EDAC)
+	if (edac_handler_set()) {
+		edac_atomic_assert_error();
+		return;
+	}
+#endif
+
+	if (panic_on_unrecovered_nmi)
+		panic("NMI: Not continuing");
+
+	pr_emerg("Dazed and confused, but trying to continue\n");
+
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
+	outb(reason, NMI_REASON_PORT);
+}
+
+static notrace __kprobes void
+io_check_error(unsigned char reason, struct pt_regs *regs)
+{
+	unsigned long i;
+
+	pr_emerg(
+	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+	show_registers(regs);
+
+	if (panic_on_io_nmi)
+		panic("NMI IOCK error: Not continuing");
+
+	/* Re-enable the IOCK line, wait for a few seconds */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
+
+	i = 20000;
+	while (--i) {
+		touch_nmi_watchdog();
+		udelay(100);
+	}
+
+	reason &= ~NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
+}
+
+static notrace __kprobes void
+unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
+{
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
+			NOTIFY_STOP)
+		return;
+#ifdef CONFIG_MCA
+	/*
+	 * Might actually be able to figure out what the guilty party
+	 * is:
+	 */
+	if (MCA_bus) {
+		mca_handle_nmi();
+		return;
+	}
+#endif
+	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
+
+	pr_emerg("Do you have a strange power saving mode enabled?\n");
+	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
+		panic("NMI: Not continuing");
+
+	pr_emerg("Dazed and confused, but trying to continue\n");
+}
+
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+{
+	unsigned char reason = 0;
+
+	/*
+	 * CPU-specific NMI must be processed before non-CPU-specific
+	 * NMI, otherwise we may lose it, because the CPU-specific
+	 * NMI can not be detected/processed on other CPUs.
+	 */
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
+
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
+#endif
+		raw_spin_unlock(&nmi_reason_lock);
+		return;
+	}
+	raw_spin_unlock(&nmi_reason_lock);
+
+	unknown_nmi_error(reason, regs);
+}
+
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_enter();
+
+	inc_irq_stat(__nmi_count);
+
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6913369..a8e3eb8 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -81,15 +81,6 @@ gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
 
-static int ignore_nmis;
-
-int unknown_nmi_panic;
-/*
- * Prevent NMI reason port (0x61) being accessed simultaneously, can
- * only be used in NMI handler.
- */
-static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
-
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -307,152 +298,6 @@ gp_in_kernel:
 	die("general protection fault", regs, error_code);
 }
 
-static int __init setup_unknown_nmi_panic(char *str)
-{
-	unknown_nmi_panic = 1;
-	return 1;
-}
-__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
-
-static notrace __kprobes void
-pci_serr_error(unsigned char reason, struct pt_regs *regs)
-{
-	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-
-	/*
-	 * On some machines, PCI SERR line is used to report memory
-	 * errors. EDAC makes use of it.
-	 */
-#if defined(CONFIG_EDAC)
-	if (edac_handler_set()) {
-		edac_atomic_assert_error();
-		return;
-	}
-#endif
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	pr_emerg("Dazed and confused, but trying to continue\n");
-
-	/* Clear and disable the PCI SERR error line. */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
-	outb(reason, NMI_REASON_PORT);
-}
-
-static notrace __kprobes void
-io_check_error(unsigned char reason, struct pt_regs *regs)
-{
-	unsigned long i;
-
-	pr_emerg(
-	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-	show_registers(regs);
-
-	if (panic_on_io_nmi)
-		panic("NMI IOCK error: Not continuing");
-
-	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
-
-	i = 20000;
-	while (--i) {
-		touch_nmi_watchdog();
-		udelay(100);
-	}
-
-	reason &= ~NMI_REASON_CLEAR_IOCHK;
-	outb(reason, NMI_REASON_PORT);
-}
-
-static notrace __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
-{
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
-#ifdef CONFIG_MCA
-	/*
-	 * Might actually be able to figure out what the guilty party
-	 * is:
-	 */
-	if (MCA_bus) {
-		mca_handle_nmi();
-		return;
-	}
-#endif
-	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-		 reason, smp_processor_id());
-
-	pr_emerg("Do you have a strange power saving mode enabled?\n");
-	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	pr_emerg("Dazed and confused, but trying to continue\n");
-}
-
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
-{
-	unsigned char reason = 0;
-
-	/*
-	 * CPU-specific NMI must be processed before non-CPU-specific
-	 * NMI, otherwise we may lose it, because the CPU-specific
-	 * NMI can not be detected/processed on other CPUs.
-	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
-	raw_spin_lock(&nmi_reason_lock);
-	reason = get_nmi_reason();
-
-	if (reason & NMI_REASON_MASK) {
-		if (reason & NMI_REASON_SERR)
-			pci_serr_error(reason, regs);
-		else if (reason & NMI_REASON_IOCHK)
-			io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-		/*
-		 * Reassert NMI in case it became active
-		 * meanwhile as it's edge-triggered:
-		 */
-		reassert_nmi();
-#endif
-		raw_spin_unlock(&nmi_reason_lock);
-		return;
-	}
-	raw_spin_unlock(&nmi_reason_lock);
-
-	unknown_nmi_error(reason, regs);
-}
-
-dotraplinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-
-	inc_irq_stat(__nmi_count);
-
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-}
-
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
-- 
1.7.6

