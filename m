Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1GETDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:03:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43824 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1GETDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:03:22 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V2 4/6] mpcore_wdt: Fix timer mode setup
Date: Tue,  5 Jul 2011 23:00:38 +0400
Message-Id: <1309892440-3260-5-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow watchdog to set its iterrupt as pending when it is configured
for timer mode (in other words, allow emitting interrupt).
Also add macros for all Watchdog Control Register flags.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 drivers/watchdog/mpcore_wdt.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index b330a0a..11c70df 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -42,6 +42,12 @@ unsigned long twd_timer_get_rate(void);
 #define TWD_WDOG_RESETSTAT		0x30
 #define TWD_WDOG_DISABLE		0x34
 
+#define TWD_WDOG_CONTROL_ENABLE		(1 << 0)
+#define TWD_WDOG_CONTROL_PERIODIC	(1 << 1)
+#define TWD_WDOG_CONTROL_IT_ENABLE	(1 << 2)
+#define TWD_WDOG_CONTROL_TIMER_MODE	(0 << 3)
+#define TWD_WDOG_CONTROL_WATCHDOG_MODE	(1 << 3)
+
 struct mpcore_wdt {
 	unsigned long	timer_alive;
 	struct device	*dev;
@@ -125,18 +131,25 @@ static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
+	u32 mode;
+
 	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
 
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
 
+	/* Setup watchdog - prescale=256, enable=1 */
+	mode = (255 << 8) | TWD_WDOG_CONTROL_ENABLE;
+
 	if (mpcore_noboot) {
-		/* Enable watchdog - prescale=256, watchdog mode=0, enable=1 */
-		writel(0x0000FF01, wdt->base + TWD_WDOG_CONTROL);
+		/* timer mode, send interrupt */
+		mode |=	TWD_WDOG_CONTROL_TIMER_MODE
+		     |  TWD_WDOG_CONTROL_IT_ENABLE;
 	} else {
-		/* Enable watchdog - prescale=256, watchdog mode=1, enable=1 */
-		writel(0x0000FF09, wdt->base + TWD_WDOG_CONTROL);
+		/* watchdog mode */
+		mode |=	TWD_WDOG_CONTROL_WATCHDOG_MODE;
 	}
+	writel(mode, wdt->base + TWD_WDOG_CONTROL);
 }
 
 static int mpcore_wdt_set_heartbeat(int t)
-- 
1.7.3.4

