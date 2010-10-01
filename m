Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0JACB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:01:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54951 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0JAB7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:38 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 07/11] staging: tidspbridge - move all iommu related code to a new file
Date: Thu, 30 Sep 2010 21:12:54 -0500
Message-Id: <1285899178-14413-8-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-7-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <1285899178-14413-3-git-send-email-x0095840@ti.com>
 <1285899178-14413-4-git-send-email-x0095840@ti.com>
 <1285899178-14413-5-git-send-email-x0095840@ti.com>
 <1285899178-14413-6-git-send-email-x0095840@ti.com>
 <1285899178-14413-7-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create dsp-mmu module and moves all the iommu code related to
this module.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/core/_deh.h            |    3 -
 drivers/staging/tidspbridge/core/_tiomap.h         |   27 +--
 drivers/staging/tidspbridge/core/dsp-mmu.c         |  316 ++++++++++++++++++++
 drivers/staging/tidspbridge/core/tiomap3430.c      |  178 +-----------
 drivers/staging/tidspbridge/core/ue_deh.c          |   86 +------
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |   67 ++++
 7 files changed, 390 insertions(+), 289 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/core/dsp-mmu.c
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index e09547d..bd36651 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_TIDSPBRIDGE)	+= bridgedriver.o
 
 libgen = gen/gb.o gen/gs.o gen/gh.o gen/uuidutil.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
-		core/tiomap3430_pwr.o core/tiomap_io.o \
+		core/tiomap3430_pwr.o core/tiomap_io.o core/dsp-mmu.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
 		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
diff --git a/drivers/staging/tidspbridge/core/_deh.h b/drivers/staging/tidspbridge/core/_deh.h
index f1254f0..8ae2633 100644
--- a/drivers/staging/tidspbridge/core/_deh.h
+++ b/drivers/staging/tidspbridge/core/_deh.h
@@ -27,9 +27,6 @@
 struct deh_mgr {
 	struct bridge_dev_context *hbridge_context;	/* Bridge context. */
 	struct ntfy_object *ntfy_obj;	/* NTFY object */
-
-	/* MMU Fault DPC */
-	struct tasklet_struct dpc_tasklet;
 };
 
 int mmu_fault_isr(struct iommu *mmu);
diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index cd7ff88..e0a801c 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -23,8 +23,7 @@
 #include <plat/clockdomain.h>
 #include <mach-omap2/prm-regbits-34xx.h>
 #include <mach-omap2/cm-regbits-34xx.h>
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
+#include <dspbridge/dsp-mmu.h>
 #include <dspbridge/devdefs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
 #include <dspbridge/sync.h>
@@ -380,28 +379,4 @@ extern s32 dsp_debug;
  */
 int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val);
 
-/**
- * user_to_dsp_map() - maps user to dsp virtual address
- * @mmu:	Pointer to iommu handle.
- * @uva:		Virtual user space address.
- * @da		DSP address
- * @size		Buffer size to map.
- * @usr_pgs	struct page array pointer where the user pages will be stored
- *
- * This function maps a user space buffer into DSP virtual address.
- *
- */
-u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
-						struct page **usr_pgs);
-
-/**
- * user_to_dsp_unmap() - unmaps DSP virtual buffer.
- * @mmu:	Pointer to iommu handle.
- * @da		DSP address
- *
- * This function unmaps a user space buffer into DSP virtual address.
- *
- */
-int user_to_dsp_unmap(struct iommu *mmu, u32 da);
-
 #endif /* _TIOMAP_ */
diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
new file mode 100644
index 0000000..3c978f9
--- /dev/null
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -0,0 +1,316 @@
+/*
+ * dsp-mmu.c
+ *
+ * DSP-BIOS Bridge driver support functions for TI OMAP processors.
+ *
+ * DSP iommu.
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc.
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
+#include <dspbridge/host_os.h>
+#include <plat/dmtimer.h>
+#include <dspbridge/dbdefs.h>
+#include <dspbridge/dev.h>
+#include <dspbridge/io_sm.h>
+#include <dspbridge/dspdeh.h>
+#include "_tiomap.h"
+
+#include <dspbridge/dsp-mmu.h>
+
+#define MMU_CNTL_TWL_EN		(1 << 2)
+
+static struct tasklet_struct mmu_tasklet;
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
+	load_iotlb_entry(mmu, &e);
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
+
+static void fault_tasklet(unsigned long data)
+{
+	struct iommu *mmu = (struct iommu *)data;
+	struct bridge_dev_context *dev_ctx;
+	struct deh_mgr *dm;
+	u32 fa;
+	dev_get_deh_mgr(dev_get_first(), &dm);
+	dev_get_bridge_context(dev_get_first(), &dev_ctx);
+
+	if (!dm || !dev_ctx)
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
+	bridge_deh_notify(dm, DSP_MMUFAULT, fa);
+}
+
+/*
+ *  ======== mmu_fault_isr ========
+ *      ISR to be triggered by a DSP MMU fault interrupt.
+ */
+static int mmu_fault_callback(struct iommu *mmu)
+{
+	if (!mmu)
+		return -EPERM;
+
+	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
+	tasklet_schedule(&mmu_tasklet);
+	return 0;
+}
+
+/**
+ * dsp_mmu_init() - initialize dsp_mmu module and returns a handle
+ *
+ * This function initialize dsp mmu module and returns a struct iommu
+ * handle to use it for dsp maps.
+ *
+ */
+struct iommu *dsp_mmu_init()
+{
+	struct iommu *mmu;
+
+	mmu = iommu_get("iva2");
+
+	if (!IS_ERR(mmu)) {
+		tasklet_init(&mmu_tasklet, fault_tasklet, (unsigned long)mmu);
+		mmu->isr = mmu_fault_callback;
+	}
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
+	tasklet_kill(&mmu_tasklet);
+}
+
+/**
+ * user_va2_pa() - get physical address from userspace address.
+ * @mm:		mm_struct Pointer of the process.
+ * @address:	Virtual user space address.
+ *
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
+ * @mm:		mm_struct Pointer of the process.
+ * @uva:		Virtual user space address.
+ * @pages	Pages to be pined.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ */
+static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
+						struct page **usr_pgs)
+{
+	u32 pa;
+	int i;
+	struct page *pg;
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
+ * user_to_dsp_map() - maps user to dsp virtual address
+ * @mmu:	Pointer to iommu handle.
+ * @uva:		Virtual user space address.
+ * @da		DSP address
+ * @size		Buffer size to map.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ * This function maps a user space buffer into DSP virtual address.
+ *
+ */
+u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+				struct page **usr_pgs)
+{
+	int res, w;
+	unsigned pages, i;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+
+	if (!size || !usr_pgs)
+		return -EINVAL;
+
+	pages = size / PG_SIZE4K;
+
+	down_read(&mm->mmap_sem);
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
+	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
+		w = 1;
+
+	if (vma->vm_flags & VM_IO)
+		i = get_io_pages(mm, uva, pages, usr_pgs);
+	else
+		i = get_user_pages(current, mm, uva, pages, w, 1,
+							usr_pgs, NULL);
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
+err_pages:
+	while (i--)
+		put_page(usr_pgs[i]);
+	return res;
+}
+
+/**
+ * user_to_dsp_unmap() - unmaps DSP virtual buffer.
+ * @mmu:	Pointer to iommu handle.
+ * @da		DSP address
+ *
+ * This function unmaps a user space buffer into DSP virtual address.
+ *
+ */
+int user_to_dsp_unmap(struct iommu *mmu, u32 da)
+{
+	unsigned i;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+
+	sgt = iommu_vunmap(mmu, da);
+	if (!sgt)
+		return -EFAULT;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		put_page(sg_page(sg));
+	sg_free_table(sgt);
+	kfree(sgt);
+
+	return 0;
+}
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 58118aa..789cc5e 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -52,7 +52,6 @@
 #include "_tiomap.h"
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
-#include "_deh.h"
 
 /* Offset in shared mem to write to in order to synchronize start with DSP */
 #define SHMSYNCOFFSET 4		/* GPP byte offset */
@@ -67,7 +66,6 @@
 #define MMU_SMALL_PAGE_MASK      0xFFFFF000
 #define OMAP3_IVA2_BOOTADDR_MASK 0xFFFFFC00
 #define PAGES_II_LVL_TABLE   512
-#define PHYS_TO_PAGE(phys)      pfn_to_page((phys) >> PAGE_SHIFT)
 
 /* Forward Declarations: */
 static int bridge_brd_monitor(struct bridge_dev_context *dev_ctxt);
@@ -352,17 +350,16 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 		mmu = dev_context->dsp_mmu;
 		if (mmu)
-			iommu_put(mmu);
-		mmu = iommu_get("iva2");
+			dsp_mmu_exit(mmu);
+		mmu = dsp_mmu_init();
 		if (IS_ERR(mmu)) {
-			dev_err(bridge, "iommu_get failed!\n");
+			dev_err(bridge, "dsp_mmu_init failed!\n");
 			dev_context->dsp_mmu = NULL;
 			status = (int)mmu;
 		}
 	}
 	if (!status) {
 		dev_context->dsp_mmu = mmu;
-		mmu->isr = mmu_fault_isr;
 		sm_sg = &dev_context->sh_s;
 		sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
 			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
@@ -618,7 +615,7 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 		}
 		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg0_da);
 		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg1_da);
-		iommu_put(dev_context->dsp_mmu);
+		dsp_mmu_exit(dev_context->dsp_mmu);
 		dev_context->dsp_mmu = NULL;
 	}
 	/* Reset IVA IOMMU*/
