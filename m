Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1JWGeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1JWGeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:06 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062539.781718204@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:44 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
        Christoph Hellwig <hch@lst.de>
Subject: [16/27] xfs: start periodic workers later
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 2bcf6e970f5a88fa05dced5eeb0326e13d93c4a1 upstream

Start the periodic sync workers only after we have finished xfs_mountfs
and thus fully set up the filesystem structures.  Without this we can
call into xfs_qm_sync before the quotainfo strucute is set up if the
mount takes unusually long, and probably hit other incomplete states
as well.

Also clean up the xfs_fs_fill_super error path by using consistent
label names, and removing an impossible to reach case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1412,37 +1412,35 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto out_filestream_unmount;
-
 	xfs_inode_shrinker_register(mp);
 
 	error = xfs_mountfs(mp);
 	if (error)
-		goto out_syncd_stop;
+		goto out_filestream_unmount;
+
+	error = xfs_syncd_init(mp);
+	if (error)
+		goto out_unmount;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
-		goto fail_unmount;
+		goto out_syncd_stop;
 	}
 	if (is_bad_inode(root)) {
 		error = EINVAL;
-		goto fail_vnrele;
+		goto out_syncd_stop;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		error = ENOMEM;
-		goto fail_vnrele;
+		goto out_iput;
 	}
 
 	return 0;
 
- out_syncd_stop:
-	xfs_inode_shrinker_unregister(mp);
-	xfs_syncd_stop(mp);
  out_filestream_unmount:
+	xfs_inode_shrinker_unregister(mp);
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
@@ -1456,17 +1454,12 @@ xfs_fs_fill_super(
  out:
 	return -error;
 
- fail_vnrele:
-	if (sb->s_root) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
-	} else {
-		iput(root);
-	}
-
- fail_unmount:
-	xfs_inode_shrinker_unregister(mp);
+ out_iput:
+	iput(root);
+ out_syncd_stop:
 	xfs_syncd_stop(mp);
+ out_unmount:
+	xfs_inode_shrinker_unregister(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.


