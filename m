Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0HHM7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:59:35 -0400
Received: from server109-228-4-14.live-servers.net ([109.228.4.14]:51696 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959Ab0HHM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:59:33 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86/hpet: Use the FSEC_PER_SEC constant for femto-second periods
Date: Sun,  8 Aug 2010 13:58:31 +0100
Message-Id: <1281272311-13820-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current computation, introduced with f12a15be63, of FSEC_PER_SEC using
the multiplication of (FSEC_PER_NSEC * NSEC_PER_SEC) is performed only
with 32bit integers on small machines, resulting in an overflow and a
*very* short intervals being programmed.  An interrupt storm follows.

Note that we also have to specify FSEC_PER_SEC as being long long to
overcome the same limitations.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Stultz <johnstul@us.ibm.com>
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
1.7.1

