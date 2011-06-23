Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab1FWWgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:36:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51329 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933238Ab1FWWgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:36:15 -0400
X-Sasl-enc: y3p8S3cxsheKsVcQfZ3L1d5Lc9nYlUwlSt9aY1Pe13Tm 1308868564
Date: Thu, 23 Jun 2011 15:35:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.33.15
Message-ID: <20110623223549.GB26114@kroah.com>
References: <20110623223539.GA26114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623223539.GA26114@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 97a11a9..e5e9b65 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 33
-EXTRAVERSION = .14
+EXTRAVERSION = .15
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 4ba0a24..aa35773 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -169,6 +169,7 @@ ENDPROC(v6_coherent_kern_range)
  */
 ENTRY(v6_flush_kern_dcache_area)
 	add	r1, r0, r1
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
 1:
 #ifdef HARVARD_CACHE
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 9073db8..5f27f4c 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -197,6 +197,8 @@ ENDPROC(v7_coherent_user_range)
 ENTRY(v7_flush_kern_dcache_area)
 	dcache_line_size r2, r3
 	add	r1, r0, r1
+	sub	r3, r2, #1
+	bic	r0, r0, r3
 1:
 	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line / unified line
 	add	r0, r0, r2
diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index 8077409..93636ca 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -261,6 +261,28 @@ static int get_kernel(unsigned long pc, unsigned long mmcra)
 	return is_kernel;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 static void power4_handle_interrupt(struct pt_regs *regs,
 				    struct op_counter_config *ctr)
 {
@@ -281,7 +303,7 @@ static void power4_handle_interrupt(struct pt_regs *regs,
 
 	for (i = 0; i < cur_cpu_spec->num_pmcs; ++i) {
 		val = classic_ctr_read(i);
-		if (val < 0) {
+		if (pmc_overflow(val)) {
 			if (oprofile_running && ctr[i].enabled) {
 				oprofile_add_ext_sample(pc, regs, i, is_kernel);
 				classic_ctr_write(i, reset_value[i]);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..99f0ad7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -42,7 +42,7 @@
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
  *
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b70ec99..e803550 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -28,6 +28,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/dma.h>
 #include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -153,6 +154,10 @@ static int iommu_init_device(struct device *dev)
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else {
+		kfree(dev_data);
+		return -ENOTSUPP;
+	}
 
 	atomic_set(&dev_data->bind, 0);
 
@@ -162,6 +167,20 @@ static int iommu_init_device(struct device *dev)
 	return 0;
 }
 
+static void iommu_ignore_device(struct device *dev)
+{
+	u16 devid, alias;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+
+	memset(&amd_iommu_dev_table[devid], 0, sizeof(struct dev_table_entry));
+	memset(&amd_iommu_dev_table[alias], 0, sizeof(struct dev_table_entry));
+
+	amd_iommu_rlookup_table[devid] = NULL;
+	amd_iommu_rlookup_table[alias] = NULL;
+}
+
 static void iommu_uninit_device(struct device *dev)
 {
 	kfree(dev->archdata.iommu);
@@ -191,7 +210,9 @@ int __init amd_iommu_init_devices(void)
 			continue;
 
 		ret = iommu_init_device(&pdev->dev);
-		if (ret)
+		if (ret == -ENOTSUPP)
+			iommu_ignore_device(&pdev->dev);
+		else if (ret)
 			goto out_free;
 	}
 
@@ -2228,6 +2249,23 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 	.dma_supported = amd_iommu_dma_supported,
 };
 
+static unsigned device_dma_ops_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	unsigned unhandled = 0;
+
+	for_each_pci_dev(pdev) {
+		if (!check_device(&pdev->dev)) {
+			unhandled += 1;
+			continue;
+		}
+
+		pdev->dev.archdata.dma_ops = &amd_iommu_dma_ops;
+	}
+
+	return unhandled;
+}
+
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
@@ -2240,7 +2278,7 @@ void __init amd_iommu_init_api(void)
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
-	int ret;
+	int ret, unhandled;
 
 	/*
 	 * first allocate a default protection domain for every IOMMU we
@@ -2266,7 +2304,11 @@ int __init amd_iommu_init_dma_ops(void)
 	swiotlb = 0;
 
 	/* Make the driver finally visible to the drivers */
-	dma_ops = &amd_iommu_dma_ops;
+	unhandled = device_dma_ops_init();
+	if (unhandled && max_pfn > MAX_DMA32_PFN) {
+		/* There are unhandled devices - initialize swiotlb for them */
+		swiotlb = 1;
+	}
 
 	amd_iommu_stats_init();
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 572146b..6432f79 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -646,8 +646,8 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -802,7 +802,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1088,7 +1088,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3825480..29dfd22 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -565,8 +565,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
@@ -582,10 +585,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
 		u64 mask;
+		int err;
 
-		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
-		mask |= (1 << 10);
-		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
+		if (err == 0) {
+			mask |= (1 << 10);
+			checking_wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		}
 	}
 }
 
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index cf889d4..a5a5c7d 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -72,7 +72,7 @@ ENTRY(_copy_to_user)
 	addq %rdx,%rcx
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_to_user
+	ja bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(_copy_to_user)
@@ -85,7 +85,7 @@ ENTRY(_copy_from_user)
 	addq %rdx,%rcx
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_from_user
+	ja bad_from_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6ec047d..356a799 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1141,7 +1141,7 @@ static void drop_other_mm_ref(void *info)
 
 	active_mm = percpu_read(cpu_tlbstate.active_mm);
 
-	if (active_mm == mm)
+	if (active_mm == mm && percpu_read(cpu_tlbstate.state) != TLBSTATE_OK)
 		leave_mm(smp_processor_id());
 
 	/* If this cpu still has a stale cr3 reference, then make sure
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 8bff7e7..1b2b73f 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -189,10 +189,10 @@ struct multicall_space __xen_mc_entry(size_t args)
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
-	    (argidx + args) > MC_ARGS) {
+	    (argidx + args) >= MC_ARGS) {
 		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
@@ -206,7 +206,7 @@ struct multicall_space __xen_mc_entry(size_t args)
 	ret.args = &b->args[argidx];
 	b->argidx = argidx + args;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
@@ -216,7 +216,7 @@ struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 	struct multicall_space ret = { NULL, NULL };
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == 0)
 		return ret;
@@ -224,14 +224,14 @@ struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 	if (b->entries[b->mcidx - 1].op != op)
 		return ret;
 
-	if ((b->argidx + size) > MC_ARGS)
+	if ((b->argidx + size) >= MC_ARGS)
 		return ret;
 
 	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
 	b->argidx += size;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
diff --git a/block/blk-core.c b/block/blk-core.c
index d1a9a0a..bcb60ea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -310,6 +310,7 @@ void blk_unplug_timeout(unsigned long data)
 	trace_block_unplug_timer(q);
 	kblockd_schedule_work(q, &q->unplug_work);
 }
+EXPORT_SYMBOL(blk_put_queue);
 
 void blk_unplug(struct request_queue *q)
 {
@@ -612,6 +613,7 @@ int blk_get_queue(struct request_queue *q)
 
 	return 1;
 }
+EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
diff --git a/block/blk.h b/block/blk.h
index 5ee3d7e..1414836 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -62,7 +62,8 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 				return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
+		    !q->elevator->ops->elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 0efb1f5..ccd2694 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -2,6 +2,7 @@
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -39,11 +40,10 @@
 
 enum {
 	CFR 		= 0x50,
-		CFR_INTR_CH0  = 0x02,
-	CNTRL 		= 0x51,
-		CNTRL_DIS_RA0 = 0x40,
-		CNTRL_DIS_RA1 = 0x80,
-		CNTRL_ENA_2ND = 0x08,
+		CFR_INTR_CH0  = 0x04,
+	CNTRL		= 0x51,
+		CNTRL_CH0     = 0x04,
+		CNTRL_CH1     = 0x08,
 	CMDTIM 		= 0x52,
 	ARTTIM0 	= 0x53,
 	DRWTIM0 	= 0x54,
@@ -53,9 +53,6 @@ enum {
 		ARTTIM23_DIS_RA2  = 0x04,
 		ARTTIM23_DIS_RA3  = 0x08,
 		ARTTIM23_INTR_CH1 = 0x10,
-	ARTTIM2 	= 0x57,
-	ARTTIM3 	= 0x57,
-	DRWTIM23	= 0x58,
 	DRWTIM2 	= 0x58,
 	BRST 		= 0x59,
 	DRWTIM3 	= 0x5b,
@@ -63,14 +60,11 @@ enum {
 	MRDMODE		= 0x71,
 		MRDMODE_INTR_CH0 = 0x04,
 		MRDMODE_INTR_CH1 = 0x08,
-		MRDMODE_BLK_CH0  = 0x10,
-		MRDMODE_BLK_CH1	 = 0x20,
 	BMIDESR0	= 0x72,
 	UDIDETCR0	= 0x73,
 	DTPR0		= 0x74,
 	BMIDECR1	= 0x78,
 	BMIDECSR	= 0x79,
-	BMIDESR1	= 0x7A,
 	UDIDETCR1	= 0x7B,
 	DTPR1		= 0x7C
 };
@@ -147,7 +141,9 @@ static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 m
 	/* Now convert the clocks into values we can actually stuff into
 	   the chip */
 
-	if (t.recover > 1)
+	if (t.recover == 16)
+		t.recover = 0;
+	else if (t.recover > 1)
 		t.recover--;
 	else
 		t.recover = 15;
@@ -245,7 +241,7 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 dma_intr;
 	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_reg = ap->port_no ? ARTTIM2 : CFR;
+	int dma_reg = ap->port_no ? ARTTIM23 : CFR;
 
 	ata_bmdma_stop(qc);
 
@@ -335,9 +331,19 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.port_ops = &cmd648_port_ops
 		}
 	};
