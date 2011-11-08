Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab1KHSfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:35:50 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab1KHSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133442214"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 7/8] msm: timer: Setup interrupt after registering clockevent
Date: Tue,  8 Nov 2011 10:34:09 -0800
Message-Id: <1320777250-23263-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bootloaders may leave a pending interrupt for the timer and
thus msm_timer_interrupt() has a check for a NULL event handler.
Unmask and register for the interrupt after registering the
clockevent so that we can get the NULL pointer check out of the
fast path.
 
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index ca0a957..3d80fbf 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -47,8 +47,6 @@ static void __iomem *event_base;
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
-	if (evt->event_handler == NULL)
-		return IRQ_HANDLED;
 	/* Stop the timer tick */
 	if (evt->mode == CLOCK_EVT_MODE_ONESHOT) {
 		u32 ctrl = readl_relaxed(event_base + TIMER_ENABLE);
@@ -174,6 +172,7 @@ static void __init msm_timer_init(void)
 	ce->cpumask = cpumask_of(0);
 
 	ce->irq = INT_GP_TIMER_EXP;
+	clockevents_register_device(ce);
 	if (cpu_is_msm8x60() || cpu_is_msm8960()) {
 		msm_evt.percpu_evt = alloc_percpu(struct clock_event_device *);
 		if (!msm_evt.percpu_evt) {
@@ -194,7 +193,6 @@ static void __init msm_timer_init(void)
 
 	if (res)
 		pr_err("request_irq failed for %s\n", ce->name);
-	clockevents_register_device(ce);
 err:
 	writel_relaxed(TIMER_ENABLE_EN, source_base + TIMER_ENABLE);
 	res = clocksource_register_hz(cs, dgt_hz);
@@ -224,8 +222,8 @@ int __cpuinit local_timer_setup(struct clock_event_device *evt)
 	evt->min_delta_ns = clockevent_delta2ns(4, evt);
 
 	*__this_cpu_ptr(msm_evt.percpu_evt) = evt;
-	enable_percpu_irq(evt->irq, 0);
 	clockevents_register_device(evt);
+	enable_percpu_irq(evt->irq, 0);
 	return 0;
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

