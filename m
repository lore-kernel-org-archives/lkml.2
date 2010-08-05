Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0HEWRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:17:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39099 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0HEWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:17:35 -0400
Subject: Re: [PATCH] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit
 archs
From: john stultz <johnstul@us.ibm.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1281011312-23499-1-git-send-email-jason.wessel@windriver.com>
References: <1281011312-23499-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 15:17:20 -0700
Message-ID: <1281046640.3405.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 07:28 -0500, Jason Wessel wrote:
> The tv_nsec is a long and when added to the shift value it can wrap
> and become negative which later causes looping problems in the
> getrawmonotonic().  The edge case occurs when the system has slept for
> a short period of time of ~2 seconds.

Ah, good catch!

I reworked some of the variable names to make a little more sense and
simplified the accumulation. Do you mind giving this a test in your
environment that triggered the issue to make sure nothing else slipped
in?

thanks
-john



>From 512349b1f7ab0d9b6dff5e33bf4820a50e79f862 Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Thu, 5 Aug 2010 07:28:32 -0500
Subject: [PATCH] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs

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
index caf8d4d..6603860 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -736,6 +736,7 @@ static void timekeeping_adjust(s64 offset)
 static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
 	if (offset < timekeeper.cycle_interval<<shift)
@@ -752,12 +753,14 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
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



