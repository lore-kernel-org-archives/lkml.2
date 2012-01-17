Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2AQSMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2AQSMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:12:54 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH] Fix c-state transitions when !NOHZ (nohz=off kernel parameter)
Date: Tue, 17 Jan 2012 13:12:48 -0500
Message-Id: <1326823968-3482-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users do still boot with "nohz=off" which re-enables the old "tickfull"
kernel and still want the (diminished) power savings of c-states.

When examining the c-state transitions for !NOHZ it was noticed that the
processors never leaving the polling state.

ie) powertop shows 98-99% residency in POLLING for all cpus

This occurs  because the value of the current tick_sched's sleep_length
is never updated from its initialized value if !NOHZ.  sleep_length is used
by the cpuidle code (via a call to tick_nohz_get_sleep_length()) to determine
how long a cpu should sleep for and in what c-state.

Admittedly I am not overly familiar with this code and there may be some
unknown repercussion from doing this.  I can say that experimentally across
several systems I do see the cpus going into deeper c-states after making
this change, and there does not appear to be anything wrong with the system.

----8<----

Fix c-state transitions when !NOHZ (nohz=off kernel parameter)

The value of sleep_length needs to be updated for the !NOHZ case in
order for processor c-state transitions to work.

Cc: Len Brown <len.brown@intel.com>
---
 kernel/time/tick-sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..d2e2782 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -300,8 +300,10 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = ktime_sub(dev->next_event, now);
 		return;
+	}
 
 	if (need_resched())
 		return;
-- 
1.7.1

