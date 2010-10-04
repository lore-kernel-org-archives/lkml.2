Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0JDJpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:45:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0JDJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:45:51 -0400
From: vkuzmichev@mvista.com
To: linux-arm-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH 4/4] ARM: mpcore_wdt: Fix timer mode setup
Date: Mon,  4 Oct 2010 13:45:40 +0400
Message-Id: <1286185540-19569-5-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuzmichev <vkuzmichev@mvista.com>

Allow watchdog to set its iterrupt as pending when it is configured
for timer mode.
Also add macros for all Watchdog Control Register flags.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 arch/arm/include/asm/smp_twd.h |    6 ++++++
 drivers/watchdog/mpcore_wdt.c  |   15 +++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index c6328d8..324bf0a 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -18,6 +18,12 @@
 #define TWD_TIMER_CONTROL_PERIODIC	(1 << 1)
 #define TWD_TIMER_CONTROL_IT_ENABLE	(1 << 2)
 
+#define TWD_WDOG_CONTROL_ENABLE		(1 << 0)
+#define TWD_WDOG_CONTROL_PERIODIC	(1 << 1)
+#define TWD_WDOG_CONTROL_IT_ENABLE	(1 << 2)
+#define TWD_WDOG_CONTROL_TIMER_MODE	(0 << 3)
+#define TWD_WDOG_CONTROL_WATCHDOG_MODE	(1 << 3)
+
 struct clock_event_device;
 
 extern void __iomem *twd_base;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 6d3ac06..07d5a1c 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -123,18 +123,25 @@ static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 
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
1.7.2.2

