Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1GGOI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:08:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52676 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1GGOIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:08:51 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        Valentine Barshak <vbarshak@mvista.com>
Subject: [PATCH V4 2/4] ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
Date: Thu,  7 Jul 2011 18:06:19 +0400
Message-Id: <1310047579-4694-1-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com>
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the commit "98af057092f8f0dabe63c5df08adc2bbfbddb1d2
 ARM: 6126/1: ARM mpcore_wdt: fix build failure and other fixes"
resolved long standing mpcore_wdt driver build problems, it
introduced an error in the relationship between the MPcore watchdog
timer clock rate and mpcore_margin, "MPcore timer margin in seconds",
such that watchdog timeouts are now arbitrary rather than the number
of seconds specified by mpcore_margin.

This change restores mpcore_wdt_keepalive() to its equivalent
implementation prior to commit 98af057 such that watchdog timeouts now
occur as specified by mpcore_margin.

The variable 'mpcore_timer_rate' which caused that build failure was
replaced by 'twd_timer_rate'. Adding exported function to obtain
'twd_timer_rate' value in mpcore_wdt driver.

MPCORE_WATCHDOG needed to build 'mpcore_wdt' already depends on
HAVE_ARM_TWD needed to build 'smp_twd', so from the point of view of
'mpcore_wdt' driver the exported function will always exist.

Signed-off-by: Valentine Barshak <vbarshak@mvista.com>
Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---

Forgot to change EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL, sorry
Other patches are unchanged.

 arch/arm/include/asm/smp_twd.h |    1 +
 arch/arm/kernel/smp_twd.c      |    7 +++++++
 drivers/watchdog/mpcore_wdt.c  |    4 +---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index fed9981..38130b1 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -24,5 +24,6 @@ extern void __iomem *twd_base;
 
 int twd_timer_ack(void);
 void twd_timer_setup(struct clock_event_device *);
+unsigned long twd_timer_get_rate(void);
 
 #endif
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 2c277d4..dd64fae 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -142,3 +142,10 @@ void __cpuinit twd_timer_setup(struct clock_event_device *clk)
 
 	clockevents_register_device(clk);
 }
+
+/* Needed by mpcore_wdt */
+unsigned long twd_timer_get_rate(void)
+{
+	return twd_timer_rate;
+}
+EXPORT_SYMBOL_GPL(twd_timer_get_rate);
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2b4af22..efde50b 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -99,9 +99,7 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 
 	spin_lock(&wdt_lock);
 	/* Assume prescale is set to 256 */
-	count =  __raw_readl(wdt->base + TWD_WDOG_COUNTER);
-	count = (0xFFFFFFFFU - count) * (HZ / 5);
-	count = (count / 256) * mpcore_margin;
+	count = (twd_timer_get_rate() / 256) * mpcore_margin;
 
 	/* Reload the counter */
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
-- 
1.7.3.4

