Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1G0WHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:07:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:17376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1G0Vs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32274628"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: namhyung@gmail.com, Laurent.Vivier@bull.net, jaxboe@fusionio.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [30/99] brd: handle on-demand devices correctly
Message-Id: <20110727214828.D4B722403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Namhyung Kim <namhyung@gmail.com>

commit af46566885a373b0a526932484cd8fef8de7b598 upstream.

When finding or allocating a ram disk device, brd_probe() did not take
partition numbers into account so that it can result to a different
device. Consider following example (I set CONFIG_BLK_DEV_RAM_COUNT=4
for simplicity) :

$ sudo modprobe brd max_part=15
$ ls -l /dev/ram*
brw-rw---- 1 root disk 1,  0 2011-05-25 15:41 /dev/ram0
brw-rw---- 1 root disk 1, 16 2011-05-25 15:41 /dev/ram1
brw-rw---- 1 root disk 1, 32 2011-05-25 15:41 /dev/ram2
brw-rw---- 1 root disk 1, 48 2011-05-25 15:41 /dev/ram3
$ sudo mknod /dev/ram4 b 1 64
$ sudo dd if=/dev/zero of=/dev/ram4 bs=4k count=256
256+0 records in
256+0 records out
1048576 bytes (1.0 MB) copied, 0.00215578 s, 486 MB/s
namhyung@leonhard:linux$ ls -l /dev/ram*
brw-rw---- 1 root disk 1,    0 2011-05-25 15:41 /dev/ram0
brw-rw---- 1 root disk 1,   16 2011-05-25 15:41 /dev/ram1
brw-rw---- 1 root disk 1,   32 2011-05-25 15:41 /dev/ram2
brw-rw---- 1 root disk 1,   48 2011-05-25 15:41 /dev/ram3
brw-r--r-- 1 root root 1,   64 2011-05-25 15:45 /dev/ram4
brw-rw---- 1 root disk 1, 1024 2011-05-25 15:44 /dev/ram64

After this patch, /dev/ram4 - instead of /dev/ram64 - was
accessed correctly.

In addition, 'range' passed to blk_register_region() should
include all range of dev_t that RAMDISK_MAJOR can address.
It does not need to be limited by partition numbers unless
'rd_nr' param was specified.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/block/brd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/block/brd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/block/brd.c
+++ linux-2.6.35.y/drivers/block/brd.c
@@ -549,7 +549,7 @@ static struct kobject *brd_probe(dev_t d
 	struct kobject *kobj;
 
 	mutex_lock(&brd_devices_mutex);
-	brd = brd_init_one(dev & MINORMASK);
+	brd = brd_init_one(MINOR(dev) >> part_shift);
 	kobj = brd ? get_disk(brd->brd_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&brd_devices_mutex);
 
@@ -590,10 +590,10 @@ static int __init brd_init(void)
 
 	if (rd_nr) {
 		nr = rd_nr;
-		range = rd_nr;
+		range = rd_nr << part_shift;
 	} else {
 		nr = CONFIG_BLK_DEV_RAM_COUNT;
-		range = 1UL << (MINORBITS - part_shift);
+		range = 1UL << MINORBITS;
 	}
 
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
@@ -632,7 +632,7 @@ static void __exit brd_exit(void)
 	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
+	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
