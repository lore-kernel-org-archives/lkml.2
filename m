Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2BVBjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:39:43 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43367 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2BVBjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:39:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6627"; a="162855576"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH] msm: timer: Support sched_clock()
Date: Tue, 21 Feb 2012 17:39:37 -0800
Message-Id: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.1.265.gb3a76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that sched_clock is mandatory on ARM it's simple to add
sched_clock support to the MSM timer code. Add it so that we get
more accurate sched_clock output than the jiffies based version
that's provided by default.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: David Brown <davidb@codeaurora.org>
---

This is based on Marc's mandatory sched_clock patch series
located at

 git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git sched_clock-v3.3-rc3

 arch/arm/mach-msm/timer.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 11d0d8f..61983da 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -24,6 +24,7 @@
 #include <asm/mach/time.h>
 #include <asm/hardware/gic.h>
 #include <asm/localtimer.h>
+#include <asm/sched_clock.h>
 
 #include <mach/msm_iomap.h>
 #include <mach/cpu.h>
@@ -105,12 +106,12 @@ static union {
 
 static void __iomem *source_base;
 
-static cycle_t msm_read_timer_count(struct clocksource *cs)
+static notrace cycle_t msm_read_timer_count(struct clocksource *cs)
 {
 	return readl_relaxed(source_base + TIMER_COUNT_VAL);
 }
 
-static cycle_t msm_read_timer_count_shift(struct clocksource *cs)
+static notrace cycle_t msm_read_timer_count_shift(struct clocksource *cs)
 {
 	/*
 	 * Shift timer count down by a constant due to unreliable lower bits
@@ -127,6 +128,11 @@ static struct clocksource msm_clocksource = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+static notrace u32 msm_sched_clock_read(void)
+{
+	return msm_clocksource.read(&msm_clocksource);
+}
+
 static void __init msm_timer_init(void)
 {
 	struct clock_event_device *ce = &msm_clockevent;
@@ -189,6 +195,8 @@ err:
 	res = clocksource_register_hz(cs, dgt_hz);
 	if (res)
 		pr_err("clocksource_register failed\n");
+	setup_sched_clock(msm_sched_clock_read,
+			cpu_is_msm7x01() ? 32 - MSM_DGT_SHIFT : 32, dgt_hz);
 }
 
 #ifdef CONFIG_LOCAL_TIMERS
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

