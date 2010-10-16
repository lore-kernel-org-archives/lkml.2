Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0JPCXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab0JPCW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:22:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: andi@firstfloor.org, robert.richter@amd.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
Date: Fri, 15 Oct 2010 22:22:17 -0400
Message-Id: <1287195738-3136-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

In original NMI handler, NMI reason io port (0x61) is only processed
on BSP. This makes it impossible to hot-remove BSP. To solve the
issue, a raw spinlock is used to make the port can be processed on any
CPU.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/traps.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d8acab3..accb2f4 100644
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
@@ -383,7 +389,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
@@ -400,28 +405,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
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
-- 
1.7.2.3

