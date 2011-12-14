Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab1LNXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:19:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1LNXTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:19:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/2 v2] PM / Sleep: Merge internal functions in generic_ops.c
Date: Thu, 15 Dec 2011 00:21:45 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201111180037.22157.rjw@sisk.pl> <201112100005.24798.rjw@sisk.pl> <201112150019.39645.rjw@sisk.pl>
In-Reply-To: <201112150019.39645.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112150021.45424.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After the change that removed the code related to runtime PM
from __pm_generic_call() and __pm_generic_resume() these two
functions need not be separate any more, so merge them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/generic_ops.c |   48 ++++++++-------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

Index: linux/drivers/base/power/generic_ops.c
===================================================================
--- linux.orig/drivers/base/power/generic_ops.c
+++ linux/drivers/base/power/generic_ops.c
@@ -97,7 +97,7 @@ int pm_generic_prepare(struct device *de
  * @event: PM transition of the system under way.
  * @bool: Whether or not this is the "noirq" stage.
  *
- * Execute the suspend/freeze/poweroff/thaw callback provided by the driver of
+ * Execute the PM callback corresponding to @event provided by the driver of
  * @dev, if defined, and return its error code.    Return 0 if the callback is
  * not present.
  */
@@ -119,9 +119,15 @@ static int __pm_generic_call(struct devi
 	case PM_EVENT_HIBERNATE:
 		callback = noirq ? pm->poweroff_noirq : pm->poweroff;
 		break;
+	case PM_EVENT_RESUME:
+		callback = noirq ? pm->resume_noirq : pm->resume;
+		break;
 	case PM_EVENT_THAW:
 		callback = noirq ? pm->thaw_noirq : pm->thaw;
 		break;
+	case PM_EVENT_RESTORE:
+		callback = noirq ? pm->restore_noirq : pm->restore;
+		break;
 	default:
 		callback = NULL;
 		break;
@@ -211,44 +217,12 @@ int pm_generic_thaw(struct device *dev)
 EXPORT_SYMBOL_GPL(pm_generic_thaw);
 
 /**
- * __pm_generic_resume - Generic resume/restore callback for subsystems.
- * @dev: Device to handle.
- * @event: PM transition of the system under way.
- * @bool: Whether or not this is the "noirq" stage.
- *
- * Execute the resume/resotre callback provided by the @dev's driver, if
- * defined, and return its error code.  Return 0 if the callback is not present.
- */
-static int __pm_generic_resume(struct device *dev, int event, bool noirq)
-{
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int (*callback)(struct device *);
-
-	if (!pm)
-		return 0;
-
-	switch (event) {
-	case PM_EVENT_RESUME:
-		callback = noirq ? pm->resume_noirq : pm->resume;
-		break;
-	case PM_EVENT_RESTORE:
-		callback = noirq ? pm->restore_noirq : pm->restore;
-		break;
-	default:
-		callback = NULL;
-		break;
-	}
-
-	return callback ? callback(dev) : 0;
-}
-
-/**
  * pm_generic_resume_noirq - Generic resume_noirq callback for subsystems.
  * @dev: Device to resume.
  */
 int pm_generic_resume_noirq(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESUME, true);
+	return __pm_generic_call(dev, PM_EVENT_RESUME, true);
 }
 EXPORT_SYMBOL_GPL(pm_generic_resume_noirq);
 
@@ -258,7 +232,7 @@ EXPORT_SYMBOL_GPL(pm_generic_resume_noir
  */
 int pm_generic_resume(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESUME, false);
+	return __pm_generic_call(dev, PM_EVENT_RESUME, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_resume);
 
@@ -268,7 +242,7 @@ EXPORT_SYMBOL_GPL(pm_generic_resume);
  */
 int pm_generic_restore_noirq(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESTORE, true);
+	return __pm_generic_call(dev, PM_EVENT_RESTORE, true);
 }
 EXPORT_SYMBOL_GPL(pm_generic_restore_noirq);
 
@@ -278,7 +252,7 @@ EXPORT_SYMBOL_GPL(pm_generic_restore_noi
  */
 int pm_generic_restore(struct device *dev)
 {
-	return __pm_generic_resume(dev, PM_EVENT_RESTORE, false);
+	return __pm_generic_call(dev, PM_EVENT_RESTORE, false);
 }
 EXPORT_SYMBOL_GPL(pm_generic_restore);
 

