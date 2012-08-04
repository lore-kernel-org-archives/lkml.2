Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HDBlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 21:41:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab2HDBlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 21:41:37 -0400
Message-ID: <1344044495.8003.53.camel@ul30vt>
Subject: Re: oops in pci_acs_path_enabled
From: Alex Williamson <alex.williamson@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 Aug 2012 19:41:35 -0600
In-Reply-To: <501C4BCA.1080804@gmail.com>
References: <501C0CDF.7010804@gmail.com> <1344025273.8003.40.camel@ul30vt>
	  <501C3EB7.4000900@gmail.com> <1344030733.8003.43.camel@ul30vt>
	 <501C4BCA.1080804@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 16:08 -0600, David Ahern wrote:
> On 8/3/12 3:52 PM, Alex Williamson wrote:
> > Is this the chunk that's causing the oops?
> 
> Yes. And taking it out fixes passthrough as well.

Hey David,

One more test please.  It looks like sriov creates buses with bus->self
is NULL.  I think what we want to do in this case is to look at
bus->parent->self.  The patch below redefines pci_acs_path_enabled
slightly to allow it to do this.  The caller needs to change too, but
this also allows us to be more consistent about applying quirks and
dealing with multifunction devices.  If this works I'll apply the same
change to amd_iommu and submit.  Thanks,

Alex

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 7469b53..4e37e9b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4124,8 +4124,14 @@ static int intel_iommu_add_device(struct device *dev)
 	} else
 		dma_pdev = pci_dev_get(pdev);
 
+acs_retest:
+	/* Account for quirked devices */
 	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
 
+	/*
+	 * If it's a multifunction device that does not support our
+	 * required ACS flags, add to the same group as function 0.
+	 */
 	if (dma_pdev->multifunction &&
 	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
 		swap_pci_ref(&dma_pdev,
@@ -4133,14 +4139,29 @@ static int intel_iommu_add_device(struct device *dev)
 					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
 					  0)));
 
-	while (!pci_is_root_bus(dma_pdev->bus)) {
-		if (pci_acs_path_enabled(dma_pdev->bus->self,
-					 NULL, REQ_ACS_FLAGS))
-			break;
+	/*
+	 * Test ACS support from our current DMA device up to the top of the
+	 * hierarchy.  If the test fails, go to the next upstream device and
+	 * try again.  Devices on the root bus always go through the iommu.
+	 */
+	if (!pci_is_root_bus(dma_pdev->bus)) {
+		struct pci_bus *bus = dma_pdev->bus;
+
+		if (pci_acs_path_enabled(bus, NULL, REQ_ACS_FLAGS))
+			goto done;
+
+		while (!bus->self) {
+			if (!pci_is_root_bus(bus))
+				bus = bus->parent;
+			else
+				goto done;
+		}
 
-		swap_pci_ref(&dma_pdev, pci_dev_get(dma_pdev->bus->self));
+		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
+		goto acs_retest;
 	}
 
+done:
 	group = iommu_group_get(&dma_pdev->dev);
 	pci_dev_put(dma_pdev);
 	if (!group) {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f3ea977..995c13f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2475,21 +2475,28 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
 }
 
 /**
- * pci_acs_path_enable - test ACS flags from start to end in a hierarchy
- * @start: starting downstream device
+ * pci_acs_path_enabled - test ACS flags from a starting bus to an end device
+ * @bus: starting downstream bus
  * @end: ending upstream device or NULL to search to the root bus
  * @acs_flags: required flags
  *
- * Walk up a device tree from start to end testing PCI ACS support.  If
+ * Walk up a PCI hiearchy from bus to end testing PCI ACS support.  If
  * any step along the way does not support the required flags, return false.
  */
-bool pci_acs_path_enabled(struct pci_dev *start,
+bool pci_acs_path_enabled(struct pci_bus *bus,
 			  struct pci_dev *end, u16 acs_flags)
 {
-	struct pci_dev *pdev, *parent = start;
+	struct pci_dev *pdev;
 
 	do {
-		pdev = parent;
+		while (!bus->self) {
+			if (!pci_is_root_bus(bus))
+				bus = bus->parent;
+			else
+				return (end == NULL);
+		}
+
+		pdev = bus->self;
 
 		if (!pci_acs_enabled(pdev, acs_flags))
 			return false;
@@ -2497,7 +2504,7 @@ bool pci_acs_path_enabled(struct pci_dev *start,
 		if (pci_is_root_bus(pdev->bus))
 			return (end == NULL);
 
-		parent = pdev->bus->self;
+		bus = bus->self->bus;
 	} while (pdev != end);
 
 	return true;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..eb9773c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1652,7 +1652,7 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 
 void pci_request_acs(void);
 bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
-bool pci_acs_path_enabled(struct pci_dev *start,
+bool pci_acs_path_enabled(struct pci_bus *bus,
 			  struct pci_dev *end, u16 acs_flags);
 
 #define PCI_VPD_LRDT			0x80	/* Large Resource Data Type */


