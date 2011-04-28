Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab1D1PoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:44:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49609 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D1PnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:22 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 6/6] staging: tidspbridge: decouple mmu functions from regular code
Date: Thu, 28 Apr 2011 10:31:52 -0500
Message-Id: <1304004712-8487-7-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Guzman Lugo <x0095840@ti.com>

Create a new dsp mmu file containing the functions needed to
interact with iommu block (map, unmap, mmufault handling, etc).

While at it, give meaningful names to map and unmap functions and
remove them from bridge's pointer-to-func structure.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/core/_deh.h            |    3 -
 drivers/staging/tidspbridge/core/dsp_mmu.c         |  396 ++++++++++++++++++++
 drivers/staging/tidspbridge/core/tiomap3430.c      |  271 +-------------
 drivers/staging/tidspbridge/core/ue_deh.c          |   87 +-----
 .../tidspbridge/include/dspbridge/dsp_mmu.h        |   33 ++
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 ---
 drivers/staging/tidspbridge/pmgr/dev.c             |    2 -
 drivers/staging/tidspbridge/rmgr/proc.c            |   13 +-
 9 files changed, 442 insertions(+), 409 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/core/dsp_mmu.c
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp_mmu.h

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 0bab58b..a12d9af 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_TIDSPBRIDGE)	+= bridgedriver.o
 
 libgen = gen/gh.o gen/uuidutil.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
-		core/tiomap3430_pwr.o core/tiomap_io.o \
+		core/tiomap3430_pwr.o core/tiomap_io.o core/dsp_mmu.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
 		pmgr/cmm.o pmgr/dbll.o
diff --git a/drivers/staging/tidspbridge/core/_deh.h b/drivers/staging/tidspbridge/core/_deh.h
index 85543cf..5cc720a 100644
--- a/drivers/staging/tidspbridge/core/_deh.h
+++ b/drivers/staging/tidspbridge/core/_deh.h
@@ -27,9 +27,6 @@
 struct deh_mgr {
 	struct bridge_dev_context *bridge_context;	/* Bridge context. */
 	struct ntfy_object *ntfy_obj;	/* NTFY object */
-
-	/* MMU Fault DPC */
-	struct tasklet_struct dpc_tasklet;
 };
 
 int mmu_fault_isr(struct iommu *mmu, u32 da, u32 iommu_errs, void *priv);
