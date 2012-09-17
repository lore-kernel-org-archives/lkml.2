Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2IQIzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:55:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:12419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab2IQIyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="222936825"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
Date: Mon, 17 Sep 2012 16:54:34 +0800
Message-Id: <1347872076-5260-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PCI devices are put into D3cold before kexec, because the
configuration registers of PCI devices in D3cold are not accessible.

And if PCI bridges are put into low power state before kexec,
configuration registers of PCI devices underneath the PCI bridges are
not accessible too.

These will make some PCI devices can not be scanned after kexec, so
resume the PCI devices in D3cold or PCI bridges in low power state
before kexec.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	/* Resume bridges and devices in D3cold for kexec to work properly */
+	if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
+		pm_runtime_resume(dev);
+
 	if (drv && drv->shutdown)
 		drv->shutdown(pci_dev);
 	pci_msi_shutdown(pci_dev);
