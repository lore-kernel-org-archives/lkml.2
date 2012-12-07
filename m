Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946089Ab2LGGZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:51 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 09/15] PCI/acpiphp: Add "acpiphp" functionality statically
	within "pci_root"
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:48 -0700
Message-ID: <20121207062548.11051.29535.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the "ACPI Hot Plug PCI Controller Driver ("acpiphp")" conversion in
place - being statically built-in to the kernel and no longer capable of
being a kernel module - remove the use of acpi_pci_[un]register_driver()
and add its functionality from directly within the "pci_root" driver.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/pci_root.c            |    2 ++
 drivers/pci/hotplug/acpiphp.h      |    3 ---
 drivers/pci/hotplug/acpiphp_core.c |   23 -----------------------
 drivers/pci/hotplug/acpiphp_glue.c |    5 -----
 include/linux/pci-acpi.h           |    8 ++++++++
 5 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index bce469c..d890322 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -648,6 +648,7 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
 			driver->add(root);
+	acpiphp_add_bridge(root);
 	mutex_unlock(&acpi_pci_root_lock);
 
 	pci_bus_add_devices(root->bus);
@@ -664,6 +665,7 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->remove)
 			driver->remove(root);
+	acpiphp_remove_bridge(root);
 
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index bf62ac8..13428c9 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -191,9 +191,6 @@ extern int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
 extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 
 /* acpiphp_glue.c */
-extern struct acpi_pci_driver acpi_pci_hp_driver;
-extern int acpiphp_add_bridge(struct acpi_pci_root *root);
-extern void acpiphp_remove_bridge(struct acpi_pci_root *root);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 extern int acpiphp_enable_slot(struct acpiphp_slot *slot);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 5536b42..fb97e8b 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -349,26 +349,3 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	if (retval)
 		err("pci_hp_deregister failed with error %d\n", retval);
 }
-
-
-static int __init acpiphp_init(void)
-{
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
-
-	if (!acpi_pci_disabled)
-		/* initialize internal data structure etc. */
-		acpi_pci_register_driver(&acpi_pci_hp_driver);
-
-	return 0;
-}
-
-
-static void __exit acpiphp_exit(void)
-{
-	if (!acpi_pci_disabled)
-		/* deallocate internal data structures etc. */
-		acpi_pci_unregister_driver(&acpi_pci_hp_driver);
-}
-
-module_init(acpiphp_init);
-module_exit(acpiphp_exit);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 3d5d7da..a4218cb 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1407,11 +1407,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 			      _handle_hotplug_event_func);
 }
 
-struct acpi_pci_driver acpi_pci_hp_driver = {
-	.add =		acpiphp_add_bridge,
-	.remove =	acpiphp_remove_bridge,
-};
-
 /**
  * acpiphp_enable_slot - power on slot
  * @slot: ACPI PHP slot
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 9a22b5e..3197070 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -49,4 +49,12 @@ extern bool aer_acpi_firmware_first(void);
 static inline bool aer_acpi_firmware_first(void) { return false; }
 #endif
 
+#ifdef CONFIG_HOTPLUG_PCI_ACPI
+extern int acpiphp_add_bridge(struct acpi_pci_root *root);
+extern void acpiphp_remove_bridge(struct acpi_pci_root *root);
+#else /* !CONFIG_HOTPLUG_PCI_ACPI */
+static inline int acpiphp_add_bridge(struct acpi_pci_root *) { return 0; }
+static inline void acpiphp_remove_bridge(struct acpi_pci_root *) { }
+#endif /* !CONFIG_HOTPLUG_PCI_ACPI */
+
 #endif	/* _PCI_ACPI_H_ */

