Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab2I1TFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:05:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab2I1TFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhouping Liu <zliu@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 232/262] time: Move ktime_t overflow checking into timespec_valid_strict
Date: Fri, 28 Sep 2012 11:52:41 -0700
Message-Id: <20120928183025.667675494@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit cee58483cf56e0ba355fdd97ff5e8925329aa936 upstream.

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
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/time.h      |    7 +++++++
 kernel/time/timekeeping.c |   10 +++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -125,6 +125,13 @@ static inline bool timespec_valid(const
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
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -384,7 +384,7 @@ int do_settimeofday(const struct timespe
 	struct timespec ts_delta;
 	unsigned long flags;
 
-	if (!timespec_valid(tv))
+	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
@@ -429,7 +429,7 @@ int timekeeping_inject_offset(struct tim
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
@@ -665,7 +665,7 @@ static void update_sleep_time(struct tim
  */
 static void __timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	if (!timespec_valid(delta)) {
+	if (!timespec_valid_strict(delta)) {
 		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
 					"sleep delta value!\n");
 		return;


