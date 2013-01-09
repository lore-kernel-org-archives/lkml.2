Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3AIHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:41:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:56595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab3AIHlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,435,1355126400"; 
   d="scan'208";a="269709530"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V2 1/2] Xen stub driver for memory hotplug
Thread-Topic: [PATCH V2 1/2] Xen stub driver for memory hotplug
Thread-Index: Ac3uPLMxqVMpMelkR/S7DovT1xLYLQ==
Date: Wed, 9 Jan 2013 07:41:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353BB0F4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch create a file (xen-stub.c) for Xen stub drivers.
Xen stub drivers are used to reserve space for Xen drivers, i.e.
memory hotplug and cpu hotplug, and to block native drivers loaded,
so that real Xen drivers can be modular and loaded on demand.

This patch is specific for Xen memory hotplug (other Xen logic
can add stub drivers on their own). The xen stub driver will
occupied earlier via subsys_initcall (than native memory hotplug
driver via module_init and so blocking native). Later real Xen
memory hotplug logic will unregister the stub driver and register
itself to take effect on demand.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig    |   11 ++++++++
 drivers/xen/Makefile   |    1 +
 drivers/xen/xen-stub.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/acpi.h     |    6 ++++
 4 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-stub.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index cabfa97..2986de9 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -180,6 +180,17 @@ config XEN_PRIVCMD
 	depends on XEN
 	default m
 
+config XEN_STUB
+	bool "Xen stub drivers"
+	depends on XEN_DOM0 && X86_64
+	default y
+	help
+	  Allow kernel to install stub drivers, to reserve space for Xen drivers,
+	  i.e. memory hotplug and cpu hotplug, and to block native drivers loaded,
+	  so that real Xen drivers can be modular.
+
+	  To enable Xen features like cpu and memory hotplug, select Y here.
+
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index fb213cf..b63edd8 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
 obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
+obj-$(CONFIG_XEN_STUB)			+= xen-stub.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
 xen-evtchn-y				:= evtchn.o
 xen-gntdev-y				:= gntdev.o
diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
new file mode 100644
index 0000000..01a49e3
--- /dev/null
+++ b/drivers/xen/xen-stub.c
@@ -0,0 +1,60 @@
+/*
+ * xen-stub.c - stub drivers to reserve space for Xen
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *    Author: Liu Jinsong <jinsong.liu@intel.com>
+ *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
+ *
+ * Copyright (C) 2012 Oracle Inc
+ *    Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include <xen/acpi.h>
+
+/*--------------------------------------------
+	stub driver for Xen memory hotplug
+--------------------------------------------*/
+
+#ifdef CONFIG_ACPI
+
+static const struct acpi_device_id memory_device_ids[] = {
+	{ACPI_MEMORY_DEVICE_HID, 0},
+	{"", 0},
+};
+
+struct acpi_driver xen_stub_memory_device_driver = {
+	/* same name as native memory driver to block native loaded */
+	.name = "acpi_memhotplug",
+	.class = ACPI_MEMORY_DEVICE_CLASS,
+	.ids = memory_device_ids,
+};
+EXPORT_SYMBOL_GPL(xen_stub_memory_device_driver);
+
+static int __init xen_stub_memory_device_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* just reserve space for Xen, block native driver loaded */
+	return acpi_bus_register_driver(&xen_stub_memory_device_driver);
+}
+subsys_initcall(xen_stub_memory_device_init);
+
+#endif
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 48a9c01..7366e58 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -40,6 +40,12 @@
 #include <xen/xen.h>
 #include <linux/acpi.h>
 
+#define ACPI_MEMORY_DEVICE_CLASS        "memory"
+#define ACPI_MEMORY_DEVICE_HID          "PNP0C80"
+#define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
+
+extern struct acpi_driver xen_stub_memory_device_driver;
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
 
-- 
1.7.1
