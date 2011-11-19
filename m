Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1KSLXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:23:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab1KSLXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:23:07 -0500
Date: Sat, 19 Nov 2011 03:22:54 -0800
From: tip-bot for Jeff Ohlstein <johlstei@codeaurora.org>
Message-ID: <tip-27c9cd7e601632b3794e1c3344d37b86917ffb43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johlstei@codeaurora.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johlstei@codeaurora.org, tglx@linutronix.de
In-Reply-To: <1321660030-8520-1-git-send-email-johlstei@codeaurora.org>
References: <1321660030-8520-1-git-send-email-johlstei@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Fix extra wakeups from __remove_hrtimer()
Git-Commit-ID: 27c9cd7e601632b3794e1c3344d37b86917ffb43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 19 Nov 2011 03:23:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27c9cd7e601632b3794e1c3344d37b86917ffb43
Gitweb:     http://git.kernel.org/tip/27c9cd7e601632b3794e1c3344d37b86917ffb43
Author:     Jeff Ohlstein <johlstei@codeaurora.org>
AuthorDate: Fri, 18 Nov 2011 15:47:10 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 19 Nov 2011 12:17:37 +0100

hrtimer: Fix extra wakeups from __remove_hrtimer()

__remove_hrtimer() attempts to reprogram the clockevent device when
the timer being removed is the next to expire. However,
__remove_hrtimer() reprograms the clockevent *before* removing the
timer from the timerqueue and thus when hrtimer_force_reprogram()
finds the next timer to expire it finds the timer we're trying to
remove.

This is especially noticeable when the system switches to NOHz mode
and the system tick is removed. The timer tick is removed from the
system but the clockevent is programmed to wakeup in another HZ
anyway.

Silence the extra wakeup by removing the timer from the timerqueue
before calling hrtimer_force_reprogram() so that we actually program
the clockevent for the next timer to expire.

This was broken by 998adc3 "hrtimers: Convert hrtimers to use
timerlist infrastructure".

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1321660030-8520-1-git-send-email-johlstei@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..2043c08 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -885,10 +885,13 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
+	struct timerqueue_node *next_timer;
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	if (&timer->node == timerqueue_getnext(&base->active)) {
+	next_timer = timerqueue_getnext(&base->active);
+	timerqueue_del(&base->active, &timer->node);
+	if (&timer->node == next_timer) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
 		if (reprogram && hrtimer_hres_active()) {
@@ -901,7 +904,6 @@ static void __remove_hrtimer(struct hrtimer *timer,
 		}
 #endif
 	}
-	timerqueue_del(&base->active, &timer->node);
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
