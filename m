Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0GXXGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 19:06:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab0GXXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 19:06:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pci@vger.kernel.org
Subject: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services simultaneously
Date: Sun, 25 Jul 2010 01:05:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007250105.23610.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It turns out that asking ACPI BIOS, through _OSC, for control of each
PCIe port native service individually sometimes confuses the BIOS if
one sevice is requested while the others are not (eg. requesting
control of the native PCIe PME without requesting control of the
native PCIe hot-plug at the same time leads to interrupt storms on
some systems).

For this reason rework the PCIe port driver so that control of all
native services is requested simultaneously and pcie_portdrv_probe()
fails if the BIOS refuses to satisfy that request.  Make it possible
to override this behavior using a new command line switch pcie_ports=
that can be set to 'auto' (ask the BIOS, the default), 'native'
(use the PCIe native services regardless of the BIOS response the
the control request), or 'compat' (do not use the PCIe native
services at all).

Accordingly, rework the existing PCIe port service drivers so that
they don't request control of the services directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This is a total RFC, I didn't have the time to really test it.  Also, it's
missing documentation updates related to the added/changed command line
options.

Comments welcome.

Rafael

---
 drivers/acpi/pci_root.c              |    5 +-
 drivers/pci/hotplug/acpi_pcihp.c     |    4 --
 drivers/pci/hotplug/pciehp.h         |   12 ------
 drivers/pci/hotplug/pciehp_core.c    |    9 ----
 drivers/pci/pcie/Makefile            |    3 +
 drivers/pci/pcie/aer/aerdrv_acpi.c   |   36 -------------------
 drivers/pci/pcie/aer/aerdrv_core.c   |    3 -
 drivers/pci/pcie/pme/Makefile        |    8 ----
 drivers/pci/pcie/pme/pcie_pme.c      |   64 ++---------------------------------
 drivers/pci/pcie/pme/pcie_pme.h      |   28 ---------------
 drivers/pci/pcie/pme/pcie_pme_acpi.c |   54 -----------------------------
 drivers/pci/pcie/portdrv.h           |   19 ++++++++++
 drivers/pci/pcie/portdrv_acpi.c      |   47 +++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c      |   20 +++++++++-
 drivers/pci/pcie/portdrv_pci.c       |   41 ++++++++++++++++++----
 15 files changed, 129 insertions(+), 224 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -29,6 +29,32 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
