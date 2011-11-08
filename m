Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab1KHSff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:35:35 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1KHSeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="133442221"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 8/8] msm: timer: Use clockevents_config_and_register()
Date: Tue,  8 Nov 2011 10:34:10 -0800
Message-Id: <1320777250-23263-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't open code the min/max delta logic. Use the generic
version instead. Also expand the number of bits we can handle
because there isn't anything that says we can't handle all 32
bits.

Before:
 max_delta_ns:   122880426391799
 min_delta_ns:   122070
 mult:           140737
 shift:          32

After:
 max_delta_ns:   131071523464981
 min_delta_ns:   122069
 mult:           70369
 shift:          31

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 3d80fbf..11d0d8f 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -93,7 +93,6 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 static struct clock_event_device msm_clockevent = {
 	.name		= "gp_timer",
 	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 200,
 	.set_next_event	= msm_timer_set_next_event,
 	.set_mode	= msm_timer_set_mode,
@@ -161,18 +160,10 @@ static void __init msm_timer_init(void)
 	writel_relaxed(0, event_base + TIMER_ENABLE);
 	writel_relaxed(0, event_base + TIMER_CLEAR);
 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
-	ce->mult = div_sc(GPT_HZ, NSEC_PER_SEC, ce->shift);
-	/*
-	 * allow at least 10 seconds to notice that the timer
-	 * wrapped
-	 */
-	ce->max_delta_ns = clockevent_delta2ns(0xf0000000, ce);
-	/* 4 gets rounded down to 3 */
-	ce->min_delta_ns = clockevent_delta2ns(4, ce);
 	ce->cpumask = cpumask_of(0);
 
 	ce->irq = INT_GP_TIMER_EXP;
-	clockevents_register_device(ce);
+	clockevents_config_and_register(ce, GPT_HZ, 4, 0xffffffff);
 	if (cpu_is_msm8x60() || cpu_is_msm8960()) {
 		msm_evt.percpu_evt = alloc_percpu(struct clock_event_device *);
 		if (!msm_evt.percpu_evt) {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

