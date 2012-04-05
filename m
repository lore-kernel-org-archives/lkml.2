Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2DEK5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:57:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61827 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2DEK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:57:04 -0400
Subject: [PATCH] mtip32xx: fix error handling in mtip_init()
From: Ryosuke Saito <raitosyo@gmail.com>
To: axboe@kernel.dk
Cc: asamymuthupa@micron.com, sbradshaw@micron.com, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Apr 2012 19:55:51 +0900
Message-ID: <1333623351.3193.10.camel@HDL00099>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sweep registered blkdev when pci_register_driver has failed.

Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 8eb81c9..1000d19 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3608,18 +3608,25 @@ MODULE_DEVICE_TABLE(pci, mtip_pci_tbl);
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
-- 
1.7.9.6

