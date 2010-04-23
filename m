Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0DWB6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:58:22 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:38502 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752035Ab0DWB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:58:11 -0400
Date: Fri, 23 Apr 2010 11:58:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100423015801.GB10390@dastard>
References: <1271118255-21070-2-git-send-email-david@fromorbit.com>
 <20100418001514.GA26575@infradead.org>
 <20100419140039.GQ5683@laptop>
 <20100420004149.GA14744@dastard>
 <20100420083840.GR5683@laptop>
 <20100420103216.GK15130@dastard>
 <20100421084004.GS5683@laptop>
 <20100422163211.GA2478@infradead.org>
 <20100422163801.GZ5683@laptop>
 <20100422164247.GA15882@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422164247.GA15882@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:42:47PM -0400, Christoph Hellwig wrote:
> On Fri, Apr 23, 2010 at 02:38:01AM +1000, Nick Piggin wrote:
> > I don't understand, it should be implemented like just all the other
> > shrinkers AFAIKS. Like the dcache one that has to shrink multiple
> > superblocks. There is absolutely no requirement for this API change
> > to implement it in XFS.
> 
> The dcache shrinker is an example for a complete mess.

Yes, it is, and one that I think we can clean up significantly by
the use of context based shrinkers.

IMO, a better approach to the VFS shrinkers is to leverage the fact
we already have per-sb dentry LRUs and convert the inode cache to a
per-sb LRU as well.

We can then remove the current dependency problems by moving to
a single context based shrinker (i.e. per-sb) to reclaim from the
per-sb dentry LRU, followed by the per-sb inode LRU via a single
shrinker. That is, remove the global scope from them because that is
the cause of the shrinker call-order dependency problems.

Further, if we then add a filesystem callout to the new superblock
shrinker callout, we can handle all the needs of XFS (and other
filesystems) without requiring them to have global filesystem lists
and without introducing new dependencies between registered
shrinkers.

And given that the shrinker currently handles proportioning reclaim
based on the number of objects reported by the cache, it also allows
us to further simplify the dentry cache reclaim by removing all the
proportioning stuff it does right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
