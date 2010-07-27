Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0G0Kq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:46:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:35336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0Kq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:46:27 -0400
Date: Tue, 27 Jul 2010 10:46:11 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] time: Implement timespec_add
Message-ID: <tip-ce3bf7ab22527183634a76512d9854a38615e4d5@git.kernel.org>
Git-Commit-ID: ce3bf7ab22527183634a76512d9854a38615e4d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:46:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce3bf7ab22527183634a76512d9854a38615e4d5
Gitweb:     http://git.kernel.org/tip/ce3bf7ab22527183634a76512d9854a38615e4d5
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:19 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:53 +0200

time: Implement timespec_add

After accidentally misusing timespec_add_safe, I wanted to make sure
we don't accidently trip over that issue again, so I created a simple
timespec_add() function which we can use to replace the instances
of timespec_add_safe() that don't want the overflow detection.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/time.h      |   16 ++++++++++++++++
 kernel/time/timekeeping.c |    6 +++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f0..9072df8 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -76,9 +76,25 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
+
+/*
+ * timespec_add_safe assumes both values are positive and checks
+ * for overflow. It will return TIME_T_MAX if the reutrn would be
+ * smaller then either of the arguments.
+ */
 extern struct timespec timespec_add_safe(const struct timespec lhs,
 					 const struct timespec rhs);
 
+
+static inline struct timespec timespec_add(struct timespec lhs,
+						struct timespec rhs)
+{
+	struct timespec ts_delta;
+	set_normalized_timespec(&ts_delta, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+	return ts_delta;
+}
+
 /*
  * sub = lhs - rhs, in normalized form
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..623fe3d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -579,9 +579,9 @@ static int timekeeping_resume(struct sys_device *dev)
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
-		xtime = timespec_add_safe(xtime, ts);
+		xtime = timespec_add(xtime, ts);
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
-		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
+		total_sleep_time = timespec_add(total_sleep_time, ts);
 	}
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
@@ -887,7 +887,7 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	*ts = timespec_add_safe(*ts, total_sleep_time);
+	*ts = timespec_add(*ts, total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
