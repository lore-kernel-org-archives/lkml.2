Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190Ab2JSKBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:01:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39220 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398Ab2JSKA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:00:56 -0400
From: Afzal Mohammed <afzal@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <rtc-linux@googlegroups.com>,
        Daniel Mack <zonque@gmail.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v4 5/5] rtc: omap: Add runtime pm support
Date: Fri, 19 Oct 2012 15:29:50 +0530
Message-ID: <85f1737925191eb340f294e1564aa9fe996dfb31.1350633036.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1350633036.git.afzal@ti.com>
References: <cover.1350633036.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

OMAP1 RTC driver is used in multiple devices like,
OMAPL138 and AM33XX. Driver currently doesn't handle any clocks,
which may be right for OMAP1 architecture but in case of AM33XX,
the clock/module needs to be enabled in order to access the registers.

So covert this driver to runtime pm, which internally handles rest.

afzal@ti.com: handle error path

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/rtc/rtc-omap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index dff9ff4..6009714 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 
@@ -364,6 +365,10 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
+	/* Enable the clock/module so that we can access the registers */
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	id_entry = platform_get_device_id(pdev);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER)) {
 		rtc_writel(KICK0_VALUE, OMAP_RTC_KICK0_REG);
@@ -448,6 +453,8 @@ fail1:
 fail0:
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	iounmap(rtc_base);
 fail:
 	release_mem_region(mem->start, resource_size(mem));
@@ -474,6 +481,11 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	rtc_device_unregister(rtc);
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
+
+	/* Disable the clock/module */
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	iounmap(rtc_base);
 	release_mem_region(mem->start, resource_size(mem));
 	return 0;
@@ -496,11 +508,17 @@ static int omap_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	else
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
+	/* Disable the clock/module */
+	pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 }
 
 static int omap_rtc_resume(struct platform_device *pdev)
 {
+	/* Enable the clock/module so that we can access the registers */
+	pm_runtime_get_sync(&pdev->dev);
+
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(omap_rtc_alarm);
 	else
-- 
1.7.12

