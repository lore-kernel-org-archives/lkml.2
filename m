Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0GCWCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:02:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0GCWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 5/8] dasd: no need for BKL in ioctl
Date: Sun,  4 Jul 2010 00:02:29 +0200
Message-Id: <1278194552-24943-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HpPriIbXzaJTaomEWHH8Cq2Lbu0dSri3aG/KpnUk39V
 GDK+Dnd8NOzsPD77SRulQxfBVfQvBmnMBmGrPrhbV9KwxfNndw
 DL5gKSsbSNU/MgNdweGJlpFAqBxaepwwlKuGSv0yIOz9z42MCy
 yY78OA+PqJ+354D5XIGkQVWM9sk+6nfluzYKndGeyK0tR9KWSJ
 BIhqCSVkmdRPfMSFq9iSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dasd driver does not need the BKL, so we can
remove it here as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/block/dasd_ioctl.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 1557214..26075e9 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -16,7 +16,6 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
@@ -370,9 +369,8 @@ static int dasd_ioctl_readall_cmb(struct dasd_block *block, unsigned int cmd,
 	return ret;
 }
 
-static int
-dasd_do_ioctl(struct block_device *bdev, fmode_t mode,
-	      unsigned int cmd, unsigned long arg)
+int dasd_ioctl(struct block_device *bdev, fmode_t mode,
+	       unsigned int cmd, unsigned long arg)
 {
 	struct dasd_block *block = bdev->bd_disk->private_data;
 	void __user *argp;
@@ -430,14 +428,3 @@ dasd_do_ioctl(struct block_device *bdev, fmode_t mode,
 		return -EINVAL;
 	}
 }
-
-int dasd_ioctl(struct block_device *bdev, fmode_t mode,
-	       unsigned int cmd, unsigned long arg)
-{
-	int rc;
-
-	lock_kernel();
-	rc = dasd_do_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
-	return rc;
-}
-- 
1.7.1

