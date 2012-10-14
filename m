Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2JNOmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46309 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab2JNOmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:31 -0400
Message-Id: <20121014143549.024896961@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, R Sricharan <r.sricharan@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 113/147] ARM: OMAP: counter: add locking to read_persistent_clock
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 9d7d6e363b06934221b81a859d509844c97380df upstream.

read_persistent_clock uses a global variable, use a spinlock to
ensure non-atomic updates to the variable don't overlap and cause
time to move backwards.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: R Sricharan <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-omap/counter_32k.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -82,22 +82,29 @@ static void notrace omap_update_sched_cl
  * nsecs and adds to a monotonically increasing timespec.
  */
 static struct timespec persistent_ts;
-static cycles_t cycles, last_cycles;
+static cycles_t cycles;
 static unsigned int persistent_mult, persistent_shift;
+static DEFINE_SPINLOCK(read_persistent_clock_lock);
+
 void read_persistent_clock(struct timespec *ts)
 {
 	unsigned long long nsecs;
-	cycles_t delta;
-	struct timespec *tsp = &persistent_ts;
+	cycles_t last_cycles;
+	unsigned long flags;
+
+	spin_lock_irqsave(&read_persistent_clock_lock, flags);
 
 	last_cycles = cycles;
 	cycles = timer_32k_base ? __raw_readl(timer_32k_base) : 0;
-	delta = cycles - last_cycles;
 
-	nsecs = clocksource_cyc2ns(delta, persistent_mult, persistent_shift);
+	nsecs = clocksource_cyc2ns(cycles - last_cycles,
+					persistent_mult, persistent_shift);
+
+	timespec_add_ns(&persistent_ts, nsecs);
+
+	*ts = persistent_ts;
 
-	timespec_add_ns(tsp, nsecs);
-	*ts = *tsp;
+	spin_unlock_irqrestore(&read_persistent_clock_lock, flags);
 }
 
 int __init omap_init_clocksource_32k(void)


