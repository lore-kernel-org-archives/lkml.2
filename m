Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1DGACs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:02:48 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:58950 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab1DGACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:44 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@opensource.se>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH/RFC 1/6] ARM: sh-mobile: runtime PM: convert to device powerdomains
Date: Wed,  6 Apr 2011 17:02:44 -0700
Message-Id: <1302134569-22825-2-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302134569-22825-1-git-send-email-khilman@ti.com>
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the deprecated use of weak platform_bus symbols in favor of using
the new device power domains.

Cc: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-shmobile/pm_runtime.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm_runtime.c b/arch/arm/mach-shmobile/pm_runtime.c
index 94912d3..6c75c3f 100644
--- a/arch/arm/mach-shmobile/pm_runtime.c
+++ b/arch/arm/mach-shmobile/pm_runtime.c
@@ -66,7 +66,7 @@ static void platform_pm_runtime_bug(struct device *dev,
 		dev_err(dev, "runtime pm suspend before resume\n");
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int platform_pm_runtime_suspend(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
@@ -82,7 +82,7 @@ int platform_pm_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int platform_pm_runtime_resume(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
@@ -98,12 +98,20 @@ int platform_pm_runtime_resume(struct device *dev)
 	return 0;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int platform_pm_runtime_idle(struct device *dev)
 {
 	/* suspend synchronously to disable clocks immediately */
 	return pm_runtime_suspend(dev);
 }
 
+static struct dev_power_domain platform_pm_power_domain = {
+	.ops = {
+		.runtime_suspend = platform_pm_runtime_suspend,
+		.runtime_resume = platform_pm_runtime_resume,
+		.runtime_idle = platform_pm_runtime_idle,
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -114,10 +122,12 @@ static int platform_bus_notify(struct notifier_block *nb,
 
 	if (action == BUS_NOTIFY_BIND_DRIVER) {
 		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
-		if (prd)
+		if (prd) {
 			devres_add(dev, prd);
-		else
+			dev->pwr_domain = &platform_pm_power_domain;
+		} else {
 			dev_err(dev, "unable to alloc memory for runtime pm\n");
+		}
 	}
 
 	return 0;
-- 
1.7.4

