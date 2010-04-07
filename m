Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0DGJyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:54:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:57312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0DGJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:54:09 -0400
Message-ID: <4BBC5637.1020604@kernel.org>
Date: Wed, 07 Apr 2010 18:53:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Matthias-Christian Ott <ott@mirix.org>
Subject: [PATCH 2/2] block: implement bd_claiming and claiming block
References: <4BBC55DD.2010201@kernel.org>
In-Reply-To: <4BBC55DD.2010201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Apr 2010 09:54:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, device claiming for exclusive open is done after low level
open - disk->fops->open() - has completed successfully.  This means
that exclusive open attempts while a device is already exclusively
open will fail only after disk->fops->open() is called.

cdrom driver issues commands during open() which means that O_EXCL
open attempt can unintentionally inject commands to in-progress
command stream for burning thus disturbing burning process.  In most
cases, this doesn't cause problems because the first command to be
issued is TUR which most devices can process in the middle of burning.
However, depending on how a device replies to TUR during burning,
cdrom driver may end up issuing further commands.

This can't be resolved trivially by moving bd_claim() before doing
actual open() because that means an open attempt which will end up
failing could interfere other legit O_EXCL open attempts.
ie. unconfirmed open attempts can fail others.

This patch resolves the problem by introducing claiming block which is
started by bd_start_claiming() and terminated either by bd_claim() or
bd_abort_claiming().  bd_claim() from inside a claiming block is
guaranteed to succeed and once a claiming block is started, other
bd_start_claiming() or bd_claim() attempts block till the current
claiming block is terminated.

bd_claim() can still be used standalone although now it always
synchronizes against claiming blocks, so the existing users will keep
working without any change.

blkdev_open() and open_bdev_exclusive() are converted to use claiming
blocks so that exclusive open attempts from these functions don't
interfere with the existing exclusive open.

This problem was discovered while investigating bko#15403.

  https://bugzilla.kernel.org/show_bug.cgi?id=15403

The burning problem itself can be resolved by updating userspace
probing tools to always open w/ O_EXCL.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Matthias-Christian Ott <ott@mirix.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 fs/block_dev.c     |  198 ++++++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/fs.h |    1
 2 files changed, 175 insertions(+), 24 deletions(-)

Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -651,6 +651,7 @@ struct block_device {
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
+	void *			bd_claiming;
 	void *			bd_holder;
 	int			bd_holders;
 #ifdef CONFIG_SYSFS
Index: work/fs/block_dev.c
===================================================================
--- work.orig/fs/block_dev.c
+++ work/fs/block_dev.c
@@ -693,11 +693,144 @@ static bool bd_may_claim(struct block_de
 }

 /**
+ * bd_prepare_to_claim - prepare to claim a block device
+ * @bdev: block device of interest
+ * @whole: the whole device containing @bdev, may equal @bdev
+ * @holder: holder trying to claim @bdev
+ *
+ * Prepare to claim @bdev.  This function fails if @bdev is already
+ * claimed by another holder and waits if another claiming is in
+ * progress.  This function doesn't actually claim.  On successful
+ * return, the caller has ownership of bd_claiming and bd_holder[s].
+ *
+ * CONTEXT:
+ * spin_lock(&bdev_lock).  Might release bdev_lock, sleep and regrab
+ * it multiple times.
+ *
+ * RETURNS:
+ * 0 if @bdev can be claimed, -EBUSY otherwise.
+ */
+static int bd_prepare_to_claim(struct block_device *bdev,
+			       struct block_device *whole, void *holder)
+{
+retry:
+	/* if someone else claimed, fail */
+	if (!bd_may_claim(bdev, whole, holder))
+		return -EBUSY;
+
+	/* if someone else is claiming, wait for it to finish */
+	if (whole->bd_claiming && whole->bd_claiming != holder) {
+		wait_queue_head_t *wq = bit_waitqueue(&whole->bd_claiming, 0);
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock(&bdev_lock);
+		schedule();
+		finish_wait(wq, &wait);
+		spin_lock(&bdev_lock);
+		goto retry;
+	}
+
+	/* yay, all mine */
+	return 0;
+}
+
+/**
+ * bd_start_claiming - start claiming a block device
+ * @bdev: block device of interest
+ * @holder: holder trying to claim @bdev
+ *
+ * @bdev is about to be opened exclusively.  Check @bdev can be opened
+ * exclusively and mark that an exclusive open is in progress.  Each
+ * successful call to this function must be matched with a call to
+ * either bd_claim() or bd_abort_claiming().  If this function
+ * succeeds, the matching bd_claim() is guaranteed to succeed.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * Pointer to the block device containing @bdev on success, ERR_PTR()
+ * value on failure.
+ */
+static struct block_device *bd_start_claiming(struct block_device *bdev,
+					      void *holder)
+{
+	struct gendisk *disk;
+	struct block_device *whole;
+	int partno, err;
+
+	might_sleep();
+
+	/*
+	 * @bdev might not have been initialized properly yet, look up
+	 * and grab the outer block device the hard way.
+	 */
+	disk = get_gendisk(bdev->bd_dev, &partno);
+	if (!disk)
+		return ERR_PTR(-ENXIO);
+
+	whole = bdget_disk(disk, 0);
+	put_disk(disk);
+	if (!whole)
+		return ERR_PTR(-ENOMEM);
+
+	/* prepare to claim, if successful, mark claiming in progress */
+	spin_lock(&bdev_lock);
+
+	err = bd_prepare_to_claim(bdev, whole, holder);
+	if (err == 0) {
+		whole->bd_claiming = holder;
+		spin_unlock(&bdev_lock);
+		return whole;
+	} else {
+		spin_unlock(&bdev_lock);
+		bdput(whole);
+		return ERR_PTR(err);
+	}
+}
+
+/* releases bdev_lock */
+static void __bd_abort_claiming(struct block_device *whole, void *holder)
+{
+	BUG_ON(whole->bd_claiming != holder);
+	whole->bd_claiming = NULL;
+	wake_up_bit(&whole->bd_claiming, 0);
+
+	spin_unlock(&bdev_lock);
+	bdput(whole);
+}
+
+/**
+ * bd_abort_claiming - abort claiming a block device
+ * @whole: whole block device returned by bd_start_claiming()
+ * @holder: holder trying to claim @bdev
+ *
+ * Abort a claiming block started by bd_start_claiming().  Note that
+ * @whole is not the block device to be claimed but the whole device
+ * returned by bd_start_claiming().
+ *
+ * CONTEXT:
+ * Grabs and releases bdev_lock.
+ */
+static void bd_abort_claiming(struct block_device *whole, void *holder)
+{
+	spin_lock(&bdev_lock);
+	__bd_abort_claiming(whole, holder);		/* releases bdev_lock */
+}
+
+/**
  * bd_claim - claim a block device
  * @bdev: block device to claim
  * @holder: holder trying to claim @bdev
  *
- * Try to claim @bdev.
+ * Try to claim @bdev which must have been opened successfully.  This
+ * function may be called with or without preceding
+ * blk_start_claiming().  In the former case, this function is always
+ * successful and terminates the claiming block.
+ *
+ * CONTEXT:
+ * Might sleep.
  *
  * RETURNS:
  * 0 if successful, -EBUSY if @bdev is already claimed.
@@ -705,11 +838,14 @@ static bool bd_may_claim(struct block_de
 int bd_claim(struct block_device *bdev, void *holder)
 {
 	struct block_device *whole = bdev->bd_contains;
-	int res = -EBUSY;
+	int res;
+
+	might_sleep();

 	spin_lock(&bdev_lock);

-	if (bd_may_claim(bdev, whole, holder)) {
+	res = bd_prepare_to_claim(bdev, whole, holder);
+	if (res == 0) {
 		/* note that for a whole device bd_holders
 		 * will be incremented twice, and bd_holder will
 		 * be set to bd_claim before being set to holder
@@ -718,10 +854,13 @@ int bd_claim(struct block_device *bdev,
 		whole->bd_holder = bd_claim;
 		bdev->bd_holders++;
 		bdev->bd_holder = holder;
-		res = 0;
 	}

-	spin_unlock(&bdev_lock);
+	if (whole->bd_claiming)
+		__bd_abort_claiming(whole, holder);	/* releases bdev_lock */
+	else
+		spin_unlock(&bdev_lock);
+
 	return res;
 }
 EXPORT_SYMBOL(bd_claim);
