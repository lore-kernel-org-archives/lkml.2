Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0JPQhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:37:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0JPQh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:37:29 -0400
Date: Sat, 16 Oct 2010 16:37:10 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1287195738-3136-5-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-5-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
Message-ID: <tip-4a45b5a06f61b46e7bce1aaf9331e2dc58704fa5@git.kernel.org>
Git-Commit-ID: 4a45b5a06f61b46e7bce1aaf9331e2dc58704fa5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:37:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a45b5a06f61b46e7bce1aaf9331e2dc58704fa5
Gitweb:     http://git.kernel.org/tip/4a45b5a06f61b46e7bce1aaf9331e2dc58704fa5
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 15 Oct 2010 22:22:17 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 15:01:28 +0200

x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU

In original NMI handler, NMI reason io port (0x61) is only
processed on BSP. This makes it impossible to hot-remove BSP. To
solve the issue, a raw spinlock is used to make the port can be
processed on any CPU.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: robert.richter@amd.com
Cc: peterz@infradead.org
LKML-Reference: <1287195738-3136-5-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
