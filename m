Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab0LUDT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 22:19:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498Ab0LUDTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 22:19:25 -0500
From: Dave Airlie <airlied@gmail.com>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: [RFC PATCH] platform/x86: add MXM WMI driver.
Date: Tue, 21 Dec 2010 13:19:15 +1000
Message-Id: <1292901555-16213-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

MXM is a laptop graphics card form-factor + interface specification,
this adds an initial stub driver to talk to the MXM WMI interface.

The only method used is the MUX switching method needed to do switchable
graphics on the nvidia chipsets.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/platform/x86/Kconfig   |    7 +++
 drivers/platform/x86/Makefile  |    1 +
 drivers/platform/x86/mxm-wmi.c |   85 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mxm-wmi.h        |   32 +++++++++++++++
 4 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/mxm-wmi.c
 create mode 100644 include/linux/mxm-wmi.h

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index faec777..8a435a1 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -639,4 +639,11 @@ config XO1_RFKILL
 	  Support for enabling/disabling the WLAN interface on the OLPC XO-1
 	  laptop.
 
+config MXM_WMI
+	tristate "WMI support for MXM Laptop Graphics"
+	depends on ACPI_WMI
+	---help---
+	 MXM is a standard for laptop graphics cards, the WMI interface
+	 is required for switchable nvidia graphics machines
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 9950ccc..6abdae9 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
 obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
+obj-$(CONFIG_MXM_WMI)		+= mxm-wmi.o
diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
new file mode 100644
index 0000000..6a42808
--- /dev/null
+++ b/drivers/platform/x86/mxm-wmi.c
@@ -0,0 +1,85 @@
+/*
+ * MXM WMI driver
+ *
+ * Copyright(C) 2010 Red Hat.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+MODULE_AUTHOR("Dave Airlie");
+MODULE_DESCRIPTION("MXM WMI Driver");
+MODULE_LICENSE("GPL");
+
+#define MXM_WMMX_GUID "F6CB5C3C-9CAE-4EBD-B577-931EA32A2CC0"
+
+MODULE_ALIAS("wmi:"MXM_WMMX_GUID);
+
+#define MXM_WMMX_FUNC_MXDS 0x5344584D /* "MXDS" */
+
+struct mxds_args {
+	u32 func;
+	u32 args;
+	u32 xarg;
+};
+
+int mxm_wmi_call_mxds(int adapter, uint32_t output_id)
+{
+	struct mxds_args args = {
+		.func = MXM_WMMX_FUNC_MXDS,
+		.args = output_id,
+		.xarg = 1,
+	};
+	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status status;
+
+	printk(KERN_DEBUG "MXM: calling mux switch %d 0x%08x\n", adapter, output_id);
+
+	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x1, adapter, &input,
+				     &output);
+
+	if (ACPI_FAILURE(status))
+		return status;
+
+	printk(KERN_DEBUG "MXM: mux switched %d\n", status);
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(mxm_wmi_call_mxds);
+
+bool mxm_wmi_supported(void)
+{
+	bool guid_valid;
+	guid_valid = wmi_has_guid(MXM_WMMX_GUID);
+	return guid_valid;
+}
+EXPORT_SYMBOL_GPL(mxm_wmi_supported);
+
+static int __init mxm_wmi_init(void)
+{
+	return 0;
+}
+
+static void __exit mxm_wmi_exit(void)
+{
+}
+
+module_init(mxm_wmi_init);
+module_exit(mxm_wmi_exit);
diff --git a/include/linux/mxm-wmi.h b/include/linux/mxm-wmi.h
new file mode 100644
index 0000000..56b5454
--- /dev/null
+++ b/include/linux/mxm-wmi.h
@@ -0,0 +1,32 @@
+/*
+ * MXM WMI driver
+ *
+ * Copyright(C) 2010 Red Hat.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef MXM_WMI_H
+#define MXM_WMI_H
+
+/* discrete adapters */
+#define MXM_MXDS_ADAPTER_DIS_0 0x0
+#define MXM_MXDS_ADAPTER_DIS_1 0x1
+/* integrated adapter */
+#define MXM_MXDS_ADAPTER_IGD 0x10
+int mxm_wmi_call_mxds(int adapter, u32 output_id);
+bool mxm_wmi_supported(void);
+
+#endif
-- 
1.7.3.3

