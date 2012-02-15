Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2BOTh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:37:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2BOThy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:37:54 -0500
Date: Wed, 15 Feb 2012 11:36:53 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-77b0d60c5adf39c74039e2142a1d3cd1e4d53799@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1320452301.15071.16.camel@sbsiddha-desk.sc.intel.com>
References: <1320452301.15071.16.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Leave the broadcast device in shutdown mode when not needed
Git-Commit-ID: 77b0d60c5adf39c74039e2142a1d3cd1e4d53799
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Feb 2012 11:37:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77b0d60c5adf39c74039e2142a1d3cd1e4d53799
Gitweb:     http://git.kernel.org/tip/77b0d60c5adf39c74039e2142a1d3cd1e4d53799
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 4 Nov 2011 17:18:21 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Feb 2012 15:23:09 +0100

clockevents: Leave the broadcast device in shutdown mode when not needed

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
Cc: john stultz <johnstul@us.ibm.com>
Cc: venki@google.com
Link: http://lkml.kernel.org/r/1320452301.15071.16.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index fd4a7b1..e883f57 100644
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
 
