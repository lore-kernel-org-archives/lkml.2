Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2JTScu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:32:50 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60883 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2JTSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:32:27 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 3/4] brd: replace list with brd_devices by an idr indexed by minor ids
Date: Sat, 20 Oct 2012 20:32:22 +0200
Message-Id: <1350757943-24981-4-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
References: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the list of brd_devices with an idr, thus enabling
easier block ram disk creation and deletion.

Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 drivers/block/brd.c | 136 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 106 insertions(+), 30 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index ce1255c..1d0016b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 
 #include <asm/uaccess.h>
 
@@ -34,11 +35,8 @@
  * device).
  */
 struct brd_device {
-	int		brd_number;
-
 	struct request_queue	*brd_queue;
 	struct gendisk		*brd_disk;
-	struct list_head	brd_list;
 
 	/*
 	 * Backing store of pages and lock to protect it. This is the contents
@@ -50,6 +48,10 @@ struct brd_device {
 
 static DEFINE_MUTEX(brd_mutex);
 
+static char dummy = -1;
+#define DUMMY ((struct brd_device *)&dummy)
+static DEFINE_IDR(brd_idr);
+
 /*
  * Look up and return a brd's page for a given sector.
  */
@@ -458,6 +460,8 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
 
+static struct brd_device *brd_new(int id);
+
 #ifndef MODULE
 /* Legacy boot options - nonmodular */
 static int __init ramdisk_size(char *str)
@@ -472,7 +476,6 @@ __setup("ramdisk_size=", ramdisk_size);
  * The device scheme is derived from loop.c. Keep them in synch where possible
  * (should share code eventually).
  */
-static LIST_HEAD(brd_devices);
 static DEFINE_MUTEX(brd_devices_mutex);
 
 static struct brd_device *brd_alloc(int i)
@@ -483,7 +486,6 @@ static struct brd_device *brd_alloc(int i)
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd)
 		goto out;
-	brd->brd_number		= i;
 	spin_lock_init(&brd->brd_lock);
 	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
 
@@ -533,27 +535,100 @@ static struct brd_device *brd_init_one(int i)
 {
 	struct brd_device *brd;
 
-	list_for_each_entry(brd, &brd_devices, brd_list) {
-		if (brd->brd_number == i)
-			goto out;
-	}
+	brd = idr_find(&brd_idr, i);
+	if (brd)
+		return brd;
 
-	brd = brd_alloc(i);
-	if (brd) {
+	brd = brd_new(i);
+	if (!IS_ERR(brd))
 		add_disk(brd->brd_disk);
-		list_add_tail(&brd->brd_list, &brd_devices);
-	}
-out:
 	return brd;
 }
 
 static void brd_del_one(struct brd_device *brd)
 {
-	list_del(&brd->brd_list);
 	del_gendisk(brd->brd_disk);
 	brd_free(brd);
 }
 
+static int brd_new_id(int min)
+{
+	int id, err;
+	err = idr_pre_get(&brd_idr, GFP_KERNEL);
+	if (!err)
+		return -ENOMEM;
+	err = idr_get_new_above(&brd_idr, DUMMY, min, &id);
+	if (err < 0)
+		return err;
+	return id;
+}
+
+static int brd_new_specific_id(int id)
+{
+	int n;
+	n = brd_new_id(id);
+	if (n < 0)
+		return n;
+	if (id != n) {
+		idr_remove(&brd_idr, n);
+		return -EBUSY;
+	}
+	return n;
+}
+
+static struct brd_device *brd_new(int id)
+{
+	int err;
+	struct brd_device *brd, *p;
+
+	err = brd_new_specific_id(id);
+	if (err < 0)
+		return ERR_PTR(err);
+	brd = brd_alloc(id);
+	if (!brd) {
+		p = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	p = idr_replace(&brd_idr, brd, id);
+	if (IS_ERR(p))
+		goto out2;
+	if (p != DUMMY) {
+		WARN_ON(1);
+		p = ERR_PTR(-EBUSY);
+		goto out2;
+	}
+	return brd;
+out2:
+	brd_free(brd);
+out:
+	idr_remove(&brd_idr, id);
+	return p;
+}
+
+static int brd_add_disk_idr(int id, void *p, void *data)
+{
+	struct brd_device *brd = (struct brd_device *)p;
+	WARN_ON(brd == DUMMY);
+	add_disk(brd->brd_disk);
+	return 0;
+}
+
+static int brd_free_idr(int id, void *p, void *data)
+{
+	struct brd_device *brd = (struct brd_device *)p;
+	WARN_ON(brd == DUMMY);
+	brd_free(brd);
+	return 0;
+}
+
+static int brd_del_one_idr(int id, void *p, void *data)
+{
+	struct brd_device *brd = (struct brd_device *)p;
+	WARN_ON(brd == DUMMY);
+	brd_del_one(brd);
+	return 0;
+}
+
 static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 {
 	struct brd_device *brd;
@@ -561,7 +636,7 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 
 	mutex_lock(&brd_devices_mutex);
 	brd = brd_init_one(MINOR(dev) >> part_shift);
-	kobj = brd ? get_disk(brd->brd_disk) : ERR_PTR(-ENOMEM);
+	kobj = IS_ERR(brd) ? ERR_PTR(PTR_ERR(brd)) : get_disk(brd->brd_disk);
 	mutex_unlock(&brd_devices_mutex);
 
 	*part = 0;
@@ -570,9 +645,10 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 
 static int __init brd_init(void)
 {
+	int err;
 	unsigned int i, nr;
 	unsigned long range;
-	struct brd_device *brd, *next;
+	struct brd_device *brd;
 
 	/*
 	 * brd module now has a feature to instantiate underlying device
@@ -619,16 +695,16 @@ static int __init brd_init(void)
 		return -EIO;
 
 	for (i = 0; i < nr; i++) {
-		brd = brd_alloc(i);
-		if (!brd)
+		brd = brd_new(i);
+		if (IS_ERR(brd)) {
+			err = PTR_RET(brd);
 			goto out_free;
-		list_add_tail(&brd->brd_list, &brd_devices);
+		}
 	}
 
 	/* point of no return */
 
-	list_for_each_entry(brd, &brd_devices, brd_list)
-		add_disk(brd->brd_disk);
+	idr_for_each(&brd_idr, brd_add_disk_idr, NULL);
 
 	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), range,
 				  THIS_MODULE, brd_probe, NULL, NULL);
@@ -637,24 +713,24 @@ static int __init brd_init(void)
 	return 0;
 
 out_free:
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list) {
-		list_del(&brd->brd_list);
-		brd_free(brd);
-	}
+	idr_for_each(&brd_idr, brd_free_idr, NULL);
+	idr_remove_all(&brd_idr);
+	idr_destroy(&brd_idr);
+
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
-	return -ENOMEM;
+	return err;
 }
 
 static void __exit brd_exit(void)
 {
 	unsigned long range;
-	struct brd_device *brd, *next;
 
 	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
 
-	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
-		brd_del_one(brd);
+	idr_for_each(&brd_idr, brd_del_one_idr, NULL);
+	idr_remove_all(&brd_idr);
+	idr_destroy(&brd_idr);
 
 	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
-- 
1.7.12.4

