Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab1I2Ubm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:31:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab1I2Ubk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:31:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 3/3] PM / QoS: Add function dev_pm_qos_read_value() (v2)
Date: Thu, 29 Sep 2011 22:33:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Ming Lei <tom.leiming@gmail.com>
References: <201108310017.03103.rjw@sisk.pl> <201109242326.48485.rjw@sisk.pl> <CAORVsuUopAWQuFkn1cURiv+YhEUT6=SQV5NRL5N1Y1oYn9d2NQ@mail.gmail.com>
In-Reply-To: <CAORVsuUopAWQuFkn1cURiv+YhEUT6=SQV5NRL5N1Y1oYn9d2NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109292233.52378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, September 29, 2011, Jean Pihet wrote:
> Hi Rafael,
> 
> I have a few minor remarks, inlined below.

In the meantime it turned out that the patch caused a build failure
for CONFIG_PM_SLEEP unset (your original patches won't really work
in this case too), so I posted a patch to fix it.  However, since
you had remarks anyway, I've simply folded the fix into the next
version of the $subject patch, which is appended.

> On Sat, Sep 24, 2011 at 11:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > To read the current PM QoS value for a given device we need to
> > make sure that the device's power.constraints object won't be
> > removed while we're doing that.  For this reason, put the
> > operation under dev->power.lock and acquire the lock
> > around the initialization and removal of power.constraints.
> >
> > Moreover, since we're using the value of power.constraints to
> > determine whether or not the object is present, the
> > power.constraints_state field isn't necessary any more and may be
> > removed.  However, dev_pm_qos_add_request() needs to check if the
> > device is being removed from the system before allocating a new
> > PM QoS constraints object for it, so it has to use device_pm_lock()
> > and the device PM QoS initialization and destruction should be done
> > under device_pm_lock() as well.
> It might be good to mention dev_pm_qos_mtx which is used internally by
> the per-device PM QoS code.
> 
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Other then the minor remarks:
> Acked-by: Jean Pihet <j-pihet@ti.com>
> 
> > ---
> >  drivers/base/power/main.c |    4 -
> >  drivers/base/power/qos.c  |  168 ++++++++++++++++++++++++++--------------------
> >  include/linux/pm.h        |    8 --
> >  include/linux/pm_qos.h    |    3
> >  4 files changed, 103 insertions(+), 80 deletions(-)
> >
> > Index: linux/drivers/base/power/qos.c
> > ===================================================================
> > --- linux.orig/drivers/base/power/qos.c
> > +++ linux/drivers/base/power/qos.c
> ...
> 
> >
> > +static void __dev_pm_qos_constraints_init(struct device *dev)
> I would change the name or add a comment stating that this is an
> internal function which reinits the constraints field under the lock.

This function was used only once, so it wasn't really necessary.  I simply
removed it.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / QoS: Add function dev_pm_qos_read_value() (v3)

To read the current PM QoS value for a given device we need to
make sure that the device's power.constraints object won't be
removed while we're doing that.  For this reason, put the
operation under dev->power.lock and acquire the lock
around the initialization and removal of power.constraints.

Moreover, since we're using the value of power.constraints to
determine whether or not the object is present, the
power.constraints_state field isn't necessary any more and may be
removed.  However, dev_pm_qos_add_request() needs to check if the
device is being removed from the system before allocating a new
PM QoS constraints object for it, so make it use the
power.power_state field of struct device for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c  |    6 -
 drivers/base/power/power.h |   10 ++
 drivers/base/power/qos.c   |  160 +++++++++++++++++++++++++--------------------
 include/linux/pm.h         |   10 --
 include/linux/pm_qos.h     |   12 ++-
 5 files changed, 114 insertions(+), 84 deletions(-)

Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -30,15 +30,6 @@
  * . To minimize the data usage by the per-device constraints, the data struct
  *   is only allocated at the first call to dev_pm_qos_add_request.
  * . The data is later free'd when the device is removed from the system.
- * . The constraints_state variable from dev_pm_info tracks the data struct
- *    allocation state:
- *    DEV_PM_QOS_NO_DEVICE: No device present or device removed, no data
- *     allocated,
- *    DEV_PM_QOS_DEVICE_PRESENT: Device present, data not allocated and will be
- *     allocated at the first call to dev_pm_qos_add_request,
- *    DEV_PM_QOS_ALLOCATED: Device present, data allocated. The per-device
- *     PM QoS constraints framework is operational and constraints can be
- *     added, updated or removed using the dev_pm_qos_* API.
  *  . A global mutex protects the constraints users from the data being
  *     allocated and free'd.
  */
