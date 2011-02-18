Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab1BRVpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:45:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:37802 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab1BRVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:45:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,189,1297065600"; 
   d="scan'208";a="604303185"
From: jacob.jun.pan@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: remove apb timer read workaround
Date: Fri, 18 Feb 2011 13:42:54 -0800
Message-Id: <1298065374-25532-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

APB timer current count was unreliable in the earlier silicon, which
could result in time going backwards. This problem has been fixed in
the current silicon stepping. This patch removes the workaround which
was used to check and prevent timer rolling back when APB timer is
used as clocksource device.

The workaround code was also flawed by potential race condition
around the cached read value last_read. Though a fix can be done
by assigning last_read to a local variable at the beginning of
apbt_read_clocksource(), but this is not necessary anymore.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |   60 +++----------------------------------------
 1 files changed, 4 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 51ef31a..671d5aa 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -508,64 +508,12 @@ static int apbt_next_event(unsigned long delta,
 	return 0;
 }
 
-/*
- * APB timer clock is not in sync with pclk on Langwell, which translates to
- * unreliable read value caused by sampling error. the error does not add up
- * overtime and only happens when sampling a 0 as a 1 by mistake. so the time
- * would go backwards. the following code is trying to prevent time traveling
- * backwards. little bit paranoid.
- */
 static cycle_t apbt_read_clocksource(struct clocksource *cs)
 {
-	unsigned long t0, t1, t2;
-	static unsigned long last_read;
-
-bad_count:
-	t1 = apbt_readl(phy_cs_timer_id,
-			APBTMR_N_CURRENT_VALUE);
-	t2 = apbt_readl(phy_cs_timer_id,
-			APBTMR_N_CURRENT_VALUE);
-	if (unlikely(t1 < t2)) {
-		pr_debug("APBT: read current count error %lx:%lx:%lx\n",
-			 t1, t2, t2 - t1);
-		goto bad_count;
-	}
-	/*
-	 * check against cached last read, makes sure time does not go back.
-	 * it could be a normal rollover but we will do tripple check anyway
-	 */
-	if (unlikely(t2 > last_read)) {
-		/* check if we have a normal rollover */
-		unsigned long raw_intr_status =
-			apbt_readl_reg(APBTMRS_RAW_INT_STATUS);
-		/*
-		 * cs timer interrupt is masked but raw intr bit is set if
-		 * rollover occurs. then we read EOI reg to clear it.
-		 */
-		if (raw_intr_status & (1 << phy_cs_timer_id)) {
-			apbt_readl(phy_cs_timer_id, APBTMR_N_EOI);
-			goto out;
-		}
-		pr_debug("APB CS going back %lx:%lx:%lx ",
-			 t2, last_read, t2 - last_read);
-bad_count_x3:
-		pr_debug("triple check enforced\n");
-		t0 = apbt_readl(phy_cs_timer_id,
-				APBTMR_N_CURRENT_VALUE);
-		udelay(1);
-		t1 = apbt_readl(phy_cs_timer_id,
-				APBTMR_N_CURRENT_VALUE);
-		udelay(1);
-		t2 = apbt_readl(phy_cs_timer_id,
-				APBTMR_N_CURRENT_VALUE);
-		if ((t2 > t1) || (t1 > t0)) {
-			printk(KERN_ERR "Error: APB CS tripple check failed\n");
-			goto bad_count_x3;
-		}
-	}
-out:
-	last_read = t2;
-	return (cycle_t)~t2;
+	unsigned long current_count;
+
+	current_count = apbt_readl(phy_cs_timer_id, APBTMR_N_CURRENT_VALUE);
+	return (cycle_t)~current_count;
 }
 
 static int apbt_clocksource_register(void)
-- 
1.7.0.4