-	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
-	u8 mrdmode;
+	const struct ata_port_info *ppi[] = {
+		&cmd_info[id->driver_data],
+		&cmd_info[id->driver_data],
+		NULL
+	};
+	u8 mrdmode, reg;
 	int rc;
+	struct pci_dev *bridge = pdev->bus->self;
+	/* mobility split bridges don't report enabled ports correctly */
+	int port_ok = !(bridge && bridge->vendor ==
+			PCI_VENDOR_ID_MOBILITY_ELECTRONICS);
+	/* all (with exceptions below) apart from 643 have CNTRL_CH0 bit */
+	int cntrl_ch0_ok = (id->driver_data != 0);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -348,11 +354,18 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
-		if (pdev->revision > 4)
+		if (pdev->revision > 4) {
 			ppi[0] = &cmd_info[2];
+			ppi[1] = &cmd_info[2];
+		}
 		/* Early rev with other problems ? */
-		else if (pdev->revision == 1)
+		else if (pdev->revision == 1) {
 			ppi[0] = &cmd_info[3];
+			ppi[1] = &cmd_info[3];
+		}
+		/* revs 1,2 have no CNTRL_CH0 */
+		if (pdev->revision < 3)
+			cntrl_ch0_ok = 0;
 	}
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -361,6 +374,20 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
+	/* check for enabled ports */
+	pci_read_config_byte(pdev, CNTRL, &reg);
+	if (!port_ok)
+		dev_printk(KERN_NOTICE, &pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
+	if (port_ok && cntrl_ch0_ok && !(reg & CNTRL_CH0)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Primary port is disabled\n");
+		ppi[0] = &ata_dummy_port_info;
+
+	}
+	if (port_ok && !(reg & CNTRL_CH1)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Secondary port is disabled\n");
+		ppi[1] = &ata_dummy_port_info;
+	}
+
 	/* Force PIO 0 here.. */
 
 	/* PPC specific fixup copied from old driver */
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 4f68843..2ef55c4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -498,7 +498,7 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 	struct kobject *kobj;
 
 	mutex_lock(&brd_devices_mutex);
-	brd = brd_init_one(dev & MINORMASK);
+	brd = brd_init_one(MINOR(dev) >> part_shift);
 	kobj = brd ? get_disk(brd->brd_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&brd_devices_mutex);
 
@@ -531,15 +531,18 @@ static int __init brd_init(void)
 	if (max_part > 0)
 		part_shift = fls(max_part);
 
+	if ((1UL << part_shift) > DISK_MAX_PARTS)
+		return -EINVAL;
+
 	if (rd_nr > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (rd_nr) {
 		nr = rd_nr;
-		range = rd_nr;
+		range = rd_nr << part_shift;
 	} else {
 		nr = CONFIG_BLK_DEV_RAM_COUNT;
-		range = 1UL << (MINORBITS - part_shift);
+		range = 1UL << MINORBITS;
 	}
 
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
@@ -578,7 +581,7 @@ static void __exit brd_exit(void)
 	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
+	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bd112c8..a7ee66d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1570,7 +1570,7 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	struct kobject *kobj;
 
 	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(dev & MINORMASK);
+	lo = loop_init_one(MINOR(dev) >> part_shift);
 	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&loop_devices_mutex);
 
@@ -1603,15 +1603,18 @@ static int __init loop_init(void)
 	if (max_part > 0)
 		part_shift = fls(max_part);
 
+	if ((1UL << part_shift) > DISK_MAX_PARTS)
+		return -EINVAL;
+
 	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (max_loop) {
 		nr = max_loop;
-		range = max_loop;
+		range = max_loop << part_shift;
 	} else {
 		nr = 8;
-		range = 1UL << (MINORBITS - part_shift);
+		range = 1UL << MINORBITS;
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
@@ -1650,7 +1653,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
+	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index cc923a5..26ada47 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -754,6 +754,12 @@ static int __init nbd_init(void)
 	if (max_part > 0)
 		part_shift = fls(max_part);
 
+	if ((1UL << part_shift) > DISK_MAX_PARTS)
+		return -EINVAL;
+
+	if (nbds_max > 1UL << (MINORBITS - part_shift))
+		return -EINVAL;
+
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1 << part_shift);
 		if (!disk)
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 4365717..1e116ac 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -138,8 +138,8 @@ static int i8k_smm(struct smm_regs *regs)
 		"movl %%edi,20(%%rax)\n\t"
 		"popq %%rdx\n\t"
 		"movl %%edx,0(%%rax)\n\t"
-		"lahf\n\t"
-		"shrl $8,%%eax\n\t"
+		"pushfq\n\t"
+		"popq %%rax\n\t"
 		"andl $1,%%eax\n"
 		:"=a"(rc)
 		:    "a"(regs)
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 295dc63..2a6dacc 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1207,12 +1207,28 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 
 	unlock_policy_rwsem_write(cpu);
 
+	cpufreq_debug_enable_ratelimit();
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* when the CPU which is the parent of the kobj is hotplugged
+	 * offline, check for siblings, and create cpufreq sysfs interface
+	 * and symlinks
+	 */
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		/* first sibling now owns the new sysfs dir */
+		cpumask_clear_cpu(cpu, data->cpus);
+		cpufreq_add_dev(get_cpu_sysdev(cpumask_first(data->cpus)));
+
+		/* finally remove our own symlink */
+		lock_policy_rwsem_write(cpu);
+		__cpufreq_remove_dev(sys_dev);
+	}
+#endif
+
 	free_cpumask_var(data->related_cpus);
 	free_cpumask_var(data->cpus);
 	kfree(data);
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-	cpufreq_debug_enable_ratelimit();
 	return 0;
 }
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5a62d67..6bbc164 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -164,17 +164,27 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
+/* should be called late in the CPU removal sequence so that the stats
+ * memory is still available in case someone tries to use it.
+ */
 static void cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	if (policy && policy->cpu == cpu)
