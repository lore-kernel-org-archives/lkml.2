Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2FHICz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:02:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:62602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab2FHIBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:01:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="149938438"
From: Xudong Hao <xudong.hao@intel.com>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        ddutile@redhat.com, myron.stowe@redhat.com, xiantao.zhang@intel.com,
        xudong.hao@intel.com
Subject: [PATCH 1/4] Add pci_obff_supported() function.
Date: Fri,  8 Jun 2012 16:01:29 +0800
Message-Id: <1339142492-13625-2-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
References: <1339142492-13625-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pci_obff_supported() function and use it by obff relative function.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 drivers/pci/pci.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 447e834..a70093b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -39,6 +39,7 @@ EXPORT_SYMBOL(pci_pci_problems);
 
 unsigned int pci_pm_d3_delay;
 
+static bool pci_obff_supported(struct pci_dev *dev);
 static void pci_pme_list_scan(struct work_struct *work);
 
 static LIST_HEAD(pci_pme_list);
@@ -2071,6 +2072,27 @@ void pci_disable_ido(struct pci_dev *dev, unsigned long type)
 EXPORT_SYMBOL(pci_disable_ido);
 
 /**
+ * pci_obff_supported - check whether a device supports OBFF 
+ * @dev: PCI device
+ *
+ * RETURNS:
+ * True if @dev supports optimized buffer flush/fill, false otherwise.
+ */
+static bool pci_obff_supported(struct pci_dev *dev)
+{
+	int pos;
+	u32 cap;
+
+	pos = pci_pcie_cap(dev);
+	if (!pos)
+		return false;
+
+	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
+
+	return cap & PCI_EXP_OBFF_MASK;
+}
+
+/**
  * pci_enable_obff - enable optimized buffer flush/fill
  * @dev: PCI device
  * @type: type of signaling to use
@@ -2096,17 +2118,13 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 	u16 ctrl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	if (!pci_obff_supported(dev))
 		return -ENOTSUPP;
 
 	pos = pci_pcie_cap(dev);
 	if (!pos)
 		return -ENOTSUPP;
 
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
-	if (!(cap & PCI_EXP_OBFF_MASK))
-		return -ENOTSUPP; /* no OBFF support at all */
-
 	/* Make sure the topology supports OBFF as well */
 	if (dev->bus) {
 		ret = pci_enable_obff(dev->bus->self, type);
@@ -2149,7 +2167,7 @@ void pci_disable_obff(struct pci_dev *dev)
 	int pos;
 	u16 ctrl;
 
-	if (!pci_is_pcie(dev))
+	if (!pci_obff_supported(dev))
 		return;
 
 	pos = pci_pcie_cap(dev);
-- 
1.5.5

