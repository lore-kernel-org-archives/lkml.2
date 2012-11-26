Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2KZRDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2KZRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>, R Sricharan <r.sricharan@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 055/270] ARM: OMAP: counter: add locking to read_persistent_clock
Date: Mon, 26 Nov 2012 14:55:45 -0200
Message-Id: <1353949160-26803-56-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 9d7d6e363b06934221b81a859d509844c97380df upstream.

read_persistent_clock uses a global variable, use a spinlock to
ensure non-atomic updates to the variable don't overlap and cause
time to move backwards.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: R Sricharan <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/plat-omap/counter_32k.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index 2132c4f..721eae5 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -52,22 +52,29 @@ static u32 notrace omap_32k_read_sched_clock(void)
  * nsecs and adds to a monotonically increasing timespec.
  */
 static struct timespec persistent_ts;
-static cycles_t cycles, last_cycles;
+static cycles_t cycles;
 static unsigned int persistent_mult, persistent_shift;
+static DEFINE_SPINLOCK(read_persistent_clock_lock);
+
 static void omap_read_persistent_clock(struct timespec *ts)
 {
 	unsigned long long nsecs;
-	cycles_t delta;
-	struct timespec *tsp = &persistent_ts;
+	cycles_t last_cycles;
+	unsigned long flags;
+
+	spin_lock_irqsave(&read_persistent_clock_lock, flags);
 
 	last_cycles = cycles;
 	cycles = sync32k_cnt_reg ? __raw_readl(sync32k_cnt_reg) : 0;
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
 
 /**
-- 
1.7.9.5

