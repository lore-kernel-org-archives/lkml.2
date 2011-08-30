Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1H3WV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:21:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1H3WVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:21:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for power.irq_safe set
Date: Wed, 31 Aug 2011 00:20:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
References: <201108310017.03103.rjw@sisk.pl>
In-Reply-To: <201108310017.03103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108310020.26104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The rpm_suspend() and rpm_resume() routines execute subsystem or PM
domain callbacks under power.lock if power.irq_safe is set for the
given device.  This is inconsistent with that rpm_idle() does after
commit 02b2677 (PM / Runtime: Allow _put_sync() from
interrupts-disabled context) and is problematic for subsystems and PM
domains wanting to use power.lock for synchronization in their
runtime PM callbacks.  For this reason, make runtime PM core functions
always release power.lock before invoking subsystem or PM domain
callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |   50 ++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -155,6 +155,31 @@ static int rpm_check_suspend_allowed(str
 }
 
 /**
+ * __rpm_callback - Run a given runtime PM callback for a given device.
+ * @cb: Runtime PM callback to run.
+ * @dev: Device to run the callback for.
+ */
+static int __rpm_callback(int (*cb)(struct device *), struct device *dev)
+	__releases(&dev->power.lock) __acquires(&dev->power.lock)
+{
+	int retval;
+
+	if (dev->power.irq_safe)
+		spin_unlock(&dev->power.lock);
+	else
+		spin_unlock_irq(&dev->power.lock);
+
+	retval = cb(dev);
+
+	if (dev->power.irq_safe)
+		spin_lock(&dev->power.lock);
+	else
+		spin_lock_irq(&dev->power.lock);
+
+	return retval;
+}
+
+/**
  * rpm_idle - Notify device bus type if the device can be suspended.
  * @dev: Device to notify the bus type about.
  * @rpmflags: Flag bits.
@@ -225,19 +250,8 @@ static int rpm_idle(struct device *dev,
 	else
 		callback = NULL;
 
-	if (callback) {
-		if (dev->power.irq_safe)
-			spin_unlock(&dev->power.lock);
-		else
-			spin_unlock_irq(&dev->power.lock);
-
-		callback(dev);
-
-		if (dev->power.irq_safe)
-			spin_lock(&dev->power.lock);
-		else
-			spin_lock_irq(&dev->power.lock);
-	}
+	if (callback)
+		__rpm_callback(callback, dev);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
@@ -252,22 +266,14 @@ static int rpm_idle(struct device *dev,
  * @dev: Device to run the callback for.
  */
 static int rpm_callback(int (*cb)(struct device *), struct device *dev)
-	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
 	int retval;
 
 	if (!cb)
 		return -ENOSYS;
 
-	if (dev->power.irq_safe) {
-		retval = cb(dev);
-	} else {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = cb(dev);
+	retval = __rpm_callback(cb, dev);
 
-		spin_lock_irq(&dev->power.lock);
-	}
 	dev->power.runtime_error = retval;
 	return retval != -EACCES ? retval : -EIO;
 }

