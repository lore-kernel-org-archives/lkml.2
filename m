Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab1EIXOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:14:41 -0400
Received: from kroah.org ([198.145.64.141]:43802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab1EIXOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:14:30 -0400
Date: Mon, 9 May 2011 16:14:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.13
Message-ID: <20110509231419.GB2992@kroah.com>
References: <20110509231403.GA2992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509231403.GA2992@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 46a1d6a..5bbff08 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index d59a0cd..897b879 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 	long err;
 	int i;
 
-	if (nsops < 1)
+	if (nsops < 1 || nsops > SEMOPM)
 		return -EINVAL;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 4665fc8..e7ad9ca 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -299,6 +299,8 @@ void __init paging_init(void)
 		zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
 		free_area_init_node(i, zones_size,
 				    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
+		if (node_present_pages(i))
+			node_set_state(i, N_NORMAL_MEMORY);
 	}
 }
 
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 13b6e3e..2609f4d 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -265,8 +265,10 @@ static void __init setup_bootmem(void)
 	}
 	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
 
-	for (i = 0; i < npmem_ranges; i++)
+	for (i = 0; i < npmem_ranges; i++) {
+		node_set_state(i, N_NORMAL_MEMORY);
 		node_set_online(i);
+	}
 #endif
 
 	/*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b203d0d..6efea79 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -651,7 +651,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0ae24d9b..a484963 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -79,6 +79,9 @@ static u32 gart_unmapped_entry;
 #define AGPEXTERN
 #endif
 
+/* GART can only remap to physical addresses < 1TB */
+#define GART_MAX_PHYS_ADDR	(1ULL << 40)
+
 /* backdoor interface to AGP driver */
 AGPEXTERN int agp_memory_reserved;
 AGPEXTERN __u32 *agp_gatt_table;
@@ -210,9 +213,13 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir, unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
-	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
+	unsigned long iommu_page;
 	int i;
 
+	if (unlikely(phys_mem + size > GART_MAX_PHYS_ADDR))
+		return bad_dma_addr;
+
+	iommu_page = alloc_iommu(dev, npages, align_mask);
 	if (iommu_page == -1) {
 		if (!nonforced_iommu(dev, phys_mem, size))
 			return phys_mem;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8606c95..cdb8048 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -473,8 +473,10 @@ int blk_register_queue(struct gendisk *disk)
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5516624..89c0b06 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1099,13 +1099,13 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	sdev->sector_size = ATA_SECT_SIZE;
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment and padding */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
+		/* set DMA padding */
 		blk_queue_update_dma_pad(sdev->request_queue,
 					 ATA_DMA_PAD_SZ - 1);
 
@@ -1119,12 +1119,24 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		/* ATA devices must be sector aligned */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_SECT_SIZE - 1);
 		sdev->manage_start_stop = 1;
 	}
 
+	/*
+	 * ata_pio_sectors() expects buffer for each sector to not cross
+	 * page boundary.  Enforce it by requiring buffers to be sector
+	 * aligned, which works iff sector_size is not larger than
+	 * PAGE_SIZE.  ATAPI devices also need the alignment as
+	 * IDENTIFY_PACKET is executed as ATA_PROT_PIO.
+	 */
+	if (sdev->sector_size > PAGE_SIZE)
+		ata_dev_printk(dev, KERN_WARNING,
+			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
+			sdev->sector_size);
+
+	blk_queue_update_dma_alignment(sdev->request_queue,
+				       sdev->sector_size - 1);
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index c505439..0d8d60c 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -123,6 +123,9 @@ static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -242,11 +245,14 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
 	int scratch_pages;
 	struct agp_memory *new;
 	size_t i;
+	int cur_memory;
 
 	if (!bridge)
 		return NULL;
 
-	if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
+	cur_memory = atomic_read(&bridge->current_memory_agp);
+	if ((cur_memory + page_count > bridge->max_memory_agp) ||
+	    (cur_memory + page_count < page_count))
 		return NULL;
 
 	if (type >= AGP_USER_TYPES) {
@@ -1123,8 +1129,8 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 		return -EINVAL;
 	}
 
-	/* AK: could wrap */
-	if ((pg_start + mem->page_count) > num_entries)
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
 		return -EINVAL;
 
 	j = pg_start;
@@ -1158,7 +1164,7 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 {
 	size_t i;
 	struct agp_bridge_data *bridge;
-	int mask_type;
+	int mask_type, num_entries;
 
 	bridge = mem->bridge;
 	if (!bridge)
@@ -1170,6 +1176,11 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 	if (type != mem->type)
 		return -EINVAL;
 
+	num_entries = agp_num_entries();
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
+		return -EINVAL;
+
 	mask_type = bridge->driver->agp_type_to_mask_type(bridge, type);
 	if (mask_type != 0) {
 		/* The generic routines know nothing of memory types */
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index fc8cf7a..4365717 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -119,7 +119,7 @@ static int i8k_smm(struct smm_regs *regs)
 	int eax = regs->eax;
 
 #if defined(CONFIG_X86_64)
-	asm("pushq %%rax\n\t"
+	asm volatile("pushq %%rax\n\t"
 		"movl 0(%%rax),%%edx\n\t"
 		"pushq %%rdx\n\t"
 		"movl 4(%%rax),%%ebx\n\t"
@@ -145,7 +145,7 @@ static int i8k_smm(struct smm_regs *regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
-	asm("pushl %%eax\n\t"
+	asm volatile("pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
 	    "movl 4(%%eax),%%ebx\n\t"
@@ -166,7 +166,8 @@ static int i8k_smm(struct smm_regs *regs)
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index b1f929d..052312f 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -128,7 +128,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_INDEX:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((index >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -138,7 +138,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_DATA:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((data >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -148,7 +148,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_ATTR:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((ctx->
 			      io_attr >> CU8(base + 2)) & (0xFFFFFFFF >> (32 -
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 40a8cfd..09d556d 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -284,7 +284,7 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 				   enum xenbus_state backend_state)
 {
 	struct xenkbd_info *info = dev_get_drvdata(&dev->dev);
-	int val;
+	int ret, val;
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -295,6 +295,16 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 
 	case XenbusStateInitWait:
 InitWait:
+		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				   "feature-abs-pointer", "%d", &val);
+		if (ret < 0)
+			val = 0;
+		if (val) {
+			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
+					    "request-abs-pointer", "1");
+			if (ret)
+				pr_warning("can't request abs-pointer\n");
+		}
 		xenbus_switch_state(dev, XenbusStateConnected);
 		break;
 
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..4f3e3ce 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(debug,
 	DEBSTATUS);
 
 #define DRIVER_VERSION "0.1"
-#define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define DRIVER_NAME "flexcop-pci"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 5c3a176..2fdeab5 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -644,6 +644,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
 		goto release;
 	}
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c279fbc..e6c65a7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1266,6 +1266,13 @@ static void sdhci_tasklet_finish(unsigned long param)
 
 	host = (struct sdhci_host*)param;
 
+        /*
+         * If this tasklet gets rescheduled while running, it will
+         * be run again afterwards but without any active request.
+         */
+	if (!host->mrq)
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	del_timer(&host->timer);
@@ -1277,7 +1284,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 	 * upon error conditions.
 	 */
 	if (!(host->flags & SDHCI_DEVICE_DEAD) &&
-		(mrq->cmd->error ||
+	    ((mrq->cmd && mrq->cmd->error) ||
 		 (mrq->data && (mrq->data->error ||
 		  (mrq->data->stop && mrq->data->stop->error))) ||
 		   (host->quirks & SDHCI_QUIRK_RESET_AFTER_REQUEST))) {
diff --git a/drivers/net/igbvf/igbvf.h b/drivers/net/igbvf/igbvf.h
index a1774b2..fd2cca4 100644
--- a/drivers/net/igbvf/igbvf.h
+++ b/drivers/net/igbvf/igbvf.h
@@ -126,7 +126,6 @@ struct igbvf_buffer {
 			unsigned int page_offset;
 		};
 	};
-	struct page *page;
 };
 
 union igbvf_desc {
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 248c670..5c2cfe6 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
+	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_APLD, CTL_FCC, NO_CTL},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f7d41c7..d660e65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -48,7 +48,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 2
+#define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2f53121..71b86a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1162,11 +1162,15 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwl_tx_status(priv, tx_info->skb[0]);
+
+		if (WARN_ON_ONCE(tx_info->skb == NULL))
+			continue;
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
+
+		iwl_tx_status(priv, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 648be32..2ce57fe 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -703,7 +703,7 @@ int p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len;
+	unsigned int padding, len, extra_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..2eb34dc 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1852,7 +1852,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
-		domain_exit(domain);
+		free_domain_mem(domain);
 		goto error;
 	}
 
@@ -3238,9 +3238,15 @@ static int device_notifier(struct notifier_block *nb,
 	if (!domain)
 		return 0;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through)
+	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
+		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
+		    list_empty(&domain->devices))
+			domain_exit(domain);
+	}
+
 	return 0;
 }
 
@@ -3389,6 +3395,11 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
+
+		spin_lock_irqsave(&iommu->lock, tmp_flags);
+		clear_bit(domain->id, iommu->domain_ids);
+		iommu->domains[domain->id] = NULL;
+		spin_unlock_irqrestore(&iommu->lock, tmp_flags);
 	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 1cca21a..5a7920d 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -63,7 +63,7 @@ static struct dasd_discipline dasd_eckd_discipline;
 static struct ccw_device_id dasd_eckd_ids[] = {
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3390, 0), .driver_info = 0x1},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3390, 0), .driver_info = 0x2},
-	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3390, 0), .driver_info = 0x3},
+	{ CCW_DEVICE_DEVTYPE (0x3880, 0, 0x3380, 0), .driver_info = 0x3},
 	{ CCW_DEVICE_DEVTYPE (0x3990, 0, 0x3380, 0), .driver_info = 0x4},
 	{ CCW_DEVICE_DEVTYPE (0x2105, 0, 0x3380, 0), .driver_info = 0x5},
 	{ CCW_DEVICE_DEVTYPE (0x9343, 0, 0x9345, 0), .driver_info = 0x6},
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 84a124f..e51d6d0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -636,6 +636,13 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 	data_out_sz = karg.data_out_size;
 	data_in_sz = karg.data_in_size;
 
+	/* Check for overflow and wraparound */
+	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	    karg.data_sge_offset > (UINT_MAX / 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* copy in request message frame from user */
 	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__, __LINE__,
@@ -1876,7 +1883,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	int rc, i;
 	u8 buffer_type;
-	unsigned long timeleft;
+	unsigned long timeleft, request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
 	u8 issue_reset = 0;
@@ -1912,6 +1919,8 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 		return -ENOMEM;
 	}
 
+	request_size = ioc->diag_buffer_sz[buffer_type];
+
 	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
 		printk(MPT2SAS_ERR_FMT "%s: either the starting_offset "
 		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
@@ -1919,13 +1928,23 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 		return -EINVAL;
 	}
 
+	if (karg.starting_offset > request_size)
+		return -EINVAL;
+
 	diag_data = (void *)(request_data + karg.starting_offset);
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(%p), "
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
+	/* Truncate data on requests that are too large */
+	if ((diag_data + karg.bytes_to_read < diag_data) ||
+	    (diag_data + karg.bytes_to_read > request_data + request_size))
+		copy_size = request_size - karg.starting_offset;
+	else
+		copy_size = karg.bytes_to_read;
+
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
-	    diag_data, karg.bytes_to_read)) {
+	    diag_data, copy_size)) {
 		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
 		    "mpt_diag_read_buffer_t data @ %p\n", ioc->name,
 		    __func__, diag_data);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b6f1ef9..2dc225e 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3527,6 +3527,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 514ef91..b288d72 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -400,10 +400,15 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 static void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost;
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
+	/* if the device is dead, sdev will be NULL, so no queue to run */
+	if (!sdev)
+		return;
+
+	shost = sdev->host;
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 02f719b..e692671 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -318,14 +318,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	/* NULL queue means the device can't be used */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -963,6 +957,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+
+	/* cause the request function to reject all I/O requests */
+	sdev->request_queue->queuedata = NULL;
+
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index fd6b135..4b50594 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -382,12 +382,13 @@ static void imx_start_tx(struct uart_port *port)
 static irqreturn_t imx_rtsint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
