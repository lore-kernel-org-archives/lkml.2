Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1I2O73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1I2O72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:59:28 -0400
From: Matthew Garrett <mjg@redhat.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] hrtimers: Special-case zero length sleeps
Date: Thu, 29 Sep 2011 10:59:32 -0400
Message-Id: <1317308372-6810-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep(0) is a common construct used by applications that want to trigger
the scheduler. sched_yield() might make more sense, but only appeared in
POSIX.1-2001 and so plenty of example code still uses the sleep(0) form.
This wouldn't normally be a problem, but it means that event-driven
applications that are merely trying to avoid starving other processes may
actually end up sleeping due to having large timer_slack values. Special-
casing this seems reasonable.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 kernel/hrtimer.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..0bb70a7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1566,6 +1566,14 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	if (rt_task(current))
 		slack = 0;
 
+	/*
+	 * Applications will often sleep(0) to indicate that they wish to
+	 * be scheduled. Special case that to avoid actually putting them
+	 * to sleep for the duration of the slack.
+	 */
+	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
+		slack = 0;
+
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
 	if (do_nanosleep(&t, mode))
-- 
1.7.6.4

