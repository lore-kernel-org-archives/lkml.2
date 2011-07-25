Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1GYITb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:19:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1GYITZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:19:25 -0400
Date: Mon, 25 Jul 2011 09:19:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 2/8] xfs: Warn if direct reclaim tries to writeback pages
Message-ID: <20110725081918.GZ5349@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-3-git-send-email-mgorman@suse.de>
 <20110724113200.GA26332@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110724113200.GA26332@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:32:00AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 21, 2011 at 05:28:44PM +0100, Mel Gorman wrote:
> > --- a/fs/xfs/linux-2.6/xfs_aops.c
> > +++ b/fs/xfs/linux-2.6/xfs_aops.c
> > @@ -930,12 +930,13 @@ xfs_vm_writepage(
> >  	 * random callers for direct reclaim or memcg reclaim.  We explicitly
> >  	 * allow reclaim from kswapd as the stack usage there is relatively low.
> >  	 *
> > -	 * This should really be done by the core VM, but until that happens
> > -	 * filesystems like XFS, btrfs and ext4 have to take care of this
> > -	 * by themselves.
> > +	 * This should never happen except in the case of a VM regression so
> > +	 * warn about it.
> >  	 */
> > -	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> > +	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC) {
> > +		WARN_ON_ONCE(1);
> >  		goto redirty;
> 
> The nicer way to write this is
> 
> 	if (WARN_ON(current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> 		goto redirty;
> 

I wanted to avoid side effects if WARN_ON was compiled out similar to
the care that is normally taken for BUG_ON but it's unnecessary and
your version is far tidier. Do you really want WARN_ON used instead
of WARN_ON_ONCE()?

-- 
Mel Gorman
SUSE Labs
