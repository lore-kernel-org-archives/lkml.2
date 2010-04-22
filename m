Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0DVUqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:46:38 -0400
Received: from kroah.org ([198.145.64.141]:37190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab0DVT1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.849167099@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>
Subject: [016/197] xfs: Dont flush stale inodes
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 44e08c45cc14e6190a424be8d450070c8e508fad upstream

Because inodes remain in cache much longer than inode buffers do
under memory pressure, we can get the situation where we have
stale, dirty inodes being reclaimed but the backing storage has
been freed.  Hence we should never, ever flush XFS_ISTALE inodes
to disk as there is no guarantee that the backing buffer is in
cache and still marked stale when the flush occurs.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_inode.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2877,10 +2877,14 @@ xfs_iflush(
 	mp = ip->i_mount;
 
 	/*
-	 * If the inode isn't dirty, then just release the inode
-	 * flush lock and do nothing.
+	 * If the inode isn't dirty, then just release the inode flush lock and
+	 * do nothing. Treat stale inodes the same; we cannot rely on the
+	 * backing buffer remaining stale in cache for the remaining life of
+	 * the stale inode and so xfs_itobp() below may give us a buffer that
+	 * no longer contains inodes below. Doing this stale check here also
+	 * avoids forcing the log on pinned, stale inodes.
 	 */
-	if (xfs_inode_clean(ip)) {
+	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
 		xfs_ifunlock(ip);
 		return 0;
 	}


