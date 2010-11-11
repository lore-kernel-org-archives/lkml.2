Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0KKJG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:06:26 -0500
Received: from mail.df.lth.se ([194.47.250.12]:41246 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1749667Ab0KKJGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:06:22 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Colin Cross <ccross@google.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] RFC: nomadik: expand timesource to 63 bits
Date: Thu, 11 Nov 2010 10:05:56 +0100
Message-Id: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After wraparound-problems in sched_clock() we expand the 32bit
timer in the MTU from 32 to 63 bits so the scheduling and
timeline is more stable. At current max operating frequency for
the MTU, 133 MHz, this should be sufficient for rougly 2200
years.

Cc: Colin Cross <ccross@google.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
tglx, nico: can you help out on reviewing this?

The solution in this patch is based on the similar approach
taken by the Tegra platform in arch/arm/mach-tegra/timer.c.

Orion on the other hand will only expand the timer to 63
bits in the sched_clock() function in arch/arm/plat-orion/time.c

What we need to know is whether it's OK to simply blow up
clocksource to 63 bits like this. In that case this
simplification should also apply to Orion, meaning that it
would base it's sched_clock() on the clocksource, using
simply clocksource_cyc2ns() cutting down the code
significantly.

My main obstacle is that I cannot really determine whether
clocksource.read() will be called often enough for the
cnt32_to_63 algorithm.

If this won't work the Tegra platform probably needs fixing
too.

We had a rather heated debate about this internally already
so I'm seeking the advice of the elders.
---
 arch/arm/plat-nomadik/timer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-nomadik/timer.c b/arch/arm/plat-nomadik/timer.c
index aedf9c1..e887bf8 100644
--- a/arch/arm/plat-nomadik/timer.c
+++ b/arch/arm/plat-nomadik/timer.c
@@ -16,6 +16,7 @@
 #include <linux/clk.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/cnt32_to_63.h>
 #include <asm/mach/time.h>
 
 #include <plat/mtu.h>
@@ -34,14 +35,14 @@ static cycle_t nmdk_read_timer_dummy(struct clocksource *cs)
 /* clocksource: MTU decrements, so we negate the value being read. */
 static cycle_t nmdk_read_timer(struct clocksource *cs)
 {
-	return -readl(mtu_base + MTU_VAL(0));
+	return cnt32_to_63(-readl(mtu_base + MTU_VAL(0)));
 }
 
 static struct clocksource nmdk_clksrc = {
 	.name		= "mtu_0",
 	.rating		= 200,
 	.read		= nmdk_read_timer_dummy,
-	.mask		= CLOCKSOURCE_MASK(32),
+	.mask		= CLOCKSOURCE_MASK(63),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-- 
1.6.3.3