diff --git a/drivers/staging/tidspbridge/core/dsp_mmu.c b/drivers/staging/tidspbridge/core/dsp_mmu.c
new file mode 100644
index 0000000..94bb29d
--- /dev/null
+++ b/drivers/staging/tidspbridge/core/dsp_mmu.c
@@ -0,0 +1,396 @@
+/*
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/errno.h>
+#include <dspbridge/dsp_mmu.h>
+#include <dspbridge/dev.h>
+#include <dspbridge/dspdeh.h>
+#include "_tiomap.h"
+#include "_tiomap_pwr.h"
+#include "_deh.h"
+
+#ifndef ARCH_HAS_SG_CHAIN
+static struct gen_pool *dmm_pool;
+
+static inline u32 dsptlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
+								u32 pgsz)
+{
+	memset(e, 0, sizeof(*e));
+
+	e->da		= da;
+	e->pa		= pa;
+	e->valid	= 1;
+	e->pgsz		= MMU_CAM_PGSZ_4K;
+	e->pgsz		= pgsz & MMU_CAM_PGSZ_MASK;
+	e->endian	= MMU_RAM_ENDIAN_LITTLE;
+	e->elsz		= MMU_RAM_ELSZ_32;
+	e->mixed	= 0;
+
+	return iopgsz_to_bytes(e->pgsz);
+}
+#endif /* !ARCH_HAS_SG_CHAIN */
+
+/**
+ * user_va2_pa() - get physical address from userspace address.
+ * @mm:		mm_struct pointer of the process.
+ * @address:	User space virtual address.
+ */
+static u32 user_va2_pa(struct mm_struct *mm, u32 address)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+
+	pgd = pgd_offset(mm, address);
+	if (!(pgd_none(*pgd) || pgd_bad(*pgd))) {
+		pmd = pmd_offset(pgd, address);
+		if (!(pmd_none(*pmd) || pmd_bad(*pmd))) {
+			ptep = pte_offset_map(pmd, address);
+			if (ptep) {
+				pte = *ptep;
+				if (pte_present(pte))
+					return pte & PAGE_MASK;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * get_io_pages() - pin and get pages of io user's buffer.
+ * @mm:		mm_struct pointer of the process.
+ * @uva:	Virtual user space address.
+ * @pages:	Pages to be pined.
+ * @usr_pgs:	struct page array pointer where the user pages will be stored
+ */
+static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
+						struct page **usr_pgs)
+{
+	struct page *pg;
+	u32 pa;
+	int i;
+
+	for (i = 0; i < pages; i++) {
+		pa = user_va2_pa(mm, uva);
+
+		if (!pfn_valid(__phys_to_pfn(pa)))
+			break;
+
+		pg = phys_to_page(pa);
+		usr_pgs[i] = pg;
+		get_page(pg);
+	}
+	return i;
+}
+
+/**
+ * user_to_dsp_map() - maps user to dsp virtual address.
+ * @dev_ctx:	Pointer to device context handle.
+ * @uva:	User space virtual address.
+ * @da:		DSP address.
+ * @size:	Buffer size to map.
+ * @usr_pgs:	Struct page array pointer where the user pages will be stored.
+ */
+u32 user_to_dsp_map(struct bridge_dev_context *dev_ctx, u32 uva, u32 da,
+				u32 size, struct page **usr_pgs)
+
+{
+	int res, w;
+	unsigned pages, i;
+	struct iommu *mmu = dev_ctx->dsp_mmu;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+#ifndef ARCH_HAS_SG_CHAIN
+	u32 pa, addr;
+	struct iotlb_entry e;
+#else
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+#endif
+
+	if (!size || !usr_pgs)
+		return -EINVAL;
+
+	pages = size / PG_SIZE4K;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, uva);
+	while (vma && (uva + size > vma->vm_end))
+		vma = find_vma(mm, vma->vm_end + 1);
+
+	if (!vma) {
+		pr_err("%s: Failed to get VMA region for 0x%x (%d)\n",
+						__func__, uva, size);
+		up_read(&mm->mmap_sem);
+		return -EINVAL;
+	}
+
+	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
+		w = 1;
+
+	if (vma->vm_flags & VM_IO)
+		i = get_io_pages(mm, uva, pages, usr_pgs);
+	else
+		i = get_user_pages(current, mm, uva, pages, w, 1,
+							usr_pgs, NULL);
+
+	up_read(&mm->mmap_sem);
+
+	if (i < 0)
+		return i;
+
+	if (i < pages) {
+		res = -EFAULT;
+		goto err_pages;
+	}
+
+#ifndef ARCH_HAS_SG_CHAIN
+	da = gen_pool_alloc(dmm_pool, size);
+	if (!da) {
+		res = -ENOMEM;
+		goto err_pages;
+	}
+
+	wake_dsp(dev_ctx, NULL);
+
+	for (i = 0, addr = da; i < pages; i++, addr += PAGE_SIZE) {
+		pa = page_to_phys(usr_pgs[i]);
+		dsptlb_init_entry(&e, addr, pa, MMU_CAM_PGSZ_4K);
+		iopgtable_store_entry(mmu, &e);
+	}
+
+	return da;
+#else
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt) {
+		res = -ENOMEM;
+		goto err_pages;
+	}
+
+	res = sg_alloc_table(sgt, pages, GFP_KERNEL);
+
+	if (res < 0)
+		goto err_sg;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
+
+	wake_dsp(dev_ctx, NULL);
+
+	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+
+	if (!IS_ERR_VALUE(da))
+		return da;
+	res = (int)da;
+
+	sg_free_table(sgt);
+err_sg:
+	kfree(sgt);
+	i = pages;
+#endif /* ARCH_HAS_SG_CHAIN */
+
+err_pages:
+	while (i--)
+		put_page(usr_pgs[i]);
+	return res;
+}
+
+/**
+ * user_to_dsp_unmap() - unmap DSP virtual buffer.
+ * @dev_ctx:	Pointer to device context handle.
+ * @da:		DSP address.
+ * @size:	Buffer size to unmap.
+ * @usr_pgs:	Struct page array pointer where the user pages are stored.
+ */
+int user_to_dsp_unmap(struct bridge_dev_context *dev_ctx, u32 da,
+				 size_t size, struct page **usr_pgs)
+{
+	unsigned i = 0;
+
+#ifndef ARCH_HAS_SG_CHAIN
+	gen_pool_free(dmm_pool, da, size);
+
+	wake_dsp(dev_ctx, NULL);
+
+	while (size > 0) {
+		size_t bytes;
+		bytes = iopgtable_clear_entry(dev_ctx->dsp_mmu, da);
+		size -= bytes;
+		da += bytes;
+		put_page(usr_pgs[i++]);
+	}
+#else
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+
+	wake_dsp(dev_ctx, NULL);
+
+	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
+	if (!sgt)
+		return -EFAULT;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		put_page(sg_page(sg));
+
+	sg_free_table(sgt);
+	kfree(sgt);
+#endif /* ARCH_HAS_SG_CHAIN */
+
+	return 0;
+}
+
+#ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
+static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
+{
+	void *dummy_addr;
+	u32 fa, tmp;
+	struct iotlb_entry e;
+	struct iommu *mmu = dev_context->dsp_mmu;
+	dummy_addr = (void *)__get_free_page(GFP_ATOMIC);
+
+	/*
+	 * Before acking the MMU fault, let's make sure MMU can only
+	 * access entry #0. Then add a new entry so that the DSP OS
+	 * can continue in order to dump the stack.
+	 */
+	tmp = iommu_read_reg(mmu, MMU_CNTL);
+	tmp &= ~MMU_CNTL_TWL_EN;
+	iommu_write_reg(mmu, tmp, MMU_CNTL);
+	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
+	e.da = fa & PAGE_MASK;
+	e.pa = virt_to_phys(dummy_addr);
+	e.valid = 1;
+	e.prsvd = 1;
+	e.pgsz = IOVMF_PGSZ_4K & MMU_CAM_PGSZ_MASK;
+	e.endian = MMU_RAM_ENDIAN_LITTLE;
+	e.elsz = MMU_RAM_ELSZ_32;
+	e.mixed = 0;
+
+	load_iotlb_entry(dev_context->dsp_mmu, &e);
+
+	dsp_clk_enable(DSP_CLK_GPT8);
+
+	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
+
+	/* Clear MMU interrupt */
+	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
+	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
+
+	dump_dsp_stack(dev_context);
+	dsp_clk_disable(DSP_CLK_GPT8);
+
+	iopgtable_clear_entry(mmu, fa);
+	free_page((unsigned long)dummy_addr);
+}
+#endif
+
+static void mmufault_tasklet(unsigned long data)
+{
+	struct iommu *mmu = (struct iommu *)data;
+	struct bridge_dev_context *dev_ctx;
+	struct deh_mgr *deh;
+	u32 fa;
+
+	dev_get_deh_mgr(dev_get_first(), &deh);
+	dev_get_bridge_context(dev_get_first(), &dev_ctx);
+
+	if (!deh || !dev_ctx)
+		return;
+
+	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
+
+#ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
+	print_dsp_trace_buffer(dev_ctx);
+	dump_dl_modules(dev_ctx);
+	mmu_fault_print_stack(dev_ctx);
+#endif
+
+	bridge_deh_notify(deh, DSP_MMUFAULT, fa);
+}
+
+static struct tasklet_struct mmufault_tsk;
+
+int mmufault_cb(struct iommu *mmu, u32 da, u32 iommu_errs, void *priv)
+{
+	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
+	tasklet_schedule(&mmufault_tsk);
+
+	return 0;
+}
+
+/**
+ * dsp_mmu_init() - initialize iommu module
+ *
+ * This function initializes iommu module, it returns a struct iommu
+ * handle to be used for dsp maps.
+ */
+struct iommu *dsp_mmu_init()
+{
+	struct iommu *mmu;
+
+	mmu = iommu_get("iva2");
+	if (IS_ERR(mmu))
+		return mmu;
+
+	tasklet_init(&mmufault_tsk, mmufault_tasklet, (unsigned long)mmu);
+	mmu->isr = mmufault_cb;
+
+#ifndef ARCH_HAS_SG_CHAIN
+	if (dmm_pool) {
+		gen_pool_destroy(dmm_pool);
+		dmm_pool = NULL;
+	}
+
+	dmm_pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!dmm_pool) {
+		iommu_put(mmu);
+		return ERR_PTR(-ENOMEM);
+	} else {
+		struct bridge_dev_context *dev_ctx;
+		struct shm_segs *sm_sg;
+		u32 start;
+
+		dev_get_bridge_context(dev_get_first(), &dev_ctx);
+		if (!dev_ctx)
+			return ERR_PTR(-EFAULT);
+
+		sm_sg = &dev_ctx->sh_s;
+		start = sm_sg->seg1_da + sm_sg->seg1_size;
+		gen_pool_add(dmm_pool, start, CONFIG_TIDSPBRIDGE_DMM_SIZE, -1);
+	}
+#endif
+
+	return mmu;
+}
+
+/**
+ * dsp_mmu_exit() - destroy dsp mmu module
+ * @mmu:	Pointer to iommu handle.
+ *
+ * This function destroys dsp mmu module.
+ *
+ */
+void dsp_mmu_exit(struct iommu *mmu)
+{
+	if (mmu)
+		iommu_put(mmu);
+	tasklet_kill(&mmufault_tsk);
+
+#ifndef ARCH_HAS_SG_CHAIN
+	if (dmm_pool) {
+		gen_pool_destroy(dmm_pool);
+		dmm_pool = NULL;
+	}
+#endif
+}
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 8b77837..cc4bfbe 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -23,7 +23,7 @@
 #include <dspbridge/host_os.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
