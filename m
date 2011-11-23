Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab1KWAqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:46:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383Ab1KWAm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:09 2011
Message-Id: <20111123002409.195639830@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [49/53] xfs: Fix possible memory corruption in xfs_readlink
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Maiolino <cmaiolino@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_vnodeops.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -535,7 +535,7 @@ xfs_readlink(
 	char		*link)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	int		pathlen;
+	xfs_fsize_t	pathlen;
 	int		error = 0;
 
 	trace_xfs_readlink(ip);
@@ -545,13 +545,19 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFLNK);
-	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
-
 	pathlen = ip->i_d.di_size;
 	if (!pathlen)
 		goto out;
 
+	if (pathlen < 0 || pathlen > MAXPATHLEN) {
+		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
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


