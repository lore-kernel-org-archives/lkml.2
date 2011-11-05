Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1KEAPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:15:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:64442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1KEAPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,458,1315206000"; 
   d="scan'208";a="86392530"
Subject: [patch] clockevents: leave the broadcast device in shutdown mode
 when not needed
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        venki@google.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 04 Nov 2011 17:18:21 -0700
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320452301.15071.16.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms with Always Running APIC Timer doesn't use the broadcast timer
but the kernel is leaving the broadcast timer (HPET in this case)
in oneshot mode.

On these platforms, before the switch to oneshot mode, broadcast device is
actually in shutdown mode. Code checks for empty tick_broadcast_mask and
avoids going into the periodic mode.

During switch to oneshot mode, add the same tick_broadcast_mask checks in the
tick_broadcast_switch_to_oneshot() and avoid the broadcast device going into
the oneshot mode.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/time/tick-broadcast.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f954282..73a0ade 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,11 +575,15 @@ void tick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+	if (cpumask_empty(tick_get_broadcast_mask()))
+		goto end;
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
+
+end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 


