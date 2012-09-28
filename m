Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422681Ab2I1UAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:00:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab2I1Szw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 044/262] ARM: 7496/1: hw_breakpoint: dont rely on dfsr to show watchpoint access type
Date: Fri, 28 Sep 2012 11:49:33 -0700
Message-Id: <20120928183003.172779624@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit bf8801145c01ab600f8df66e8c879ac642fa5846 upstream.

>From ARM debug architecture v7.1 onwards, a watchpoint exception causes
the DFAR to be updated with the faulting data address. However, DFSR.WnR
takes an UNKNOWN value and therefore cannot be used in general to
determine the access type that triggered the watchpoint.

This patch forbids watchpoints without an overflow handler from
specifying a specific access type (load/store). Those with overflow
handlers must be able to handle false positives potentially triggered by
a watchpoint of a different access type on the same address. For
SIGTRAP-based handlers (i.e. ptrace), this should have no impact.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/hw_breakpoint.c |   55 +++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 15 deletions(-)

--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -159,6 +159,12 @@ static int debug_arch_supported(void)
 		arch >= ARM_DEBUG_ARCH_V7_1;
 }
 
+/* Can we determine the watchpoint access type from the fsr? */
+static int debug_exception_updates_fsr(void)
+{
+	return 0;
+}
+
 /* Determine number of WRP registers available. */
 static int get_num_wrp_resources(void)
 {
@@ -619,18 +625,35 @@ int arch_validate_hwbkpt_settings(struct
 	info->address &= ~alignment_mask;
 	info->ctrl.len <<= offset;
 
-	/*
-	 * Currently we rely on an overflow handler to take
-	 * care of single-stepping the breakpoint when it fires.
-	 * In the case of userspace breakpoints on a core with V7 debug,
-	 * we can use the mismatch feature as a poor-man's hardware
-	 * single-step, but this only works for per-task breakpoints.
-	 */
-	if (!bp->overflow_handler && (arch_check_bp_in_kernelspace(bp) ||
-	    !core_has_mismatch_brps() || !bp->hw.bp_target)) {
-		pr_warning("overflow handler required but none found\n");
-		ret = -EINVAL;
+	if (!bp->overflow_handler) {
+		/*
+		 * Mismatch breakpoints are required for single-stepping
+		 * breakpoints.
+		 */
+		if (!core_has_mismatch_brps())
+			return -EINVAL;
+
+		/* We don't allow mismatch breakpoints in kernel space. */
+		if (arch_check_bp_in_kernelspace(bp))
+			return -EPERM;
+
+		/*
+		 * Per-cpu breakpoints are not supported by our stepping
+		 * mechanism.
+		 */
+		if (!bp->hw.bp_target)
+			return -EINVAL;
+
+		/*
+		 * We only support specific access types if the fsr
+		 * reports them.
+		 */
+		if (!debug_exception_updates_fsr() &&
+		    (info->ctrl.type == ARM_BREAKPOINT_LOAD ||
+		     info->ctrl.type == ARM_BREAKPOINT_STORE))
+			return -EINVAL;
 	}
+
 out:
 	return ret;
 }
@@ -706,10 +729,12 @@ static void watchpoint_handler(unsigned
 				goto unlock;
 
 			/* Check that the access type matches. */
-			access = (fsr & ARM_FSR_ACCESS_MASK) ? HW_BREAKPOINT_W :
-				 HW_BREAKPOINT_R;
-			if (!(access & hw_breakpoint_type(wp)))
-				goto unlock;
+			if (debug_exception_updates_fsr()) {
+				access = (fsr & ARM_FSR_ACCESS_MASK) ?
+					  HW_BREAKPOINT_W : HW_BREAKPOINT_R;
+				if (!(access & hw_breakpoint_type(wp)))
+					goto unlock;
+			}
 
 			/* We have a winner. */
 			info->trigger = addr;