+/*
+ * If this switch is set, ACPI _OSC will be used to determine whether or not to
+ * enable PCIe port native services.
+ */
+static bool pcie_ports_auto = true;
+
+/* If this switch is set, PCIe port native services should not be enabled. */
+static bool pcie_ports_disabled;
+
+static int __init pcie_port_setup(char *str)
+{
+	if (!strncmp(str, "auto", 4)) {
+		pcie_ports_disabled = false;
+		pcie_ports_auto = true;
+	} else if (!strncmp(str, "native", 6)) {
+		pcie_ports_disabled = false;
+		pcie_ports_auto = false;
+	} else if (!strncmp(str, "compat", 6)) {
+		pcie_ports_disabled = true;
+		pcie_ports_auto = false;
+	}
+
+	return 1;
+}
+__setup("pcie_ports=", pcie_port_setup);
+
 /* global data */
 
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
@@ -82,6 +108,11 @@ static int __devinit pcie_portdrv_probe(
 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
+
+	status = pcie_port_platform_notify(dev);
+	if (status && pcie_ports_auto)
+			return status;
+
 	status = pcie_port_device_register(dev);
 	if (status)
 		return status;
@@ -301,6 +332,9 @@ static int __init pcie_portdrv_init(void
 {
 	int retval;
 
+	if (pcie_ports_disabled)
+		return -EACCES;
+
 	dmi_check_system(pcie_portdrv_dmi_table);
 
 	retval = pcie_port_bus_register();
@@ -315,11 +349,4 @@ static int __init pcie_portdrv_init(void
 	return retval;
 }
 
-static void __exit pcie_portdrv_exit(void)
-{
-	pci_unregister_driver(&pcie_portdriver);
-	pcie_port_bus_unregister();
-}
-
 module_init(pcie_portdrv_init);
-module_exit(pcie_portdrv_exit);
Index: linux-2.6/drivers/pci/pcie/portdrv_acpi.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/pcie/portdrv_acpi.c
@@ -0,0 +1,47 @@
+/*
+ * PCIe Port Native Services Support, ACPI-Related Part
+ *
+ * Copyright (C) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License V2.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/pci-acpi.h>
+
+/**
+ * pcie_port_acpi_setup - Request the BIOS to release control of PCIe services.
+ * @port - PCIe Port service for a root port or event collector.
+ *
+ * Invoked when @port is identified as a PCIe port device.  To avoid conflicts
+ * with the BIOS PCIe port native services support requires the BIOS to yield
+ * PCIe control of these services to the kernel.
+ *
+ * NOTE: It turns out that we cannot do that for individual port services
+ * separately, because that would make some systems work incorrectly.
+ */
+int pcie_port_acpi_setup(struct pci_dev *port)
+{
+	acpi_status status = AE_NOT_FOUND;
+	acpi_handle handle;
+
+	if (acpi_pci_disabled)
+		return -ENOSYS;
+
+	handle = acpi_find_root_bridge_handle(port);
+	if (!handle)
+		return -EINVAL;
+
+	status = acpi_pci_osc_control_set(handle,
+			OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL |
+			OSC_PCI_EXPRESS_AER_CONTROL |
+			OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |
+			OSC_PCI_EXPRESS_PME_CONTROL);
+
+	return ACPI_FAILURE(status) ? -ENODEV : 0;
+}
Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -30,6 +30,8 @@ extern void pcie_port_device_remove(stru
 extern int __must_check pcie_port_bus_register(void);
 extern void pcie_port_bus_unregister(void);
 
+struct pci_dev;
+
 #ifdef CONFIG_PCIE_PME
 extern bool pcie_pme_msi_disabled;
 
@@ -42,9 +44,26 @@ static inline bool pcie_pme_no_msi(void)
 {
 	return pcie_pme_msi_disabled;
 }
+
+extern void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable);
 #else /* !CONFIG_PCIE_PME */
 static inline void pcie_pme_disable_msi(void) {}
 static inline bool pcie_pme_no_msi(void) { return false; }
+static inline void pcie_pme_interrupt_enable(struct pci_dev *dev, bool en) {}
 #endif /* !CONFIG_PCIE_PME */
 
+#ifdef CONFIG_ACPI
+extern int pcie_port_acpi_setup(struct pci_dev *port);
+
+static inline int pcie_port_platform_notify(struct pci_dev *port)
+{
+	return pcie_port_acpi_setup(port);
+}
+#else /* !CONFIG_ACPI */
+static inline int pcie_port_platform_notify(struct pci_dev *port)
+{
+	return 0;
+}
+#endif /* !CONFIG_ACPI */
+
 #endif /* _PORTDRV_H_ */
Index: linux-2.6/drivers/pci/pcie/Makefile
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/Makefile
+++ linux-2.6/drivers/pci/pcie/Makefile
@@ -6,10 +6,11 @@
 obj-$(CONFIG_PCIEASPM)		+= aspm.o
 
 pcieportdrv-y			:= portdrv_core.o portdrv_pci.o portdrv_bus.o
+pcieportdrv-$(CONFIG_ACPI)	+= portdrv_acpi.o
 
 obj-$(CONFIG_PCIEPORTBUS)	+= pcieportdrv.o
 
 # Build PCI Express AER if needed
 obj-$(CONFIG_PCIEAER)		+= aer/
 
-obj-$(CONFIG_PCIE_PME) += pme/
+obj-$(CONFIG_PCIE_PME) += pme/pcie_pme.o
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pcieport_if.h>
+#include <linux/aer.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -242,18 +243,31 @@ static int get_port_device_capability(st
 	/* Hot-Plug Capable */
 	if (reg16 & PCI_EXP_FLAGS_SLOT) {
 		pci_read_config_dword(dev, pos + PCI_EXP_SLTCAP, &reg32);
-		if (reg32 & PCI_EXP_SLTCAP_HPC)
+		if (reg32 & PCI_EXP_SLTCAP_HPC) {
 			services |= PCIE_PORT_SERVICE_HP;
+			/*
+			 * Disable hot-plug interrupts in case the hot-plug
+			 * service driver is not loaded.
+			 */
+			pos += PCI_EXP_SLTCTL;
+			pci_read_config_word(dev, pos, &reg16);
+			reg16 &= ~(PCI_EXP_SLTCTL_CCIE | PCI_EXP_SLTCTL_HPIE);
+			pci_write_config_word(dev, pos, reg16);
+		}
 	}
 	/* AER capable */
-	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR))
+	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR)) {
 		services |= PCIE_PORT_SERVICE_AER;
+		pci_disable_pcie_error_reporting(dev);
+	}
 	/* VC support */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_VC))
 		services |= PCIE_PORT_SERVICE_VC;
 	/* Root ports are capable of generating PME too */
