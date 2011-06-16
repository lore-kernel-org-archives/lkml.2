Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1FPHUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:20:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55750 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658Ab1FPHKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:40 -0400
X-Sasl-enc: c4yWNGJbSESmBfcM7FSNEw2Txx28WTAOCMrYOlu7mFx8 1308208239
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:06 2011
Message-Id: <20110616002906.582468804@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namhyung Kim <namhyung@gmail.com>,
        Laurent Vivier <Laurent.Vivier@bull.net>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [28/85] loop: handle on-demand devices correctly
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Namhyung Kim <namhyung@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1570,7 +1570,7 @@ static struct kobject *loop_probe(dev_t
 	struct kobject *kobj;
 
 	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(dev & MINORMASK);
+	lo = loop_init_one(MINOR(dev) >> part_shift);
 	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
 	mutex_unlock(&loop_devices_mutex);
 
@@ -1611,10 +1611,10 @@ static int __init loop_init(void)
 
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
@@ -1653,7 +1653,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
+	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);


