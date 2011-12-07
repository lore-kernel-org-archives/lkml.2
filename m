Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab1LGQml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:42:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557Ab1LGQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.549789985@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:48 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, greg@kroah.com
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com, bpm@sgi.com,
        Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>
Subject: [046/104] xfs: dont serialise direct IO reads on page cache checks
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dave Chinner <dchinner@redhat.com>

commit 0c38a2512df272b14ef4238b476a2e4f70da1479 upstream.

There is no need to grab the i_mutex of the IO lock in exclusive
mode if we don't need to invalidate the page cache. Taking these
locks on every direct IO effective serialises them as taking the IO
lock in exclusive mode has to wait for all shared holders to drop
the lock. That only happens when IO is complete, so effective it
prevents dispatch of concurrent direct IO reads to the same inode.

Fix this by taking the IO lock shared to check the page cache state,
and only then drop it and take the IO lock exclusively if there is
work to be done. Hence for the normal direct IO case, no exclusive
locking will occur.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Joern Engel <joern@logfs.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_file.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -317,7 +317,19 @@ xfs_file_aio_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (unlikely(ioflags & IO_ISDIRECT)) {
+	/*
+	 * Locking is a bit tricky here. If we take an exclusive lock
+	 * for direct IO, we effectively serialise all new concurrent
+	 * read IO to this file and block it behind IO that is currently in
+	 * progress because IO in progress holds the IO lock shared. We only
+	 * need to hold the lock exclusive to blow away the page cache, so
+	 * only take lock exclusively if the page cache needs invalidation.
+	 * This allows the normal direct IO case of no page cache pages to
+	 * proceeed concurrently without serialisation.
+	 */
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
+		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
 		if (inode->i_mapping->nrpages) {
@@ -330,8 +342,7 @@ xfs_file_aio_read(
 			}
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-	} else
-		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 


