Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2JFPbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:31:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44906 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2JFPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:31:42 -0400
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
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        Gaohuai Han <hangaohuai@huawei.com>
Subject: [RFC PATCH v3 08/28] ACPIHP: add callbacks into acpi_device_ops to support new hotplug framework
Date: Sat,  6 Oct 2012 23:27:16 +0800
Message-Id: <1349537256-21670-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new callbacks into struct acpi_device_ops to provide better error handling,
error recover and operation cancellation for ACPI based system device hotplug.

There are three major operations and each major operation is divided into
three steps.
1) pre_configure, configure, post_configure
	add an ACPI device into running system and rollback if error happens
	cancelled by user.
2) pre_release, release, post_release
	reclaim an ACPI device from running system and rollback if error
	happens or cancelled by user. It's important to privode a mechanism
	to cancel memory hot-removal operations because it's may take very
	long or even endless time to reclaim a memory device.
3) pre_unconfigure, unconfigure, post_unconfigure
	remove an ACPI device from running system and release all resources
	associated with it.

There's another callback to query status and information about the ACPI device.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Gaohuai Han <hangaohuai@huawei.com>
---
 drivers/acpi/hotplug/device.c |   93 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h       |    3 ++
 include/acpi/acpi_hotplug.h   |   64 ++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)

diff --git a/drivers/acpi/hotplug/device.c b/drivers/acpi/hotplug/device.c
index fb0451f..d566522 100644
--- a/drivers/acpi/hotplug/device.c
+++ b/drivers/acpi/hotplug/device.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2012 Huawei Tech. Co., Ltd.
  * Copyright (C) 2012 Jiang Liu <jiang.liu@huawei.com>
+ * Copyright (C) 2012 Hanjun Guo <guohanjun@huawei.com>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
@@ -27,6 +28,98 @@
 #include <acpi/acpi_hotplug.h>
 #include "acpihp.h"
 
