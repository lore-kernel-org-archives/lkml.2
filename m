Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab0HXXD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:29 -0400
Received: from kroah.org ([198.145.64.141]:41289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab0HXXDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:09 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:08 2010
Message-Id: <20100824224508.185133706@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [080/114] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit archs
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit deda2e81961e96be4f2c09328baca4710a2fd1a0 upstream.

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
 [ Reworked variable names and simplified some of the code. - John ]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -736,6 +736,7 @@ static void timekeeping_adjust(s64 offse
 static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
+	u64 raw_nsecs;
 
 	/* If the offset is smaller then a shifted interval, do nothing */
 	if (offset < timekeeper.cycle_interval<<shift)
@@ -752,12 +753,14 @@ static cycle_t logarithmic_accumulation(
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


