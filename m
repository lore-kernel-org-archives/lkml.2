Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1K0Mis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:38:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1K0Miq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:38:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Sleep: Simplify generic system suspend callbacks
Date: Sun, 27 Nov 2011 13:41:36 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201111180037.22157.rjw@sisk.pl>
In-Reply-To: <201111180037.22157.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271341.36155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The pm_runtime_suspended() check in __pm_generic_call() doesn't
really help and may cause problems to happen, because in some cases
the system suspend callbacks need to be called even if the given
device has been suspended by runtime PM.  For example, if the device
generally supports remote wakeup and is not enabled to wake up
the system from sleep, it should be prevented from generating wakeup
signals during system suspend and that has to be done by the
suspend callbacks that the pm_runtime_suspended() check prevents from
being executed.

Similarly, it may not be a good idea to unconditionally change
the runtime PM status of the device to 'active' in
__pm_generic_resume(), because the driver may want to leave the
device in the 'suspended' state, depending on what happened to it
before the system suspend and whether or not it is enabled to
wake up the system.

For the above reasons, remove the pm_runtime_suspended()
check from __pm_generic_call() and remove the code changing the
device's runtime PM status from __pm_generic_resume().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/generic_ops.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux/drivers/base/power/generic_ops.c
===================================================================
--- linux.orig/drivers/base/power/generic_ops.c
+++ linux/drivers/base/power/generic_ops.c
@@ -106,7 +106,7 @@ static int __pm_generic_call(struct devi
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);
 
-	if (!pm || pm_runtime_suspended(dev))
+	if (!pm)
 		return 0;
 
 	switch (event) {
@@ -224,7 +224,6 @@ static int __pm_generic_resume(struct de
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);
-	int ret;
 
 	if (!pm)
 		return 0;
@@ -241,17 +240,7 @@ static int __pm_generic_resume(struct de
 		break;
 	}
 
-	if (!callback)
-		return 0;
-
-	ret = callback(dev);
-	if (!ret && !noirq && pm_runtime_enabled(dev)) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
-
-	return ret;
+	return callback ? callback(dev) : 0;
 }
 
 /**

