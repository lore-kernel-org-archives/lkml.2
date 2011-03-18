Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1CREWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:22:06 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30727 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1CREV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:21:59 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-Id: <20110318041801.2349.33357.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [RFC][PATCH v2]: PCI: PCIe links may not get configured for ASPM under POWERSAVE mode
Date: Fri, 18 Mar 2011 04:21:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 -> v1:
	. Kept the logic in pci_raw_set_power_state
	. Changed the ASPM enabling logic
	. Modified the text that describes the problem

v1	: http://marc.info/?l=linux-pci&m=130013164703283&w=2

The assumption made in commit 41cd766b065970ff6f6c89dd1cf55fa706c84a3d 
(PCI: Don't enable aspm before drivers have had a chance to veto it) that
pci_enable_device() will result in re-configuring ASPM when aspm_policy is 
POWERSAVE is no longer valid.  This is due to commit 
97c145f7c87453cec90e91238fba5fe2c1561b32 (PCI: read current power state 
at enable time) which resets dev->current_state to D0. This makes the
equality check (below) become true, so pcie_aspm_pm_state_change() never
gets called.
./drivers/pci/pci.c: pci_raw_set_pci_power_state()
546         /* Check if we're already there */
547         if (dev->current_state == state)
548                 return 0;

So OSPM doesnn't configure the PCIe links for ASPM.

The patch below does the following:
At the end of each Root Bridge scan make a call to configure ASPM when the
ASPM policy is set to "powersave" mode. Note that if a previous pass had 
completed the configuration for all devices under that Bridge then the 
configuration will not take place again because pcie_config_aspm_link() 
checks to see if the link is already in the requested state.
We won't reconfigure ASPM when _OSC control is not granted. In fact, we will
disable ASPM in that situation. This is to protect systems with a buggy BIOS
that did not set the FADT bit even though the underlying HW can't do ASPM.

To turn "on" ASPM the minimum the BIOS needs to do:
1. Clear the ACPI FADT "ASPM Controls" bit. 
2. Support _OSC appropriately

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl> 
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8524939..c0655aa 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -32,6 +32,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
+#include <linux/pci-aspm.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
@@ -591,12 +592,22 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 
 		status = acpi_pci_osc_control_set(device->handle, &flags,
 					OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-		if (ACPI_SUCCESS(status))
+
+		if (ACPI_SUCCESS(status)) {
 			dev_info(root->bus->bridge,
 				"ACPI _OSC control (0x%02x) granted\n", flags);
-		else
+			/*
+			 * When aspm_policy is POWERSAVE, this
+			 * call ensures that ASPM is configured.
+			 */
+			pcie_aspm_reconfig_link(root->bus->self);
+		} else {
 			dev_dbg(root->bus->bridge,
 				"ACPI _OSC request failed (code %d)\n", status);
+			printk(KERN_INFO "Unable to assume _OSC PCIe control."
+				" Disabling ASPM.\n");
+			pcie_no_aspm();
+		}
 	}
 
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 3188cd9..1316745 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -742,6 +742,29 @@ void pci_disable_link_state(struct pci_dev *pdev, int state)
 }
 EXPORT_SYMBOL(pci_disable_link_state);
 
+void pcie_aspm_reconfig_link(struct pci_dev *pdev)
+{
+	struct pcie_link_state *link = NULL;
+
+	if (aspm_disabled)
+		return;
+	if (aspm_policy != POLICY_POWERSAVE)
+		return;
+
+	down_read(&pci_bus_sem);
+	mutex_lock(&aspm_lock);
+
+	if (list_empty(&link_list))
+		goto out;
+	list_for_each_entry(link, &link_list, sibling) {
+		pcie_config_aspm_link(link, policy_to_aspm_state(link));
+		pcie_set_clkpm(link, policy_to_clkpm_state(link));
+	}
+out:
+	mutex_unlock(&aspm_lock);
+	up_read(&pci_bus_sem);
+}
+
 static int pcie_aspm_set_policy(const char *val, struct kernel_param *kp)
 {
 	int i;
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 5130d0d..595654a 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
-#include <linux/pci-aspm.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -356,10 +355,8 @@ int pcie_port_device_register(struct pci_dev *dev)
 
 	/* Get and check PCI Express port services */
 	capabilities = get_port_device_capability(dev);
-	if (!capabilities) {
-		pcie_no_aspm();
+	if (!capabilities)
 		return 0;
-	}
 
 	pci_set_master(dev);
 	/*
diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
index ce68105..216b196 100644
--- a/include/linux/pci-aspm.h
+++ b/include/linux/pci-aspm.h
@@ -26,6 +26,7 @@
 extern void pcie_aspm_init_link_state(struct pci_dev *pdev);
 extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
 extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
+extern void pcie_aspm_reconfig_link(struct pci_dev *pdev);
 extern void pci_disable_link_state(struct pci_dev *pdev, int state);
 extern void pcie_clear_aspm(void);
 extern void pcie_no_aspm(void);
@@ -39,6 +40,9 @@ static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 static inline void pcie_aspm_pm_state_change(struct pci_dev *pdev)
 {
 }
+static inline void pcie_aspm_reconfig_link(struct pci_dev *pdev)
+{
+}
 static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
 {
 }
