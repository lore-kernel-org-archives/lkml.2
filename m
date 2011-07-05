Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1GETDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:03:20 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43824 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1GETDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:03:17 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V2 2/6] arm_smp_twd: mpcore_wdt: Fix watchdog counter loading
Date: Tue,  5 Jul 2011 23:00:36 +0400
Message-Id: <1309892440-3260-3-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
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

A build error will not occur because MPCORE_WATCHDOG needed to build
'mpcore_wdt' depends on HAVE_ARM_TWD needed to build 'smp_twd'.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 drivers/clocksource/arm_smp_twd.c |   13 +++++++++++++
 drivers/watchdog/mpcore_wdt.c     |    6 +++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_smp_twd.c b/drivers/clocksource/arm_smp_twd.c
index 6acbdac..32f78ff 100644
--- a/drivers/clocksource/arm_smp_twd.c
+++ b/drivers/clocksource/arm_smp_twd.c
@@ -241,6 +241,19 @@ static void __cpuinit twd_setup(void *data)
 					0xf, 0xffffffff);
 }
 
+/* Needed by mpcore_wdt */
+unsigned long twd_timer_get_rate(void)
+{
+	unsigned long rate;
+
+	if (!IS_ERR_OR_NULL(twd_clk))
+		rate = clk_get_rate(twd_clk);
+	else
+		rate = twd_timer_rate;
+	return rate;
+}
+EXPORT_SYMBOL(twd_timer_get_rate);
+
 static void __cpuinit twd_teardown(void *data)
 {
 	struct clock_event_device *clk = data;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index f638206..7a3d6b2 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -33,6 +33,8 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 
+unsigned long twd_timer_get_rate(void);
+
 #define TWD_WDOG_LOAD			0x20
 #define TWD_WDOG_COUNTER		0x24
 #define TWD_WDOG_CONTROL		0x28
@@ -104,9 +106,7 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 
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

