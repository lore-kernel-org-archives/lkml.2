Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0E1JHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:07:24 -0400
Received: from www.tglx.de ([62.245.132.106]:42598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab0E1JHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:07:21 -0400
Date: Fri, 28 May 2010 11:07:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes for 2.6.35-rc1
Message-ID: <alpine.LFD.2.00.1005281106120.3116@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Andrey Vagin (1):
      posix_timer: Fix error path in timer_create

Stanislaw Gruszka (1):
      hrtimer: Avoid double seqlock

Thomas Gleixner (2):
      timers: Fix slack calculation really
      timers: Move local variable into else section


 kernel/hrtimer.c      |    2 +-
 kernel/posix-timers.c |   11 ++++-------
 kernel/timer.c        |   10 +++++++---
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b9b134b..5c69e99 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -89,7 +89,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xts = current_kernel_time();
+		xts = __current_kernel_time();
 		tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 00d1fda..ad72342 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -559,14 +559,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_id = (timer_t) new_timer_id;
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
-	if (error)
-		goto out;
 
-	/*
-	 * return the timer_id now.  The next step is hard to
-	 * back out if there is an error.
-	 */
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
@@ -597,6 +590,10 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	if (error)
+		goto out;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
diff --git a/kernel/timer.c b/kernel/timer.c
index be394af..2211834 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -752,11 +752,15 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 
 	expires_limit = expires;
 
-	if (timer->slack > -1)
+	if (timer->slack >= 0) {
 		expires_limit = expires + timer->slack;
-	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
-		expires_limit = expires + (expires - jiffies)/256;
+	} else {
+		unsigned long now = jiffies;
 
+		/* No slack, if already expired else auto slack 0.4% */
+		if (time_after(expires, now))
+			expires_limit = expires + (expires - now)/256;
+	}
 	mask = expires ^ expires_limit;
 	if (mask == 0)
 		return expires;
