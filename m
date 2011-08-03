Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1HCIDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:03:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48416 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1HCIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:03:07 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p7382rH1031364, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging:rts_pstor:modify thread synchronization flow
Date: Wed, 3 Aug 2011 16:00:25 +0800
X-BOX-Message-Id: p7382rH1031364
Message-ID: <1312358425-8442-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Using different completion variables to synchronize different kernel threads

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx.c |  109 +++++++++++++++-----------------------
 drivers/staging/rts_pstor/rtsx.h |    9 +++-
 2 files changed, 50 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 5ff59f2..16c73fb 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -66,12 +66,6 @@ static int msi_en;
 module_param(msi_en, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(msi_en, "enable msi");
 
-/* These are used to make sure the module doesn't unload before all the
- * threads have exited.
- */
-static atomic_t total_threads = ATOMIC_INIT(0);
-static DECLARE_COMPLETION(threads_gone);
-
 static irqreturn_t rtsx_interrupt(int irq, void *dev_id);
 
 /***********************************************************************
@@ -192,7 +186,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	/* enqueue the command and wake up the control thread */
 	srb->scsi_done = done;
 	chip->srb = srb;
-	up(&(dev->sema));
+	complete(&dev->cmnd_ready);
 
 	return 0;
 }
@@ -475,7 +469,7 @@ static int rtsx_control_thread(void *__dev)
 	current->flags |= PF_NOFREEZE;
 
 	for (;;) {
-		if (down_interruptible(&dev->sema))
+		if (wait_for_completion_interruptible(&dev->cmnd_ready))
 			break;
 
 		/* lock the device pointers */
@@ -557,8 +551,6 @@ SkipForAbort:
 		mutex_unlock(&dev->dev_mutex);
 	} /* for (;;) */
 
-	scsi_host_put(host);
-
 	/* notify the exit routine that we're actually exiting now
 	 *
 	 * complete()/wait_for_completion() is similar to up()/down(),
@@ -573,7 +565,7 @@ SkipForAbort:
 	 * This is important in preemption kernels, which transfer the flow
 	 * of execution immediately upon a complete().
 	 */
-	complete_and_exit(&threads_gone, 0);
+	complete_and_exit(&dev->control_exit, 0);
 }
 
 
@@ -581,7 +573,6 @@ static int rtsx_polling_thread(void *__dev)
 {
 	struct rtsx_dev *dev = (struct rtsx_dev *)__dev;
 	struct rtsx_chip *chip = dev->chip;
-	struct Scsi_Host *host = rtsx_to_host(dev);
 	struct sd_info *sd_card = &(chip->sd_card);
 	struct xd_info *xd_card = &(chip->xd_card);
 	struct ms_info *ms_card = &(chip->ms_card);
@@ -621,8 +612,7 @@ static int rtsx_polling_thread(void *__dev)
 		mutex_unlock(&dev->dev_mutex);
 	}
 
-	scsi_host_put(host);
-	complete_and_exit(&threads_gone, 0);
+	complete_and_exit(&dev->polling_exit, 0);
 }
 
 /*
@@ -699,29 +689,38 @@ static void rtsx_release_resources(struct rtsx_dev *dev)
 {
 	printk(KERN_INFO "-- %s\n", __func__);
 
+	/* Tell the control thread to exit.  The SCSI host must
+	 * already have been removed so it won't try to queue
+	 * any more commands.
+	 */
+	printk(KERN_INFO "-- sending exit command to thread\n");
+	complete(&dev->cmnd_ready);
+	if (dev->ctl_thread)
+		wait_for_completion(&dev->control_exit);
+	if (dev->polling_thread)
+		wait_for_completion(&dev->polling_exit);
+
+	wait_timeout(200);
+
 	if (dev->rtsx_resv_buf) {
-		dma_free_coherent(&(dev->pci->dev), HOST_CMDS_BUF_LEN,
+		dma_free_coherent(&(dev->pci->dev), RTSX_RESV_BUF_LEN,
 				dev->rtsx_resv_buf, dev->rtsx_resv_buf_addr);
 		dev->chip->host_cmds_ptr = NULL;
 		dev->chip->host_sg_tbl_ptr = NULL;
 	}
 
-	pci_disable_device(dev->pci);
-	pci_release_regions(dev->pci);
-
-	if (dev->irq > 0) {
+	if (dev->irq > 0)
 		free_irq(dev->irq, (void *)dev);
-	}
-	if (dev->chip->msi_en) {
+	if (dev->chip->msi_en)
 		pci_disable_msi(dev->pci);
-	}
+	if (dev->remap_addr)
+		iounmap(dev->remap_addr);
 
-	/* Tell the control thread to exit.  The SCSI host must
-	 * already have been removed so it won't try to queue
-	 * any more commands.
-	 */
-	printk(KERN_INFO "-- sending exit command to thread\n");
-	up(&dev->sema);
+	pci_disable_device(dev->pci);
+	pci_release_regions(dev->pci);
+
+	rtsx_release_chip(dev->chip);
+	kfree(dev->chip);
 }
 
 /* First stage of disconnect processing: stop all commands and remove
@@ -739,6 +738,7 @@ static void quiesce_and_remove_host(struct rtsx_dev *dev)
 	scsi_unlock(host);
 	mutex_unlock(&dev->dev_mutex);
 	wake_up(&dev->delay_wait);
+	wait_for_completion(&dev->scanning_done);
 
 	/* Wait some time to let other threads exist */
 	wait_timeout(100);