-		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (stat) {
 		kfree(stat->time_in_state);
 		kfree(stat);
 	}
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
+}
+
+/* must be called early in the CPU removal sequence (before
+ * cpufreq_remove_dev) so that policy is still valid.
+ */
+static void cpufreq_stats_free_sysfs(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	if (policy && policy->cpu == cpu)
+		sysfs_remove_group(&policy->kobj, &stats_attr_group);
 	if (policy)
 		cpufreq_cpu_put(policy);
 }
@@ -315,6 +325,9 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
+	case CPU_DOWN_PREPARE:
+		cpufreq_stats_free_sysfs(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
@@ -323,9 +336,11 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
+/* priority=1 so this will get called before cpufreq_remove_dev */
 static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
+	.priority = 1,
 };
 
 static struct notifier_block notifier_policy_block = {
@@ -372,6 +387,7 @@ static void __exit cpufreq_stats_exit(void)
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
 		cpufreq_stats_free_table(cpu);
+		cpufreq_stats_free_sysfs(cpu);
 	}
 }
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f8e57c6..0537437 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -185,6 +185,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
+	struct timespec t;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -199,8 +200,9 @@ static int menu_select(struct cpuidle_device *dev)
 		return 0;
 
 	/* determine the expected residency time, round up */
+	t = ktime_to_timespec(tick_nohz_get_sleep_length());
 	data->expected_us =
-	    DIV_ROUND_UP((u32)ktime_to_ns(tick_nohz_get_sleep_length()), 1000);
+		t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
 
 
 	data->bucket = which_bucket(data->expected_us);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 49c724e..451d3fe 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -915,6 +915,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Asus EeeBox PC EB1007",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EB1007"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 509ba3f..5f081bb 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -682,6 +682,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	dma_bits = rdev->need_dma32 ? 32 : 40;
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
+		rdev->need_dma32 = true;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b22feb..c2af31b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -352,6 +352,7 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
+	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -360,6 +361,22 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
+	/*
+	 * Some devices exist without request functions,
+	 * such as loop devices not yet bound to backing files.
+	 * Forbid the use of such devices.
+	 */
+	q = bdev_get_queue(bdev);
+	if (!q || !q->make_request_fn) {
+		DMWARN("%s: %s is not yet initialised: "
+		       "start=%llu, len=%llu, dev_size=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       (unsigned long long)start,
+		       (unsigned long long)len,
+		       (unsigned long long)dev_size);
+		return 1;
+	}
+
 	if (!dev_size)
 		return 0;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3512dd8..0da8025 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2386,7 +2386,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		if (rdev->raid_disk == -1)
 			return -EEXIST;
 		/* personality does all needed checks */
-		if (rdev->mddev->pers->hot_add_disk == NULL)
+		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		err = rdev->mddev->pers->
 			hot_remove_disk(rdev->mddev, rdev->raid_disk);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 105a3dc..96d79ab 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -127,7 +127,7 @@ static inline int raid5_dec_bi_hw_segments(struct bio *bio)
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */
diff --git a/drivers/mtd/mtdconcat.c b/drivers/mtd/mtdconcat.c
index db6de74..b140257 100644
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -306,7 +306,7 @@ concat_write_oob(struct mtd_info *mtd, loff_t to, struct mtd_oob_ops *ops)
 	if (!(mtd->flags & MTD_WRITEABLE))
 		return -EROFS;
 
-	ops->retlen = 0;
+	ops->retlen = ops->oobretlen = 0;
 
 	for (i = 0; i < concat->num_subdev; i++) {
 		struct mtd_info *subdev = concat->subdev[i];
@@ -321,7 +321,7 @@ concat_write_oob(struct mtd_info *mtd, loff_t to, struct mtd_oob_ops *ops)
 			devops.len = subdev->size - to;
 
 		err = subdev->write_oob(subdev, to, &devops);
-		ops->retlen += devops.retlen;
+		ops->retlen += devops.oobretlen;
 		if (err)
 			return err;
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 171ce2b..16cb529 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -614,7 +614,8 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
-		if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
+		if (WLAN_RC_PHY_40(rate_table->info[rix].phy) &&
+		    conf_is_ht40(&txrc->hw->conf))
 			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d660e65..f7d41c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -48,7 +48,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 5
+#define IWL5000_UCODE_API_MAX 2
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 54c3a9d..cb74ac6 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -80,6 +80,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
 	{USB_DEVICE(0x0915, 0x2000)},	/* Cohiba Proto board */
diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
index 80b461c..749fdf0 100644
--- a/drivers/pci/hotplug/pcihp_slot.c
+++ b/drivers/pci/hotplug/pcihp_slot.c
@@ -158,6 +158,47 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
 	 */
 }
 
