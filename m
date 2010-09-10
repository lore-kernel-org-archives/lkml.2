Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0IJCvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:51:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:56172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0IJCvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:51:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,344,1280732400"; 
   d="scan'208";a="655886350"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR error
Date: Fri, 10 Sep 2010 10:51:02 +0800
Message-Id: <1284087065-32722-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory parity error is only valid for IBM PC-AT, newer machine use 7
bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
reported via MCE. So corresponding function name and kernel log string
is changed.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mach_traps.h |    6 +++---
 arch/x86/kernel/traps.c           |   24 ++++++------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -9,11 +9,11 @@
 
 #define NMI_REASON_PORT		0x61
 
-#define NMI_REASON_MEMPAR	0x80
+#define NMI_REASON_SERR		0x80
 #define NMI_REASON_IOCHK	0x40
-#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
+#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
 
-#define NMI_REASON_CLEAR_MEMPAR	0x04
+#define NMI_REASON_CLEAR_SERR	0x04
 #define NMI_REASON_CLEAR_IOCHK	0x08
 #define NMI_REASON_CLEAR_MASK	0x0f
 
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -301,29 +301,17 @@ gp_in_kernel:
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
-
-#if defined(CONFIG_EDAC)
-	if (edac_handler_set()) {
-		edac_atomic_assert_error();
-		return;
-	}
-#endif
+	printk(KERN_EMERG "NMI: PCI system error (SERR).\n");
 
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_MEMPAR;
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
 	outb(reason, NMI_REASON_PORT);
 }
 
@@ -420,8 +408,8 @@ static notrace __kprobes void default_do
 		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & NMI_REASON_MEMPAR)
-		mem_parity_error(reason, regs);
+	if (reason & NMI_REASON_SERR)
+		pci_serr_error(reason, regs);
 	if (reason & NMI_REASON_IOCHK)
 		io_check_error(reason, regs);
 #ifdef CONFIG_X86_32
