Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1BYO2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:28:22 -0500
Received: from fep32.mx.upcmail.net ([62.179.121.50]:64979 "EHLO
	fep32.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab1BYO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:28:21 -0500
X-SourceIP: 78.102.42.209
Date: Fri, 25 Feb 2011 15:27:29 +0100
From: Petr Uzel <petr.uzel@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] block: kill loop_mutex
Message-ID: <20110225142729.GA4029@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Cloudmark-Analysis: v=1.1 cv=kR4HTYXl3FXdRAFjS5RpcnDbDNViz/VYMWXR75RtSM0= c=1 sm=0 a=AyT_rQ6v2KAA:10 a=kj9zAlcOel0A:10 a=YgUFFZ79AAAA:8 a=1nSz6Ew-AAAA:8 a=VwQbUJbxAAAA:8 a=RzDwf6Uq8B1ls9frvZkA:9 a=tPwOqrpweMIfdP0nBq0A:7 a=qVc4xEfQzbJ2yAaiAfTzZIqYogEA:4 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following steps lead to deadlock in kernel:

dd if=/dev/zero of=img bs=512 count=1000
losetup -f img
mkfs.ext2 /dev/loop0
mount -t ext2 -o loop /dev/loop0 mnt
umount mnt/

Stacktrace:
[<c102ec04>] irq_exit+0x36/0x59
[<c101502c>] smp_apic_timer_interrupt+0x6b/0x75
[<c127f639>] apic_timer_interrupt+0x31/0x38
[<c101df88>] mutex_spin_on_owner+0x54/0x5b
[<fe2250e9>] lo_release+0x12/0x67 [loop]
[<c10c4eae>] __blkdev_put+0x7c/0x10c
[<c10a4da5>] fput+0xd5/0x1aa
[<fe2250cf>] loop_clr_fd+0x1a9/0x1b1 [loop]
[<fe225110>] lo_release+0x39/0x67 [loop]
[<c10c4eae>] __blkdev_put+0x7c/0x10c
[<c10a59d9>] deactivate_locked_super+0x17/0x36
[<c10b6f37>] sys_umount+0x27e/0x2a5
[<c10b6f69>] sys_oldumount+0xb/0xe
[<c1002897>] sysenter_do_call+0x12/0x26
[<ffffffff>] 0xffffffff

Regression since 2a48fc0ab24241755dc9, which introduced the private
loop_mutex as part of the BKL removal process.

As per [1], the mutex can be safely removed.

[1] http://www.gossamer-threads.com/lists/linux/kernel/1341930

Addresses: https://bugzilla.novell.com/show_bug.cgi?id=669394
Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=29172

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/block/loop.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 49e6a54..dbf31ec 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -78,7 +78,6 @@
 
 #include <asm/uaccess.h>
 
-static DEFINE_MUTEX(loop_mutex);
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
@@ -1501,11 +1500,9 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	mutex_unlock(&loop_mutex);
 
 	return 0;
 }
@@ -1515,7 +1512,6 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 	struct loop_device *lo = disk->private_data;
 	int err;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
@@ -1540,7 +1536,6 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
-	mutex_unlock(&loop_mutex);
 	return 0;
 }
 
-- 
1.7.2.3
