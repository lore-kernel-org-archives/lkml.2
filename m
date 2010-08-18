Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0HRTQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:16:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60579 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0HRTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:15:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51462468"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca, gregkh@suse.de,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] msm-bus: Define the msm-bus skeleton
Date: Wed, 18 Aug 2010 12:15:42 -0700
Message-Id: <1282158943-11902-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines the msm_bus_type and adds 3 bus
devices (msm-apps, msm-system, msm-mmss) to it.

With this new model it is trivial to move devices and
drivers onto the msm_bus, simply

	s/platform_device_register/msm_device_register
	s/platform_driver_register/msm_driver_register

This is not the final architecture of msm_bus /devices/,
rather a demonstration of the API usage to define and
utilize the msm_bus_type. Architecture will likely be
specified in board files or perhaps OF.

The resulting bus structure is (snipped):

/sys/bus
|-- msm-bus-type
|   |-- devices
|   |   |-- msm-apps -> ../../../devices/msm-apps
|   |   |-- msm-mmss -> ../../../devices/msm-mmss
|   |   |-- msm-system -> ../../../devices/msm-system
|   |   |-- some-msm-dev -> ../../../devices/msm-system/some-msm-dev
|   |-- drivers
|   |   |-- some-msm-drv

/sys/devices
|-- msm-apps
|-- msm-mmss
|-- msm-system
|   |-- some-msm-dev

Which maps the desired topology

QUICK COMMENT

It is worth noting that this patch is a fairly minimal implementation,
that is, it does not yet have any functionality that makes it differ
from the platform bus - it just shows how it would be done.

Also, it only implements the part of the API it needs to, which could
be confusing - you register devices with msm_device_register, yet
unregister them with platform_device_unregister; although it would
be perfectly valid to add

   #define msm_device_unregister platform_device_unregister
   (...etc)

to msm_device.h to "complete the API".

This patch and the following are a /proof of concept/, not the acutal
patches for MSM; physical bus devices vary, and will not be defined as
statically as shown here

Change-Id: I0f4cd8eb515726ef1945d8ea972f0f8a5e145a7b
Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                  |    1 +
 arch/arm/mach-msm/include/mach/msm_device.h |   28 +++++++
 arch/arm/mach-msm/msm_bus.c                 |  105 +++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_device.h
 create mode 100644 arch/arm/mach-msm/msm_bus.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 7046106..977ba89 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -4,6 +4,7 @@ obj-y += vreg.o
 obj-y += acpuclock-arm11.o
 obj-y += clock.o clock-pcom.o
 obj-y += gpio.o
+obj-y += msm_bus.o
 
 ifdef CONFIG_MSM_VIC
 obj-y += irq-vic.o
diff --git a/arch/arm/mach-msm/include/mach/msm_device.h b/arch/arm/mach-msm/include/mach/msm_device.h
new file mode 100644
index 0000000..f46a2d0
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_device.h
@@ -0,0 +1,28 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _MSM_DEVICE_H
+#define _MSM_DEVICE_H
+
+#include <linux/platform_device.h>
+
+extern int msm_device_register(struct platform_device *pdev);
+extern int msm_driver_register(struct platform_driver *pdrv);
+extern int msm_driver_probe(struct platform_driver *pdrv,
+		int (*probe)(struct platform_device *));
+
+#endif
diff --git a/arch/arm/mach-msm/msm_bus.c b/arch/arm/mach-msm/msm_bus.c
new file mode 100644
index 0000000..f32942c
--- /dev/null
+++ b/arch/arm/mach-msm/msm_bus.c
@@ -0,0 +1,105 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include <mach/msm_device.h>
+
+const struct dev_pm_ops msm_pm_ops = {
+	PLATFORM_PM_OPS_TEMPLATE,
+	.prepare	= NULL,
+};
+
+struct bus_type msm_bus_type = {
+	PLATFORM_BUS_TEMPLATE,
+	.name		= "msm-bus-type",
+	.dev_attrs	= NULL,
+	.pm		= &msm_pm_ops,
+};
+
+static struct platform_device msm_apps_bus = {
+	.name			= "msm-apps",
+	.id			= -1,
+};
+
+static struct platform_device msm_system_bus = {
+	.name			= "msm-system",
+	.id			= -1,
+};
+
+static struct platform_device msm_mmss_bus = {
+	.name			= "msm-mmss",
+	.id			= -1,
+};
+
+int msm_device_register(struct platform_device *pdev)
+{
+	pdev->dev.bus = &msm_bus_type;
+	/* XXX: Use platform_data to assign pdev->dev.parent */
+
+	device_initialize(&pdev->dev);
+	return __platform_device_add(pdev);
+}
+
+int msm_driver_register(struct platform_driver *pdrv)
+{
+	pdrv->driver.bus = &msm_bus_type;
+
+	return __platform_driver_register(pdrv);
+}
+
+int msm_driver_probe(struct platform_driver *pdrv,
+		int (*probe)(struct platform_device *))
+{
+	return __platform_driver_probe(pdrv, probe, &msm_driver_register);
+}
+
+static int __init msm_bus_init(void)
+{
+	int error;
+
+	error = bus_register(&msm_bus_type);
+	if (error)
+		return error;
+
+	error = msm_device_register(&msm_apps_bus);
+	if (error)
+		goto fail_apps_bus;
+
+	error = msm_device_register(&msm_system_bus);
+	if (error)
+		goto fail_system_bus;
+
+	error = msm_device_register(&msm_mmss_bus);
+	if (error)
+		goto fail_mmss_bus;
+
+	return error;
+
+	/* platform_device_unregister(&msm_mmss_bus); */
+fail_mmss_bus:
+	platform_device_unregister(&msm_system_bus);
+fail_system_bus:
+	platform_device_unregister(&msm_apps_bus);
+fail_apps_bus:
+	bus_unregister(&msm_bus_type);
+
+	return error;
+}
+postcore_initcall(msm_bus_init);
-- 
1.7.2.1

