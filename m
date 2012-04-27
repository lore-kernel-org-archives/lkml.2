Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2D0Vto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:49:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2D0Vtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:49:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/2] PM / QoS: Create device constraints objects on notifier registration
Date: Fri, 27 Apr 2012 23:48:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl>
In-Reply-To: <201204272346.44145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204272348.18533.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current behavior of dev_pm_qos_add_notifier() makes device PM QoS
notifiers less than useful.  Namely, it silently returns success when
called before any PM QoS constraints are added for the device, so the
caller will assume that the notifier has been registered, but when
someone actually adds some nontrivial constraints for the device
eventually, the previous callers of dev_pm_qos_add_notifier()
will not know about that and their notifier routines will not be
executed (contrary to their expectations).

To address this problem make dev_pm_qos_add_notifier() create the
constraints object for the device if it is not present when the
routine is called.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/qos.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -352,21 +352,26 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_remove_requ
  *
  * Will register the notifier into a notification chain that gets called
  * upon changes to the target value for the device.
+ *
+ * If the device's constraints object doesn't exist when this routine is called,
+ * it will be created (or error code will be returned if that fails).
  */
 int dev_pm_qos_add_notifier(struct device *dev, struct notifier_block *notifier)
 {
-	int retval = 0;
+	int ret = 0;
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	/* Silently return if the constraints object is not present. */
-	if (dev->power.constraints)
-		retval = blocking_notifier_chain_register(
-				dev->power.constraints->notifiers,
-				notifier);
+	if (!dev->power.constraints)
+		ret = dev->power.power_state.event != PM_EVENT_INVALID ?
+			dev_pm_qos_constraints_allocate(dev) : -ENODEV;
+
+	if (!ret)
+		ret = blocking_notifier_chain_register(
+				dev->power.constraints->notifiers, notifier);
 
 	mutex_unlock(&dev_pm_qos_mtx);
-	return retval;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_notifier);
 

