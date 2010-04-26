Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0DZAqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 20:46:55 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:58873 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017Ab0DZAqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 20:46:53 -0400
Date: Mon, 26 Apr 2010 10:46:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 4/4] xfs: remove nr_to_write writeback windup.
Message-ID: <20100426004645.GC11437@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-5-git-send-email-david@fromorbit.com>
 <20100422190936.GB19286@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422190936.GB19286@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 09:09:37PM +0200, Jan Kara wrote:
> On Tue 20-04-10 12:41:54, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that the background flush code has been fixed, we shouldn't need to
> > silently multiply the wbc->nr_to_write to get good writeback. Remove
> > that code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_aops.c |    8 --------
> >  1 files changed, 0 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> > index 9962850..2b2225d 100644
> > --- a/fs/xfs/linux-2.6/xfs_aops.c
> > +++ b/fs/xfs/linux-2.6/xfs_aops.c
> > @@ -1336,14 +1336,6 @@ xfs_vm_writepage(
> >  	if (!page_has_buffers(page))
> >  		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
> >  
> > -
> > -	/*
> > -	 *  VM calculation for nr_to_write seems off.  Bump it way
> > -	 *  up, this gets simple streaming writes zippy again.
> > -	 *  To be reviewed again after Jens' writeback changes.
> > -	 */
> > -	wbc->nr_to_write *= 4;
> > -
>   Hum, are you sure about this? I thought it's there because VM passes at
> most 1024 pages to write from background writeback and you wanted to write
> more in one go (at least ext4 wants to do this).

About 500MB/s sure. ;)

Seriously though, the problem that lead to us adding this
multiplication was that writeback was not feeding XFS 1024 pages at
a time - we were getting much less than this (somewhere in the order
of 32-64 pages at a time. With the fixes I posted, in every
circumstance I can see we are the correct number of pages (1024
pages or what is left over from the last inode) being passed into
->writepages, and writeback is back to full speed without needing
this crutch. Indeed, this multiplication now causes  nr_to_write to
go ballistic in some cirumstances, and that causes latency and
fairness problems that will significantly reduce write rates for
applications like NFS servers.

Realistically, XFS doesn't need to write more than 1024 pages in one
go - the reason ext4 needs to do this is it's amazingly convoluted
delayed allocation path and the fact that it's allocator is nowhere
near as good at contiguous allocation across multiple invocations as
the XFS allocator is. IOWs, XFS really just needs enough contiguous
pages to be able to form large IOs, and given that most hardware
limits the IO size to 1MB on x86_64, then 1024 pages is more than
enough to provide this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
