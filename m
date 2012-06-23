Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2FWCZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:25:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:11162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2FWCX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169147105"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v7 2/4] PCIe, PM, Add runtime PM support to PCIe port
Date: Sat, 23 Jun 2012 10:23:49 +0800
Message-Id: <1340418231-10134-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
References: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

This patch adds runtime PM support to PCIe port.  This is needed by
PCIe D3cold support, where PCIe device without ACPI node may be
powered on/off by PCIe port.

Because runtime suspend is broken for some chipsets, a black list is
used to disable runtime PM support for these chipsets.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c              |   10 ++++++++++
 drivers/pci/pcie/portdrv_pci.c |   24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1480,6 +1480,16 @@ static void pci_pme_list_scan(struct wor
 	if (!list_empty(&pci_pme_list)) {
 		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
 			if (pme_dev->dev->pme_poll) {
+				struct pci_dev *bridge;
+
+				bridge = pme_dev->dev->bus->self;
+				/*
+				 * If bridge is in low power state, the
+				 * configuration space of subordinate devices
+				 * may be not accessible
+				 */
+				if (bridge && bridge->current_state != PCI_D0)
+					continue;
 				pci_pme_wakeup(pme_dev->dev, NULL);
 			} else {
 				list_del(&pme_dev->list);
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/init.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
@@ -99,6 +100,15 @@ static int pcie_port_resume_noirq(struct
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int pcie_port_runtime_pm(struct device *dev)
+{
+	return 0;
+}
+#else
+#define pcie_port_runtime_pm	NULL
+#endif
+
 static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
@@ -107,6 +117,8 @@ static const struct dev_pm_ops pcie_port
 	.poweroff	= pcie_port_device_suspend,
 	.restore	= pcie_port_device_resume,
 	.resume_noirq	= pcie_port_resume_noirq,
+	.runtime_suspend = pcie_port_runtime_pm,
+	.runtime_resume = pcie_port_runtime_pm,
 };
 
 #define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
@@ -117,6 +129,14 @@ static const struct dev_pm_ops pcie_port
 #endif /* !PM */
 
 /*
+ * PCIe port runtime suspend is broken for some chipsets, so use a
+ * black list to disable runtime PM for these chipsets.
+ */
+static const struct pci_device_id port_runtime_pm_black_list[] = {
+	{ /* end: all zeroes */ }
+};
+
+/*
  * pcie_portdrv_probe - Probe PCI-Express port devices
  * @dev: PCI-Express port device being probed
  *
@@ -144,12 +164,16 @@ static int __devinit pcie_portdrv_probe(
 		return status;
 
 	pci_save_state(dev);
+	if (!pci_match_id(port_runtime_pm_black_list, dev))
+		pm_runtime_put_noidle(&dev->dev);
 
 	return 0;
 }
 
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
+	if (!pci_match_id(port_runtime_pm_black_list, dev))
+		pm_runtime_get_noresume(&dev->dev);
 	pcie_port_device_remove(dev);
 	pci_disable_device(dev);
 }
