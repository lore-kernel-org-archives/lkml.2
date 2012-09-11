Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab2IKS6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:58:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37443 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346Ab2IKS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:58:43 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Zhouping Liu <zliu@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] 3.5.y: time: Move ktime_t overflow checking into timespec_valid_strict
Date: Tue, 11 Sep 2012 14:56:21 -0400
Message-Id: <1347389781-54602-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347389781-54602-1-git-send-email-john.stultz@linaro.org>
References: <1347389781-54602-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091118-5518-0000-0000-000007962E2C
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
 kernel/time/timekeeping.c |   10 +++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index b0bbd8f..b51e664 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -125,6 +125,13 @@ static inline bool timespec_valid(const struct timespec *ts)
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
index df9447b..63c88c1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -384,7 +384,7 @@ int do_settimeofday(const struct timespec *tv)
 	struct timespec ts_delta;
 	unsigned long flags;
 
-	if (!timespec_valid(tv))
+	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
@@ -429,7 +429,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeping_forward_now();
 
 	tmp = timespec_add(timekeeper.xtime,  *ts);
-	if (!timespec_valid(&tmp)) {
+	if (!timespec_valid_strict(&tmp)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -606,7 +606,7 @@ void __init timekeeping_init(void)
 	struct timespec now, boot;
 
 	read_persistent_clock(&now);
-	if (!timespec_valid(&now)) {
+	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
@@ -614,7 +614,7 @@ void __init timekeeping_init(void)
 	}
 
 	read_boot_clock(&boot);
-	if (!timespec_valid(&boot)) {
+	if (!timespec_valid_strict(&boot)) {
 		pr_warn("WARNING: Boot clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		boot.tv_sec = 0;
@@ -665,7 +665,7 @@ static void update_sleep_time(struct timespec t)
  */
 static void __timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	if (!timespec_valid(delta)) {
+	if (!timespec_valid_strict(delta)) {
 		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
 					"sleep delta value!\n");
 		return;
-- 
1.7.9.5

