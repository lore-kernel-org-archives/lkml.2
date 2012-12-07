Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946198Ab2LGG03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGG0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:26:25 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 15/15] PCI/ACPI: Remove the "pci_root" driver's sub-driver
	infrastructure
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:26:23 -0700
Message-ID: <20121207062622.11051.48770.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both sub-drivers of the "PCI Root Bridge ("pci_bridge")" driver, "acpiphp"
and "pci_slot", have been converted to statically built-in functionality
added directly from within "pci_bridge".

With the conversions there are no remaining usages of the 'struct
acpi_pci_driver' list based infrastructure.  This patch removes it.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/pci_root.c |   42 +-----------------------------------------
 include/linux/acpi.h    |    9 ---------
 2 files changed, 1 insertions(+), 50 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 42566e2..7cde9dc 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -71,44 +71,12 @@ static struct acpi_driver acpi_pci_root_driver = {
 		},
 };
 
-/* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
+/* Lock to protect acpi_pci_roots list */
 static DEFINE_MUTEX(acpi_pci_root_lock);
 static LIST_HEAD(acpi_pci_roots);
-static LIST_HEAD(acpi_pci_drivers);
 
 static DEFINE_MUTEX(osc_lock);
 
-int acpi_pci_register_driver(struct acpi_pci_driver *driver)
-{
-	int n = 0;
-	struct acpi_pci_root *root;
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_add_tail(&driver->node, &acpi_pci_drivers);
-	if (driver->add)
-		list_for_each_entry(root, &acpi_pci_roots, node) {
-			driver->add(root);
-			n++;
-		}
-	mutex_unlock(&acpi_pci_root_lock);
-
-	return n;
-}
-EXPORT_SYMBOL(acpi_pci_register_driver);
-
-void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
-{
-	struct acpi_pci_root *root;
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_del(&driver->node);
-	if (driver->remove)
-		list_for_each_entry(root, &acpi_pci_roots, node)
-			driver->remove(root);
-	mutex_unlock(&acpi_pci_root_lock);
-}
-EXPORT_SYMBOL(acpi_pci_unregister_driver);
-
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int seg, unsigned int bus)
 {
 	struct acpi_pci_root *root;
@@ -642,14 +610,10 @@ end:
 static int acpi_pci_root_start(struct acpi_device *device)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
-	struct acpi_pci_driver *driver;
 
 	pci_bus_add_devices(root->bus);
 
 	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->add)
-			driver->add(root);
 	acpiphp_add_bridge(root);
 	acpi_pci_slot_add(root);
 	mutex_unlock(&acpi_pci_root_lock);
@@ -660,12 +624,8 @@ static int acpi_pci_root_start(struct acpi_device *device)
 static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
-	struct acpi_pci_driver *driver;
 
 	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->remove)
-			driver->remove(root);
 	acpi_pci_slot_remove(root);
 	acpiphp_remove_bridge(root);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 90be989..8e2b65f 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -137,15 +137,6 @@ void acpi_penalize_isa_irq(int irq, int active);
 
 void acpi_pci_irq_disable (struct pci_dev *dev);
 
-struct acpi_pci_driver {
-	struct list_head node;
-	int (*add)(struct acpi_pci_root *root);
-	void (*remove)(struct acpi_pci_root *root);
-};
-
-int acpi_pci_register_driver(struct acpi_pci_driver *driver);
-void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
-
 extern int ec_read(u8 addr, u8 *val);
 extern int ec_write(u8 addr, u8 val);
 extern int ec_transaction(u8 command,

