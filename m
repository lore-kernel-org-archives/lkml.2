Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab0I0A6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:58:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:61860 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab0I0A5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121723"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 1/7] x86, NMI, Add symbol definition for NMI magic constants
Date: Mon, 27 Sep 2010 08:57:00 +0800
Message-Id: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the NMI related magic numbers with symbol constants.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mach_traps.h |   12 +++++++++++-
 arch/x86/kernel/traps.c           |   18 +++++++++---------
 2 files changed, 20 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -7,9 +7,19 @@
 
 #include <asm/mc146818rtc.h>
 
+#define NMI_REASON_PORT		0x61
+
+#define NMI_REASON_MEMPAR	0x80
+#define NMI_REASON_IOCHK	0x40
+#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
+
+#define NMI_REASON_CLEAR_MEMPAR	0x04
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
@@ -323,8 +323,8 @@ mem_parity_error(unsigned char reason, s
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
 	/* Clear and disable the memory parity error line. */
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
+	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_MEMPAR;
+	outb(reason, NMI_REASON_PORT);
 }
 
 static notrace __kprobes void
@@ -339,15 +339,15 @@ io_check_error(unsigned char reason, str
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
@@ -388,7 +388,7 @@ static notrace __kprobes void default_do
 	if (!cpu)
 		reason = get_nmi_reason();
 
-	if (!(reason & 0xc0)) {
+	if (!(reason & NMI_REASON_MASK)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
@@ -418,9 +418,9 @@ static notrace __kprobes void default_do
 		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & 0x80)
+	if (reason & NMI_REASON_MEMPAR)
 		mem_parity_error(reason, regs);
-	if (reason & 0x40)
+	if (reason & NMI_REASON_IOCHK)
 		io_check_error(reason, regs);
 #ifdef CONFIG_X86_32
 	/*
