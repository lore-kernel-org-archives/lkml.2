Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab1KWAmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432Ab1KWAmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:08 2011
Message-Id: <20111123002408.908319178@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [46/53] xfs: avoid direct I/O write vs buffered I/O race
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit c58cb165bd44de8aaee9755a144136ae743be116 upstream.

Currently a buffered reader or writer can add pages to the pagecache
while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
this by re-checking mapping->nrpages after we got the iolock, and if
nessecary upgrade the lock to exclusive mode.  To simplify this a bit
only take the ilock inside of xfs_file_aio_write_checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -669,6 +669,7 @@ xfs_file_aio_write_checks(
 	xfs_fsize_t		new_size;
 	int			error = 0;
 
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
@@ -760,14 +761,24 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
 		return ret;
 
+	/*
+	 * Recheck if there are cached pages that need invalidate after we got
+	 * the iolock to protect against other threads adding new pages while
+	 * we were waiting for the iolock.
+	 */
+	if (mapping->nrpages && *iolock == XFS_IOLOCK_SHARED) {
+		xfs_rw_iunlock(ip, *iolock);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_rw_ilock(ip, *iolock);
+	}
+
 	if (mapping->nrpages) {
-		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
 		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
 							FI_REMAPF_LOCKED);
 		if (ret)
@@ -812,7 +823,7 @@ xfs_file_buffered_aio_write(
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)


