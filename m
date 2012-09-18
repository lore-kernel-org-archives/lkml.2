Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2IRBjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:39:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40942 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab2IRBi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:38:58 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Zhouping Liu <zliu@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] 2.6.34.y: time: Move ktime_t overflow checking into timespec_valid_strict
Date: Mon, 17 Sep 2012 21:38:47 -0400
Message-Id: <1347932327-33192-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
References: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091801-9360-0000-0000-00000AC2EC6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a -stable backport of cee58483cf56e0ba355fdd97ff5e8925329aa936

Andreas Bombe reported that the added ktime_t overflow checking added to
timespec_valid in commit 4e8b14526ca7 ("time: Improve sanity checking of
timekeeping inputs") was causing problems with X.org because it caused
timeouts larger then KTIME_T to be invalid.

Previously, these large timeouts would be clamped to KTIME_MAX and would
never expire, which is valid.

This patch splits the ktime_t overflow checking into a new
timespec_valid_strict function, and converts the timekeeping codes
internal checking to use this more strict function.

Reported-and-tested-by: Andreas Bombe <aeb@debian.org>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h      |    7 +++++++
 kernel/time/timekeeping.c |    6 +++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 146b6f3..bc93987 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,6 +109,13 @@ static inline bool timespec_valid(const struct timespec *ts)
 	/* Can't have more nanoseconds then a second */
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return false;
+	return true;
+}
+
+static inline bool timespec_valid_strict(const struct timespec *ts)
+{
+	if (!timespec_valid(ts))
+		return false;
 	/* Disallow values that could overflow ktime_t */
 	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
 		return false;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index bbdad71a..21cd75b 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -343,7 +343,7 @@ int do_settimeofday(struct timespec *tv)
 	struct timespec ts_delta;
 	unsigned long flags;
 
-	if (!timespec_valid(tv))
+	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
@@ -559,7 +559,7 @@ void __init timekeeping_init(void)
 	struct timespec now, boot;
 
 	read_persistent_clock(&now);
-	if (!timespec_valid(&now)) {
+	if (!timespec_valid_strict(&now)) {
 		printk("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
@@ -567,7 +567,7 @@ void __init timekeeping_init(void)
 	}
 
 	read_boot_clock(&boot);
-	if (!timespec_valid(&boot)) {
+	if (!timespec_valid_strict(&boot)) {
 		printk("WARNING: Boot clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		boot.tv_sec = 0;
-- 
1.7.9.5