-#include <linux/genalloc.h>
+#include <dspbridge/dsp_mmu.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
@@ -106,12 +106,6 @@ static int bridge_brd_mem_copy(struct bridge_dev_context *dev_ctxt,
 static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 				    u8 *host_buff, u32 dsp_addr,
 				    u32 ul_num_bytes, u32 mem_type);
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
-				  u32 ul_mpu_addr, u32 virt_addr,
-				  u32 ul_num_bytes, struct page **mapped_pages);
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctxt,
-				     u32 da, size_t size,
-				     struct page **usr_pgs);
 static int bridge_dev_create(struct bridge_dev_context
 					**dev_cntxt,
 					struct dev_object *hdev_obj,
@@ -119,9 +113,6 @@ static int bridge_dev_create(struct bridge_dev_context
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
 				  u32 dw_cmd, void *pargs);
 static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt);
-static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
-						struct page **usr_pgs);
-static u32 user_va2_pa(struct mm_struct *mm, u32 address);
 bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
 
 /*  ----------------------------------- Globals */
@@ -145,8 +136,6 @@ static struct bridge_drv_interface drv_interface_fxns = {
 	bridge_brd_set_state,
 	bridge_brd_mem_copy,
 	bridge_brd_mem_write,
-	bridge_brd_mem_map,
-	bridge_brd_mem_un_map,
 	/* The following CHNL functions are provided by chnl_io.lib: */
 	bridge_chnl_create,
 	bridge_chnl_destroy,
@@ -180,27 +169,6 @@ static struct notifier_block dsp_mbox_notifier = {
 	.notifier_call = io_mbox_msg,
 };
 
-#ifndef ARCH_HAS_SG_CHAIN
-static struct gen_pool *dmm_pool;
-
-static inline u32 dsptlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
-								u32 pgsz)
-{
-	memset(e, 0, sizeof(*e));
-
-	e->da		= da;
-	e->pa		= pa;
-	e->valid	= 1;
-	e->pgsz		= MMU_CAM_PGSZ_4K;
-	e->pgsz		= pgsz & MMU_CAM_PGSZ_MASK;
-	e->endian	= MMU_RAM_ENDIAN_LITTLE;
-	e->elsz		= MMU_RAM_ELSZ_32;
-	e->mixed	= 0;
-
-	return iopgsz_to_bytes(e->pgsz);
-}
-#endif /* !ARCH_HAS_SG_CHAIN */
-
 /*
  *  ======== bridge_drv_entry ========
  *  purpose:
@@ -406,38 +374,16 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 	mmu = dev_context->dsp_mmu;
 	if (mmu)
-		iommu_put(mmu);
+		dsp_mmu_exit(mmu);
 
-	mmu = iommu_get("iva2");
+	mmu = dsp_mmu_init();
 	if (IS_ERR(mmu)) {
 		dev_err(bridge, "iommu_get failed!\n");
 		dev_context->dsp_mmu = NULL;
 		return PTR_ERR(mmu);
 	}
-#ifndef ARCH_HAS_SG_CHAIN
-	else {
-		u32 start;
-
-		if (dmm_pool) {
-			gen_pool_destroy(dmm_pool);
-			dmm_pool = NULL;
-		}
-
-		dmm_pool = gen_pool_create(PAGE_SHIFT, -1);
-		if (!dmm_pool) {
-			iommu_put(mmu);
-			dev_context->dsp_mmu = NULL;
-			return -ENOMEM;
-		}
-
-		sm_sg = &dev_context->sh_s;
-		start = sm_sg->seg1_da + sm_sg->seg1_size;
-		gen_pool_add(dmm_pool, start, CONFIG_TIDSPBRIDGE_DMM_SIZE, -1);
-	}
-#endif
 
 	dev_context->dsp_mmu = mmu;
-	mmu->isr = mmu_fault_isr;
 	sm_sg = &dev_context->sh_s;
 	/* Set valid range to map shared memory */
 	status = iommu_set_da_range(mmu, sm_sg->seg0_da,
@@ -702,14 +648,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 
 		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg1_da);
 		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg0_da);
