Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1FSODe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 10:03:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab1FSODc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 10:03:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
Date: Sun, 19 Jun 2011 16:04:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <Pine.LNX.4.44L0.1106182137100.3523-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106182137100.3523-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191604.11074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 19, 2011, Alan Stern wrote:
> On Sun, 19 Jun 2011, Rafael J. Wysocki wrote:
> 
> > On Saturday, June 18, 2011, Rafael J. Wysocki wrote:
> > > On Saturday, June 18, 2011, Alan Stern wrote:
> > > > On Sat, 18 Jun 2011, Rafael J. Wysocki wrote:
> > ...
> > > 
> > > Well, assuming that https://patchwork.kernel.org/patch/893722/ is applied,
> > > which is going to be, I think we can put
> > > 
> > > +       pm_runtime_get_noresume(dev);
> > > +       pm_runtime_enable(dev);
> > > 
> > > in device_resume() after the dev->power.is_suspended check and
> > > pm_runtime_put_noidle() under the End label.  That cause them to
> > > be called under the device lock, but that shouldn't be a big deal.
> > > 
> > > Accordingly, we can call pm_runtime_disable(dev) in __device_suspend(),
> > > right next to the setting of power.is_suspended.
> > > 
> > > This is implemented by the patch below.
> > 
> > Well, it hangs suspend on my Toshiba test box, I'm not sure why exactly.
> > 
> > This happens even if the pm_runtime_disable() is replaced with a version
> > that only increments the disable depth, so it looks like something down
> > the road relies on disable_depth being zero.  Which is worrisome.
> 
> This is a sign that the PM subsystem is getting a little too 
> complicated.  :-(

Well, that was kind of difficult to debug, but not impossible. :-)

The problem here turns out to be related to the SCSI subsystem.
Namely, when the AHCI controller is suspended, it uses the SCSI error
handling mechanism for scheduling the suspend operation (I'm still at a little
loss why that is necessary, but Tejun says it is :-)).  This (after several
convoluted operations) causes scsi_error_handler() to be woken up and
it calls scsi_autopm_get_host(shost), which returns error code (-EAGAIN),
because the runtime PM has been disabled at the host level.

This happens because scsi_autopm_get_host() uses
pm_runtime_get_sync(&shost->shost_gendev) and returns error code when
shost_gendev.power.disable_depth is nonzero.

So, the problem is either in scsi_autopm_get_host() that should check the
error code returned by pm_runtime_get_sync(), or in rpm_suspend() that should
return 0 if RPM_GET_PUT is set in flags.  I'm inclined to say that the
problem should be fixed in rpm_suspend() and hence the appended patch that
works (well, it probably should be split into three separate patches).

> > Trying to figure out what the problem is I noticed that, for example,
> > the generic PM operations use pm_runtime_suspended() to decide whether or
> > not to execute system suspend callbacks, so the patch below would break it.
> > 
> > Also, after commit e8665002477f0278f84f898145b1f141ba26ee26 the
> > pm_runtime_suspended() check in __pm_generic_call() doesn't really make
> > sense.
> 
> In light of the recent changes, we should revisit the decisions behind 
> the generic PM operations.

Certainly, although the situation is not as bad as I thought, because
__pm_generic_call() is executed after the patch below disables runtime PM
during system suspend.  Still, the pm_runtime_suspended() check in there is
pointless.

Thanks,
Rafael

