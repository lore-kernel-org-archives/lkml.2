Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab0GAALu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:11:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38026 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab0GAALo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:11:44 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyu@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 7/9] dspbridge: move all iommu related code to a new file
Date: Wed, 30 Jun 2010 19:20:58 -0500
Message-Id: <1277943660-4112-8-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277943660-4112-7-git-send-email-x0095840@ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
 <1277943660-4112-2-git-send-email-x0095840@ti.com>
 <1277943660-4112-3-git-send-email-x0095840@ti.com>
 <1277943660-4112-4-git-send-email-x0095840@ti.com>
 <1277943660-4112-5-git-send-email-x0095840@ti.com>
 <1277943660-4112-6-git-send-email-x0095840@ti.com>
 <1277943660-4112-7-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all the code related to iommu in the
dsp-mmu.c file

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/dspbridge/dsp-mmu.h |   90 ++++++++++
 arch/arm/plat-omap/include/dspbridge/dspdeh.h  |    1 -
 drivers/dsp/bridge/Makefile                    |    2 +-
 drivers/dsp/bridge/core/_deh.h                 |    3 -
 drivers/dsp/bridge/core/_tiomap.h              |   41 +-----
 drivers/dsp/bridge/core/dsp-mmu.c              |  218 ++++++++++++++++++++++++
 drivers/dsp/bridge/core/mmu_fault.c            |   76 --------
 drivers/dsp/bridge/core/mmu_fault.h            |   35 ----
 drivers/dsp/bridge/core/tiomap3430.c           |  111 +------------
 drivers/dsp/bridge/core/ue_deh.c               |   68 +-------
 drivers/dsp/bridge/rmgr/proc.c                 |    6 +-
 11 files changed, 318 insertions(+), 333 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
 create mode 100644 drivers/dsp/bridge/core/dsp-mmu.c
 delete mode 100644 drivers/dsp/bridge/core/mmu_fault.c
 delete mode 100644 drivers/dsp/bridge/core/mmu_fault.h

diff --git a/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h b/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
new file mode 100644
index 0000000..266f38b
--- /dev/null
+++ b/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
@@ -0,0 +1,90 @@
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
+ * dsp_iotlb_init() - initialize dsp mmu entry
+ * @e:		Pointer tbl entry.
+ * @da		DSP address
+ * @pa:		physical address.
+ * @pgsz		page size to map.
+ *
+ * This function initializes a dsp mmu entry in order to be used with
+ * iommu functions.
+ */
+static inline void dsp_iotlb_init(struct iotlb_entry *e, u32 da, u32 pa,
+							u32 pgsz)
+{
+	e->da = da;
+	e->pa = pa;
+	e->valid = 1;
+	e->prsvd = 1;
+	e->pgsz = pgsz & MMU_CAM_PGSZ_MASK;
+	e->endian = MMU_RAM_ENDIAN_LITTLE;
+	e->elsz = MMU_RAM_ELSZ_32;
+	e->mixed = 0;
+}
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
+int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
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
diff --git a/arch/arm/plat-omap/include/dspbridge/dspdeh.h b/arch/arm/plat-omap/include/dspbridge/dspdeh.h
index 4394711..af19926 100644
--- a/arch/arm/plat-omap/include/dspbridge/dspdeh.h
+++ b/arch/arm/plat-omap/include/dspbridge/dspdeh.h
@@ -43,5 +43,4 @@ extern int bridge_deh_register_notify(struct deh_mgr *deh_mgr,
 extern void bridge_deh_notify(struct deh_mgr *deh_mgr,
 		u32 ulEventMask, u32 dwErrInfo);
 
-extern void bridge_deh_release_dummy_mem(void);
 #endif /* DSPDEH_ */
diff --git a/drivers/dsp/bridge/Makefile b/drivers/dsp/bridge/Makefile
index 66ca10a..9f32055 100644
--- a/drivers/dsp/bridge/Makefile
+++ b/drivers/dsp/bridge/Makefile
@@ -5,7 +5,7 @@ libservices = services/sync.o services/cfg.o \
 		services/ntfy.o services/services.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o \
-		core/mmu_fault.o core/ue_deh.o core/wdt.o core/dsp-clock.o
+		core/dsp-mmu.o core/ue_deh.o core/wdt.o core/dsp-clock.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
 		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
 librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
diff --git a/drivers/dsp/bridge/core/_deh.h b/drivers/dsp/bridge/core/_deh.h
index 8da2212..b1ef2e9 100644
--- a/drivers/dsp/bridge/core/_deh.h
+++ b/drivers/dsp/bridge/core/_deh.h
@@ -27,9 +27,6 @@ struct deh_mgr {
 	struct bridge_dev_context *hbridge_context;	/* Bridge context. */
 	struct ntfy_object *ntfy_obj;	/* NTFY object */
 	struct dsp_errorinfo err_info;	/* DSP exception info. */
-
-	/* MMU Fault DPC */
-	struct tasklet_struct dpc_tasklet;
 };
 
 #endif /* _DEH_ */
diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index 35f20a7..8a9a822 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
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
@@ -381,42 +380,4 @@ extern s32 dsp_debug;
  */
 int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val);
 
