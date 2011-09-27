Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1I0UDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:03:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1I0UC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:02:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Sept 27 (power/qos.c)
Date: Tue, 27 Sep 2011 22:05:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
References: <20110927173530.ceae2e49537a81da65287bf3@canb.auug.org.au> <4E81FA1E.3060702@xenotime.net>
In-Reply-To: <4E81FA1E.3060702@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272205.12021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Randy Dunlap wrote:
> On 09/27/2011 12:35 AM, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> When CONFIG_PM_SLEEP is not enabled:
> 
> drivers/base/power/qos.c:231:29: error: 'struct dev_pm_info' has no member named 'entry'

Thanks for the report.

Below is a patch and it should be fixed in linux-next now.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / QoS: Fix build issue for CONFIG_PM_SLEEP unset

Commit d41a041b58684710638cbc0d5342a661b50db124 "PM / QoS: Add
function dev_pm_qos_read_value() (v2)" introduced a build problem
for CONFIG_PM_SLEEP, because it overlooked this case entirely.

To fix this issue, use the power.power_state in struct device to
indicate whether or not PM QoS constraints can be applied to the
device object in question instead of checking the device's
power.entry field that is valid only for CONFIG_PM_SLEEP set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c  |    2 +-
 drivers/base/power/power.h |   10 +++++++++-
 drivers/base/power/qos.c   |   11 ++++-------
 include/linux/pm.h         |    2 ++
 include/linux/pm_qos.h     |    9 +++++++--
 5 files changed, 23 insertions(+), 11 deletions(-)

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
@@ -142,9 +143,13 @@ static inline int dev_pm_qos_remove_glob
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
Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -149,6 +149,7 @@ void dev_pm_qos_constraints_init(struct
 {
 	mutex_lock(&dev_pm_qos_mtx);
 	dev->power.constraints = NULL;
+	dev->power.power_state = PMSG_ON;
 	mutex_unlock(&dev_pm_qos_mtx);
 }
 
@@ -165,6 +166,7 @@ void dev_pm_qos_constraints_destroy(stru
 
 	mutex_lock(&dev_pm_qos_mtx);
 
+	dev->power.power_state = PMSG_INVALID;
 	c = dev->power.constraints;
 	if (!c)
 		goto out;
@@ -222,20 +224,15 @@ int dev_pm_qos_add_request(struct device
 
 	req->dev = dev;
 
-	device_pm_lock();
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (dev->power.constraints) {
-		device_pm_unlock();
-	} else {
-		if (list_empty(&dev->power.entry)) {
+	if (!dev->power.constraints) {
+		if (dev->power.power_state.event == PM_EVENT_INVALID) {
 			/* The device has been removed from the system. */
-			device_pm_unlock();
 			req->dev = NULL;
 			ret = -ENODEV;
 			goto out;
 		} else {
-			device_pm_unlock();
 			/*
 			 * Allocate the constraints data on the first call to
 			 * add_request, i.e. only if the data is not already
