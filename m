Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2EAUYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:24:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2EAUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:24:52 -0400
Date: Tue, 1 May 2012 13:24:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm + fs: prepare for non-page entries in page cache
Message-Id: <20120501132449.30485966.akpm@linux-foundation.org>
In-Reply-To: <20120501201504.GB2112@cmpxchg.org>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
	<1335861713-4573-3-git-send-email-hannes@cmpxchg.org>
	<20120501120246.83d2ce28.akpm@linux-foundation.org>
	<20120501201504.GB2112@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 22:15:04 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, May 01, 2012 at 12:02:46PM -0700, Andrew Morton wrote:
> > On Tue,  1 May 2012 10:41:50 +0200
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -544,8 +544,7 @@ static void evict(struct inode *inode)
> > >  	if (op->evict_inode) {
> > >  		op->evict_inode(inode);
> > >  	} else {
> > > -		if (inode->i_data.nrpages)
> > > -			truncate_inode_pages(&inode->i_data, 0);
> > > +		truncate_inode_pages(&inode->i_data, 0);
> > 
> > Why did we lose this optimisation?
> 
> For inodes with only shadow pages remaining in the tree, because there
> is no separate counter for them.  Otherwise, we'd leak the tree nodes.
> 
> I had mapping->nrshadows at first to keep truncation conditional, but
> thought that using an extra word per cached inode would be worse than
> removing this optimization.  There is not too much being done when the
> tree is empty.
> 
> Another solution would be to include the shadows count in ->nrpages,
> but filesystems use this counter for various other purposes.
> 
> Do you think it's worth reconsidering?

It doesn't sound like it's worth adding ->nrshadows for only that
reason.

That's a pretty significant alteration in the meaning of ->nrpages. 
Did this not have any other effects?

What does truncate do?  I assume it invalidates shadow page entries in
the radix tree?  And frees the radix-tree nodes?

The patchset will make lookups slower in some (probably obscure)
circumstances, due to the additional radix-tree nodes.

I assume that if a pagecache lookup encounters a radix-tree node which
contains no real pages, the search will terminate at that point?  We
don't pointlessly go all the way down to the leaf nodes?