-static inline void dsp_iotlb_init(struct iotlb_entry *e, u32 da, u32 pa,
-							u32 pgsz)
-{
-	e->da = da;
-	e->pa = pa;
-	e->valid = 1;
-	e->prsvd = 1;
-	e->pgsz = pgsz & MMU_CAM_PGSZ_MASK;
-	e->endian = MMU_RAM_ENDIAN_LITTLE;
-	e->elsz = MMU_RAM_ELSZ_32;
-	e->mixed = 0;
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
-
-int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
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
diff --git a/drivers/dsp/bridge/core/dsp-mmu.c b/drivers/dsp/bridge/core/dsp-mmu.c
new file mode 100644
index 0000000..e8da327
--- /dev/null
+++ b/drivers/dsp/bridge/core/dsp-mmu.c
@@ -0,0 +1,218 @@
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
+static struct tasklet_struct mmu_tasklet;
+
+static void fault_tasklet(unsigned long data)
+{
+	struct iommu *mmu = (struct iommu *)data;
+	struct bridge_dev_context *dev_ctx;
+	struct deh_mgr *dm;
+	struct iotlb_entry e;
+	u32 fa, tmp, dummy;
+
+	dev_get_deh_mgr(dev_get_first(), &dm);
+	dev_get_bridge_context(dev_get_first(), &dev_ctx);
+
+	if (!dm || !dev_ctx)
+		return;
+
+	dummy = __get_free_page(GFP_ATOMIC);
+
+	if (!dummy)
+		return;
+
+	print_dsp_trace_buffer(dev_ctx);
+	dump_dl_modules(dev_ctx);
+
+	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
+	dsp_iotlb_init(&e, fa & PAGE_MASK, __pa(dummy), IOVMF_PGSZ_4K);
+	load_iotlb_entry(mmu, &e);
+
+	dsp_clk_enable(DSP_CLK_GPT7);
+	dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe);
+
+	/* Clear MMU interrupt */
+	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
+	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
+
+	dump_dsp_stack(dev_ctx);
+	dsp_clk_disable(DSP_CLK_GPT7);
+
+	bridge_deh_notify(dm, DSP_MMUFAULT, fa);
+	free_page(dummy);
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
+	mmu = iommu_get("iva2");
+	if (IS_ERR(mmu))
+		return mmu;
+
+	tasklet_init(&mmu_tasklet, fault_tasklet, (unsigned long)mmu);
+	mmu->isr = mmu_fault_callback;
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
+
+	if (mmu)
+		iommu_put(mmu);
+	tasklet_kill(&mmu_tasklet);
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
+
+int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+						struct page **usr_pgs)
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
+						       __func__, uva, size);
+		up_read(&mm->mmap_sem);
+		return -EINVAL;
+	}
+	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
+		w = 1;
+	res = get_user_pages(current, mm, uva, pages, w, 1, usr_pgs, NULL);
+	up_read(&mm->mmap_sem);
+	if (res < 0)
+		return res;
+
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+
+	if (!sgt)
+		return -ENOMEM;
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
+	if (IS_ERR_VALUE(da)) {
+		res = (int)da;
+		goto err_map;
+	}
+	return 0;
+
+err_map:
+	sg_free_table(sgt);
+err_sg:
+	kfree(sgt);
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
+
+	sg_free_table(sgt);
+	kfree(sgt);
+
+	return 0;
+}
diff --git a/drivers/dsp/bridge/core/mmu_fault.c b/drivers/dsp/bridge/core/mmu_fault.c
deleted file mode 100644
index 54c0bc3..0000000
--- a/drivers/dsp/bridge/core/mmu_fault.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * mmu_fault.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Implements DSP MMU fault handling functions.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-/*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/std.h>
-#include <dspbridge/dbdefs.h>
-
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/host_os.h>
-#include <dspbridge/dbc.h>
-#include <plat/iommu.h>
-
-/*  ----------------------------------- OS Adaptation Layer */
-#include <dspbridge/drv.h>
-#include <dspbridge/dev.h>
-
-
-/*  ----------------------------------- Link Driver */
-#include <dspbridge/dspdeh.h>
-
-/*  ----------------------------------- This */
-#include "_deh.h"
-#include <dspbridge/cfg.h>
-#include "_tiomap.h"
-#include "mmu_fault.h"
-
-/*
- *  ======== mmu_fault_dpc ========
- *      Deferred procedure call to handle DSP MMU fault.
- */
-void mmu_fault_dpc(IN unsigned long pRefData)
-{
-	struct deh_mgr *hdeh_mgr = (struct deh_mgr *)pRefData;
-
-	if (hdeh_mgr)
-		bridge_deh_notify(hdeh_mgr, DSP_MMUFAULT, 0L);
-
-}
-
-/*
- *  ======== mmu_fault_isr ========
- *      ISR to be triggered by a DSP MMU fault interrupt.
- */
-int mmu_fault_isr(struct iommu *mmu)
-
-{
-	struct deh_mgr *dm;
-	u32 da;
-
-	dev_get_deh_mgr(dev_get_first(), &dm);
-
-	if (!dm)
-		return -EPERM;
-
-	da = iommu_read_reg(mmu, MMU_FAULT_AD);
-	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
-	dm->err_info.dw_val1 = da;
-	tasklet_schedule(&dm->dpc_tasklet);
-
-	return 0;
-}
diff --git a/drivers/dsp/bridge/core/mmu_fault.h b/drivers/dsp/bridge/core/mmu_fault.h
deleted file mode 100644
index df3fba6..0000000
--- a/drivers/dsp/bridge/core/mmu_fault.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * mmu_fault.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Defines DSP MMU fault handling functions.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef MMU_FAULT_
-#define MMU_FAULT_
-
-/*
- *  ======== mmu_fault_dpc ========
- *      Deferred procedure call to handle DSP MMU fault.
- */
-void mmu_fault_dpc(IN unsigned long pRefData);
-
-/*
- *  ======== mmu_fault_isr ========
- *      ISR to be triggered by a DSP MMU fault interrupt.
- */
-int mmu_fault_isr(struct iommu *mmu);
-
-
-#endif /* MMU_FAULT_ */
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index 9b6293b..aa6e999 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -53,7 +53,6 @@
 #include "_tiomap.h"
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
-#include "mmu_fault.h"
 
 /* Offset in shared mem to write to in order to synchronize start with DSP */
 #define SHMSYNCOFFSET 4		/* GPP byte offset */
