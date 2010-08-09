Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0HITwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:52:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38369 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab0HITwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:52:47 -0400
Subject: Re: [BISECTED/2.6.35+] Regression: Machine runs really slowly
 after commit f12a15be
From: john stultz <johnstul@us.ibm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1281382707.22355.0.camel@mini>
References: <1281186941.23274.5.camel@chi>
	 <1281380498.2444.2.camel@localhost.localdomain>
	 <1281382707.22355.0.camel@mini>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 12:51:58 -0700
Message-ID: <1281383518.2444.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 21:38 +0200, Alexey Fisher wrote:
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> hpet
> 
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> hpet acpi_pm 


On Mon, 2010-08-09 at 22:43 +0300, Priit Laes wrote:
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> hpet
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> hpet acpi_pm 


Ok. Good. Chris Wilson has created the following patch which should
hopefully resolve this issue. It would be great if you could try booting
with it to verify that there are no other problems lurking here.

Thanks again for the great bug reporting!

thanks
-john


From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] x86/hpet: Use the FSEC_PER_SEC constant for femto-second
 periods

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
1.7.1




