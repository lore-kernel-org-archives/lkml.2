Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2EOHAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:00:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:1227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2EOHAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140728208"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v3 2/2] PCIe: Add PCIe runtime D3cold support
Date: Tue, 15 May 2012 15:00:11 +0800
Message-Id: <1337065211-19525-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337065211-19525-1-git-send-email-ying.huang@intel.com>
References: <1337065211-19525-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime D3cold support to PCIe bus.  D3cold is the
deepest power saving state for PCIe devices.  Where the main PCIe link
will be powered off totally, so before the PCIe main link is powered
on again, you can not access the device, even the configuration space,
which is still accessible in D3hot.  Because the main PCIe link is not
available, the PCI PM registers can not be used to put device into/out
of D3cold state, that will be done by platform logic such as ACPI
_PR3.

To support remote wake up in D3cold, aux power is supplied, and a
side-band pin: WAKE# is used to notify remote wake up event, the pin
is usually connected to platform logic such as ACPI GPE.  This is
quite different with other power saving states, where remote wake up
is notified via PME message through the PCIe main link.

PCIe devices in plug-in slot usually has no direct platform logic, for
example, there is usually no ACPI _PR3 for them.  The D3cold support
for these devices can be done via the PCIe port connected to it.  When
power on/off the PCIe port, the corresponding PCIe devices are powered
on/off too.  And the remote wake up event from PCIe device will be
notified to the corresponding PCIe port.

The PCI subsystem D3cold support and corresponding ACPI platform
support is implemented in the patch.  Including the support for PCIe
devices in plug-in slot.

For more information about PCIe D3cold and corresponding ACPI support,
please refer to:

- PCI Express Base Specification Revision 2.0
- Advanced Configuration and Power Interface Specification Revision 5.0

