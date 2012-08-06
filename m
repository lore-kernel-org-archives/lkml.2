Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2HFBfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:35:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:16530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab2HFBef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193560350"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [BUGFIX -v2 1/4] PCI/PM: enable D3/D3cold by default for most devices
Date: Mon,  6 Aug 2012 09:34:27 +0800
Message-Id: <1344216870-21105-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344216870-21105-1-git-send-email-ying.huang@intel.com>
References: <1344216870-21105-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following bug:

http://marc.info/?l=linux-usb&m=134318961120825&w=2

Originally, device lower power states include D1, D2, D3.  After that,
D3 is further divided into D3hot and D3cold.  To support both scenario
safely, original D3 is mapped to D3cold.

When adding D3cold support, because worry about some device may have
broken D3cold support, D3cold is disabled by default.  This disable D3
on original platform too.  But some original platform may only have
working D3, but no working D1, D2.  The root cause of the above bug is
it too.

To deal with this, this patch enables D3/D3cold by default for most
devices.  This restores the original behavior.  For some devices that
suspected to have broken D3cold support, such as PCIe port, D3cold is
disabled by default.

Reported-by: Bjorn Mork <bjorn@mork.no>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c              |    1 +
 drivers/pci/pcie/portdrv_pci.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1941,6 +1941,7 @@ void pci_pm_init(struct pci_dev *dev)
 	dev->pm_cap = pm;
 	dev->d3_delay = PCI_PM_D3_WAIT;
 	dev->d3cold_delay = PCI_PM_D3COLD_WAIT;
+	dev->d3cold_allowed = true;
 
 	dev->d1_support = false;
 	dev->d2_support = false;
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -200,6 +200,11 @@ static int __devinit pcie_portdrv_probe(
 		return status;
 
 	pci_save_state(dev);
+	/*
+	 * D3cold may not work properly on some PCIe port, so disable
+	 * it by default.
+	 */
+	dev->d3cold_allowed = false;
 	if (!pci_match_id(port_runtime_pm_black_list, dev))
 		pm_runtime_put_noidle(&dev->dev);
 
