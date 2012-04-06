Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2DFLfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:35:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2DFLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:35:06 -0400
Date: Fri, 6 Apr 2012 04:34:43 -0700
From: tip-bot for Neal Cardwell <ncardwell@google.com>
Message-ID: <tip-6f103929f8979d2638e58d7f7fda0beefcb8ee7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, ncardwell@google.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, ncardwell@google.com,
        bsegall@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1332875377-23014-1-git-send-email-ncardwell@google.com>
References: <1332875377-23014-1-git-send-email-ncardwell@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] nohz:
  Fix stale jiffies update in tick_nohz_restart()
Git-Commit-ID: 6f103929f8979d2638e58d7f7fda0beefcb8ee7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Apr 2012 04:34:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f103929f8979d2638e58d7f7fda0beefcb8ee7e
Gitweb:     http://git.kernel.org/tip/6f103929f8979d2638e58d7f7fda0beefcb8ee7e
Author:     Neal Cardwell <ncardwell@google.com>
AuthorDate: Tue, 27 Mar 2012 15:09:37 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 6 Apr 2012 13:24:17 +0200

nohz: Fix stale jiffies update in tick_nohz_restart()

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
Cc: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1332875377-23014-1-git-send-email-ncardwell@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
