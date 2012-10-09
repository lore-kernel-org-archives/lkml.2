Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2JIEt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2JIEtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:49:53 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 3/5] amd_iommu: Split upstream bus device lookup
To: Joerg.Roedel@amd.com, florian@dazinger.net
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:49:48 -0600
Message-ID: <20121009044948.16302.92834.stgit@bling.home>
In-Reply-To: <20121009044057.16302.44577.stgit@bling.home>
References: <20121009044057.16302.44577.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6edbd0e..3a00b5ce 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -274,6 +274,18 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
 	*from = to;
 }
 
+static struct pci_bus *find_hosted_bus(struct pci_bus *bus)
+{
+	while (!bus->self) {
+		if (!pci_is_root_bus(bus))
+			bus = bus->parent;
+		else
+			return ERR_PTR(-ENODEV);
+	}
+
+	return bus;
+}
+
 #define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
 static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
@@ -300,14 +312,9 @@ static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
 	 * Finding the next device may require skipping virtual buses.
 	 */
 	while (!pci_is_root_bus(dma_pdev->bus)) {
-		struct pci_bus *bus = dma_pdev->bus;
-
-		while (!bus->self) {
-			if (!pci_is_root_bus(bus))
-				bus = bus->parent;
-			else
-				goto root_bus;
-		}
+		struct pci_bus *bus = find_hosted_bus(dma_pdev->bus);
+		if (IS_ERR(bus))
+			break;
 
 		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
 			break;
@@ -315,7 +322,6 @@ static struct pci_dev *get_isolation_root(struct pci_dev *pdev)
 		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
 	}
 
-root_bus:
 	return dma_pdev;
 }
 

