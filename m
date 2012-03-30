Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606Ab2C3WsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:48:24 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41969 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935037Ab2C3VGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:25 -0400
Message-Id: <201203302105.q2UL5AuJ006312@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:24:41 -0400
Subject: [PATCH] arch/tile: return SIGBUS for addresses that are unaligned AND invalid
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:10.0725 (UTC) FILETIME=[CB10A750:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we were returning SIGSEGV in this case.  It seems cleaner
to return SIGBUS since the hardware figures out alignment traps
before TLB violations, so SIGBUS is the "more correct" signal.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/single_step.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index b231ef4..36ccd37 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -152,6 +152,25 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 	if (((unsigned long)addr % size) == 0)
 		return bundle;
 
+	/*
+	 * Return SIGBUS with the unaligned address, if requested.
+	 * Note that we return SIGBUS even for completely invalid addresses
+	 * as long as they are in fact unaligned; this matches what the
+	 * tilepro hardware would be doing, if it could provide us with the
+	 * actual bad address in an SPR, which it doesn't.
+	 */
+	if (unaligned_fixup == 0) {
+		siginfo_t info = {
+			.si_signo = SIGBUS,
+			.si_code = BUS_ADRALN,
+			.si_addr = addr
+		};
+		trace_unhandled_signal("unaligned trap", regs,
+				       (unsigned long)addr, SIGBUS);
+		force_sig_info(info.si_signo, &info, current);
+		return (tilepro_bundle_bits) 0;
+	}
+
 	/* Handle unaligned load/store */
 	if (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) {
 		unsigned short val_16;
@@ -199,18 +218,6 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 		return (tile_bundle_bits) 0;
 	}
 
-	if (unaligned_fixup == 0) {
-		siginfo_t info = {
-			.si_signo = SIGBUS,
-			.si_code = BUS_ADRALN,
-			.si_addr = addr
-		};
-		trace_unhandled_signal("unaligned trap", regs,
-				       (unsigned long)addr, SIGBUS);
-		force_sig_info(info.si_signo, &info, current);
-		return (tile_bundle_bits) 0;
-	}
-
 	if (unaligned_printk || unaligned_fixup_count == 0) {
 		pr_info("Process %d/%s: PC %#lx: Fixup of"
 			" unaligned %s at %#lx.\n",
-- 
1.6.5.2

