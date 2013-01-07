Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3AGKlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:26455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab3AGKlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="273733510"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 02/11] spi/pxa2xx: convert to the pump message infrastructure
Date: Mon,  7 Jan 2013 12:44:31 +0200
Message-Id: <1357555480-24022-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPI core provides infrastructure for standard message queueing so use
that instead of handling everything in the driver. This simplifies the
driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |  212 +++-------------------------------------------
 1 file changed, 12 insertions(+), 200 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 7fac65d..ad842eb 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -85,9 +85,6 @@ DEFINE_SSP_REG(SSPSP, 0x2c)
 #define DONE_STATE ((void*)2)
 #define ERROR_STATE ((void*)-1)
 
-#define QUEUE_RUNNING 0
-#define QUEUE_STOPPED 1
-
 struct driver_data {
 	/* Driver model hookup */
 	struct platform_device *pdev;
@@ -117,14 +114,6 @@ struct driver_data {
 	u32 clear_sr;
 	u32 mask_sr;
 
-	/* Driver message queue */
-	struct workqueue_struct	*workqueue;
-	struct work_struct pump_messages;
-	spinlock_t lock;
-	struct list_head queue;
-	int busy;
-	int run;
-
 	/* Message Transfer pump */
 	struct tasklet_struct pump_transfers;
 
@@ -173,8 +162,6 @@ struct chip_data {
 	void (*cs_control)(u32 command);
 };
 
-static void pump_messages(struct work_struct *work);
-
 static void cs_assert(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
@@ -444,15 +431,11 @@ static void unmap_dma_buffers(struct driver_data *drv_data)
 static void giveback(struct driver_data *drv_data)
 {
 	struct spi_transfer* last_transfer;
-	unsigned long flags;
 	struct spi_message *msg;
 
-	spin_lock_irqsave(&drv_data->lock, flags);
 	msg = drv_data->cur_msg;
 	drv_data->cur_msg = NULL;
 	drv_data->cur_transfer = NULL;
-	queue_work(drv_data->workqueue, &drv_data->pump_messages);
-	spin_unlock_irqrestore(&drv_data->lock, flags);
 
 	last_transfer = list_entry(msg->transfers.prev,
 					struct spi_transfer,
@@ -481,13 +464,7 @@ static void giveback(struct driver_data *drv_data)
 		 */
 
 		/* get a pointer to the next message, if any */
-		spin_lock_irqsave(&drv_data->lock, flags);
-		if (list_empty(&drv_data->queue))
-			next_msg = NULL;
-		else
-			next_msg = list_entry(drv_data->queue.next,
-					struct spi_message, queue);
-		spin_unlock_irqrestore(&drv_data->lock, flags);
+		next_msg = spi_get_next_queued_message(drv_data->master);
 
 		/* see if the next and current messages point
 		 * to the same chip
@@ -498,10 +475,7 @@ static void giveback(struct driver_data *drv_data)
 			cs_deassert(drv_data);
 	}
 
-	msg->state = NULL;
-	if (msg->complete)
-		msg->complete(msg->context);
-
+	spi_finalize_current_message(drv_data->master);
 	drv_data->cur_chip = NULL;
 }
 
@@ -1176,31 +1150,12 @@ static void pump_transfers(unsigned long data)
 	write_SSCR1(cr1, reg);
 }
 
-static void pump_messages(struct work_struct *work)
+static int pxa2xx_spi_transfer_one_message(struct spi_master *master,
+					   struct spi_message *msg)
 {
-	struct driver_data *drv_data =
-		container_of(work, struct driver_data, pump_messages);
-	unsigned long flags;
-
-	/* Lock queue and check for queue work */
-	spin_lock_irqsave(&drv_data->lock, flags);
-	if (list_empty(&drv_data->queue) || drv_data->run == QUEUE_STOPPED) {
-		drv_data->busy = 0;
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return;
-	}
-
-	/* Make sure we are not already running a message */
-	if (drv_data->cur_msg) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return;
-	}
-
-	/* Extract head of queue */
-	drv_data->cur_msg = list_entry(drv_data->queue.next,
-					struct spi_message, queue);
-	list_del_init(&drv_data->cur_msg->queue);
+	struct driver_data *drv_data = spi_master_get_devdata(master);
 
+	drv_data->cur_msg = msg;
 	/* Initial message state*/
 	drv_data->cur_msg->state = START_STATE;
 	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
@@ -1213,34 +1168,6 @@ static void pump_messages(struct work_struct *work)
 
 	/* Mark as busy and launch transfers */
 	tasklet_schedule(&drv_data->pump_transfers);
-
-	drv_data->busy = 1;
-	spin_unlock_irqrestore(&drv_data->lock, flags);
-}
-
-static int transfer(struct spi_device *spi, struct spi_message *msg)
-{
-	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
-	unsigned long flags;
-
-	spin_lock_irqsave(&drv_data->lock, flags);
-
-	if (drv_data->run == QUEUE_STOPPED) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return -ESHUTDOWN;
-	}
-
-	msg->actual_length = 0;
-	msg->status = -EINPROGRESS;
-	msg->state = START_STATE;
-
-	list_add_tail(&msg->queue, &drv_data->queue);
-
-	if (drv_data->run == QUEUE_RUNNING && !drv_data->busy)
-		queue_work(drv_data->workqueue, &drv_data->pump_messages);
-
-	spin_unlock_irqrestore(&drv_data->lock, flags);
-
 	return 0;
 }
 
@@ -1438,94 +1365,6 @@ static void cleanup(struct spi_device *spi)
 	kfree(chip);
 }
 
-static int init_queue(struct driver_data *drv_data)
-{
-	INIT_LIST_HEAD(&drv_data->queue);
-	spin_lock_init(&drv_data->lock);
-
-	drv_data->run = QUEUE_STOPPED;
-	drv_data->busy = 0;
-
-	tasklet_init(&drv_data->pump_transfers,
-			pump_transfers,	(unsigned long)drv_data);
-
-	INIT_WORK(&drv_data->pump_messages, pump_messages);
-	drv_data->workqueue = create_singlethread_workqueue(
-				dev_name(drv_data->master->dev.parent));
-	if (drv_data->workqueue == NULL)
-		return -EBUSY;
-
-	return 0;
-}
-
-static int start_queue(struct driver_data *drv_data)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&drv_data->lock, flags);
-
-	if (drv_data->run == QUEUE_RUNNING || drv_data->busy) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return -EBUSY;
-	}
-
-	drv_data->run = QUEUE_RUNNING;
-	drv_data->cur_msg = NULL;
-	drv_data->cur_transfer = NULL;
-	drv_data->cur_chip = NULL;
-	spin_unlock_irqrestore(&drv_data->lock, flags);
-
-	queue_work(drv_data->workqueue, &drv_data->pump_messages);
-
-	return 0;
-}
-
-static int stop_queue(struct driver_data *drv_data)
-{
-	unsigned long flags;
-	unsigned limit = 500;
-	int status = 0;
-
-	spin_lock_irqsave(&drv_data->lock, flags);
-
-	/* This is a bit lame, but is optimized for the common execution path.
-	 * A wait_queue on the drv_data->busy could be used, but then the common
-	 * execution path (pump_messages) would be required to call wake_up or
-	 * friends on every SPI message. Do this instead */
-	drv_data->run = QUEUE_STOPPED;
-	while ((!list_empty(&drv_data->queue) || drv_data->busy) && limit--) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		msleep(10);
-		spin_lock_irqsave(&drv_data->lock, flags);
-	}
-
-	if (!list_empty(&drv_data->queue) || drv_data->busy)
-		status = -EBUSY;
-
-	spin_unlock_irqrestore(&drv_data->lock, flags);
-
-	return status;
-}
-
-static int destroy_queue(struct driver_data *drv_data)
-{
-	int status;
-
-	status = stop_queue(drv_data);
-	/* we are unloading the module or failing to load (only two calls
-	 * to this routine), and neither call can handle a return value.
-	 * However, destroy_workqueue calls flush_workqueue, and that will
-	 * block until all work is done.  If the reason that stop_queue
-	 * timed out is that the work will never finish, then it does no
-	 * good to call destroy_workqueue, so return anyway. */
-	if (status != 0)
-		return status;
-
-	destroy_workqueue(drv_data->workqueue);
-
-	return 0;
-}
-
 static int pxa2xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1566,7 +1405,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
 	master->setup = setup;
