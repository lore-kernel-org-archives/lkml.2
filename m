Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2JAXE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:04:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35671 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320Ab2JAXDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:35 -0400
Message-Id: <20121001225159.562823590@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, Carlos Maiolino <cmaiolino@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 046/180] xfs: Fix possible memory corruption in xfs_readlink
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Maiolino <cmaiolino@redhat.com>

commit b52a360b2aa1c59ba9970fb0f52bbb093fcc7a24 upstream

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
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/xfs/xfs_vnodeops.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 8f32f50..1638884 100644
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
@@ -564,13 +564,20 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFLNK);
-	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
-
 	pathlen = ip->i_d.di_size;
 	if (!pathlen)
 		goto out;
 
+	if (pathlen < 0 || pathlen > MAXPATHLEN) {
+		xfs_fs_cmn_err(CE_ALERT, mp,
+			 "%s: inode (%llu) bad symlink length (%lld)",
+			 __func__, (unsigned long long) ip->i_ino,
+			 (long long) pathlen);
+		ASSERT(0);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
 		link[pathlen] = '\0';
-- 
1.7.2.1.45.g54fbc



