Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2FFMBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:01:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38004 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2FFMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:01:35 -0400
Date: Wed, 6 Jun 2012 05:01:16 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e40468a54882ef7411fb178dbf2e465ec2349af7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
        gilad@benyossef.com
In-Reply-To: <20120525214819.317535385@linutronix.de>
References: <20120525214819.317535385@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Improve get_next_timer_interrupt()
Git-Commit-ID: e40468a54882ef7411fb178dbf2e465ec2349af7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 05:01:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e40468a54882ef7411fb178dbf2e465ec2349af7
Gitweb:     http://git.kernel.org/tip/e40468a54882ef7411fb178dbf2e465ec2349af7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 25 May 2012 22:08:59 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 6 Jun 2012 13:49:02 +0200

timers: Improve get_next_timer_interrupt()

Gilad reported at

 http://lkml.kernel.org/r/1336056962-10465-2-git-send-email-gilad@benyossef.com

"Current timer code fails to correctly return a value meaning that
 there is no future timer event, with the result that the timer keeps
 getting re-armed in HZ one shot mode even when we could turn it off,
 generating unneeded interrupts.

 What is happening is that when __next_timer_interrupt() wishes
 to return a value that signifies "there is no future timer
 event", it returns (base->timer_jiffies + NEXT_TIMER_MAX_DELTA).

 However, the code in tick_nohz_stop_sched_tick(), which called
 __next_timer_interrupt() via get_next_timer_interrupt(),
 compares the return value to (last_jiffies + NEXT_TIMER_MAX_DELTA)
 to see if the timer needs to be re-armed.

 base->timer_jiffies != last_jiffies and so tick_nohz_stop_sched_tick()
 interperts the return value as indication that there is a distant
 future event 12 days from now and programs the timer to fire next
 after KTIME_MAX nsecs instead of avoiding to arm it. This ends up
 causing a needless interrupt once every KTIME_MAX nsecs."

Fix this by using the new active timer accounting. This avoids scans
when no active timer is enqueued completely, so we don't have to rely
on base->timer_next and base->timer_jiffies anymore.

Reported-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20120525214819.317535385@linutronix.de
---
 kernel/timer.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 7fada69..a61c093 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1326,18 +1326,21 @@ static unsigned long cmp_next_hrtimer_event(unsigned long now,
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
 	struct tvec_base *base = __this_cpu_read(tvec_bases);
-	unsigned long expires;
+	unsigned long expires = now + NEXT_TIMER_MAX_DELTA;
 
 	/*
 	 * Pretend that there is no timer pending if the cpu is offline.
 	 * Possible pending timers will be migrated later to an active cpu.
 	 */
 	if (cpu_is_offline(smp_processor_id()))
-		return now + NEXT_TIMER_MAX_DELTA;
+		return expires;
+
 	spin_lock(&base->lock);
-	if (time_before_eq(base->next_timer, base->timer_jiffies))
-		base->next_timer = __next_timer_interrupt(base);
-	expires = base->next_timer;
+	if (base->active_timers) {
+		if (time_before_eq(base->next_timer, base->timer_jiffies))
+			base->next_timer = __next_timer_interrupt(base);
+		expires = base->next_timer;
+	}
 	spin_unlock(&base->lock);
 
 	if (time_before_eq(expires, now))