+/* Program PCIE MaxPayload setting on device: ensure parent maxpayload <= device */
+static int pci_set_payload(struct pci_dev *dev)
+{
+       int pos, ppos;
+       u16 pctl, psz;
+       u16 dctl, dsz, dcap, dmax;
+       struct pci_dev *parent;
+
+       parent = dev->bus->self;
+       pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+       if (!pos)
+               return 0;
+
+       /* Read Device MaxPayload capability and setting */
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &dctl);
+       pci_read_config_word(dev, pos + PCI_EXP_DEVCAP, &dcap);
+       dsz = (dctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+       dmax = (dcap & PCI_EXP_DEVCAP_PAYLOAD);
+
+       /* Read Parent MaxPayload setting */
+       ppos = pci_find_capability(parent, PCI_CAP_ID_EXP);
+       if (!ppos)
+               return 0;
+       pci_read_config_word(parent, ppos + PCI_EXP_DEVCTL, &pctl);
+       psz = (pctl &  PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+
+       /* If parent payload > device max payload -> error
+        * If parent payload > device payload -> set speed
+        * If parent payload <= device payload -> do nothing
+        */
+       if (psz > dmax)
+               return -1;
+       else if (psz > dsz) {
+               dev_info(&dev->dev, "Setting MaxPayload to %d\n", 128 << psz);
+               pci_write_config_word(dev, pos + PCI_EXP_DEVCTL,
+                                     (dctl & ~PCI_EXP_DEVCTL_PAYLOAD) +
+                                     (psz << 5));
+       }
+       return 0;
+}
+
 void pci_configure_slot(struct pci_dev *dev)
 {
 	struct pci_dev *cdev;
@@ -169,6 +210,10 @@ void pci_configure_slot(struct pci_dev *dev)
 			(dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
 		return;
 
+       ret = pci_set_payload(dev);
+       if (ret)
+               dev_warn(&dev->dev, "could not set device max payload\n");
+
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
 	if (ret)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3eb4a3d..0879981 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2537,6 +2537,16 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
 
 #endif /* CONFIG_PCI_MSI */
 
+static void __devinit fixup_ti816x_class(struct pci_dev* dev)
+{
+	/* TI 816x devices do not have class code set when in PCIe boot mode */
+	if (dev->class == PCI_CLASS_NOT_DEFINED) {
+		dev_info(&dev->dev, "Setting PCI class for 816x PCIe device\n");
+		dev->class = PCI_CLASS_MULTIMEDIA_VIDEO;
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 1af578d..52a7930 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1199,6 +1199,7 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 	iscsi_init.dummy_buffer_addr_hi =
 		(u32) ((u64) hba->dummy_buf_dma >> 32);
 
+	hba->num_ccell = hba->max_sqes >> 1;
 	hba->ctx_ccell_tasks =
 			((hba->num_ccell & 0xFFFF) | (hba->max_sqes << 16));
 	iscsi_init.num_ccells_per_conn = hba->num_ccell;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 33b2294..930ca5b 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1159,6 +1159,9 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 	struct bnx2i_cmd *cmd = task->dd_data;
 	struct iscsi_cmd *hdr = (struct iscsi_cmd *) task->hdr;
 
+	if (bnx2i_conn->ep->num_active_cmds + 1 > hba->max_sqes)
+		return -ENOMEM;
+
 	/*
 	 * If there is no scsi_cmnd this must be a mgmt task
 	 */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 012f73a..d6d6c74 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -294,7 +294,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
@@ -1339,8 +1339,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		sdev = scsi_alloc_sdev(starget, 0, NULL);
 		if (!sdev)
 			return 0;
-		if (scsi_device_get(sdev))
+		if (scsi_device_get(sdev)) {
+			__scsi_remove_device(sdev);
 			return 0;
+		}
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
@@ -1907,10 +1909,9 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev) {
-		sdev->sdev_gendev.parent = get_device(&starget->dev);
+	if (sdev)
 		sdev->borken = 0;
-	} else
+	else
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e692671..06a7d07 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -318,6 +318,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
@@ -872,7 +873,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
-	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
+	error = scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (error)
 		return error;
 
 	error = scsi_target_add(starget);
@@ -883,13 +885,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		printk(KERN_INFO "error 1\n");
-		goto out_remove;
+		return error;
 	}
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
 		device_del(&sdev->sdev_gendev);
-		goto out_remove;
+		return error;
 	}
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
@@ -904,14 +906,14 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
 	if (error)
-		goto out_remove;
+		return error;
 
 	if (sdev->host->hostt->change_queue_type)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
 	else
 		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
 	if (error)
-		goto out_remove;
+		return error;
 
 	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
 
@@ -927,16 +929,11 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 			error = device_create_file(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error)
-				goto out_remove;
+				return error;
 		}
 	}
 
-	return 0;
-
- out_remove:
-	__scsi_remove_device(sdev);
 	return error;
-
 }
 
 void __scsi_remove_device(struct scsi_device *sdev)
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..7f0eda2 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -306,7 +306,7 @@ static inline int find_and_clear_bit_16(unsigned long *field)
 	"0: bsfw %1,%w0\n\t"
 	"btr %0,%1\n\t"
 	"jnc 0b"
-	: "=&r" (rv), "=m" (*field) :);
+	: "=&r" (rv), "+m" (*field) :);
 
   return rv;
 }
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 719e0c1..3c5c62de 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -770,7 +770,7 @@ static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index c33d098..6a8a3c2 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -327,7 +327,8 @@ static int get_hub_status(struct usb_device *hdev,
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_HUB, 0, 0,
 			data, sizeof(*data), USB_STS_TIMEOUT);
@@ -343,7 +344,8 @@ static int get_port_status(struct usb_device *hdev, int port1,
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_PORT, 0, port1,
 			data, sizeof(*data), USB_STS_TIMEOUT);
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 043e04d..aedd37b 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1687,7 +1687,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 	}
 
 	/* newer chips have more FIFO memory than rm9200 */
-	if (cpu_is_at91sam9260()) {
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
 		udc->ep[0].maxpacket = 64;
 		udc->ep[3].maxpacket = 64;
 		udc->ep[4].maxpacket = 512;
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 95dae4c..e2f144c 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -419,8 +419,7 @@ rndis_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
 	 */
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8)
 			| USB_CDC_SEND_ENCAPSULATED_COMMAND:
-		if (w_length > req->length || w_value
-				|| w_index != rndis->ctrl_id)
+		if (w_value || w_index != rndis->ctrl_id)
 			goto invalid;
 		/* read the request; process it later */
 		value = w_length;
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 8d548e2..fe2b76c 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -505,9 +505,19 @@ static unsigned int xhci_parse_exponent_interval(struct usb_device *udev,
 	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
 	if (interval != ep->desc.bInterval - 1)
 		dev_warn(&udev->dev,
-			 "ep %#x - rounding interval to %d microframes\n",
+			 "ep %#x - rounding interval to %d %sframes\n",
 			 ep->desc.bEndpointAddress,
-			 1 << interval);
+			 1 << interval,
+			 udev->speed == USB_SPEED_FULL ? "" : "micro");
+
+	if (udev->speed == USB_SPEED_FULL) {
+		/*
+		 * Full speed isoc endpoints specify interval in frames,
+		 * not microframes. We are using microframes everywhere,
+		 * so adjust accordingly.
+		 */
+		interval += 3;	/* 1 frame = 2^3 uframes */
+	}
 
 	return interval;
 }
