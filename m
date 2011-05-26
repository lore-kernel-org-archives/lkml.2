Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1EZM4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab1EZM4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wz9PjDrauNl7/dhuKj4PhL6mbiosGCYEzVHTepuUz7fHAlcvlwtNxM50zQqMrAJuoB
         vcddvAt1XmmvD9PYhNR24Tvp3KNZG2lh+MC05i98baf44tdLPEqPrenAtGL0F0xSRADQ
         unVgdQf9817FqC0SbnnwlXKrlSpV683JtEQp4=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>,
        stable@kernel.org
Subject: [PATCH 3/5] brd: handle on-demand devices correctly
Date: Thu, 26 May 2011 21:55:55 +0900
Message-Id: <1306414557-2441-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 drivers/block/brd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index e9a19d99f928..b1efa8f9ff42 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -548,7 +548,7 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 	struct kobject *kobj;
 
 	mutex_lock(&brd_devices_mutex);
-	brd = brd_init_one(dev & MINORMASK);
+	brd = brd_init_one(MINOR(dev) >> part_shift);
 	kobj = brd ? get_disk(brd->brd_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&brd_devices_mutex);
 
@@ -589,10 +589,10 @@ static int __init brd_init(void)
 
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
@@ -631,7 +631,7 @@ static void __exit brd_exit(void)
 	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
+	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
-- 
1.7.5.2

