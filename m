Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379Ab0EURBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:03 -0400
Received: from kroah.org ([198.145.64.141]:39078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934228Ab0EUQyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/38] drivers/base: Convert dev->sem to mutex
Date: Fri, 21 May 2010 09:53:40 -0700
Message-Id: <1274460848-11377-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The semaphore is semantically a mutex. Convert it to a real mutex and
fix up a few places where code was relying on semaphore.h to be included
by device.h, as well as the users of the trylock function, as that value
is now reversed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c                              |    3 +--
 drivers/net/mlx4/mlx4.h                          |    1 +
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    1 +
 drivers/usb/core/usb.c                           |    2 +-
 include/linux/device.h                           |    9 ++++-----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e11c8c3..cf507a7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
 
@@ -559,7 +558,7 @@ void device_initialize(struct device *dev)
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index bc72d6e..13343e8 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -40,6 +40,7 @@
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/timer.h>
+#include <linux/semaphore.h>
 #include <linux/workqueue.h>
 
 #include <linux/mlx4/device.h>
diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 1786db2..8b274b7 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -48,6 +48,7 @@ Devices: [Quatech] DAQP-208 (daqp), DAQP-308
 */
 
 #include "../comedidev.h"
+#include <linux/semaphore.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 397b678..5ae14f6 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -573,7 +573,7 @@ int usb_lock_device_for_reset(struct usb_device *udev,
 			iface->condition == USB_INTERFACE_UNBOUND))
 		return -EINTR;
 
-	while (usb_trylock_device(udev) != 0) {
+	while (!usb_trylock_device(udev)) {
 
 		/* If we can't acquire the lock after waiting one second,
 		 * we're probably deadlocked */
diff --git a/include/linux/device.h b/include/linux/device.h
index 241b96b..6f96191 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -404,7 +403,7 @@ struct device {
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
 
-	struct semaphore	sem;	/* semaphore to synchronize calls to
+	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
 					 */
 
@@ -514,17 +513,17 @@ static inline bool device_async_suspend_enabled(struct device *dev)
 
 static inline void device_lock(struct device *dev)
 {
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 }
 
 static inline int device_trylock(struct device *dev)
 {
-	return down_trylock(&dev->sem);
+	return mutex_trylock(&dev->mutex);
 }
 
 static inline void device_unlock(struct device *dev)
 {
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 void driver_init(void);
-- 
1.7.0.3