---
 drivers/base/power/main.c    |    9 ++++++++-
 drivers/base/power/runtime.c |   41 ++++++++++++++++++++++++-----------------
 include/linux/pm_runtime.h   |   13 ++++++++++---
 3 files changed, 42 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -521,6 +521,9 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_enable(dev);
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pwr_domain->ops, state);
@@ -557,6 +560,7 @@ static int device_resume(struct device *
 
  End:
 	dev->power.is_suspended = false;
+	pm_runtime_put_noidle(dev);
 
  Unlock:
 	device_unlock(dev);
@@ -888,7 +892,10 @@ static int __device_suspend(struct devic
 	}
 
  End:
-	dev->power.is_suspended = !error;
+	if (!error) {
+		dev->power.is_suspended = true;
+		__pm_runtime_disable(dev, PRD_DEPTH);
+	}
 
  Unlock:
 	device_unlock(dev);
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -455,12 +455,14 @@ static int rpm_resume(struct device *dev
 	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
 
  repeat:
-	if (dev->power.runtime_error)
+	if (dev->power.runtime_error) {
 		retval = -EINVAL;
-	else if (dev->power.disable_depth > 0)
-		retval = -EAGAIN;
-	if (retval)
 		goto out;
+	} else if (dev->power.disable_depth > 0) {
+		if (!(rpmflags & RPM_GET_PUT))
+			retval = -EAGAIN;
+		goto out;
+	}
 
 	/*
 	 * Other scheduled or pending requests need to be canceled.  Small
@@ -965,18 +967,23 @@ EXPORT_SYMBOL_GPL(pm_runtime_barrier);
 /**
  * __pm_runtime_disable - Disable run-time PM of a device.
  * @dev: Device to handle.
- * @check_resume: If set, check if there's a resume request for the device.
+ * @level: How much to do.
+ *
+ * Increment power.disable_depth for the device and if was zero previously.
+ *
+ * If @level is at least PRD_BARRIER, additionally cancel all pending run-time
+ * PM requests for the device and wait for all operations in progress to
+ * complete.
+ *
+ * If @level is at least PRD_CHECK_RESUME and there's a resume request pending
+ * when this function is called, and power.disable_depth is zero, the device
+ * will be woken up before disabling its run-time PM.
+ *
+ * The device can be either active or suspended after its run-time PM has been
+ * disabled.
  *
- * Increment power.disable_depth for the device and if was zero previously,
- * cancel all pending run-time PM requests for the device and wait for all
- * operations in progress to complete.  The device can be either active or
- * suspended after its run-time PM has been disabled.
- *
- * If @check_resume is set and there's a resume request pending when
- * __pm_runtime_disable() is called and power.disable_depth is zero, the
- * function will wake up the device before disabling its run-time PM.
  */
-void __pm_runtime_disable(struct device *dev, bool check_resume)
+void __pm_runtime_disable(struct device *dev, enum prd_level level)
 {
 	spin_lock_irq(&dev->power.lock);
 
@@ -990,7 +997,7 @@ void __pm_runtime_disable(struct device
 	 * means there probably is some I/O to process and disabling run-time PM
 	 * shouldn't prevent the device from processing the I/O.
 	 */
-	if (check_resume && dev->power.request_pending
+	if (level >= PRD_CHECK_RESUME && dev->power.request_pending
 	    && dev->power.request == RPM_REQ_RESUME) {
 		/*
 		 * Prevent suspends and idle notifications from being carried
@@ -1003,7 +1010,7 @@ void __pm_runtime_disable(struct device
 		pm_runtime_put_noidle(dev);
 	}
 
-	if (!dev->power.disable_depth++)
+	if (!dev->power.disable_depth++ && level >= PRD_BARRIER)
 		__pm_runtime_barrier(dev);
 
  out:
@@ -1230,7 +1237,7 @@ void pm_runtime_init(struct device *dev)
  */
 void pm_runtime_remove(struct device *dev)
 {
-	__pm_runtime_disable(dev, false);
+	__pm_runtime_disable(dev, PRD_BARRIER);
 
 	/* Change the status back to 'suspended' to match the initial status. */
 	if (dev->power.runtime_status == RPM_ACTIVE)
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -22,6 +22,13 @@
 					    usage_count */
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
 
+/* Runtime PM disable levels */
+enum prd_level {
+	PRD_DEPTH = 0,		/* Only increment disable depth */
+	PRD_BARRIER,		/* Additionally, act as a runtime PM barrier */
+	PRD_CHECK_RESUME,	/* Additionally, check if resume is pending */
+};
+
 #ifdef CONFIG_PM_RUNTIME
 
 extern struct workqueue_struct *pm_wq;
@@ -33,7 +40,7 @@ extern int pm_schedule_suspend(struct de
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
-extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern void __pm_runtime_disable(struct device *dev, enum prd_level level);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
 extern int pm_generic_runtime_idle(struct device *dev);
@@ -119,7 +126,7 @@ static inline int __pm_runtime_set_statu
 					    unsigned int status) { return 0; }
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
 static inline void pm_runtime_enable(struct device *dev) {}
-static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline void __pm_runtime_disable(struct device *dev, enum prd_level l) {}
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
@@ -232,7 +239,7 @@ static inline void pm_runtime_set_suspen
 
 static inline void pm_runtime_disable(struct device *dev)
 {
-	__pm_runtime_disable(dev, true);
+	__pm_runtime_disable(dev, PRD_CHECK_RESUME);
 }
 
 static inline void pm_runtime_use_autosuspend(struct device *dev)
