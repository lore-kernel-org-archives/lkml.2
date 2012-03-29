Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab2C3W62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:58:28 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934891Ab2C3VFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:36 -0400
Message-Id: <201203302105.q2UL54KG006285@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:23:54 -0400
Subject: [PATCH] arch/tile: improve trap handling a bit
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0366 (UTC) FILETIME=[C74658E0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now respond to MEM_ERROR traps (e.g. an atomic instruction to
non-cacheable memory) with a SIGBUS.

We also no longer generate a console crash message if a user
process die due to a SIGTRAP.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_64.S |    2 +-
 arch/tile/kernel/traps.c     |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 709e224..6a1ea82 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1186,7 +1186,7 @@ STD_ENTRY(fill_ra_stack)
 #define do_hardwall_trap bad_intr
 #endif
 
-	int_hand     INT_MEM_ERROR, MEM_ERROR, bad_intr
+	int_hand     INT_MEM_ERROR, MEM_ERROR, do_trap
 	int_hand     INT_SINGLE_STEP_3, SINGLE_STEP_3, bad_intr
 #if CONFIG_KERNEL_PL == 2
 	int_hand     INT_SINGLE_STEP_2, SINGLE_STEP_2, gx_singlestep_handle
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 1e91fda..4c33057 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -199,7 +199,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 {
 	siginfo_t info = { 0 };
 	int signo, code;
-	unsigned long address;
+	unsigned long address = 0;
 	bundle_bits instr;
 
 	/* Re-enable interrupts. */
@@ -222,6 +222,10 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	}
 
 	switch (fault_num) {
+	case INT_MEM_ERROR:
+		signo = SIGBUS;
+		code = BUS_OBJERR;
+		break;
 	case INT_ILL:
 		if (copy_from_user(&instr, (void __user *)regs->pc,
 				   sizeof(instr))) {
@@ -311,7 +315,8 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	info.si_addr = (void __user *)address;
 	if (signo == SIGILL)
 		info.si_trapno = fault_num;
-	trace_unhandled_signal("trap", regs, address, signo);
+	if (signo != SIGTRAP)
+		trace_unhandled_signal("trap", regs, address, signo);
 	force_sig_info(signo, &info, current);
 }
 
-- 
1.6.5.2

