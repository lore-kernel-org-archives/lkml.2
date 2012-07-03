Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2GCOqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:46:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab2GCOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:55 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/8] vfs: Create function for iterating over block devices
Date: Tue,  3 Jul 2012 16:45:31 +0200
Message-Id: <1341326734-29881-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341326734-29881-1-git-send-email-jack@suse.cz>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c     |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c2bbe1f..1e51919 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1710,3 +1710,39 @@ int __invalidate_device(struct block_device *bdev, bool kill_dirty)
 	return res;
 }
 EXPORT_SYMBOL(__invalidate_device);
+
+void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
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
+		func(I_BDEV(inode), arg);
+
+		spin_lock(&inode_sb_list_lock);
+	}
+	spin_unlock(&inode_sb_list_lock);
+	iput(old_inode);
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17fd887..d0892e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2091,6 +2091,7 @@ extern sector_t blkdev_max_block(struct block_device *bdev);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
+extern void iterate_bdevs(void (*)(struct block_device *, void *), void *);
 extern int sync_blockdev(struct block_device *bdev);
 extern void kill_bdev(struct block_device *);
 extern struct super_block *freeze_bdev(struct block_device *);
-- 
1.7.1