-		iommu_put(dev_context->dsp_mmu);
+		dsp_mmu_exit(dev_context->dsp_mmu);
 		dev_context->dsp_mmu = NULL;
-#ifndef ARCH_HAS_SG_CHAIN
-		if (dmm_pool) {
-			gen_pool_destroy(dmm_pool);
-			dmm_pool = NULL;
-		}
-#endif
 	}
 
 	/* Reset IVA IOMMU */
@@ -1018,209 +958,6 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 }
 
 /*
- *  ======== bridge_brd_mem_map ========
- *      This function maps MPU buffer to the DSP address space. It performs
- *  linear to physical address translation if required. It translates each
- *  page since linear addresses can be physically non-contiguous
- *  All address & size arguments are assumed to be page aligned (in proc.c)
- *
- *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
- */
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
-			u32 uva, u32 da, u32 size, struct page **usr_pgs)
-
-{
-	int res, w;
-	unsigned pages, i;
-	struct iommu *mmu = dev_ctx->dsp_mmu;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
-#ifndef ARCH_HAS_SG_CHAIN
-	u32 pa, addr;
-	struct iotlb_entry e;
-#else
-	struct sg_table *sgt;
-	struct scatterlist *sg;
-#endif
-
-	if (!size || !usr_pgs)
-		return -EINVAL;
-
-	pages = size / PG_SIZE4K;
-
-	down_read(&mm->mmap_sem);
-	vma = find_vma(mm, uva);
-	while (vma && (uva + size > vma->vm_end))
-		vma = find_vma(mm, vma->vm_end + 1);
-
-	if (!vma) {
-		pr_err("%s: Failed to get VMA region for 0x%x (%d)\n",
-						__func__, uva, size);
-		up_read(&mm->mmap_sem);
-		return -EINVAL;
-	}
-	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
-		w = 1;
-
-	if (vma->vm_flags & VM_IO)
-		i = get_io_pages(mm, uva, pages, usr_pgs);
-	else
-		i = get_user_pages(current, mm, uva, pages, w, 1,
-							usr_pgs, NULL);
-	up_read(&mm->mmap_sem);
-
-	if (i < 0)
-		return i;
-
-	if (i < pages) {
-		res = -EFAULT;
-		goto err_pages;
-	}
-
-#ifndef ARCH_HAS_SG_CHAIN
-	da = gen_pool_alloc(dmm_pool, size);
-	if (!da) {
-		res = -ENOMEM;
-		goto err_pages;
-	}
-
-	wake_dsp(dev_ctx, NULL);
-
-	for (i = 0, addr = da; i < pages; i++, addr += PAGE_SIZE) {
-		pa = page_to_phys(usr_pgs[i]);
-		dsptlb_init_entry(&e, addr, pa, MMU_CAM_PGSZ_4K);
-		iopgtable_store_entry(mmu, &e);
-	}
-
-	return da;
-#else
-	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
-	if (!sgt) {
-		res = -ENOMEM;
-		goto err_pages;
-	}
-
-	res = sg_alloc_table(sgt, pages, GFP_KERNEL);
-
-	if (res < 0)
-		goto err_sg;
-
-	for_each_sg(sgt->sgl, sg, sgt->nents, i)
-		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
-
-	wake_dsp(dev_ctx, NULL);
-
-	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
-
-	if (!IS_ERR_VALUE(da))
-		return da;
-	res = (int)da;
-
-	sg_free_table(sgt);
-err_sg:
-	kfree(sgt);
-	i = pages;
-#endif /* ARCH_HAS_SG_CHAIN */
-err_pages:
-	while (i--)
-		put_page(usr_pgs[i]);
-	return res;
-}
-
-/*
- *  ======== bridge_brd_mem_un_map ========
- *      Invalidate the PTEs for the DSP VA block to be unmapped.
- *
- *      PTEs of a mapped memory block are contiguous in any page table
- *      So, instead of looking up the PTE address for every 4K block,
- *      we clear consecutive PTEs until we unmap all the bytes
- */
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da,
-				 size_t size, struct page **usr_pgs)
-{
-	unsigned i = 0;
-#ifndef ARCH_HAS_SG_CHAIN
-	gen_pool_free(dmm_pool, da, size);
-
-	wake_dsp(dev_ctx, NULL);
-
-	while (size > 0) {
-		size_t bytes;
-		bytes = iopgtable_clear_entry(dev_ctx->dsp_mmu, da);
-		size -= bytes;
-		da += bytes;
-		put_page(usr_pgs[i++]);
-	}
-#else
-	struct sg_table *sgt;
-	struct scatterlist *sg;
-
-	wake_dsp(dev_ctx, NULL);
-
-	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
-	if (!sgt)
-		return -EFAULT;
-
-	for_each_sg(sgt->sgl, sg, sgt->nents, i)
-		put_page(sg_page(sg));
-
-	sg_free_table(sgt);
-	kfree(sgt);
-#endif /* ARCH_HAS_SG_CHAIN */
-
-	return 0;
-}
-
-
-static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
-						struct page **usr_pgs)
-{
-	u32 pa;
-	int i;
-	struct page *pg;
-
-	for (i = 0; i < pages; i++) {
-		pa = user_va2_pa(mm, uva);
-
-		if (!pfn_valid(__phys_to_pfn(pa)))
-			break;
-
-		pg = PHYS_TO_PAGE(pa);
-		usr_pgs[i] = pg;
-		get_page(pg);
-	}
-	return i;
-}
-
-/*
- *  ======== user_va2_pa ========
- *  Purpose:
- *      This function walks through the page tables to convert a userland
- *      virtual address to physical address
- */
-static u32 user_va2_pa(struct mm_struct *mm, u32 address)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-
-	pgd = pgd_offset(mm, address);
-	if (!(pgd_none(*pgd) || pgd_bad(*pgd))) {
-		pmd = pmd_offset(pgd, address);
-		if (!(pmd_none(*pmd) || pmd_bad(*pmd))) {
-			ptep = pte_offset_map(pmd, address);
-			if (ptep) {
-				pte = *ptep;
-				if (pte_present(pte))
-					return pte & PAGE_MASK;
-			}
-		}
-	}
-
-	return 0;
-}
-
-/*
  *  ======== wait_for_start ========
  *      Wait for the singal from DSP that it has started, or time out.
  */
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 317e7f6..1f1c084 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -31,33 +31,6 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/wdt.h>
 
