Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1HTTby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:31:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab1HTTbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:31:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH 1/2] PM / Runtime: Introduce pm_runtime_irq_unsafe()
Date: Sat, 20 Aug 2011 21:32:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201108202131.19479.rjw@sisk.pl>
In-Reply-To: <201108202131.19479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108202132.13304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a helper function allowing drivers and subsystems to clear
the power.irq_safe device flag.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |    4 ++++
 drivers/base/power/runtime.c       |    9 +++++----
 include/linux/pm_runtime.h         |   13 ++++++++++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

Index: linux/include/linux/pm_runtime.h
===================================================================
--- linux.orig/include/linux/pm_runtime.h
+++ linux/include/linux/pm_runtime.h
@@ -40,7 +40,7 @@ extern int pm_generic_runtime_idle(struc
 extern int pm_generic_runtime_suspend(struct device *dev);
 extern int pm_generic_runtime_resume(struct device *dev);
 extern void pm_runtime_no_callbacks(struct device *dev);
-extern void pm_runtime_irq_safe(struct device *dev);
+extern void __pm_runtime_irq_safe(struct device *dev, bool irq_safe);
 extern void __pm_runtime_use_autosuspend(struct device *dev, bool use);
 extern void pm_runtime_set_autosuspend_delay(struct device *dev, int delay);
 extern unsigned long pm_runtime_autosuspend_expiration(struct device *dev);
@@ -102,6 +102,16 @@ static inline void pm_runtime_mark_last_
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+static inline void pm_runtime_irq_safe(struct device *dev)
+{
+	__pm_runtime_irq_safe(dev, true);
+}
+
+static inline void pm_runtime_irq_unsafe(struct device *dev)
+{
+	__pm_runtime_irq_safe(dev, false);
+}
+
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -143,6 +153,7 @@ static inline int pm_generic_runtime_sus
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
+static inline void pm_runtime_irq_unsafe(struct device *dev) {}
 
 static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -1109,22 +1109,23 @@ void pm_runtime_no_callbacks(struct devi
 EXPORT_SYMBOL_GPL(pm_runtime_no_callbacks);
 
 /**
- * pm_runtime_irq_safe - Leave interrupts disabled during callbacks.
+ * __pm_runtime_irq_safe - Manipulate a device's power.irq_safe flag.
  * @dev: Device to handle
+ * @irq_safe: Whether or not to leave interrupts disabled during callbacks.
  *
- * Set the power.irq_safe flag, which tells the PM core that the
+ * Set or unset the power.irq_safe flag, which tells the PM core that the
  * ->runtime_suspend() and ->runtime_resume() callbacks for this device should
  * always be invoked with the spinlock held and interrupts disabled.  It also
  * causes the parent's usage counter to be permanently incremented, preventing
  * the parent from runtime suspending -- otherwise an irq-safe child might have
  * to wait for a non-irq-safe parent.
  */
-void pm_runtime_irq_safe(struct device *dev)
+void __pm_runtime_irq_safe(struct device *dev, bool irq_safe)
 {
 	if (dev->parent)
 		pm_runtime_get_sync(dev->parent);
 	spin_lock_irq(&dev->power.lock);
-	dev->power.irq_safe = 1;
+	dev->power.irq_safe = irq_safe;
 	spin_unlock_irq(&dev->power.lock);
 }
 EXPORT_SYMBOL_GPL(pm_runtime_irq_safe);
Index: linux/Documentation/power/runtime_pm.txt
===================================================================
--- linux.orig/Documentation/power/runtime_pm.txt
+++ linux/Documentation/power/runtime_pm.txt
@@ -434,6 +434,10 @@ drivers/base/power/runtime.c and include
       suspend and resume callbacks (but not the idle callback) to be invoked
       with interrupts disabled
 
+  void pm_runtime_irq_unsafe(struct device *dev);
+    - clear the power.irq_safe flag for the device, causing the runtime-PM
+      callbacks to be invoked with interrupts enabled
+
   void pm_runtime_mark_last_busy(struct device *dev);
     - set the power.last_busy field to the current time
 