-	unsigned int val = readl(sport->port.membase + USR1) & USR1_RTSS;
+	unsigned int val;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	writel(USR1_RTSD, sport->port.membase + USR1);
+	val = readl(sport->port.membase + USR1) & USR1_RTSS;
 	uart_handle_cts_change(&sport->port, !!val);
 	wake_up_interruptible(&sport->port.state->port.delta_msr_wait);
 
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 16cb6d5..83bbe44 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1134,7 +1134,7 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 		usbip_uerr("create hcd failed\n");
 		return -ENOMEM;
 	}
-
+	hcd->has_tt = 1;
 
 	/* this is private data for vhci_hcd */
 	the_controller = hcd_to_vhci(hcd);
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 5eb9318..e176a06 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1798,6 +1798,7 @@ allocate_instance(struct device *dev,
 	INIT_LIST_HEAD(&musb->out_bulk);
 
 	hcd->uses_new_polling = 1;
+	hcd->has_tt = 1;
 
 	musb->vbuserr_retry = VBUSERR_RETRY_COUNT;
 	musb->a_wait_bcon = OTG_TIME_A_WAIT_BCON;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 5f59a2d..a0288aa 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -861,9 +861,10 @@ out:
 	return ret;
 }
 
-static void nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
+static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long ret = 0;
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
@@ -871,25 +872,32 @@ static void nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		nfsi->change_attr = fattr->change_attr;
 		if (S_ISDIR(inode->i_mode))
 			nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		ret |= NFS_INO_INVALID_ATTR;
 	}
 	/* If we have atomic WCC data, we may update some attributes */
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECTIME)
 			&& (fattr->valid & NFS_ATTR_FATTR_CTIME)
