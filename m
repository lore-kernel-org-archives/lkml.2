Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1GXLyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:54:32 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48781 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1GXLy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:54:26 -0400
Date: Sun, 24 Jul 2011 13:54:20 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Subject: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
Message-ID: <20110724115420.GA1626@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
 <20110723220212.GA1648@x4.trippels.de>
 <20110724111625.GA12658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724111625.GA12658@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.24 at 07:16 -0400, Christoph Hellwig wrote:
> On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> > The following patch fixes the problem for me:
> 
> Good catch, can you send it with a proper signoff and description?

The fsync prototype change commit 02c24a82187d accidentally overwrote
the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
writes. Fix this by checking if an error occured when calling
xfs_file_fsync and only change the return value in this case.
In addition xfs_file_fsync actually returns a normal negative error, so
fix this, too.
---
 fs/xfs/linux-2.6/xfs_file.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index cca00f4..825390e 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -881,11 +881,14 @@ xfs_file_aio_write(
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
+		int error;
 
 		xfs_rw_iunlock(ip, iolock);
-		ret = -xfs_file_fsync(file, pos, end,
+		error = xfs_file_fsync(file, pos, end,
 				      (file->f_flags & __O_SYNC) ? 0 : 1);
 		xfs_rw_ilock(ip, iolock);
+		if (error)
+			ret = error;
 	}
 
 out_unlock:
-- 
Markus