@@ -369,8 +368,8 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	mmu = dev_context->dsp_mmu;
 
 	if (mmu)
-		iommu_put(mmu);
-	mmu = iommu_get("iva2");
+		dsp_mmu_exit(mmu);
+	mmu = dsp_mmu_init();
 
 	if (IS_ERR(mmu)) {
 		pr_err("Error in iommu_get %ld\n", PTR_ERR(mmu));
@@ -379,7 +378,6 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 		goto end;
 	}
 	dev_context->dsp_mmu = mmu;
-	mmu->isr = mmu_fault_isr;
 	sm_sg = dev_context->sh_s;
 
 	sm_sg->seg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
@@ -612,7 +610,7 @@ static int bridge_brd_stop(struct bridge_dev_context *hDevContext)
 			iommu_kunmap(dev_context->dsp_mmu,
 						dev_context->sh_s->seg1_da);
 		}
-		iommu_put(dev_context->dsp_mmu);
+		dsp_mmu_exit(dev_context->dsp_mmu);
 		dev_context->dsp_mmu = NULL;
 	}
 
@@ -673,7 +671,7 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 			iommu_kunmap(dev_context->dsp_mmu,
 						dev_context->sh_s->seg1_da);
 		}
-		iommu_put(dev_context->dsp_mmu);
+		dsp_mmu_exit(dev_context->dsp_mmu);
 		dev_context->dsp_mmu = NULL;
 	}
 
