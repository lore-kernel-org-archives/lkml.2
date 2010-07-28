Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0G1LAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:00:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0G1LAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:00:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services at once (v3)
Date: Wed, 28 Jul 2010 12:59:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201007250105.23610.rjw@sisk.pl> <20100727185628.GA17903@srcf.ucam.org> <201007280055.03306.rjw@sisk.pl>
In-Reply-To: <201007280055.03306.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281259.10023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 28, 2010, Rafael J. Wysocki wrote:
> On Tuesday, July 27, 2010, Matthew Garrett wrote:
> > On Tue, Jul 27, 2010 at 08:42:39PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, July 27, 2010, Matthew Garrett wrote:
> > > > I've done some more testing of this and found that my intial belief 
> > > > (supported by Microsoft's documentation...) that all PCIe support had to 
> > > > be handed over for any to be used is incorrect. It turns out that the 
> > > > firmware must support native hotplug, native power management and PCI 
> > > > express capability structure control - ie, SHPC and AER aren't required.
> > > 
> > > But the ACPI spec says quite explicitly that PCIe capability control is
> > > necessary for AER as well.
> > 
> > I may not have been clear. If the firmware doesn't report AER, Windows 
> > will use PME and hotplug. If the firmware doesn't support hotplug, 
> > Windows will *not* use PME or AER, and ditto if it doesn't support PME.
> > 
> > > > (2) If any of bits 0, 2 and 4 are unsupported, disable all PCIe support 
> > > > via _OSC
> > > 
> > > I guess you mean "don't request control of that services at all"?
> > 
> > I mean pass 0 as the third dword in our _OSC call.
> 
> If my reading of the ACPI spec is correct, this won't have any effect.
> 
> > > > (3) Ask for the set of supported bits & 0x1d
> > > 
> > > Really, if we try to treat native PME, native hot-plug and AER separately
> > > (which is our current approach), we fall into a Catch 22 situation where
> > > each of them needs PCIe capability control and once we've received the
> > > control of that, we have no choice but to use the other native sevices as well.
> > 
> > It seems that it's valid to have hotplug and PME without AER. The 
> > behaviour of Windows for each bit is:
> > 
> > 0 Hotplug             Required
> > 1 SHPHC               Will never request
> > 2 PME                 Required
> > 3 AER                 Optional
> > 4 capability control  Required
> > 
> > So firmware can refuse to support SHPHC and AER and still get PCIe 
> > support, but if any of the required bits aren't available Windows won't 
> > use *any* of the _OSC-provided functions.
> 
> OK, below is an updated patch (tested only on a system without _OSC :-)).
> 
> It first checks what features we can get control of and if the PCIe capability
> structure is not one of them, pcie_portdrv_probe() will fail.  Otherwise it
> only requests the features that the BIOS is going to grant us control of.
> 
> Comments welcome.

Alas, it was buggy.

