Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0JPH5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:16 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab0JPH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBIUM
Date: Sat, 16 Oct 2010 18:57:13 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] fs: split locking of inode writeback and LRU
 lists
Message-ID: <20101016075713.GQ19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-14-git-send-email-david@fromorbit.com>
 <20101008074243.GB24089@infradead.org>
 <20101008080018.GV4681@dastard>
 <20101008081816.GA17577@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008081816.GA17577@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:18:16AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 07:00:18PM +1100, Dave Chinner wrote:
> > > >  
> > > > -		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
> > > > +		if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
> > > >  			requeue_io(inode);
> > > >  			continue;
> > > >  		}
> > > 
> > > What does this have to do with the rest of the patch?
> > 
> > That's because there's now a window between setting I_FREEING and taking
> > the inode off the writeback list which means that we can see inodes
> > in that state here. Generally it means that the code setting
> > I_FREEING is spinning waiting for the wb->b_lock that this thread
> > currently holds so it can be removed from the list.. Hence the requeue
> > to move the inode out of the way and keep processing inodes for
> > writeback.
> 
> That needs some documentation both in the changelog and in the code
> I think.

This is another instance where the irregular i_lock locking is making
these little subtleties to the locking. I think that is actually much
worse for maintainence/complexity than a few trylocks which can be
mostly removed with rcu anyway (which are obvious because of the well
documented lock order).


