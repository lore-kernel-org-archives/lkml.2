Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0LJD5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:57:18 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49607 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786Ab0LJD5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:57:07 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <felipe.contreras@gmail.com>, <nm@ti.com>,
        <ohad@wizery.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 4/4] staging: tidspbridge - change mmufault tasklet to a workqueue
Date: Thu,  9 Dec 2010 21:55:42 -0600
Message-Id: <1291953342-4905-5-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we don't need to manage the mmufault inside a tasklet
it is safer using a workqueue.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/staging/tidspbridge/core/_deh.h   |    2 +-
 drivers/staging/tidspbridge/core/ue_deh.c |   39 +++++++++++++++++-----------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_deh.h b/drivers/staging/tidspbridge/core/_deh.h
index 16723cd..d4aa561 100644
--- a/drivers/staging/tidspbridge/core/_deh.h
+++ b/drivers/staging/tidspbridge/core/_deh.h
@@ -29,7 +29,7 @@ struct deh_mgr {
 	struct ntfy_object *ntfy_obj;	/* NTFY object */
 
 	/* MMU Fault DPC */
-	struct tasklet_struct dpc_tasklet;
+	struct work_struct work;
 };
 
 #endif /* _DEH_ */
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 183900e..bef1018 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -32,10 +32,11 @@
 #include <dspbridge/wdt.h>
 
 static u32 fault_addr;
+static struct workqueue_struct *deh_wq;
 
-static void mmu_fault_dpc(unsigned long data)
+static void mmu_fault_dpc(struct work_struct *work)
 {
-	struct deh_mgr *deh = (void *)data;
+	struct deh_mgr *deh = container_of(work, struct deh_mgr, work);
 
 	if (!deh)
 		return;
@@ -69,7 +70,7 @@ static irqreturn_t mmu_fault_isr(int irq, void *data)
 		 * necessary to check if DSP MMU fault is intended for
 		 * Bridge.
 		 */
-		tasklet_schedule(&deh->dpc_tasklet);
+		queue_work(deh_wq, &deh->work);
 
 		/* Disable the MMU events, else once we clear it will
 		 * start to raise INTs again */
@@ -105,12 +106,19 @@ int bridge_deh_create(struct deh_mgr **ret_deh,
 	deh->ntfy_obj = kmalloc(sizeof(struct ntfy_object), GFP_KERNEL);
 	if (!deh->ntfy_obj) {
 		status = -ENOMEM;
-		goto err;
+		goto err1;
 	}
 	ntfy_init(deh->ntfy_obj);
 
+
 	/* Create a MMUfault DPC */
-	tasklet_init(&deh->dpc_tasklet, mmu_fault_dpc, (u32) deh);
+	deh_wq = create_workqueue("dspbridge-mmu_wq");
+	if (!deh_wq) {
+		status = -ENOMEM;
+		goto err2;
+	}
+
+	INIT_WORK(&deh->work, mmu_fault_dpc);
 
 	/* Fill in context structure */
 	deh->hbridge_context = hbridge_context;
@@ -118,14 +126,17 @@ int bridge_deh_create(struct deh_mgr **ret_deh,
 	/* Install ISR function for DSP MMU fault */
 	status = request_irq(INT_DSP_MMU_IRQ, mmu_fault_isr, 0,
 			"DspBridge\tiommu fault", deh);
-	if (status < 0)
-		goto err;
-
-	*ret_deh = deh;
-	return 0;
+	if (!status) {
+		*ret_deh = deh;
+		return 0;
+	}
 
+	destroy_workqueue(deh_wq);
+err2:
+	kfree(deh->ntfy_obj);
+err1:
+	kfree(deh);
 err:
-	bridge_deh_destroy(deh);
 	*ret_deh = NULL;
 	return status;
 }
@@ -144,7 +155,7 @@ int bridge_deh_destroy(struct deh_mgr *deh)
 	free_irq(INT_DSP_MMU_IRQ, deh);
 
 	/* Free DPC object */
-	tasklet_kill(&deh->dpc_tasklet);
+	destroy_workqueue(deh_wq);
 
 	/* Deallocate the DEH manager object */
 	kfree(deh);
@@ -178,7 +189,7 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	void *dummy_va_addr;
 
 	resources = dev_context->resources;
-	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
+	dummy_va_addr = (void *)__get_free_page(GFP_KERNEL);
 
 	if (!dummy_va_addr)
 		return;
@@ -195,8 +206,6 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 		return;
 	}
 
-	dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe);
-
 	/* Clear MMU interrupt */
 	hw_mmu_event_ack(resources->dw_dmmu_base,
 			HW_MMU_TRANSLATION_FAULT);
-- 
1.7.3.2