@@ -987,107 +985,6 @@ static int bridge_brd_mem_write(struct bridge_dev_context *hDevContext,
 	return status;
 }
 
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
-
-int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
-						struct page **usr_pgs)
-
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
-						       __func__, uva, size);
-		up_read(&mm->mmap_sem);
-		return -EINVAL;
-	}
-	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
-		w = 1;
-	res = get_user_pages(current, mm, uva, pages, w, 1, usr_pgs, NULL);
-	up_read(&mm->mmap_sem);
-	if (res < 0)
-		return res;
-
-	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
-
-	if (!sgt)
-		return -ENOMEM;
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
-	if (IS_ERR_VALUE(da)) {
-		res = (int)da;
-		goto err_map;
-	}
-	return 0;
-
-err_map:
-	sg_free_table(sgt);
-err_sg:
-	kfree(sgt);
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
-
-	sg_free_table(sgt);
-	kfree(sgt);
-
-	return 0;
-}
-
 /*
  *  ======== wait_for_start ========
  *      Wait for the singal from DSP that it has started, or time out.
diff --git a/drivers/dsp/bridge/core/ue_deh.c b/drivers/dsp/bridge/core/ue_deh.c
index 72cc6c0..4a00d09 100644
--- a/drivers/dsp/bridge/core/ue_deh.c
+++ b/drivers/dsp/bridge/core/ue_deh.c
@@ -18,11 +18,11 @@
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
-#include <plat/iommu.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/std.h>
 #include <dspbridge/dbdefs.h>
+#include <dspbridge/dsp-mmu.h>
 
 /*  ----------------------------------- Trace & Debug */
 #include <dspbridge/dbc.h>
@@ -42,14 +42,11 @@
 #include <dspbridge/wdt.h>
 
 /*  ----------------------------------- This */
-#include "mmu_fault.h"
 #include "_tiomap.h"
 #include "_deh.h"
 #include "_tiomap_pwr.h"
 #include <dspbridge/io_sm.h>
 
