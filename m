Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2FKCsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:48:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:46108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab2FKCrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151117059"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH -v5 1/3] ACPI, PM, Specify lowest allowed state for device sleep state
Date: Mon, 11 Jun 2012 10:47:11 +0800
Message-Id: <1339382833-7928-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339382833-7928-1-git-send-email-ying.huang@intel.com>
References: <1339382833-7928-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lower device sleep state can save more power, but has more exit
latency too.  Sometimes, to satisfy some power QoS and other
requirement, we need to constrain the lowest device sleep state.

In this patch, a parameter to specify lowest allowed state for
acpi_pm_device_sleep_state is added.  So that the caller can enforce
the constraint via the parameter.

This is needed by PCIe D3cold support, where the lowest power state
allowed may be D3_HOT instead of default D3_COLD.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/sleep.c       |   24 +++++++++++++++++++-----
 drivers/pci/pci-acpi.c     |    3 ++-
 drivers/pnp/pnpacpi/core.c |    4 ++--
 include/acpi/acpi_bus.h    |    6 +++---
 4 files changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -716,8 +716,9 @@ int acpi_suspend(u32 acpi_state)
  *	@dev: device to examine; its driver model wakeup flags control
  *		whether it should be able to wake up the system
  *	@d_min_p: used to store the upper limit of allowed states range
- *	Return value: preferred power state of the device on success, -ENODEV on
- *		failure (ie. if there's no 'struct acpi_device' for @dev)
+ *	@d_max_in: specify the lowest allowed states
+ *	Return value: preferred power state of the device on success, -ENODEV
+ *	(ie. if there's no 'struct acpi_device' for @dev) or -EINVAL on failure
  *
  *	Find the lowest power (highest number) ACPI device power state that
  *	device @dev can be in while the system is in the sleep state represented
@@ -732,13 +733,15 @@ int acpi_suspend(u32 acpi_state)
  *	via @wake.
  */
 
-int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
+int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 	char acpi_method[] = "_SxD";
 	unsigned long long d_min, d_max;
 
+	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3)
+		return -EINVAL;
 	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &adev))) {
 		printk(KERN_DEBUG "ACPI handle has no context!\n");
 		return -ENODEV;
@@ -746,8 +749,10 @@ int acpi_pm_device_sleep_state(struct de
 
 	acpi_method[2] = '0' + acpi_target_sleep_state;
 	/*
-	 * If the sleep state is S0, we will return D3, but if the device has
-	 * _S0W, we will use the value from _S0W
+	 * If the sleep state is S0, the lowest limit from ACPI is D3,
+	 * but if the device has _S0W, we will use the value from _S0W
+	 * as the lowest limit from ACPI.  Finally, we will constrain
+	 * the lowest limit with the specified one.
 	 */
 	d_min = ACPI_STATE_D0;
 	d_max = ACPI_STATE_D3;
@@ -791,8 +796,17 @@ int acpi_pm_device_sleep_state(struct de
 		}
 	}
 
+	if (d_max_in < d_min)
+		return -EINVAL;
 	if (d_min_p)
 		*d_min_p = d_min;
+	/* constrain d_max with specified lowest limit (max number) */
+	if (d_max > d_max_in) {
+		for (d_max = d_max_in; d_max > d_min; d_max--) {
+			if (adev->power.states[d_max].flags.valid)
+				break;
+		}
+	}
 	return d_max;
 }
 #endif /* CONFIG_PM */
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -189,7 +189,8 @@ static pci_power_t acpi_pci_choose_state
 {
 	int acpi_state;
 
-	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL);
+	acpi_state = acpi_pm_device_sleep_state(&pdev->dev, NULL,
+						ACPI_STATE_D3);
 	if (acpi_state < 0)
 		return PCI_POWER_ERROR;
 
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -170,8 +170,8 @@ static int pnpacpi_suspend(struct pnp_de
 	}
 
 	if (acpi_bus_power_manageable(handle)) {
-		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL);
-
+		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL,
+							     ACPI_STATE_D3);
 		if (power_state < 0)
 			power_state = (state.event == PM_EVENT_ON) ?
 					ACPI_STATE_D0 : ACPI_STATE_D3;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -414,13 +414,13 @@ int acpi_enable_wakeup_device_power(stru
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
 #ifdef CONFIG_PM
-int acpi_pm_device_sleep_state(struct device *, int *);
+int acpi_pm_device_sleep_state(struct device *, int *, int);
 #else
-static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
+static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
 {
 	if (p)
 		*p = ACPI_STATE_D0;
-	return ACPI_STATE_D3;
+	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
 }
 #endif
 
