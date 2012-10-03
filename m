Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2JCXAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:00:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50223 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab2JCXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:00:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/4] PCI, ACPI: Remove not used acpi_pci_root_start()
Date: Wed,  3 Oct 2012 16:00:13 -0700
Message-Id: <1349305214-3241-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349305214-3241-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with new acpi_bus_add, we could move code in acpi_pci_root_start into
acpi_pci_root_add.

After that we could remove acpi_pci_root_start.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index bce469c..8d85287 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -47,7 +47,6 @@ ACPI_MODULE_NAME("pci_root");
 #define ACPI_PCI_ROOT_DEVICE_NAME	"PCI Root Bridge"
 static int acpi_pci_root_add(struct acpi_device *device);
 static int acpi_pci_root_remove(struct acpi_device *device, int type);
-static int acpi_pci_root_start(struct acpi_device *device);
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
 				| OSC_ACTIVE_STATE_PWR_SUPPORT \
@@ -67,7 +66,6 @@ static struct acpi_driver acpi_pci_root_driver = {
 	.ops = {
 		.add = acpi_pci_root_add,
 		.remove = acpi_pci_root_remove,
-		.start = acpi_pci_root_start,
 		},
 };
 
@@ -451,6 +449,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	acpi_status status;
 	int result;
 	struct acpi_pci_root *root;
+	struct acpi_pci_driver *driver;
 	acpi_handle handle;
 	struct acpi_device *child;
 	u32 flags, base_flags;
@@ -628,22 +627,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 
-	return 0;
-
-out_del_root:
-	mutex_lock(&acpi_pci_root_lock);
-	list_del(&root->node);
-	mutex_unlock(&acpi_pci_root_lock);
-end:
-	kfree(root);
-	return result;
-}
-
-static int acpi_pci_root_start(struct acpi_device *device)
-{
-	struct acpi_pci_root *root = acpi_driver_data(device);
-	struct acpi_pci_driver *driver;
-
 	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
@@ -653,6 +636,14 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	pci_bus_add_devices(root->bus);
 
 	return 0;
+
+out_del_root:
+	mutex_lock(&acpi_pci_root_lock);
+	list_del(&root->node);
+	mutex_unlock(&acpi_pci_root_lock);
+end:
+	kfree(root);
+	return result;
 }
 
 static int acpi_pci_root_remove(struct acpi_device *device, int type)
-- 
1.7.7

