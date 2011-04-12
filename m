Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1DLOhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:52 -0400
Received: from kroah.org ([198.145.64.141]:57459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab1DLOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:50 2011
Message-Id: <20110412143550.497779074@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Chinner <dchinner@redhat.com>
Subject: [024/105] xfs: register the inode cache shrinker before quotachecks
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 704b2907c2d47ceb187c0e25a6bbc2174b198f2f upstream.

During mount, we can do a quotacheck that involves a bulkstat pass
on all inodes. If there are more inodes in the filesystem than can
be held in memory, we require the inode cache shrinker to run to
ensure that we don't run out of memory.

Unfortunately, the inode cache shrinker is not registered until we
get to the end of the superblock setup process, which is after a
quotacheck is run if it is needed. Hence we need to register the
inode cache shrinker earlier in the mount process so that we don't
OOM during mount. This requires that we also initialise the syncd
work before we register the shrinker, so we nee dto juggle that
around as well.

While there, make sure that we have set up the block sizes in the
VFS superblock correctly before the quotacheck is run so that any
inodes that are cached as a result of the quotacheck have their
block size fields set up correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_super.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1551,10 +1551,14 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
-	error = xfs_mountfs(mp);
-	if (error)
-		goto out_filestream_unmount;
-
+	/*
+	 * we must configure the block size in the superblock before we run the
+	 * full mount process as the mount process can lookup and cache inodes.
+	 * For the same reason we must also initialise the syncd and register
+	 * the inode cache shrinker so that inodes can be reclaimed during
+	 * operations like a quotacheck that iterate all inodes in the
+	 * filesystem.
+	 */
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
@@ -1562,6 +1566,16 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
+	error = xfs_syncd_init(mp);
+	if (error)
+		goto out_filestream_unmount;
+
+	xfs_inode_shrinker_register(mp);
+
+	error = xfs_mountfs(mp);
+	if (error)
+		goto out_syncd_stop;
+
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
@@ -1577,14 +1591,11 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 	}
 
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto fail_vnrele;
-
-	xfs_inode_shrinker_register(mp);
-
 	return 0;
 
+ out_syncd_stop:
+	xfs_inode_shrinker_unregister(mp);
+	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1608,6 +1619,9 @@ xfs_fs_fill_super(
 	}
 
  fail_unmount:
+	xfs_inode_shrinker_unregister(mp);
+	xfs_syncd_stop(mp);
+
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive


