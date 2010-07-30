Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0G3Wl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 18:41:28 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:48825 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab0G3Wl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 18:41:26 -0400
Subject: Re: [PATCH 6/6] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20100730150601.199c5618.akpm@linux-foundation.org>
References: <1280497020-22816-1-git-send-email-mel@csn.ul.ie>
	 <1280497020-22816-7-git-send-email-mel@csn.ul.ie>
	 <20100730150601.199c5618.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 18:40:53 -0400
Message-ID: <1280529653.12852.67.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 15 msgs/h 1 sum rcpts/h 23 sum msgs/h 2 total rcpts 723 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E6B0609EC3226EFD432FB1C498078FB946C397EE
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 291 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 15:06 -0700, Andrew Morton wrote:
> On Fri, 30 Jul 2010 14:37:00 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > There are a number of cases where pages get cleaned but two of concern
> > to this patch are;
> >   o When dirtying pages, processes may be throttled to clean pages if
> >     dirty_ratio is not met.
> 
> Ambiguous.  I assume you meant "if dirty_ratio is exceeded".
> 
> >   o Pages belonging to inodes dirtied longer than
> >     dirty_writeback_centisecs get cleaned.
> > 
> > The problem for reclaim is that dirty pages can reach the end of the LRU if
> > pages are being dirtied slowly so that neither the throttling or a flusher
> > thread waking periodically cleans them.
> > 
> > Background flush is already cleaning old or expired inodes first but the
> > expire time is too far in the future at the time of page reclaim. To mitigate
> > future problems, this patch wakes flusher threads to clean 4M of data -
> > an amount that should be manageable without causing congestion in many cases.
> > 
> > Ideally, the background flushers would only be cleaning pages belonging
> > to the zone being scanned but it's not clear if this would be of benefit
> > (less IO) or not (potentially less efficient IO if an inode is scattered
> > across multiple zones).
> > 
> 
> Sigh.  We have sooo many problems with writeback and latency.  Read
> https://bugzilla.kernel.org/show_bug.cgi?id=12309 and weep.  Everyone's
> running away from the issue and here we are adding code to solve some
> alleged stack-overflow problem which seems to be largely a non-problem,
> by making changes which may worsen our real problems.
> 
> direct-reclaim wants to write a dirty page because that page is in the
> zone which the caller wants to allcoate from!  Telling the flusher
> threads to perform generic writeback will sometimes cause them to just
> gum the disk up with pages from different zones, making it even
> harder/slower to allocate a page from the zones we're interested in,
> no?
> 
> If/when that happens, the problem will be rare, subtle, will take a
> long time to get reported and will take years to understand and fix and
> will probably be reported in the monster bug report which everyone's
> hiding from anyway.

There is that, and then there are issues with the VM simply lying to the
filesystems.

See https://bugzilla.kernel.org/show_bug.cgi?id=16056

Which basically boils down to the following: kswapd tells the filesystem
that it is quite safe to do GFP_KERNEL allocations in pageouts and as
part of try_to_release_page().

In the case of pageouts, it does set the 'WB_SYNC_NONE', 'nonblocking'
and 'for_reclaim' flags in the writeback_control struct, and so the
filesystem has at least some hint that it should do non-blocking i/o.

However if you trust the GFP_KERNEL flag in try_to_release_page() then
the kernel can and will deadlock, and so I had to add in a hack
specifically to tell the NFS client not to trust that flag if it comes
from kswapd.

 Trond