-#define MMU_CNTL_TWL_EN		(1 << 2)
-
-static void mmu_fault_dpc(unsigned long data)
-{
-	struct deh_mgr *deh = (void *)data;
-
-	if (!deh)
-		return;
-
-	bridge_deh_notify(deh, DSP_MMUFAULT, 0);
-}
-
-int mmu_fault_isr(struct iommu *mmu, u32 da, u32 iommu_errs, void *priv)
-{
-	struct deh_mgr *deh;
-
-	dev_get_deh_mgr(dev_get_first(), &deh);
-
-	if (!deh)
-		return -EPERM;
-
-	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
-	tasklet_schedule(&deh->dpc_tasklet);
-
-	return 0;
-}
-
 int bridge_deh_create(struct deh_mgr **ret_deh,
 		struct dev_object *hdev_obj)
 {
@@ -85,9 +58,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh,
 	}
 	ntfy_init(deh->ntfy_obj);
 
-	/* Create a MMUfault DPC */
-	tasklet_init(&deh->dpc_tasklet, mmu_fault_dpc, (u32) deh);
-
 	/* Fill in context structure */
 	deh->bridge_context = hbridge_context;
 
@@ -111,9 +81,6 @@ int bridge_deh_destroy(struct deh_mgr *deh)
 		kfree(deh->ntfy_obj);
 	}
 
