Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2HOUic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:38:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62738 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab2HOTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Carlos Maiolino <cmaiolino@redhat.com>, Alex Elder <aelder@sgi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 013/165] xfs: Fix possible memory corruption in xfs_readlink
Date: Wed, 15 Aug 2012 15:45:57 -0400
Message-ID: <1345060109-9187-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b52a360b2aa1c59ba9970fb0f52bbb093fcc7a24 upstream.

Fixes a possible memory corruption when the link is larger than
MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
S_ISLNK assert, since the inode mode is checked previously in
xfs_readlink_by_handle() and via VFS.

Updated to address concerns raised by Ben Hutchings about the loose
attention paid to 32- vs 64-bit values, and the lack of handling a
potentially negative pathlen value:
 - Changed type of "pathlen" to be xfs_fsize_t, to match that of
   ip->i_d.di_size
 - Added checking for a negative pathlen to the too-long pathlen
   test, and generalized the message that gets reported in that case
   to reflect the change
As a result, if a negative pathlen were encountered, this function
would return EFSCORRUPTED (and would fail an assertion for a debug
build)--just as would a too-long pathlen.

Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[PG: no xfs_alert in 2.6.34; use xfs_fs_cmn_err(CE_ALERT, ...) instead]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/xfs_vnodeops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 4498f07..c682c5d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -554,7 +554,7 @@ xfs_readlink(
 	char		*link)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	int		pathlen;
+	xfs_fsize_t	pathlen;
 	int		error = 0;
 
 	xfs_itrace_entry(ip);
@@ -564,13 +564,19 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFLNK);
-	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
-
 	pathlen = ip->i_d.di_size;
 	if (!pathlen)
 		goto out;
 
+	if (pathlen < 0 || pathlen > MAXPATHLEN) {
+		xfs_fs_cmn_err(CE_ALERT, mp,
+			 "%s: inode (%llu) bad symlink length (%lld)", __func__,
+			 (unsigned long long) ip->i_ino, (long long) pathlen);
+		ASSERT(0);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
 		link[pathlen] = '\0';
-- 
1.7.12.rc2

