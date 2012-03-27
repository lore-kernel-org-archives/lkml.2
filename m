Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2C0TJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:09:59 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54429 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2C0TJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:09:55 -0400
From: Neal Cardwell <ncardwell@google.com>
To: linux-kernel@vger.kernel.org
Cc: Neal Cardwell <ncardwell@google.com>, Ben Segall <bsegall@google.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] nohz: fix stale jiffies update in tick_nohz_restart()
Date: Tue, 27 Mar 2012 15:09:37 -0400
Message-Id: <1332875377-23014-1-git-send-email-ncardwell@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix tick_nohz_restart() to not use a stale ktime_t "now" value when
calling tick_do_update_jiffies64(now).

If we reach this point in the loop it means that we crossed a tick
boundary since we grabbed the "now" timestamp, so at this point "now"
refers to a time in the old jiffy, so using the old value for "now" is
incorrect, and is likely to give us a stale jiffies value.

In particular, the first time through the loop the
tick_do_update_jiffies64(now) call is always a no-op, since the
caller, tick_nohz_restart_sched_tick(), will have already called
tick_do_update_jiffies64(now) with that "now" value.

Note that tick_nohz_stop_sched_tick() already uses the correct
approach: when we notice we cross a jiffy boundary, grab a new
timestamp with ktime_get(), and *then* update jiffies.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3526038..6a3a5b9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -534,9 +534,9 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 				hrtimer_get_expires(&ts->sched_timer), 0))
 				break;
 		}
-		/* Update jiffies and reread time */
-		tick_do_update_jiffies64(now);
+		/* Reread time and update jiffies */
 		now = ktime_get();
+		tick_do_update_jiffies64(now);
 	}
 }
 
-- 
1.7.7.3