-	/* Free DPC object */
-	tasklet_kill(&deh->dpc_tasklet);
-
 	/* Deallocate the DEH manager object */
 	kfree(deh);
 
@@ -134,51 +101,6 @@ int bridge_deh_register_notify(struct deh_mgr *deh, u32 event_mask,
 		return ntfy_unregister(deh->ntfy_obj, hnotification);
 }
 
-#ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
-static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
-{
-	void *dummy_addr;
-	u32 fa, tmp;
-	struct iotlb_entry e;
-	struct iommu *mmu = dev_context->dsp_mmu;
-	dummy_addr = (void *)__get_free_page(GFP_ATOMIC);
-
-	/*
-	 * Before acking the MMU fault, let's make sure MMU can only
-	 * access entry #0. Then add a new entry so that the DSP OS
-	 * can continue in order to dump the stack.
-	 */
-	tmp = iommu_read_reg(mmu, MMU_CNTL);
-	tmp &= ~MMU_CNTL_TWL_EN;
-	iommu_write_reg(mmu, tmp, MMU_CNTL);
-	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
-	e.da = fa & PAGE_MASK;
-	e.pa = virt_to_phys(dummy_addr);
-	e.valid = 1;
-	e.prsvd = 1;
-	e.pgsz = IOVMF_PGSZ_4K & MMU_CAM_PGSZ_MASK;
-	e.endian = MMU_RAM_ENDIAN_LITTLE;
-	e.elsz = MMU_RAM_ELSZ_32;
-	e.mixed = 0;
-
-	load_iotlb_entry(dev_context->dsp_mmu, &e);
-
-	dsp_clk_enable(DSP_CLK_GPT8);
-
-	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
-
-	/* Clear MMU interrupt */
-	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
-	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
-
-	dump_dsp_stack(dev_context);
-	dsp_clk_disable(DSP_CLK_GPT8);
-
-	iopgtable_clear_entry(mmu, fa);
-	free_page((unsigned long)dummy_addr);
-}
-#endif
-
 static inline const char *event_to_string(int event)
 {
 	switch (event) {
@@ -194,7 +116,6 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 {
 	struct bridge_dev_context *dev_context;
 	const char *str = event_to_string(event);
-	u32 fa;
 
 	if (!deh)
 		return;
@@ -212,13 +133,7 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 #endif
 		break;
 	case DSP_MMUFAULT:
-		fa = iommu_read_reg(dev_context->dsp_mmu, MMU_FAULT_AD);
-		dev_err(bridge, "%s: %s, addr=0x%x", __func__, str, fa);
-#ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
-		print_dsp_trace_buffer(dev_context);
-		dump_dl_modules(dev_context);
-		mmu_fault_print_stack(dev_context);
-#endif
+		dev_err(bridge, "%s: %s, addr=0x%x", __func__, str, info);
 		break;
 	default:
 		dev_err(bridge, "%s: %s", __func__, str);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dsp_mmu.h b/drivers/staging/tidspbridge/include/dspbridge/dsp_mmu.h
new file mode 100644
index 0000000..ff70c9d
--- /dev/null
+++ b/drivers/staging/tidspbridge/include/dspbridge/dsp_mmu.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#ifndef _DSP_MMU_
+#define _DSP_MMU_
+
+#include <linux/string.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/genalloc.h>
+
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
+
+struct bridge_dev_context;
+
+u32 user_to_dsp_map(struct bridge_dev_context *dev_ctx, u32 uva, u32 da,
+			u32 size, struct page **usr_pgs);
+int user_to_dsp_unmap(struct bridge_dev_context *dev_ctx, u32 da, size_t size,
+			struct page **usr_pgs);
+struct iommu *dsp_mmu_init(void);
+void dsp_mmu_exit(struct iommu *mmu);
+
+#endif /* _DSP_MMU_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index e052bba..fb1aa89 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -156,48 +156,6 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
 				       u32 mem_type);
 
 /*
- *  ======== bridge_brd_mem_map ========
- *  Purpose:
- *      Map a MPU memory region to a DSP/IVA memory space
- *  Parameters:
- *      dev_ctxt:    Handle to Bridge driver defined device info.
- *      ul_mpu_addr:      MPU memory region start address.
- *      virt_addr:      DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to map.
- *      map_attrs:       Mapping attributes (e.g. endianness).
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      dev_ctxt != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memmap) (struct bridge_dev_context
-				     * dev_ctxt, u32 ul_mpu_addr,
-				     u32 virt_addr, u32 ul_num_bytes,
-				     struct page **mapped_pages);
-
-/*
- *  ======== bridge_brd_mem_un_map ========
- *  Purpose:
- *      UnMap an MPU memory region from DSP/IVA memory space
- *  Parameters:
- *      dev_ctxt:    Handle to Bridge driver defined device info.
- *      virt_addr:      DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to unmap.
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      dev_ctxt != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
-				       * dev_ctxt,
-				       u32 da, size_t size,
-				       struct page **usr_pgs);
-
-/*
  *  ======== bridge_brd_stop ========
  *  Purpose:
  *      Bring board to the BRD_STOPPED state.
@@ -987,8 +945,6 @@ struct bridge_drv_interface {
 	fxn_brd_setstate brd_set_state;	/* Sets the Board State */
 	fxn_brd_memcopy brd_mem_copy;	/* Copies DSP Memory */
 	fxn_brd_memwrite brd_mem_write;	/* Write DSP Memory w/o halt */
-	fxn_brd_memmap brd_mem_map;	/* Maps MPU mem to DSP mem */
-	fxn_brd_memunmap brd_mem_un_map;	/* Unmaps MPU mem to DSP mem */
 	fxn_chnl_create chnl_create;	/* Create channel manager. */
 	fxn_chnl_destroy chnl_destroy;	/* Destroy channel manager. */
 	fxn_chnl_open chnl_open;	/* Create a new channel. */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index d8f4079..2cdfc92 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -1038,8 +1038,6 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 		STORE_FXN(fxn_brd_setstate, brd_set_state);
 		STORE_FXN(fxn_brd_memcopy, brd_mem_copy);
 		STORE_FXN(fxn_brd_memwrite, brd_mem_write);
-		STORE_FXN(fxn_brd_memmap, brd_mem_map);
-		STORE_FXN(fxn_brd_memunmap, brd_mem_un_map);
 		STORE_FXN(fxn_chnl_create, chnl_create);
 		STORE_FXN(fxn_chnl_destroy, chnl_destroy);
 		STORE_FXN(fxn_chnl_open, chnl_open);
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index c53e60c..2623cdd 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -21,6 +21,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <dspbridge/host_os.h>
+#include <dspbridge/dsp_mmu.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
@@ -1392,9 +1393,10 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		if (!map_obj) {
 			status = -ENOMEM;
 		} else {
-			va_align = (*p_proc_object->intf_fxns->brd_mem_map)
-			    (p_proc_object->bridge_context, pa_align, 0,
-			     size_align, map_obj->pages);
+			va_align =
+				user_to_dsp_map(p_proc_object->bridge_context,
+						pa_align, 0, size_align,
+						map_obj->pages);
 			if (IS_ERR_VALUE(va_align))
 				status = va_align;
 		}
@@ -1662,9 +1664,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 		goto unmap_failed;
 
 	/* Remove mapping from the page tables. */
-	status = (*p_proc_object->intf_fxns->brd_mem_un_map)
-			(p_proc_object->bridge_context, va_align, dmo->size,
-			 dmo->pages);
+	status = user_to_dsp_unmap(p_proc_object->bridge_context, va_align,
+					dmo->size, dmo->pages);
 	if (status)
 		goto unmap_failed;
 
-- 
1.7.1

