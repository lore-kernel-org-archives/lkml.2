Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336Ab2EOCRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:49100 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964881Ab2EOCQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 024/179] loop: handle on-demand devices correctly
Date: Mon, 14 May 2012 22:12:00 -0400
Message-ID: <1337048075-6132-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a1c15c59feee36267c43142a41152fbf7402afb6 upstream.

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
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bcd26d0..8d1c3c0e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1571,7 +1571,7 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	struct kobject *kobj;
 
 	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(dev & MINORMASK);
+	lo = loop_init_one(MINOR(dev) >> part_shift);
 	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&loop_devices_mutex);
 
@@ -1612,10 +1612,10 @@ static int __init loop_init(void)
 
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
@@ -1654,7 +1654,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
+	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
-- 
1.7.9.6

