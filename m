Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2HDSTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2HDSTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:19:32 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] pci: Account for virtual buses in pci_acs_path_enabled
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com
Date: Sat, 04 Aug 2012 12:19:29 -0600
Message-ID: <20120804181445.6598.6505.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to have buses without an associated bridge
(bus->self == NULL).  SR-IOV can generate such buses.  When
we find these, skip to the parent bus to look for the next
ACS test.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

David Ahern reported an oops from iommu drivers passing NULL into
this function for the same mistake.  Harden this function against
assuming bus->self is valid as well.  David, please include this
patch as well as the iommu patches in your testing.

 drivers/pci/pci.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f3ea977..e11a49c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2486,18 +2486,30 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
 bool pci_acs_path_enabled(struct pci_dev *start,
 			  struct pci_dev *end, u16 acs_flags)
 {
-	struct pci_dev *pdev, *parent = start;
+	struct pci_dev *pdev = start;
+	struct pci_bus *bus;
 
 	do {
-		pdev = parent;
-
 		if (!pci_acs_enabled(pdev, acs_flags))
 			return false;
 
-		if (pci_is_root_bus(pdev->bus))
+		bus = pdev->bus;
+
+		if (pci_is_root_bus(bus))
 			return (end == NULL);
 
-		parent = pdev->bus->self;
+		/*
+		 * Skip buses without an associated bridge.  In this
+		 * case move to the parent and continue.
+		 */
+		while (!bus->self) {
+			if (!pci_is_root_bus(bus))
+				bus = bus->parent;
+			else
+				return (end == NULL);
+		}
+
+		pdev = bus->self;
 	} while (pdev != end);
 
 	return true;

