Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2HNXJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:09:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2HNXJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:09:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH][RFC][Update] PM / Runtime: Introduce driver runtime PM work routine
Date: Wed, 15 Aug 2012 01:15:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1208131737400.27622-100000@netrider.rowland.org> <201208140006.37977.rjw@sisk.pl>
In-Reply-To: <201208140006.37977.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208150115.35535.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 14, 2012, Rafael J. Wysocki wrote:
> On Monday, August 13, 2012, Alan Stern wrote:
> > On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:
> > 
> > > > I guess the best we can say is that if you call pm_runtime_barrier()  
> > > > after updating the dev_pm_ops method pointers then after the barrier
> > > > returns, the old method pointers will not be invoked and the old method
> > > > routines will not be running.  So we need an equivalent guarantee with
> > > > regard to the pm_runtime_work pointer.  (Yes, we could use a better 
> > > > name for that pointer.)
> > > > 
> > > > Which means the code in the patch isn't quite right, because it saves 
> > > > the pm_runtime_work pointer before calling rpm_resume().  Maybe we 
> > > > should avoid looking at the pointer until rpm_resume() returns.
> > > 
> > > Yes, we can do that.
> > > 
> > > Alternatively, we can set power.work_in_progress before calling
> > > rpm_resume(dev, 0) (i.e. regard the resume as a part of the work) to make
> > > the barrier wait for all of it to complete.
> > 
> > Yep, that would work.  In fact, I did it that way in the proposed code 
> > posted earlier in this thread.  (But that was just on general 
> > principles, not because I had this particular race in mind.)
> 
> OK
> 
> I need to prepare a new patch now, but first I'll send a couple of (minor)
> fixes for the core runtime PM code.

The new patch is appended along with the "motivation" part of the changelog.
It is on top of the following three patches posted earlier:

https://patchwork.kernel.org/patch/1323641/
https://patchwork.kernel.org/patch/1323661/
https://patchwork.kernel.org/patch/1323651/

I changed the new callback's name to .pm_async_work() to avoid the name
conflict with the pm_runtime_work() function.  I don't have a better idea
for its name at the moment.

Thanks,
Rafael


---
Unfortunately, pm_runtime_get() is not a very useful interface,
because if the device is not in the "active" state already, it
only queues up a work item supposed to resume the device.  Then,
the caller doesn't really know when the device is going to be
resumed which makes it difficult to synchronize future device
accesses with the resume completion.

