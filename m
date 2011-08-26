Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HZWcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:32:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:58342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab1HZWcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:32:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,286,1312182000"; 
   d="scan'208";a="42896290"
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] tick-broadcast: push down tick_broadcast_lock
Date: Fri, 26 Aug 2011 15:32:04 -0700
Message-Id: <1314397924-10236-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314397924-10236-1-git-send-email-andi@firstfloor.org>
References: <1314397924-10236-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For the oneshot case, only take the tick_broadcast_lock when the
global device is actually changing. For the case when the new
event is only setting the wakeup to a later time than it already
is we don't need the lock.

This avoids lock contention for some special cases on systems
that don't have an always running per cpu timer. It's not a full
solution to the scalability problem there unfortunately, just
the first step.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/time/tick-broadcast.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7f33b15..1576da7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -485,23 +485,33 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	bc = tick_broadcast_device.evtdev;
 
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!__get_cpu_var(state).need_oneshot) {
 			__get_cpu_var(state).need_oneshot = 1;
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
+		       
+			/* Only take the lock if the events gets set earlier */
+			if (dev->next_event.tv64 < bc->next_event.tv64) {
+				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 				tick_broadcast_set_event(dev->next_event, 1);
+				raw_spin_unlock_irqrestore(&tick_broadcast_lock, 
+							   flags);		
+			}
 		}
 	} else {
 		if (__get_cpu_var(state).need_oneshot) {
 			__get_cpu_var(state).need_oneshot = 0;
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 != KTIME_MAX)
+
+			/* Only take the lock if the event changes */
+			if (dev->next_event.tv64 != KTIME_MAX) {
+				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 				tick_program_event(dev->next_event, 1);
+				raw_spin_unlock_irqrestore(&tick_broadcast_lock, 
+							   flags);
+			}
 		}
 	}
-	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
 /*
-- 
1.7.4.4