...
> @@ -302,13 +316,13 @@ static int pcie_device_init(struct pci_d
>   * Allocate the port extension structure and register services associated with
>   * the port.
>   */
> -int pcie_port_device_register(struct pci_dev *dev)
> +int pcie_port_device_register(struct pci_dev *dev, int cap_mask)
>  {
>  	int status, capabilities, i, nr_service;
>  	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
>  
>  	/* Get and check PCI Express port services */
> -	capabilities = get_port_device_capability(dev);
> +	capabilities = get_port_device_capability(dev) & cap_mask;
>  	if (!capabilities)
>  		return -ENODEV;

We can't do it this way, because get_port_device_capability() writes to the
config registers.

Below is a fixed version.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / PCIe: Ask BIOS for control of all native services at once (v3)

PCIe port service drivers ask the BIOS, through _OSC, for control of
the services they handle.  Unfortunately, each of them individually
asks for control of the PCIe capability structure and if that is
granted, some BIOSes expect that the other PCIe port services will be
configured and handled by the kernel as well.  If that is not the
case (eg. one of the PCIe port service drivers is not loaded), the
BIOS may be confused and may cause the system as a whole to misbehave
(eg. on one of such systems enabling the native PCIe PME service
without loading the native PCIe hot-plug service driver causes a
storm of ACPI notify requests to appear).

For this reason rework the PCIe port driver so that (1) it checks
which native PCIe port services can be enabled, according to the
BIOS, and (2) it requests control of all these services
simultaneously.  In particular, this causes pcie_portdrv_probe() to
fail if the BIOS refuses to grant control of the PCIe capability
structure, which means that no native PCIe port services can be
enabled for the PCIe root complex the given port belongs to.

Make it possible to override this behavior using a new command line
switch pcie_ports= that can be set to 'auto' (ask the BIOS, the
default), 'native' (use the PCIe native services regardless of the
BIOS response to the control request), or 'compat' (do not use the
PCIe native services at all).

Accordingly, rework the existing PCIe port service drivers so that
they don't request control of the services directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/kernel-parameters.txt  |   17 ++++--
 drivers/acpi/pci_root.c              |   53 +++++++++++++++++++--
 drivers/pci/hotplug/acpi_pcihp.c     |    4 -
 drivers/pci/hotplug/pciehp.h         |   12 ----
 drivers/pci/hotplug/pciehp_acpi.c    |    4 -
 drivers/pci/hotplug/pciehp_core.c    |    4 -
 drivers/pci/pcie/Makefile            |    3 -
 drivers/pci/pcie/aer/aerdrv_acpi.c   |   36 --------------
 drivers/pci/pcie/aer/aerdrv_core.c   |   14 -----
 drivers/pci/pcie/pme/Makefile        |    8 ---
 drivers/pci/pcie/pme/pcie_pme.c      |   64 ++------------------------
 drivers/pci/pcie/pme/pcie_pme.h      |   28 -----------
 drivers/pci/pcie/pme/pcie_pme_acpi.c |   54 ---------------------
 drivers/pci/pcie/portdrv.h           |   22 ++++++++
 drivers/pci/pcie/portdrv_acpi.c      |   86 +++++++++++++++++++++++++++++++++++
 drivers/pci/pcie/portdrv_core.c      |   37 +++++++++++++--
 drivers/pci/pcie/portdrv_pci.c       |   37 ++++++++++++---
 include/linux/acpi.h                 |    1 
 include/linux/pcieport_if.h          |    5 ++
 19 files changed, 246 insertions(+), 243 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -29,6 +29,32 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
+/* If this switch is set, PCIe port native services should not be enabled. */
+bool pcie_ports_disabled;
+
+/*
+ * If this switch is set, ACPI _OSC will be used to determine whether or not to
+ * enable PCIe port native services.
+ */
+bool pcie_ports_auto = true;
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
@@ -82,6 +108,7 @@ static int __devinit pcie_portdrv_probe(
 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
+
 	status = pcie_port_device_register(dev);
 	if (status)
 		return status;
@@ -301,6 +328,9 @@ static int __init pcie_portdrv_init(void
 {
 	int retval;
 
+	if (pcie_ports_disabled)
+		return -EACCES;
+
 	dmi_check_system(pcie_portdrv_dmi_table);
 
 	retval = pcie_port_bus_register();
@@ -315,11 +345,4 @@ static int __init pcie_portdrv_init(void
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
@@ -0,0 +1,86 @@
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
+#include <linux/pcieport_if.h>
+
+#include "aer/aerdrv.h"
+
+/**
+ * pcie_port_acpi_setup - Request the BIOS to release control of PCIe services.
+ * @port: PCIe Port service for a root port or event collector.
+ * @srv_mask: Bit mask of services that can be enabled for @port.
+ *
+ * Invoked when @port is identified as a PCIe port device.  To avoid conflicts
+ * with the BIOS PCIe port native services support requires the BIOS to yield
+ * control of these services to the kernel.  The mask of services that the BIOS
+ * allows to be enabled for @port is written to @srv_mask.
+ *
+ * NOTE: It turns out that we cannot do that for individual port services
+ * separately, because that would make some systems work incorrectly.
+ */
+int pcie_port_acpi_setup(struct pci_dev *port, int *srv_mask)
+{
+	acpi_status status;
+	acpi_handle handle;
+	u32 flags, req_flags;
+
+	if (acpi_pci_disabled)
+		return 0;
+
+	handle = acpi_find_root_bridge_handle(port);
+	if (!handle)
+		return -EINVAL;
+
+	status = acpi_pci_osc_control_get(handle, &flags);
+	if (ACPI_FAILURE(status)) {
+		dev_info(&port->dev, "ACPI _OSC query failed (code %d)\n",
+			status);
+		return -ENODEV;
+	}
+
+	if (!(flags & OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)) {
+		dev_info(&port->dev,
+			"BIOS refuses to grant control of PCIe Capability "
+			"Structure\n");
+		return -EACCES;
+	}
+
+	req_flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL;
+	*srv_mask = PCIE_PORT_SERVICE_VC;
+	if (flags & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL) {
+		req_flags |= OSC_PCI_EXPRESS_NATIVE_HP_CONTROL;
+		*srv_mask |= PCIE_PORT_SERVICE_HP;
+	}
+	if (flags & OSC_PCI_EXPRESS_PME_CONTROL) {
+		req_flags |= OSC_PCI_EXPRESS_PME_CONTROL;
+		*srv_mask |= PCIE_PORT_SERVICE_PME;
+	}
+
+	if (pcie_aer_get_firmware_first(port)) {
+		dev_dbg(&port->dev, "PCIe errors handled by BIOS.\n");
+	} else if (flags & OSC_PCI_EXPRESS_AER_CONTROL) {
+		req_flags |= OSC_PCI_EXPRESS_AER_CONTROL;
+		*srv_mask |= PCIE_PORT_SERVICE_AER;
+	}
+
+	status = acpi_pci_osc_control_set(handle, req_flags);
+	if (ACPI_FAILURE(status)) {
+		dev_info(&port->dev, "ACPI _OSC request failed (code %d)\n",
+			status);
+		return -ENODEV;
+	}
+
+	return 0;
+}
Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -20,6 +20,9 @@
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
+extern bool pcie_ports_disabled;
+extern bool pcie_ports_auto;
+
 extern struct bus_type pcie_port_bus_type;
 extern int pcie_port_device_register(struct pci_dev *dev);
 #ifdef CONFIG_PM
@@ -30,6 +33,8 @@ extern void pcie_port_device_remove(stru
 extern int __must_check pcie_port_bus_register(void);
 extern void pcie_port_bus_unregister(void);
 
+struct pci_dev;
+
 #ifdef CONFIG_PCIE_PME
 extern bool pcie_pme_msi_disabled;
 
@@ -42,9 +47,26 @@ static inline bool pcie_pme_no_msi(void)
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
+extern int pcie_port_acpi_setup(struct pci_dev *port, int *mask);
+
+static inline int pcie_port_platform_notify(struct pci_dev *port, int *mask)
+{
+	return pcie_port_acpi_setup(port, mask);
+}
+#else /* !CONFIG_ACPI */
+static inline int pcie_port_platform_notify(struct pci_dev *port, int *mask)
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
@@ -236,24 +237,49 @@ static int get_port_device_capability(st
 	int services = 0, pos;
 	u16 reg16;
 	u32 reg32;
+	int cap_mask;
+	int err;
+
+	err = pcie_port_platform_notify(dev, &cap_mask);
+	if (pcie_ports_auto) {
+		if (err)
+			return 0;
+	} else {
+		cap_mask = PCIE_PORT_SERVICE_MASK;
+	}
 
 	pos = pci_pcie_cap(dev);
 	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
 	/* Hot-Plug Capable */
-	if (reg16 & PCI_EXP_FLAGS_SLOT) {
+	if ((cap_mask & PCIE_PORT_SERVICE_HP) && (reg16 & PCI_EXP_FLAGS_SLOT)) {
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
+	if ((cap_mask & PCIE_PORT_SERVICE_AER)
+	    && pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR)) {
 		services |= PCIE_PORT_SERVICE_AER;
+		pci_disable_pcie_error_reporting(dev);
+	}
 	/* VC support */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_VC))
 		services |= PCIE_PORT_SERVICE_VC;
 	/* Root ports are capable of generating PME too */
-	if (dev->pcie_type == PCI_EXP_TYPE_ROOT_PORT)
+	if ((cap_mask & PCIE_PORT_SERVICE_PME)
+	    && dev->pcie_type == PCI_EXP_TYPE_ROOT_PORT) {
 		services |= PCIE_PORT_SERVICE_PME;
+		pcie_pme_interrupt_enable(dev, false);
+	}
 
 	return services;
 }
@@ -494,6 +520,9 @@ static void pcie_port_shutdown_service(s
  */
 int pcie_port_service_register(struct pcie_port_service_driver *new)
 {
+	if (pcie_ports_disabled)
+		return -ENODEV;
+
 	new->driver.name = (char *)new->name;
 	new->driver.bus = &pcie_port_bus_type;
 	new->driver.probe = pcie_port_probe_service;
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -240,6 +240,9 @@ static acpi_status acpi_pci_query_osc(st
 	if (ACPI_SUCCESS(status)) {
 		root->osc_support_set = support_set;
 		root->osc_control_qry = result;
+		if (!root->osc_queried)
+			dev_info(root->bus->bridge,
+				"ACPI _OSC control mask: 0x%02x\n", result);
 		root->osc_queried = 1;
 	}
 	return status;
@@ -364,6 +367,42 @@ out:
 EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
 
 /**
+ * acpi_pci_osc_control_get - Get the _OSC bits the BIOS will grant control of.
+ * @handle: ACPI handle of a PCI root bridge (or PCIe Root Complex).
+ * @mask: Address to store the _OSC bits mask at.
+ **/
+acpi_status acpi_pci_osc_control_get(acpi_handle handle, u32 *mask)
+{
+	acpi_status status;
+	acpi_handle tmp;
+	struct acpi_pci_root *root;
+
+	root = acpi_pci_find_root(handle);
+	if (!root)
+		return AE_NOT_EXIST;
+
+	status = acpi_get_handle(handle, "_OSC", &tmp);
+	if (ACPI_FAILURE(status)) {
+		dev_info(root->bus->bridge, "ACPI _OSC not found\n");
+		return status;
+	}
+
+	mutex_lock(&osc_lock);
+
+	if (!root->osc_queried) {
+		status = acpi_pci_query_osc(root, root->osc_support_set);
+		if (ACPI_FAILURE(status))
+			goto out;
+	}
+
+	*mask = root->osc_control_qry;
+
+ out:
+	mutex_unlock(&osc_lock);
+	return status;
+}
+
+/**
  * acpi_pci_osc_control_set - commit requested control to Firmware
  * @handle: acpi_handle for the target ACPI object
  * @flags: driver's requested control bits
@@ -377,10 +416,6 @@ acpi_status acpi_pci_osc_control_set(acp
 	acpi_handle tmp;
 	struct acpi_pci_root *root;
 
-	status = acpi_get_handle(handle, "_OSC", &tmp);
-	if (ACPI_FAILURE(status))
-		return status;
-
 	control_req = (flags & OSC_PCI_CONTROL_MASKS);
 	if (!control_req)
 		return AE_TYPE;
@@ -389,6 +424,12 @@ acpi_status acpi_pci_osc_control_set(acp
 	if (!root)
 		return AE_NOT_EXIST;
 
+	status = acpi_get_handle(handle, "_OSC", &tmp);
+	if (ACPI_FAILURE(status)) {
+		dev_info(root->bus->bridge, "ACPI _OSC not found\n");
+		return status;
+	}
+
 	mutex_lock(&osc_lock);
 	/* No need to evaluate _OSC if the control was already granted. */
 	if ((root->osc_control_set & control_req) == control_req)
@@ -401,8 +442,8 @@ acpi_status acpi_pci_osc_control_set(acp
 			goto out;
 	}
 	if ((root->osc_control_qry & control_req) != control_req) {
-		printk(KERN_DEBUG
-		       "Firmware did not grant requested _OSC control\n");
+		pr_info("ACPI: Requested _OSC control for unsupported mask "
+			"0x%02x\n", control_req);
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
@@ -771,22 +771,10 @@ void aer_isr(struct work_struct *work)
  */
 int aer_init(struct pcie_device *dev)
 {
-	if (pcie_aer_get_firmware_first(dev->port)) {
-		dev_printk(KERN_DEBUG, &dev->device,
-			   "PCIe errors handled by platform firmware.\n");
-		goto out;
-	}
-
-	if (aer_osc_setup(dev))
-		goto out;
-
-	return 0;
-out:
 	if (forceload) {
 		dev_printk(KERN_DEBUG, &dev->device,
 			   "aerdrv forceload requested.\n");
 		pcie_aer_force_firmware_first(dev->port, 0);
-		return 0;
 	}
-	return -ENXIO;
+	return 0;
 }
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
 
@@ -235,7 +235,7 @@ static int pciehp_probe(struct pcie_devi
 		dev_info(&dev->device,
 			 "Bypassing BIOS check for pciehp use on %s\n",
 			 pci_name(dev->port));
-	else if (pciehp_get_hp_hw_control_from_firmware(dev->port))
+	else if (pciehp_acpi_slot_detection_check(dev->port))
 		goto err_out_none;
 
 	ctrl = pcie_init(dev);
Index: linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_acpi.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
@@ -85,9 +85,7 @@ static int __init dummy_probe(struct pci
 	acpi_handle handle;
 	struct dummy_slot *slot, *tmp;
 	struct pci_dev *pdev = dev->port;
-	/* Note: pciehp_detect_mode != PCIEHP_DETECT_ACPI here */
-	if (pciehp_get_hp_hw_control_from_firmware(pdev))
-		return -ENODEV;
+
 	pos = pci_pcie_cap(pdev);
 	if (!pos)
 		return -ENODEV;
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -2047,15 +2047,18 @@ and is between 256 and 4096 characters. 
 		force	Enable ASPM even on devices that claim not to support it.
 			WARNING: Forcing ASPM on may cause system lockups.
 
+	pcie_ports=	[PCIE] PCIe ports handling:
+		auto	Ask the BIOS whether or not to use native PCIe services
+			associated with PCIe ports (PME, hot-plug, AER).  Use
+			them only if that is allowed by the BIOS.
+		native	Use native PCIe services associated with PCIe ports
+			unconditionally.
+		compat	Treat PCIe ports as PCI-to-PCI bridges, disable the PCIe
+			ports driver.
+
 	pcie_pme=	[PCIE,PM] Native PCIe PME signaling options:
-			Format: {auto|force}[,nomsi]
-		auto	Use native PCIe PME signaling if the BIOS allows the
-			kernel to control PCIe config registers of root ports.
-		force	Use native PCIe PME signaling even if the BIOS refuses
-			to allow the kernel to control the relevant PCIe config
-			registers.
 		nomsi	Do not use MSI for native PCIe PME signaling (this makes
-			all PCIe root ports use INTx for everything).
+			all PCIe root ports use INTx for all services).
 
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -305,6 +305,7 @@ acpi_status acpi_run_osc(acpi_handle han
 				OSC_PCI_EXPRESS_AER_CONTROL |		\
 				OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)
 
+extern acpi_status acpi_pci_osc_control_get(acpi_handle handle, u32 *mask);
 extern acpi_status acpi_pci_osc_control_set(acpi_handle handle, u32 flags);
 extern void acpi_early_init(void);
 
Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -22,6 +22,11 @@
 #define PCIE_PORT_SERVICE_VC_SHIFT	3	/* Virtual Channel */
 #define PCIE_PORT_SERVICE_VC		(1 << PCIE_PORT_SERVICE_VC_SHIFT)
 
+#define PCIE_PORT_SERVICE_MASK		(PCIE_PORT_SERVICE_PME \
+					| PCIE_PORT_SERVICE_AER \
+					| PCIE_PORT_SERVICE_HP \
+					| PCIE_PORT_SERVICE_VC)
+
 struct pcie_device {
 	int 		irq;	    /* Service IRQ/MSI/MSI-X Vector */
 	struct pci_dev *port;	    /* Root/Upstream/Downstream Port */
