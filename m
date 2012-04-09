Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2DIGEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:04:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33966 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2DIGE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:04:29 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tglx@linutronix.de>
CC: <suresh.b.siddha@intel.com>, <linux-kernel@vger.kernel.org>,
        <johnstul@us.ibm.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH] clockevents: Leave broadcast device shtudown only if the current device is always running.
Date: Mon, 9 Apr 2012 11:33:43 +0530
Message-ID: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77b0d60{clockevents: Leave the broadcast device in shutdown mode
when not needed} was intended to leave the broadcast device in shutdown mode
when the per-cpu clockevent devices are always running.

This breaks the systems where per cpu clock events stop in low power states.

Hence revert 77b0d60 and implement the same requirement with use
of C3STOP feature flag.

Not-yet-signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
---
The 3.4-rc1 kernel introduced a regression with cpuidle and after debugging it
arrowed down the issue to commit 77b0d60 {clockevents: Leave the broadcast
device in shutdown mode when not needed}.

On OMAP, the percpu clock-events die in the low power states and
hence the broadcast clock-event needs to be active. With 77b0d60 
patch I was seeing that broadcast device was not getting programmed
while entering in low power states and hence system locks up.

I am not completely sure about this fix and the patch is RFC.

 kernel/time/tick-broadcast.c |    4 ----
 kernel/time/tick-oneshot.c   |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index e883f57..fd4a7b1 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,15 +575,11 @@ void ntick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-	if (cpumask_empty(tick_get_broadcast_mask()))
-		goto end;
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
-
-end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 8241090..318ec0c 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -82,7 +82,8 @@ int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-	tick_broadcast_switch_to_oneshot();
+	if (dev->features & CLOCK_EVT_FEAT_C3STOP)
+		tick_broadcast_switch_to_oneshot();
 	return 0;
 }
 
-- 
1.7.5.4

