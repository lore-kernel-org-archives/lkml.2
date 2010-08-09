Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0HIVU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:20:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58451 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0HIVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:20:25 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] x86/hpet: Use the FSEC_PER_SEC constant for femto-second periods
Date: Mon,  9 Aug 2010 14:20:10 -0700
Message-Id: <1281388810-25806-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1281388810-25806-2-git-send-email-johnstul@us.ibm.com>
References: <1281388810-25806-1-git-send-email-johnstul@us.ibm.com>
 <1281388810-25806-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

The current computation, introduced with f12a15be63, of FSEC_PER_SEC using
the multiplication of (FSEC_PER_NSEC * NSEC_PER_SEC) is performed only
with 32bit integers on small machines, resulting in an overflow and a
*very* short intervals being programmed.  An interrupt storm follows.

Note that we also have to specify FSEC_PER_SEC as being long long to
overcome the same limitations.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c |    4 ++--
 include/linux/time.h   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 33dbcc4..351f9c0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -582,7 +582,7 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	 * scaled math multiplication factor for nanosecond to hpet tick
 	 * conversion.
 	 */
-	hpet_freq = 1000000000000000ULL;
+	hpet_freq = FSEC_PER_SEC;
 	do_div(hpet_freq, hpet_period);
 	evt->mult = div_sc((unsigned long) hpet_freq,
 				      NSEC_PER_SEC, evt->shift);
@@ -837,7 +837,7 @@ static int hpet_clocksource_register(void)
 	 * cyc/sec = FSEC_PER_SEC/hpet_period(fsec/cyc)
 	 * cyc/sec = (FSEC_PER_NSEC * NSEC_PER_SEC)/hpet_period
 	 */
-	hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;
+	hpet_freq = FSEC_PER_SEC;
 	do_div(hpet_freq, hpet_period);
 	clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq);
 
diff --git a/include/linux/time.h b/include/linux/time.h
index cb34e35..1261270 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -38,7 +38,7 @@ extern struct timezone sys_tz;
 #define NSEC_PER_MSEC	1000000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
-#define FSEC_PER_SEC	1000000000000000L
+#define FSEC_PER_SEC	1000000000000000LL
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
-- 
1.6.0.4

