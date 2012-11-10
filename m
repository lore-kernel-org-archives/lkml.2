Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2KJN65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:58:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41508 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2KJN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:58:56 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 1/6] driver core: add a bus notification to temporarily reject driver binding
Date: Sat, 10 Nov 2012 21:57:14 +0800
Message-Id: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

There are several requirements to temporarily reject device driver
binding. Possible usage cases as below:
1) We should avoid binding an unsafe driver to a device belonging to
   an active VFIO group, otherwise it will break the DMA isolation
   property of VFIO.
2) When hot-removing a PCI hierachy, we should avoid binding device
   drivers to PCI devices going to be removed during the window
   between unbinding of device driver and destroying of device nodes.
3) When hot-adding a PCI host bridge, we should temporarily disable
   driver binding before setting up corresponding IOMMU and IOAPIC.

We may add a flag into struct device to temporarily disable driver
binding as in this thread https://patchwork.kernel.org/patch/1535721/.

This patch proposes another solution to temporarily disable driver
binding by using bus notification mechanisms. It adds an notification
event to solicit if anybody has objections when binding a driver to a
device.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/base/dd.c      |   11 ++++++++++-
 include/linux/device.h |    8 +++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e3bbed8..43c8034 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -205,9 +205,18 @@ static int driver_sysfs_add(struct device *dev)
 {
 	int ret;
 
-	if (dev->bus)
+	if (dev->bus) {
+		/* Does anybody have objections to the driver binding? */
+		ret = blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+				   BUS_NOTIFY_SOLICIT_BINDING, dev);
+		if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK) {
+			dev_dbg(dev, "driver binding has been rejected by bus notification handler.\n");
+			return notifier_to_errno(ret);
+		}
+
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BIND_DRIVER, dev);
+	}
 
 	ret = sysfs_create_link(&dev->driver->p->kobj, &dev->kobj,
 			  kobject_name(&dev->kobj));
diff --git a/include/linux/device.h b/include/linux/device.h
index 52a5f15..2cfe8f9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -165,9 +165,13 @@ extern int bus_register_notifier(struct bus_type *bus,
 extern int bus_unregister_notifier(struct bus_type *bus,
 				   struct notifier_block *nb);
 
-/* All 4 notifers below get called with the target struct device *
+/* All 7 notifers below get called with the target struct device *
  * as an argument. Note that those functions are likely to be called
  * with the device lock held in the core, so be careful.
+ *
+ * Note: return values of notification handler are ignored by the driver core
+ * except for BUS_SOLICIT_BINDING, so notication handler shouldn't return
+ * error code except for BUS_SOLICIT_BINDING.
  */
 #define BUS_NOTIFY_ADD_DEVICE		0x00000001 /* device added */
 #define BUS_NOTIFY_DEL_DEVICE		0x00000002 /* device removed */
@@ -178,6 +182,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 						      unbound */
 #define BUS_NOTIFY_UNBOUND_DRIVER	0x00000006 /* driver is unbound
 						      from the device */
+#define BUS_NOTIFY_SOLICIT_BINDING	0x00000007 /* Any objections to the
+						      driver binding? */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
-- 
1.7.9.5

