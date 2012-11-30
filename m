Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2K3TSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:18:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:58663 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992820Ab2K3S4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, R Sricharan <r.sricharan@ti.com>,
        Tony Lindgren <tony@atomide.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [ 53/56] ARM: OMAP: counter: add locking to read_persistent_clock
Date: Fri, 30 Nov 2012 10:55:45 -0800
Message-Id: <20121130185123.709697756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

commit 9d7d6e363b06934221b81a859d509844c97380df upstream.

read_persistent_clock uses a global variable, use a spinlock to
ensure non-atomic updates to the variable don't overlap and cause
time to move backwards.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: R Sricharan <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/plat-omap/counter_32k.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -50,22 +50,29 @@ static u32 notrace omap_32k_read_sched_c
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


