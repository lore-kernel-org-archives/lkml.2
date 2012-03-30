Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864Ab2C3Wrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:47:47 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41969 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935052Ab2C3VG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:29 -0400
Message-Id: <201203302105.q2UL5Bb1006315@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:31:08 -0400
Subject: [PATCH] arch/tile: add descriptive text if the kernel reports a bad trap
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:11.0382 (UTC) FILETIME=[CB74E760:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel unexpectedly takes a bad trap, it's convenient to
have it report the type of trap as part of the error.  This gives
customers a bit more context before they call up customer support.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/traps.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 4c33057..871d497 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -194,6 +194,25 @@ static int special_ill(bundle_bits bundle, int *sigp, int *codep)
 	return 1;
 }
 
+static const char *const int_name[] = {
+	[INT_MEM_ERROR] = "Memory error",
+	[INT_ILL] = "Illegal instruction",
+	[INT_GPV] = "General protection violation",
+	[INT_UDN_ACCESS] = "UDN access",
+	[INT_IDN_ACCESS] = "IDN access",
+#if CHIP_HAS_SN()
+	[INT_SN_ACCESS] = "SN access",
+#endif
+	[INT_SWINT_3] = "Software interrupt 3",
+	[INT_SWINT_2] = "Software interrupt 2",
+	[INT_SWINT_0] = "Software interrupt 0",
+	[INT_UNALIGN_DATA] = "Unaligned data",
+	[INT_DOUBLE_FAULT] = "Double fault",
+#ifdef __tilegx__
+	[INT_ILL_TRANS] = "Illegal virtual address",
+#endif
+};
+
 void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		       unsigned long reason)
 {
@@ -210,10 +229,17 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	 * current process and hope for the best.
 	 */
 	if (!user_mode(regs)) {
+		const char *name;
 		if (fixup_exception(regs))  /* only UNALIGN_DATA in practice */
 			return;
-		pr_alert("Kernel took bad trap %d at PC %#lx\n",
-		       fault_num, regs->pc);
+		if (fault_num >= 0 &&
+		    fault_num < sizeof(int_name)/sizeof(int_name[0]) &&
+		    int_name[fault_num] != NULL)
+			name = int_name[fault_num];
+		else
+			name = "Unknown interrupt";
+		pr_alert("Kernel took bad trap %d (%s) at PC %#lx\n",
+			 fault_num, name, regs->pc);
 		if (fault_num == INT_GPV)
 			pr_alert("GPV_REASON is %#lx\n", reason);
 		show_regs(regs);
-- 
1.6.5.2

