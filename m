Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0HIVUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:20:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44500 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab0HIVUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:20:39 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs
Date: Mon,  9 Aug 2010 14:20:09 -0700
Message-Id: <1281388810-25806-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1281388810-25806-1-git-send-email-johnstul@us.ibm.com>
References: <1281388810-25806-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

The tv_nsec is a long and when added to the shifted interval it can wrap
and become negative which later causes looping problems in the
getrawmonotonic().  The edge case occurs when the system has slept for
a short period of time of ~2 seconds.

A trace printk of the values in this patch illustrate the problem:

ftrace time stamp: log
43.716079: logarithmic_accumulation: raw: 3d0913 tv_nsec d687faa
43.718513: logarithmic_accumulation: raw: 3d0913 tv_nsec da588bd
43.722161: logarithmic_accumulation: raw: 3d0913 tv_nsec de291d0
46.349925: logarithmic_accumulation: raw: 7a122600 tv_nsec e1f9ae3
46.349930: logarithmic_accumulation: raw: 1e848980 tv_nsec 8831c0e3

The kernel starts looping at 46.349925 in the getrawmonotonic() due to
the negative value from adding the raw value to tv_nsec.

A simple solution is to accumulate into a u64, and then normalize it
to a timespec_t.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Reworked variable names and sipmlified some of the code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

CC: Thomas Gleixner <tglx@linutronix.de>
CC: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time/timekeeping.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e14c839..e960d82 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -690,6 +690,7 @@ static void timekeeping_adjust(s64 offset)
 static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
 	if (offset < timekeeper.cycle_interval<<shift)
@@ -706,12 +707,14 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		second_overflow();
 	}
 
-	/* Accumulate into raw time */
-	raw_time.tv_nsec += timekeeper.raw_interval << shift;;
-	while (raw_time.tv_nsec >= NSEC_PER_SEC) {
-		raw_time.tv_nsec -= NSEC_PER_SEC;
+	/* Accumulate raw time */
+	raw_nsecs = timekeeper.raw_interval << shift;
+	raw_nsecs += raw_time.tv_nsec;
+	while (raw_nsecs >= NSEC_PER_SEC) {
+		raw_nsecs -= NSEC_PER_SEC;
 		raw_time.tv_sec++;
 	}
+	raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-- 
1.6.0.4