-static void *dummy_va_addr;
-
 int bridge_deh_create(struct deh_mgr **ret_deh_mgr,
 		struct dev_object *hdev_obj)
 {
@@ -63,7 +60,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh_mgr,
 	/* Get Bridge context info. */
 	dev_get_bridge_context(hdev_obj, &hbridge_context);
 	DBC_ASSERT(hbridge_context);
-	dummy_va_addr = NULL;
 	/* Allocate IO manager object: */
 	deh_mgr = kzalloc(sizeof(struct deh_mgr), GFP_KERNEL);
 	if (!deh_mgr) {
@@ -80,9 +76,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh_mgr,
 		goto err;
 	}
 
-	/* Create a MMUfault DPC */
-	tasklet_init(&deh_mgr->dpc_tasklet, mmu_fault_dpc, (u32) deh_mgr);
-
 	/* Fill in context structure */
 	deh_mgr->hbridge_context = hbridge_context;
 	deh_mgr->err_info.dw_err_mask = 0L;
@@ -107,17 +100,12 @@ int bridge_deh_destroy(struct deh_mgr *deh_mgr)
 	if (!deh_mgr)
 		return -EFAULT;
 
-	/* Release dummy VA buffer */
-	bridge_deh_release_dummy_mem();
 	/* If notification object exists, delete it */
 	if (deh_mgr->ntfy_obj) {
 		ntfy_delete(deh_mgr->ntfy_obj);
 		kfree(deh_mgr->ntfy_obj);
 	}
 
-	/* Free DPC object */
-	tasklet_kill(&deh_mgr->dpc_tasklet);
-
 	/* Deallocate the DEH manager object */
 	kfree(deh_mgr);
 
@@ -145,10 +133,7 @@ int bridge_deh_register_notify(struct deh_mgr *deh_mgr, u32 event_mask,
 void bridge_deh_notify(struct deh_mgr *deh_mgr, u32 ulEventMask, u32 dwErrInfo)
 {
 	struct bridge_dev_context *dev_context;
-	u32 hw_mmu_max_tlb_count = 31;
 	struct cfg_hostres *resources;
-	u32 fault_addr, tmp;
-	struct iotlb_entry e;
 
 	if (!deh_mgr)
 		return;
@@ -171,49 +156,8 @@ void bridge_deh_notify(struct deh_mgr *deh_mgr, u32 ulEventMask, u32 dwErrInfo)
 		dump_dsp_stack(dev_context);
 		break;
 	case DSP_MMUFAULT:
-		/* MMU fault routine should have set err info structure. */
-		fault_addr = iommu_read_reg(dev_context->dsp_mmu,
-							MMU_FAULT_AD);
-
-		deh_mgr->err_info.dw_err_mask = DSP_MMUFAULT;
-		dev_err(bridge, "%s: %s, err_info = 0x%x\n",
-				__func__, "DSP_MMUFAULT", dwErrInfo);
-		dev_info(bridge, "%s: %s, high=0x%x, low=0x%x, "
-			"fault=0x%x\n", __func__, "DSP_MMUFAULT",
-			(unsigned int) deh_mgr->err_info.dw_val1,
-			(unsigned int) deh_mgr->err_info.dw_val2,
-			(unsigned int) fault_addr);
-		dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
-		dev_context = (struct bridge_dev_context *)
-			deh_mgr->hbridge_context;
-
-		print_dsp_trace_buffer(dev_context);
-		dump_dl_modules(dev_context);
-
-		/*
-		 * Reset the dynamic mmu index to fixed count if it exceeds
-		 * 31. So that the dynmmuindex is always between the range of
-		 * standard/fixed entries and 31.
-		 */
-		if (dev_context->num_tlb_entries >
-				hw_mmu_max_tlb_count) {
-			dev_context->num_tlb_entries =
-				dev_context->fixed_tlb_entries;
-		}
-		dsp_iotlb_init(&e, fault_addr & PAGE_MASK,
-			virt_to_phys(dummy_va_addr), IOVMF_PGSZ_4K);
-		load_iotlb_entry(dev_context->dsp_mmu, &e);
-
-
-		dsp_clk_enable(DSP_CLK_GPT8);
-
-		dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
-
-		tmp = iommu_read_reg(dev_context->dsp_mmu, MMU_IRQSTATUS);
-		iommu_write_reg(dev_context->dsp_mmu, tmp, MMU_IRQSTATUS);
-
-		dump_dsp_stack(deh_mgr->hbridge_context);
-		dsp_clk_disable(DSP_CLK_GPT8);
+		dev_err(bridge, "%s: %s, fault address = 0x%x\n",
+				__func__, "DSP_MMUFault", dwErrInfo);
 		break;
 #ifdef CONFIG_BRIDGE_NTFY_PWRERR
 	case DSP_PWRERROR:
@@ -276,9 +220,3 @@ int bridge_deh_get_info(struct deh_mgr *deh_mgr,
 
 	return 0;
 }
-
-void bridge_deh_release_dummy_mem(void)
-{
-	free_page((unsigned long)dummy_va_addr);
-	dummy_va_addr = NULL;
-}
diff --git a/drivers/dsp/bridge/rmgr/proc.c b/drivers/dsp/bridge/rmgr/proc.c
index 299bef3..4f10a41 100644
--- a/drivers/dsp/bridge/rmgr/proc.c
+++ b/drivers/dsp/bridge/rmgr/proc.c
@@ -1634,11 +1634,7 @@ int proc_stop(void *hprocessor)
 		status = -EFAULT;
 		goto func_end;
 	}
-	if (DSP_SUCCEEDED((*p_proc_object->intf_fxns->pfn_brd_status)
-			  (p_proc_object->hbridge_context, &brd_state))) {
-		if (brd_state == BRD_ERROR)
-			bridge_deh_release_dummy_mem();
-	}
+
 	/* check if there are any running nodes */
 	status = dev_get_node_manager(p_proc_object->hdev_obj, &hnode_mgr);
 	if (DSP_SUCCEEDED(status) && hnode_mgr) {
-- 
1.6.3.3

