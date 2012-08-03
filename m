Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2HCGbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:31:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:48832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2HCGal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192770854"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX 2/4] PCI/PM: Keep parent bridge active when probing device
Date: Fri,  3 Aug 2012 14:30:33 +0800
Message-Id: <1343975435-25469-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343975435-25469-1-git-send-email-ying.huang@intel.com>
References: <1343975435-25469-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following bug:

http://marc.info/?l=linux-pci&m=134329923124234&w=2

The root cause of the bug is as follow.

If a device is not bound with the corresponding driver, the device
runtime PM will be disabled and the device will be put into suspended
state.  So that, the bridge/PCIe port connected to it may be put into
suspended and low power state.  When do probing for the device later,
because the bridge/PCIe port connected to it is in low power state,
the IO access to device may fail.

To solve the issue, the bridge/PCIe port connected to the device is
put into active state before probing.

Reported-by: Bjorn Mork <bjorn@mork.no>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-driver.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -280,8 +280,12 @@ static long local_pci_probe(void *_ddi)
 {
 	struct drv_dev_and_id *ddi = _ddi;
 	struct device *dev = &ddi->dev->dev;
+	struct device *parent = dev->parent;
 	int rc;
 
+	/* The parent bridge must be in active state when probing */
+	if (parent)
+		pm_runtime_get_sync(parent);
 	/* Unbound PCI devices are always set to disabled and suspended.
 	 * During probe, the device is set to enabled and active and the
 	 * usage count is incremented.  If the driver supports runtime PM,
@@ -298,6 +302,8 @@ static long local_pci_probe(void *_ddi)
 		pm_runtime_set_suspended(dev);
 		pm_runtime_put_noidle(dev);
 	}
+	if (parent)
+		pm_runtime_put(parent);
 	return rc;
 }
 
