Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2AKOU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:20:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57314 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab2AKOUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:20:24 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC] OMAP : watchdog : Fix the mismatch of pm_runtime enable and disable
Date: Wed, 11 Jan 2012 19:50:18 +0530
Message-ID: <1326291618-20416-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the watchdog driver calls the pm_runtime_enable and never
the disable. This may cause a warning when pm_runtime_enable
checks for the count match.

Also fixes the error

/build/watchdog # insmod omap_wdt.ko
[   44.999389] omap_wdt omap_wdt: Unbalanced pm_runtime_enable!
[   45.011047] OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
/build/watchdog #

Attempting to fix the same by calling pm_runtime_disable.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/watchdog/omap_wdt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 971179d..d084a7a 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -339,6 +339,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 	return 0;
 
 err_misc:
+	pm_runtime_disable(wdev->dev);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(wdev->base);
 
@@ -371,6 +372,7 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
+	pm_runtime_disable(wdev->dev);
 	if (!res)
 		return -ENOENT;
 
-- 
1.7.1

