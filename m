Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797Ab2EJRhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:37:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762Ab2EJRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:58 -0400
Message-Id: <20120510173137.073215791@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ryosuke Saito <raitosyo@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 48/52] mtip32xx: fix error handling in mtip_init()
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Saito <raitosyo@gmail.com>

commit 6d27f09a6398ee086b11804aa3a16609876f0c7c upstream.

Ensure that block device is properly unregistered, if
pci_register_driver() fails.

Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3605,18 +3605,25 @@ MODULE_DEVICE_TABLE(pci, mtip_pci_tbl);
  */
 static int __init mtip_init(void)
 {
+	int error;
+
 	printk(KERN_INFO MTIP_DRV_NAME " Version " MTIP_DRV_VERSION "\n");
 
 	/* Allocate a major block device number to use with this driver. */
-	mtip_major = register_blkdev(0, MTIP_DRV_NAME);
-	if (mtip_major < 0) {
+	error = register_blkdev(0, MTIP_DRV_NAME);
+	if (error <= 0) {
 		printk(KERN_ERR "Unable to register block device (%d)\n",
-		mtip_major);
+		error);
 		return -EBUSY;
 	}
+	mtip_major = error;
 
 	/* Register our PCI operations. */
-	return pci_register_driver(&mtip_pci_driver);
+	error = pci_register_driver(&mtip_pci_driver);
+	if (error)
+		unregister_blkdev(mtip_major, MTIP_DRV_NAME);
+
+	return error;
 }
 
 /*


