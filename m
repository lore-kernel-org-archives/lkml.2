Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1KVSyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:54:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41923 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1KVSye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:54:34 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/3] reiserfs: Delay reiserfs lock until journal initialization
Date: Tue, 22 Nov 2011 19:54:17 +0100
Message-Id: <1321988059-13053-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321988059-13053-1-git-send-email-fweisbec@gmail.com>
References: <1321988059-13053-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the mount path, transactions that are made before journal
initialization don't involve the filesystem. We can delay
the reiserfs lock until we play with the journal.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/bitmap.c |    3 ---
 fs/reiserfs/super.c  |   43 ++++++++++++++++++++++++-------------------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index d1aca1d..5bab921 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -1273,10 +1273,7 @@ int reiserfs_init_bitmap_cache(struct super_block *sb)
 	struct reiserfs_bitmap_info *bitmap;
 	unsigned int bmap_nr = reiserfs_bmap_count(sb);
 
-	/* Avoid lock recursion in fault case */
-	reiserfs_write_unlock(sb);
 	bitmap = vmalloc(sizeof(*bitmap) * bmap_nr);
-	reiserfs_write_lock(sb);
 	if (bitmap == NULL)
 		return -ENOMEM;
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 14363b9..1f0d4fa 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1655,22 +1655,11 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	mutex_init(&REISERFS_SB(s)->lock);
 	REISERFS_SB(s)->lock_depth = -1;
 
-	/*
-	 * This function is called with the bkl, which also was the old
-	 * locking used here.
-	 * do_journal_begin() will soon check if we hold the lock (ie: was the
-	 * bkl). This is likely because do_journal_begin() has several another
-	 * callers because at this time, it doesn't seem to be necessary to
-	 * protect against anything.
-	 * Anyway, let's be conservative and lock for now.
-	 */
-	reiserfs_write_lock(s);
-
 	jdev_name = NULL;
 	if (reiserfs_parse_options
 	    (s, (char *)data, &(sbi->s_mount_opt), &blocks, &jdev_name,
 	     &commit_max_age, qf_names, &qfmt) == 0) {
-		goto error;
+		goto error_unlocked;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1678,7 +1667,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 
 	if (blocks) {
 		SWARN(silent, s, "jmacd-7", "resize option for remount only");
-		goto error;
+		goto error_unlocked;
 	}
 
 	/* try old format (undistributed bitmap, super block in 8-th 1k block of a device) */
@@ -1688,7 +1677,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	else if (read_super_block(s, REISERFS_DISK_OFFSET_IN_BYTES)) {
 		SWARN(silent, s, "sh-2021", "can not find reiserfs on %s",
 		      reiserfs_bdevname(s));
-		goto error;
+		goto error_unlocked;
 	}
 
 	rs = SB_DISK_SUPER_BLOCK(s);
@@ -1704,7 +1693,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		      "or increase size of your LVM partition");
 		SWARN(silent, s, "", "Or may be you forgot to "
 		      "reboot after fdisk when it told you to");
-		goto error;
+		goto error_unlocked;
 	}
 
 	sbi->s_mount_state = SB_REISERFS_STATE(s);
@@ -1712,8 +1701,9 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 
 	if ((errval = reiserfs_init_bitmap_cache(s))) {
 		SWARN(silent, s, "jmacd-8", "unable to read bitmap");
-		goto error;
+		goto error_unlocked;
 	}
+
 	errval = -EINVAL;
 #ifdef CONFIG_REISERFS_CHECK
 	SWARN(silent, s, "", "CONFIG_REISERFS_CHECK is set ON");
@@ -1736,6 +1726,17 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	if (reiserfs_barrier_flush(s)) {
 		printk("reiserfs: using flush barriers\n");
 	}
+
+	/*
+	 * This path assumed to be called with the BKL in the old times.
+	 * Now we have inherited the big reiserfs lock from it and many
+	 * reiserfs helpers called in the mount path and elsewhere require
+	 * this lock to be held even if it's not always necessary. Let's be
+	 * conservative and hold it early. The window can be reduced after
+	 * careful review of the code.
+	 */
+	reiserfs_write_lock(s);
+
 	// set_device_ro(s->s_dev, 1) ;
 	if (journal_init(s, jdev_name, old_format, commit_max_age)) {
 		SWARN(silent, s, "sh-2022",
@@ -1896,12 +1897,16 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	return (0);
 
 error:
-	if (jinit_done) {	/* kill the commit thread, free journal ram */
+	reiserfs_write_unlock(s);
+
+error_unlocked:
+	/* kill the commit thread, free journal ram */
+	if (jinit_done) {
+		reiserfs_write_lock(s);
 		journal_release_error(NULL, s);
+		reiserfs_write_unlock(s);
 	}
 
-	reiserfs_write_unlock(s);
-
 	reiserfs_free_bitmap_cache(s);
 	if (SB_BUFFER_WITH_SB(s))
 		brelse(SB_BUFFER_WITH_SB(s));
-- 
1.7.5.4

