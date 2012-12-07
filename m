Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946179Ab2LGG0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGG0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:26:20 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 14/15] PCI/ACPI: Add "pci_slot" functionality statically
	within "pci_root"
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:26:17 -0700
Message-ID: <20121207062617.11051.9895.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the "ACPI PCI Slot Detection Driver ("pci_slot")" conversion in place
- being statically built-in to the kernel and no longer capable of being a
kernel module - remove the use of acpi_pci_[un]register_driver() and add
its functionality from directly within the "pci_root" driver.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/pci_root.c  |    2 ++
 drivers/acpi/pci_slot.c  |   27 ++-------------------------
 include/linux/pci-acpi.h |    8 ++++++++
 3 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index f9be8fb..42566e2 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -651,6 +651,7 @@ static int acpi_pci_root_start(struct acpi_device *device)
 		if (driver->add)
 			driver->add(root);
 	acpiphp_add_bridge(root);
+	acpi_pci_slot_add(root);
 	mutex_unlock(&acpi_pci_root_lock);
 
 	return 0;
@@ -665,6 +666,7 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->remove)
 			driver->remove(root);
+	acpi_pci_slot_remove(root);
 	acpiphp_remove_bridge(root);
 
 	device_set_run_wake(root->bus->bridge, false);
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index efa58af..b3944a8 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -67,15 +67,8 @@ struct acpi_pci_slot {
 	struct list_head list;		/* node in the list of slots */
 };
 
-static int acpi_pci_slot_add(struct acpi_pci_root *root);
-static void acpi_pci_slot_remove(struct acpi_pci_root *root);
-
 static LIST_HEAD(slot_list);
 static DEFINE_MUTEX(slot_list_lock);
-static struct acpi_pci_driver acpi_pci_slot_driver = {
-	.add = acpi_pci_slot_add,
-	.remove = acpi_pci_slot_remove,
-};
 
 static int
 check_slot(acpi_handle handle, unsigned long long *sun)
@@ -294,7 +287,7 @@ static struct dmi_system_id acpi_pci_slot_dmi_table[] = {
  * acpi_pci_slot_add
  * @handle: points to an acpi_pci_root
  */
-static int
+int
 acpi_pci_slot_add(struct acpi_pci_root *root)
 {
 	static bool inited = false;
@@ -316,7 +309,7 @@ acpi_pci_slot_add(struct acpi_pci_root *root)
  * acpi_pci_slot_remove
  * @handle: points to an acpi_pci_root
  */
-static void
+void
 acpi_pci_slot_remove(struct acpi_pci_root *root)
 {
 	struct acpi_pci_slot *slot, *tmp;
@@ -335,19 +328,3 @@ acpi_pci_slot_remove(struct acpi_pci_root *root)
 	}
 	mutex_unlock(&slot_list_lock);
 }
-
-static int __init
-acpi_pci_slot_init(void)
-{
-	acpi_pci_register_driver(&acpi_pci_slot_driver);
-	return 0;
-}
-
-static void __exit
-acpi_pci_slot_exit(void)
-{
-	acpi_pci_unregister_driver(&acpi_pci_slot_driver);
-}
-
-module_init(acpi_pci_slot_init);
-module_exit(acpi_pci_slot_exit);
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index bc5b763..339ea97 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -57,4 +57,12 @@ static inline void acpiphp_add_bridge(struct acpi_pci_root *) { }
 static inline void acpiphp_remove_bridge(struct acpi_pci_root *) { }
 #endif /* !CONFIG_HOTPLUG_PCI_ACPI */
 
+#ifdef CONFIG_ACPI_PCI_SLOT
+extern int acpi_pci_slot_add(struct acpi_pci_root *root);
+extern void acpi_pci_slot_remove(struct acpi_pci_root *root);
+#else /* !CONFIG_ACPI_PCI_SLOT */
+static inline int acpi_pci_slot_add(struct acpi_pci_root *) { return 0; }
+static inline void acpi_pci_slot_remove(struct acpi_pci_root *) { }
+#endif /* !CONFIG_ACPI_PCI_SLOT */
+
 #endif	/* _PCI_ACPI_H_ */