@@ -51,8 +42,30 @@
 
 
 static DEFINE_MUTEX(dev_pm_qos_mtx);
+
 static BLOCKING_NOTIFIER_HEAD(dev_pm_notifiers);
 
+/**
+ * dev_pm_qos_read_value - Get PM QoS constraint for a given device.
+ * @dev: Device to get the PM QoS constraint value for.
+ */
+s32 dev_pm_qos_read_value(struct device *dev)
+{
+	struct pm_qos_constraints *c;
+	unsigned long flags;
+	s32 ret = 0;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	c = dev->power.constraints;
+	if (c)
+		ret = pm_qos_read_value(c);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return ret;
+}
+
 /*
  * apply_constraint
  * @req: constraint request to apply
@@ -105,27 +118,31 @@ static int dev_pm_qos_constraints_alloca
 	}
 	BLOCKING_INIT_NOTIFIER_HEAD(n);
 
+	plist_head_init(&c->list);
+	c->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
+	c->default_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
+	c->type = PM_QOS_MIN;
+	c->notifiers = n;
+
+	spin_lock_irq(&dev->power.lock);
 	dev->power.constraints = c;
-	plist_head_init(&dev->power.constraints->list);
-	dev->power.constraints->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
-	dev->power.constraints->default_value =	PM_QOS_DEV_LAT_DEFAULT_VALUE;
-	dev->power.constraints->type = PM_QOS_MIN;
-	dev->power.constraints->notifiers = n;
-	dev->power.constraints_state = DEV_PM_QOS_ALLOCATED;
+	spin_unlock_irq(&dev->power.lock);
 
 	return 0;
 }
 
 /**
- * dev_pm_qos_constraints_init
+ * dev_pm_qos_constraints_init - Initalize device's PM QoS constraints pointer.
  * @dev: target device
  *
- * Called from the device PM subsystem at device insertion
+ * Called from the device PM subsystem during device insertion under
+ * device_pm_lock().
  */
 void dev_pm_qos_constraints_init(struct device *dev)
 {
 	mutex_lock(&dev_pm_qos_mtx);
-	dev->power.constraints_state = DEV_PM_QOS_DEVICE_PRESENT;
+	dev->power.constraints = NULL;
+	dev->power.power_state = PMSG_ON;
 	mutex_unlock(&dev_pm_qos_mtx);
 }
 
@@ -133,34 +150,38 @@ void dev_pm_qos_constraints_init(struct
  * dev_pm_qos_constraints_destroy
  * @dev: target device
  *
- * Called from the device PM subsystem at device removal
+ * Called from the device PM subsystem on device removal under device_pm_lock().
  */
 void dev_pm_qos_constraints_destroy(struct device *dev)
 {
 	struct dev_pm_qos_request *req, *tmp;
+	struct pm_qos_constraints *c;
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
-		/* Flush the constraints list for the device */
-		plist_for_each_entry_safe(req, tmp,
-					  &dev->power.constraints->list,
-					  node) {
-			/*
-			 * Update constraints list and call the notification
-			 * callbacks if needed
-			 */
-			apply_constraint(req, PM_QOS_REMOVE_REQ,
-					 PM_QOS_DEFAULT_VALUE);
-			memset(req, 0, sizeof(*req));
-		}
+	dev->power.power_state = PMSG_INVALID;
+	c = dev->power.constraints;
+	if (!c)
+		goto out;
 
-		kfree(dev->power.constraints->notifiers);
-		kfree(dev->power.constraints);
-		dev->power.constraints = NULL;
+	/* Flush the constraints list for the device */
+	plist_for_each_entry_safe(req, tmp, &c->list, node) {
+		/*
+		 * Update constraints list and call the notification
+		 * callbacks if needed
+		 */
+		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
+		memset(req, 0, sizeof(*req));
 	}
-	dev->power.constraints_state = DEV_PM_QOS_NO_DEVICE;
 
+	spin_lock_irq(&dev->power.lock);
+	dev->power.constraints = NULL;
+	spin_unlock_irq(&dev->power.lock);
+
+	kfree(c->notifiers);
+	kfree(c);
+
+ out:
 	mutex_unlock(&dev_pm_qos_mtx);
 }
 
@@ -178,8 +199,9 @@ void dev_pm_qos_constraints_destroy(stru
  *
  * Returns 1 if the aggregated constraint value has changed,
  * 0 if the aggregated constraint value has not changed,
- * -EINVAL in case of wrong parameters, -ENODEV if the device has been
- * removed from the system
+ * -EINVAL in case of wrong parameters, -ENOMEM if there's not enough memory
+ * to allocate for data structures, -ENODEV if the device has just been removed
+ * from the system.
  */
 int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
 			   s32 value)
@@ -195,28 +217,32 @@ int dev_pm_qos_add_request(struct device
 		return -EINVAL;
 	}
 
-	mutex_lock(&dev_pm_qos_mtx);
 	req->dev = dev;
 
-	/* Return if the device has been removed */
-	if (req->dev->power.constraints_state == DEV_PM_QOS_NO_DEVICE) {
-		ret = -ENODEV;
-		goto out;
-	}
+	mutex_lock(&dev_pm_qos_mtx);
 
-	/*
-	 * Allocate the constraints data on the first call to add_request,
-	 * i.e. only if the data is not already allocated and if the device has
-	 * not been removed
-	 */
-	if (dev->power.constraints_state == DEV_PM_QOS_DEVICE_PRESENT)
-		ret = dev_pm_qos_constraints_allocate(dev);
+	if (!dev->power.constraints) {
+		if (dev->power.power_state.event == PM_EVENT_INVALID) {
+			/* The device has been removed from the system. */
+			req->dev = NULL;
+			ret = -ENODEV;
+			goto out;
+		} else {
+			/*
+			 * Allocate the constraints data on the first call to
+			 * add_request, i.e. only if the data is not already
+			 * allocated and if the device has not been removed.
+			 */
+			ret = dev_pm_qos_constraints_allocate(dev);
+		}
+	}
 
 	if (!ret)
 		ret = apply_constraint(req, PM_QOS_ADD_REQ, value);
 
-out:
+ out:
 	mutex_unlock(&dev_pm_qos_mtx);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_add_request);
