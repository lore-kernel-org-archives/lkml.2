Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1KAVdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:33:19 -0400
Received: from plexity.net ([206.123.115.38]:42170 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1KAVdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:33:16 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 17:33:16 EDT
Date: Tue, 1 Nov 2011 14:25:25 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, rmk@arm.linux.org.uk,
        John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Replace LATCH with PIT_LATCH in i8253 clocksource driver
Message-ID: <20111101212525.GD31143@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The i8253 clockevent & clocksource driver uses PIT_LATCH
except for two cases where it uses LATCH:

1)
	/* VIA686a test code... reset the latch if count > max + 1 */
	if (count > LATCH) {

LATCH is based on CLOCK_TICK_RATE which is defined as 
PIT_TICK_RATE on x86 so this should just be the later.

2)
	...
	switch (mode) {
	case CLOCK_EVT_MODE_PERIODIC:
		/* binary, mode 2, LSB/MSB, ch 0 */
		outb_p(0x34, PIT_MODE);
		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
		outb_p(LATCH >> 8 , PIT_CH0);		/* MSB */
	...

MIPS and ARM are the only other arches that use this driver. In
the MIPS case CLOCK_TICK_RATE is defined as the same value as
PIT_TICK_RATE. For ARM, the only machine that uses it is
Footbridge which has a totally bogus CLOCK_TICK_RATE according
to the comments. Furthermore, the clockevent_i8253_init()
initializes the clockevent with PIT_TIC_RATE, so there's
no reason to use the generic LATCH.

This is part of work to remove and depecrate the global
CLOCK_TICK_RATE symbol.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 drivers/clocksource/i8253.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 27c49e6..e7cab2d 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -53,7 +53,7 @@ static cycle_t i8253_read(struct clocksource *cs)
 	count |= inb_p(PIT_CH0) << 8;
 
 	/* VIA686a test code... reset the latch if count > max + 1 */
-	if (count > LATCH) {
+	if (count > PIT_LATCH) {
 		outb_p(0x34, PIT_MODE);
 		outb_p(PIT_LATCH & 0xff, PIT_CH0);
 		outb_p(PIT_LATCH >> 8, PIT_CH0);
@@ -114,8 +114,8 @@ static void init_pit_timer(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb_p(LATCH >> 8 , PIT_CH0);		/* MSB */
+		outb_p(PIT_LATCH & 0xff , PIT_CH0);	/* LSB */
+		outb_p(PIT_LATCH >> 8 , PIT_CH0);		/* MSB */
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
-- 
1.7.4.1

