Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1GWTce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:32:34 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34939 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1GWTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:32:28 -0400
Date: Sat, 23 Jul 2011 21:32:25 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110723193225.GA1652@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723180942.GA1616@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.23 at 20:09 +0200, Markus Trippelsdorf wrote:
> On 2011.06.29 at 14:05 -0400, Josef Bacik wrote:
> > Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> > in fsync to make it less of a painful operation, so push down taking i_mutex and
> > the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> > file systems can drop taking the i_mutex altogether it seems, like ext3 and
> > ocfs2.  For correctness sake I just pushed everything down in all cases to make
> > sure that we keep the current behavior the same for everybody, and then each
> > individual fs maintainer can make up their mind about what to do from there.
> 
> At least the xfs part of this patch is broken.
> Running the latest git-kernel bogofilter doesn't work anymore on my xfs
> partition. When I run "bogoutil -d wordlist.db" to dump the contents of
> the database, it produces no output at all. 
> 
> Reverting 02c24a82187d (or only the xfs part of that commit) "solves"
> the problem.

Looks like a locking problem (note the stale xfs_rw_ilock):

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7f782af..fbbf657 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -127,6 +127,8 @@ xfs_iozero(
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
+	loff_t			start,
+	loff_t			end,
 	int			datasync)
 {
 	struct inode		*inode = file->f_mapping->host;
@@ -138,6 +140,10 @@ xfs_file_fsync(
 
 	trace_xfs_file_fsync(ip);
 
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
@@ -875,18 +881,11 @@ xfs_file_aio_write(
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
-		int error, error2;
 
 		xfs_rw_iunlock(ip, iolock);
-		error = filemap_write_and_wait_range(mapping, pos, end);
+		ret = -xfs_file_fsync(file, pos, end,
+				      (file->f_flags & __O_SYNC) ? 0 : 1);
 		xfs_rw_ilock(ip, iolock);
-
-		error2 = -xfs_file_fsync(file,
-					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (error)
-			ret = error;
-		else if (error2)
-			ret = error2;
 	}
 
 out_unlock:

-- 
Markus
