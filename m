Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab0JIGuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 02:50:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:7021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab0JIGt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 02:49:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,307,1283756400"; 
   d="scan'208";a="614941825"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v3 4/6] Make NMI reason io port (0x61) can be processed on any CPU
Date: Sat,  9 Oct 2010 14:49:45 +0800
Message-Id: <1286606987-19879-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original NMI handler, NMI reason io port (0x61) is only processed
on BSP. This makes it impossible to hot-remove BSP. To solve the
issue, a raw spinlock is used to make the port can be processed on any
CPU.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/traps.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -83,6 +83,12 @@ EXPORT_SYMBOL_GPL(used_vectors);
 
 static int ignore_nmis;
 
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
+
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -383,7 +389,6 @@ unknown_nmi_error(unsigned char reason,
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
@@ -400,28 +405,28 @@ static notrace __kprobes void default_do
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
-	cpu = smp_processor_id();
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu) {
-		reason = get_nmi_reason();
-		if (reason & NMI_REASON_MASK) {
-			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			    == NOTIFY_STOP)
-				return;
-			if (reason & NMI_REASON_SERR)
-				pci_serr_error(reason, regs);
-			else if (reason & NMI_REASON_IOCHK)
-				io_check_error(reason, regs);
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
+	if (reason & NMI_REASON_MASK) {
+		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+		    == NOTIFY_STOP)
+			goto unlock_return;
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
 #ifdef CONFIG_X86_32
-			/*
-			 * Reassert NMI in case it became active
-			 * meanwhile as it's edge-triggered:
-			 */
-			reassert_nmi();
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
 #endif
-			return;
-		}
+unlock_return:
+		raw_spin_unlock(&nmi_reason_lock);
+		return;
 	}
+	raw_spin_unlock(&nmi_reason_lock);
 
 	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
