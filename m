Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1AFVTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:19:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1AFVTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:19:39 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
Date: Thu,  6 Jan 2011 16:18:51 -0500
Message-Id: <1294348732-15030-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original NMI handler, NMI reason io port (0x61) is only processed
on BSP.  This makes it impossible to hot-remove BSP.  To solve the
issue, a raw spinlock is used to allow the port to be processed on any
CPU.

Originally-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/traps.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 23f6ac0..613b3d2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL_GPL(used_vectors);
 static int ignore_nmis;
 
 int unknown_nmi_panic;
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -392,7 +397,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
@@ -402,13 +406,12 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
-	cpu = smp_processor_id();
-
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
 
 	if (!(reason & NMI_REASON_MASK)) {
+		raw_spin_unlock(&nmi_reason_lock);
 		unknown_nmi_error(reason, regs);
 
 		return;
@@ -426,6 +429,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 */
 	reassert_nmi();
 #endif
+	raw_spin_unlock(&nmi_reason_lock);
 }
 
 dotraplinkage notrace __kprobes void
-- 
1.7.3.4

