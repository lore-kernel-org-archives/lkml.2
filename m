Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414Ab2FAVQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927Ab2FAVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:16:40 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/4] PCI: Add pci_pcie_cap2() check for PCIe feature
	capabilities >= v2
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xudong.hao@linux.intel.com, ddutile@redhat.com, yu.zhao@intel.com
Date: Fri, 01 Jun 2012 15:16:37 -0600
Message-ID: <20120601211637.20328.108.stgit@amt.stowe>
In-Reply-To: <20120601211619.20328.36769.stgit@amt.stowe>
References: <20120601211619.20328.36769.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resolves potential issues when accessing PCI Express
capability structures.  The makeup of Express' capability structure
varies substantially between v1 and v2:

    PCI Express 1.0 and 1.1 base neither requires the endpoint to
    implement the entire PCIe capability structure nor specifies
    default values of registers that are not implemented by the
    device.  Its capability version is 1.

    PCIe 1.1 Capability Structure Expansion ECN, PCIe 2.0, 2.1, and
    3.0 added additional registers to the structure and require all
    registers to be either implemented or hardwired to 0.  Their PCIe
    capability version is 2.

Due to the differences in the capability structures, code dealing with
capability features must be careful not to access the additional
registers introduced with v2 unless the device is specifically known to
be a v2 capable device.  Otherwise, attempts to access non-existant
registers will occur.  This is a subtle issue that is hard to track down
when it occurs (and it has - see commit 864d296cf94).

To try and help mitigate such occurrances, this patch introduces
pci_pcie_cap2() which is similar to pci_pcie_cap() but also checks
that the PCIe capability version is >= 2.  pci_pcie_cap2() should be
used for qualifying PCIe capability features introduced after v1.

Suggested by Don Dutile.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci.c        |   65 +++++++++++++++++++++++++++++++++++-----------
 include/linux/pci_regs.h |    7 +++++
 2 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ff0beb0..26933ff 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -279,6 +279,38 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
 }
 
 /**
+ * pci_pcie_cap2 - query for devices' PCI_CAP_ID_EXP v2 capability structure
+ * @dev: PCI device to check
+ *
+ * Like pci_pcie_cap() but also checks that the PCIe capability version is
+ * >= 2.  Note that v1 capability structures could be sparse in that not
+ * all register fields were required.  v2 requires the entire structure to
+ * be present size wise, while still allowing for non-implemented registers
+ * to exist but they must be hardwired to 0.
+ *
+ * Due to the differences in the versions of capability structures, one
+ * must be careful not to try and access non-existant registers that may
+ * exist in early versions - v1 - of Express devices.
+ *
+ * Returns the offset of the PCIe capability structure as long as the
+ * capability version is >= 2; otherwise 0 is returned.
+ */
+static int pci_pcie_cap2(struct pci_dev *dev)
+{
+	u16 flags;
+	int pos;
+
+	pos = pci_pcie_cap(dev);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &flags);
+		if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+			pos = 0;
+	}
+
+	return pos;
+}
+
+/**
  * pci_find_ext_capability - Find an extended capability
  * @dev: PCI device to query
  * @cap: capability code
@@ -1984,7 +2016,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 flags, ctrl;
+	u16 ctrl;
 	struct pci_dev *bridge;
 
 	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
@@ -1998,13 +2030,9 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!bridge)
 		return;
 
-	pos = pci_pcie_cap(bridge);
-	if (!pos)
-		return;
-
 	/* ARI is a PCIe v2 feature */
-	pci_read_config_word(bridge, pos + PCI_EXP_FLAGS, &flags);
-	if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+	pos = pci_pcie_cap2(bridge);
+	if (!pos)
 		return;
 
 	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
@@ -2019,7 +2047,7 @@ void pci_enable_ari(struct pci_dev *dev)
 }
 
 /**
- * pci_enable_ido - enable ID-based ordering on a device
+ * pci_enable_ido - enable ID-based Ordering on a device
  * @dev: the PCI device
  * @type: which types of IDO to enable
  *
@@ -2032,7 +2060,8 @@ void pci_enable_ido(struct pci_dev *dev, unsigned long type)
 	int pos;
 	u16 ctrl;
 
-	pos = pci_pcie_cap(dev);
+	/* ID-based Ordering is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return;
 
@@ -2055,7 +2084,8 @@ void pci_disable_ido(struct pci_dev *dev, unsigned long type)
 	int pos;
 	u16 ctrl;
 
-	pos = pci_pcie_cap(dev);
+	/* ID-based Ordering is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return;
 
@@ -2094,7 +2124,8 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 	u16 ctrl;
 	int ret;
 
-	pos = pci_pcie_cap(dev);
+	/* OBFF is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return -ENOTSUPP;
 
@@ -2144,7 +2175,8 @@ void pci_disable_obff(struct pci_dev *dev)
 	int pos;
 	u16 ctrl;
 
-	pos = pci_pcie_cap(dev);
+	/* OBFF is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return;
 
@@ -2166,7 +2198,8 @@ static bool pci_ltr_supported(struct pci_dev *dev)
 	int pos;
 	u32 cap;
 
-	pos = pci_pcie_cap(dev);
+	/* LTR is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return false;
 
@@ -2194,7 +2227,8 @@ int pci_enable_ltr(struct pci_dev *dev)
 	if (!pci_ltr_supported(dev))
 		return -ENOTSUPP;
 
-	pos = pci_pcie_cap(dev);
+	/* LTR is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return -ENOTSUPP;
 
@@ -2229,7 +2263,8 @@ void pci_disable_ltr(struct pci_dev *dev)
 	if (!pci_ltr_supported(dev))
 		return;
 
-	pos = pci_pcie_cap(dev);
+	/* LTR is a PCIe v2 feature */
+	pos = pci_pcie_cap2(dev);
 	if (!pos)
 		return;
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 4b608f5..bc1b54d 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -507,6 +507,13 @@
 #define PCI_EXP_RTSTA		32	/* Root Status */
 #define PCI_EXP_RTSTA_PME	0x10000 /* PME status */
 #define PCI_EXP_RTSTA_PENDING	0x20000 /* PME pending */
+/*
+ * Note that the following PCI Express 'Capability Structure' registers
+ * were introduced with 'Capability Version' 0x2 (v2).  These registers
+ * do not exist, and thus should not be attempted to be accesses, by
+ * PCI Express v1 devices (see pci_pcie_cap2() for use in qualifying
+ * PCI Express v2 capability related features).
+ */
 #define PCI_EXP_DEVCAP2		36	/* Device Capabilities 2 */
 #define  PCI_EXP_DEVCAP2_ARI	0x20	/* Alternative Routing-ID */
 #define  PCI_EXP_DEVCAP2_LTR	0x800	/* Latency tolerance reporting */

