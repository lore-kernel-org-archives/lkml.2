Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab2FAVQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab2FAVQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:16:34 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/4] PCI: Remove redundant checking in PCI Express capability
	routines
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xudong.hao@linux.intel.com, ddutile@redhat.com, yu.zhao@intel.com
Date: Fri, 01 Jun 2012 15:16:31 -0600
Message-ID: <20120601211631.20328.53913.stgit@amt.stowe>
In-Reply-To: <20120601211619.20328.36769.stgit@amt.stowe>
References: <20120601211619.20328.36769.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of redundant pci_is_pcie() checks in various PCI
Express capabilities related routines like the following:

    if (!pci_is_pcie(dev))
	return false;

    pos = pci_pcie_cap(dev);
    if (!pos)
	return false;

The current pci_is_pcie() implementation is merely:

    static inline bool pci_is_pcie(struct pci_dev *dev)
    {
        return !!pci_pcie_cap(dev);
    }

so we can just drop the pci_is_pcie() test in such cases.

Suggested by Bjorn Helgaas in -
http://marc.info/?l=linux-pci&m=130463494319762&w=2

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 64471b1..ff0beb0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1995,7 +1995,7 @@ void pci_enable_ari(struct pci_dev *dev)
 		return;
 
 	bridge = dev->bus->self;
-	if (!bridge || !pci_is_pcie(bridge))
+	if (!bridge)
 		return;
 
 	pos = pci_pcie_cap(bridge);
@@ -2055,9 +2055,6 @@ void pci_disable_ido(struct pci_dev *dev, unsigned long type)
 	int pos;
 	u16 ctrl;
 
-	if (!pci_is_pcie(dev))
-		return;
-
 	pos = pci_pcie_cap(dev);
 	if (!pos)
 		return;
@@ -2097,9 +2094,6 @@ int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type type)
 	u16 ctrl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
-		return -ENOTSUPP;
-
 	pos = pci_pcie_cap(dev);
 	if (!pos)
 		return -ENOTSUPP;
@@ -2150,9 +2144,6 @@ void pci_disable_obff(struct pci_dev *dev)
 	int pos;
 	u16 ctrl;
 
-	if (!pci_is_pcie(dev))
-		return;
-
 	pos = pci_pcie_cap(dev);
 	if (!pos)
 		return;
@@ -2175,9 +2166,6 @@ static bool pci_ltr_supported(struct pci_dev *dev)
 	int pos;
 	u32 cap;
 
-	if (!pci_is_pcie(dev))
-		return false;
-
 	pos = pci_pcie_cap(dev);
 	if (!pos)
 		return false;

