Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab0HEM2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:28:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:39881 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0HEM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:28:52 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs
Date: Thu,  5 Aug 2010 07:28:32 -0500
Message-Id: <1281011312-23499-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 05 Aug 2010 12:28:38.0534 (UTC) FILETIME=[BB305A60:01CB3499]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tv_nsec is a long and when added to the shift value it can wrap
and become negative which later causes looping problems in the
getrawmonotonic().  The edge case occurs when the system has slept for
a short period of time of ~2 seconds.

A trace printk of the values in this patch illustrate the problem:

ftrace time stamp: log
43.716079: logarithmic_accumulation: raw_shift: 3d0913 tv_nsec d687faa
43.718513: logarithmic_accumulation: raw_shift: 3d0913 tv_nsec da588bd
43.722161: logarithmic_accumulation: raw_shift: 3d0913 tv_nsec de291d0
46.349925: logarithmic_accumulation: raw_shift: 7a122600 tv_nsec e1f9ae3
46.349930: logarithmic_accumulation: raw_shift: 1e848980 tv_nsec 8831c0e3

The kernel starts looping at 46.349925 in the getrawmonotonic() due to
the negative value from adding the raw_shift to tv_nsec.

A simple solution is to process the raw_shift separately from the
tv_nsec using the same type of loop in logarithmic_accumulation().

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: H. Peter Anvin <hpa@zytor.com>
---
 kernel/time/timekeeping.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..1762282 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -736,6 +736,7 @@ static void timekeeping_adjust(s64 offset)
 static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 raw_shift;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
 	if (offset < timekeeper.cycle_interval<<shift)
@@ -753,7 +754,12 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	}
 
 	/* Accumulate into raw time */
-	raw_time.tv_nsec += timekeeper.raw_interval << shift;;
+	raw_shift = timekeeper.raw_interval << shift;
+	while (raw_shift >= NSEC_PER_SEC) {
+		raw_shift -= NSEC_PER_SEC;
+		raw_time.tv_sec++;
+	}
+	raw_time.tv_nsec += raw_shift;
 	while (raw_time.tv_nsec >= NSEC_PER_SEC) {
 		raw_time.tv_nsec -= NSEC_PER_SEC;
 		raw_time.tv_sec++;
-- 
1.6.3.3