@@ -564,12 +574,12 @@ static inline unsigned int xhci_get_endpoint_interval(struct usb_device *udev,
 		break;
 
 	case USB_SPEED_FULL:
-		if (usb_endpoint_xfer_int(&ep->desc)) {
+		if (usb_endpoint_xfer_isoc(&ep->desc)) {
 			interval = xhci_parse_exponent_interval(udev, ep);
 			break;
 		}
 		/*
-		 * Fall through for isochronous endpoint interval decoding
+		 * Fall through for interrupt endpoint interval decoding
 		 * since it uses the same rules as low speed interrupt
 		 * endpoints.
 		 */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7ba67e3..dd2182c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -566,6 +566,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_APP70_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	/*
 	 * ELV devices:
 	 */
@@ -646,6 +647,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, EVER_ECO_PRO_CDS) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_4N_GALAXY_DE_3_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_0_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_1_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index f3200c4..acf476a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -331,6 +331,7 @@
  */
 #define FTDI_4N_GALAXY_DE_1_PID	0xF3C0
 #define FTDI_4N_GALAXY_DE_2_PID	0xF3C1
+#define FTDI_4N_GALAXY_DE_3_PID	0xF3C2
 
 /*
  * Linx Technologies product ids
@@ -471,6 +472,11 @@
 /* www.canusb.com Lawicel CANUSB device (FTDI_VID) */
 #define FTDI_CANUSB_PID 0xFFA8 /* Product Id */
 
+/*
+ * TavIR AVR product ids (FTDI_VID)
+ */
+#define FTDI_TAVIR_STK500_PID	0xFA33	/* STK500 AVR programmer */
+
 
 
 /********************************/
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 5ac900e..867d97b 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1,7 +1,7 @@
 /*
  * Garmin GPS driver
  *
- * Copyright (C) 2006-2009 Hermann Kneissel herkne@users.sourceforge.net
+ * Copyright (C) 2006-2011 Hermann Kneissel herkne@gmx.de
  *
  * The latest version of the driver can be found at
  * http://sourceforge.net/projects/garmin-gps/
@@ -51,7 +51,7 @@ static int debug;
  */
 
 #define VERSION_MAJOR	0
-#define VERSION_MINOR	33
+#define VERSION_MINOR	36
 
 #define _STR(s) #s
 #define _DRIVER_VERSION(a, b) "v" _STR(a) "." _STR(b)
@@ -411,6 +411,7 @@ static int gsp_send_ack(struct garmin_data *garmin_data_p, __u8 pkt_id)
  */
 static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 {
+	unsigned long flags;
 	const __u8 *recpkt = garmin_data_p->inbuffer+GSP_INITIAL_OFFSET;
 	__le32 *usbdata = (__le32 *) garmin_data_p->inbuffer;
 
@@ -459,7 +460,9 @@ static int gsp_rec_packet(struct garmin_data *garmin_data_p, int count)
 	/* if this was an abort-transfer command, flush all
 	   queued data. */
 	if (isAbortTrfCmnd(garmin_data_p->inbuffer)) {
+		spin_lock_irqsave(&garmin_data_p->lock, flags);
 		garmin_data_p->flags |= FLAGS_DROP_DATA;
+		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 		pkt_clear(garmin_data_p);
 	}
 
@@ -944,7 +947,7 @@ static int garmin_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_lock_irqsave(&garmin_data_p->lock, flags);
 	garmin_data_p->mode  = initial_mode;
 	garmin_data_p->count = 0;
-	garmin_data_p->flags = 0;
+	garmin_data_p->flags &= FLAGS_SESSION_REPLY1_SEEN;
 	spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 	/* shutdown any bulk reads that might be going on */
@@ -1179,7 +1182,8 @@ static int garmin_write_room(struct tty_struct *tty)
 
 
 static void garmin_read_process(struct garmin_data *garmin_data_p,
-				 unsigned char *data, unsigned data_length)
+				 unsigned char *data, unsigned data_length,
+				 int bulk_data)
 {
 	unsigned long flags;
 
@@ -1194,7 +1198,8 @@ static void garmin_read_process(struct garmin_data *garmin_data_p,
 		   send it directly to the tty port */
 		if (garmin_data_p->flags & FLAGS_QUEUING) {
 			pkt_add(garmin_data_p, data, data_length);
-		} else if (getLayerId(data) == GARMIN_LAYERID_APPL) {
+		} else if (bulk_data ||
+			   getLayerId(data) == GARMIN_LAYERID_APPL) {
 
 			spin_lock_irqsave(&garmin_data_p->lock, flags);
 			garmin_data_p->flags |= APP_RESP_SEEN;
@@ -1238,7 +1243,7 @@ static void garmin_read_bulk_callback(struct urb *urb)
 	usb_serial_debug_data(debug, &port->dev,
 				__func__, urb->actual_length, data);
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 1);
 
 	if (urb->actual_length == 0 &&
 			0 != (garmin_data_p->flags & FLAGS_BULK_IN_RESTART)) {
@@ -1348,7 +1353,7 @@ static void garmin_read_int_callback(struct urb *urb)
 			__func__, garmin_data_p->serial_num);
 	}
 
-	garmin_read_process(garmin_data_p, data, urb->actual_length);
+	garmin_read_process(garmin_data_p, data, urb->actual_length, 0);
 
 	port->interrupt_in_urb->dev = port->serial->dev;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -1463,6 +1468,7 @@ static int garmin_attach(struct usb_serial *serial)
 	garmin_data_p->timer.function = timeout_handler;
 	garmin_data_p->port = port;
 	garmin_data_p->state = 0;
+	garmin_data_p->flags = 0;
 	garmin_data_p->count = 0;
 	usb_set_serial_port_data(port, garmin_data_p);
 
diff --git a/drivers/usb/serial/moto_modem.c b/drivers/usb/serial/moto_modem.c
index 99bd00f5..c53a8a5 100644
--- a/drivers/usb/serial/moto_modem.c
+++ b/drivers/usb/serial/moto_modem.c
@@ -25,6 +25,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
 	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
 	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
+	{ USB_DEVICE(0x22b8, 0x2c84) }, /* Motorola VE240 phone */
 	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
 	{ },
 };
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8db62b2..5d8d311 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1211,6 +1211,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (!bdev->bd_part)
 				goto out_clear;
 
+			ret = 0;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
 				if (ret == -ERESTARTSYS) {
@@ -1226,9 +1227,18 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					mutex_unlock(&bdev->bd_mutex);
 					goto restart;
 				}
-				if (ret)
-					goto out_clear;
 			}
+			/*
+			 * If the device is invalidated, rescan partition
+			 * if open succeeded or failed with -ENOMEDIUM.
+			 * The latter is necessary to prevent ghost
+			 * partitions on a removed medium.
+			 */
+			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
+				rescan_partitions(disk, bdev);
+			if (ret)
+				goto out_clear;
+
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
@@ -1236,8 +1246,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					bdi = &default_backing_dev_info;
 				bdev->bd_inode->i_data.backing_dev_info = bdi;
 			}
