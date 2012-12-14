Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2LNCwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:52:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:9111 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab2LNCwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:52:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,277,1355126400"; 
   d="scan'208";a="257243085"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH] PCIe/PM: Do not suspend port if any subordinate device need PME polling
Date: Fri, 14 Dec 2012 10:52:11 +0800
Message-Id: <1355453531-23348-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  http://www.mail-archive.com/linux-usb@vger.kernel.org/msg07976.html

Ulrich reported that his USB3 cardreader does not work reliably when
connected to the USB3 port.  It turns out that USB3 controller failed
to be waken up when plugging in the USB3 cardreader.  Further
experiment found that the USB3 host controller can only be waken up
via polling, while not via PME interrupt.  But if the PCIe port that
the USB3 host controller is connected is suspended, we can not poll
the USB3 host controller because its config space is not accessible if
the PCIe port is put into low power state.

To solve the issue, the PCIe port will not be suspended if any
subordinate device need PME polling.

Reported-by: Ulrich Eckhardt <usb@uli-eckhardt.de>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@vger.kernel.org	# 3.6+
---
 drivers/pci/pcie/portdrv_pci.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -134,10 +134,26 @@ static int pcie_port_runtime_resume(stru
 	return 0;
 }
 
+static int pci_dev_pme_poll(struct pci_dev *pdev, void *data)
+{
+	int *pme_poll = data;
+	*pme_poll = *pme_poll || pdev->pme_poll;
+	return 0;
+}
+
 static int pcie_port_runtime_idle(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int pme_poll = false;
+
+	/*
+	 * If any subordinate device needs pme poll, we should keep
+	 * the port in D0, because we need port in D0 to poll it.
+	 */
+	pci_walk_bus(pdev->subordinate, pci_dev_pme_poll, &pme_poll);
 	/* Delay for a short while to prevent too frequent suspend/resume */
-	pm_schedule_suspend(dev, 10);
+	if (!pme_poll)
+		pm_schedule_suspend(dev, 10);
 	return -EBUSY;
 }
 #else