-			&& timespec_equal(&inode->i_ctime, &fattr->pre_ctime))
-			memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
+			&& timespec_equal(&inode->i_ctime, &fattr->pre_ctime)) {
+		memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
+		ret |= NFS_INO_INVALID_ATTR;
+	}
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PREMTIME)
 			&& (fattr->valid & NFS_ATTR_FATTR_MTIME)
 			&& timespec_equal(&inode->i_mtime, &fattr->pre_mtime)) {
-			memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
-			if (S_ISDIR(inode->i_mode))
-				nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
+		if (S_ISDIR(inode->i_mode))
+			nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		ret |= NFS_INO_INVALID_ATTR;
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_PRESIZE)
 			&& (fattr->valid & NFS_ATTR_FATTR_SIZE)
 			&& i_size_read(inode) == nfs_size_to_loff_t(fattr->pre_size)
-			&& nfsi->npages == 0)
-			i_size_write(inode, nfs_size_to_loff_t(fattr->size));
+			&& nfsi->npages == 0) {
+		i_size_write(inode, nfs_size_to_loff_t(fattr->size));
+		ret |= NFS_INO_INVALID_ATTR;
+	}
+	return ret;
 }
 
 /**
@@ -1183,7 +1191,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			| NFS_INO_REVAL_PAGECACHE);
 
 	/* Do atomic weak cache consistency updates */
-	nfs_wcc_update_inode(inode, fattr);
+	invalid |= nfs_wcc_update_inode(inode, fattr);
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index c1e2733..7ffbe3e 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1330,7 +1330,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	int status = 0;
 
 	/* Ensure exclusive access to NFSv4 state */
-	for(;;) {
+	do {
 		if (test_and_clear_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state)) {
 			/* We're going to have to re-establish a clientid */
 			status = nfs4_reclaim_lease(clp);
@@ -1404,7 +1404,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			break;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			break;
-	}
+	} while (atomic_read(&clp->cl_count) > 1);
 	return;
 out_error:
 	printk(KERN_WARNING "Error: state manager failed on NFSv4 server %s"
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 912e61f..a032ec0 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1981,6 +1981,15 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	if (error < 0)
 		goto out;
 
+	/*
+	 * noac is a special case. It implies -o sync, but that's not
+	 * necessarily reflected in the mtab options. do_remount_sb
+	 * will clear MS_SYNCHRONOUS if -o sync wasn't specified in the
+	 * remount options, so we have to explicitly reset it.
+	 */
+	if (data->flags & NFS_MOUNT_NOAC)
+		*flags |= MS_SYNCHRONOUS;
+
 	/* compare new mount options with old ones */
 	error = nfs_compare_remount_data(nfss, data);
 out:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c217a940..dc38b04 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1387,7 +1387,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out;
 	if (!(iap->ia_valid & ATTR_MODE))
 		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
 	if (err)
 		goto out;
 
@@ -1409,6 +1409,13 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (IS_ERR(dchild))
 		goto out_nfserr;
 
+	/* If file doesn't exist, check for permissions to create one */
+	if (!dchild->d_inode) {
+		err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
+		if (err)
+			goto out;
+	}
+
 	err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
 	if (err)
 		goto out;
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 2cd9e43..a2a14cd 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -1299,6 +1299,11 @@ static bool ldm_frag_add (const u8 *data, int size, struct list_head *frags)
 
 	BUG_ON (!data || !frags);
 
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
+		return false;
+	}
+
 	group = get_unaligned_be32(data + 0x08);
 	rec   = get_unaligned_be16(data + 0x0C);
 	num   = get_unaligned_be16(data + 0x0E);
