Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0LTWVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:21:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1415 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab0LTWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:20:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67407005"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv4 4/4] msm: timer: Migrate to timer based __delay()
Date: Mon, 20 Dec 2010 14:20:33 -0800
Message-Id: <1292883633-19553-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to provide a dummy set_mode for the DGT since we don't
want it to ever turn off.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This is more of an illustration patch. This code needs to be
fixed to always leave clocksources running.

 arch/arm/mach-msm/include/mach/timex.h |    1 +
 arch/arm/mach-msm/timer.c              |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/timex.h b/arch/arm/mach-msm/include/mach/timex.h
index a62e6b2..52b602b 100644
--- a/arch/arm/mach-msm/include/mach/timex.h
+++ b/arch/arm/mach-msm/include/mach/timex.h
@@ -17,5 +17,6 @@
 #define __ASM_ARCH_MSM_TIMEX_H
 
 #define CLOCK_TICK_RATE		1000000
+#define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 950100f..9da4908 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -84,6 +84,12 @@ static cycle_t msm_dgt_read(struct clocksource *cs)
 	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
 }
 
+int read_current_timer(unsigned long *timer_val)
+{
+	*timer_val = readl(MSM_DGT_BASE + TIMER_COUNT_VAL);
+	return 0;
+}
+
 static int msm_timer_set_next_event(unsigned long cycles,
 				    struct clock_event_device *evt)
 {
@@ -122,6 +128,12 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 	}
 }
 
+static void msm_timer_set_mode_nop(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	/* The timer is always ticking so do nothing */
+}
+
 static struct msm_clock msm_clocks[] = {
 	{
 		.clockevent = {
@@ -157,7 +169,7 @@ static struct msm_clock msm_clocks[] = {
 			.shift          = 32 + MSM_DGT_SHIFT,
 			.rating         = 300,
 			.set_next_event = msm_timer_set_next_event,
-			.set_mode       = msm_timer_set_mode,
+			.set_mode       = msm_timer_set_mode_nop,
 		},
 		.clocksource = {
 			.name           = "dg_timer",
@@ -218,6 +230,8 @@ static void __init msm_timer_init(void)
 
 		clockevents_register_device(ce);
 	}
+	writel(TIMER_ENABLE_EN, MSM_DGT_BASE + TIMER_ENABLE);
+	set_delay_fn(read_current_timer_delay_loop);
 }
 
 struct sys_timer msm_timer = {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

