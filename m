Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2DIWjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:39:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:61628 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042Ab2DIWjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:39:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="87098094"
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Date: Mon, 09 Apr 2012 15:41:44 -0700
In-Reply-To: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 11:33 +0530, Santosh Shilimkar wrote:
> Commit 77b0d60{clockevents: Leave the broadcast device in shutdown mode
> when not needed} was intended to leave the broadcast device in shutdown mode
> when the per-cpu clockevent devices are always running.
> 
> This breaks the systems where per cpu clock events stop in low power states.
> 
> Hence revert 77b0d60 and implement the same requirement with use
> of C3STOP feature flag.

Problem you encountered is not related to leaving the broadcast device
in shutdown mode. Problem is that we didn't track the mode change to
oneshot and later during idle entry/exit, when we request the broadcast
device services using CLOCK_EVT_NOTIFY_BROADCAST_ENTER etc,
tick_broadcast_oneshot_control() returns with out doing much as it
thinks broadcast device is in periodic mode.

Can you please check if the appended patch fixes the issue? I could
reproduce the issue on my NHM platform which doesn't have always running
apic timer and with the appended fix, all is well with cpu's going into
tickless idle etc. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: clockevents: track broadcast device mode change in tick_broadcast_switch_to_oneshot()

In the commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799,
"clockevents: Leave the broadcast device in shutdown mode when not needed",
we were bailing out too quickly in tick_broadcast_switch_to_oneshot(),
with out tracking the broadcast device mode change to 'TICKDEV_MODE_ONESHOT'.

This breaks the platforms which need broadcast device oneshot services during
deep idle states. tick_broadcast_oneshot_control() thinks that it is
in periodic mode and fails to take proper decisions based on the
CLOCK_EVT_NOTIFY_BROADCAST_[ENTER, EXIT] notifications during deep
idle entry/exit.

Fix this by tracking the broadcast device mode as 'TICKDEV_MODE_ONESHOT',
before leaving the broadcast HW device in shutdown mode if there are no active
requests for the moment.

Reported-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/time/tick-broadcast.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index e883f57..bf57abd 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,10 +575,12 @@ void tick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
+
 	if (cpumask_empty(tick_get_broadcast_mask()))
 		goto end;
 
-	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);


