Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1D1PpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:45:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43431 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab1D1PnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:16 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 3/6] staging: tidspbridge: mapping support when SG_CHAIN is not defined
Date: Thu, 28 Apr 2011 10:31:49 -0500
Message-Id: <1304004712-8487-4-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ARCH_HAS_SG_CHAIN is not defined a scatter-gather table can hold a
fixed number of entries, otherwise it results in a panic when
allocating bigger tables.

Use generic allocator to manage the mapped memory in such cases and
ignore iovmm functions.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/Kconfig                |    1 +
 drivers/staging/tidspbridge/core/tiomap3430.c      |   94 +++++++++++++++++++-
 .../tidspbridge/include/dspbridge/dspdefs.h        |    3 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |    3 +-
 4 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 19b1b76..7a9d539 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -8,6 +8,7 @@ menuconfig TIDSPBRIDGE
 	select OMAP_MBOX_FWK
 	select OMAP_IOMMU
 	select OMAP_IOMMU_IVA2
+	select GENERIC_ALLOCATOR
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
 	  one or more attached DSPs.  The GPP is considered the master or
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 1ca50d9..692a456 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -23,6 +23,7 @@
 #include <dspbridge/host_os.h>
 #include <linux/mm.h>
 #include <linux/mmzone.h>
+#include <linux/genalloc.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
@@ -114,7 +115,8 @@ static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
 				  u32 ul_mpu_addr, u32 virt_addr,
 				  u32 ul_num_bytes, struct page **mapped_pages);
 static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctxt,
-				     u32 da);
+				     u32 da, size_t size,
+				     struct page **usr_pgs);
 static int bridge_dev_create(struct bridge_dev_context
 					**dev_cntxt,
 					struct dev_object *hdev_obj,
@@ -229,6 +231,27 @@ static struct notifier_block dsp_mbox_notifier = {
 	.notifier_call = io_mbox_msg,
 };
 
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
 static inline void flush_all(struct bridge_dev_context *dev_context)
 {
 	if (dev_context->brd_state == BRD_DSP_HIBERNATION ||
@@ -463,6 +486,27 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		dev_context->dsp_mmu = NULL;
 		return PTR_ERR(mmu);
 	}
+#ifndef ARCH_HAS_SG_CHAIN
+	else {
+		u32 start;
+
+		if (dmm_pool) {
+			gen_pool_destroy(dmm_pool);
+			dmm_pool = NULL;
+		}
+
+		dmm_pool = gen_pool_create(PAGE_SHIFT, -1);
+		if (!dmm_pool) {
+			iommu_put(mmu);
+			dev_context->dsp_mmu = NULL;
+			return -ENOMEM;
+		}
+
+		sm_sg = &dev_context->sh_s;
+		start = sm_sg->seg1_da + sm_sg->seg1_size;
+		gen_pool_add(dmm_pool, start, CONFIG_TIDSPBRIDGE_DMM_SIZE, -1);
+	}
+#endif
 
 	dev_context->dsp_mmu = mmu;
 	mmu->isr = mmu_fault_isr;
@@ -741,6 +785,12 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg0_da);
 		iommu_put(dev_context->dsp_mmu);
 		dev_context->dsp_mmu = NULL;
+#ifndef ARCH_HAS_SG_CHAIN
+		if (dmm_pool) {
+			gen_pool_destroy(dmm_pool);
+			dmm_pool = NULL;
+		}
+#endif
 	}
 
 	/* Reset IVA IOMMU */
@@ -1194,8 +1244,13 @@ static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
 	struct iommu *mmu = dev_ctx->dsp_mmu;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
+#ifndef ARCH_HAS_SG_CHAIN
+	u32 pa, addr;
+	struct iotlb_entry e;
+#else
 	struct sg_table *sgt;
 	struct scatterlist *sg;
+#endif
 
 	if (!size || !usr_pgs)
 		return -EINVAL;
@@ -1231,6 +1286,23 @@ static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
 		goto err_pages;
 	}
 
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
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 	if (!sgt) {
 		res = -ENOMEM;
@@ -1257,6 +1329,7 @@ static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
 err_sg:
 	kfree(sgt);
 	i = pages;
+#endif /* ARCH_HAS_SG_CHAIN */
 err_pages:
 	while (i--)
 		put_page(usr_pgs[i]);
@@ -1271,9 +1344,23 @@ err_pages:
  *      So, instead of looking up the PTE address for every 4K block,
  *      we clear consecutive PTEs until we unmap all the bytes
  */
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da)
+static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da,
+				 size_t size, struct page **usr_pgs)
 {
-	unsigned i;
+	unsigned i = 0;
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
 	struct sg_table *sgt;
 	struct scatterlist *sg;
 
@@ -1288,6 +1375,7 @@ static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da)
 
 	sg_free_table(sgt);
 	kfree(sgt);
+#endif /* ARCH_HAS_SG_CHAIN */
 
 	return 0;
 }
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 48f91c9..e052bba 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -194,7 +194,8 @@ typedef int(*fxn_brd_memmap) (struct bridge_dev_context
  */
 typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
 				       * dev_ctxt,
-				       u32 da);
+				       u32 da, size_t size,
+				       struct page **usr_pgs);
 
 /*
  *  ======== bridge_brd_stop ========
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 9049df8..ce57279 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1731,7 +1731,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 
 	/* Remove mapping from the page tables. */
 	status = (*p_proc_object->intf_fxns->brd_mem_un_map)
-			(p_proc_object->bridge_context, va_align);
+			(p_proc_object->bridge_context, va_align, dmo->size,
+			 dmo->pages);
 	if (status)
 		goto unmap_failed;
 
-- 
1.7.1

