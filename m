Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1EIN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:29:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39361 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1EIN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:29:26 -0400
Date: Mon, 09 May 2011 14:29:22 +0100
Message-Id: <E1QJQWY-0000M4-A5@rmk-PC.arm.linux.org.uk>
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/4] clocksource: convert x86 to generic i8253 clocksource
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert x86 i8253 clocksource code to use generic i8253 clocksource.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/x86/Kconfig             |    1 +
 arch/x86/include/asm/i8253.h |    2 +
 arch/x86/kernel/i8253.c      |   79 +-----------------------------------------
 3 files changed, 4 insertions(+), 78 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..01115d5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -8,6 +8,7 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select CLKSRC_I8253
 
 config X86_64
 	def_bool 64BIT
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index fc1f579..65aaa91 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -6,6 +6,8 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
+#define PIT_LATCH	LATCH
+
 extern raw_spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 2dfd315..a97aefc 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -117,81 +117,6 @@ void __init setup_pit_timer(void)
 }
 
 #ifndef CONFIG_X86_64
-/*
- * Since the PIT overflows every tick, its not very useful
- * to just read by itself. So use jiffies to emulate a free
- * running counter:
- */
-static cycle_t pit_read(struct clocksource *cs)
-{
-	static int old_count;
-	static u32 old_jifs;
-	unsigned long flags;
-	int count;
-	u32 jifs;
-
-	raw_spin_lock_irqsave(&i8253_lock, flags);
-	/*
-	 * Although our caller may have the read side of xtime_lock,
-	 * this is now a seqlock, and we are cheating in this routine
-	 * by having side effects on state that we cannot undo if
-	 * there is a collision on the seqlock and our caller has to
-	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
-	 * jiffies as volatile despite the lock.  We read jiffies
-	 * before latching the timer count to guarantee that although
-	 * the jiffies value might be older than the count (that is,
-	 * the counter may underflow between the last point where
-	 * jiffies was incremented and the point where we latch the
-	 * count), it cannot be newer.
-	 */
-	jifs = jiffies;
-	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_pit(PIT_CH0);	/* read the latched count */
-	count |= inb_pit(PIT_CH0) << 8;
-
-	/* VIA686a test code... reset the latch if count > max + 1 */
-	if (count > LATCH) {
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(LATCH & 0xff, PIT_CH0);
-		outb_pit(LATCH >> 8, PIT_CH0);
-		count = LATCH - 1;
-	}
-
-	/*
-	 * It's possible for count to appear to go the wrong way for a
-	 * couple of reasons:
-	 *
-	 *  1. The timer counter underflows, but we haven't handled the
-	 *     resulting interrupt and incremented jiffies yet.
-	 *  2. Hardware problem with the timer, not giving us continuous time,
-	 *     the counter does small "jumps" upwards on some Pentium systems,
-	 *     (see c't 95/10 page 335 for Neptun bug.)
-	 *
-	 * Previous attempts to handle these cases intelligently were
-	 * buggy, so we just do the simple thing now.
-	 */
-	if (count > old_count && jifs == old_jifs)
-		count = old_count;
-
-	old_count = count;
-	old_jifs = jifs;
-
-	raw_spin_unlock_irqrestore(&i8253_lock, flags);
-
-	count = (LATCH - 1) - count;
-
-	return (cycle_t)(jifs * LATCH) + count;
-}
-
-static struct clocksource pit_cs = {
-	.name		= "pit",
-	.rating		= 110,
-	.read		= pit_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-	.mult		= 0,
-	.shift		= 20,
-};
-
 static int __init init_pit_clocksource(void)
 {
 	 /*
@@ -205,9 +130,7 @@ static int __init init_pit_clocksource(void)
 	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
-
-	return clocksource_register(&pit_cs);
+	return clocksource_pit_init();
 }
 arch_initcall(init_pit_clocksource);
 
-- 
1.7.4.4

