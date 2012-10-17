Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2JQD0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:26:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2JQD0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:26:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,597,1344182400"; 
   d="scan'208";a="6012226"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, jiang.liu@huawei.com, bhelgaas@google.com,
        lenb@kernel.org, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH 1/1] Update acpi_root_bridge_list in container hotplug path.
Date: Wed, 17 Oct 2012 11:25:08 +0800
Message-Id: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 11:25:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 11:25:55,
	Serialize complete at 2012/10/17 11:25:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

List acpi_root_bridge_list is only updated when kernel is booting,
or in _handle_hotplug_event_root() when handling ACPI_NOTIFY_DEVICE_CHECK
event on a pci root bridge device. But when we hotplug a container, which
contains one or more pci root bridges, container_notify_cb() will be
called but not _handle_hotplug_event_root(). As a result,
acpi_root_bridge_list won't be updated.

This patch makes the following api and struct public in pci_root_hp.h,
	struct acpi_root_bridge;
	add_acpi_root_bridge()
	remove_acpi_root_bridge()
	acpi_root_handle_to_bridge()
and call add_acpi_root_bridge() in acpi_bus_check_add() and call
remove_acpi_root_bridge() in acpi_bus_remove().

This patch is based on Lu Yinghai's git tree branch for-pci-split-pci-root-hp-2.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/pci_root_hp.c |   20 ++++++--------------
 drivers/acpi/scan.c        |   18 ++++++++++++++++--
 include/acpi/pci_root_hp.h |   13 +++++++++++++
 3 files changed, 35 insertions(+), 16 deletions(-)
 create mode 100644 include/acpi/pci_root_hp.h

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index 01e71f6..6381a26 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -31,7 +31,7 @@ static const struct acpi_device_id root_device_ids[] = {
 
 #define ACPI_STA_FUNCTIONING	(0x00000008)
 
-static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
+struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
 {
 	struct acpi_root_bridge *bridge;
 
@@ -43,7 +43,7 @@ static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
 }
 
 /* allocate and initialize host bridge data structure */
-static void add_acpi_root_bridge(acpi_handle handle)
+void add_acpi_root_bridge(acpi_handle handle)
 {
 	struct acpi_root_bridge *bridge;
 	acpi_handle dummy_handle;
@@ -79,7 +79,7 @@ static void add_acpi_root_bridge(acpi_handle handle)
 	list_add(&bridge->list, &acpi_root_bridge_list);
 }
 
-static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
+void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
 {
 	list_del(&bridge->list);
 	kfree(bridge);
@@ -172,10 +172,8 @@ static void handle_root_bridge_removal(acpi_handle handle,
 	u32 flags = 0;
 	struct acpi_device *device;
 
-	if (bridge) {
+	if (bridge)
 		flags = bridge->flags;
-		remove_acpi_root_bridge(bridge);
-	}
 
 	if (!acpi_bus_get_device(handle, &device)) {
 		int ret_val;
@@ -223,10 +221,8 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 		/* bus enumerate */
 		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
 				 objname);
-		if (!bridge) {
+		if (!bridge)
 			handle_root_bridge_insertion(handle);
-			add_acpi_root_bridge(handle);
-		}
 
 		break;
 
@@ -234,10 +230,8 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 		/* device check */
 		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
 				 objname);
-		if (!bridge) {
+		if (!bridge)
 			handle_root_bridge_insertion(handle);
-			add_acpi_root_bridge(handle);
-		}
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
@@ -304,8 +298,6 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 		printk(KERN_DEBUG "acpi root: %s notify handler is installed\n",
 				 objname);
 
-	add_acpi_root_bridge(handle);
-
 	return AE_OK;
 }
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6ca2eaf..c258064 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -12,6 +12,7 @@
 #include <linux/dmi.h>
 
 #include <acpi/acpi_drivers.h>
+#include <acpi/pci_root_hp.h>
 
 #include "internal.h"
 
@@ -1265,8 +1266,17 @@ int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
 	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
 	device_release_driver(&dev->dev);
 
-	if (rmdevice)
+	if (rmdevice) {
+		if (acpi_is_root_bridge(dev->handle)) {
+			struct acpi_root_bridge *bridge;
+
+			bridge = acpi_root_handle_to_bridge(dev->handle);
+			if (bridge)
+				remove_acpi_root_bridge(bridge);
+		}
+
 		acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
+	}
 
 	return 0;
 }
@@ -1448,9 +1458,13 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
 	 */
 	device = NULL;
 	acpi_bus_get_device(handle, &device);
-	if (ops->acpi_op_add && !device)
+	if (ops->acpi_op_add && !device) {
 		acpi_add_single_object(&device, handle, type, sta, ops);
 
+		if (acpi_is_root_bridge(handle))
+			add_acpi_root_bridge(handle);
+	}
+
 	if (!device)
 		return AE_CTRL_DEPTH;
 
diff --git a/include/acpi/pci_root_hp.h b/include/acpi/pci_root_hp.h
new file mode 100644
index 0000000..2761add
--- /dev/null
+++ b/include/acpi/pci_root_hp.h
@@ -0,0 +1,13 @@
+
+/*PCI root bridge hotplug API */
+
+#ifndef __PCI_ROOT_HP__
+#define __PCI_ROOT_HP__
+
+struct acpi_root_bridge;
+
+void add_acpi_root_bridge(acpi_handle handle);
+void remove_acpi_root_bridge(struct acpi_root_bridge *bridge);
+struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle);
+
+#endif				/* __PCI_ROOT_HP_H__ */
-- 
1.7.1

