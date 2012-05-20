Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2ETWcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 18:32:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55561 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab2ETWcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 18:32:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Domains: Use subsystem runtime suspend/resume callbacks by default
Date: Mon, 21 May 2012 00:37:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205210037.51266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, the default "save state" and "restore state" routines
for generic PM domains, pm_genpd_default_save_state() and
pm_genpd_default_restore_state(), respectively, only use runtime PM
callbacks provided by device drivers, but in general those callbacks
need not provide the entire necessary functionality.  Namely, in
general it may be necessary to execute subsystem (i.e. device type,
device class or bus type) callbacks that will carry out all of the
necessary operations.

For this reason, modify pm_genpd_default_save_state() and
pm_genpd_default_restore_state() to execute subsystem callbacks,
if they are provided, and fall back to driver callbacks otherwise.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1738,16 +1738,24 @@ int genpd_detach_cpuidle(struct generic_
 static int pm_genpd_default_save_state(struct device *dev)
 {
 	int (*cb)(struct device *__dev);
-	struct device_driver *drv = dev->driver;
 
 	cb = dev_gpd_data(dev)->ops.save_state;
 	if (cb)
 		return cb(dev);
 
-	if (drv && drv->pm && drv->pm->runtime_suspend)
-		return drv->pm->runtime_suspend(dev);
+	if (dev->type && dev->type->pm)
+		cb = dev->type->pm->runtime_suspend;
+	else if (dev->class && dev->class->pm)
+		cb = dev->class->pm->runtime_suspend;
+	else if (dev->bus && dev->bus->pm)
+		cb = dev->bus->pm->runtime_suspend;
+	else
+		cb = NULL;
 
-	return 0;
+	if (!cb && dev->driver && dev->driver->pm)
+		cb = dev->driver->pm->runtime_suspend;
+
+	return cb ? cb(dev) : 0;
 }
 
 /**
@@ -1757,16 +1765,24 @@ static int pm_genpd_default_save_state(s
 static int pm_genpd_default_restore_state(struct device *dev)
 {
 	int (*cb)(struct device *__dev);
-	struct device_driver *drv = dev->driver;
 
 	cb = dev_gpd_data(dev)->ops.restore_state;
 	if (cb)
 		return cb(dev);
 
-	if (drv && drv->pm && drv->pm->runtime_resume)
-		return drv->pm->runtime_resume(dev);
+	if (dev->type && dev->type->pm)
+		cb = dev->type->pm->runtime_resume;
+	else if (dev->class && dev->class->pm)
+		cb = dev->class->pm->runtime_resume;
+	else if (dev->bus && dev->bus->pm)
+		cb = dev->bus->pm->runtime_resume;
+	else
+		cb = NULL;
+
+	if (!cb && dev->driver && dev->driver->pm)
+		cb = dev->driver->pm->runtime_resume;
 
-	return 0;
+	return cb ? cb(dev) : 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
