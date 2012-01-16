Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2APUJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:09:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:58926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab2APUJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:09:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="107679250"
Subject: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Date: Mon, 16 Jan 2012 12:15:32 -0800
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, We are seeing NTP failures on a big cluster as a result of big
variation in calibrated TSC values. Our debug showed that it is indeed
because of the SMI and its effect on quick pit calibration. Appended
patch helps fix it. It ran over the weekend boot tests with out any
failures.

thanks,
suresh
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, tsc: fix SMI induced variation in quick_pit_calibrate()

pit_expect_msb() returns success wrongly in the below SMI scenario:

a. pit_verify_msb() has not yet seen the MSB transition.

b. We are close to the MSB transition though and got a SMI immediately after
   returning from pit_verify_msb() which didn't see the MSB transition. PIT MSB
   transition has happened somewhere during SMI execution.

c. Returned from SMI and we noted down the 'tsc', saw the pit MSB change now and
   exited the loop to calculate d1/d2. Instead of noting the TSC at the MSB
   transition, we are way off because of the SMI.  And as the SMI happened
   between the pit_verify_msb() and before the 'tsc' is recorded in the
   for loop, d1/d2 will be small and quick_pit_calibrate() will not notice
   this error.

Depending on whether SMI disturbance happens while computing d1 or d2, we will
see the TSC calibrated value smaller or bigger than the expected value. As a
result, in a cluster we were seeing a variation of approximately +/- 20MHz in
the calibrated values, resulting in NTP failures.

  [ As far as the SMI source is concerned, this is a periodic SMI that gets
    disabled after ACPI is enabled by the OS. But the TSC calibration happens
    before the ACPI is enabled. ]

Fix this by comparing the returned delta (that is supposed to capture the MSB
transition and represents d1/d2 in the quick_pit_calibrate()) with
the one before in the for loop. If both of them are similar, then the returned
delta, tsc is captured closer to the MSB transition. Otherwise we will return
failure and fallback to slow PIT calibration.

Any SMI induced disturbance in returned delta (d1/d2) itself is already caught
in our requirements of error has to be less than 500ppm.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/tsc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c0dd5b6..27a1311 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -290,11 +290,12 @@ static inline int pit_verify_msb(unsigned char val)
 static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *deltap)
 {
 	int count;
-	u64 tsc = 0;
+	u64 tsc = 0, tsc_old;
 
 	for (count = 0; count < 50000; count++) {
 		if (!pit_verify_msb(val))
 			break;
+		tsc_old = tsc;
 		tsc = get_cycles();
 	}
 	*deltap = get_cycles() - tsc;
@@ -304,7 +305,7 @@ static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *de
 	 * We require _some_ success, but the quality control
 	 * will be based on the error terms on the TSC values.
 	 */
-	return count > 5;
+	return count > 5 && (tsc - tsc_old <= 2 * (*deltap));
 }
 
 /*


