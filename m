Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0LEPPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 10:15:44 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:52920 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab0LEPPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 10:15:43 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: axboe@kernel.dk
Cc: paulmck@linux.vnet.ibm.com, shemminger@vyatta.com,
        isimatu.yasuaki@jp.fujitsu.com, neilb@suse.de,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] block: add_disk: fix error handling
Date: Sun,  5 Dec 2010 16:15:27 +0100
Message-Id: <1291562127-31432-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings better error handling to the
add_disk function.
Now it reports success or failure.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 block/genhd.c         |   34 +++++++++++++++++++++++++++-------
 include/linux/genhd.h |    2 +-
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..075e630 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -508,10 +508,8 @@ static int exact_lock(dev_t devt, void *data)
  *
  * This function registers the partitioning information in @disk
  * with the kernel.
- *
- * FIXME: error handling
  */
-void add_disk(struct gendisk *disk)
+int add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
 	dev_t devt;
@@ -529,7 +527,7 @@ void add_disk(struct gendisk *disk)
 	retval = blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
-		return;
+		goto out;
 	}
 	disk_to_dev(disk)->devt = devt;
 
@@ -541,16 +539,38 @@ void add_disk(struct gendisk *disk)
 
 	/* Register BDI before referencing it from bdev */ 
 	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, disk_devt(disk));
+	retval = bdi_register_dev(bdi, disk_devt(disk));
+	if (retval) {
+		WARN_ON(1);
+		goto out_free_devt;
+	}
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
-	blk_register_queue(disk);
+	retval = blk_register_queue(disk);
+	if (retval) {
+		WARN_ON(1);
+		goto out_unregister_bdi;
+	}
 
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
-	WARN_ON(retval);
+	if (retval) {
+		WARN_ON(1);
+		goto out_unregister_queue;
+	}
+
+	return 0;
+
+out_unregister_queue:
+	blk_unregister_queue(disk);
+out_unregister_bdi:
+	bdi_unregister(bdi);
+out_free_devt:
+	blk_free_devt(devt);
+out:
+	return -1;
 }
 
 EXPORT_SYMBOL(add_disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7a7b9c1..4e7ab8e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -393,7 +393,7 @@ static inline void free_part_info(struct hd_struct *part)
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void add_disk(struct gendisk *disk);
+extern int add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
-- 
1.6.6.1

