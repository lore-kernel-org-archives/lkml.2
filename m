Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1BRWTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:19:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:52832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1BRWTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:19:14 -0500
Date: Fri, 18 Feb 2011 22:18:58 GMT
From: "tip-bot for jacob.jun.pan@linux.intel.com" 
	<jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1298065374-25532-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1298065374-25532-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: mrst: Remove apb timer read workaround
Message-ID: <tip-5df91509d324d44cfb11e55d9cb02fe18b53b045@git.kernel.org>
Git-Commit-ID: 5df91509d324d44cfb11e55d9cb02fe18b53b045
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 22:18:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5df91509d324d44cfb11e55d9cb02fe18b53b045
Gitweb:     http://git.kernel.org/tip/5df91509d324d44cfb11e55d9cb02fe18b53b045
Author:     jacob.jun.pan@linux.intel.com <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 18 Feb 2011 13:42:54 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Feb 2011 23:14:54 +0100

x86: mrst: Remove apb timer read workaround

APB timer current count was unreliable in the earlier silicon, which
could result in time going backwards. This problem has been fixed in
the current silicon stepping. This patch removes the workaround which
was used to check and prevent timer rolling back when APB timer is
used as clocksource device.

The workaround code was also flawed by potential race condition
around the cached read value last_read. Though a fix can be done
by assigning last_read to a local variable at the beginning of
apbt_read_clocksource(), but this is not necessary anymore.

[ tglx: A sane timer on an Intel chip - I can't believe it ]

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
LKML-Reference: <1298065374-25532-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apb_timer.c |   60 +++----------------------------------------
 1 files changed, 4 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7c9ab59..afc4064 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -506,64 +506,12 @@ static int apbt_next_event(unsigned long delta,
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
