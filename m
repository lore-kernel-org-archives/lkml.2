Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262Ab2FEI7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38854 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab2FEI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:59:30 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] driver core: fix shutdown races with probe/remove
Date: Tue,  5 Jun 2012 16:59:07 +0800
Message-Id: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, .shutdown callback may touch a uninitialized hardware
if dev->driver is set and .probe is not completed.

Secondly, device_shutdown() may dereference a null pointer to cause
oops when dev->driver is cleared after it is checked in device_shutdown().

This patch uses SRCU and ACCESS_ONCE to avoid the races:
- don't start .shutdown until .probe in progess is completed
- avoid running .probe and .remove once shutdown is started

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---

Thanks Paul for helpping me on using SRCU and ACCESS_ONCE to solve
the problem.

 drivers/base/base.h |    4 ++++
 drivers/base/core.c |    6 ++++++
 drivers/base/dd.c   |   14 ++++++++++++++
 drivers/base/init.c |    3 +++
 4 files changed, 27 insertions(+)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 6ee17bb..06f9dc1 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -1,4 +1,5 @@
 #include <linux/notifier.h>
+#include <linux/srcu.h>
 
 /**
  * struct subsys_private - structure to hold the private to the driver core portions of the bus_type/class structure.
@@ -138,3 +139,6 @@ extern int devtmpfs_init(void);
 #else
 static inline int devtmpfs_init(void) { return 0; }
 #endif
+
+extern struct srcu_struct driver_srcu;
+extern int device_shutdown_started;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..c3d597b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -49,6 +49,9 @@ static struct kobject *dev_kobj;
 struct kobject *sysfs_dev_char_kobj;
 struct kobject *sysfs_dev_block_kobj;
 
+struct srcu_struct driver_srcu;
+int device_shutdown_started;
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
@@ -1803,6 +1806,9 @@ void device_shutdown(void)
 {
 	struct device *dev;
 
+	ACCESS_ONCE(device_shutdown_started) = 1;
+	synchronize_srcu(&driver_srcu);
+
 	spin_lock(&devices_kset->list_lock);
 	/*
 	 * Walk the devices list backward, shutting down each in turn.
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1b1cbb5..5587037 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -250,8 +250,13 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	int ret = 0;
+	int idx;
 
+	idx = srcu_read_lock(&driver_srcu);
 	atomic_inc(&probe_count);
+	if (ACCESS_ONCE(device_shutdown_started))
+		goto done;
+
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	WARN_ON(!list_empty(&dev->devres_head));
@@ -305,6 +310,7 @@ probe_failed:
 done:
 	atomic_dec(&probe_count);
 	wake_up(&probe_waitqueue);
+	srcu_read_unlock(&driver_srcu, idx);
 	return ret;
 }
 
@@ -467,6 +473,12 @@ EXPORT_SYMBOL_GPL(driver_attach);
 static void __device_release_driver(struct device *dev)
 {
 	struct device_driver *drv;
+	int idx;
+
+	idx = srcu_read_lock(&driver_srcu);
+
+	if (ACCESS_ONCE(device_shutdown_started))
+		goto exit;
 
 	drv = dev->driver;
 	if (drv) {
@@ -494,6 +506,8 @@ static void __device_release_driver(struct device *dev)
 						     dev);
 
 	}
+exit:
+	srcu_read_unlock(&driver_srcu, idx);
 }
 
 /**
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c16f0b8..1b7dae6 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -27,6 +27,9 @@ void __init driver_init(void)
 	firmware_init();
 	hypervisor_init();
 
+	/* sync shutdown with probe/release */
+	init_srcu_struct(&driver_srcu);
+
 	/* These are also core pieces, but must come after the
 	 * core core pieces.
 	 */
-- 
1.7.9.5

