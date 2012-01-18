Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2ARAZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:25:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2ARAZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:25:39 -0500
Date: Tue, 17 Jan 2012 16:25:26 -0800
From: tip-bot for Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <tip-68f30fbee19cc67849b9fa8e153ede70758afe81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
In-Reply-To: <1326843337.5291.4.camel@sbsiddha-mobl2>
References: <1326843337.5291.4.camel@sbsiddha-mobl2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, tsc:
  Fix SMI induced variation in quick_pit_calibrate()
Git-Commit-ID: 68f30fbee19cc67849b9fa8e153ede70758afe81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 16:25:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68f30fbee19cc67849b9fa8e153ede70758afe81
Gitweb:     http://git.kernel.org/tip/68f30fbee19cc67849b9fa8e153ede70758afe81
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Tue, 17 Jan 2012 15:35:37 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 17 Jan 2012 15:46:51 -0800

x86, tsc: Fix SMI induced variation in quick_pit_calibrate()

pit_expect_msb() returns success wrongly in the below SMI scenario:

a. pit_verify_msb() has not yet seen the MSB transition.

b. we are close to the MSB transition though and got a SMI immediately after
   returning from pit_verify_msb() which didn't see the MSB transition. PIT MSB
   transition has happened somewhere during SMI execution.

c. returned from SMI and we noted down the 'tsc', saw the pit MSB change now and
   exited the loop to calculate 'deltatsc'. Instead of noting the TSC at the MSB
   transition, we are way off because of the SMI.  And as the SMI happened
   between the pit_verify_msb() and before the 'tsc' is recorded in the
   for loop, 'delattsc' (d1/d2 in quick_pit_calibrate()) will be small and
   quick_pit_calibrate() will not notice this error.

Depending on whether SMI disturbance happens while computing d1 or d2, we will
see the TSC calibrated value smaller or bigger than the expected value. As a
result, in a cluster we were seeing a variation of approximately +/- 20MHz in
the calibrated values, resulting in NTP failures.

  [ As far as the SMI source is concerned, this is a periodic SMI that gets
    disabled after ACPI is enabled by the OS. But the TSC calibration happens
    before the ACPI is enabled. ]

To address this, change pit_expect_msb() so that

 - the 'tsc' is the TSC in between the two reads that read the MSB
change from the PIT (same as before)

 - the 'delta' is the difference in TSC from *before* the MSB changed
to *after* the MSB changed.

Now the delta is twice as big as before (it covers four PIT accesses,
roughly 4us) and quick_pit_calibrate() will loop a bit longer to get
the calibrated value with in the 500ppm precision. As the delta (d1/d2)
covers four PIT accesses, actual calibrated result might be closer to
250ppm precision.

As the loop now takes longer to stabilize, double MAX_QUICK_PIT_MS to 50.

SMI disturbance will showup as much larger delta's and the loop will take
longer than usual for the result to be with in the accepted precision. Or will
fallback to slow PIT calibration if it takes more than 50msec.

Also while we are at this, remove the calibration correction that aims to
get the result to the middle of the error bars. We really don't know which
direction to correct into, so remove it.

Reported-and-tested-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1326843337.5291.4.camel@sbsiddha-mobl2
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/tsc.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 2c9cf0f..f546946 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -290,14 +290,15 @@ static inline int pit_verify_msb(unsigned char val)
 static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
 {
 	int count;
-	u64 tsc = 0;
+	u64 tsc = 0, prev_tsc = 0;
 
 	for (count = 0; count < 50000; count++) {
 		if (!pit_verify_msb(val))
 			break;
+		prev_tsc = tsc;
 		tsc = get_cycles();
 	}
-	*deltap = get_cycles() - tsc;
+	*deltap = get_cycles() - prev_tsc;
 	*tscp = tsc;
 
 	/*
@@ -311,9 +312,9 @@ static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *de
  * How many MSB values do we want to see? We aim for
  * a maximum error rate of 500ppm (in practice the
  * real error is much smaller), but refuse to spend
- * more than 25ms on it.
+ * more than 50ms on it.
  */
-#define MAX_QUICK_PIT_MS 25
+#define MAX_QUICK_PIT_MS 50
 #define MAX_QUICK_PIT_ITERATIONS (MAX_QUICK_PIT_MS * PIT_TICK_RATE / 1000 / 256)
 
 static unsigned long quick_pit_calibrate(void)
@@ -383,15 +384,12 @@ success:
 	 *
 	 * As a result, we can depend on there not being
 	 * any odd delays anywhere, and the TSC reads are
-	 * reliable (within the error). We also adjust the
-	 * delta to the middle of the error bars, just
-	 * because it looks nicer.
+	 * reliable (within the error).
 	 *
 	 * kHz = ticks / time-in-seconds / 1000;
 	 * kHz = (t2 - t1) / (I * 256 / PIT_TICK_RATE) / 1000
 	 * kHz = ((t2 - t1) * PIT_TICK_RATE) / (I * 256 * 1000)
 	 */
-	delta += (long)(d2 - d1)/2;
 	delta *= PIT_TICK_RATE;
 	do_div(delta, i*256*1000);
 	printk("Fast TSC calibration using PIT\n");