@@ -1306,6 +1311,10 @@ static bool ldm_frag_add (const u8 *data, int size, struct list_head *frags)
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
 	}
+	if (rec >= num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
+		return false;
+	}
 
 	list_for_each (item, frags) {
 		f = list_entry (item, struct frag, list);
@@ -1334,10 +1343,9 @@ found:
 
 	f->map |= (1 << rec);
 
-	if (num > 0) {
-		data += VBLK_SIZE_HEAD;
-		size -= VBLK_SIZE_HEAD;
-	}
+	data += VBLK_SIZE_HEAD;
+	size -= VBLK_SIZE_HEAD;
+
 	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
 
 	return true;
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 868a55e..ae462ae 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -299,6 +299,32 @@ int ubifs_recover_master_node(struct ubifs_info *c)
 			goto out_free;
 		}
 		memcpy(c->rcvrd_mst_node, c->mst_node, UBIFS_MST_NODE_SZ);
+
+		/*
+		 * We had to recover the master node, which means there was an
+		 * unclean reboot. However, it is possible that the master node
+		 * is clean at this point, i.e., %UBIFS_MST_DIRTY is not set.
+		 * E.g., consider the following chain of events:
+		 *
+		 * 1. UBIFS was cleanly unmounted, so the master node is clean
+		 * 2. UBIFS is being mounted R/W and starts changing the master
+		 *    node in the first (%UBIFS_MST_LNUM). A power cut happens,
+		 *    so this LEB ends up with some amount of garbage at the
+		 *    end.
+		 * 3. UBIFS is being mounted R/O. We reach this place and
+		 *    recover the master node from the second LEB
+		 *    (%UBIFS_MST_LNUM + 1). But we cannot update the media
+		 *    because we are being mounted R/O. We have to defer the
+		 *    operation.
+		 * 4. However, this master node (@c->mst_node) is marked as
+		 *    clean (since the step 1). And if we just return, the
+		 *    mount code will be confused and won't recover the master
+		 *    node when it is re-mounter R/W later.
+		 *
+		 *    Thus, to force the recovery by marking the master node as
+		 *    dirty.
+		 */
+		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_DIRTY);
 	} else {
 		/* Write the recovered master node */
 		c->max_sqnum = le64_to_cpu(mst->ch.sqnum) - 1;
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..3e45a9b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1070,6 +1070,7 @@ config SLAB
 	  per cpu and per node queues.
 
 config SLUB
+	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 3c03cb0..f7ae8d3 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1412,9 +1412,14 @@ static int bcm_init(struct sock *sk)
 static int bcm_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
-	struct bcm_sock *bo = bcm_sk(sk);
+	struct bcm_sock *bo;
 	struct bcm_op *op, *next;
 
+	if (sk == NULL)
+		return 0;
+
+	bo = bcm_sk(sk);
+
 	/* remove bcm_ops, timer, rx_unregister(), etc. */
 
 	unregister_netdevice_notifier(&bo->notifier);
diff --git a/net/can/raw.c b/net/can/raw.c
index abca920..502368c 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -280,7 +280,12 @@ static int raw_init(struct sock *sk)
 static int raw_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
-	struct raw_sock *ro = raw_sk(sk);
+	struct raw_sock *ro;
+
+	if (!sk)
+		return 0;
+
+	ro = raw_sk(sk);
 
 	unregister_netdevice_notifier(&ro->notifier);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index b296721..a6e5a08 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -870,8 +870,10 @@ int ip_append_data(struct sock *sk,
 	    !exthdrlen)
 		csummode = CHECKSUM_PARTIAL;
 
+	skb = skb_peek_tail(&sk->sk_write_queue);
+
 	inet->cork.length += length;
-	if (((length> mtu) || !skb_queue_empty(&sk->sk_write_queue)) &&
+	if (((length > mtu) || (skb && skb_is_gso(skb))) &&
 	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		err = ip_ufo_append_data(sk, getfrag, from, length, hh_len,
@@ -889,7 +891,7 @@ int ip_append_data(struct sock *sk,
 	 * adding appropriate IP header.
 	 */
 
-	if ((skb = skb_peek_tail(&sk->sk_write_queue)) == NULL)
+	if (!skb)
 		goto alloc_new_skb;
 
 	while (length > 0) {
@@ -1118,7 +1120,8 @@ ssize_t	ip_append_page(struct sock *sk, struct page *page,
 		return -EINVAL;
 
 	inet->cork.length += size;
-	if ((sk->sk_protocol == IPPROTO_UDP) &&
+	if ((size + skb->len > mtu) &&
+	    (sk->sk_protocol == IPPROTO_UDP) &&
 	    (rt->u.dst.dev->features & NETIF_F_UFO)) {
 		skb_shinfo(skb)->gso_size = mtu - fragheaderlen;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f255119..207c142 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -503,6 +503,8 @@ static int unix_dgram_connect(struct socket *, struct sockaddr *,
 			      int, int);
 static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t);
+static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
+				  struct msghdr *, size_t, int);
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -562,7 +564,7 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.setsockopt =	sock_no_setsockopt,
 	.getsockopt =	sock_no_getsockopt,
 	.sendmsg =	unix_seqpacket_sendmsg,
-	.recvmsg =	unix_dgram_recvmsg,
+	.recvmsg =	unix_seqpacket_recvmsg,
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 };
@@ -1631,6 +1633,18 @@ static int unix_seqpacket_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	return unix_dgram_sendmsg(kiocb, sock, msg, len);
 }
 
+static int unix_seqpacket_recvmsg(struct kiocb *iocb, struct socket *sock,
+			      struct msghdr *msg, size_t size,
+			      int flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return -ENOTCONN;
+
+	return unix_dgram_recvmsg(iocb, sock, msg, size, flags);
+}
+
 static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 {
 	struct unix_sock *u = unix_sk(sk);
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9960d1c..7f97e3f 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -330,7 +330,7 @@ static int conf_choice(struct menu *menu)
 		}
 		if (!child)
 			continue;
-		if (line[strlen(line) - 1] == '?') {
+		if (line[0] && line[strlen(line) - 1] == '?') {
 			print_help(child);
 			continue;
 		}
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index d73c305..940f2ea 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -593,12 +593,12 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
 
 	{ "SPKL", "Input Switch", "MIXINL" },
 	{ "SPKL", "IN1LP Switch", "IN1LP" },
-	{ "SPKL", "Output Switch", "Left Output Mixer" },
+	{ "SPKL", "Output Switch", "Left Output PGA" },
 	{ "SPKL", NULL, "TOCLK" },
 
 	{ "SPKR", "Input Switch", "MIXINR" },
 	{ "SPKR", "IN1RP Switch", "IN1RP" },
-	{ "SPKR", "Output Switch", "Right Output Mixer" },
+	{ "SPKR", "Output Switch", "Right Output PGA" },
 	{ "SPKR", NULL, "TOCLK" },
 
 	{ "SPKL Boost", "Direct Voice Switch", "Direct Voice" },
@@ -620,8 +620,8 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
 	{ "SPKOUTRP", NULL, "SPKR Driver" },
 	{ "SPKOUTRN", NULL, "SPKR Driver" },
 
-	{ "Left Headphone Mux", "Mixer", "Left Output Mixer" },
-	{ "Right Headphone Mux", "Mixer", "Right Output Mixer" },
+	{ "Left Headphone Mux", "Mixer", "Left Output PGA" },
+	{ "Right Headphone Mux", "Mixer", "Right Output PGA" },
 
 	{ "Headphone PGA", NULL, "Left Headphone Mux" },
 	{ "Headphone PGA", NULL, "Right Headphone Mux" },
