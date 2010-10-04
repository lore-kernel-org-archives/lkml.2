Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0JDSXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0JDSXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:04 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/5] ACPI: Bind implicit GPE dependencies to PCI devices
Date: Mon,  4 Oct 2010 14:22:27 -0400
Message-Id: <1286216549-5438-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1286216549-5438-1-git-send-email-mjg@redhat.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several platforms provide GPE information about devices in ACPI, but provide
no ACPI methods to handle these at runtime. Provide a default handler for
this case and bind it to PCI devices as they're discovered in ACPI space.
Keep the methods associated in case they have side effects.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/pci_bind.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 2ef0409..8b3cc6a 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
 #include <linux/acpi.h>
+#include <linux/list.h>
 #include <linux/pm_runtime.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -35,6 +36,43 @@
 #define _COMPONENT		ACPI_PCI_COMPONENT
 ACPI_MODULE_NAME("pci_bind");
 
+static LIST_HEAD(acpi_pci_gpe_devs);
+
+struct pci_gpe_dev {
+	struct list_head node;
+	struct pci_dev *dev;
+	acpi_handle gpe_device;
+	int gpe_number;
+	struct work_struct work;
+};
+
+static void acpi_pci_wake_handler_work(struct work_struct *work)
+{
+	struct pci_gpe_dev *gpe_dev = container_of(work, struct pci_gpe_dev,
+						   work);
+
+	pci_check_pme_status(gpe_dev->dev);
+	pm_runtime_resume(&gpe_dev->dev->dev);
+	pci_wakeup_event(gpe_dev->dev);
+	if (gpe_dev->dev->subordinate)
+		pci_pme_wakeup_bus(gpe_dev->dev->subordinate);
+}
+
+static u32 acpi_pci_wake_handler(void *data)
+{
+	long gpe_number = (long) data;
+	struct pci_gpe_dev *gpe_dev;
+
+	list_for_each_entry(gpe_dev, &acpi_pci_gpe_devs, node) {
+		if (gpe_number != gpe_dev->gpe_number)
+			continue;
+
+		schedule_work(&gpe_dev->work);
+	}
+
+	return ACPI_INTERRUPT_HANDLED;
+}
+
 static int acpi_pci_unbind(struct acpi_device *device)
 {
 	struct pci_dev *dev;
@@ -43,6 +81,30 @@ static int acpi_pci_unbind(struct acpi_device *device)
 	if (!dev)
 		goto out;
 
+	if (device->wakeup.flags.valid) {
+		struct pci_gpe_dev *gpe_dev;
+		struct pci_gpe_dev *tmp;
+		int gpe_count = 0;
+		int gpe_number = device->wakeup.gpe_number;
+		acpi_handle gpe_device = device->wakeup.gpe_device;
+
+		list_for_each_entry_safe(gpe_dev, tmp, &acpi_pci_gpe_devs, node) {
+			if (gpe_dev->dev == dev) {
+				flush_work(&gpe_dev->work);
+				list_del(&gpe_dev->node);
+				kfree(gpe_dev);
+			} else if (gpe_dev->gpe_number == gpe_number &&
+				   gpe_dev->gpe_device == gpe_device) {
+				gpe_count++;
+			}
+		}
+
+		if (gpe_count == 0) {
+			acpi_remove_gpe_handler(gpe_device, gpe_number,
+						&acpi_pci_wake_handler);
+		}
+	}
+
 	device_set_run_wake(&dev->dev, false);
 	pci_acpi_remove_pm_notifier(device);
 
@@ -71,6 +133,30 @@ static int acpi_pci_bind(struct acpi_device *device)
 		return 0;
 
 	pci_acpi_add_pm_notifier(device, dev);
+	if (device->wakeup.flags.valid) {
+		struct pci_gpe_dev *gpe_dev;
+		acpi_handle gpe_device = device->wakeup.gpe_device;
+		long gpe_number = device->wakeup.gpe_number;
+
+		gpe_dev = kmalloc(sizeof(struct pci_gpe_dev), GFP_KERNEL);
+		if (gpe_dev) {
+			gpe_dev->dev = dev;
+			gpe_dev->gpe_device = gpe_device;
+			gpe_dev->gpe_number = gpe_number;
+			INIT_WORK(&gpe_dev->work, acpi_pci_wake_handler_work);
+
+			acpi_install_gpe_handler(gpe_device, gpe_number,
+						 ACPI_GPE_LEVEL_TRIGGERED,
+						 &acpi_pci_wake_handler,
+						 (void *)gpe_number,
+						 true);
+			acpi_gpe_can_wake(device->wakeup.gpe_device,
+					  device->wakeup.gpe_number);
+			device->wakeup.flags.run_wake = 1;
+			list_add_tail(&gpe_dev->node, &acpi_pci_gpe_devs);
+		}
+	}
+
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(&dev->dev, true);
 
-- 
1.7.3.1

