Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3AHXhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:37 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53657 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592Ab3AHXhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>, Zhouping Liu <zliu@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 04/77] time: Move ktime_t overflow checking into timespec_valid_strict
Date: Tue, 8 Jan 2013 18:34:43 -0500
Message-ID: <1357688156-25387-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/time.h      | 7 +++++++
 kernel/time/timekeeping.c | 6 +++---
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
index bbdad71..21cd75b 100644
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
1.7.12.1

