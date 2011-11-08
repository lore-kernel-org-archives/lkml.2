Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1KHSeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab1KHSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802409"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/8] msm: timer: Fix ONESHOT mode interrupts
Date: Tue,  8 Nov 2011 10:34:06 -0800
Message-Id: <1320777250-23263-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSM timers don't support an interrupt enable/disable bit.
Therefore, when the timer is free running it's possible for the
count to wrap and the match value to match again even though a
set_next_event() call hasn't been made since the last match.

Workaround the lack of an interrupt enable bit by explicitly
stopping the timer in the interrupt handler when the clockevent
is in ONESHOT mode. This should prevent any possibility of the
timer wrapping and matching more than once per set_next_event().

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mach-msm/timer.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 405e8a9..9f3671a 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -81,11 +81,20 @@ enum {
 
 static struct msm_clock msm_clocks[];
 
+static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt);
+
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
 	if (evt->event_handler == NULL)
 		return IRQ_HANDLED;
+	/* Stop the timer tick */
+	if (evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+		struct msm_clock *clock = clockevent_to_clock(evt);
+		u32 ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
+		ctrl &= ~TIMER_ENABLE_EN;
+		writel_relaxed(ctrl, clock->regbase + TIMER_ENABLE);
+	}
 	evt->event_handler(evt);
 	return IRQ_HANDLED;
 }
@@ -118,10 +127,12 @@ static int msm_timer_set_next_event(unsigned long cycles,
 				    struct clock_event_device *evt)
 {
 	struct msm_clock *clock = clockevent_to_clock(evt);
-	uint32_t now = readl(clock->local_counter);
-	uint32_t alarm = now + (cycles << clock->shift);
+	u32 match = cycles << clock->shift;
+	u32 ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
 
-	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
+	writel_relaxed(0, clock->regbase + TIMER_CLEAR);
+	writel_relaxed(match, clock->regbase + TIMER_MATCH_VAL);
+	writel_relaxed(ctrl | TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
 	return 0;
 }
 
@@ -129,19 +140,23 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 			      struct clock_event_device *evt)
 {
 	struct msm_clock *clock = clockevent_to_clock(evt);
+	u32 ctrl;
+
+	ctrl = readl_relaxed(clock->regbase + TIMER_ENABLE);
+	ctrl &= ~(TIMER_ENABLE_EN | TIMER_ENABLE_CLR_ON_MATCH_EN);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_RESUME:
 	case CLOCK_EVT_MODE_PERIODIC:
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		writel(TIMER_ENABLE_EN, clock->regbase + TIMER_ENABLE);
+		/* Timer is enabled in set_next_event */
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		writel(0, clock->regbase + TIMER_ENABLE);
 		break;
 	}
+	writel_relaxed(ctrl, clock->regbase + TIMER_ENABLE);
 }
 
 static struct msm_clock msm_clocks[] = {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