-			if (bdev->bd_invalidated)
-				rescan_partitions(disk, bdev);
 		} else {
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
@@ -1264,13 +1272,14 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
-			if (bdev->bd_disk->fops->open) {
+			ret = 0;
+			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
-				if (ret)
-					goto out_unlock_bdev;
-			}
-			if (bdev->bd_invalidated)
+			/* the same as first opener case, read comment there */
+			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
 				rescan_partitions(bdev->bd_disk, bdev);
+			if (ret)
+				goto out_unlock_bdev;
 		}
 	}
 	bdev->bd_openers++;
diff --git a/fs/dcookies.c b/fs/dcookies.c
index a21cabd..dda0dc7 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -178,6 +178,8 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 	/* FIXME: (deleted) ? */
 	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
+	mutex_unlock(&dcookie_mutex);
+
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
 		goto out_free;
@@ -194,6 +196,7 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 
 out_free:
 	kfree(kbuf);
+	return err;
 out:
 	mutex_unlock(&dcookie_mutex);
 	return err;
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index aa2480a..8f1a525 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -481,8 +481,8 @@ struct ecryptfs_write_tag_70_packet_silly_stack {
 	struct mutex *tfm_mutex;
 	char *block_aligned_filename;
 	struct ecryptfs_auth_tok *auth_tok;
-	struct scatterlist src_sg;
-	struct scatterlist dst_sg;
+	struct scatterlist src_sg[2];
+	struct scatterlist dst_sg[2];
 	struct blkcipher_desc desc;
 	char iv[ECRYPTFS_MAX_IV_BYTES];
 	char hash[ECRYPTFS_TAG_70_DIGEST_SIZE];
@@ -695,23 +695,21 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	memcpy(&s->block_aligned_filename[s->num_rand_bytes], filename,
 	       filename_size);
 	rc = virt_to_scatterlist(s->block_aligned_filename,
-				 s->block_aligned_filename_size, &s->src_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->src_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
-		       "convert filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
+		       "convert filename memory to scatterlist; rc = [%d]. "
 		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
 	rc = virt_to_scatterlist(&dest[s->i], s->block_aligned_filename_size,
-				 &s->dst_sg, 1);
-	if (rc != 1) {
+				 s->dst_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
 	/* The characters in the first block effectively do the job
@@ -734,7 +732,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_release_free_unlock;
 	}
-	rc = crypto_blkcipher_encrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_encrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to encrypt filename; "
@@ -766,8 +764,8 @@ struct ecryptfs_parse_tag_70_packet_silly_stack {
 	struct mutex *tfm_mutex;
 	char *decrypted_filename;
 	struct ecryptfs_auth_tok *auth_tok;
-	struct scatterlist src_sg;
-	struct scatterlist dst_sg;
+	struct scatterlist src_sg[2];
+	struct scatterlist dst_sg[2];
 	struct blkcipher_desc desc;
 	char fnek_sig_hex[ECRYPTFS_SIG_SIZE_HEX + 1];
 	char iv[ECRYPTFS_MAX_IV_BYTES];
@@ -872,13 +870,12 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	}
 	mutex_lock(s->tfm_mutex);
 	rc = virt_to_scatterlist(&data[(*packet_size)],
-				 s->block_aligned_filename_size, &s->src_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->src_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_unlock;
 	}
 	(*packet_size) += s->block_aligned_filename_size;
@@ -892,13 +889,12 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		goto out_unlock;
 	}
 	rc = virt_to_scatterlist(s->decrypted_filename,
-				 s->block_aligned_filename_size, &s->dst_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->dst_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert decrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_free_unlock;
 	}
 	/* The characters in the first block effectively do the job of
@@ -937,7 +933,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_free_unlock;
 	}
-	rc = crypto_blkcipher_decrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_decrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to decrypt filename; "
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 5589aa1..9370b8c 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1425,10 +1425,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
+	/*
+	 * Mark buffers dirty here so that if do_split() fails we write a
+	 * consistent set of buffers to disk.
+	 */
+	ext3_journal_dirty_metadata(handle, frame->bh);
+	ext3_journal_dirty_metadata(handle, bh);
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		ext3_mark_inode_dirty(handle, dir);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d34afad..c63c529 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1138,6 +1138,8 @@ repeat_load_buddy:
 	return 0;
 
 err:
+	if (page)
+		page_cache_release(page);
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)
diff --git a/fs/fat/file.c b/fs/fat/file.c
index e8c159d..279937b 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -101,7 +101,7 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 4bd8825..17d29a8 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -746,8 +746,13 @@ wait_for_iobuf:
                    required. */
 		JBUFFER_TRACE(jh, "file as BJ_Forget");
 		journal_file_buffer(jh, commit_transaction, BJ_Forget);
-		/* Wake up any transactions which were waiting for this
-		   IO to complete */
+		/*
+		 * Wake up any transactions which were waiting for this
+		 * IO to complete. The barrier must be here so that changes
+		 * by journal_file_buffer() take effect before wake_up_bit()
+		 * does the waitqueue check.
+		 */
+		smp_mb();
 		wake_up_bit(&bh->b_state, BH_Unshadow);
 		JBUFFER_TRACE(jh, "brelse shadowed buffer");
 		__brelse(bh);
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index bd224ee..45905ff 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -435,9 +435,12 @@ int __log_space_left(journal_t *journal)
 int __log_start_commit(journal_t *journal, tid_t target)
 {
 	/*
-	 * Are we already doing a recent enough commit?
+	 * The only transaction we can possibly wait upon is the
+	 * currently running transaction (if it exists).  Otherwise,
+	 * the target tid must be an old one.
 	 */
-	if (!tid_geq(journal->j_commit_request, target)) {
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == target) {
 		/*
 		 * We want a new commit: OK, mark the request and wakup the
 		 * commit thread.  We do _not_ do the commit ourselves.
@@ -449,7 +452,14 @@ int __log_start_commit(journal_t *journal, tid_t target)
 			  journal->j_commit_sequence);
 		wake_up(&journal->j_wait_commit);
 		return 1;
-	}
+	} else if (!tid_geq(journal->j_commit_request, target))
+		/* This should never happen, but if it does, preserve
+		   the evidence before kjournald goes into a loop and
+		   increments j_commit_sequence beyond all recognition. */
+		WARN_ONCE(1, "jbd: bad log_start_commit: %u %u %u %u\n",
+		    journal->j_commit_request, journal->j_commit_sequence,
+		    target, journal->j_running_transaction ?
+		    journal->j_running_transaction->t_tid : 0);
 	return 0;
 }
 
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index a2a14cd..dd6efdb 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data, int size, struct list_head *frags)
 
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >= f->num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &= 0x7F;			/* Mark the group as broken */
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index d321bae..841f77c 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -665,6 +665,7 @@ out_free:
 
 out_release:
 	release_head(c, BASEHD);
+	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
 	if (last_reference)
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 57085e4..238ad15 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -474,7 +474,8 @@ failed:
  * @c: UBIFS file-system description object
  *
  * This function returns a pointer to the superblock node or a negative error
- * code.
+ * code. Note, the user of this function is responsible of kfree()'ing the
+ * returned superblock buffer.
  */
 struct ubifs_sb_node *ubifs_read_sb_node(struct ubifs_info *c)
 {
diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
index 02feb59..aec6689 100644
--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -283,7 +283,11 @@ int ubifs_shrinker(int nr, gfp_t gfp_mask)
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	if (nr == 0)
-		return clean_zn_cnt;
+		/*
+		 * Due to the way UBIFS updates the clean znode counter it may
+		 * temporarily be negative.
+		 */
+		return clean_zn_cnt >= 0 ? clean_zn_cnt : 1;
 
 	if (!clean_zn_cnt) {
 		/*
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 43f9d19..4ccc5d9 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1545,6 +1545,7 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		}
 		sup->leb_cnt = cpu_to_le32(c->leb_cnt);
 		err = ubifs_write_sb_node(c, sup);
+		kfree(sup);
 		if (err)
 			goto out;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 57adf2d..0a0245e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -712,16 +712,24 @@ xfs_inode_set_reclaim_tag(
 }
 
 void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
+__xfs_inode_clear_reclaim(
 	xfs_perag_t	*pag,
 	xfs_inode_t	*ip)
 {
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
 	pag->pag_ici_reclaimable--;
 }
 
+void
+__xfs_inode_clear_reclaim_tag(
+       xfs_mount_t     *mp,
+       xfs_perag_t     *pag,
+       xfs_inode_t     *ip)
+{
+       radix_tree_tag_clear(&pag->pag_ici_root,
+                       XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
+       __xfs_inode_clear_reclaim(pag, ip);
+}
+
 STATIC int
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 0b28c13..81dd3bc 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -48,6 +48,7 @@ int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct xfs_inode *ip);
+void __xfs_inode_clear_reclaim(struct xfs_perag *pag, struct xfs_inode *ip);
 void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 				struct xfs_inode *ip);
 
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index fd21160..788b72e 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -499,6 +499,7 @@ xfs_ireclaim(
 	write_lock(&pag->pag_ici_lock);
 	if (!radix_tree_delete(&pag->pag_ici_root, agino))
 		ASSERT(0);
+	__xfs_inode_clear_reclaim(pag, ip);
 	write_unlock(&pag->pag_ici_lock);
 	xfs_put_perag(mp, pag);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aae408..e07eaf8 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -605,6 +605,8 @@
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
+#define PCI_VENDOR_ID_MOBILITY_ELECTRONICS	0x14f2
+
 #define PCI_VENDOR_ID_CT		0x102c
 #define PCI_DEVICE_ID_CT_69000		0x00c0
 #define PCI_DEVICE_ID_CT_65545		0x00d8
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 632205c..4c3257d 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -88,12 +88,12 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 	unsigned ret;
 
 repeat:
-	ret = sl->sequence;
-	smp_rmb();
+	ret = ACCESS_ONCE(sl->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
+	smp_rmb();
 
 	return ret;
 }
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 493a0ef..b029c95 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3252,7 +3252,7 @@ int lock_is_held(struct lockdep_map *lock)
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e2ab064..b69a19a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -32,6 +32,8 @@ struct timekeeper {
 	cycle_t cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64	xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64	xtime_remainder;
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32	raw_interval;
 
@@ -62,7 +64,7 @@ struct timekeeper timekeeper;
 static void timekeeper_setup_internals(struct clocksource *clock)
 {
 	cycle_t interval;
-	u64 tmp;
+	u64 tmp, ntpinterval;
 
 	timekeeper.clock = clock;
 	clock->cycle_last = clock->read(clock);
@@ -70,6 +72,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
+	ntpinterval = tmp;
 	tmp += clock->mult/2;
 	do_div(tmp, clock->mult);
 	if (tmp == 0)
@@ -80,6 +83,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
@@ -771,7 +775,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ae311ce..e961e81 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2367,14 +2367,16 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		ftrace_match_records(parser->buffer, parser->idx, enable);
 	}
 
-	mutex_lock(&ftrace_lock);
-	if (ftrace_start_up && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftrace_lock);
-
 	trace_parser_put(parser);
 	kfree(iter);
 
+	if (file->f_mode & FMODE_WRITE) {
+		mutex_lock(&ftrace_lock);
+		if (ftrace_start_up && ftrace_enabled)
+			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+		mutex_unlock(&ftrace_lock);
+	}
+
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 619313e..507a22f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -144,7 +144,7 @@ static void init_shared_classes(void)
 
 #define HARDIRQ_ENTER()				\
 	local_irq_disable();			\
-	irq_enter();				\
+	__irq_enter();				\
 	WARN_ON(!in_irq());
 
 #define HARDIRQ_EXIT()				\
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e8d9544..3cdabc4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1026,10 +1026,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 */
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
-		return ERR_PTR(chg);
+		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
 		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5b069e4..c182586 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1369,9 +1369,12 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	++(*pos);
 
 	list_for_each_continue_rcu(n, &object_list) {
-		next_obj = list_entry(n, struct kmemleak_object, object_list);
-		if (get_object(next_obj))
+		struct kmemleak_object *obj =
+			list_entry(n, struct kmemleak_object, object_list);
+		if (get_object(obj)) {
+			next_obj = obj;
 			break;
+		}
 	}
 
 	put_object(prev_obj);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d42b021..a3bf950 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1848,6 +1848,7 @@ restart:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -1855,7 +1856,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 		page = __alloc_pages_high_priority(gfp_mask, order,
diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index b5674dc..7bbe81e 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -57,6 +57,14 @@ static ssize_t show_atmaddress(struct device *cdev,
 	return pos - buf;
 }
 
+static ssize_t show_atmindex(struct device *cdev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct atm_dev *adev = to_atm_dev(cdev);
+
+	return sprintf(buf, "%d\n", adev->number);
+}
+
 static ssize_t show_carrier(struct device *cdev,
 			    struct device_attribute *attr, char *buf)
 {
@@ -97,6 +105,7 @@ static ssize_t show_link_rate(struct device *cdev,
 
 static DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
 static DEVICE_ATTR(atmaddress, S_IRUGO, show_atmaddress, NULL);
+static DEVICE_ATTR(atmindex, S_IRUGO, show_atmindex, NULL);
 static DEVICE_ATTR(carrier, S_IRUGO, show_carrier, NULL);
 static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
 static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
@@ -104,6 +113,7 @@ static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
 static struct device_attribute *atm_attrs[] = {
 	&dev_attr_atmaddress,
 	&dev_attr_address,
+	&dev_attr_atmindex,
 	&dev_attr_carrier,
 	&dev_attr_type,
 	&dev_attr_link_rate,
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 35ae554..4233662 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -43,6 +43,8 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	int tcphoff, needs_ack;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
 	struct ipv6hdr *ip6h;
+#define DEFAULT_TOS_VALUE	0x0U
+	const __u8 tclass = DEFAULT_TOS_VALUE;
 	struct dst_entry *dst = NULL;
 	u8 proto;
 	struct flowi fl;
@@ -121,7 +123,7 @@ static void send_reset(struct net *net, struct sk_buff *oldskb)
 	skb_put(nskb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(nskb);
 	ip6h = ipv6_hdr(nskb);
-	ip6h->version = 6;
+	*(__be32 *)ip6h =  htonl(0x60000000 | (tclass << 20));
 	ip6h->hop_limit = dst_metric(dst, RTAX_HOPLIMIT);
 	ip6h->nexthdr = IPPROTO_TCP;
 	ipv6_addr_copy(&ip6h->saddr, &oip6h->daddr);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 624a548..6e96fa5 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -472,7 +472,7 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_queue *fq, struct net_device *dev)
 
 	/* all original skbs are linked into the NFCT_FRAG6_CB(head).orig */
 	fp = skb_shinfo(head)->frag_list;
-	if (NFCT_FRAG6_CB(fp)->orig == NULL)
+	if (fp && NFCT_FRAG6_CB(fp)->orig == NULL)
 		/* at above code, head skb is divided into two skbs. */
 		fp = fp->next;
 
@@ -598,12 +598,6 @@ struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user)
 	hdr = ipv6_hdr(clone);
 	fhdr = (struct frag_hdr *)skb_transport_header(clone);
 
-	if (!(fhdr->frag_off & htons(0xFFF9))) {
-		pr_debug("Invalid fragment offset\n");
-		/* It is not a fragmented frame */
-		goto ret_orig;
-	}
-
 	if (atomic_read(&nf_init_frags.mem) > nf_init_frags.high_thresh)
 		nf_ct_frag6_evictor();
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 74ce892..5ec6374 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 60d1653..3351a31 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1366,7 +1366,6 @@ static void xs_tcp_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 		/* The server initiated a shutdown of the socket */
 		xprt_force_disconnect(xprt);
-	case TCP_SYN_SENT:
 		xprt->connect_cookie++;
 	case TCP_CLOSING:
 		/*
@@ -1813,6 +1812,7 @@ static void xs_tcp_reuse_connection(struct rpc_xprt *xprt, struct sock_xprt *tra
 static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	int ret = -ENOTCONN;
 
 	if (!transport->inet) {
 		struct sock *sk = sock->sk;
@@ -1844,12 +1844,22 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	}
 
 	if (!xprt_bound(xprt))
-		return -ENOTCONN;
+		goto out;
 
 	/* Tell the socket layer to start connecting... */
 	xprt->stat.connect_count++;
 	xprt->stat.connect_start = jiffies;
-	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
+	ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
+	switch (ret) {
+	case 0:
+	case -EINPROGRESS:
+		/* SYN_SENT! */
+		xprt->connect_cookie++;
+		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
+			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
+	}
+out:
+	return ret;
 }
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7cb0d64..eb1674f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3078,12 +3078,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 97bd8fd..64f966c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12824,6 +12824,7 @@ static struct snd_pci_quirk alc268_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer Aspire One",
 						ALC268_ACER_ASPIRE_ONE),
 	SND_PCI_QUIRK(0x1028, 0x0253, "Dell OEM", ALC268_DELL),
+	SND_PCI_QUIRK(0x1028, 0x02b0, "Dell Inspiron 910", ALC268_AUTO),
 	SND_PCI_QUIRK_MASK(0x1028, 0xfff0, 0x02b0,
 			"Dell Inspiron Mini9/Vostro A90", ALC268_DELL),
 	/* almost compatible with toshiba but with optional digital outs;
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 0d3dd06..2f0c668 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1608,7 +1608,7 @@ static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
 				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
-				"Dell Studio 1558", STAC_DELL_M6_BOTH),
+				"Dell Studio 1558", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };
 
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 940f2ea..0601a64 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -639,17 +639,17 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
 static const struct snd_soc_dapm_route lineout1_diff_routes[] = {
 	{ "LINEOUT1 Mixer", "IN1L Switch", "IN1L PGA" },
 	{ "LINEOUT1 Mixer", "IN1R Switch", "IN1R PGA" },
-	{ "LINEOUT1 Mixer", "Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1 Mixer", "Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1 Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout1_se_routes[] = {
-	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT1N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT1N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1N Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1P Mixer" },
@@ -658,17 +658,17 @@ static const struct snd_soc_dapm_route lineout1_se_routes[] = {
 static const struct snd_soc_dapm_route lineout2_diff_routes[] = {
 	{ "LINEOUT2 Mixer", "IN2L Switch", "IN2L PGA" },
 	{ "LINEOUT2 Mixer", "IN2R Switch", "IN2R PGA" },
-	{ "LINEOUT2 Mixer", "Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2 Mixer", "Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2 Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout2_se_routes[] = {
-	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT2N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT2N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2N Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2P Mixer" },
@@ -686,17 +686,21 @@ int wm_hubs_add_analogue_controls(struct snd_soc_codec *codec)
 	snd_soc_update_bits(codec, WM8993_RIGHT_LINE_INPUT_3_4_VOLUME,
 			    WM8993_IN2_VU, WM8993_IN2_VU);
 
+	snd_soc_update_bits(codec, WM8993_SPEAKER_VOLUME_LEFT,
+			    WM8993_SPKOUT_VU, WM8993_SPKOUT_VU);
 	snd_soc_update_bits(codec, WM8993_SPEAKER_VOLUME_RIGHT,
 			    WM8993_SPKOUT_VU, WM8993_SPKOUT_VU);
 
 	snd_soc_update_bits(codec, WM8993_LEFT_OUTPUT_VOLUME,
-			    WM8993_HPOUT1L_ZC, WM8993_HPOUT1L_ZC);
+			    WM8993_HPOUT1_VU | WM8993_HPOUT1L_ZC,
+			    WM8993_HPOUT1_VU | WM8993_HPOUT1L_ZC);
 	snd_soc_update_bits(codec, WM8993_RIGHT_OUTPUT_VOLUME,
 			    WM8993_HPOUT1_VU | WM8993_HPOUT1R_ZC,
 			    WM8993_HPOUT1_VU | WM8993_HPOUT1R_ZC);
 
 	snd_soc_update_bits(codec, WM8993_LEFT_OPGA_VOLUME,
-			    WM8993_MIXOUTL_ZC, WM8993_MIXOUTL_ZC);
+			    WM8993_MIXOUTL_ZC | WM8993_MIXOUT_VU,
+			    WM8993_MIXOUTL_ZC | WM8993_MIXOUT_VU);
 	snd_soc_update_bits(codec, WM8993_RIGHT_OPGA_VOLUME,
 			    WM8993_MIXOUTR_ZC | WM8993_MIXOUT_VU,
 			    WM8993_MIXOUTR_ZC | WM8993_MIXOUT_VU);