@@ -1337,6 +1476,7 @@ EXPORT_SYMBOL(blkdev_get);

 static int blkdev_open(struct inode * inode, struct file * filp)
 {
+	struct block_device *whole = NULL;
 	struct block_device *bdev;
 	int res;

@@ -1359,22 +1499,25 @@ static int blkdev_open(struct inode * in
 	if (bdev == NULL)
 		return -ENOMEM;

+	if (filp->f_mode & FMODE_EXCL) {
+		whole = bd_start_claiming(bdev, filp);
+		if (IS_ERR(whole)) {
+			bdput(bdev);
+			return PTR_ERR(whole);
+		}
+	}
+
 	filp->f_mapping = bdev->bd_inode->i_mapping;

 	res = blkdev_get(bdev, filp->f_mode);
-	if (res)
-		return res;

-	if (filp->f_mode & FMODE_EXCL) {
-		res = bd_claim(bdev, filp);
-		if (res)
-			goto out_blkdev_put;
+	if (whole) {
+		if (res == 0)
+			BUG_ON(bd_claim(bdev, filp) != 0);
+		else
+			bd_abort_claiming(whole, filp);
 	}

-	return 0;
-
- out_blkdev_put:
-	blkdev_put(bdev, filp->f_mode);
 	return res;
 }

@@ -1585,27 +1728,34 @@ EXPORT_SYMBOL(lookup_bdev);
  */
 struct block_device *open_bdev_exclusive(const char *path, fmode_t mode, void *holder)
 {
-	struct block_device *bdev;
-	int error = 0;
+	struct block_device *bdev, *whole;
+	int error;

 	bdev = lookup_bdev(path);
 	if (IS_ERR(bdev))
 		return bdev;

+	whole = bd_start_claiming(bdev, holder);
+	if (IS_ERR(whole)) {
+		bdput(bdev);
+		return whole;
+	}
+
 	error = blkdev_get(bdev, mode);
 	if (error)
-		return ERR_PTR(error);
+		goto out_abort_claiming;
+
 	error = -EACCES;
 	if ((mode & FMODE_WRITE) && bdev_read_only(bdev))
-		goto blkdev_put;
-	error = bd_claim(bdev, holder);
-	if (error)
-		goto blkdev_put;
+		goto out_blkdev_put;

+	BUG_ON(bd_claim(bdev, holder) != 0);
 	return bdev;
-	
-blkdev_put:
+
+out_blkdev_put:
 	blkdev_put(bdev, mode);
+out_abort_claiming:
+	bd_abort_claiming(whole, holder);
 	return ERR_PTR(error);
 }