@@ -252,7 +278,7 @@ int dev_pm_qos_update_request(struct dev
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (req->dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
+	if (req->dev->power.constraints) {
 		if (new_value != req->node.prio)
 			ret = apply_constraint(req, PM_QOS_UPDATE_REQ,
 					       new_value);
@@ -293,7 +319,7 @@ int dev_pm_qos_remove_request(struct dev
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (req->dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
+	if (req->dev->power.constraints) {
 		ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
 				       PM_QOS_DEFAULT_VALUE);
 		memset(req, 0, sizeof(*req));
@@ -323,15 +349,12 @@ int dev_pm_qos_add_notifier(struct devic
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	/* Silently return if the device has been removed */
-	if (dev->power.constraints_state != DEV_PM_QOS_ALLOCATED)
-		goto out;
-
-	retval = blocking_notifier_chain_register(
-			dev->power.constraints->notifiers,
-			notifier);
+	/* Silently return if the constraints object is not present. */
+	if (dev->power.constraints)
+		retval = blocking_notifier_chain_register(
+				dev->power.constraints->notifiers,
+				notifier);
 
-out:
 	mutex_unlock(&dev_pm_qos_mtx);
 	return retval;
 }
@@ -354,15 +377,12 @@ int dev_pm_qos_remove_notifier(struct de
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	/* Silently return if the device has been removed */
-	if (dev->power.constraints_state != DEV_PM_QOS_ALLOCATED)
-		goto out;
-
-	retval = blocking_notifier_chain_unregister(
-			dev->power.constraints->notifiers,
-			notifier);
+	/* Silently return if the constraints object is not present. */
+	if (dev->power.constraints)
+		retval = blocking_notifier_chain_unregister(
+				dev->power.constraints->notifiers,
+				notifier);
 
-out:
 	mutex_unlock(&dev_pm_qos_mtx);
 	return retval;
 }
Index: linux/include/linux/pm_qos.h
===================================================================
--- linux.orig/include/linux/pm_qos.h
+++ linux/include/linux/pm_qos.h
@@ -7,6 +7,7 @@
 #include <linux/plist.h>
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
+#include <linux/device.h>
 
 #define PM_QOS_RESERVED 0
 #define PM_QOS_CPU_DMA_LATENCY 1
@@ -77,6 +78,7 @@ int pm_qos_remove_notifier(int pm_qos_cl
 int pm_qos_request_active(struct pm_qos_request *req);
 s32 pm_qos_read_value(struct pm_qos_constraints *c);
 
+s32 dev_pm_qos_read_value(struct device *dev);
 int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
 			   s32 value);
 int dev_pm_qos_update_request(struct dev_pm_qos_request *req, s32 new_value);
@@ -117,6 +119,8 @@ static inline int pm_qos_request_active(
 static inline s32 pm_qos_read_value(struct pm_qos_constraints *c)
 			{ return 0; }
 
+static inline s32 dev_pm_qos_read_value(struct device *dev)
+			{ return 0; }
 static inline int dev_pm_qos_add_request(struct device *dev,
 					 struct dev_pm_qos_request *req,
 					 s32 value)
@@ -139,9 +143,13 @@ static inline int dev_pm_qos_remove_glob
 					struct notifier_block *notifier)
 			{ return 0; }
 static inline void dev_pm_qos_constraints_init(struct device *dev)
-			{ return; }
+{
+	dev->power.power_state = PMSG_ON;
+}
 static inline void dev_pm_qos_constraints_destroy(struct device *dev)
-			{ return; }
+{
+	dev->power.power_state = PMSG_INVALID;
+}
 #endif
 
 #endif
Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -22,7 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
-#include <linux/pm_qos.h>
 #include <linux/resume-trace.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -67,6 +66,7 @@ void device_pm_init(struct device *dev)
 	spin_lock_init(&dev->power.lock);
 	pm_runtime_init(dev);
 	INIT_LIST_HEAD(&dev->power.entry);
+	dev->power.power_state = PMSG_INVALID;
 }
 
 /**
@@ -98,8 +98,8 @@ void device_pm_add(struct device *dev)
 		dev_warn(dev, "parent %s should not be sleeping\n",
 			dev_name(dev->parent));
 	list_add_tail(&dev->power.entry, &dpm_list);
-	mutex_unlock(&dpm_list_mtx);
 	dev_pm_qos_constraints_init(dev);
+	mutex_unlock(&dpm_list_mtx);
 }
 
 /**
@@ -110,9 +110,9 @@ void device_pm_remove(struct device *dev
 {
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
-	dev_pm_qos_constraints_destroy(dev);
 	complete_all(&dev->power.completion);
 	mutex_lock(&dpm_list_mtx);
+	dev_pm_qos_constraints_destroy(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 	device_wakeup_disable(dev);
Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -326,6 +326,7 @@ extern struct dev_pm_ops generic_subsys_
  *			requested by a driver.
  */
 
+#define PM_EVENT_INVALID	(-1)
 #define PM_EVENT_ON		0x0000
 #define PM_EVENT_FREEZE 	0x0001
 #define PM_EVENT_SUSPEND	0x0002
@@ -346,6 +347,7 @@ extern struct dev_pm_ops generic_subsys_
 #define PM_EVENT_AUTO_SUSPEND	(PM_EVENT_AUTO | PM_EVENT_SUSPEND)
 #define PM_EVENT_AUTO_RESUME	(PM_EVENT_AUTO | PM_EVENT_RESUME)
 
+#define PMSG_INVALID	((struct pm_message){ .event = PM_EVENT_INVALID, })
 #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
 #define PMSG_QUIESCE	((struct pm_message){ .event = PM_EVENT_QUIESCE, })
@@ -421,13 +423,6 @@ enum rpm_request {
 	RPM_REQ_RESUME,
 };
 
-/* Per-device PM QoS constraints data struct state */
-enum dev_pm_qos_state {
-	DEV_PM_QOS_NO_DEVICE,		/* No device present */
-	DEV_PM_QOS_DEVICE_PRESENT,	/* Device present, data not allocated */
-	DEV_PM_QOS_ALLOCATED,		/* Device present, data allocated */
-};
-
 struct wakeup_source;
 
 struct pm_domain_data {
@@ -489,7 +484,6 @@ struct dev_pm_info {
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
 	struct pm_qos_constraints *constraints;
-	enum dev_pm_qos_state	constraints_state;
 };
 
 extern void update_pm_runtime_accounting(struct device *dev);
Index: linux/drivers/base/power/power.h
===================================================================
--- linux.orig/drivers/base/power/power.h
+++ linux/drivers/base/power/power.h
@@ -1,3 +1,5 @@
+#include <linux/pm_qos.h>
+
 #ifdef CONFIG_PM_RUNTIME
 
 extern void pm_runtime_init(struct device *dev);
@@ -35,15 +37,21 @@ extern void device_pm_move_last(struct d
 static inline void device_pm_init(struct device *dev)
 {
 	spin_lock_init(&dev->power.lock);
+	dev->power.power_state = PMSG_INVALID;
 	pm_runtime_init(dev);
 }
 
+static inline void device_pm_add(struct device *dev)
+{
+	dev_pm_qos_constraints_init(dev);
+}
+
 static inline void device_pm_remove(struct device *dev)
 {
+	dev_pm_qos_constraints_destroy(dev);
 	pm_runtime_remove(dev);
 }
 
-static inline void device_pm_add(struct device *dev) {}
 static inline void device_pm_move_before(struct device *deva,
 					 struct device *devb) {}
 static inline void device_pm_move_after(struct device *deva,
