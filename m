Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2CIOW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:22:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab2CIOW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:22:58 -0500
Date: Fri, 9 Mar 2012 15:22:53 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120309142253.GB14159@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
 <1330963277-26336-12-git-send-email-jack@suse.cz>
 <20120308232041.GU3592@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308232041.GU3592@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-03-12 10:20:41, Dave Chinner wrote:
> On Mon, Mar 05, 2012 at 05:01:09PM +0100, Jan Kara wrote:
> > Generic code now blocks all writers from standard write paths. So we block all
> > writers coming from ioctl and replace blocking of transactions on frozen
> > filesystem with a debugging check. As a bonus, we get a protection of ioctl
> > against racing remount read-only. We also convert xfs_file_aio_write() to a
> > non-racy freeze protection.
> ....
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 329b06a..6468a2a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -577,7 +577,6 @@ xfs_trans_alloc(
> >  	xfs_mount_t	*mp,
> >  	uint		type)
> >  {
> > -	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> >  	return _xfs_trans_alloc(mp, type, KM_SLEEP);
> >  }
> 
> So what is there to stop internal XFS threads from starting
> transactions when the filesystem is frozen? Previously this
> SB_FREEZE_TRANS would guarantee even internal fucntions would get
> stopped, but now there's nothing?
  I've checked XFS now and I didn't find any work that would be done on a
clean filesystem. I found:
_xfs_mru_cache_reap() - doesn't seem to do any IO
xfs_end_io(), xfs_buf_iodone_work() - shouldn't be a problem either since only
  reads can happen on a frozen filesystem
xfs_reclaim_worker() - everything is clean so no IO should happen
xfs_flush_worker() - everything is clean so no IO should happen
xfs_sync_worker() - again the same if I understand the code right

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
