Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0DVUq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:46:56 -0400
Received: from kroah.org ([198.145.64.141]:37184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab0DVT1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:37 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.753405509@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>
Subject: [015/197] xfs: fix timestamp handling in xfs_setattr
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@infradead.org>

commit d6d59bada372bcf8bd36c3bbc71c485c29dd2a4b upstream

We currently have some rather odd code in xfs_setattr for
updating the a/c/mtime timestamps:

 - first we do a non-transaction update if all three are updated
   together
 - second we implicitly update the ctime for various changes
   instead of relying on the ATTR_CTIME flag
 - third we set the timestamps to the current time instead of the
   arguments in the iattr structure in many cases.

This patch makes sure we update it in a consistent way:

 - always transactional
 - ctime is only updated if ATTR_CTIME is set or we do a size
   update, which is a special case
 - always to the times passed in from the caller instead of the
   current time

The only non-size caller of xfs_setattr that doesn't come from
the VFS is updated to set ATTR_CTIME and pass in a valid ctime
value.

Reported-by: Eric Blake <ebb9@byu.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_acl.c |    3 -
 fs/xfs/xfs_vnodeops.c      |   93 ++++++++++++++++++---------------------------
 2 files changed, 41 insertions(+), 55 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -250,8 +250,9 @@ xfs_set_mode(struct inode *inode, mode_t
 	if (mode != inode->i_mode) {
 		struct iattr iattr;
 
-		iattr.ia_valid = ATTR_MODE;
+		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
 		iattr.ia_mode = mode;
+		iattr.ia_ctime = current_fs_time(inode->i_sb);
 
 		error = -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
 	}
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -69,7 +69,6 @@ xfs_setattr(
 	uint			commit_flags=0;
 	uid_t			uid=0, iuid=0;
 	gid_t			gid=0, igid=0;
-	int			timeflags = 0;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
 	int			need_iolock = 1;
 
@@ -134,16 +133,13 @@ xfs_setattr(
 	if (flags & XFS_ATTR_NOLOCK)
 		need_iolock = 0;
 	if (!(mask & ATTR_SIZE)) {
-		if ((mask != (ATTR_CTIME|ATTR_ATIME|ATTR_MTIME)) ||
-		    (mp->m_flags & XFS_MOUNT_WSYNC)) {
-			tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
-			commit_flags = 0;
-			if ((code = xfs_trans_reserve(tp, 0,
-						     XFS_ICHANGE_LOG_RES(mp), 0,
-						     0, 0))) {
-				lock_flags = 0;
-				goto error_return;
-			}
+		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+		commit_flags = 0;
+		code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp),
+					 0, 0, 0);
+		if (code) {
+			lock_flags = 0;
+			goto error_return;
 		}
 	} else {
 		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
@@ -294,15 +290,23 @@ xfs_setattr(
 		 * or we are explicitly asked to change it. This handles
 		 * the semantic difference between truncate() and ftruncate()
 		 * as implemented in the VFS.
+		 *
+		 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME
+		 * is a special case where we need to update the times despite
+		 * not having these flags set.  For all other operations the
+		 * VFS set these flags explicitly if it wants a timestamp
+		 * update.
 		 */
-		if (iattr->ia_size != ip->i_size || (mask & ATTR_CTIME))
-			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		if (iattr->ia_size != ip->i_size &&
+		    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
+			iattr->ia_ctime = iattr->ia_mtime =
+				current_fs_time(inode->i_sb);
+			mask |= ATTR_CTIME | ATTR_MTIME;
+		}
 
 		if (iattr->ia_size > ip->i_size) {
 			ip->i_d.di_size = iattr->ia_size;
 			ip->i_size = iattr->ia_size;
-			if (!(flags & XFS_ATTR_DMI))
-				xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		} else if (iattr->ia_size <= ip->i_size ||
 			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
@@ -373,9 +377,6 @@ xfs_setattr(
 			ip->i_d.di_gid = gid;
 			inode->i_gid = gid;
 		}
-
-		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
-		timeflags |= XFS_ICHGTIME_CHG;
 	}
 
 	/*
@@ -392,51 +393,37 @@ xfs_setattr(
 
 		inode->i_mode &= S_IFMT;
 		inode->i_mode |= mode & ~S_IFMT;
-
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		timeflags |= XFS_ICHGTIME_CHG;
 	}
 
 	/*
 	 * Change file access or modified times.
 	 */
-	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
-		if (mask & ATTR_ATIME) {
-			inode->i_atime = iattr->ia_atime;
-			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-			ip->i_update_core = 1;
-		}
-		if (mask & ATTR_MTIME) {
-			inode->i_mtime = iattr->ia_mtime;
-			ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-			ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-			timeflags &= ~XFS_ICHGTIME_MOD;
-			timeflags |= XFS_ICHGTIME_CHG;
-		}
-		if (tp && (mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)))
-			xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
+	if (mask & ATTR_ATIME) {
+		inode->i_atime = iattr->ia_atime;
+		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
+		ip->i_update_core = 1;
 	}
-
-	/*
-	 * Change file inode change time only if ATTR_CTIME set
-	 * AND we have been called by a DMI function.
-	 */
-
-	if ((flags & XFS_ATTR_DMI) && (mask & ATTR_CTIME)) {
+	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
 		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
 		ip->i_update_core = 1;
-		timeflags &= ~XFS_ICHGTIME_CHG;
+	}
+	if (mask & ATTR_MTIME) {
+		inode->i_mtime = iattr->ia_mtime;
+		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
+		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
+		ip->i_update_core = 1;
 	}
 
 	/*
-	 * Send out timestamp changes that need to be set to the
-	 * current time.  Not done when called by a DMI function.
+	 * And finally, log the inode core if any attribute in it
+	 * has been changed.
 	 */
-	if (timeflags && !(flags & XFS_ATTR_DMI))
-		xfs_ichgtime(ip, timeflags);
+	if (mask & (ATTR_UID|ATTR_GID|ATTR_MODE|
+		    ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(xs_ig_attrchg);
 
@@ -451,12 +438,10 @@ xfs_setattr(
 	 * mix so this probably isn't worth the trouble to optimize.
 	 */
 	code = 0;
-	if (tp) {
-		if (mp->m_flags & XFS_MOUNT_WSYNC)
-			xfs_trans_set_sync(tp);
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(tp);
 
-		code = xfs_trans_commit(tp, commit_flags);
-	}
+	code = xfs_trans_commit(tp, commit_flags);
 
 	xfs_iunlock(ip, lock_flags);
 


