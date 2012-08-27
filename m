Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2H0VSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:18:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56025 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2H0VSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:18:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="227730827"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        shinya.kuribayashi.px@renesas.com
Subject: [PATCH] ARM: MSM: Implement read_current_timer for msm timers
Date: Mon, 27 Aug 2012 14:18:39 -0700
Message-Id: <1346102319-24497-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.70.g851f7e6
In-Reply-To: <1345817604-9004-2-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the same timer used as the clocksource to be used as the
read_current_timer implementation. This allows us to support a
stable udelay implementation on MSMs where it's possible for the
CPUs to scale speeds independently of one another.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I have some patches to send that add DT support to the MSM timer that
this conflicts with slightly. I'm not too concerned though, but we may
want to decide what tree this goes through when I send out those patches.

 arch/arm/mach-msm/timer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 81280825..1997ab1 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -25,6 +25,7 @@
 #include <asm/hardware/gic.h>
 #include <asm/localtimer.h>
 #include <asm/sched_clock.h>
+#include <asm/delay.h>
 
 #include <mach/msm_iomap.h>
 #include <mach/cpu.h>
@@ -172,6 +173,16 @@ static notrace u32 msm_sched_clock_read(void)
 	return msm_clocksource.read(&msm_clocksource);
 }
 
+static int msm_read_current_timer(unsigned long *timer_val)
+{
+	*timer_val = msm_clocksource.read(&msm_clocksource);
+	return 0;
+}
+
+static struct delay_timer msm_delay_timer = {
+	.read_current_timer = msm_read_current_timer,
+};
+
 static void __init msm_timer_init(void)
 {
 	struct clock_event_device *ce = &msm_clockevent;
@@ -240,6 +251,8 @@ err:
 		pr_err("clocksource_register failed\n");
 	setup_sched_clock(msm_sched_clock_read,
 			cpu_is_msm7x01() ? 32 - MSM_DGT_SHIFT : 32, dgt_hz);
+	msm_delay_timer.freq = dgt_hz;
+	register_current_timer_delay(&msm_delay_timer);
 }
 
 struct sys_timer msm_timer = {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

