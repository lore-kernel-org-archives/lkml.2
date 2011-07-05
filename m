Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1GETD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:03:28 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43824 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1GETDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:03:25 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V2 5/6] mpcore_wdt: Add cpufreq notifier to reload counter
Date: Tue,  5 Jul 2011 23:00:39 +0400
Message-Id: <1309892440-3260-6-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case if CPU frequency is changed when watchdog is working it begins to
acount faster or slower. To avoid watchdog triggering before the margin time
the watchdog counter needs to be reloaded.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 drivers/watchdog/mpcore_wdt.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 11c70df..38b9119 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -32,6 +32,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 unsigned long twd_timer_get_rate(void);
 
@@ -426,6 +427,25 @@ static int __devexit mpcore_wdt_remove(struct platform_device *dev)
 	return 0;
 }
 
+static int mpcore_wdt_notify(struct notifier_block *nb,
+				unsigned long state, void *data)
+{
+	struct mpcore_wdt *wdt = platform_get_drvdata(mpcore_wdt_dev);
+	/*
+	 * The mpcore_wdt counter register must be reloaded to account
+	 * properly with the new frequency.
+	 */
+	if (mpcore_wdt_dev && wdt && (state == CPUFREQ_POSTCHANGE ||
+					state == CPUFREQ_RESUMECHANGE))
+		mpcore_wdt_keepalive(wdt);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mpcore_wdt_nb = {
+	.notifier_call = mpcore_wdt_notify,
+};
+
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:mpcore_wdt");
 
@@ -444,6 +464,7 @@ static char banner[] __initdata = KERN_INFO "MPcore Watchdog Timer: 0.1. "
 
 static int __init mpcore_wdt_init(void)
 {
+	int ret = 0;
 	/*
 	 * Check that the margin value is within it's range;
 	 * if not reset to the default
@@ -456,11 +477,19 @@ static int __init mpcore_wdt_init(void)
 
 	printk(banner, mpcore_noboot, mpcore_margin, nowayout);
 
-	return platform_driver_register(&mpcore_wdt_driver);
+	ret = platform_driver_register(&mpcore_wdt_driver);
+
+	if (!ret)
+		ret = cpufreq_register_notifier(&mpcore_wdt_nb,
+						CPUFREQ_TRANSITION_NOTIFIER);
+
+	return ret;
 }
 
 static void __exit mpcore_wdt_exit(void)
 {
+	cpufreq_unregister_notifier(&mpcore_wdt_nb,
+					CPUFREQ_TRANSITION_NOTIFIER);
 	platform_driver_unregister(&mpcore_wdt_driver);
 }
 
-- 
1.7.3.4

