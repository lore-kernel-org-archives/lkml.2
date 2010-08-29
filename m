Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0H2PGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:06:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44086 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0H2PGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=obpwvHoRfDyrmQ3VM35Er9UzK4cqv3vwQQl/CsshiuWi1f3HIVRUF37+t/18IGT4tJ
         339StCCHnti6BU1UcdwzioaYhVive0eaxF/swM6hTO2CVP5lbWqW8/7bOB9tewjqrNAI
         daK0NW+QTTlC7wJbW4DTiutQVFU6e8EYcnTk8=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 4/6] hrtimer: change call site of timer_stats_hrtimer_clear_start_info()
Date: Sun, 29 Aug 2010 23:05:07 +0800
Message-Id: <1283094309-6635-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Put timer_stats_hrtimer_clear_start_info() to the real cancel
place.

Because remove_hrtimer() is used for internal, and it could be called
as below:
int __hrtimer_start_range_ns(ARG) {
	...
	remove_hrtimer();
	...
	timer_stats_hrtimer_set_start_info();
}

Then if remove_hrtimer() clear the start_site, the following
timer_stats_hrtimer_set_start_info() will record the caller of
__hrtimer_start_range_ns as start_site. But this is not what
we want.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ce66917..2b79ab4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -772,7 +772,7 @@ static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
 #ifdef CONFIG_TIMER_STATS
-	if (likely(!timer_stats_active))
+	if (!timer->start_site)
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
@@ -942,7 +942,6 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 * rare case and less expensive than a smp call.
 		 */
 		debug_deactivate(timer);
-		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
 				 reprogram);
@@ -1055,9 +1054,10 @@ int hrtimer_try_to_cancel(struct hrtimer *timer)
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (!hrtimer_callback_running(timer))
+	if (!hrtimer_callback_running(timer)){
+		timer_stats_hrtimer_clear_start_info(timer);
 		ret = remove_hrtimer(timer, base);
-
+	}
 	unlock_hrtimer_base(timer, &flags);
 
 	return ret;
-- 
1.7.0.4