@@ -793,8 +793,7 @@ static int rtsx_scan_thread(void *__dev)
 		/* Should we unbind if no devices were detected? */
 	}
 
-	scsi_host_put(rtsx_to_host(dev));
-	complete_and_exit(&threads_gone, 0);
+	complete_and_exit(&dev->scanning_done, 0);
 }
 
 static void rtsx_init_options(struct rtsx_chip *chip)
@@ -941,8 +940,11 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 
 	spin_lock_init(&dev->reg_lock);
 	mutex_init(&(dev->dev_mutex));
-	sema_init(&(dev->sema), 0);
+	init_completion(&dev->cmnd_ready);
+	init_completion(&dev->control_exit);
+	init_completion(&dev->polling_exit);
 	init_completion(&(dev->notify));
+	init_completion(&dev->scanning_done);
 	init_waitqueue_head(&dev->delay_wait);
 
 	dev->pci = pci;
@@ -992,28 +994,22 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 	pci_set_master(pci);
 	synchronize_irq(dev->irq);
 
-	err = scsi_add_host(host, &pci->dev);
-	if (err) {
-		printk(KERN_ERR "Unable to add the scsi host\n");
-		goto errout;
-	}
-
 	rtsx_init_chip(dev->chip);
 
 	/* Start up our control thread */
-	th = kthread_create(rtsx_control_thread, dev, CR_DRIVER_NAME);
+	th = kthread_run(rtsx_control_thread, dev, CR_DRIVER_NAME);
 	if (IS_ERR(th)) {
 		printk(KERN_ERR "Unable to start control thread\n");
 		err = PTR_ERR(th);
 		goto errout;
 	}
+	dev->ctl_thread = th;
 
-	/* Take a reference to the host for the control thread and
-	 * count it among all the threads we have launched.  Then
-	 * start it up. */
-	scsi_host_get(rtsx_to_host(dev));
-	atomic_inc(&total_threads);
-	wake_up_process(th);
+	err = scsi_add_host(host, &pci->dev);
+	if (err) {
+		printk(KERN_ERR "Unable to add the scsi host\n");
+		goto errout;
+	}
 
 	/* Start up the thread for delayed SCSI-device scanning */
 	th = kthread_create(rtsx_scan_thread, dev, "rtsx-scan");
@@ -1024,28 +1020,17 @@ static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_device_id
 		goto errout;
 	}
 
-	/* Take a reference to the host for the scanning thread and
-	 * count it among all the threads we have launched.  Then
-	 * start it up. */
-	scsi_host_get(rtsx_to_host(dev));
-	atomic_inc(&total_threads);
 	wake_up_process(th);
 
 	/* Start up the thread for polling thread */
-	th = kthread_create(rtsx_polling_thread, dev, "rtsx-polling");
+	th = kthread_run(rtsx_polling_thread, dev, "rtsx-polling");
 	if (IS_ERR(th)) {
 		printk(KERN_ERR "Unable to start the device-polling thread\n");
 		quiesce_and_remove_host(dev);
 		err = PTR_ERR(th);
 		goto errout;
 	}
-
-	/* Take a reference to the host for the polling thread and
-	 * count it among all the threads we have launched.  Then
-	 * start it up. */
-	scsi_host_get(rtsx_to_host(dev));
-	atomic_inc(&total_threads);
-	wake_up_process(th);
+	dev->polling_thread = th;
 
 	pci_set_drvdata(pci, dev);
 
@@ -1108,16 +1093,6 @@ static void __exit rtsx_exit(void)
 
 	pci_unregister_driver(&driver);
 
-	/* Don't return until all of our control and scanning threads
-	 * have exited.  Since each thread signals threads_gone as its
-	 * last act, we have to call wait_for_completion the right number
-	 * of times.
-	 */
-	while (atomic_read(&total_threads) > 0) {
-		wait_for_completion(&threads_gone);
-		atomic_dec(&total_threads);
-	}
-
 	printk(KERN_INFO "%s module exit\n", CR_DRIVER_NAME);
 }
 
diff --git a/drivers/staging/rts_pstor/rtsx.h b/drivers/staging/rts_pstor/rtsx.h
index 247615b..86e47c2 100644
--- a/drivers/staging/rts_pstor/rtsx.h
+++ b/drivers/staging/rts_pstor/rtsx.h
@@ -112,9 +112,16 @@ struct rtsx_dev {
 	/* locks */
 	spinlock_t 		reg_lock;
 
+	struct task_struct	*ctl_thread;	 /* the control thread   */
+	struct task_struct	*polling_thread; /* the polling thread   */
+
 	/* mutual exclusion and synchronization structures */
-	struct semaphore	sema;		 /* to sleep thread on	    */
+	struct completion	cmnd_ready;	 /* to sleep thread on	    */
+	struct completion	control_exit;	 /* control thread exit	    */
+	struct completion	polling_exit;	 /* polling thread exit	    */
 	struct completion	notify;		 /* thread begin/end	    */
+	struct completion	scanning_done;	 /* wait for scan thread    */
+
 	wait_queue_head_t	delay_wait;	 /* wait during scan, reset */
 	struct mutex		dev_mutex;
 
-- 
1.7.6

