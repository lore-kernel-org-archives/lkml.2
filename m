Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0JZAit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:38:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46198 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0JZAij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:39 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 3/8] staging: tidspbridge - change mmufault tasklet to a workqueue
Date: Mon, 25 Oct 2010 19:51:41 -0500
Message-Id: <1288054306-4361-4-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-3-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to manage the mmufault inside a tasklet
it is safer using a workqueue.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-mmu.c |   34 ++++++++++++++++++----------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 983c95a..6d7501a 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -28,7 +28,8 @@
 
 #define MMU_CNTL_TWL_EN		(1 << 2)
 
-static struct tasklet_struct mmu_tasklet;
+static struct workqueue_struct *mmu_wq;
+static struct work_struct fault_work;
 
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
@@ -37,7 +38,10 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	u32 fa, tmp;
 	struct iotlb_entry e;
 	struct iommu *mmu = dev_context->dsp_mmu;
-	dummy_addr = (void *)__get_free_page(GFP_ATOMIC);
+
+	dummy_addr = (void *)__get_free_page(GFP_KERNEL);
+	if (!dummy_addr)
+		return;
 
 	/*
 	 * Before acking the MMU fault, let's make sure MMU can only
@@ -76,19 +80,19 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 #endif
 
 
-static void fault_tasklet(unsigned long data)
+static void mmu_fault_work(struct work_struct *work)
 {
-	struct iommu *mmu = (struct iommu *)data;
 	struct bridge_dev_context *dev_ctx;
 	struct deh_mgr *dm;
 	u32 fa;
+
 	dev_get_deh_mgr(dev_get_first(), &dm);
 	dev_get_bridge_context(dev_get_first(), &dev_ctx);
 
 	if (!dm || !dev_ctx)
 		return;
 
-	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
+	fa = iommu_read_reg(dev_ctx->dsp_mmu, MMU_FAULT_AD);
 
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 	print_dsp_trace_buffer(dev_ctx);
@@ -109,7 +113,8 @@ static int mmu_fault_callback(struct iommu *mmu)
 		return -EPERM;
 
 	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
-	tasklet_schedule(&mmu_tasklet);
+	queue_work(mmu_wq, &fault_work);
+
 	return 0;
 }
 
@@ -126,10 +131,16 @@ struct iommu *dsp_mmu_init()
 
 	mmu = iommu_get("iva2");
 
-	if (!IS_ERR(mmu)) {
-		tasklet_init(&mmu_tasklet, fault_tasklet, (unsigned long)mmu);
-		mmu->isr = mmu_fault_callback;
+	if (IS_ERR(mmu))
+		return mmu;
+
+	mmu->isr = mmu_fault_callback;
+	mmu_wq = create_workqueue("dsp-mmu_wq");
+	if (!mmu_wq) {
+		iommu_put(mmu);
+		return ERR_PTR(-ENOMEM);
 	}
+	INIT_WORK(&fault_work, mmu_fault_work);
 
 	return mmu;
 }
@@ -143,9 +154,8 @@ struct iommu *dsp_mmu_init()
  */
 void dsp_mmu_exit(struct iommu *mmu)
 {
-	if (mmu)
-		iommu_put(mmu);
-	tasklet_kill(&mmu_tasklet);
+	iommu_put(mmu);
+	destroy_workqueue(mmu_wq);
 }
 
 /**
-- 
1.6.3.3

