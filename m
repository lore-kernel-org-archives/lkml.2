Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0JIGty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 02:49:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:7021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab0JIGty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 02:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,307,1283756400"; 
   d="scan'208";a="614941810"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3 1/6] x86, NMI, Add NMI symbol constants and rename memory parity to PCI SERR
Date: Sat,  9 Oct 2010 14:49:42 +0800
Message-Id: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the NMI related magic numbers with symbol constants.

memory parity error is only valid for IBM PC-AT, newer machine use 7
bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
reported via MCE. So corresponding function name and kernel log string
is changed.

But on some machines, PCI SERR line is still used to report memory
errors. This is used by EDAC, so corresponding EDAC call is reserved.


v3:

- Merge adding symbol constants and renaming patches

v2:

- EDAC call in pci_serr_error is reserved.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mach_traps.h |   12 ++++++++
 arch/x86/kernel/traps.c           |   51 +++++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 26 deletions(-)

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
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -301,15 +301,15 @@ gp_in_kernel:
 }
 
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
@@ -320,11 +320,11 @@ mem_parity_error(unsigned char reason, s
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
@@ -332,22 +332,24 @@ io_check_error(unsigned char reason, str
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
@@ -366,15 +368,14 @@ unknown_nmi_error(unsigned char reason,
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
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	pr_emerg("Dazed and confused, but trying to continue\n");
 }
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
@@ -388,7 +389,7 @@ static notrace __kprobes void default_do
 	if (!cpu)
 		reason = get_nmi_reason();
 
-	if (!(reason & 0xc0)) {
+	if (!(reason & NMI_REASON_MASK)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
@@ -418,9 +419,9 @@ static notrace __kprobes void default_do
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
