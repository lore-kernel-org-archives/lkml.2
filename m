Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2AQXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:36:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:63631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2AQXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="97609808"
Subject: Re: [patch] x86, tsc: fix SMI induced variation in
 quick_pit_calibrate()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
In-Reply-To: <CA+55aFxjzr3qugZdfsPGPw8RooTCzTr4XQubcqjvF=t+GLHE0Q@mail.gmail.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFys9zddHAoKURGAeu0QYD_MC11uEyOQGU_4Ybsf200NkQ@mail.gmail.com>
	 <1326760869.16150.16.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFzGN59W5zhmc-kicQrpomAKLiwX4yBUsNcagwmM=Z8jxw@mail.gmail.com>
	 <CA+55aFwuwPXatwdJqeW_e_7w_rBELL8HTHqq0FLDiE+xmPm5XQ@mail.gmail.com>
	 <1326773165.16150.35.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFxjzr3qugZdfsPGPw8RooTCzTr4XQubcqjvF=t+GLHE0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Tue, 17 Jan 2012 15:35:37 -0800
Message-ID: <1326843337.5291.4.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 21:15 -0800, Linus Torvalds wrote:
> So let's just double MAX_QUICK_PIT_MS to 50, ok?
> 

Ok. Here is the patch with the changelog. x86 folks, can you please
apply it?

Thanks.
---
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: x86, tsc: fix SMI induced variation in quick_pit_calibrate()

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