@@ -932,173 +929,6 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 }
 
 /*
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
-/**
- * get_io_pages() - pin and get pages of io user's buffer.
- * @mm:		mm_struct Pointer of the process.
- * @uva:		Virtual user space address.
- * @pages	Pages to be pined.
- * @usr_pgs	struct page array pointer where the user pages will be stored
- *
- */
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
-/**
- * user_to_dsp_map() - maps user to dsp virtual address
- * @mmu:	Pointer to iommu handle.
- * @uva:		Virtual user space address.
- * @da		DSP address
- * @size		Buffer size to map.
- * @usr_pgs	struct page array pointer where the user pages will be stored
- *
- * This function maps a user space buffer into DSP virtual address.
- *
- */
-u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
-				struct page **usr_pgs)
-{
-	int res, w;
-	unsigned pages, i;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
-	struct sg_table *sgt;
-	struct scatterlist *sg;
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
-err_pages:
-	while (i--)
-		put_page(usr_pgs[i]);
-	return res;
-}
-
-/**
- * user_to_dsp_unmap() - unmaps DSP virtual buffer.
- * @mmu:	Pointer to iommu handle.
- * @da		DSP address
- *
- * This function unmaps a user space buffer into DSP virtual address.
- *
- */
-int user_to_dsp_unmap(struct iommu *mmu, u32 da)
-{
-	unsigned i;
-	struct sg_table *sgt;
-	struct scatterlist *sg;
-
-	sgt = iommu_vunmap(mmu, da);
-	if (!sgt)
-		return -EFAULT;
-
-	for_each_sg(sgt->sgl, sg, sgt->nents, i)
-		put_page(sg_page(sg));
-	sg_free_table(sgt);
-	kfree(sgt);
-
-	return 0;
-}
-
-/*
  *  ======== wait_for_start ========
  *      Wait for the singal from DSP that it has started, or time out.
  */
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 2e1ac89..e24ea0c 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -31,32 +31,6 @@
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
-int mmu_fault_isr(struct iommu *mmu)
-{
-	struct deh_mgr *dm;
-
-	dev_get_deh_mgr(dev_get_first(), &dm);
-
-	if (!dm)
-		return -EPERM;
-
-	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
-	tasklet_schedule(&dm->dpc_tasklet);
-	return 0;
-}
-
 int bridge_deh_create(struct deh_mgr **ret_deh,
 		struct dev_object *hdev_obj)
 {
@@ -84,9 +58,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh,
 	}
 	ntfy_init(deh->ntfy_obj);
 
-	/* Create a MMUfault DPC */
-	tasklet_init(&deh->dpc_tasklet, mmu_fault_dpc, (u32) deh);
-
 	/* Fill in context structure */
 	deh->hbridge_context = hbridge_context;
 
@@ -110,9 +81,6 @@ int bridge_deh_destroy(struct deh_mgr *deh)
 		kfree(deh->ntfy_obj);
 	}
 
-	/* Free DPC object */
-	tasklet_kill(&deh->dpc_tasklet);
-
 	/* Deallocate the DEH manager object */
 	kfree(deh);
 
@@ -133,51 +101,6 @@ int bridge_deh_register_notify(struct deh_mgr *deh, u32 event_mask,
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
@@ -193,7 +116,6 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 {
 	struct bridge_dev_context *dev_context;
 	const char *str = event_to_string(event);
-	u32 fa;
 
 	if (!deh)
 		return;
@@ -211,13 +133,7 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
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
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
new file mode 100644
index 0000000..cb38d4c
--- /dev/null
+++ b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
@@ -0,0 +1,67 @@
+/*
+ * dsp-mmu.h
+ *
+ * DSP-BIOS Bridge driver support functions for TI OMAP processors.
+ *
+ * DSP iommu.
+ *
+ * Copyright (C) 2005-2010 Texas Instruments, Inc.
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
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
+
+/**
+ * dsp_mmu_init() - initialize dsp_mmu module and returns a handle
+ *
+ * This function initialize dsp mmu module and returns a struct iommu
+ * handle to use it for dsp maps.
+ *
+ */
+struct iommu *dsp_mmu_init(void);
+
+/**
+ * dsp_mmu_exit() - destroy dsp mmu module
+ * @mmu:	Pointer to iommu handle.
+ *
+ * This function destroys dsp mmu module.
+ *
+ */
+void dsp_mmu_exit(struct iommu *mmu);
+
+/**
+ * user_to_dsp_map() - maps user to dsp virtual address
+ * @mmu:	Pointer to iommu handle.
+ * @uva:		Virtual user space address.
+ * @da		DSP address
+ * @size		Buffer size to map.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ * This function maps a user space buffer into DSP virtual address.
+ *
+ */
+u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+						struct page **usr_pgs);
+
+/**
+ * user_to_dsp_unmap() - unmaps DSP virtual buffer.
+ * @mmu:	Pointer to iommu handle.
+ * @da		DSP address
+ *
+ * This function unmaps a user space buffer into DSP virtual address.
+ *
+ */
+int user_to_dsp_unmap(struct iommu *mmu, u32 da);
+
+#endif
-- 
1.6.3.3