+int acpihp_dev_get_info(struct acpi_device *device,
+			struct acpihp_dev_info *info)
+{
+	int ret = -ENOSYS;
+
+	acpihp_dev_get_type(device->handle, &info->type);
+
+	device_lock(&device->dev);
+	if (device->driver && device->driver->ops.hp_ops &&
+	    device->driver->ops.hp_ops->get_info)
+		ret = device->driver->ops.hp_ops->get_info(device, info);
+	else
+#if 0
+		/* Turn on this once all system devices have been converted
+		 * to the new hotplug framework
+		 */
+		info->status |= ACPIHP_DEV_STATUS_IRREMOVABLE;
+#else
+		ret = 0;
+#endif
+
+	if (device->driver)
+		info->status |= ACPIHP_DEV_STATUS_ATTACHED;
+	device_unlock(&device->dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(acpihp_dev_get_info);
+
+#define	ACPIHP_DEFINE_FUNC1(method, def, err, type) \
+int acpihp_dev_##method(struct acpi_device *device, type val) \
+{ \
+	int ret; \
+	BUG_ON(device == NULL); \
+	device_lock(&device->dev); \
+	if (!device->driver || !device->driver->ops.hp_ops) \
+		ret = (err); \
+	else if (!device->driver->ops.hp_ops->method) \
+		ret = (def); \
+	else \
+		ret = device->driver->ops.hp_ops->method(device, val); \
+	device_unlock(&device->dev); \
+	return ret; \
+} \
+EXPORT_SYMBOL_GPL(acpihp_dev_##method)
+
+#define	ACPIHP_DEFINE_FUNC2(method, def, err, type) \
+int acpihp_dev_##method(struct acpi_device *device, type val) \
+{ \
+	int ret = 0; \
+	BUG_ON(device == NULL); \
+	device_lock(&device->dev); \
+	if (!device->driver || !device->driver->ops.hp_ops) \
+		ret = (err); \
+	else if (!device->driver->ops.hp_ops->method) \
+		ret = (def); \
+	else \
+		device->driver->ops.hp_ops->method(device, val); \
+	device_unlock(&device->dev); \
+	return ret; \
+} \
+EXPORT_SYMBOL_GPL(acpihp_dev_##method)
+
+#define	ACPIHP_DEFINE_FUNC3(method, def, err) \
+int acpihp_dev_##method(struct acpi_device *device) \
+{ \
+	int ret = 0; \
+	BUG_ON(device == NULL); \
+	device_lock(&device->dev); \
+	if (!device->driver || !device->driver->ops.hp_ops) \
+		ret = (err); \
+	else if (!device->driver->ops.hp_ops->method) \
+		ret = (def); \
+	else \
+		device->driver->ops.hp_ops->method(device);\
+	device_unlock(&device->dev); \
+	return ret; \
+} \
+EXPORT_SYMBOL_GPL(acpihp_dev_##method)
+
+ACPIHP_DEFINE_FUNC1(pre_configure, 0, 0, struct acpihp_cancel_context *);
+ACPIHP_DEFINE_FUNC1(configure, 0, -ENOSYS, struct acpihp_cancel_context *);
+ACPIHP_DEFINE_FUNC2(post_configure, 0, 0, enum acpihp_dev_post_cmd);
+
+ACPIHP_DEFINE_FUNC1(pre_release, 0, 0, struct acpihp_cancel_context *);
+ACPIHP_DEFINE_FUNC1(release, 0, 0, struct acpihp_cancel_context *);
+ACPIHP_DEFINE_FUNC2(post_release, 0, 0, enum acpihp_dev_post_cmd);
+
+ACPIHP_DEFINE_FUNC3(pre_unconfigure, 0, 0);
+ACPIHP_DEFINE_FUNC3(unconfigure, 0, -ENOSYS);
+ACPIHP_DEFINE_FUNC3(post_unconfigure, 0, 0);
+
 /*
  * When creating ACPI devices for hot-added system devices connecting to slot,
  * don't cross the slot boundary. Otherwise it will cause inconsistence
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 8136dd7..6f9fdf2 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -138,6 +138,9 @@ struct acpi_device_ops {
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;
+#ifdef	CONFIG_ACPI_HOTPLUG
+	struct acpihp_dev_ops *hp_ops;
+#endif	/* CONFIG_ACPI_HOTPLUG */
 };
 
 #define ACPI_DRIVER_ALL_NOTIFY_EVENTS	0x1	/* system AND device events */
diff --git a/include/acpi/acpi_hotplug.h b/include/acpi/acpi_hotplug.h
index 2e7011e..fd46997 100644
--- a/include/acpi/acpi_hotplug.h
+++ b/include/acpi/acpi_hotplug.h
@@ -65,6 +65,51 @@ struct acpihp_dev_node {
 	struct klist_node	node;
 };
 
+/* Status of system devices. */
+#define	ACPIHP_DEV_STATUS_ATTACHED	0x1 /* Device driver attached */
+#define	ACPIHP_DEV_STATUS_STARTED	0x2 /* Device started */
+#define	ACPIHP_DEV_STATUS_IRREMOVABLE	0x10000 /* Device can't be removed */
+#define	ACPIHP_DEV_STATUS_FAULT		0x20000 /* Device in fault status */
+
+struct acpihp_dev_info {
+	enum acpihp_dev_type		type;
+	uint32_t			status;
+};
+
+/* Rollback or commit changes in post_{confiure|release} */
+enum acpihp_dev_post_cmd {
+	ACPIHP_DEV_POST_CMD_ROLLBACK,
+	ACPIHP_DEV_POST_CMD_COMMIT
+};
+
+/*
+ * ACPI system device drivers may check cancellations of hotplug operations
+ * by invoking the callback.
+ */
+struct acpihp_cancel_context {
+	int (*check_cancel)(struct acpihp_cancel_context *ctx);
+};
+
+/*
+ * Callback hooks provided by ACPI device drivers to support system device
+ * hotplug. To support hotplug, an ACPI system device driver should implement
+ * configure(), unconfigure() and get_info() at minimal.
+ */
+struct acpihp_dev_ops {
+	int (*get_info)(struct acpi_device *, struct acpihp_dev_info *info);
+	int (*pre_configure)(struct acpi_device *,
+			     struct acpihp_cancel_context *);
+	int (*configure)(struct acpi_device *, struct acpihp_cancel_context *);
+	void (*post_configure)(struct acpi_device *, enum acpihp_dev_post_cmd);
+	int (*pre_release)(struct acpi_device *,
+			   struct acpihp_cancel_context *);
+	int (*release)(struct acpi_device *, struct acpihp_cancel_context *);
+	void (*post_release)(struct acpi_device *, enum acpihp_dev_post_cmd);
+	void (*pre_unconfigure)(struct acpi_device *);
+	void (*unconfigure)(struct acpi_device *);
+	void (*post_unconfigure)(struct acpi_device *);
+};
+
 /*
  * ACPI hotplug slot is an abstraction of receptacles where a group of
  * system devices could be attached, just like PCI slot in PCI hotplug.
@@ -166,6 +211,25 @@ extern int acpihp_register_class(void);
 /* Unregister the ACPI hotplug slot class driver */
 extern void acpihp_unregister_class(void);
 
+/* Interfaces to invoke the ACPI device driver's hotplug hooks. */
+extern int acpihp_dev_get_info(struct acpi_device *device,
+			       struct acpihp_dev_info *info);
+extern int acpihp_dev_pre_configure(struct acpi_device *device,
+				    struct acpihp_cancel_context *ctx);
+extern int acpihp_dev_configure(struct acpi_device *device,
+				struct acpihp_cancel_context *ctx);
+extern int acpihp_dev_post_configure(struct acpi_device *device,
+				     enum acpihp_dev_post_cmd cmd);
+extern int acpihp_dev_pre_release(struct acpi_device *device,
+				  struct acpihp_cancel_context *ctx);
+extern int acpihp_dev_release(struct acpi_device *device,
+			      struct acpihp_cancel_context *ctx);
+extern int acpihp_dev_post_release(struct acpi_device *device,
+				   enum acpihp_dev_post_cmd cmd);
+extern int acpihp_dev_pre_unconfigure(struct acpi_device *device);
+extern int acpihp_dev_unconfigure(struct acpi_device *device);
+extern int acpihp_dev_post_unconfigure(struct acpi_device *device);
+
 /* Utility routines */
 extern int acpihp_dev_get_type(acpi_handle handle, enum acpihp_dev_type *type);
 extern bool acpihp_dev_match_ids(struct acpi_device_info *infop, char **ids);
-- 
1.7.9.5

