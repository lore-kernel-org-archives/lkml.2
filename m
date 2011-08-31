Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1HaPLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60096 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab1HaPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/16] drbd: Replaced the minor_table array by an idr
Date: Wed, 31 Aug 2011 17:11:08 +0200
Message-Id: <1314803468-1201-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 +-----
 drivers/block/drbd/drbd_main.c     |   42 ++++++++++++++++++-----------------
 drivers/block/drbd/drbd_proc.c     |   14 +++--------
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_worker.c   |   10 +------
 5 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5fb5bd0..e3f542c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -168,8 +168,8 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 /* 4th incarnation of the disk layout. */
 #define DRBD_MD_MAGIC (DRBD_MAGIC+4)
 
-extern struct drbd_conf **minor_table;
 extern struct ratelimit_state drbd_ratelimit_state;
+extern struct idr minors;
 extern struct list_head drbd_tconns;
 
 /* on the wire */
@@ -1109,11 +1109,7 @@ struct drbd_conf {
 
 static inline struct drbd_conf *minor_to_mdev(unsigned int minor)
 {
-	struct drbd_conf *mdev;
-
-	mdev = minor < minor_count ? minor_table[minor] : NULL;
-
-	return mdev;
+	return (struct drbd_conf *)idr_find(&minors, minor);
 }
 
 static inline unsigned int mdev_to_minor(struct drbd_conf *mdev)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1188fca..0a2575c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -74,7 +74,7 @@ MODULE_AUTHOR("Philipp Reisner <phil@linbit.com>, "
 MODULE_DESCRIPTION("drbd - Distributed Replicated Block Device v" REL_VERSION);
 MODULE_VERSION(REL_VERSION);
 MODULE_LICENSE("GPL");
-MODULE_PARM_DESC(minor_count, "Maximum number of drbd devices ("
+MODULE_PARM_DESC(minor_count, "Approximate number of drbd devices ("
 		 __stringify(DRBD_MINOR_COUNT_MIN) "-" __stringify(DRBD_MINOR_COUNT_MAX) ")");
 MODULE_ALIAS_BLOCKDEV_MAJOR(DRBD_MAJOR);
 
@@ -120,7 +120,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
 /* in 2.6.x, our device mapping and config info contains our virtual gendisks
  * as member "struct gendisk *vdisk;"
  */
-struct drbd_conf **minor_table;
+struct idr minors;
 struct list_head drbd_tconns;  /* list of struct drbd_tconn */
 
 struct kmem_cache *drbd_request_cache;
@@ -2118,11 +2118,13 @@ void drbd_delete_device(unsigned int minor)
 	 * allocated from drbd_new_device
 	 * and actually free the mdev itself */
 	drbd_free_mdev(mdev);
+	idr_remove(&minors, minor);
 }
 
 static void drbd_cleanup(void)
 {
 	unsigned int i;
+	struct drbd_conf *mdev;
 
 	unregister_reboot_notifier(&drbd_notifier);
 
@@ -2139,17 +2141,13 @@ static void drbd_cleanup(void)
 
 	drbd_nl_cleanup();
 
-	if (minor_table) {
-		i = minor_count;
-		while (i--)
-			drbd_delete_device(i);
-		drbd_destroy_mempools();
-	}
-
-	kfree(minor_table);
-
+	idr_for_each_entry(&minors, mdev, i)
+		drbd_delete_device(i);
+	drbd_destroy_mempools();
 	unregister_blkdev(DRBD_MAJOR, "drbd");
 
+	idr_destroy(&minors);
+
 	printk(KERN_INFO "drbd: module cleanup done.\n");
 }
 
@@ -2286,6 +2284,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	struct gendisk *disk;
 	struct request_queue *q;
 	int vnr_got = vnr;
+	int minor_got = minor;
 
 	mdev = minor_to_mdev(minor);
 	if (mdev)
@@ -2361,13 +2360,20 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	INIT_LIST_HEAD(&mdev->current_epoch->list);
 	mdev->epochs = 1;
 
-	minor_table[minor] = mdev;
+	if (!idr_pre_get(&minors, GFP_KERNEL))
+		goto out_no_minor_idr;
+	if (idr_get_new(&minors, mdev, &minor_got))
+		goto out_no_minor_idr;
+	if (minor_got != minor) {
+		idr_remove(&minors, minor_got);
+		goto out_no_minor_idr;
+	}
 	add_disk(disk);
 
 	return NO_ERROR;
 
-/* out_whatever_else:
-	kfree(mdev->current_epoch); */
+out_no_minor_idr:
+	kfree(mdev->current_epoch);
 out_no_epoch:
 	drbd_bm_cleanup(mdev);
 out_no_bitmap:
@@ -2407,7 +2413,7 @@ int __init drbd_init(void)
 
 	if (minor_count < DRBD_MINOR_COUNT_MIN || minor_count > DRBD_MINOR_COUNT_MAX) {
 		printk(KERN_ERR
-			"drbd: invalid minor_count (%d)\n", minor_count);
+		       "drbd: invalid minor_count (%d)\n", minor_count);
 #ifdef MODULE
 		return -EINVAL;
 #else
@@ -2437,10 +2443,7 @@ int __init drbd_init(void)
 	init_waitqueue_head(&drbd_pp_wait);
 
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
-	minor_table = kzalloc(sizeof(struct drbd_conf *)*minor_count,
-				GFP_KERNEL);
-	if (!minor_table)
-		goto Enomem;
+	idr_init(&minors);
 
 	err = drbd_create_mempools();
 	if (err)
@@ -2461,7 +2464,6 @@ int __init drbd_init(void)
 	printk(KERN_INFO "drbd: %s\n", drbd_buildtag());
 	printk(KERN_INFO "drbd: registered as block device major %d\n",
 		DRBD_MAJOR);
-	printk(KERN_INFO "drbd: minor_table @ 0x%p\n", minor_table);
 
 	return 0; /* Success! */
 
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 4e53cb3..36c9a6c 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -194,7 +194,7 @@ static void resync_dump_detail(struct seq_file *seq, struct lc_element *e)
 
 static int drbd_seq_show(struct seq_file *seq, void *v)
 {
-	int i, hole = 0;
+	int i, prev_i = -1;
 	const char *sn;
 	struct drbd_conf *mdev;
 
@@ -227,16 +227,10 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	 oos .. known out-of-sync kB
 	*/
 
-	for (i = 0; i < minor_count; i++) {
-		mdev = minor_to_mdev(i);
-		if (!mdev) {
-			hole = 1;
-			continue;
-		}
-		if (hole) {
-			hole = 0;
+	idr_for_each_entry(&minors, mdev, i) {
+		if (prev_i != i - 1)
 			seq_printf(seq, "\n");
-		}
+		prev_i = i;
 
 		sn = drbd_conn_str(mdev->state.conn);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e607503..620f27f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -284,7 +284,7 @@ static void drbd_pp_free(struct drbd_conf *mdev, struct page *page, int is_net)
 	atomic_t *a = is_net ? &mdev->pp_in_use_by_net : &mdev->pp_in_use;
 	int i;
 
-	if (drbd_pp_vacant > (DRBD_MAX_BIO_SIZE/PAGE_SIZE)*minor_count)
+	if (drbd_pp_vacant > (DRBD_MAX_BIO_SIZE/PAGE_SIZE) * minor_count)
 		i = page_chain_free(page);
 	else {
 		struct page *tmp;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 5cb5ffc..e459cb2 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1349,10 +1349,7 @@ static int _drbd_pause_after(struct drbd_conf *mdev)
 	struct drbd_conf *odev;
 	int i, rv = 0;
 
-	for (i = 0; i < minor_count; i++) {
-		odev = minor_to_mdev(i);
-		if (!odev)
-			continue;
+	idr_for_each_entry(&minors, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
 		if (!_drbd_may_sync_now(odev))
@@ -1374,10 +1371,7 @@ static int _drbd_resume_next(struct drbd_conf *mdev)
 	struct drbd_conf *odev;
 	int i, rv = 0;
 
-	for (i = 0; i < minor_count; i++) {
-		odev = minor_to_mdev(i);
-		if (!odev)
-			continue;
+	idr_for_each_entry(&minors, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
 		if (odev->state.aftr_isp) {
-- 
1.7.4.1

