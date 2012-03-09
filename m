Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2CIIXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:23:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab2CIIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:23:09 -0500
Date: Fri, 9 Mar 2012 09:23:06 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH 11/19] xfs: Convert to new freezing code
Message-ID: <20120309082306.GB21038@quack.suse.cz>
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
> 
> I do beleive that ext4 has the same problem (the issue reported with
> the lazy inode init background thread), and I can see that any other
> filesystem that can make modifications via internal triggers will
> see the same problem - freeze doesn't block them any more...
  Yes, I'll have to audit filesystem internal threads. I forgot about these
in the first round. Most of them shouldn't have anything to do because the
filesystem is clean but there are exceptions as ext4 lazyinit has shown.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
