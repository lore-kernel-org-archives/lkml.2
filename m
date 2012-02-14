Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394Ab2BNXvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:51:12 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47745 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755652Ab2BNXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:51:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGHxOk95LI9Y/2dsb2JhbABDsFOBCIFyAQEFJxMcIxAIAxguFCUDIRPAfROLTAIBEQoZBAwIAw4EBgMRARQCg3MIKgwDBguDLwSVMYk1iUQ
Date: Wed, 15 Feb 2012 10:51:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-ID: <20120214235106.GL7479@dastard>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
 <1328832993-23228-2-git-send-email-john.stultz@linaro.org>
 <20120214051659.GH14132@dastard>
 <1329198932.2753.62.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329198932.2753.62.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 09:55:32PM -0800, John Stultz wrote:
> On Tue, 2012-02-14 at 16:16 +1100, Dave Chinner wrote:
> > On Thu, Feb 09, 2012 at 04:16:33PM -0800, John Stultz wrote:
> > > This patch provides new fadvise flags that can be used to mark
> > > file pages as volatile, which will allow it to be discarded if the
> > > kernel wants to reclaim memory.
> > > 
> > > This is useful for userspace to allocate things like caches, and lets
> > > the kernel destructively (but safely) reclaim them when there's memory
> > > pressure.
> > .....
> > > @@ -655,6 +656,8 @@ struct address_space {
> > >  	spinlock_t		private_lock;	/* for use by the address_space */
> > >  	struct list_head	private_list;	/* ditto */
> > >  	struct address_space	*assoc_mapping;	/* ditto */
> > > +	struct range_tree_node	*volatile_root;	/* volatile range list */
> > > +	struct mutex		vlist_mutex;	/* protect volatile_list */
> > >  } __attribute__((aligned(sizeof(long))));
> > 
> > So you're adding roughly 32 bytes to every cached inode in the
> > system? This will increasing the memory footprint of the inode cache
> > by 2-5% (depending on the filesystem). Almost no-one will be using
> > this functionality on most inodes that are cached in the system, so
> > that seems like a pretty bad trade-off to me...
> 
> Yea. Bloating the address_space is a concern I'm aware of, but for the
> initial passes I left it to see where folks would rather I keep it.
> Pushing the mutex into a range_tree_root structure or something could
> cut this down, but I still suspect it won't be loved. Another idea would
> be to manage the mapping -> range tree separately via something like a
> hash.  Do you have any preferences or suggestions here?

Given that it is a single state bit per page (volatile/non volatile)
you could just use a radix tree tag for keeping the state. Changing
the state isn't a performance critical operation, and tagging large
ranges isn't that expensive (e.g. we do that in the writeback code),
so I'm not sure the overhead of a separate tree is necessary here....

That doesn't help with the reclaim side of things, but I would have
thought that such functioanlity would be better integrated into the
VM page cache/lru scanning code than adding a shrinker to shrink the
page cache additionally on top of what the VM has already done
before calling the shrinkers. I'm not sure what is best here,
though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
