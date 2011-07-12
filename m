Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1GLWhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:37:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1GLWhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:37:17 -0400
Date: Wed, 13 Jul 2011 00:37:15 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110712223715.GC13656@quack.suse.cz>
References: <20110629165714.GF17590@quack.suse.cz>
 <20110629175534.GA32236@infradead.org>
 <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20110712104132.GA14189@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 12-07-11 06:41:32, Christoph Hellwig wrote:
> On Tue, Jul 12, 2011 at 12:34:53PM +0200, Jan Kara wrote:
> > > All block device inodes sit on blockdev_superblock, we got rid of inodes
> > > without a superblock long time ago.
> >   Sure, we can easily iterate also blockdev_superblock. What I meant is
> > that blockdev_superblock will need a special handling since we otherwise
> > ignore pseudo superblocks...
> 
> Pseudo superblocks aren't ignored.  They are added to super_blocks like
> all others, and iterate_supers doesn't skip over them.  The problem
> is that blockdev_superblock doesn't have a proper s_bdi set, and thus
> gets skipped over by __sync_filesystem. 
  Yes. But even if it was not skipped writeback_inodes_sb() doesn't have
one flusher thread to kick to actually do the writeout (since each inode on
blockdev_superblock belongs to a different bdi). So it's perfectly fine we
skip blockdev_superblock.

  If we want to fix the problem something like attached patch should do.
Comments?

								Honza

PS: While testing the patch, I've noticed that block device can have any
dirty data only if it is still open (__blkdev_put() writes all dirty pages)
so that somehow limits how much people can be burned by sync not writing
out block devices...
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Make-sync-1-writeout-also-block-device-inodes.patch"

>From 2834bd2727c93055bb7373d8849492044f70c530 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jul 2011 22:01:51 +0200
Subject: [PATCH] vfs: Make sync(1) writeout also block device inodes

In case block device does not have filesystem mounted on it, sync(1) will just
ignore it and doesn't writeout dirty pages because it iterates over filesystems
with s_bdi != noop_backing_dev_info and thus it avoids blockdev_superblock.
Since it's unexpected that sync doesn't writeout dirty data for block devices
be nice to users and change the behavior to do so.

This requires a change to how syncing is done. We now first traverse all
superblocks with s_bdi != noop_backing_dev_info, writeout their inodes and
call sync_fs and when this is done, we traverse all block devices and sync
them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index c38ec16..f8f21d9 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -23,20 +23,13 @@
 
 /*
  * Do the filesystem syncing work. For simple filesystems
- * writeback_inodes_sb(sb) just dirties buffers with inodes so we have to
- * submit IO for these buffers via __sync_blockdev(). This also speeds up the
- * wait == 1 case since in that case write_inode() functions do
+ * writeback_inodes_sb(sb) just dirties buffers with inodes so the caller has
+ * to additionally submit IO for these buffers via __sync_blockdev(). This also
+ * speeds up the wait == 1 case since in that case write_inode() functions do
  * sync_dirty_buffer() and thus effectively write one block at a time.
  */
-static int __sync_filesystem(struct super_block *sb, int wait)
+static void __sync_filesystem(struct super_block *sb, int wait)
 {
-	/*
-	 * This should be safe, as we require bdi backing to actually
-	 * write out data in the first place
-	 */
-	if (sb->s_bdi == &noop_backing_dev_info)
-		return 0;
-
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
 		sb->s_qcop->quota_sync(sb, -1, wait);
 
@@ -47,7 +40,6 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
 }
 
 /*
@@ -71,16 +63,26 @@ int sync_filesystem(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	ret = __sync_filesystem(sb, 0);
+	/*
+	 * This should be safe, as we require bdi backing to actually
+	 * write out data in the first place.
+	 */
+	if (sb->s_bdi == &noop_backing_dev_info)
+		return 0;
+
+	__sync_filesystem(sb, 0);
+	ret = __sync_blockdev(sb->s_bdev, 0);
 	if (ret < 0)
 		return ret;
-	return __sync_filesystem(sb, 1);
+	__sync_filesystem(sb, 1);
+	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_one_sb(struct super_block *sb, void *arg)
 {
-	if (!(sb->s_flags & MS_RDONLY))
+	/* Avoid read-only filesystems and filesystems without backing device */
+	if (!(sb->s_flags & MS_RDONLY) && sb->s_bdi != &noop_backing_dev_info)
 		__sync_filesystem(sb, *(int *)arg);
 }
 /*
@@ -92,6 +94,42 @@ static void sync_filesystems(int wait)
 	iterate_supers(sync_one_sb, &wait);
 }
 
+static void sync_all_bdevs(int wait)
+{
+	struct inode *inode, *old_inode = NULL;
+
+	spin_lock(&inode_sb_list_lock);
+	list_for_each_entry(inode, &blockdev_superblock->s_inodes, i_sb_list) {
+		struct address_space *mapping = inode->i_mapping;
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
+		    mapping->nrpages == 0) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&inode_sb_list_lock);
+		/*
+		 * We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the
+		 * inode_sb_list_lock.  We cannot iput the inode now as we can
+		 * be holding the last reference and we cannot iput it under
+		 * inode_sb_list_lock. So we keep the reference and iput it
+		 * later.
+		 */
+		iput(old_inode);
+		old_inode = inode;
+
+		__sync_blockdev(I_BDEV(inode), wait);
+
+		spin_lock(&inode_sb_list_lock);
+	}
+	spin_unlock(&inode_sb_list_lock);
+	iput(old_inode);
+}
+
 /*
  * sync everything.  Start out by waking pdflush, because that writes back
  * all queues in parallel.
@@ -101,6 +139,8 @@ SYSCALL_DEFINE0(sync)
 	wakeup_flusher_threads(0);
 	sync_filesystems(0);
 	sync_filesystems(1);
+	sync_all_bdevs(0);
+	sync_all_bdevs(1);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
 	return 0;
-- 
1.7.1


--4Ckj6UjgE2iN1+kY--
