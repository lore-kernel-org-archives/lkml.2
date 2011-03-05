Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1CEBBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:01:05 -0500
Received: from kroah.org ([198.145.64.141]:50484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab1CEBA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.831280368@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Petr Uzel <petr.uzel@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [64/73] block: kill loop_mutex
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Petr Uzel <petr.uzel@suse.cz>

commit fd51469fb68b987032e46297e0a4fe9020063c20 upstream.

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
Reviewed-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/loop.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -78,7 +78,6 @@
 
 #include <asm/uaccess.h>
 
-static DEFINE_MUTEX(loop_mutex);
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
@@ -1505,11 +1504,9 @@ static int lo_open(struct block_device *
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	mutex_unlock(&loop_mutex);
 
 	return 0;
 }
@@ -1519,7 +1516,6 @@ static int lo_release(struct gendisk *di
 	struct loop_device *lo = disk->private_data;
 	int err;
 
-	mutex_lock(&loop_mutex);
 	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
@@ -1544,7 +1540,6 @@ static int lo_release(struct gendisk *di
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
-	mutex_unlock(&loop_mutex);
 	return 0;
 }
 


