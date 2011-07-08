Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1GHIyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:32 -0400
Received: from service87.mimecast.com ([94.185.240.25]:50202 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754591Ab1GHIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:26 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC PATCH v2 2/4] Core device subsystem implementation
Date: Fri,  8 Jul 2011 09:54:08 +0100
Message-Id: <1310115250-3859-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
X-OriginalArrivalTime: 08 Jul 2011 08:54:16.0209 (UTC) FILETIME=[9DDB1010:01CC3D4C]
X-MC-Unique: 111070809542400401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p688slSw032439

There is a small number of devices that the core kernel needs very
early in the boot process, namely an interrupt controller and a timer,
long before the device model is up and running.

The "core device subsystem" offers a class based device/driver
matching model, doesn't rely on any other subsystem, is very (too?)
simple, and support getting information both from DT as well as from
static data provided by the platform. It also gives the opportunity to
define the probing order by offering a sorting hook at runtime.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 drivers/base/Makefile             |    3 +-
 drivers/base/core_device.c        |  108 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |    6 ++
 include/linux/core_device.h       |   69 +++++++++++++++++++++++
 5 files changed, 186 insertions(+), 1 deletions(-)
 create mode 100644 drivers/base/core_device.c
 create mode 100644 include/linux/core_device.h

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index e5287f2..ae33310 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -70,6 +70,7 @@ SECTIONS
 
 		INIT_SETUP(16)
 
+		INIT_CORE_DRV
 		INIT_CALLS
 		CON_INITCALL
 		SECURITY_INITCALL
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4c5701c..79476f0 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o
+			   attribute_container.o transport_class.o \
+			   core_device.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
diff --git a/drivers/base/core_device.c b/drivers/base/core_device.c
new file mode 100644
index 0000000..9262145
--- /dev/null
+++ b/drivers/base/core_device.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2011 ARM Ltd
+ * Written by Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Core device init support
+ */
+#include <linux/core_device.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+
+static struct list_head anchors[CORE_DEV_CLASS_MAX] __initdata = {
+	[CORE_DEV_CLASS_IRQ]   = LIST_HEAD_INIT(anchors[CORE_DEV_CLASS_IRQ]),
+	[CORE_DEV_CLASS_TIMER] = LIST_HEAD_INIT(anchors[CORE_DEV_CLASS_TIMER]),
+};
+
+static int __init core_device_match(struct core_device *dev,
+				    struct core_device_id *ids)
+{
+	int i;
+#ifdef CONFIG_OF
+	if (dev->of_node)
+		for (i = 0; ids[i].name != NULL; i++)
+			if (of_device_is_compatible(dev->of_node,
+						    ids[i].name))
+				return 1;
+#endif
+	for (i = 0; ids[i].name != NULL; i++)
+		if (!strcmp(dev->name, ids[i].name))
+			return 1;
+
+	return 0;
+}
+
+void __init core_device_register(enum core_device_class class,
+			  struct core_device *dev)
+{
+	list_add_tail(&dev->entry, &anchors[class]);
+}
+
+extern const struct core_driver_setup_block __core_driver_block_start[],
+					    __core_driver_block_end[];
+
+void __init core_driver_init_class(enum core_device_class class,
+				   void (*sort)(struct list_head *))
+{
+	const struct core_driver_setup_block *b;
+	struct core_device *dev, *tmp;
+	int err;
+
+	if (sort)
+		sort(&anchors[class]);
+
+	list_for_each_entry_safe(dev, tmp, &anchors[class], entry) {
+		pr_debug("core: matching device %s(%d)\n", dev->name, class);
+		for (b = __core_driver_block_start;
+		     b < __core_driver_block_end;
+		     b++) {
+			if (b->class != class ||
+			    !core_device_match(dev, b->drv->ids))
+				continue;
+			
+			pr_debug("core: matched device %s\n", dev->name);
+			err = b->drv->init(dev);
+			if (err)
+				pr_warning("core: %s init failed\n", dev->name);
+		}
+
+		list_del(&dev->entry);
+#ifdef CONFIG_OF
+		if (dev->of_node) { /* These are dynamically allocated */
+			kfree(dev->resource);
+			kfree(dev);
+		}
+#endif
+	}
+}
+
+#ifdef CONFIG_OF
+void __init of_core_device_populate(enum core_device_class class,
+			     struct of_device_id *matches)
+{
+	struct device_node *np;
+	struct core_device *dev;
+	int num_res;
+
+	for_each_matching_node(np, matches) {
+		pr_debug("core: registering OF device %s\n", np->full_name);
+		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev)
+			return;
+		dev->name = np->name;
+		dev->of_node = np;
+
+		dev->resource = of_device_alloc_resources(np, &num_res);
+		if (num_res < 0) {
+			kfree(dev);
+			return;
+		}
+		dev->num_resources = num_res;
+
+		core_device_register(class, dev);
+	}
+}
+#endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db22d13..2b1590a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -616,6 +616,11 @@
 		*(.init.setup)						\
 		VMLINUX_SYMBOL(__setup_end) = .;
 
+#define INIT_CORE_DRV							\
+		VMLINUX_SYMBOL(__core_driver_block_start) = .;		\
+		*(.init.core_driver)					\
+		VMLINUX_SYMBOL(__core_driver_block_end) = .;
+
 #define INITCALLS							\
 	*(.initcallearly.init)						\
 	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
@@ -797,6 +802,7 @@
 	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {		\
 		INIT_DATA						\
 		INIT_SETUP(initsetup_align)				\
+		INIT_CORE_DRV						\
 		INIT_CALLS						\
 		CON_INITCALL						\
 		SECURITY_INITCALL					\
diff --git a/include/linux/core_device.h b/include/linux/core_device.h
new file mode 100644
index 0000000..ca67e5e
--- /dev/null
+++ b/include/linux/core_device.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2011 ARM Ltd
+ * Written by Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Core device init support
+ */
+
+#ifndef _CORE_DEVICE_H
+#define _CORE_DEVICE_H
+
+#include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/of.h>
+
+struct core_device_id {
+	const char		*name;
+};
+
+enum core_device_class {
+	CORE_DEV_CLASS_IRQ,
+	CORE_DEV_CLASS_TIMER,
+	CORE_DEV_CLASS_MAX		/* Do not use as a class */
+};
+
+struct core_device {
+	const char		*name;
+	u32			num_resources;
+	struct resource		*resource;
+#ifdef CONFIG_OF
+	struct device_node	*of_node;
+#endif
+	struct list_head	entry;
+};
+
+struct core_driver {
+	int			(*init)(struct core_device *);
+	struct core_device_id	*ids;
+};
+
+void core_device_register(enum core_device_class class,
+			  struct core_device *dev);
+void core_driver_init_class(enum core_device_class class,
+			    void (*sort)(struct list_head *));
+#ifdef CONFIG_OF
+void of_core_device_populate(enum core_device_class class,
+			     struct of_device_id *matches);
+#else
+static inline void of_core_device_populate(enum core_device_class class,
+					   struct of_device_id *matches)
+{
+}
+#endif
+
+struct core_driver_setup_block {
+	enum core_device_class	class;
+	struct core_driver	*drv;
+};
+
+#define core_driver_register(cls, drv)					\
+static struct core_driver_setup_block __core_driver_block_##cls##_##drv	\
+	__used __section(.init.core_driver)				\
+	__attribute__((aligned((sizeof(long)))))			\
+	= { cls, &drv }
+
+#endif
-- 
1.7.0.4


