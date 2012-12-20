Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2LTB52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:57:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38307 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2LTBzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 14/16] ACPI / PCI: Rework the setup and cleanup of device wakeup
Date: Thu, 20 Dec 2012 02:58:17 +0100
Message-ID: <3181154.NDRBl366gp@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, the ACPI wakeup capability of PCI devices is set up
in two different places, partially in acpi_pci_bind() where
runtime wakeup is initialized and partially in
platform_pci_wakeup_init(), where system wakeup is initialized.
The cleanup is only done in acpi_pci_unbind() and it only covers
runtime wakeup.

Use the new .setup() and .cleanup() callbacks in struct acpi_bus_type
to consolidate that code and do the setup and the cleanup each in one
place.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    2 +-
 drivers/acpi/pci_bind.c  |    7 -------
 drivers/pci/pci-acpi.c   |   30 +++++++++++++++++++++++++++++-
 drivers/pci/pci.c        |   26 +-------------------------
 drivers/pci/pci.h        |    5 -----
 drivers/pci/probe.c      |    1 -
 include/linux/acpi.h     |    5 +++++
 7 files changed, 36 insertions(+), 40 deletions(-)

Index: linux/drivers/acpi/pci_bind.c
===================================================================
--- linux.orig/drivers/acpi/pci_bind.c
+++ linux/drivers/acpi/pci_bind.c
@@ -43,9 +43,6 @@ static int acpi_pci_unbind(struct acpi_d
 	if (!dev)
 		goto out;
 
-	device_set_run_wake(&dev->dev, false);
-	pci_acpi_remove_pm_notifier(device);
-
 	if (!dev->subordinate)
 		goto out;
 
@@ -70,10 +67,6 @@ static int acpi_pci_bind(struct acpi_dev
 	if (!dev)
 		return 0;
 
-	pci_acpi_add_pm_notifier(device, dev);
-	if (device->wakeup.flags.run_wake)
-		device_set_run_wake(&dev->dev, true);
-
 	/*
 	 * Install the 'bind' function to facilitate callbacks for
 	 * children of the P2P bridge.
Index: linux/drivers/pci/pci.h
===================================================================
--- linux.orig/drivers/pci/pci.h
+++ linux/drivers/pci/pci.h
@@ -44,9 +44,6 @@ int pci_probe_reset_function(struct pci_
  *                platform; to be used during system-wide transitions from a
  *                sleeping state to the working state and vice versa
  *
- * @can_wakeup: returns 'true' if given device is capable of waking up the
- *              system from a sleeping state
- *
  * @sleep_wake: enables/disables the system wake up capability of given device
  *
  * @run_wake: enables/disables the platform to generate run-time wake-up events
@@ -60,7 +57,6 @@ struct pci_platform_pm_ops {
 	bool (*is_manageable)(struct pci_dev *dev);
 	int (*set_state)(struct pci_dev *dev, pci_power_t state);
 	pci_power_t (*choose_state)(struct pci_dev *dev);
-	bool (*can_wakeup)(struct pci_dev *dev);
 	int (*sleep_wake)(struct pci_dev *dev, bool enable);
 	int (*run_wake)(struct pci_dev *dev, bool enable);
 };
@@ -75,7 +71,6 @@ extern void pci_wakeup_bus(struct pci_bu
 extern void pci_config_pm_runtime_get(struct pci_dev *dev);
 extern void pci_config_pm_runtime_put(struct pci_dev *dev);
 extern void pci_pm_init(struct pci_dev *dev);
-extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 
Index: linux/drivers/pci/probe.c
===================================================================
--- linux.orig/drivers/pci/probe.c
+++ linux/drivers/pci/probe.c
@@ -1276,7 +1276,6 @@ static void pci_init_capabilities(struct
 
 	/* Power Management */
 	pci_pm_init(dev);
-	platform_pci_wakeup_init(dev);
 
 	/* Vital Product Data */
 	pci_vpd_pci22_init(dev);
Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -450,7 +450,7 @@ static struct pci_platform_pm_ops *pci_p
 int pci_set_platform_pm(struct pci_platform_pm_ops *ops)
 {
 	if (!ops->is_manageable || !ops->set_state || !ops->choose_state
-	    || !ops->sleep_wake || !ops->can_wakeup)
+	    || !ops->sleep_wake)
 		return -EINVAL;
 	pci_platform_pm = ops;
 	return 0;
@@ -473,11 +473,6 @@ static inline pci_power_t platform_pci_c
 			pci_platform_pm->choose_state(dev) : PCI_POWER_ERROR;
 }
 
-static inline bool platform_pci_can_wakeup(struct pci_dev *dev)
-{
-	return pci_platform_pm ? pci_platform_pm->can_wakeup(dev) : false;
-}
-
 static inline int platform_pci_sleep_wake(struct pci_dev *dev, bool enable)
 {
 	return pci_platform_pm ?
@@ -1960,25 +1955,6 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 }
 
-/**
- * platform_pci_wakeup_init - init platform wakeup if present
- * @dev: PCI device
- *
- * Some devices don't have PCI PM caps but can still generate wakeup
- * events through platform methods (like ACPI events).  If @dev supports
- * platform wakeup events, set the device flag to indicate as much.  This
- * may be redundant if the device also supports PCI PM caps, but double
- * initialization should be safe in that case.
- */
-void platform_pci_wakeup_init(struct pci_dev *dev)
-{
-	if (!platform_pci_can_wakeup(dev))
-		return;
-
-	device_set_wakeup_capable(&dev->dev, true);
-	platform_pci_sleep_wake(dev, false);
-}
-
 static void pci_add_saved_cap(struct pci_dev *pci_dev,
 	struct pci_cap_saved_state *new_cap)
 {
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -510,9 +510,14 @@ static inline int acpi_subsys_resume_ear
 #endif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM)
+struct acpi_device *acpi_dev_pm_get_node(struct device *dev);
 int acpi_dev_pm_attach(struct device *dev, bool power_on);
 void acpi_dev_pm_detach(struct device *dev, bool power_off);
 #else
+static struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
+{
+	return NULL;
+}
 static inline int acpi_dev_pm_attach(struct device *dev, bool power_on)
 {
 	return -ENODEV;
Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -634,7 +634,7 @@ int acpi_pm_device_sleep_wake(struct dev
  * acpi_dev_pm_get_node - Get ACPI device node for the given physical device.
  * @dev: Device to get the ACPI node for.
  */
-static struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
+struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
Index: linux/drivers/pci/pci-acpi.c
===================================================================
--- linux.orig/drivers/pci/pci-acpi.c
+++ linux/drivers/pci/pci-acpi.c
@@ -283,7 +283,6 @@ static struct pci_platform_pm_ops acpi_p
 	.is_manageable = acpi_pci_power_manageable,
 	.set_state = acpi_pci_set_power_state,
 	.choose_state = acpi_pci_choose_state,
-	.can_wakeup = acpi_pci_can_wakeup,
 	.sleep_wake = acpi_pci_sleep_wake,
 	.run_wake = acpi_pci_run_wake,
 };
@@ -321,10 +320,39 @@ static int acpi_pci_find_root_bridge(str
 	return 0;
 }
 
+static void acpi_pci_wakeup_setup(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	if (!adev || !adev->wakeup.flags.valid)
+		return;
+
+	device_set_wakeup_capable(dev, true);
+	acpi_pci_sleep_wake(pci_dev, false);
+
+	pci_acpi_add_pm_notifier(adev, pci_dev);
+	if (adev->wakeup.flags.run_wake)
+		device_set_run_wake(dev, true);
+}
+
+static void acpi_pci_wakeup_cleanup(struct device *dev)
+{
+	struct acpi_device *adev = acpi_dev_pm_get_node(dev);
+
+	if (adev && adev->wakeup.flags.valid) {
+		device_set_wakeup_capable(dev, false);
+		device_set_run_wake(dev, false);
+		pci_acpi_remove_pm_notifier(adev);
+	}
+}
+
 static struct acpi_bus_type acpi_pci_bus = {
 	.bus = &pci_bus_type,
 	.find_device = acpi_pci_find_device,
 	.find_bridge = acpi_pci_find_root_bridge,
+	.setup = acpi_pci_wakeup_setup,
+	.cleanup = acpi_pci_wakeup_cleanup,
 };
 
 static int __init acpi_pci_init(void)