-	master->transfer = transfer;
+	master->transfer_one_message = pxa2xx_spi_transfer_one_message;
 
 	drv_data->ssp_type = ssp->type;
 	drv_data->null_dma_buf = (u32 *)PTR_ALIGN(drv_data + 1, 8);
@@ -1639,31 +1478,19 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		write_SSTO(0, drv_data->ioaddr);
 	write_SSPSP(0, drv_data->ioaddr);
 
-	/* Initial and start queue */
-	status = init_queue(drv_data);
-	if (status != 0) {
-		dev_err(&pdev->dev, "problem initializing queue\n");
-		goto out_error_clock_enabled;
-	}
-	status = start_queue(drv_data);
-	if (status != 0) {
-		dev_err(&pdev->dev, "problem starting queue\n");
-		goto out_error_clock_enabled;
-	}
+	tasklet_init(&drv_data->pump_transfers, pump_transfers,
+		     (unsigned long)drv_data);
 
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
 	status = spi_register_master(master);
 	if (status != 0) {
 		dev_err(&pdev->dev, "problem registering spi master\n");
-		goto out_error_queue_alloc;
+		goto out_error_clock_enabled;
 	}
 
 	return status;
 
-out_error_queue_alloc:
-	destroy_queue(drv_data);
-
 out_error_clock_enabled:
 	clk_disable(ssp->clk);
 
@@ -1686,26 +1513,11 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	struct ssp_device *ssp;
-	int status = 0;
 
 	if (!drv_data)
 		return 0;
 	ssp = drv_data->ssp;
 
-	/* Remove the queue */
-	status = destroy_queue(drv_data);
-	if (status != 0)
-		/* the kernel does not check the return status of this
-		 * this routine (mod->exit, within the kernel).  Therefore
-		 * nothing is gained by returning from here, the module is
-		 * going away regardless, and we should not leave any more
-		 * resources allocated than necessary.  We cannot free the
-		 * message memory in drv_data->queue, but we can release the
-		 * resources below.  I think the kernel should honor -EBUSY
-		 * returns but... */
-		dev_err(&pdev->dev, "pxa2xx_spi_remove: workqueue will not "
-			"complete, message memory not freed\n");
-
 	/* Disable the SSP at the peripheral and SOC level */
 	write_SSCR0(0, drv_data->ioaddr);
 	clk_disable(ssp->clk);
@@ -1748,7 +1560,7 @@ static int pxa2xx_spi_suspend(struct device *dev)
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
-	status = stop_queue(drv_data);
+	status = spi_master_suspend(drv_data->master);
 	if (status != 0)
 		return status;
 	write_SSCR0(0, drv_data->ioaddr);
@@ -1774,7 +1586,7 @@ static int pxa2xx_spi_resume(struct device *dev)
 	clk_enable(ssp->clk);
 
 	/* Start the queue running */
-	status = start_queue(drv_data);
+	status = spi_master_resume(drv_data->master);
 	if (status != 0) {
 		dev_err(dev, "problem starting queue (%d)\n", status);
 		return status;
-- 
1.7.10.4

