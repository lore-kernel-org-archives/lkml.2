Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2ITQ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:58:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30989 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2ITQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:57:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="236931875"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling monitor mode
Date: Thu, 20 Sep 2012 09:57:40 -0700
Message-Id: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset value of the BCR, BVR, WCR, and WVR registers are all
UNKNOWN on ARMv7. Unfortunately, reset_ctrl_regs() clears these
registers *after* enabling monitor mode, not before, and so some
implementations may experience UNPREDICTABLE behavior if the
reset values of these registers are non-zero. Clear the
breakpoints before enabling monitor mode so that we don't
experience boot hangs/loops due to breakpoints being enabled
out of reset.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/hw_breakpoint.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index ba386bd..9eac571 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -216,6 +216,20 @@ static int get_num_brps(void)
 	return core_has_mismatch_brps() ? brps - 1 : brps;
 }
 
+/* Determine if halting mode is enabled */
+static int halting_mode_enabled(void)
+{
+	u32 dscr;
+
+	ARM_DBG_READ(c1, 0, dscr);
+
+	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
+		"halting debug mode enabled. Unable to access hardware resources.\n")) {
+		return -EPERM;
+	}
+	return 0;
+}
+
 /*
  * In order to access the breakpoint/watchpoint control registers,
  * we must be running in debug monitor mode. Unfortunately, we can
@@ -225,16 +239,13 @@ static int get_num_brps(void)
 static int enable_monitor_mode(void)
 {
 	u32 dscr;
-	int ret = 0;
+	int ret;
 
 	ARM_DBG_READ(c1, 0, dscr);
 
 	/* Ensure that halting mode is disabled. */
-	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
-		"halting debug mode enabled. Unable to access hardware resources.\n")) {
-		ret = -EPERM;
+	if ((ret = halting_mode_enabled()))
 		goto out;
-	}
 
 	/* If monitor mode is already enabled, just return. */
 	if (dscr & ARM_DSCR_MDBGEN)
@@ -935,7 +946,7 @@ static void reset_ctrl_regs(void *unused)
 	isb();
 
 reset_regs:
-	if (enable_monitor_mode())
+	if (halting_mode_enabled())
 		return;
 
 	/* We must also reset any reserved registers. */
@@ -949,6 +960,7 @@ reset_regs:
 		write_wb_reg(ARM_BASE_WCR + i, 0UL);
 		write_wb_reg(ARM_BASE_WVR + i, 0UL);
 	}
+	enable_monitor_mode();
 }
 
 static int __cpuinit dbg_reset_notify(struct notifier_block *self,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

