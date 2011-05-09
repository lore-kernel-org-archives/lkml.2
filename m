Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1EIN2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:28:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1EIN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:28:46 -0400
Date: Mon, 09 May 2011 14:28:41 +0100
Message-Id: <E1QJQVt-0000Lv-GW@rmk-PC.arm.linux.org.uk>
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 1/4] clocksource: add common i8253 PIT clocksource
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based upon both arch/arm/mach-footbridge/isa-timer.c and
arch/x86/kernel/i8253.c.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/clocksource/Kconfig  |    3 +
 drivers/clocksource/Makefile |    1 +
 drivers/clocksource/i8253.c  |   88 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clocksource/Kconfig
 create mode 100644 drivers/clocksource/i8253.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
new file mode 100644
index 0000000..6726997
--- /dev/null
+++ b/drivers/clocksource/Kconfig
@@ -0,0 +1,3 @@
+config CLKSRC_I8253
+	bool
+
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index be61ece..cfb6383 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
+obj-$(CONFIG_CLKSRC_I8253)	+= i8253.o
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
new file mode 100644
index 0000000..225c176
--- /dev/null
+++ b/drivers/clocksource/i8253.c
@@ -0,0 +1,88 @@
+/*
+ * i8253 PIT clocksource
+ */
+#include <linux/clocksource.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/timex.h>
+
+#include <asm/i8253.h>
+
+/*
+ * Since the PIT overflows every tick, its not very useful
+ * to just read by itself. So use jiffies to emulate a free
+ * running counter:
+ */
+static cycle_t i8253_read(struct clocksource *cs)
+{
+	static int old_count;
+	static u32 old_jifs;
+	unsigned long flags;
+	int count;
+	u32 jifs;
+
+	raw_spin_lock_irqsave(&i8253_lock, flags);
+	/*
+	 * Although our caller may have the read side of xtime_lock,
+	 * this is now a seqlock, and we are cheating in this routine
+	 * by having side effects on state that we cannot undo if
+	 * there is a collision on the seqlock and our caller has to
+	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
+	 * jiffies as volatile despite the lock.  We read jiffies
+	 * before latching the timer count to guarantee that although
+	 * the jiffies value might be older than the count (that is,
+	 * the counter may underflow between the last point where
+	 * jiffies was incremented and the point where we latch the
+	 * count), it cannot be newer.
+	 */
+	jifs = jiffies;
+	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
+	count = inb_pit(PIT_CH0);	/* read the latched count */
+	count |= inb_pit(PIT_CH0) << 8;
+
+	/* VIA686a test code... reset the latch if count > max + 1 */
+	if (count > LATCH) {
+		outb_pit(0x34, PIT_MODE);
+		outb_pit(PIT_LATCH & 0xff, PIT_CH0);
+		outb_pit(PIT_LATCH >> 8, PIT_CH0);
+		count = PIT_LATCH - 1;
+	}
+
+	/*
+	 * It's possible for count to appear to go the wrong way for a
+	 * couple of reasons:
+	 *
+	 *  1. The timer counter underflows, but we haven't handled the
+	 *     resulting interrupt and incremented jiffies yet.
+	 *  2. Hardware problem with the timer, not giving us continuous time,
+	 *     the counter does small "jumps" upwards on some Pentium systems,
+	 *     (see c't 95/10 page 335 for Neptun bug.)
+	 *
+	 * Previous attempts to handle these cases intelligently were
+	 * buggy, so we just do the simple thing now.
+	 */
+	if (count > old_count && jifs == old_jifs)
+		count = old_count;
+
+	old_count = count;
+	old_jifs = jifs;
+
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
+
+	count = (PIT_LATCH - 1) - count;
+
+	return (cycle_t)(jifs * PIT_LATCH) + count;
+}
+
+static struct clocksource i8253_cs = {
+	.name		= "pit",
+	.rating		= 110,
+	.read		= i8253_read,
+	.mask		= CLOCKSOURCE_MASK(32),
+};
+
+int __init clocksource_i8253_init(void)
+{
+	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
+}
-- 
1.7.4.4

