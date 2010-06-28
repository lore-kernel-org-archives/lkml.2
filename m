Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0F1VIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:08:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:43034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0F1VI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:08:27 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>, Andy Walls <awalls@md.metrocast.net>,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH 02/35] ivtv: use kthread_worker instead of workqueue
Date: Mon, 28 Jun 2010 23:03:50 +0200
Message-Id: <1277759063-24607-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming workqueue updates will no longer guarantee fixed workqueue to
worker kthread association, so giving RT priority to the irq worker
won't work.  Use kthread_worker which guarantees specific kthread
association instead.  This also makes setting the priority cleaner.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/ivtv/ivtv-driver.c |   26 ++++++++++++++++----------
 drivers/media/video/ivtv/ivtv-driver.h |    8 ++++----
 drivers/media/video/ivtv/ivtv-irq.c    |   15 +++------------
 drivers/media/video/ivtv/ivtv-irq.h    |    2 +-
 4 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 1b79475..49e0b1c 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -695,6 +695,8 @@ done:
  */
 static int __devinit ivtv_init_struct1(struct ivtv *itv)
 {
+	struct sched_param param = { .sched_priority = 99 };
+
 	itv->base_addr = pci_resource_start(itv->pdev, 0);
 	itv->enc_mbox.max_mbox = 2; /* the encoder has 3 mailboxes (0-2) */
 	itv->dec_mbox.max_mbox = 1; /* the decoder has 2 mailboxes (0-1) */
@@ -706,13 +708,17 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
 	spin_lock_init(&itv->lock);
 	spin_lock_init(&itv->dma_reg_lock);
 
-	itv->irq_work_queues = create_singlethread_workqueue(itv->v4l2_dev.name);
-	if (itv->irq_work_queues == NULL) {
-		IVTV_ERR("Could not create ivtv workqueue\n");
+	init_kthread_worker(&itv->irq_worker);
+	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
+					   itv->v4l2_dev.name);
+	if (IS_ERR(itv->irq_worker_task)) {
+		IVTV_ERR("Could not create ivtv task\n");
 		return -1;
 	}
+	/* must use the FIFO scheduler as it is realtime sensitive */
+	sched_setscheduler(itv->irq_worker_task, SCHED_FIFO, &param);
 
-	INIT_WORK(&itv->irq_work_queue, ivtv_irq_work_handler);
+	init_kthread_work(&itv->irq_work, ivtv_irq_work_handler);
 
 	/* start counting open_id at 1 */
 	itv->open_id = 1;
@@ -996,7 +1002,7 @@ static int __devinit ivtv_probe(struct pci_dev *pdev,
 	/* PCI Device Setup */
 	retval = ivtv_setup_pci(itv, pdev, pci_id);
 	if (retval == -EIO)
-		goto free_workqueue;
+		goto free_worker;
 	if (retval == -ENXIO)
 		goto free_mem;
 
@@ -1208,8 +1214,8 @@ free_mem:
 	release_mem_region(itv->base_addr + IVTV_REG_OFFSET, IVTV_REG_SIZE);
 	if (itv->has_cx23415)
 		release_mem_region(itv->base_addr + IVTV_DECODER_OFFSET, IVTV_DECODER_SIZE);
-free_workqueue:
-	destroy_workqueue(itv->irq_work_queues);
+free_worker:
+	kthread_stop(itv->irq_worker_task);
 err:
 	if (retval == 0)
 		retval = -ENODEV;
@@ -1353,9 +1359,9 @@ static void ivtv_remove(struct pci_dev *pdev)
 	ivtv_set_irq_mask(itv, 0xffffffff);
 	del_timer_sync(&itv->dma_timer);
 
-	/* Stop all Work Queues */
-	flush_workqueue(itv->irq_work_queues);
-	destroy_workqueue(itv->irq_work_queues);
+	/* Kill irq worker */
+	flush_kthread_worker(&itv->irq_worker);
+	kthread_stop(itv->irq_worker_task);
 
 	ivtv_streams_cleanup(itv, 1);
 	ivtv_udma_free(itv);
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 5b45fd2..51f7f2a 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -51,7 +51,7 @@
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
-#include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -257,7 +257,6 @@ struct ivtv_mailbox_data {
 #define IVTV_F_I_DEC_PAUSED	   20 	/* the decoder is paused */
 #define IVTV_F_I_INITED		   21 	/* set after first open */
 #define IVTV_F_I_FAILED		   22 	/* set if first open failed */
-#define IVTV_F_I_WORK_INITED       23	/* worker thread was initialized */
 
 /* Event notifications */
 #define IVTV_F_I_EV_DEC_STOPPED	   28	/* decoder stopped event */
@@ -663,8 +662,9 @@ struct ivtv {
 	/* Interrupts & DMA */
 	u32 irqmask;                    /* active interrupts */
 	u32 irq_rr_idx;                 /* round-robin stream index */
-	struct workqueue_struct *irq_work_queues;       /* workqueue for PIO/YUV/VBI actions */
-	struct work_struct irq_work_queue;              /* work entry */
+	struct kthread_worker irq_worker;		/* kthread worker for PIO/YUV/VBI actions */
+	struct task_struct *irq_worker_task;		/* task for irq_worker */
+	struct kthread_work irq_work;	/* kthread work entry */
 	spinlock_t dma_reg_lock;        /* lock access to DMA engine registers */
 	int cur_dma_stream;		/* index of current stream doing DMA (-1 if none) */
 	int cur_pio_stream;		/* index of current stream doing PIO (-1 if none) */
diff --git a/drivers/media/video/ivtv/ivtv-irq.c b/drivers/media/video/ivtv/ivtv-irq.c
index fea1ec3..9b4faf0 100644
--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -71,19 +71,10 @@ static void ivtv_pio_work_handler(struct ivtv *itv)
 	write_reg(IVTV_IRQ_ENC_PIO_COMPLETE, 0x44);
 }
 
-void ivtv_irq_work_handler(struct work_struct *work)
+void ivtv_irq_work_handler(struct kthread_work *work)
 {
-	struct ivtv *itv = container_of(work, struct ivtv, irq_work_queue);
+	struct ivtv *itv = container_of(work, struct ivtv, irq_work);
 
-	DEFINE_WAIT(wait);
-
-	if (test_and_clear_bit(IVTV_F_I_WORK_INITED, &itv->i_flags)) {
-		struct sched_param param = { .sched_priority = 99 };
-
-		/* This thread must use the FIFO scheduler as it
-		   is realtime sensitive. */
-		sched_setscheduler(current, SCHED_FIFO, &param);
-	}
 	if (test_and_clear_bit(IVTV_F_I_WORK_HANDLER_PIO, &itv->i_flags))
 		ivtv_pio_work_handler(itv);
 
@@ -975,7 +966,7 @@ irqreturn_t ivtv_irq_handler(int irq, void *dev_id)
 	}
 
 	if (test_and_clear_bit(IVTV_F_I_HAVE_WORK, &itv->i_flags)) {
-		queue_work(itv->irq_work_queues, &itv->irq_work_queue);
+		queue_kthread_work(&itv->irq_worker, &itv->irq_work);
 	}
 
 	spin_unlock(&itv->dma_reg_lock);
diff --git a/drivers/media/video/ivtv/ivtv-irq.h b/drivers/media/video/ivtv/ivtv-irq.h
index f879a58..1e84433 100644
--- a/drivers/media/video/ivtv/ivtv-irq.h
+++ b/drivers/media/video/ivtv/ivtv-irq.h
@@ -46,7 +46,7 @@
 
 irqreturn_t ivtv_irq_handler(int irq, void *dev_id);
 
-void ivtv_irq_work_handler(struct work_struct *work);
+void ivtv_irq_work_handler(struct kthread_work *work);
 void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock);
 void ivtv_unfinished_dma(unsigned long arg);
 
-- 
1.6.4.2

