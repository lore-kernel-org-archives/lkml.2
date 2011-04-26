Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab1DZQKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:10:24 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33067
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754324Ab1DZQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 25/25] Staging: hv: VMBUS is a acpi enumerated device; get irq value from bios.
Date: Tue, 26 Apr 2011 09:20:42 -0700
Message-Id: <1303834842-5022-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some windows hosts, the Linux  PCI sub-system is not allocating irq resources to the
vmbus driver. It looks like VMBUS is an ACPI enumerated device. Retrieve the irq
information from DSDT. Currently we use this bios specified irq, if the PCI
sub-system fails to allocate the irq.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |  101 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index f95ec2b..1c5d43a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -17,8 +17,8 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *   K. Y. Srinivasan <kys@microsoft.com>
  *
- * 3/9/2011: K. Y. Srinivasan	- Significant restructuring and cleanup
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -31,6 +31,8 @@
 #include <linux/pci.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
 #include <linux/completion.h>
 #include "version_info.h"
 #include "hv_api.h"
@@ -52,6 +54,7 @@ EXPORT_SYMBOL(vmbus_loglevel);
 
 static int pci_probe_error;
 static struct completion probe_event;
+static int irq;
 
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
@@ -723,6 +726,74 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 }
 
 
+/*
+ * VMBUS is an acpi enumerated device. Get the the IRQ information
+ * from DSDT.
+ */
+
+static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *irq)
+{
+
+	if (res->type == ACPI_RESOURCE_TYPE_IRQ) {
+		struct acpi_resource_irq *irqp;
+		irqp = &res->data.irq;
+
+		*((unsigned int *)irq) = irqp->interrupts[0];
+	}
+
+	return AE_OK;
+}
+
+static int vmbus_acpi_add(struct acpi_device *device)
+{
+	acpi_status result;
+
+	result =
+	acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+			vmbus_walk_resources, &irq);
+
+	if (ACPI_FAILURE(result)) {
+		complete(&probe_event);
+		return -ENODEV;
+	}
+	complete(&probe_event);
+	return 0;
+}
+
+static const struct acpi_device_id vmbus_acpi_device_ids[] = {
+	{"VMBUS", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, vmbus_acpi_device_ids);
+
+static struct acpi_driver vmbus_acpi_driver = {
+	.name = "vmbus",
+	.ids = vmbus_acpi_device_ids,
+	.ops = {
+		.add = vmbus_acpi_add,
+	},
+};
+
+static int vmbus_acpi_init(void)
+{
+	int result;
+
+
+	result = acpi_bus_register_driver(&vmbus_acpi_driver);
+	if (result < 0)
+		return result;
+
+	return 0;
+}
+
+static void vmbus_acpi_exit(void)
+{
+	acpi_bus_unregister_driver(&vmbus_acpi_driver);
+
+	return;
+}
+
+
 static int __devinit hv_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
@@ -732,7 +803,16 @@ static int __devinit hv_pci_probe(struct pci_dev *pdev,
 	if (pci_probe_error)
 		goto probe_cleanup;
 
+	/*
+	 * If the PCI sub-sytem did not assign us an
+	 * irq, use the bios provided one.
+	 */
+
+	if (pdev->irq == 0)
+		pdev->irq = irq;
+
 	pci_probe_error = vmbus_bus_init(pdev);
+
 	if (pci_probe_error)
 		pci_disable_device(pdev);
 
@@ -762,6 +842,25 @@ static struct pci_driver hv_bus_driver = {
 static int __init hv_pci_init(void)
 {
 	int ret;
+
+	init_completion(&probe_event);
+
+	/*
+	 * Get irq resources first.
+	 */
+
+	ret = vmbus_acpi_init();
+	if (ret)
+		return ret;
+
+	wait_for_completion(&probe_event);
+
+	if (irq <= 0) {
+		vmbus_acpi_exit();
+		return -ENODEV;
+	}
+
+	vmbus_acpi_exit();
 	init_completion(&probe_event);
 	ret = pci_register_driver(&hv_bus_driver);
 	if (ret)
-- 
1.7.4.1

