Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1LUUVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:21:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1LUUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:21:49 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
        reiserfs-devel@vger.kernel.org, stable@kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] reiserfs: Force inode evictions before umount to avoid crash
Date: Wed, 21 Dec 2011 21:21:22 +0100
Message-Id: <1324498882-29263-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

This patch fixes a crash in reiserfs_delete_xattrs during umount.

When shrink_dcache_for_umount clears the dcache from
generic_shutdown_super, delayed evictions are forced to disk. If an
evicted inode has extended attributes associated with it, it will
need to walk the xattr tree to locate and remove them.

But since shrink_dcache_for_umount will BUG if it encounters active
dentries, the xattr tree must be released before it's called or it will
crash during every umount.

This patch forces the evictions to occur before generic_shutdown_super
by calling shrink_dcache_sb first. The additional evictions caused
by the removal of each associated xattr file and dir will be automatically
handled as they're added to the LRU list.

CC: reiserfs-devel@vger.kernel.org
CC: stable@kernel.org
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

 This patch is sitting in SUSE tree for quite a few months. I'll push it
to Linus in the next merge window if noone objects.

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 6ecba5c..d1e5950 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -455,16 +455,20 @@ int remove_save_link(struct inode *inode, int truncate)
 static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
-		if (REISERFS_SB(s)->xattr_root) {
-			d_invalidate(REISERFS_SB(s)->xattr_root);
-			dput(REISERFS_SB(s)->xattr_root);
-			REISERFS_SB(s)->xattr_root = NULL;
-		}
-		if (REISERFS_SB(s)->priv_root) {
-			d_invalidate(REISERFS_SB(s)->priv_root);
-			dput(REISERFS_SB(s)->priv_root);
-			REISERFS_SB(s)->priv_root = NULL;
-		}
+		/*
+		 * Force any pending inode evictions to occur now. Any
+		 * inodes to be removed that have extended attributes
+		 * associated with them need to clean them up before
+		 * we can release the extended attribute root dentries.
+		 * shrink_dcache_for_umount will BUG if we don't release
+		 * those before it's called so ->put_super is too late.
+		 */
+		shrink_dcache_sb(s);
+
+		dput(REISERFS_SB(s)->xattr_root);
+		REISERFS_SB(s)->xattr_root = NULL;
+		dput(REISERFS_SB(s)->priv_root);
+		REISERFS_SB(s)->priv_root = NULL;
 	}
 
 	kill_block_super(s);
-- 
1.7.1

