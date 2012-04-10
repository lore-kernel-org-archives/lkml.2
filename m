Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2DJJtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:49:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2DJJts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:49:48 -0400
Date: Tue, 10 Apr 2012 02:49:36 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-fa4da365bc7772c2cd6d5405bdf151612455f957@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        santosh.shilimkar@ti.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        tglx@linutronix.de
In-Reply-To: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
References: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clockevents:
  tTack broadcast device mode change in tick_broadcast_switch_to_oneshot()
Git-Commit-ID: fa4da365bc7772c2cd6d5405bdf151612455f957
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Apr 2012 02:49:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa4da365bc7772c2cd6d5405bdf151612455f957
Gitweb:     http://git.kernel.org/tip/fa4da365bc7772c2cd6d5405bdf151612455f957
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 9 Apr 2012 15:41:44 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 10 Apr 2012 11:42:07 +0200

clockevents: tTack broadcast device mode change in tick_broadcast_switch_to_oneshot()

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

Reported-and-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
