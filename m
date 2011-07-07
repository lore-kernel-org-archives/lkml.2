Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1GGLcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:32:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab1GGLc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:32:29 -0400
Message-ID: <4E159945.8050900@gmail.com>
Date: Thu, 07 Jul 2011 13:32:21 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
CC: devel@linuxdriverproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [staging] mei: Enable msi when supported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
Tested suspend/resume, driver (re/un)loading. Comments welcome. :)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index bfd1b46..58106bf 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -121,6 +121,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 {
 	struct mei_device *dev;
 	int err;
+	unsigned long flags = 0;
 
 	mutex_lock(&mei_mutex);
 	if (mei_device) {
@@ -154,11 +155,13 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		err = -ENOMEM;
 		goto free_device;
 	}
+	if (pci_enable_msi(pdev) < 0)
+		flags |= IRQF_SHARED;
 	/* request and enable interrupt   */
 	err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
 			mei_interrupt_thread_handler,
-			IRQF_SHARED, mei_driver_name, dev);
+			flags, mei_driver_name, dev);
 	if (err) {
 		printk(KERN_ERR "mei: request_threaded_irq failure. irq = %d\n",
 		       pdev->irq);
@@ -186,6 +189,7 @@ release_irq:
 	mei_disable_interrupts(dev);
 	flush_scheduled_work();
 	free_irq(pdev->irq, dev);
+	pci_disable_msi(pdev);
 unmap_memory:
 	pci_iounmap(pdev, dev->mem_addr);
 free_device:
@@ -250,6 +254,7 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 	mei_disable_interrupts(dev);
 
 	free_irq(pdev->irq, dev);
+	pci_disable_msi(pdev);
 	pci_set_drvdata(pdev, NULL);
 
 	if (dev->mem_addr)
@@ -1103,7 +1108,7 @@ static int mei_pci_suspend(struct device *device)
 	mutex_unlock(&dev->device_lock);
 
 	free_irq(pdev->irq, dev);
-
+	pci_disable_msi(pdev);
 
 	return err;
 }
@@ -1113,16 +1118,19 @@ static int mei_pci_resume(struct device *device)
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mei_device *dev;
 	int err;
+	unsigned long flags = 0;
 
 	dev = pci_get_drvdata(pdev);
 	if (!dev)
 		return -ENODEV;
 
+	if (pci_enable_msi(pdev) < 0)
+		flags |= IRQF_SHARED;
 	/* request and enable interrupt   */
 	err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
 			mei_interrupt_thread_handler,
-			IRQF_SHARED, mei_driver_name, dev);
+			flags, mei_driver_name, dev);
 	if (err) {
 		printk(KERN_ERR "mei: Request_irq failure. irq = %d\n",
 		       pdev->irq);


