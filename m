Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2DRMIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:08:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:08:11 -0400
Date: Wed, 18 Apr 2012 05:07:26 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, svenjoac@gmx.de, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        svenjoac@gmx.de, tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <alpine.LFD.2.02.1204181205540.2542@ionos>
References: <alpine.LFD.2.02.1204181205540.2542@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
Git-Commit-ID: b435092f70ec5ebbfb6d075d5bf3c631b49a51de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 05:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b435092f70ec5ebbfb6d075d5bf3c631b49a51de
Gitweb:     http://git.kernel.org/tip/b435092f70ec5ebbfb6d075d5bf3c631b49a51de
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 18 Apr 2012 12:08:23 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Apr 2012 14:00:56 +0200

tick: Fix oneshot broadcast setup really

Sven Joachim reported, that suspend/resume on rc3 trips over a NULL
pointer dereference. Linus spotted the clockevent handler being NULL.

commit fa4da365b(clockevents: tTack broadcast device mode change in
tick_broadcast_switch_to_oneshot()) tried to fix a problem with the
broadcast device setup, which was introduced in commit 77b0d60c5(
clockevents: Leave the broadcast device in shutdown mode when not
needed).

The initial commit avoided to set up the broadcast device when no
broadcast request bits were set, but that left the broadcast device
disfunctional. In consequence deep idle states which need the
broadcast device were not woken up.

commit fa4da365b tried to fix that by initializing the state of the
broadcast facility, but that missed the fact, that nothing initializes
the event handler and some other state of the underlying clock event
device.

The fix is to revert both commits and make only the mode setting of
the clock event device conditional on the state of active broadcast
users. 

That initializes everything except the low level device mode, but this
happens when the broadcast functionality is invoked by deep idle.

Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204181205540.2542@ionos

---
 kernel/time/tick-broadcast.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..119aca5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -531,7 +531,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 		/* Take the do_timer update */
 		tick_do_timer_cpu = cpu;
@@ -549,6 +548,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   to_cpumask(tmpmask));
 
 		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
@@ -577,15 +577,10 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
-
-	if (cpumask_empty(tick_get_broadcast_mask()))
-		goto end;
-
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
 
-end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
