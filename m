Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab1DPXpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:45:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760501Ab1DPXpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:45:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/9] PM / Runtime: Add subsystem data field to struct dev_pm_info
Date: Sun, 17 Apr 2011 01:40:40 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl>
In-Reply-To: <201104170135.19388.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104170140.40557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some subsystems need to attach PM-related data to struct device and
they need to use devres for this purpose.  For their convenience
and to make code more straightforward, add a new field called
subsys_data to struct dev_pm_info and let subsystems use it for
attaching PM-related information to devices.

Convert the ARM shmobile platform to using the new field.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c |   34 +++++++++++++++++-----------------
 include/linux/pm.h                  |    1 +
 2 files changed, 18 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -460,6 +460,7 @@ struct dev_pm_info {
 	unsigned long		active_jiffies;
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
+	void			*subsys_data;  /* Owned by the subsystem. */
 #endif
 };
 
Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -18,6 +18,7 @@
 #include <linux/clk.h>
 #include <linux/sh_clk.h>
 #include <linux/bitmap.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_PM_RUNTIME
 #define BIT_ONCE 0
@@ -29,22 +30,9 @@ struct pm_runtime_data {
 	struct clk *clk;
 };
 
-static void __devres_release(struct device *dev, void *res)
-{
-	struct pm_runtime_data *prd = res;
-
-	dev_dbg(dev, "__devres_release()\n");
-
-	if (test_bit(BIT_CLK_ENABLED, &prd->flags))
-		clk_disable(prd->clk);
-
-	if (test_bit(BIT_ACTIVE, &prd->flags))
-		clk_put(prd->clk);
-}
-
 static struct pm_runtime_data *__to_prd(struct device *dev)
 {
-	return devres_find(dev, __devres_release, NULL, NULL);
+	return dev ? dev->power.subsys_data : NULL;
 }
 
 static void platform_pm_runtime_init(struct device *dev,
@@ -121,14 +109,26 @@ static int platform_bus_notify(struct no
 
 	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
 
-	if (action == BUS_NOTIFY_BIND_DRIVER) {
-		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		prd = kzalloc(sizeof(*prd), GFP_KERNEL);
 		if (prd) {
-			devres_add(dev, prd);
+			dev->power.subsys_data = prd;
 			dev->pwr_domain = &default_power_domain;
 		} else {
 			dev_err(dev, "unable to alloc memory for runtime pm\n");
 		}
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		prd = __to_prd(dev);
+		if (prd) {
+			if (test_bit(BIT_CLK_ENABLED, &prd->flags))
+				clk_disable(prd->clk);
+
+			if (test_bit(BIT_ACTIVE, &prd->flags))
+				clk_put(prd->clk);
+		}
+		break;
 	}
 
 	return 0;

