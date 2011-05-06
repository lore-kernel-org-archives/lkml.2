Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1EFVlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:41:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:45243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab1EFVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="431975481"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <chris.mason@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] Avoid broadcast time lock when not changing the timeout
Date: Fri,  6 May 2011 14:40:56 -0700
Message-Id: <1304718056-20206-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
References: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Don't take the global lock when the new timeout is larger than the
old timeout.

The timeout on the broadcast device should never shrink, so this
is safe to do.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/time/tick-broadcast.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c1587cb..4776742 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -524,6 +524,17 @@ static void set_broadcast_sibling_state(int cpu, int enter)
 	}
 }
 
+static void set_broadcast_timeout(ktime_t to, struct clock_event_device *bc)
+{
+	unsigned long flags;
+
+	if (to.tv64 < bc->next_event.tv64) {
+		raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+		tick_broadcast_set_event(to, 1);
+		raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	}
+}
+
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
@@ -532,7 +543,6 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
-	unsigned long flags;
 	int cpu;
 	ktime_t timeout;
 	
@@ -556,14 +566,12 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 				reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER))
 		return;
 
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!__get_cpu_var(state).need_oneshot) {
 			/* Turn all slaves into oneshots */
 			set_broadcast_sibling_state(cpu, 1);
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (timeout.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(timeout, 1);
+			set_broadcast_timeout(timeout, bc);
 		}
 	} else {
 		if (__get_cpu_var(state).need_oneshot) {
@@ -574,7 +582,6 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 				tick_program_event(dev->next_event, 1);
 		}
 	}
-	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
 /*
-- 
1.7.4.4

