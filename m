Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0IPRtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:49:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0IPRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org
Subject: [PATCH 07/12] BKL: Remove BKL from USB gadgetfs
Date: Thu, 16 Sep 2010 19:46:20 +0200
Message-Id: <1284659185-8942-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hOWS7Glb5Qv751N6++ciIqH/WNxOpEfjOLzsvt4Tich
 FFogr4ovDX5gQGUmuIBDx4f/pz6B/fsAU9WYoGBXBh5f4yz9HJ
 0ymhkS9Klc77Pi2PlgT0XdJnGWAV0ehJU9Xb9IoapnO85GElNv
 HOzKU1wVi7m6ivq7wRTmd0j/Rt4ebFwtLoGfzQ5HIvlN96cb9h
 qE4yaIJBs5OP5FyJztXCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in fill_super, which is  protected by the superblocks
s_umount rw_semaphore. Therefore it is safe to remove the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/inode.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 82a88d3..3f1d771 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -33,7 +33,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -2043,19 +2042,13 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 	struct dentry	*d;
 	struct dev_data	*dev;
 
-	lock_kernel();
-
-	if (the_device) {
-		unlock_kernel();
+	if (the_device)
 		return -ESRCH;
-	}
 
 	/* fake probe to determine $CHIP */
 	(void) usb_gadget_register_driver (&probe_driver);
-	if (!CHIP) {
-		unlock_kernel();
+	if (!CHIP)
 		return -ENODEV;
-	}
 
 	/* superblock */
 	sb->s_blocksize = PAGE_CACHE_SIZE;
@@ -2092,7 +2085,6 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 	 * from binding to a controller.
 	 */
 	the_device = dev;
-	unlock_kernel();
 	return 0;
 
 enomem3:
@@ -2102,7 +2094,6 @@ enomem2:
 enomem1:
 	iput (inode);
 enomem0:
-	unlock_kernel();
 	return -ENOMEM;
 }
 
-- 
1.7.1

