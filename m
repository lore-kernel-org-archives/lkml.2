Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0EZXBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:01:44 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:34568 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367Ab0EZXBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:01:42 -0400
Date: Thu, 27 May 2010 09:01:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/5] inode: Make unused inode LRU per superblock
Message-ID: <20100526230129.GA1395@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-2-git-send-email-david@fromorbit.com>
 <20100526161732.GC22536@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100526161732.GC22536@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:17:33AM +1000, Nick Piggin wrote:
> On Tue, May 25, 2010 at 06:53:04PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode unused list is currently a global LRU. This does not match
> > the other global filesystem cache - the dentry cache - which uses
> > per-superblock LRU lists. Hence we have related filesystem object
> > types using different LRU reclaimatin schemes.
> 
> Is this an improvement I wonder? The dcache is using per sb lists
> because it specifically requires sb traversal.

Right - I originally implemented the per-sb dentry lists for
scalability purposes. i.e. to avoid monopolising the dentry_lock
during unmount looking for dentries on a specific sb and hanging the
system for several minutes.

However, the reason for doing this to the inode cache is not for
scalability, it's because we have a tight relationship between the
dentry and inode cacheѕ. That is, reclaim from the dentry LRU grows
the inode LRU.  Like the registration of the shrinkers, this is kind
of an implicit, undocumented behavour of the current shrinker
implemenation.

What this patch series does is take that implicit relationship and
make it explicit.  It also allows other filesystem caches to tie
into the relationship if they need to (e.g. the XFS inode cache).
What it _doesn't do_ is change the macro level behaviour of the
shrinkers...

> What allocation/reclaim really wants (for good scalability and NUMA
> characteristics) is per-zone lists for these things. It's easy to
> convert a single list into per-zone lists.
>
> It is much harder to convert per-sb lists into per-sb x per-zone lists.

No it's not. Just convert the s_{dentry,inode}_lru lists on each
superblock and call the shrinker with a new zone mask field to pick
the correct LRU. That's no harder than converting a global LRU.
Anyway, you'd still have to do per-sb x per-zone lists for the dentry LRUs,
so changing the inode cache to per-sb makes no difference.

However, this is a moot point because we don't have per-zone shrinker
interfaces. That's an entirely separate discussion because of the
macro-level behavioural changes it implies....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
