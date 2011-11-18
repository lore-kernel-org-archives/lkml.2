Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1KRXrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:47:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44815 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1KRXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:47:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6534"; a="139092461"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH] hrtimer: Fix extra wakeups from __remove_hrtimer()
Date: Fri, 18 Nov 2011 15:47:10 -0800
Message-Id: <1321660030-8520-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__remove_hrtimer() attempts to reprogram the clockevent device when
the timer being removed is the next to expire. However,
__remove_hrtimer() reprograms the clockevent *before* removing the
timer from the timerqueue and thus when hrtimer_force_reprogram()
finds the next timer to expire it finds the timer we're trying to
remove.

This is especially noticeable when the system switches to NOHz mode
and the system tick is removed. The timer tick is removed from the
system but the clockevent is programmed to wakeup in another HZ
anyway.

Silence the extra wakeup by removing the timer from the timerqueue
before calling hrtimer_force_reprogram() so that we actually program
the clockevent for the next timer to expire.

This was broken by 998adc3 "hrtimers: Convert hrtimers to use
timerlist infrastructure".

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 kernel/hrtimer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 422e567..ae34bf5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -885,10 +885,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
+	struct timerqueue_node *next_timer;
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	if (&timer->node == timerqueue_getnext(&base->active)) {
+	next_timer = timerqueue_getnext(&base->active);
+	timerqueue_del(&base->active, &timer->node);
+	if (&timer->node == next_timer) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
 		if (reprogram && hrtimer_hres_active()) {
@@ -901,7 +904,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	timerqueue_del(&base->active, &timer->node);
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

