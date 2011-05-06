Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1EFVlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:41:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:43903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab1EFVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="919049149"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Mason <chris.mason@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] Move C3 stop test outside lock
Date: Fri,  6 May 2011 14:40:53 -0700
Message-Id: <1304718056-20206-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
References: <1304718056-20206-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Avoid taking locks in the idle path for systems where the timer
doesn't stop in C3.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/time/tick-broadcast.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index da800ff..2fc424d 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -456,23 +456,22 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	unsigned long flags;
 	int cpu;
 
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		goto out;
+		return;
 
-	bc = tick_broadcast_device.evtdev;
 	cpu = smp_processor_id();
+	bc = tick_broadcast_device.evtdev;
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		goto out;
+		return;
 
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
@@ -489,8 +488,6 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 				tick_program_event(dev->next_event, 1);
 		}
 	}
-
-out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-- 
1.7.4.4

