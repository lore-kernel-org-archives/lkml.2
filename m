Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935862Ab0HFTye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:54:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761801Ab0HFTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=c5oLYWClvw0MzPFpMcwAf6yDUXiRFbWfCkN9gl5j3pUs1848ZmTnLX8ChHTYkMVlBu
         GlweOooAcmOdQuQWfFb8PtG/ErRnHWCHqlejCrmKYtP7pmxmuT/cyVDtXj5gQomWmVib
         G4BEgU9nIcD6LJtS4Kywmxa+S6qMg1TSigU48=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
        Olimpiu Pascariu <olimpiu.pascariu@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] staging: cx25821: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:52:57 +0400
Message-Id: <1281124379-13796-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/cx25821/cx25821-core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index c487c19..ad7ce01 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -962,7 +962,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 		       dev->pci->subsystem_device);
 
 		cx25821_devcount--;
-		return -ENODEV;
+		return -EBUSY;
 	}
 
 	/* PCIe stuff */
@@ -1412,9 +1412,12 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 
 	printk(KERN_INFO "cx25821 Athena pci enable !\n");
 
-	if (cx25821_dev_setup(dev) < 0) {
-		err = -EINVAL;
-		goto fail_unregister_device;
+	err = cx25821_dev_setup(dev);
+	if (err) {
+		if (err == -EBUSY)
+			goto fail_unregister_device;
+		else
+			goto fail_unregister_pci;
 	}
 
 	/* print pci info */
@@ -1448,6 +1451,8 @@ fail_irq:
 	printk(KERN_INFO "cx25821 cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
+fail_unregister_pci:
+	pci_disable_device(pci_dev);
 fail_unregister_device:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
-- 
1.7.0.4

