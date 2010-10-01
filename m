Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0JAWir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 18:38:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0JAWio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 18:38:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] PM / Runtime: Reduce code duplication in core helper functions (was: Re: [linux-pm] [PATCH] PM: add synchronous ...)
Date: Sat, 2 Oct 2010 00:37:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1010011011380.1813-100000@iolanthe.rowland.org> <201010012314.38089.rjw@sisk.pl>
In-Reply-To: <201010012314.38089.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010020037.55277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 01, 2010, Rafael J. Wysocki wrote:
> On Friday, October 01, 2010, Alan Stern wrote:
> > On Fri, 1 Oct 2010, Rafael J. Wysocki wrote:
> > 
> > > On Thursday, September 30, 2010, Alan Stern wrote:
> > > > This patch (as1431) adds a synchronous runtime-PM interface suitable
> > > > for use in interrupt handlers.  Four new helper functions are defined:
> > > > 
> > > > 	pm_runtime_suspend_irq(), pm_runtime_resume_irq(),
> > > > 	pm_runtime_get_sync_irq(), pm_runtime_put_sync_irq(),
> > > > 
> > > > together with pm_runtime_callbacks_in_irq(), which subsystems use to
> > > > tell the PM core that the runtime callbacks should be invoked with
> > > > interrupts disabled.
> > > 
> > > BTW, I like some changes made by your patch that aren't really related to
> > > the issue at hand, so I think the patch below can be applied regardless of
> > > the other changes, unless I made a mistake I can see now.
> > 
> > It looks like a good change, but you forgot to preserve the assignments 
> > to dev->power.runtime_error.
> 
> That's correct and there's a difference betwee _idle and the other cases
> because of that.  I'll send updated patch with a changelog shortly.

Appended as promised.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Reduce code duplication in core helper functions

Reduce code duplication in rpm_idle(), rpm_suspend() and rpm_resume()
by using local pointers to store callback addresses and moving some
duplicated code into a separate function.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |  122 +++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 68 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -153,7 +153,6 @@ static int rpm_check_suspend_allowed(str
 	return retval;
 }
 
-
 /**
  * rpm_idle - Notify device bus type if the device can be suspended.
  * @dev: Device to notify the bus type about.
@@ -167,8 +166,8 @@ static int rpm_check_suspend_allowed(str
  * This function must be called under dev->power.lock with interrupts disabled.
  */
 static int rpm_idle(struct device *dev, int rpmflags)
-	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
+	int (*callback)(struct device *);
 	int retval;
 
 	retval = rpm_check_suspend_allowed(dev);
@@ -214,23 +213,19 @@ static int rpm_idle(struct device *dev, 
 
 	dev->power.idle_notification = true;
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle) {
-		spin_unlock_irq(&dev->power.lock);
-
-		dev->bus->pm->runtime_idle(dev);
-
-		spin_lock_irq(&dev->power.lock);
-	} else if (dev->type && dev->type->pm && dev->type->pm->runtime_idle) {
-		spin_unlock_irq(&dev->power.lock);
-
-		dev->type->pm->runtime_idle(dev);
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_idle)
+		callback = dev->bus->pm->runtime_idle;
+	else if (dev->type && dev->type->pm && dev->type->pm->runtime_idle)
+		callback = dev->type->pm->runtime_idle;
+	else if (dev->class && dev->class->pm)
+		callback = dev->class->pm->runtime_idle;
+	else
+		callback = NULL;
 
-		spin_lock_irq(&dev->power.lock);
-	} else if (dev->class && dev->class->pm
-	    && dev->class->pm->runtime_idle) {
+	if (callback) {
 		spin_unlock_irq(&dev->power.lock);
 
-		dev->class->pm->runtime_idle(dev);
+		callback(dev);
 
 		spin_lock_irq(&dev->power.lock);
 	}
@@ -243,6 +238,29 @@ static int rpm_idle(struct device *dev, 
 }
 
 /**
+ * rpm_callback - Run a given runtime PM callback for a given device.
+ * @cb: Runtime PM callback to run.
+ * @dev: Device to run the callback for.
+ */
+static int rpm_callback(int (*cb)(struct device *), struct device *dev)
+	__releases(&dev->power.lock) __acquires(&dev->power.lock)
+{
+	int retval;
+
+	if (!cb)
+		return -ENOSYS;
+
+	spin_unlock_irq(&dev->power.lock);
+
+	retval = cb(dev);
+
+	spin_lock_irq(&dev->power.lock);
+	dev->power.runtime_error = retval;
+
+	return retval;
+}
+
+/**
  * rpm_suspend - Carry out run-time suspend of given device.
  * @dev: Device to suspend.
  * @rpmflags: Flag bits.
@@ -261,6 +279,7 @@ static int rpm_idle(struct device *dev, 
 static int rpm_suspend(struct device *dev, int rpmflags)
 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
+	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	bool notify = false;
 	int retval;
@@ -351,33 +370,16 @@ static int rpm_suspend(struct device *de
 
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->bus->pm->runtime_suspend(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else if (dev->type && dev->type->pm
-	    && dev->type->pm->runtime_suspend) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->type->pm->runtime_suspend(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else if (dev->class && dev->class->pm
-	    && dev->class->pm->runtime_suspend) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->class->pm->runtime_suspend(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else {
-		retval = -ENOSYS;
-	}
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend)
+		callback = dev->bus->pm->runtime_suspend;
+	else if (dev->type && dev->type->pm && dev->type->pm->runtime_suspend)
+		callback = dev->type->pm->runtime_suspend;
+	else if (dev->class && dev->class->pm)
+		callback = dev->class->pm->runtime_suspend;
+	else
+		callback = NULL;
 
+	retval = rpm_callback(callback, dev);
 	if (retval) {
 		__update_runtime_status(dev, RPM_ACTIVE);
 		dev->power.deferred_resume = 0;
@@ -443,6 +445,7 @@ static int rpm_suspend(struct device *de
 static int rpm_resume(struct device *dev, int rpmflags)
 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
 {
+	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	int retval = 0;
 
@@ -563,33 +566,16 @@ static int rpm_resume(struct device *dev
 
 	__update_runtime_status(dev, RPM_RESUMING);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->bus->pm->runtime_resume(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else if (dev->type && dev->type->pm
-	    && dev->type->pm->runtime_resume) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->type->pm->runtime_resume(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else if (dev->class && dev->class->pm
-	    && dev->class->pm->runtime_resume) {
-		spin_unlock_irq(&dev->power.lock);
-
-		retval = dev->class->pm->runtime_resume(dev);
-
-		spin_lock_irq(&dev->power.lock);
-		dev->power.runtime_error = retval;
-	} else {
-		retval = -ENOSYS;
-	}
+	if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_resume)
+		callback = dev->bus->pm->runtime_resume;
+	else if (dev->type && dev->type->pm && dev->type->pm->runtime_resume)
+		callback = dev->type->pm->runtime_resume;
+	else if (dev->class && dev->class->pm)
+		callback = dev->class->pm->runtime_resume;
+	else
+		callback = NULL;
 
+	retval = rpm_callback(callback, dev);
 	if (retval) {
 		__update_runtime_status(dev, RPM_SUSPENDED);
 		pm_runtime_cancel_pending(dev);
