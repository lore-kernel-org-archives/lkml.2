Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0I0A5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:57:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:61860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0I0A5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121732"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 3/7] x86, NMI, Rename memory parity error to PCI SERR error
Date: Mon, 27 Sep 2010 08:57:02 +0800
Message-Id: <1285549026-5008-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory parity error is only valid for IBM PC-AT, newer machine use 7
bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
reported via MCE. So corresponding function name and kernel log string
is changed.

But on some machines, PCI SERR line is still used to report memory
errors. This is used by EDAC, so corresponding EDAC call is reserved.


v2:

- EDAC call in pci_serr_error is reserved.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mach_traps.h |    6 +++---
 arch/x86/kernel/traps.c           |   21 ++++++++++-----------
 2 files changed, 13 insertions(+), 14 deletions(-)

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
@@ -301,15 +301,14 @@ gp_in_kernel:
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
+	printk(KERN_EMERG "NMI: PCI system error (SERR).\n");
 
+	/*
+	 * On some machines, PCI SERR line is used to report memory
+	 * errors. EDAC makes use of it.
+	 */
 #if defined(CONFIG_EDAC)
 	if (edac_handler_set()) {
 		edac_atomic_assert_error();
@@ -322,8 +321,8 @@ mem_parity_error(unsigned char reason, s
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_MEMPAR;
+	/* Clear and disable the PCI SERR error line. */
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
 	outb(reason, NMI_REASON_PORT);
 }
 
@@ -420,8 +419,8 @@ static notrace __kprobes void default_do
 		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & NMI_REASON_MEMPAR)
-		mem_parity_error(reason, regs);
+	if (reason & NMI_REASON_SERR)
+		pci_serr_error(reason, regs);
 	if (reason & NMI_REASON_IOCHK)
 		io_check_error(reason, regs);
 #ifdef CONFIG_X86_32
