Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab2AJXCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934250Ab2AJXCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:03 2012
Message-Id: <20120110215603.633730952@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [24/49] reiserfs: Force inode evictions before umount to avoid crash
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit a9e36da655e54545c3289b2a0700b5c443de0edd upstream.

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
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/super.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -453,16 +453,20 @@ int remove_save_link(struct inode *inode
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


