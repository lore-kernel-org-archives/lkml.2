Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2EDIOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:14:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:42313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab2EDIN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138801446"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [RFC v2 4/5] ACPI, PM, Specify lowest allowed state for device sleep state
Date: Fri,  4 May 2012 16:13:40 +0800
Message-Id: <1336119221-21146-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lower device sleep state can save more power, but has more exit
latency too.  Sometimes, to satisfy some power QoS and other
requirement, we need to constrain the lowest device sleep state.

In this patch, a parameter to specify lowest allowed state for
acpi_pm_device_sleep_state is added.  So that the caller can enforce
the constraint via the parameter.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/sleep.c       |   18 +++++++++++++++---
 drivers/pci/pci-acpi.c     |    3 ++-
 drivers/pnp/pnpacpi/core.c |    4 ++--
 include/acpi/acpi_bus.h    |    6 +++---
 4 files changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -677,6 +677,7 @@ int acpi_suspend(u32 acpi_state)
  *	@dev: device to examine; its driver model wakeup flags control
  *		whether it should be able to wake up the system
  *	@d_min_p: used to store the upper limit of allowed states range
+ *	@d_max_in: specify the lowest allowed states
  *	Return value: preferred power state of the device on success, -ENODEV on
  *		failure (ie. if there's no 'struct acpi_device' for @dev)
  *
@@ -693,7 +694,7 @@ int acpi_suspend(u32 acpi_state)
  *	via @wake.
  */
 
-int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
+int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
 	struct acpi_device *adev;
@@ -704,11 +705,14 @@ int acpi_pm_device_sleep_state(struct de
 		printk(KERN_DEBUG "ACPI handle has no context!\n");
 		return -ENODEV;
 	}
+	d_max_in = clamp_t(int, d_max_in, ACPI_STATE_D0, ACPI_STATE_D3);
 
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
@@ -754,6 +758,14 @@ int acpi_pm_device_sleep_state(struct de
 
 	if (d_min_p)
 		*d_min_p = d_min;
+	/* constrain d_max with specified lowest limit (max number) */
+	if (d_max > d_max_in) {
+		d_max = d_max_in;
+		for (;d_max > d_min; d_max--) {
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
@@ -383,13 +383,13 @@ int acpi_enable_wakeup_device_power(stru
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
+	return m == ACPI_STATE_D3 ? m : ACPI_STATE_D0;
 }
 #endif
 
