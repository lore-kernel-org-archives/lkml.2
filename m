Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1EXOgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:36:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38592 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1EXOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PDb1u0+XtbrCKefmBx1o6taEyESyzpzUDnZ7Z54q3OC11KrcTpiRp652cjrJTKuHCC
         59Kx4D7fSqWKAH2RBrrEyQy97l2TUwkW6tErbrI13cvHR1wZlhcwtnkhRUSepKQHo4ay
         nCmaZcrdDc8dujkg+owwZsBcgKXqxgsmwLFS4=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 2/2] loop: handle on-demand devices correctly
Date: Tue, 24 May 2011 23:36:01 +0900
Message-Id: <1306247761-2246-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When finding or allocating a loop device, loop_probe() did not take
partition numbers into account so that it can result to a different
device. Consider following example:

$ sudo modprobe loop max_part=15
$ ls -l /dev/loop*
brw-rw---- 1 root disk 7,   0 2011-05-24 22:16 /dev/loop0
brw-rw---- 1 root disk 7,  16 2011-05-24 22:16 /dev/loop1
brw-rw---- 1 root disk 7,  32 2011-05-24 22:16 /dev/loop2
brw-rw---- 1 root disk 7,  48 2011-05-24 22:16 /dev/loop3
brw-rw---- 1 root disk 7,  64 2011-05-24 22:16 /dev/loop4
brw-rw---- 1 root disk 7,  80 2011-05-24 22:16 /dev/loop5
brw-rw---- 1 root disk 7,  96 2011-05-24 22:16 /dev/loop6
brw-rw---- 1 root disk 7, 112 2011-05-24 22:16 /dev/loop7
$ sudo mknod /dev/loop8 b 7 128
$ sudo losetup /dev/loop8 ~/temp/disk-with-3-parts.img
$ sudo losetup -a
/dev/loop128: [0805]:278201 (/home/namhyung/temp/disk-with-3-parts.img)
$ ls -l /dev/loop*
brw-rw---- 1 root disk 7,    0 2011-05-24 22:16 /dev/loop0
brw-rw---- 1 root disk 7,   16 2011-05-24 22:16 /dev/loop1
brw-rw---- 1 root disk 7, 2048 2011-05-24 22:18 /dev/loop128
brw-rw---- 1 root disk 7, 2049 2011-05-24 22:18 /dev/loop128p1
brw-rw---- 1 root disk 7, 2050 2011-05-24 22:18 /dev/loop128p2
brw-rw---- 1 root disk 7, 2051 2011-05-24 22:18 /dev/loop128p3
brw-rw---- 1 root disk 7,   32 2011-05-24 22:16 /dev/loop2
brw-rw---- 1 root disk 7,   48 2011-05-24 22:16 /dev/loop3
brw-rw---- 1 root disk 7,   64 2011-05-24 22:16 /dev/loop4
brw-rw---- 1 root disk 7,   80 2011-05-24 22:16 /dev/loop5
brw-rw---- 1 root disk 7,   96 2011-05-24 22:16 /dev/loop6
brw-rw---- 1 root disk 7,  112 2011-05-24 22:16 /dev/loop7
brw-r--r-- 1 root root 7,  128 2011-05-24 22:17 /dev/loop8

After this patch, /dev/loop8 - instead of /dev/loop128 - was
accessed correctly.

In addition, 'range' passed to blk_register_region() should
include all range of dev_t that LOOP_MAJOR can address. It does
not need to be limited by partition numbers unless 'max_loop'
param was specified.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/block/loop.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cbf7052d1dd5..c59a672a3de0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1658,7 +1658,7 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	struct kobject *kobj;
 
 	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(dev & MINORMASK);
+	lo = loop_init_one(MINOR(dev) >> part_shift);
 	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&loop_devices_mutex);
 
@@ -1699,10 +1699,10 @@ static int __init loop_init(void)
 
 	if (max_loop) {
 		nr = max_loop;
-		range = max_loop;
+		range = max_loop << part_shift;
 	} else {
 		nr = 8;
-		range = 1UL << (MINORBITS - part_shift);
+		range = 1UL << MINORBITS;
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
@@ -1741,7 +1741,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
+	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
-- 
1.7.5.2

