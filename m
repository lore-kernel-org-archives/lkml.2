Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0HLAe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:34:27 -0400
Received: from kroah.org ([198.145.64.141]:43482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab0HKX6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:46 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235501.960714485@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [070/111] Btrfs: run orphan cleanup on default fs root
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit e3acc2a6850efff647f1c5458524eb3a8bcba20a upstream.

This patch revert's commit

6c090a11e1c403b727a6a8eff0b97d5fb9e95cb5

Since it introduces this problem where we can run orphan cleanup on a
volume that can have orphan entries re-added.  Instead of my original
fix, Yan Zheng pointed out that we can just revert my original fix and
then run the orphan cleanup in open_ctree after we look up the fs_root.
I have tested this with all the tests that gave me problems and this
patch fixes both problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/disk-io.c |    6 ++++++
 fs/btrfs/inode.c   |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1993,6 +1993,12 @@ struct btrfs_root *open_ctree(struct sup
 	if (!fs_info->fs_root)
 		goto fail_trans_kthread;
 
+	if (!(sb->s_flags & MS_RDONLY)) {
+		down_read(&fs_info->cleanup_work_sem);
+		btrfs_orphan_cleanup(fs_info->fs_root);
+		up_read(&fs_info->cleanup_work_sem);
+	}
+
 	return tree_root;
 
 fail_trans_kthread:
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3796,12 +3796,6 @@ struct inode *btrfs_lookup_dentry(struct
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root);
-		if (unlikely(root->clean_orphans) &&
-		    !(inode->i_sb->s_flags & MS_RDONLY)) {
-			down_read(&root->fs_info->cleanup_work_sem);
-			btrfs_orphan_cleanup(root);
-			up_read(&root->fs_info->cleanup_work_sem);
-		}
 		return inode;
 	}
 


