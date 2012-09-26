Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2IZTuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 15:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2IZTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 15:50:21 -0400
Message-ID: <1348689013.28860.220.camel@bling.home>
Subject: Re: 3.6-rc7 boot crash + bisection
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Florian Dazinger <florian@dazinger.net>,
        iommu <iommu@lists.linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 26 Sep 2012 13:50:13 -0600
In-Reply-To: <1348676470.28860.197.camel@bling.home>
References: <20120924210348.5f50677b@brain.lan>
	 <1348597970.28860.114.camel@bling.home> <20120925205420.0a07dea2@brain.lan>
	 <1348602226.28860.132.camel@bling.home> <20120926132050.GB10549@amd.com>
	 <1348670159.28860.183.camel@bling.home> <20120926151044.GE10549@amd.com>
	 <1348676470.28860.197.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 10:21 -0600, Alex Williamson wrote:
> On Wed, 2012-09-26 at 17:10 +0200, Roedel, Joerg wrote:
> > On Wed, Sep 26, 2012 at 08:35:59AM -0600, Alex Williamson wrote:
> > > Hmm, that throws a kink in iommu groups.  So perhaps we need to make an
> > > alias interface to iommu groups.  Seems like this could just be an extra
> > > parameter to iommu_group_get and iommu_group_add_device (empty in the
> > > typical case).  Then we have the problem of what's the type for an
> > > alias?  For AMI-Vi, it's a u16, but we need to be more generic than
> > > that.  Maybe iommu groups should just treat it as a void* so iommus can
> > > use a pointer to some structure or a fixed value like a u16 bus:slot.
> > > Thoughts?
> > 
> > Good question. The iommu-groups are part of the IOMMU-API, with an
> > interface to the IOMMU drivers and one to the users of IOMMU-API. So the
> > alias handling itself should be a function of the interface to the IOMMU
> > driver. In general the interface should not be bus specific.
> > 
> > So a void pointer seems the only logical choice then. But I would not
> > limit its scope to alias handling. How about making it a bus-private
> > pointer where IOMMU driver store bus-specific information. That way we
> > make sure that there is one struct per bus-type for this pointer, and
> > not one structure per IOMMU driver.
> 
> I thought of another approach that may actually be more 3.6 worthy.
> What if we just make the iommu driver handle it?  For instance,
> amd_iommu can walk the alias table looking for entries that use the same
> alias and get the device via pci_get_bus_and_slot.  If it finds a device
> with an iommu group, it attaches the new device to the same group,
> hiding anything about aliases from the group layer.  It just groups all
> devices within the range.  I think the only complication is making sure
> we're safe around device hotplug while we're doing this.  Thanks,

I think this could work.  Instead of searching for other devices, check
for or allocate an iommu group on the alias dev_data, any "virtual"
aliases use that iommu group.  Florian, could you test this as well?
Thanks,

Alex

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b64502d..22879ed 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -126,6 +126,8 @@ static void free_dev_data(struct iommu_dev_data *dev_data)
 
 	spin_lock_irqsave(&dev_data_list_lock, flags);
 	list_del(&dev_data->dev_data_list);
+	if (dev_data->group)
+		iommu_group_put(dev_data->group);
 	spin_unlock_irqrestore(&dev_data_list_lock, flags);
 
 	kfree(dev_data);
@@ -256,6 +258,37 @@ static bool check_device(struct device *dev)
 	return true;
 }
 
