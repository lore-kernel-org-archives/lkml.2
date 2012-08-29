Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2H2B3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:29:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2H2B3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:29:37 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] staging/rts_pstor: Use pr_ printks in rtsx.c
Date: Wed, 29 Aug 2012 10:29:26 +0900
Message-Id: <1346203766-5939-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed some checkpatch warnings.
-WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
-WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
-WARNING: quoted string split across lines

And added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx.c |  107 +++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 5fb05a2..a44f630 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -20,6 +20,8 @@
  *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
@@ -170,14 +172,14 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 
 	/* check for state-transition errors */
 	if (chip->srb != NULL) {
-		printk(KERN_ERR "Error in %s: chip->srb = %p\n",
-			__func__, chip->srb);
+		pr_err("Error in %s: chip->srb = %p\n",
+		       __func__, chip->srb);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* fail the command if we are disconnecting */
 	if (rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
-		printk(KERN_INFO "Fail command during disconnect\n");
+		pr_info("Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
 		return 0;
@@ -204,14 +206,14 @@ static int command_abort(struct scsi_cmnd *srb)
 	struct rtsx_dev *dev = host_to_rtsx(host);
 	struct rtsx_chip *chip = dev->chip;
 
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_info("%s called\n", __func__);
 
 	scsi_lock(host);
 
 	/* Is this command still active? */
 	if (chip->srb != srb) {
 		scsi_unlock(host);
-		printk(KERN_INFO "-- nothing to abort\n");
+		pr_info("-- nothing to abort\n");
 		return FAILED;
 	}
 
@@ -231,7 +233,7 @@ static int device_reset(struct scsi_cmnd *srb)
 {
 	int result = 0;
 
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_info("%s called\n", __func__);
 
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -241,7 +243,7 @@ static int bus_reset(struct scsi_cmnd *srb)
 {
 	int result = 0;
 
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_info("%s called\n", __func__);
 
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -303,14 +305,14 @@ static int rtsx_acquire_irq(struct rtsx_dev *dev)
 {
 	struct rtsx_chip *chip = dev->chip;
 
-	printk(KERN_INFO "%s: chip->msi_en = %d, pci->irq = %d\n",
-			__func__, chip->msi_en, dev->pci->irq);
+	pr_info("%s: chip->msi_en = %d, pci->irq = %d\n",
+		__func__, chip->msi_en, dev->pci->irq);
 
 	if (request_irq(dev->pci->irq, rtsx_interrupt,
 			chip->msi_en ? 0 : IRQF_SHARED,
 			CR_DRIVER_NAME, dev)) {
-		printk(KERN_ERR "rtsx: unable to grab IRQ %d, "
-		       "disabling device\n", dev->pci->irq);
+		pr_err("unable to grab IRQ %d, disabling device\n",
+		       dev->pci->irq);
 		return -1;
 	}
 
@@ -347,10 +349,10 @@ static int rtsx_suspend(struct pci_dev *pci, pm_message_t state)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	printk(KERN_INFO "Ready to suspend\n");
+	pr_info("Ready to suspend\n");
 
 	if (!dev) {
-		printk(KERN_ERR "Invalid memory\n");
+		pr_err("Invalid memory\n");
 		return 0;
 	}
 
@@ -386,10 +388,10 @@ static int rtsx_resume(struct pci_dev *pci)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	printk(KERN_INFO "Ready to resume\n");
+	pr_info("Ready to resume\n");
 
 	if (!dev) {
-		printk(KERN_ERR "Invalid memory\n");
+		pr_err("Invalid memory\n");
 		return 0;
 	}
 
@@ -401,8 +403,7 @@ static int rtsx_resume(struct pci_dev *pci)
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
 	if (pci_enable_device(pci) < 0) {
-		printk(KERN_ERR "%s: pci_enable_device failed, "
-		       "disabling device\n", CR_DRIVER_NAME);
+		pr_err("pci_enable_device failed, disabling device\n");
 		/* unlock the device pointers */
 		mutex_unlock(&dev->dev_mutex);
 		return -EIO;
@@ -435,10 +436,10 @@ static void rtsx_shutdown(struct pci_dev *pci)
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 	struct rtsx_chip *chip;
 
-	printk(KERN_INFO "Ready to shutdown\n");
+	pr_info("Ready to shutdown\n");
 
 	if (!dev) {
-		printk(KERN_ERR "Invalid memory\n");
+		pr_err("Invalid memory\n");
 		return;
 	}
 
@@ -475,7 +476,7 @@ static int rtsx_control_thread(void *__dev)
 
 		/* if the device has disconnected, we are free to exit */
 		if (rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
-			printk(KERN_INFO "-- rtsx-control exiting\n");
+			pr_info("-- rtsx-control exiting\n");
 			mutex_unlock(&dev->dev_mutex);
 			break;
 		}
@@ -495,7 +496,7 @@ static int rtsx_control_thread(void *__dev)
 		 * is UNKNOWN
 		 */
 		if (chip->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
-			printk(KERN_ERR "UNKNOWN data direction\n");
+			pr_err("UNKNOWN data direction\n");
 			chip->srb->result = DID_ERROR << 16;
 		}
 
@@ -503,16 +504,16 @@ static int rtsx_control_thread(void *__dev)
 		 * the maximum known LUN
 		 */
 		else if (chip->srb->device->id) {
-			printk(KERN_ERR "Bad target number (%d:%d)\n",
-				chip->srb->device->id,
-				chip->srb->device->lun);
+			pr_err("Bad target number (%d:%d)\n",
+			       chip->srb->device->id,
+			       chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (chip->srb->device->lun > chip->max_lun) {
-			printk(KERN_ERR "Bad LUN (%d:%d)\n",
-				chip->srb->device->id,
-				chip->srb->device->lun);
+			pr_err("Bad LUN (%d:%d)\n",
+			       chip->srb->device->id,
+			       chip->srb->device->lun);
 			chip->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -534,7 +535,7 @@ static int rtsx_control_thread(void *__dev)
 			chip->srb->scsi_done(chip->srb);
 		} else {
 SkipForAbort:
-			printk(KERN_ERR "scsi command aborted\n");
+			pr_err("scsi command aborted\n");
 		}
 
 		if (rtsx_chk_stat(chip, RTSX_STAT_ABORT)) {
@@ -594,7 +595,7 @@ static int rtsx_polling_thread(void *__dev)
 
 		/* if the device has disconnected, we are free to exit */
 		if (rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
-			printk(KERN_INFO "-- rtsx-polling exiting\n");
+			pr_info("-- rtsx-polling exiting\n");
 			mutex_unlock(&dev->dev_mutex);
 			break;
 		}
@@ -683,13 +684,13 @@ Exit:
 /* Release all our dynamic resources */
 static void rtsx_release_resources(struct rtsx_dev *dev)
 {
-	printk(KERN_INFO "-- %s\n", __func__);
+	pr_info("-- %s\n", __func__);
 
 	/* Tell the control thread to exit.  The SCSI host must
 	 * already have been removed so it won't try to queue
 	 * any more commands.
 	 */
-	printk(KERN_INFO "-- sending exit command to thread\n");
+	pr_info("-- sending exit command to thread\n");
 	complete(&dev->cmnd_ready);
 	if (dev->ctl_thread)
 		wait_for_completion(&dev->control_exit);
@@ -774,8 +775,7 @@ static int rtsx_scan_thread(void *__dev)
 
 	/* Wait for the timeout to expire or for a disconnect */
 	if (delay_use > 0) {
-		printk(KERN_INFO "%s: waiting for device "
-				"to settle before scanning\n", CR_DRIVER_NAME);
+		pr_info("waiting for device to settle before scanning\n");
 		wait_event_interruptible_timeout(dev->delay_wait,
 				rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT),
 				delay_use * HZ);
@@ -784,7 +784,7 @@ static int rtsx_scan_thread(void *__dev)
 	/* If the device is still connected, perform the scanning */
 	if (!rtsx_chk_stat(chip, RTSX_STAT_DISCONNECT)) {
 		scsi_scan_host(rtsx_to_host(dev));
-		printk(KERN_INFO "%s: device scan complete\n", CR_DRIVER_NAME);
+		pr_info("device scan complete\n");
 
 		/* Should we unbind if no devices were detected? */
 	}
@@ -906,13 +906,13 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 
 	err = pci_enable_device(pci);
 	if (err < 0) {
-		printk(KERN_ERR "PCI enable device failed!\n");
+		pr_err("PCI enable device failed!\n");
 		return err;
 	}
 
 	err = pci_request_regions(pci, CR_DRIVER_NAME);
 	if (err < 0) {
-		printk(KERN_ERR "PCI request regions for %s failed!\n",
+		pr_err("PCI request regions for %s failed!\n",
 		       CR_DRIVER_NAME);
 		pci_disable_device(pci);
 		return err;
@@ -924,7 +924,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	 */
 	host = scsi_host_alloc(&rtsx_host_template, sizeof(*dev));
 	if (!host) {
-		printk(KERN_ERR "Unable to allocate the scsi host\n");
+		pr_err("Unable to allocate the scsi host\n");
 		pci_release_regions(pci);
 		pci_disable_device(pci);
 		return -ENOMEM;
@@ -949,12 +949,12 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	dev->pci = pci;
 	dev->irq = -1;
 
-	printk(KERN_INFO "Resource length: 0x%x\n",
-	       (unsigned int)pci_resource_len(pci, 0));
+	pr_info("Resource length: 0x%x\n",
+		(unsigned int)pci_resource_len(pci, 0));
 	dev->addr = pci_resource_start(pci, 0);
 	dev->remap_addr = ioremap_nocache(dev->addr, pci_resource_len(pci, 0));
 	if (dev->remap_addr == NULL) {
-		printk(KERN_ERR "ioremap error\n");
+		pr_err("ioremap error\n");
 		err = -ENXIO;
 		goto errout;
 	}
@@ -963,13 +963,13 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	 * Using "unsigned long" cast here to eliminate gcc warning in
 	 * 64-bit system
 	 */
-	printk(KERN_INFO "Original address: 0x%lx, remapped address: 0x%lx\n",
-	       (unsigned long)(dev->addr), (unsigned long)(dev->remap_addr));
+	pr_info("Original address: 0x%lx, remapped address: 0x%lx\n",
+		(unsigned long)(dev->addr), (unsigned long)(dev->remap_addr));
 
 	dev->rtsx_resv_buf = dma_alloc_coherent(&(pci->dev), RTSX_RESV_BUF_LEN,
 			&(dev->rtsx_resv_buf_addr), GFP_KERNEL);
 	if (dev->rtsx_resv_buf == NULL) {
-		printk(KERN_ERR "alloc dma buffer fail\n");
+		pr_err("alloc dma buffer fail\n");
 		err = -ENXIO;
 		goto errout;
 	}
@@ -983,7 +983,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 
 	rtsx_init_options(dev->chip);
 
-	printk(KERN_INFO "pci->irq = %d\n", pci->irq);
+	pr_info("pci->irq = %d\n", pci->irq);
 
 	if (dev->chip->msi_en) {
 		if (pci_enable_msi(pci) < 0)
@@ -1008,7 +1008,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	/* Start up our control thread */
 	th = kthread_run(rtsx_control_thread, dev, CR_DRIVER_NAME);
 	if (IS_ERR(th)) {
-		printk(KERN_ERR "Unable to start control thread\n");
+		pr_err("Unable to start control thread\n");
 		err = PTR_ERR(th);
 		goto errout;
 	}
@@ -1016,14 +1016,14 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 
 	err = scsi_add_host(host, &pci->dev);
 	if (err) {
-		printk(KERN_ERR "Unable to add the scsi host\n");
+		pr_err("Unable to add the scsi host\n");
 		goto errout;
 	}
 
 	/* Start up the thread for delayed SCSI-device scanning */
 	th = kthread_run(rtsx_scan_thread, dev, "rtsx-scan");
 	if (IS_ERR(th)) {
-		printk(KERN_ERR "Unable to start the device-scanning thread\n");
+		pr_err("Unable to start the device-scanning thread\n");
 		complete(&dev->scanning_done);
 		quiesce_and_remove_host(dev);
 		err = PTR_ERR(th);
@@ -1033,7 +1033,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	/* Start up the thread for polling thread */
 	th = kthread_run(rtsx_polling_thread, dev, "rtsx-polling");
 	if (IS_ERR(th)) {
-		printk(KERN_ERR "Unable to start the device-polling thread\n");
+		pr_err("Unable to start the device-polling thread\n");
 		quiesce_and_remove_host(dev);
 		err = PTR_ERR(th);
 		goto errout;
@@ -1046,7 +1046,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 
 	/* We come here if there are any problems */
 errout:
-	printk(KERN_ERR "rtsx_probe() failed\n");
+	pr_err("rtsx_probe() failed\n");
 	release_everything(dev);
 
 	return err;
@@ -1057,7 +1057,7 @@ static void __devexit rtsx_remove(struct pci_dev *pci)
 {
 	struct rtsx_dev *dev = (struct rtsx_dev *)pci_get_drvdata(pci);
 
-	printk(KERN_INFO "rtsx_remove() called\n");
+	pr_info("rtsx_remove() called\n");
 
 	quiesce_and_remove_host(dev);
 	release_everything(dev);
@@ -1090,20 +1090,21 @@ static struct pci_driver driver = {
 
 static int __init rtsx_init(void)
 {
-	printk(KERN_INFO "Initializing Realtek PCIE storage driver...\n");
+	pr_info("Initializing Realtek PCIE storage driver...\n");
 
 	return pci_register_driver(&driver);
 }
 
 static void __exit rtsx_exit(void)
 {
-	printk(KERN_INFO "rtsx_exit() called\n");
+	pr_info("rtsx_exit() called\n");
 
 	pci_unregister_driver(&driver);
 
-	printk(KERN_INFO "%s module exit\n", CR_DRIVER_NAME);
+	pr_info("%s module exit\n", CR_DRIVER_NAME);
 }
 
+
 module_init(rtsx_init)
 module_exit(rtsx_exit)
 
-- 
1.7.9.5

