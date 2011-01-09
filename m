Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1AIRIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:08:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50734 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1AIRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:08:39 -0500
Date: Sun, 9 Jan 2011 17:08:29 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Subject: Bug: loops_per_jiffy based udelay() mostly shorter than requested
Message-ID: <20110109170829.GA14252@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking at the ARM implementation of udelay(), as Moore's Law
may bite us in maybe the next six or so months.  In doing so, I've been
comparing udelay() candidates against our replacement sched_clock()
implementation, which on the platform I've been using has a resolution of
about 41ns.

However, I'm having a hard time making it satisfy the requirement that
"udelay() must produce a delay of at least the requested duration."  It
appears that it mostly produces a delay less than requested, particularly
if IRQs are off or for delays shorter than the jiffy interval (up to a
point).  At the bottom of this message are the measured udelay() values
for a range of delays from 1us to 5ms.

It seems that loops_per_jiffy is being a little optimistic.  The causes
seem to be:

1. the calibration loop in init/calibrate.c runs a successive
   approximation on the value.  This is biased towards producing a
   shorter delay than one jiffy, as the last bit tested will be cleared
   if __delay(loops_per_jiffy) produced a delay longer than one jiffy.

   Eg, if on the penultimate iteration, loopbit = 0x800, and
   __delay(0x7f800) produced a longer than desired duration, we clear
   this bit and try the next bit: loopbit = 0x400, __delay(0x7f400).
   If this produces a delay longer than the duration, we exit with
   loops_per_jiffy = 0x7f000 - and __delay(0x7f000) will produce a
   delay shorter than one jiffy.  Otherwise, the delay was still
   shorter and we exit with loops_per_jiffy leaving the bit set -
   so again __delay(0x7f400) was shorter than one jiffy.

2. as a consequence of how this algorithm works, what we're actually
   measuring is the time taken for __delay(loops_per_jiffy) plus the
   overhead of one timer IRQ.  So we end up with a loops_per_jiffy which
   produces a delay equivalent to
	(usec_per_jiffy - timer_interrupt_usec)

The error we're talking about is around .7% towards delays being "too
short" on the ARM926 test platform.  To get correct results, I need (eg)
a lpj value to be increased from 521216 (0x7F400) to 5000000 / 4964033
* 521216 = 524993 (0x802C1).

For udelay(us), we - just like many architectures - calculate the number
of loops using the formula:

	loops = us * loops_per_jiffy * HZ / 1000000

and we fall short on 'loops' - so that a requested 5ms delay becomes a
4.96ms delay.  This error is also reflected as a %age in shorter delays
too, until about 2us delays where we finally produce delays longer than
requested due to the overheads in calculating the loops value.

Given the difference in values (0x7F400 vs 0x802C1) (1) doesn't really
come into it as the dominant error is from (2) - in this case, 0x7f800
was measured as too long so cleared, and the last trial of 0x7f400 was
measured as too short.

Obviously, we can't run the calibration with IRQs off, otherwise jiffies
won't increment and the calibration algorithm locks up.  We also may not
have sched_clock() initialized at this point either (it may also be
jiffy based), so we can't use that.

Any suggestions or thoughts, or should we not care too much if udelay()
produces slightly shorter than desired delays?  Or am I doing something
horribly wrong in the ARM code?


== results and code ===
Measured delays against sched_lock() counter running at 24MHz (41ns
resolution) with IRQs off, and with the patch below applied to ARM to
eliminate lost precision in the udelay conversion:

Calibrating delay loop... 104.24 BogoMIPS (lpj=521216)
udelay(1) = 1516ns
udelay(2) = 2424ns
udelay(5) = 5116ns
udelay(10) = 10091ns
udelay(20) = 20099ns
udelay(50) = 49766ns
udelay(100) = 99474ns
udelay(200) = 198674ns
udelay(500) = 496524ns
udelay(1000) = 992916ns
udelay(2000) = 1985766ns
udelay(5000) = 4964033ns

With loops_per_jiffy forced to 524993 (based on measured shortfall and
current lpj):
udelay(1) = 1166ns
udelay(2) = 2232ns
udelay(5) = 5141ns
udelay(10) = 10166ns
udelay(20) = 20250ns
udelay(50) = 50208ns
udelay(100) = 100232ns
udelay(200) = 200241ns
udelay(500) = 500424ns
udelay(1000) = 1000733ns
udelay(2000) = 2001391ns
udelay(5000) = 5003041ns

This was produced by:

static int __init test_udelay(void)
{
	unsigned long long sc1, sc2, sd0, sd;
	unsigned long delay, dm, d[3] = {1, 2, 5};
	int i, j;

	local_irq_disable();
	sc1 = sched_clock();
	sc2 = sched_clock();
	sd0 = sc2 - sc1;	/* eliminate sched_clock() overhead */

	for (dm = 1; dm < 10000; dm *= 10) {
		for (j = 0; j < 3; j++) {
			delay = dm * d[j];
			for (sd = 0, i = 0; i < 5; i++) {
				sc1 = sched_clock();
				udelay(delay);
				sc2 = sched_clock();
				sd += sc2 - sc1 - sd0;
			}
			printk("udelay(%lu) = %luns\n", delay,
				(unsigned long)sd / 5);
		}
	}
	local_irq_enable();
	return 0;
}
subsys_initcall(test_udelay).

=== patch to fix loss of precision in calculating 'loops' ===
This affects only udelay() itself.  The function used to calibrate lpj
(__delay()) uses the result of this calculation and is independent of
this error.

diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
index 8d6a876..3c9a05c 100644
--- a/arch/arm/lib/delay.S
+++ b/arch/arm/lib/delay.S
@@ -25,11 +25,15 @@ ENTRY(__udelay)
 		ldr	r2, .LC1
 		mul	r0, r2, r0
 ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
+		mov	r1, #-1
 		ldr	r2, .LC0
 		ldr	r2, [r2]		@ max = 0x01ffffff
+		add	r0, r0, r1, lsr #32-14
 		mov	r0, r0, lsr #14		@ max = 0x0001ffff
+		add	r2, r2, r1, lsr #32-10
 		mov	r2, r2, lsr #10		@ max = 0x00007fff
 		mul	r0, r2, r0		@ max = 2^32-1
+		add	r0, r0, r1, lsr #32-6
 		movs	r0, r0, lsr #6
 		moveq	pc, lr
 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
