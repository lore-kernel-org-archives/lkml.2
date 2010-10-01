Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0JACA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:00:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35031 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0JAB7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:38 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 05/11] staging: tidspbridge - fix mmufault support
Date: Thu, 30 Sep 2010 21:12:52 -0500
Message-Id: <1285899178-14413-6-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-5-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <1285899178-14413-3-git-send-email-x0095840@ti.com>
 <1285899178-14413-4-git-send-email-x0095840@ti.com>
 <1285899178-14413-5-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With changes for iommu migration mmufault report and dsp track
dump is broken, this patch fixes that.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/_deh.h       |    2 +
 drivers/staging/tidspbridge/core/tiomap3430.c |    2 +
 drivers/staging/tidspbridge/core/ue_deh.c     |   93 ++++++++++---------------
 3 files changed, 40 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_deh.h b/drivers/staging/tidspbridge/core/_deh.h
index 16723cd..f1254f0 100644
--- a/drivers/staging/tidspbridge/core/_deh.h
+++ b/drivers/staging/tidspbridge/core/_deh.h
@@ -32,4 +32,6 @@ struct deh_mgr {
 	struct tasklet_struct dpc_tasklet;
 };
 
+int mmu_fault_isr(struct iommu *mmu);
+
 #endif /* _DEH_ */
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index f99cc24..55ea265 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -56,6 +56,7 @@
 #include "_tiomap.h"
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
+#include "_deh.h"
 
 /* Offset in shared mem to write to in order to synchronize start with DSP */
 #define SHMSYNCOFFSET 4		/* GPP byte offset */
@@ -365,6 +366,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	}
 	if (!status) {
 		dev_context->dsp_mmu = mmu;
+		mmu->isr = mmu_fault_isr;
 		sm_sg = &dev_context->sh_s;
 		sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
 			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 14f3191..2e1ac89 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -31,7 +31,7 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/wdt.h>
 
-static u32 fault_addr;
+#define MMU_CNTL_TWL_EN		(1 << 2)
 
 static void mmu_fault_dpc(unsigned long data)
 {
@@ -43,43 +43,18 @@ static void mmu_fault_dpc(unsigned long data)
 	bridge_deh_notify(deh, DSP_MMUFAULT, 0);
 }
 
-static irqreturn_t mmu_fault_isr(int irq, void *data)
+int mmu_fault_isr(struct iommu *mmu)
 {
-	struct deh_mgr *deh = data;
-	struct cfg_hostres *resources;
-	u32 event;
+	struct deh_mgr *dm;
 
-	if (!deh)
-		return IRQ_HANDLED;
+	dev_get_deh_mgr(dev_get_first(), &dm);
 
-	resources = deh->hbridge_context->resources;
-	if (!resources) {
-		dev_dbg(bridge, "%s: Failed to get Host Resources\n",
-				__func__);
-		return IRQ_HANDLED;
-	}
+	if (!dm)
+		return -EPERM;
 
-	hw_mmu_event_status(resources->dw_dmmu_base, &event);
-	if (event == HW_MMU_TRANSLATION_FAULT) {
-		hw_mmu_fault_addr_read(resources->dw_dmmu_base, &fault_addr);
-		dev_dbg(bridge, "%s: event=0x%x, fault_addr=0x%x\n", __func__,
-				event, fault_addr);
-		/*
-		 * Schedule a DPC directly. In the future, it may be
-		 * necessary to check if DSP MMU fault is intended for
-		 * Bridge.
-		 */
-		tasklet_schedule(&deh->dpc_tasklet);
-
-		/* Disable the MMU events, else once we clear it will
-		 * start to raise INTs again */
-		hw_mmu_event_disable(resources->dw_dmmu_base,
-				HW_MMU_TRANSLATION_FAULT);
-	} else {
-		hw_mmu_event_disable(resources->dw_dmmu_base,
-				HW_MMU_ALL_INTERRUPTS);
-	}
-	return IRQ_HANDLED;
+	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
+	tasklet_schedule(&dm->dpc_tasklet);
+	return 0;
 }
 
 int bridge_deh_create(struct deh_mgr **ret_deh,
@@ -161,42 +136,45 @@ int bridge_deh_register_notify(struct deh_mgr *deh, u32 event_mask,
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 {
-	struct cfg_hostres *resources;
-	struct hw_mmu_map_attrs_t map_attrs = {
-		.endianism = HW_LITTLE_ENDIAN,
-		.element_size = HW_ELEM_SIZE16BIT,
-		.mixed_size = HW_MMU_CPUES,
-	};
-	void *dummy_va_addr;
-
-	resources = dev_context->resources;
-	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
+	void *dummy_addr;
+	u32 fa, tmp;
+	struct iotlb_entry e;
+	struct iommu *mmu = dev_context->dsp_mmu;
+	dummy_addr = (void *)__get_free_page(GFP_ATOMIC);
 
 	/*
 	 * Before acking the MMU fault, let's make sure MMU can only
 	 * access entry #0. Then add a new entry so that the DSP OS
 	 * can continue in order to dump the stack.
 	 */
-	hw_mmu_twl_disable(resources->dw_dmmu_base);
-	hw_mmu_tlb_flush_all(resources->dw_dmmu_base);
-
-	hw_mmu_tlb_add(resources->dw_dmmu_base,
-			virt_to_phys(dummy_va_addr), fault_addr,
-			HW_PAGE_SIZE4KB, 1,
-			&map_attrs, HW_SET, HW_SET);
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
 
 	dsp_clk_enable(DSP_CLK_GPT8);
 
 	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
 
 	/* Clear MMU interrupt */
-	hw_mmu_event_ack(resources->dw_dmmu_base,
-			HW_MMU_TRANSLATION_FAULT);
+	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
+	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
+
 	dump_dsp_stack(dev_context);
 	dsp_clk_disable(DSP_CLK_GPT8);
 
-	hw_mmu_disable(resources->dw_dmmu_base);
-	free_page((unsigned long)dummy_va_addr);
+	iopgtable_clear_entry(mmu, fa);
+	free_page((unsigned long)dummy_addr);
 }
 #endif
 
@@ -215,6 +193,7 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 {
 	struct bridge_dev_context *dev_context;
 	const char *str = event_to_string(event);
+	u32 fa;
 
 	if (!deh)
 		return;
@@ -232,8 +211,8 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 #endif
 		break;
 	case DSP_MMUFAULT:
-		dev_err(bridge, "%s: %s, addr=0x%x", __func__,
-				str, fault_addr);
+		fa = iommu_read_reg(dev_context->dsp_mmu, MMU_FAULT_AD);
+		dev_err(bridge, "%s: %s, addr=0x%x", __func__, str, fa);
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 		print_dsp_trace_buffer(dev_context);
 		dump_dl_modules(dev_context);
-- 
1.6.3.3

