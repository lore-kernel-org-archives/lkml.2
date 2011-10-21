Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1JUWfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 18:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1JUWfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 18:35:05 -0400
Subject: Re: [PATCH 0/4] iommu: iommu_ops group interface
From: Alex Williamson <alex.williamson@redhat.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@redhat.com" <chrisw@redhat.com>,
        "agraf@suse.de" <agraf@suse.de>, "dwg@au1.ibm.com" <dwg@au1.ibm.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "B08248@freescale.com" <B08248@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Date: Fri, 21 Oct 2011 16:34:32 -0600
References: <20111021195412.8438.9951.stgit@s20.home>
	 <1319229248.19448.6.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1319236474.19108.25.camel@bling.home>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 15:16 -0600, Alex Williamson wrote:
> On Fri, 2011-10-21 at 20:34 +0000, Woodhouse, David wrote:
> > On Fri, 2011-10-21 at 13:55 -0600, Alex Williamson wrote:
> > > IOMMUs can't always distiguish transactions from each individual
> > > device in a system.  Sometimes this is by design (such as powerpc
> > > partitionable endpoints), other times by topology (PCIe-to-PCI
> > > bridges masking downstream devices).  We call these sets of
> > > indistinguishable devices "groups". 
> > 
> > Other times it's because a multi-function PCIe device is broken and does
> > all its DMA from function zero.... like some Ricoh devices seen in
> > laptops. Can you handle quirks to "group" those too?
> 
> I could add:
> 
> drivers/pci/quirks.c: int pci_iommu_group_mf_quirk(struct pci_dev *)
> 
> That's used just like iommu_group_mf to always blacklist specific
> devices.  Let me know VID/DID if you have them.  Thanks,

I guess just a bit and a quirk is easiest, something like below
(quirking an 82576 just as an example).  Thanks,

Alex

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6f75536..de158d9 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2782,11 +2782,11 @@ static int amd_iommu_device_group(struct device *dev, unsigned int *groupid)
 	if (!dev_data)
 		return -ENODEV;
 
-	if (pdev->is_virtfn || !iommu_group_mf)
-		devid = dev_data->devid;
-	else
+	if (pdev->group_mf || (iommu_group_mf && !pdev->is_virtfn))
 		devid = calc_devid(pdev->bus->number,
 				   PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+	else
+		devid = dev_data->devid;
 
 	*groupid = amd_iommu_alias_table[devid];
 
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a5e1a2f..fba0256 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3939,7 +3939,7 @@ static int intel_iommu_device_group(struct device *dev, unsigned int *groupid)
 		}
 	}
 
-	if (!pdev->is_virtfn && iommu_group_mf)
+	if (pdev->group_mf || (iommu_group_mf && !pdev->is_virtfn))
 		id.pci.devfn = PCI_DEVFN(PCI_SLOT(id.pci.devfn), 0);
 
 	*groupid = id.group;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1196f61..4764645 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3009,3 +3009,9 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 
 	return -ENOTTY;
 }
+
+static void __devinit quirk_iommu_group_mf(struct pci_dev* dev)
+{
+	dev->group_mf = 1;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x10c9, quirk_iommu_group_mf);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..d763027 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -322,6 +322,7 @@ struct pci_dev {
 	unsigned int    is_hotplug_bridge:1;
 	unsigned int    __aer_firmware_first_valid:1;
 	unsigned int	__aer_firmware_first:1;
+	unsigned int	group_mf:1;	/* per device iommu=group_mf */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 



