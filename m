Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2HaRnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:43:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58748 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2HaRnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:43:50 -0400
Message-ID: <5040F7CE.6030505@us.ibm.com>
Date: Fri, 31 Aug 2012 10:43:42 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Andreas Bombe <aeb@debian.org>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
References: <20120831040500.GA6090@amos.fritz.box>
In-Reply-To: <20120831040500.GA6090@amos.fritz.box>
Content-Type: multipart/mixed;
 boundary="------------030007030303030100030500"
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083117-3534-0000-0000-00000C152A96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030007030303030100030500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/30/2012 09:05 PM, Andreas Bombe wrote:
> I have recently started to get problems with X simply shutting itself
> down and returning to the login screen. In the X logs I find:
>
>> [  1492.936]
>> Fatal server error:
>> [  1492.936] WaitForSomething(): select: Invalid argument
> No messages whatsoever is found in the kernel logs. This error happens
> randomly without any correlation to user input, but with a high
> likelihood (within a few minutes at most) when a video is playing. It
> doesn't matter if the video is in Flash in a browser window or in a
> video player playing a local file.
>
> With that somewhat easy test I bisected it down to 4e8b14526 "time:
> Improve sanity checking of timekeeping inputs". The latest Linus git
> (155e36d40) with a revert of the bisected commit does not show the
> problem.
>
> Video is Radeon HD 6950 with open source drivers. Xorg version is the
> one currently in Debian unstable (xserver-xorg-core: 2:1.12.3.902-1,
>   xserver-xorg-video-radeon: 1:6.14.4-5, libdrm: 2.4.33-3).

Thanks so much for bisecting this down!
I'm guessing X is passing crazy large timespecs into select (via 
WaitForSomething()) values that are catching on the ktime_t overflow 
check in timespec_valid(). Previously these would be clamped to 
KTIME_MAX (which basically is infinity) in the timer subsystem before.

So the issue is the patch in question is too strict in its validation. 
We want to be strict on things like timekeeping inputs, but for timers 
wait to infinity is still valid.

The attached (sorry not inline, on the road) patch should fix this, but 
could you verify it? (I'm running my testing concurrently)

Linus: The issue the patch in question addresses has only been reported 
from trinity stress testing and a system with a crazy CMOS clock value, 
so I'm ok with the revert if you'd prefer that.

thanks
-john

--------------030007030303030100030500
Content-Type: text/x-patch;
 name="0001-time-Move-ktime_t-overflow-checking-into-timespec_va.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-time-Move-ktime_t-overflow-checking-into-timespec_va.pa";
 filename*1="tch"

>From a71cdf72cbd10ae5ef6b061db7ab3019293933a4 Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Fri, 31 Aug 2012 13:30:06 -0400
Subject: [PATCH] time: Move ktime_t overflow checking into
 timespec_valid_strict

Andreas Bombe reported that the added ktime_t overflow
checking added to timespec_valid in commit 4e8b14526
was causing problems with X.org because it caused
timeouts larger then KTIME_T to be invalid.

Previously, these large timeouts would be clamped
to KTIME_MAX and would never expire, which is valid.

This patch splits the ktime_t overflow checking into
a new timespec_valid_strict function, and converts
the timekeeping code's checking to use this more
strict function.

Cc: Andreas Bombe <aeb@debian.org>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Reported-by: Andreas Bombe <aeb@debian.org>
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
index 0c1485e..34e5eac 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -428,7 +428,7 @@ int do_settimeofday(const struct timespec *tv)
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
-	if (!timespec_valid(tv))
+	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&tk->lock, flags);
@@ -476,7 +476,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	/* Make sure the proposed value is valid */
 	tmp = timespec_add(tk_xtime(tk),  *ts);
-	if (!timespec_valid(&tmp)) {
+	if (!timespec_valid_strict(&tmp)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -659,7 +659,7 @@ void __init timekeeping_init(void)
 	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
-	if (!timespec_valid(&now)) {
+	if (!timespec_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
@@ -667,7 +667,7 @@ void __init timekeeping_init(void)
 	}
 
 	read_boot_clock(&boot);
-	if (!timespec_valid(&boot)) {
+	if (!timespec_valid_strict(&boot)) {
 		pr_warn("WARNING: Boot clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		boot.tv_sec = 0;
@@ -713,7 +713,7 @@ static struct timespec timekeeping_suspend_time;
 static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 							struct timespec *delta)
 {
-	if (!timespec_valid(delta)) {
+	if (!timespec_valid_strict(delta)) {
 		printk(KERN_WARNING "__timekeeping_inject_sleeptime: Invalid "
 					"sleep delta value!\n");
 		return;
-- 
1.7.9.5


--------------030007030303030100030500--

