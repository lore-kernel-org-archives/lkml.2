Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1GHFFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307Ab1GHFFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.063446634@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [096/107] Fix CPU spinlock lockups on secondary CPU bringup
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 1b19ca9f0bdab7d5035821e1ec8f39df9a6e3ee0 upstream.

Secondary CPU bringup typically calls calibrate_delay() during its
initialization.  However, calibrate_delay() modifies a global variable
(loops_per_jiffy) used for udelay() and __delay().

A side effect of 71c696b1 ("calibrate: extract fall-back calculation
into own helper") introduced in the 2.6.39 merge window means that we
end up with a substantial period where loops_per_jiffy is zero.  This
causes the spinlock debugging code to malfunction:

	u64 loops = loops_per_jiffy * HZ;
	for (;;) {
		for (i = 0; i < loops; i++) {
			if (arch_spin_trylock(&lock->raw_lock))
				return;
			__delay(1);
		}
		...
	}

by never calling arch_spin_trylock() - resulting in the CPU locking
up in an infinite loop inside __spin_lock_debug().

Work around this by only writing to loops_per_jiffy only once we have
completed all the calibration decisions.

Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
--
Better solutions (such as omitting the calibration for secondary CPUs,
or arranging for calibrate_delay() to return the LPJ value and leave
it to the caller to decide where to store it) are a possibility, but
would be much more invasive into each architecture.

I think this is the best solution for -rc and stable, but it should be
revisited for the next merge window.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/calibrate.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -185,30 +185,32 @@ recalibrate:
 
 void __cpuinit calibrate_delay(void)
 {
+	unsigned long lpj;
 	static bool printed;
 
 	if (preset_lpj) {
-		loops_per_jiffy = preset_lpj;
+		lpj = preset_lpj;
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
 				"preset value.. ");
 	} else if ((!printed) && lpj_fine) {
-		loops_per_jiffy = lpj_fine;
+		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
-	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
+	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
 				"specific routine.. ");
 	} else {
 		if (!printed)
 			pr_info("Calibrating delay loop... ");
-		loops_per_jiffy = calibrate_delay_converge();
+		lpj = calibrate_delay_converge();
 	}
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+			lpj/(500000/HZ),
+			(lpj/(5000/HZ)) % 100, lpj);
 
+	loops_per_jiffy = lpj;
 	printed = true;
 }


