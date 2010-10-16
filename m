Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0JPQgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:36:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:53195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0JPQga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:36:30 -0400
Date: Sat, 16 Oct 2010 16:36:05 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1287195738-3136-2-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Add NMI symbol constants and rename memory parity to PCI SERR
Message-ID: <tip-88de48ce3d1c384079bf5b603d3056ae2d60a185@git.kernel.org>
Git-Commit-ID: 88de48ce3d1c384079bf5b603d3056ae2d60a185
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:36:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88de48ce3d1c384079bf5b603d3056ae2d60a185
Gitweb:     http://git.kernel.org/tip/88de48ce3d1c384079bf5b603d3056ae2d60a185
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 15 Oct 2010 22:22:14 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 15:01:27 +0200

x86, NMI: Add NMI symbol constants and rename memory parity to PCI SERR

Replace the NMI related magic numbers with symbol constants.

memory parity error is only valid for IBM PC-AT, newer machine
use bit 7 (0x80) of 0x61 port for PCI SERR. While memory error
is usually reported via MCE. So corresponding function name and
kernel log string is changed.

But on some machines, PCI SERR line is still used to report
memory errors. This is used by EDAC, so corresponding EDAC call
is reserved.

v3:

- Merge adding symbol constants and renaming patches

v2:

- EDAC call in pci_serr_error is reserved.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: robert.richter@amd.com
Cc: peterz@infradead.org
LKML-Reference: <1287195738-3136-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 60788de..e04e59b 100644
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
@@ -320,11 +320,11 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
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
@@ -332,22 +332,24 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
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
@@ -366,15 +368,14 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
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
@@ -388,7 +389,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (!cpu)
 		reason = get_nmi_reason();
 
-	if (!(reason & 0xc0)) {
+	if (!(reason & NMI_REASON_MASK)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
@@ -418,9 +419,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
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
