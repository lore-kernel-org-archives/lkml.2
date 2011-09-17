Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1IQL5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 07:57:52 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:57856 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1IQL5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 07:57:50 -0400
Subject: Re: iommu_iova leak
Mime-Version: 1.0 (Apple Message framework v1250.3)
Content-Type: text/plain; charset=us-ascii
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <1316256305.24257.25.camel@shinybook.infradead.org>
Date: Sat, 17 Sep 2011 12:57:42 +0100
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
References: <4E734467.3040703@bootc.net> <1316256305.24257.25.camel@shinybook.infradead.org>
To: "Woodhouse, David" <david.woodhouse@intel.com>
X-Mailer: Apple Mail (2.1250.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
> On Fri, 2011-09-16 at 13:43 +0100, Chris Boot wrote:
>> In the very short term the number is up and down by a few hundred 
>> objects but the general trend is constantly upwards. After about 5 days' 
>> uptime I have some very serious IO slowdowns (narrowed down by a friend 
>> to SCSI command queueing) with a lot of time spent in
>> alloc_iova() and rb_prev() according to 'perf top'. Eventually these 
>> translate into softlockups and the machine becomes almost unusable.
> 
> If you're seeing it spend ages in rb_prev() that implies that the
> mappings are still *active* and in the rbtree, rather than just the the
> iommu_iova data structure has been leaked.
> 
> I suppose it's vaguely possible that we're leaking them in such a way
> that they remain on the rbtree, perhaps if the deferred unmap is never
> actually happening... but I think it's a whole lot more likely that the
> PCI driver is just never bothering to unmap the pages it maps.
> 
> If you boot with 'intel_iommu=strict' that will avoid the deferred unmap
> which is the only likely culprit in the IOMMU code...


Booting with intel_iommu=on,strict still shows the iommu_iova on a constant increase, so I don't think it's that.

I've bodged the following patch to see if it catches anything obvious. We'll see if anything useful comes of it. Sorry, my mail client kills whitespace.

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..aebbd56 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2724,6 +2724,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
        int ret;
        struct intel_iommu *iommu;
        unsigned long paddr_pfn = paddr >> PAGE_SHIFT;
+       int dma_map_count;
 
        BUG_ON(dir == DMA_NONE);
 
@@ -2761,6 +2762,9 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
        if (ret)
                goto error;
 
+       dma_map_count = atomic_inc_return(&pdev->dma_map_count);
+       WARN_ON((dma_map_count > 2000) && !(dma_map_count % 1000));
+
        /* it's a non-present to present mapping. Only flush if caching mode */
        if (cap_caching_mode(iommu->cap))
                iommu_flush_iotlb_psi(iommu, domain->id, mm_to_dma_pfn(iova->pfn_lo), size, 1);
@@ -2892,6 +2896,7 @@ static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
 
        pr_debug("Device %s unmapping: pfn %lx-%lx\n",
                 pci_name(pdev), start_pfn, last_pfn);
+       atomic_dec(&pdev->dma_map_count);
 
        /*  clear the whole page */
        dma_pte_clear_range(domain, start_pfn, last_pfn);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f3f94a5..cb1e86b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1108,6 +1108,7 @@ struct pci_dev *alloc_pci_dev(void)
                return NULL;
 
        INIT_LIST_HEAD(&dev->bus_list);
+       atomic_set(&dev->dma_map_count, 0);
 
        return dev;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..d431f39 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -331,6 +331,7 @@ struct pci_dev {
        int rom_attr_enabled;           /* has display of the rom attribute been enabled? */
        struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
        struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
+       atomic_t        dma_map_count;
 #ifdef CONFIG_PCI_MSI
        struct list_head msi_list;
 #endif

-- 
Chris Boot
bootc@bootc.net