-	if (dev->pcie_type == PCI_EXP_TYPE_ROOT_PORT)
+	if (dev->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
 		services |= PCIE_PORT_SERVICE_PME;
+		pcie_pme_interrupt_enable(dev, false);
+	}
 
 	return services;
 }
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -401,8 +401,9 @@ acpi_status acpi_pci_osc_control_set(acp
 			goto out;
 	}
 	if ((root->osc_control_qry & control_req) != control_req) {
-		printk(KERN_DEBUG
-		       "Firmware did not grant requested _OSC control\n");
+		printk(KERN_INFO
+		       "Firmware does not grant _OSC control for mask 0x%02x\n",
+		       control_req);
 		status = AE_SUPPORT;
 		goto out;
 	}
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme.c
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
@@ -24,37 +24,12 @@
 #include <linux/pm_runtime.h>
 
 #include "../../pci.h"
-#include "pcie_pme.h"
+#include "../portdrv.h"
 
 #define PCI_EXP_RTSTA_PME	0x10000 /* PME status */
 #define PCI_EXP_RTSTA_PENDING	0x20000 /* PME pending */
 
 /*
- * If set, this switch will prevent the PCIe root port PME service driver from
- * being registered.  Consequently, the interrupt-based PCIe PME signaling will
- * not be used by any PCIe root ports in that case.
- */
-static bool pcie_pme_disabled = true;
-
-/*
- * The PCI Express Base Specification 2.0, Section 6.1.8, states the following:
- * "In order to maintain compatibility with non-PCI Express-aware system
- * software, system power management logic must be configured by firmware to use
- * the legacy mechanism of signaling PME by default.  PCI Express-aware system
- * software must notify the firmware prior to enabling native, interrupt-based
- * PME signaling."  However, if the platform doesn't provide us with a suitable
- * notification mechanism or the notification fails, it is not clear whether or
- * not we are supposed to use the interrupt-based PCIe PME signaling.  The
- * switch below can be used to indicate the desired behaviour.  When set, it
- * will make the kernel use the interrupt-based PCIe PME signaling regardless of
- * the platform notification status, although the kernel will attempt to notify
- * the platform anyway.  When unset, it will prevent the kernel from using the
- * the interrupt-based PCIe PME signaling if the platform notification fails,
- * which is the default.
- */
-static bool pcie_pme_force_enable;
-
-/*
  * If this switch is set, MSI will not be used for PCIe PME signaling.  This
  * causes the PCIe port driver to use INTx interrupts only, but it turns out
  * that using MSI for PCIe PME signaling doesn't play well with PCIe PME-based
@@ -64,38 +39,13 @@ bool pcie_pme_msi_disabled;
 
 static int __init pcie_pme_setup(char *str)
 {
-	if (!strncmp(str, "auto", 4))
-		pcie_pme_disabled = false;
-	else if (!strncmp(str, "force", 5))
-		pcie_pme_force_enable = true;
-
-	str = strchr(str, ',');
-	if (str) {
-		str++;
-		str += strspn(str, " \t");
-		if (*str && !strcmp(str, "nomsi"))
-			pcie_pme_msi_disabled = true;
-	}
+	if (!strncmp(str, "nomsi", 5))
+		pcie_pme_msi_disabled = true;
 
 	return 1;
 }
 __setup("pcie_pme=", pcie_pme_setup);
 
-/**
- * pcie_pme_platform_setup - Ensure that the kernel controls the PCIe PME.
- * @srv: PCIe PME root port service to use for carrying out the check.
- *
- * Notify the platform that the native PCIe PME is going to be used and return
- * 'true' if the control of the PCIe PME registers has been acquired from the
- * platform.
- */
-static bool pcie_pme_platform_setup(struct pcie_device *srv)
-{
-	if (!pcie_pme_platform_notify(srv))
-		return true;
-	return pcie_pme_force_enable;
-}
-
 struct pcie_pme_service_data {
 	spinlock_t lock;
 	struct pcie_device *srv;
@@ -108,7 +58,7 @@ struct pcie_pme_service_data {
  * @dev: PCIe root port or event collector.
  * @enable: Enable or disable the interrupt.
  */
-static void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
+void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
 {
 	int rtctl_pos;
 	u16 rtctl;
@@ -417,9 +367,6 @@ static int pcie_pme_probe(struct pcie_de
 	struct pcie_pme_service_data *data;
 	int ret;
 
-	if (!pcie_pme_platform_setup(srv))
-		return -EACCES;
-
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -509,8 +456,7 @@ static struct pcie_port_service_driver p
  */
 static int __init pcie_pme_service_init(void)
 {
-	return pcie_pme_disabled ?
-		-ENODEV : pcie_port_service_register(&pcie_pme_driver);
+	return pcie_port_service_register(&pcie_pme_driver);
 }
 
 module_init(pcie_pme_service_init);
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * drivers/pci/pcie/pme/pcie_pme.h
- *
- * PCI Express Root Port PME signaling support
- *
- * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
- */
-
-#ifndef _PCIE_PME_H_
-#define _PCIE_PME_H_
-
-struct pcie_device;
-
-#ifdef CONFIG_ACPI
-extern int pcie_pme_acpi_setup(struct pcie_device *srv);
-
-static inline int pcie_pme_platform_notify(struct pcie_device *srv)
-{
-	return pcie_pme_acpi_setup(srv);
-}
-#else /* !CONFIG_ACPI */
-static inline int pcie_pme_platform_notify(struct pcie_device *srv)
-{
-	return 0;
-}
-#endif /* !CONFIG_ACPI */
-
-#endif
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme_acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/pcie_pme_acpi.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * PCIe Native PME support, ACPI-related part
- *
- * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License V2.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
-#include <linux/pcieport_if.h>
-
-/**
- * pcie_pme_acpi_setup - Request the ACPI BIOS to release control over PCIe PME.
- * @srv - PCIe PME service for a root port or event collector.
- *
- * Invoked when the PCIe bus type loads PCIe PME service driver.  To avoid
- * conflict with the BIOS PCIe support requires the BIOS to yield PCIe PME
- * control to the kernel.
- */
-int pcie_pme_acpi_setup(struct pcie_device *srv)
-{
-	acpi_status status = AE_NOT_FOUND;
-	struct pci_dev *port = srv->port;
-	acpi_handle handle;
-	int error = 0;
-
-	if (acpi_pci_disabled)
-		return -ENOSYS;
-
-	dev_info(&port->dev, "Requesting control of PCIe PME from ACPI BIOS\n");
-
-	handle = acpi_find_root_bridge_handle(port);
-	if (!handle)
-		return -EINVAL;
-
-	status = acpi_pci_osc_control_set(handle,
-			OSC_PCI_EXPRESS_PME_CONTROL |
-			OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-	if (ACPI_FAILURE(status)) {
-		dev_info(&port->dev,
-			"Failed to receive control of PCIe PME service: %s\n",
-			(status == AE_SUPPORT || status == AE_NOT_FOUND) ?
-			"no _OSC support" : "ACPI _OSC failed");
-		error = -ENODEV;
-	}
-
-	return error;
-}
Index: linux-2.6/drivers/pci/pcie/pme/Makefile
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/pme/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for PCI-Express Root Port PME signaling driver
-#
-
-obj-$(CONFIG_PCIE_PME) += pmedriver.o
-
-pmedriver-objs := pcie_pme.o
-pmedriver-$(CONFIG_ACPI) += pcie_pme_acpi.o
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv_acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -19,42 +19,6 @@
 #include <acpi/apei.h>
 #include "aerdrv.h"
 
-/**
- * aer_osc_setup - run ACPI _OSC method
- * @pciedev: pcie_device which AER is being enabled on
- *
- * @return: Zero on success. Nonzero otherwise.
- *
- * Invoked when PCIe bus loads AER service driver. To avoid conflict with
- * BIOS AER support requires BIOS to yield AER control to OS native driver.
- **/
-int aer_osc_setup(struct pcie_device *pciedev)
-{
-	acpi_status status = AE_NOT_FOUND;
-	struct pci_dev *pdev = pciedev->port;
-	acpi_handle handle = NULL;
-
-	if (acpi_pci_disabled)
-		return -1;
-
-	handle = acpi_find_root_bridge_handle(pdev);
-	if (handle) {
-		status = acpi_pci_osc_control_set(handle,
-					OSC_PCI_EXPRESS_AER_CONTROL |
-					OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-	}
-
-	if (ACPI_FAILURE(status)) {
-		dev_printk(KERN_DEBUG, &pciedev->device, "AER service couldn't "
-			   "init device: %s\n",
-			   (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
-			   "no _OSC support" : "_OSC failed");
-		return -1;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_ACPI_APEI
 static inline int hest_match_pci(struct acpi_hest_aer_common *p,
 				 struct pci_dev *pci)
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv_core.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv_core.c
@@ -777,9 +777,6 @@ int aer_init(struct pcie_device *dev)
 		goto out;
 	}
 
-	if (aer_osc_setup(dev))
-		goto out;
-
 	return 0;
 out:
 	if (forceload) {
Index: linux-2.6/drivers/pci/hotplug/acpi_pcihp.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/acpi_pcihp.c
+++ linux-2.6/drivers/pci/hotplug/acpi_pcihp.c
@@ -338,9 +338,7 @@ int acpi_get_hp_hw_control_from_firmware
 	acpi_handle chandle, handle;
 	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	flags &= (OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |
-		  OSC_SHPC_NATIVE_HP_CONTROL |
-		  OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	flags &= OSC_SHPC_NATIVE_HP_CONTROL;
 	if (!flags) {
 		err("Invalid flags %u specified!\n", flags);
 		return -EINVAL;
Index: linux-2.6/drivers/pci/hotplug/pciehp.h
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp.h
+++ linux-2.6/drivers/pci/hotplug/pciehp.h
@@ -176,19 +176,7 @@ static inline void pciehp_firmware_init(
 {
 	pciehp_acpi_slot_detection_init();
 }
-
-static inline int pciehp_get_hp_hw_control_from_firmware(struct pci_dev *dev)
-{
-	int retval;
-	u32 flags = (OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |
-		     OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-	retval = acpi_get_hp_hw_control_from_firmware(dev, flags);
-	if (retval)
-		return retval;
-	return pciehp_acpi_slot_detection_check(dev);
-}
 #else
 #define pciehp_firmware_init()				do {} while (0)
-#define pciehp_get_hp_hw_control_from_firmware(dev) 	0
 #endif 				/* CONFIG_ACPI */
 #endif				/* _PCIEHP_H */
Index: linux-2.6/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_core.c
@@ -59,7 +59,7 @@ module_param(pciehp_force, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
-MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
+MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if OSHP is missing");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -231,13 +231,6 @@ static int pciehp_probe(struct pcie_devi
 	struct slot *slot;
 	u8 occupied, poweron;
 
-	if (pciehp_force)
-		dev_info(&dev->device,
-			 "Bypassing BIOS check for pciehp use on %s\n",
-			 pci_name(dev->port));
-	else if (pciehp_get_hp_hw_control_from_firmware(dev->port))
-		goto err_out_none;
-
 	ctrl = pcie_init(dev);
 	if (!ctrl) {
 		dev_err(&dev->device, "Controller initialization failed\n");
