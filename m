Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0KQEXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:23:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51921 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0KQEXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:23:36 -0500
Message-ID: <4CE3579B.1000301@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:18:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@oracle.com>
CC: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ito <t-itoh@jp.fujitsu.com>
Subject: [PATCH 1/3] direct-io: add a hook for the fs to provide its own bio
 merging check function
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:23:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:23:57,
	Serialize complete at 2010-11-17 12:23:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTRFS can not submit bios that span its chunks or stripes, so it needs a
function to check it when we want to add a page into the bios. So we add a
can_merge_io hook to do it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/block_dev.c              |    3 ++-
 fs/btrfs/inode.c            |    2 +-
 fs/direct-io.c              |   12 +++++++++---
 fs/ext4/inode.c             |    2 +-
 fs/gfs2/aops.c              |    2 +-
 fs/ocfs2/aops.c             |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c |    5 +++--
 include/linux/fs.h          |    6 ++++--
 8 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 06e8ff1..e3728f6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -188,7 +188,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct inode *inode = file->f_mapping->host;
 
 	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
+				    nr_segs, blkdev_get_blocks, NULL, NULL,
+				    NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..3906e48 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5868,7 +5868,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, NULL, 0);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..f0b14a4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -83,6 +83,7 @@ struct dio {
 	get_block_t *get_block;		/* block mapping function */
 	dio_iodone_t *end_io;		/* IO completion function */
 	dio_submit_t *submit_io;	/* IO submition function */
+	can_merge_io_t *can_merge_io;	/* IO merging check function */
 	loff_t logical_offset_in_bio;	/* current first logical block in bio */
 	sector_t final_block_in_bio;	/* current final block in bio + 1 */
 	sector_t next_block_for_io;	/* next block to be put under IO,
@@ -661,6 +662,10 @@ static int dio_send_cur_page(struct dio *dio)
 		 */
 		else if (dio->boundary)
 			dio_bio_submit(dio);
+		else if (dio->can_merge_io &&
+			 dio->can_merge_io(dio->cur_page_len, dio->inode,
+					   dio->bio))
+			dio_bio_submit(dio);
 	}
 
 	if (dio->bio == NULL) {
@@ -983,7 +988,7 @@ static ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io, struct dio *dio)
+	dio_submit_t submit_io, can_merge_io_t can_merge_io, struct dio *dio)
 {
 	unsigned long user_addr; 
 	unsigned long flags;
@@ -1001,6 +1006,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->submit_io = submit_io;
+	dio->can_merge_io = can_merge_io;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 
@@ -1159,7 +1165,7 @@ ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	dio_submit_t submit_io,	can_merge_io_t can_merge_io, int flags)
 {
 	int seg;
 	size_t size;
@@ -1247,7 +1253,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io,
-				submit_io, dio);
+				submit_io, can_merge_io, dio);
 
 out:
 	return retval;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bdbe699..b67964b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3553,7 +3553,7 @@ retry:
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+				 ext4_get_block, NULL, NULL, NULL, 0);
 	else {
 		ret = blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4f36f88..35fc14b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1039,7 +1039,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, gfs2_get_block_direct,
-				  NULL, NULL, 0);
+				  NULL, NULL, NULL, 0);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f1e962c..5d006ea 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -631,7 +631,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 	ret = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
 				   iov, offset, nr_segs,
 				   ocfs2_direct_IO_get_blocks,
-				   ocfs2_dio_end_io, NULL, 0);
+				   ocfs2_dio_end_io, NULL, NULL, 0);
 
 	mlog_exit(ret);
 	return ret;
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7d287af..1f3eaa5 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1484,14 +1484,15 @@ xfs_vm_direct_IO(
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
 					    xfs_get_blocks_direct,
-					    xfs_end_io_direct_write, NULL, 0);
+					    xfs_end_io_direct_write, NULL,
+					    NULL, 0);
 		if (ret != -EIOCBQUEUED && iocb->private)
 			xfs_destroy_ioend(iocb->private);
 	} else {
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
 					    xfs_get_blocks_direct,
-					    NULL, NULL, 0);
+					    NULL, NULL, NULL, 0);
 	}
 
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 334d68a..b4c2976 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2311,6 +2311,8 @@ static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
 
+typedef int (can_merge_io_t)(size_t size, struct inode *inode, struct bio *bio);
+
 enum {
 	/* need locking between buffered and direct access */
 	DIO_LOCKING	= 0x01,
@@ -2324,7 +2326,7 @@ void dio_end_io(struct bio *bio, int error);
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
+	dio_submit_t submit_io,	can_merge_io_t can_merge_io, int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
@@ -2332,7 +2334,7 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 	dio_iodone_t end_io)
 {
 	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				    nr_segs, get_block, end_io, NULL,
+				    nr_segs, get_block, end_io, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #endif
-- 
1.7.0.1
