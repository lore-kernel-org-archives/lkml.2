Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1FTOYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:24:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57106 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1FTOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:24:00 -0400
Date: Mon, 20 Jun 2011 15:23:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620142338.GL2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com> <20110620111336.GG2082@n2100.arm.linux.org.uk> <4DFF2E37.8030602@ti.com> <20110620114019.GH2082@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620114019.GH2082@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:40:19PM +0100, Russell King - ARM Linux wrote:
> Ok.  So loops_per_jiffy must be too small.  My guess is you're using an
> older kernel without 71c696b1 (calibrate: extract fall-back calculation
> into own helper).

Right, this commit above helps show the problem - and it's fairly subtle.

It's a race condition.  Let's first look at the spinlock debugging code.
It does this:

static void __spin_lock_debug(raw_spinlock_t *lock)
{
        u64 i;
        u64 loops = loops_per_jiffy * HZ;

        for (;;) {
                for (i = 0; i < loops; i++) {
                        if (arch_spin_trylock(&lock->raw_lock))
                                return;
                        __delay(1);
                }
		/* print warning */
	}
}

If loops_per_jiffy is zero, we never try to grab the spinlock, because
we never enter the inner for loop.  We immediately print a warning,
and re-execute the outer loop for ever, resulting in the CPU locking up
in this condition.

In theory, we should never see a zero loops_per_jiffy value, because it
represents the number of loops __delay() needs to delay by one jiffy and
clearly zero makes no sense.

However, calibrate_delay() does this (which x86 and ARM call on secondary
CPU startup):

calibrate_delay()
{
...
	if (preset_lpj) {
	} else if ((!printed) && lpj_fine) {
	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
	} else {
		/* approximation/convergence stuff */
	}
}

Now, before 71c696b, this used to be:

        } else {
                loops_per_jiffy = (1<<12);

So the window between calibrate_delay_direct() returning and setting
loops_per_jiffy to zero, and the re-initialization of loops_per_jiffy
was relatively short (maybe even the compiler optimized away the zero
write.)

However, after 71c696b, this now does:

        } else {
                if (!printed)
                        pr_info("Calibrating delay loop... ");
+               loops_per_jiffy = calibrate_delay_converge();

So, as loops_per_jiffy is not local to this function, the compiler has
to write out that zero value, before calling calibrate_delay_converge(),
and loops_per_jiffy only becomes non-zero _after_ calibrate_delay_converge()
has returned.  This opens the window and allows the spinlock debugging
code to explode.

This patch closes the window completely, by only writing to loops_per_jiffy
only when we have a real value for it.

This allows me to boot 3.0.0-rc3 on Versatile Express (4 CPU) whereas
without this it fails with spinlock lockup and rcu problems.

 init/calibrate.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 2568d22..aae2f40 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -245,30 +245,32 @@ static unsigned long __cpuinit calibrate_delay_converge(void)
 
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
