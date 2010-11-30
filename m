Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0K3W2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:28:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0K3W2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:28:20 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/9] x86, NMI: Add NMI symbol constants and rename memory parity to PCI SERR
Date: Tue, 30 Nov 2010 17:27:22 -0500
Message-Id: <1291156050-4482-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Replace the NMI related magic numbers with symbol constants.

memory parity error is only valid for IBM PC-AT, newer machine use
bit 7 (0x80) of 0x61 port for PCI SERR. While memory error is usually
reported via MCE. So corresponding function name and kernel log string
is changed.

But on some machines, PCI SERR line is still used to report memory
errors. This is used by EDAC, so corresponding EDAC call is reserved.

v3:

- Merge adding symbol constants and renaming patches

v2:

- EDAC call in pci_serr_error is reserved.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/mach_traps.h |   12 ++++++++-
 arch/x86/kernel/traps.c           |   51 +++++++++++++++++++------------------
 2 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
index f792060..72a8b52 100644
--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -7,9 +7,19 @@
 
 #include <asm/mc146818rtc.h>
 
+#define NMI_REASON_PORT		0x61
+
+#define NMI_REASON_SERR		0x80
+#define NMI_REASON_IOCHK	0x40
+#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
+
+#define NMI_REASON_CLEAR_SERR	0x04
+#define NMI_REASON_CLEAR_IOCHK	0x08
+#define NMI_REASON_CLEAR_MASK	0x0f
+
 static inline unsigned char get_nmi_reason(void)
 {
-	return inb(0x61);
+	return inb(NMI_REASON_PORT);
 }
 
 static inline void reassert_nmi(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bb6f041..10a43f5 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -310,15 +310,15 @@ static int __init setup_unknown_nmi_panic(char *str)
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 static notrace __kprobes void
-mem_parity_error(unsigned char reason, struct pt_regs *regs)
+pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
-	printk(KERN_EMERG
-		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-			reason, smp_processor_id());
-
-	printk(KERN_EMERG
-		"You have some hardware problem, likely on the PCI bus.\n");
+	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 
+	/*
+	 * On some machines, PCI SERR line is used to report memory
+	 * errors. EDAC makes use of it.
+	 */
 #if defined(CONFIG_EDAC)
 	if (edac_handler_set()) {
 		edac_atomic_assert_error();
@@ -329,11 +329,11 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	pr_emerg("Dazed and confused, but trying to continue\n");
 
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
+	outb(reason, NMI_REASON_PORT);
 }
 
 static notrace __kprobes void
@@ -341,22 +341,24 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
 
-	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
+	pr_emerg(
+	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 	show_registers(regs);
 
 	if (panic_on_io_nmi)
 		panic("NMI IOCK error: Not continuing");
 
 	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & 0xf) | 8;
-	outb(reason, 0x61);
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
 
 	i = 2000;
 	while (--i)
 		udelay(1000);
 
-	reason &= ~8;
-	outb(reason, 0x61);
+	reason &= ~NMI_REASON_CLEAR_IOCHK;
+	outb(reason, NMI_REASON_PORT);
 }
 
 static notrace __kprobes void
@@ -375,15 +377,14 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 		return;
 	}
 #endif
-	printk(KERN_EMERG
-		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-			reason, smp_processor_id());
+	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+		 reason, smp_processor_id());
 
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
+	pr_emerg("Do you have a strange power saving mode enabled?\n");
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	pr_emerg("Dazed and confused, but trying to continue\n");
 }
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
@@ -397,7 +398,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (!cpu)
 		reason = get_nmi_reason();
 
-	if (!(reason & 0xc0)) {
+	if (!(reason & NMI_REASON_MASK)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
@@ -415,9 +416,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & 0x80)
-		mem_parity_error(reason, regs);
-	if (reason & 0x40)
+	if (reason & NMI_REASON_SERR)
+		pci_serr_error(reason, regs);
+	if (reason & NMI_REASON_IOCHK)
 		io_check_error(reason, regs);
 #ifdef CONFIG_X86_32
 	/*
-- 
1.7.3.2