In that case, if the caller is the device's driver, the most
straightforward way for it to cope with the situation is to use its
.runtime_resume() callback for data processing unrelated to the
resume itself, but the correctness of this is questionable.  Namely,
the driver's .runtime_resume() callback need not be executed directly
by the core and it may be run from within a subsystem or PM domain
callback.  Then, the data processing carried out by the driver's
callback may disturb the subsystem's or PM domain's functionality
(for example, the subsystem may still be unready for the device to
process I/O when the driver's callback is about to return).  Besides,
the .runtime_resume() callback is not supposed to do anything beyond
what is needed to resume the device.

For this reason, it appears to be necessary to introduce a mechanism
by which device drivers may schedule the execution of certain code
(say a procedure) to occur when the device in question is known to be
in the "active" state (preferably, as soon as it has been resumed).
Thus add a new runtime PM callback, .pm_async_work(), to struct
device_driver that will be executed along with the asynchronous
resume if pm_runtime_get() returns 0 (it may be executed once for
multiple subsequent invocations of pm_runtime_get() for the same
device, but if at least one of them returns 0, .pm_async_work() will
be executed at least once).

Additionally, define pm_runtime_get_nowork() that won't cause
the driver's .pm_async_work() callback to be executed.

This version of the patch doesn't include any documentation updates.

No sign-off yet.
---
 drivers/base/power/runtime.c |  111 ++++++++++++++++++++++++++++++-------------
 include/linux/device.h       |    2 
 include/linux/pm.h           |    2 
 include/linux/pm_runtime.h   |    6 ++
 4 files changed, 88 insertions(+), 33 deletions(-)

Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -203,6 +203,7 @@ extern struct klist *bus_get_device_klis
  *		automatically.
  * @pm:		Power management operations of the device which matched
  *		this driver.
+ * @pm_async_work: Called after asynchronous runtime resume of the device.
  * @p:		Driver core's private data, no one other than the driver
  *		core can touch this.
  *
@@ -232,6 +233,7 @@ struct device_driver {
 	const struct attribute_group **groups;
 
 	const struct dev_pm_ops *pm;
+	void (*pm_async_work) (struct device *dev);
 
 	struct driver_private *p;
 };
Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -538,6 +538,8 @@ struct dev_pm_info {
 	unsigned int		irq_safe:1;
 	unsigned int		use_autosuspend:1;
 	unsigned int		timer_autosuspends:1;
+	bool			run_driver_work:1;
+	bool			work_in_progress:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
Index: linux/include/linux/pm_runtime.h
===================================================================
--- linux.orig/include/linux/pm_runtime.h
+++ linux/include/linux/pm_runtime.h
@@ -22,6 +22,7 @@
 #define RPM_GET_PUT		0x04	/* Increment/decrement the
 					    usage_count */
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
+#define RPM_RUN_WORK		0x10	/* Run asynchronous work routine */
 
 #ifdef CONFIG_PM_RUNTIME
 
@@ -189,6 +190,11 @@ static inline int pm_request_autosuspend
 
 static inline int pm_runtime_get(struct device *dev)
 {
+	return __pm_runtime_resume(dev, RPM_GET_PUT | RPM_ASYNC | RPM_RUN_WORK);
+}
+
+static inline int pm_runtime_get_nowork(struct device *dev)
+{
 	return __pm_runtime_resume(dev, RPM_GET_PUT | RPM_ASYNC);
 }
 
Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -484,6 +484,15 @@ static int rpm_suspend(struct device *de
 	goto out;
 }
 
+void rpm_queue_up_resume(struct device *dev)
+{
+	dev->power.request = RPM_REQ_RESUME;
+	if (!dev->power.request_pending) {
+		dev->power.request_pending = true;
+		queue_work(pm_wq, &dev->power.work);
+	}
+}
+
 /**
  * rpm_resume - Carry out runtime resume of given device.
  * @dev: Device to resume.
@@ -495,8 +504,10 @@ static int rpm_suspend(struct device *de
  * RPM_NOWAIT and RPM_ASYNC flags.  Similarly, if there's a suspend running in
  * parallel with this function, either tell the other process to resume after
  * suspending (deferred_resume) or wait for it to finish.  If the RPM_ASYNC
- * flag is set then queue a resume request; otherwise run the
- * ->runtime_resume() callback directly.  Queue an idle notification for the
+ * flag is set, then queue a resume request and if the RPM_RUN_WORK flag is set
+ * too, schedule the executction of the device driver's .pm_async_work()
+ * callback after the resume request has been completed.  Otherwise run the
+ * .runtime_resume() callback directly and queue an idle notification for the
  * device if the resume succeeded.
  *
  * This function must be called under dev->power.lock with interrupts disabled.
@@ -519,12 +530,18 @@ static int rpm_resume(struct device *dev
 		goto out;
 
 	/*
-	 * Other scheduled or pending requests need to be canceled.  Small
-	 * optimization: If an autosuspend timer is running, leave it running
-	 * rather than cancelling it now only to restart it again in the near
-	 * future.
+	 * Other scheduled or pending requests need to be canceled.  If the
+	 * execution of driver work is queued up along with a resume request,
+	 * do not cancel it.
+	 */
+	if (dev->power.request != RPM_REQ_RESUME || !dev->power.run_driver_work)
+		dev->power.request = RPM_REQ_NONE;
+
+	/*
+	 * Small optimization: If an autosuspend timer is running, leave it
+	 * running rather than cancelling it now only to restart it again in the
+	 * near future.
 	 */
-	dev->power.request = RPM_REQ_NONE;
 	if (!dev->power.timer_autosuspends)
 		pm_runtime_deactivate_timer(dev);
 
@@ -533,6 +550,36 @@ static int rpm_resume(struct device *dev
 		goto out;
 	}
 
+	/*
+	 * See if we can skip waking up the parent.  This is safe only if
+	 * power.no_callbacks is set, because otherwise we don't know whether
+	 * the resume will actually succeed.
+	 */
+	if (dev->power.no_callbacks && !parent && dev->parent) {
+		spin_lock_nested(&dev->parent->power.lock, SINGLE_DEPTH_NESTING);
+		if (dev->parent->power.disable_depth > 0
+		    || dev->parent->power.ignore_children
+		    || dev->parent->power.runtime_status == RPM_ACTIVE) {
+			atomic_inc(&dev->parent->power.child_count);
+			spin_unlock(&dev->parent->power.lock);
+			retval = 1;
+			goto no_callback;	/* Assume success. */
+		}
+		spin_unlock(&dev->parent->power.lock);
+	}
+
+	/*
+	 * If the driver's asynchronous work routine is to be executed, schedule
+	 * it now.
+	 */
+	if (rpmflags & RPM_RUN_WORK) {
+		WARN_ON_ONCE(!(rpmflags & RPM_ASYNC));
+		dev->power.run_driver_work = true;
+		rpm_queue_up_resume(dev);
+		retval = 0;
+		goto out;
+	}
+
 	if (dev->power.runtime_status == RPM_RESUMING
 	    || dev->power.runtime_status == RPM_SUSPENDING) {
 		DEFINE_WAIT(wait);
@@ -572,31 +619,9 @@ static int rpm_resume(struct device *dev
 		goto repeat;
 	}
 
-	/*
-	 * See if we can skip waking up the parent.  This is safe only if
-	 * power.no_callbacks is set, because otherwise we don't know whether
-	 * the resume will actually succeed.
-	 */
-	if (dev->power.no_callbacks && !parent && dev->parent) {
-		spin_lock_nested(&dev->parent->power.lock, SINGLE_DEPTH_NESTING);
-		if (dev->parent->power.disable_depth > 0
-		    || dev->parent->power.ignore_children
-		    || dev->parent->power.runtime_status == RPM_ACTIVE) {
-			atomic_inc(&dev->parent->power.child_count);
-			spin_unlock(&dev->parent->power.lock);
-			retval = 1;
-			goto no_callback;	/* Assume success. */
-		}
-		spin_unlock(&dev->parent->power.lock);
-	}
-
 	/* Carry out an asynchronous or a synchronous resume. */
 	if (rpmflags & RPM_ASYNC) {
-		dev->power.request = RPM_REQ_RESUME;
-		if (!dev->power.request_pending) {
-			dev->power.request_pending = true;
-			queue_work(pm_wq, &dev->power.work);
-		}
+		rpm_queue_up_resume(dev);
 		retval = 0;
 		goto out;
 	}
@@ -716,7 +741,25 @@ static void pm_runtime_work(struct work_
 		rpm_suspend(dev, RPM_NOWAIT | RPM_AUTO);
 		break;
 	case RPM_REQ_RESUME:
-		rpm_resume(dev, RPM_NOWAIT);
+		if (!dev->power.run_driver_work
+		    || !dev->driver || !dev->driver->pm_async_work) {
+			rpm_resume(dev, RPM_NOWAIT);
+			break;
+		}
+
+		dev->power.run_driver_work = false;
+		dev->power.work_in_progress = true;
+		pm_runtime_get_noresume(dev);
+		rpm_resume(dev, 0);
+		spin_unlock_irq(&dev->power.lock);
+
+		dev->driver->pm_async_work(dev);
+
+		spin_lock_irq(&dev->power.lock);
+		dev->power.work_in_progress = false;
+		wake_up_all(&dev->power.wait_queue);
+		pm_runtime_put_noidle(dev);
+		rpm_idle(dev, RPM_NOWAIT);
 		break;
 	}
 
@@ -983,7 +1026,8 @@ static void __pm_runtime_barrier(struct
 
 	if (dev->power.runtime_status == RPM_SUSPENDING
 	    || dev->power.runtime_status == RPM_RESUMING
-	    || dev->power.idle_notification) {
+	    || dev->power.idle_notification
+	    || dev->power.work_in_progress) {
 		DEFINE_WAIT(wait);
 
 		/* Suspend, wake-up or idle notification in progress. */
@@ -992,7 +1036,8 @@ static void __pm_runtime_barrier(struct
 					TASK_UNINTERRUPTIBLE);
 			if (dev->power.runtime_status != RPM_SUSPENDING
 			    && dev->power.runtime_status != RPM_RESUMING
-			    && !dev->power.idle_notification)
+			    && !dev->power.idle_notification
+			    && !dev->power.work_in_progress)
 				break;
 			spin_unlock_irq(&dev->power.lock);
 