Originally-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-acpi.c         |   26 +++++++--
 drivers/pci/pci-driver.c       |    3 +
 drivers/pci/pci-sysfs.c        |   29 ++++++++++
 drivers/pci/pci.c              |  117 +++++++++++++++++++++++++++++++++++++----
 drivers/pci/pci.h              |    1 
 drivers/pci/pcie/portdrv_pci.c |   30 ++++++++++
 include/linux/pci.h            |   16 ++++-
 7 files changed, 204 insertions(+), 18 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -48,6 +48,15 @@ static void pci_acpi_wake_dev(acpi_handl
 	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
 		return;
 
+	if (pci_dev->current_state == PCI_D3cold) {
+		pci_wakeup_event(pci_dev);
+		pm_runtime_get_sync(&pci_dev->dev);
+		/* Powering on bridge needs to resume whole hierarchy */
+		pci_wakeup_bus(pci_dev->subordinate, true);
+		pm_runtime_put(&pci_dev->dev);
+		return;
+	}
+
 	if (!pci_dev->pm_cap || !pci_dev->pme_support
 	     || pci_check_pme_status(pci_dev)) {
 		if (pci_dev->pme_poll)
@@ -187,10 +196,13 @@ acpi_status pci_acpi_remove_pm_notifier(
 
 static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
 {
-	int acpi_state;
+	int acpi_state, d_max;
 
-	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
-						ACPI_STATE_D3);
+	if (pdev->no_d3cold)
+		d_max = ACPI_STATE_D3_HOT;
+	else
+		d_max = ACPI_STATE_D3_COLD;
+	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL, d_max);
 	if (acpi_state < 0)
 		return PCI_POWER_ERROR;
 
@@ -297,7 +309,13 @@ static void acpi_pci_propagate_run_wake(
 
 static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
 {
-	if (dev->pme_interrupt)
+	/*
+	 * Per PCI Express Base Specification Revision 2.0 section
+	 * 5.3.3.2 Link Wakeup, platform support is needed for D3cold
+	 * waking up to power on the main link even if there is PME
+	 * support for D3cold
+	 */
+	if (dev->pme_interrupt && !dev->runtime_d3cold)
 		return 0;
 
 	if (!acpi_pm_device_run_wake(&dev->dev, enable))
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1013,10 +1013,13 @@ static int pci_pm_runtime_suspend(struct
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
 	if (error)
 		return error;
+	if (!pci_dev->d3cold_allowed)
+		pci_dev->no_d3cold = true;
 
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/pci-aspm.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -377,6 +378,31 @@ dev_bus_rescan_store(struct device *dev,
 
 #endif
 
+#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
+static ssize_t d3cold_allowed_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pdev->d3cold_allowed = !!val;
+	pm_runtime_resume(dev);
+
+	return count;
+}
+
+static ssize_t d3cold_allowed_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	return sprintf (buf, "%u\n", pdev->d3cold_allowed);
+}
+#endif
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
@@ -401,6 +427,9 @@ struct device_attribute pci_dev_attrs[]
 	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
 	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
 #endif
+#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
+	__ATTR(d3cold_allowed, 0644, d3cold_allowed_show, d3cold_allowed_store),
+#endif
 	__ATTR_NULL,
 };
 
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -653,6 +653,12 @@ void pci_update_current_state(struct pci
 	if (dev->pm_cap) {
 		u16 pmcsr;
 
+		/*
+		 * Configuration space is not accessible for device in
+		 * D3cold, so keep in D3cold for safety
+		 */
+		if (dev->current_state == PCI_D3cold)
+			return;
 		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
 	} else {
@@ -671,8 +677,12 @@ static int pci_platform_power_transition
 
 	if (platform_pci_power_manageable(dev)) {
 		error = platform_pci_set_power_state(dev, state);
-		if (!error)
-			pci_update_current_state(dev, state);
+		if (!error) {
+			if (state == PCI_D3cold)
+				dev->current_state = PCI_D3cold;
+			else
+				pci_update_current_state(dev, state);
+		}
 		/* Fall back to PCI_D0 if native PM is not supported */
 		if (!dev->pm_cap)
 			dev->current_state = PCI_D0;
@@ -693,8 +703,49 @@ static int pci_platform_power_transition
  */
 static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
 {
-	if (state == PCI_D0)
+	if (state == PCI_D0) {
 		pci_platform_power_transition(dev, PCI_D0);
+		/*
+		 * Mandatory power management transition delays, see
+		 * PCI Express Base Specification Revision 2.0 Section
+		 * 6.6.1: Conventional Reset.  Do not delay for
+		 * devices powered on/off by corresponding bridge,
+		 * because have already delayed for the bridge.
+		 */
+		if (dev->runtime_d3cold) {
+			msleep(dev->d3cold_delay);
+			/* When powering on a bridge from D3cold, the
+			 * whole hierarchy may be powered on into
+			 * D0uninitialized state, resume them to give
+			 * them a chance to suspend again
+			 */
+			pci_wakeup_bus(dev->subordinate, false);
+		}
+	}
+}
+
+/**
+ * __pci_dev_set_current_state - Set current state of a PCI device
+ * @dev: Device to handle
+ * @data: pointer to state to be set
+ */
+static int __pci_dev_set_current_state(struct pci_dev *dev, void *data)
+{
+	pci_power_t state = *(pci_power_t *)data;
+
+	dev->current_state = state;
+	return 0;
+}
+
+/**
+ * __pci_bus_set_current_state - Walk given bus and set current state of devices
+ * @bus: Top bus of the subtree to walk.
+ * @state: state to be set
+ */
+static void __pci_bus_set_current_state(struct pci_bus *bus, pci_power_t state)
+{
+	if (bus)
+		pci_walk_bus(bus, __pci_dev_set_current_state, &state);
 }
 
 /**
@@ -706,8 +757,15 @@ static void __pci_start_power_transition
  */
 int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
 {
-	return state >= PCI_D0 ?
-			pci_platform_power_transition(dev, state) : -EINVAL;
+	int ret;
+
+	if (state < PCI_D0)
+		return -EINVAL;
+	ret = pci_platform_power_transition(dev, state);
+	/* Power off the bridge may power off the whole hierarchy */
+	if (!ret && state == PCI_D3cold)
+		__pci_bus_set_current_state(dev->subordinate, PCI_D3cold);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
 
@@ -731,8 +789,8 @@ int pci_set_power_state(struct pci_dev *
 	int error;
 
 	/* bound the state we're entering */
-	if (state > PCI_D3hot)
-		state = PCI_D3hot;
+	if (state > PCI_D3cold)
+		state = PCI_D3cold;
 	else if (state < PCI_D0)
 		state = PCI_D0;
 	else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
@@ -747,10 +805,15 @@ int pci_set_power_state(struct pci_dev *
 
 	/* This device is quirked not to be put into D3, so
 	   don't put it in D3 */
-	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
+	if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
 		return 0;
 
-	error = pci_raw_set_power_state(dev, state);
+	/*
+	 * To put device in D3cold, we put device into D3hot in native
+	 * way, then put device into D3cold with platform ops
+	 */
+	error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
+					PCI_D3hot : state);
 
 	if (!__pci_complete_power_transition(dev, state))
 		error = 0;
@@ -1497,6 +1560,35 @@ void pci_pme_wakeup_bus(struct pci_bus *
 }
 
 /**
+ * pci_wakeup - Wake up a PCI device
+ * @dev: Device to handle.
+ * @data: whether to resume first device synchronously
+ */
+static int pci_wakeup(struct pci_dev *pci_dev, void *data)
+{
+	bool *sync_first = data;
+
+	pci_wakeup_event(pci_dev);
+	if (*sync_first) {
+		pm_runtime_resume(&pci_dev->dev);
+		*sync_first = false;
+	} else
+		pm_request_resume(&pci_dev->dev);
+	return 0;
+}
+
+/**
+ * pci_wakeup_bus - Walk given bus and wake up devices on it
+ * @bus: Top bus of the subtree to walk.
+ * @sync_first: whether to resume first device synchronously
+ */
+void pci_wakeup_bus(struct pci_bus *bus, bool sync_first)
+{
+	if (bus)
+		pci_walk_bus(bus, pci_wakeup, &sync_first);
+}
+
+/**
  * pci_pme_capable - check the capability of PCI device to generate PME#
  * @dev: PCI device to handle.
  * @state: PCI state from which device will issue PME#.
@@ -1790,12 +1882,16 @@ int pci_finish_runtime_suspend(struct pc
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
+	dev->runtime_d3cold = target_state == PCI_D3cold;
+
 	__pci_enable_wake(dev, target_state, true, pci_dev_run_wake(dev));
 
 	error = pci_set_power_state(dev, target_state);
 
-	if (error)
+	if (error) {
 		__pci_enable_wake(dev, target_state, true, false);
+		dev->runtime_d3cold = false;
+	}
 
 	return error;
 }
@@ -1865,6 +1961,7 @@ void pci_pm_init(struct pci_dev *dev)
 
 	dev->pm_cap = pm;
 	dev->d3_delay = PCI_PM_D3_WAIT;
+	dev->d3cold_delay = PCI_PM_D3COLD_WAIT;
 
 	dev->d1_support = false;
 	dev->d2_support = false;
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -70,6 +70,7 @@ extern void pci_update_current_state(str
 extern void pci_disable_enabled_device(struct pci_dev *dev);
 extern int pci_finish_runtime_suspend(struct pci_dev *dev);
 extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
+extern void pci_wakeup_bus(struct pci_bus *bus, bool sync_first);
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -101,8 +101,38 @@ static int pcie_port_resume_noirq(struct
 }
 
 #ifdef CONFIG_PM_RUNTIME
+struct d3cold_info {
+	bool no_d3cold;
+	unsigned int d3cold_delay;
+};
+
+static int pci_dev_d3cold_info(struct pci_dev *pdev, void *data)
+{
+	struct d3cold_info *info = data;
+
+	info->d3cold_delay = max_t(unsigned int, pdev->d3cold_delay,
+				   info->d3cold_delay);
+	if (pdev->no_d3cold)
+		info->no_d3cold = true;
+	return 0;
+}
+
 static int pcie_port_runtime_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct d3cold_info d3cold_info = {
+		.no_d3cold	= false,
+		.d3cold_delay	= PCI_PM_D3_WAIT,
+	};
+
+	/*
+	 * If any subordinate device disable D3cold, we should not put
+	 * the port into D3cold.  The D3cold delay of port should be
+	 * the max of that of all subordinate devices.
+	 */
+	pci_walk_bus(pdev->subordinate, pci_dev_d3cold_info, &d3cold_info);
+	pdev->no_d3cold = d3cold_info.no_d3cold;
+	pdev->d3cold_delay = d3cold_info.d3cold_delay;
 	return 0;
 }
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -132,9 +132,10 @@ static inline const char *pci_power_name
 	return pci_power_names[1 + (int) state];
 }
 
-#define PCI_PM_D2_DELAY	200
-#define PCI_PM_D3_WAIT	10
-#define PCI_PM_BUS_WAIT	50
+#define PCI_PM_D2_DELAY		200
+#define PCI_PM_D3_WAIT		10
+#define PCI_PM_D3COLD_WAIT	100
+#define PCI_PM_BUS_WAIT		50
 
 /** The pci_channel state describes connectivity between the CPU and
  *  the pci device.  If some PCI bus between here and the pci device
@@ -278,11 +279,18 @@ struct pci_dev {
 	unsigned int	pme_poll:1;	/* Poll device's PME status bit */
 	unsigned int	d1_support:1;	/* Low power state D1 is supported */
 	unsigned int	d2_support:1;	/* Low power state D2 is supported */
-	unsigned int	no_d1d2:1;	/* Only allow D0 and D3 */
+	unsigned int	no_d1d2:1;	/* D1 and D2 are forbidden */
+	unsigned int	no_d3cold:1;	/* D3cold is forbidden */
+	unsigned int	d3cold_allowed:1;	/* D3cold is allowed by user */
 	unsigned int	mmio_always_on:1;	/* disallow turning off io/mem
 						   decoding during bar sizing */
 	unsigned int	wakeup_prepared:1;
+	unsigned int	runtime_d3cold:1;	/* whether go through runtime
+						   D3cold, not set for devices
+						   powered on/off by the
+						   corresponding bridge */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
+	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 
 #ifdef CONFIG_PCIEASPM
 	struct pcie_link_state	*link_state;	/* ASPM link state. */