+/*
+ * Sometimes there's no actual device for an alias.  When that happens
+ * we allocate an iommu group on the iommu_dev_data so that it gets used
+ * by anything with the same alias.  We keep the reference from
+ * iommu_group_alloc so the group persists with the iommu_dev_data.
+ */
+static int dev_data_add_iommu_group(struct iommu_dev_data *dev_data,
+				    struct device *dev)
+{
+	unsigned long flags;
+	struct iommu_group *group;
+	int ret = 0;
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	if (!dev_data->group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group)) {
+			ret = PTR_ERR(group);
+			goto unlock;
+		}
+
+		dev_data->group = group;
+	} else
+		group = dev_data->group;
+
+	ret = iommu_group_add_device(group, dev);
+unlock:
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+	return ret;
+}
+
 static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
 {
 	pci_dev_put(*from);
@@ -264,38 +297,12 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
 
 #define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
 
-static int iommu_init_device(struct device *dev)
+static int pdev_add_iommu_group(struct pci_dev *pdev, struct device *dev)
 {
-	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
-	struct iommu_dev_data *dev_data;
+	struct pci_dev *dma_pdev = pdev;
 	struct iommu_group *group;
-	u16 alias;
 	int ret;
 
-	if (dev->archdata.iommu)
-		return 0;
-
-	dev_data = find_dev_data(get_device_id(dev));
-	if (!dev_data)
-		return -ENOMEM;
-
-	alias = amd_iommu_alias_table[dev_data->devid];
-	if (alias != dev_data->devid) {
-		struct iommu_dev_data *alias_data;
-
-		alias_data = find_dev_data(alias);
-		if (alias_data == NULL) {
-			pr_err("AMD-Vi: Warning: Unhandled device %s\n",
-					dev_name(dev));
-			free_dev_data(dev_data);
-			return -ENOTSUPP;
-		}
-		dev_data->alias_data = alias_data;
-
-		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
-	} else
-		dma_pdev = pci_dev_get(pdev);
-
 	/* Account for quirked devices */
 	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
 
@@ -344,8 +351,61 @@ root_bus:
 
 	iommu_group_put(group);
 
-	if (ret)
-		return ret;
+	return ret;
+}
+
+static int iommu_init_device(struct device *dev)
+{
+	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
+	struct iommu_dev_data *dev_data;
+	u16 alias;
+	int ret;
+
+	if (dev->archdata.iommu)
+		return 0;
+
+	dev_data = find_dev_data(get_device_id(dev));
+	if (!dev_data)
+		return -ENOMEM;
+
+	alias = amd_iommu_alias_table[dev_data->devid];
+	if (alias != dev_data->devid) {
+		struct iommu_dev_data *alias_data;
+
+		alias_data = find_dev_data(alias);
+		if (alias_data == NULL) {
+			pr_err("AMD-Vi: Warning: Unhandled device %s\n",
+					dev_name(dev));
+			free_dev_data(dev_data);
+			return -ENOTSUPP;
+		}
+		dev_data->alias_data = alias_data;
+
+		/*
+		 * If the alias device exists, use it as the base dma
+		 * device.  This results in all devices aliasing to this
+		 * one to be in the same iommu group.  If it doesn't
+		 * actually exist, store the iommu group on the alias
+		 * dev_data and use that for all aliases.
+		 */
+		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
+		if (!dma_pdev) {
+			ret = dev_data_add_iommu_group(alias_data, dev);
+			if (ret) {
+				free_dev_data(dev_data);
+				return ret;
+			}
+		}
+	} else
+		dma_pdev = pci_dev_get(pdev);
+
+	if (dma_pdev) {
+		ret = pdev_add_iommu_group(dma_pdev, dev);
+		if (ret) {
+			free_dev_data(dev_data);
+			return ret;
+		}
+	}
 
 	if (pci_iommuv2_capable(pdev)) {
 		struct amd_iommu *iommu;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index d0dab86..6597d6a 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -404,6 +404,7 @@ struct iommu_dev_data {
 	struct list_head dev_data_list;	  /* For global dev_data_list */
 	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
+	struct iommu_group *group;	  /* IOMMU group for virtual aliases */
 	atomic_t bind;			  /* Domain attach reverent count */
 	u16 devid;			  /* PCI Device ID */
 	bool iommu_v2;			  /* Device can make use of IOMMUv2 */


