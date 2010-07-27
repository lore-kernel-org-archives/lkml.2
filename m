Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0G0Ks0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:48:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:34770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0KsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:48:24 -0400
Date: Tue, 27 Jul 2010 10:48:07 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] hrtimer: Cleanup direct access to wall_to_monotonic
Message-ID: <tip-8ab4351a4c888016620f43bde605b3d0964af339@git.kernel.org>
Git-Commit-ID: 8ab4351a4c888016620f43bde605b3d0964af339
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:48:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ab4351a4c888016620f43bde605b3d0964af339
Gitweb:     http://git.kernel.org/tip/8ab4351a4c888016620f43bde605b3d0964af339
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:25 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:55 +0200

hrtimer: Cleanup direct access to wall_to_monotonic

Provides an accessor function to replace hrtimer.c's
direct access of wall_to_monotonic.

This will allow wall_to_monotonic to be made static as
planned in Documentation/feature-removal-schedule.txt

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    3 ++-
 kernel/hrtimer.c          |    9 ++++-----
 kernel/time/timekeeping.c |    5 +++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 9072df8..a57e0f6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -126,7 +126,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
-struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec __current_kernel_time(void); /* does not take xtime_lock */
+struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c69e99..809f48c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -90,7 +90,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		xts = __current_kernel_time();
-		tom = wall_to_monotonic;
+		tom = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
@@ -612,7 +612,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset;
+	struct timespec realtime_offset, wtm;
 	unsigned long seq;
 
 	if (!hrtimer_hres_active())
@@ -620,10 +620,9 @@ static void retrigger_next_event(void *arg)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		set_normalized_timespec(&realtime_offset,
-					-wall_to_monotonic.tv_sec,
-					-wall_to_monotonic.tv_nsec);
+		wtm = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
+	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b15c3ac..fb61c2e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -858,6 +858,11 @@ struct timespec __current_kernel_time(void)
 	return xtime;
 }
 
+struct timespec __get_wall_to_monotonic(void)
+{
+	return wall_to_monotonic;
+}
+
 struct timespec current_kernel_time(void)
 {
 	struct timespec now;
