Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2JFPeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:34:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33560 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2JFPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:33:57 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v3 17/28] ACPIHP: block ACPI device driver unloading when executing hotplug operations
Date: Sat,  6 Oct 2012 23:27:25 +0800
Message-Id: <1349537256-21670-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI hotplug driver depends on ACPI device drivers to configure or
unconfigure ACPI devices. It will confuse the hotplug driver if an ACPI
device driver is unloaded when there are ongoing hotplug operations.
So block ACPI device driver unbinding/unloading by holding the device
lock when there are ongoing hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/hotplug/configure.c |   18 ++++++++++++++++--
 drivers/acpi/hotplug/device.c    |    8 --------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/hotplug/configure.c b/drivers/acpi/hotplug/configure.c
index 346b976..75e8752 100644
--- a/drivers/acpi/hotplug/configure.c
+++ b/drivers/acpi/hotplug/configure.c
@@ -37,7 +37,9 @@ enum config_op_code {
 	DRV_OP_POST_RELEASE,
 	DRV_OP_PRE_UNCONFIGURE,
 	DRV_OP_UNCONFIGURE,
-	DRV_OP_POST_UNCONFIGURE
+	DRV_OP_POST_UNCONFIGURE,
+	DRV_OP_LOCK_DEVICE,
+	DRV_OP_UNLOCK_DEVICE,
 };
 
 /* All devices will be configured in following order. */
@@ -102,6 +104,12 @@ static int acpihp_drv_invoke_method(enum config_op_code  opcode,
 		return acpihp_dev_unconfigure(dev);
 	case DRV_OP_POST_UNCONFIGURE:
 		return acpihp_dev_post_unconfigure(dev);
+	case DRV_OP_LOCK_DEVICE:
+		device_lock(&dev->dev);
+		return 0;
+	case DRV_OP_UNLOCK_DEVICE:
+		device_unlock(&dev->dev);
+		return 0;
 	default:
 		BUG_ON(opcode);
 		return -ENOSYS;
@@ -126,7 +134,9 @@ static int acpihp_drv_call_method(enum config_op_code opcode,
 		result = acpihp_drv_invoke_method(opcode, slot, acpi_dev, 0);
 		if (result)
 			break;
-		acpihp_drv_update_dev_state(np, state);
+		if (opcode != DRV_OP_LOCK_DEVICE &&
+		    opcode != DRV_OP_UNLOCK_DEVICE)
+			acpihp_drv_update_dev_state(np, state);
 	}
 	klist_iter_exit(&iter);
 
@@ -248,6 +258,7 @@ int acpihp_drv_configure(struct list_head *list)
 		acpihp_slot_change_state(dep->slot,
 					 ACPIHP_SLOT_STATE_CONFIGURING);
 
+	acpihp_drv_walk_devs(&head, DRV_OP_LOCK_DEVICE, 0, false);
 	result = acpihp_drv_walk_devs(&head, DRV_OP_PRE_CONFIGURE,
 				      DEVICE_STATE_PRE_CONFIGURE, false);
 	if (!result)
@@ -257,6 +268,7 @@ int acpihp_drv_configure(struct list_head *list)
 		post = ACPIHP_DEV_POST_CMD_ROLLBACK;
 	acpihp_drv_walk_devs_post(&head, DRV_OP_POST_CONFIGURE,
 				  DEVICE_STATE_CONNECTED, post, false);
+	acpihp_drv_walk_devs(&head, DRV_OP_UNLOCK_DEVICE, 0, false);
 
 	list_for_each_entry(dep, &head, node)
 		acpihp_drv_update_slot_state(dep->slot);
@@ -327,9 +339,11 @@ int acpihp_drv_unconfigure(struct list_head *list)
 		acpihp_slot_change_state(dep->slot,
 					 ACPIHP_SLOT_STATE_UNCONFIGURING);
 
+	acpihp_drv_walk_devs(&head, DRV_OP_LOCK_DEVICE, 0, false);
 	result = acpihp_drv_release(&head);
 	if (!result)
 		__acpihp_drv_unconfigure(&head);
+	acpihp_drv_walk_devs(&head, DRV_OP_UNLOCK_DEVICE, 0, false);
 
 	list_for_each_entry(dep, &head, node)
 		acpihp_drv_update_slot_state(dep->slot);
diff --git a/drivers/acpi/hotplug/device.c b/drivers/acpi/hotplug/device.c
index d566522..90666f8 100644
--- a/drivers/acpi/hotplug/device.c
+++ b/drivers/acpi/hotplug/device.c
@@ -35,7 +35,6 @@ int acpihp_dev_get_info(struct acpi_device *device,
 
 	acpihp_dev_get_type(device->handle, &info->type);
 
-	device_lock(&device->dev);
 	if (device->driver && device->driver->ops.hp_ops &&
 	    device->driver->ops.hp_ops->get_info)
 		ret = device->driver->ops.hp_ops->get_info(device, info);
@@ -51,7 +50,6 @@ int acpihp_dev_get_info(struct acpi_device *device,
 
 	if (device->driver)
 		info->status |= ACPIHP_DEV_STATUS_ATTACHED;
-	device_unlock(&device->dev);
 
 	return ret;
 }
@@ -62,14 +60,12 @@ int acpihp_dev_##method(struct acpi_device *device, type val) \
 { \
 	int ret; \
 	BUG_ON(device == NULL); \
-	device_lock(&device->dev); \
 	if (!device->driver || !device->driver->ops.hp_ops) \
 		ret = (err); \
 	else if (!device->driver->ops.hp_ops->method) \
 		ret = (def); \
 	else \
 		ret = device->driver->ops.hp_ops->method(device, val); \
-	device_unlock(&device->dev); \
 	return ret; \
 } \
 EXPORT_SYMBOL_GPL(acpihp_dev_##method)
@@ -79,14 +75,12 @@ int acpihp_dev_##method(struct acpi_device *device, type val) \
 { \
 	int ret = 0; \
 	BUG_ON(device == NULL); \
-	device_lock(&device->dev); \
 	if (!device->driver || !device->driver->ops.hp_ops) \
 		ret = (err); \
 	else if (!device->driver->ops.hp_ops->method) \
 		ret = (def); \
 	else \
 		device->driver->ops.hp_ops->method(device, val); \
-	device_unlock(&device->dev); \
 	return ret; \
 } \
 EXPORT_SYMBOL_GPL(acpihp_dev_##method)
@@ -96,14 +90,12 @@ int acpihp_dev_##method(struct acpi_device *device) \
 { \
 	int ret = 0; \
 	BUG_ON(device == NULL); \
-	device_lock(&device->dev); \
 	if (!device->driver || !device->driver->ops.hp_ops) \
 		ret = (err); \
 	else if (!device->driver->ops.hp_ops->method) \
 		ret = (def); \
 	else \
 		device->driver->ops.hp_ops->method(device);\
-	device_unlock(&device->dev); \
 	return ret; \
 } \
 EXPORT_SYMBOL_GPL(acpihp_dev_##method)
-- 
1.7.9.5

