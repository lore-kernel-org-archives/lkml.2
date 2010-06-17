Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0FQAZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:25:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab0FQAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:25:03 -0400
Date: Wed, 16 Jun 2010 17:18:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/12] vmscan: kill prev_priority completely
Message-Id: <20100616171847.71703d1a.akpm@linux-foundation.org>
In-Reply-To: <4C196219.6000901@redhat.com>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-6-git-send-email-mel@csn.ul.ie>
	<20100616163709.1e0f6b56.akpm@linux-foundation.org>
	<4C196219.6000901@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 19:45:29 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 06/16/2010 07:37 PM, Andrew Morton wrote:
> 
> > This would have been badder in earlier days when we were using the
> > scanning priority to decide when to start unmapping pte-mapped pages -
> > page reclaim would have been recirculating large blobs of mapped pages
> > around the LRU until the priority had built to the level where we
> > started to unmap them.
> >
> > However that priority-based decision got removed and right now I don't
> > recall what it got replaced with.  Aren't we now unmapping pages way
> > too early and suffering an increased major&minor fault rate?  Worried.
> 
> We keep a different set of statistics to decide whether to
> reclaim only page cache pages, or both page cache and
> anonymous pages. The function get_scan_ratio parses those
> statistics.

I wasn't talking about anon-vs-file.  I was referring to mapped-file
versus not-mapped file.  If the code sees a mapped page come off the
tail of the LRU it'll just unmap and reclaim the thing.  This policy
caused awful amounts of paging activity when someone started doing lots
of read() activity, which is why the VM was changed to value mapped
pagecache higher than unmapped pagecache.  Did this biasing get
retained and if so, how?

> >    So.  What's up with that?  I don't even remember _why_ we disable
> >    the swap token once the scanning priority gets severe and the code
> >    comments there are risible.  And why do we wait until priority==0
> >    rather than priority==1?
> 
> The reason is that we never page out the pages belonging to the
> process owning the swap token (with the exception of that process
> evicting its own pages).
> 
> If that process has a really large RSS in the current zone, and
> we are having problems freeing pages, it may be beneficial to
> also evict pages from that process.
> 
> Now that the LRU lists are split out into file backed and swap
> backed, it may be a lot easier to find pages to evict.  That
> may mean we could notice we're getting into trouble at much
> higher priority levels and disable the swap token at a higher
> priority level.

hm, lots of "may"s there.

Does thrash-avoidance actually still work?

> I do not believe prev_priority will be very useful here, since
> we'd like to start out with small scans whenever possible.

Why?

> > - Busted prev_priority means that lumpy reclaim will act oddly.
> >    Every time someone goes into do some recalim, they'll start out not
> >    doing lumpy reclaim.  Then, after a while, they'll get a clue and
> >    will start doing the lumpy thing.  Then they return from reclaim and
> >    the next recalim caller will again forget that he should have done
> >    lumpy reclaim.
> 
> How common are lumpy reclaims, anyway?

A lot more than they should be, I suspect, given the recent trend
towards asking for higher-order allocations.  Kernel developers should
be prohibited from using more than 512M of RAM.

> Isn't it more likely that in-between every two higher-order
> reclaims, a number of order zero reclaims will be happening?

Sounds likely, yes.   Need prev_priority[DEF_PRIORITY], sigh.

> In that case, the prev_priority logic may have introduced the
> kind of behavioural bug you describe above...
> 
> > And one has to wonder: if we're making these incorrect decisions based
> > upon a bogus view of the current scanning difficulty, why are these
> > various priority-based thresholding heuristics even in there?  Are they
> > doing anything useful?
> 
> The prev_priority code was useful when we had filesystem and
> swap backed pages mixed on the same LRU list.

No, stop saying swap! ;)

It's all to do with mapped pagecache versus unmapped pagecache.  "ytf
does my browser get paged out all the time".



