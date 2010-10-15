Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0JOQ1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:27:38 -0400
Received: from www.tglx.de ([62.245.132.106]:49456 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0JOQ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:27:36 -0400
Date: Fri, 15 Oct 2010 18:27:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT Pull] Timer fix for 36-rc8
Message-ID: <alpine.LFD.2.00.1010151808060.2496@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-urgent

Thanks,

	tglx

------------------>
Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()


 kernel/hrtimer.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1decafb..72206cf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -931,6 +931,7 @@ static inline int
 remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
+		unsigned long state;
 		int reprogram;
 
 		/*
@@ -944,8 +945,13 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
-		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
-				 reprogram);
+		/*
+		 * We must preserve the CALLBACK state flag here,
+		 * otherwise we could move the timer base in
+		 * switch_hrtimer_base.
+		 */
+		state = timer->state & HRTIMER_STATE_CALLBACK;
+		__remove_hrtimer(timer, base, state, reprogram);
 		return 1;
 	}
 	return 0;
@@ -1231,6 +1237,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
 		enqueue_hrtimer(timer, base);
 	}
+
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
+
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
