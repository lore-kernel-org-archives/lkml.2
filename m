Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab1GWWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 18:02:19 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33197 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1GWWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 18:02:15 -0400
Date: Sun, 24 Jul 2011 00:02:12 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110723220212.GA1648@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723203824.GB1652@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.23 at 22:38 +0200, Markus Trippelsdorf wrote:
> On 2011.07.23 at 16:26 -0400, Josef Bacik wrote:
> > On 07/23/2011 02:09 PM, Markus Trippelsdorf wrote:
> > > On 2011.06.29 at 14:05 -0400, Josef Bacik wrote:
> > >> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> > >> in fsync to make it less of a painful operation, so push down taking i_mutex and
> > >> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> > >> file systems can drop taking the i_mutex altogether it seems, like ext3 and
> > >> ocfs2.  For correctness sake I just pushed everything down in all cases to make
> > >> sure that we keep the current behavior the same for everybody, and then each
> > >> individual fs maintainer can make up their mind about what to do from there.
> > >
> > > At least the xfs part of this patch is broken.
> > > Running the latest git-kernel bogofilter doesn't work anymore on my xfs
> > > partition. When I run "bogoutil -d wordlist.db" to dump the contents of
> > > the database, it produces no output at all.
> > >
> > 
> > Already fixed and sent a patch out earlier this week.  Thanks,
> 
> No. This happens with your patch already applied. See my other reply.

The following patch fixes the problem for me:

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index cca00f4..2e23e3d 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -881,11 +881,14 @@ xfs_file_aio_write(
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
+		int error;
 
 		xfs_rw_iunlock(ip, iolock);
-		ret = -xfs_file_fsync(file, pos, end,
+		error = -xfs_file_fsync(file, pos, end,
 				      (file->f_flags & __O_SYNC) ? 0 : 1);
 		xfs_rw_ilock(ip, iolock);
+		if (error)
+			ret = error;
 	}
 
 out_unlock:

-- 
Markus
