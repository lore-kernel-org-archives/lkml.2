Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0DRTFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:05:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0DRTFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:05:46 -0400
Date: Sun, 18 Apr 2010 15:05:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100418190526.GA1692@infradead.org>
References: <20100413202021.GZ13327@think> <20100414014041.GD2493@dastard> <20100414155233.D153.A69D9226@jp.fujitsu.com> <20100414072830.GK2493@dastard> <20100414085132.GJ25756@csn.ul.ie> <20100415013436.GO2493@dastard> <20100415102837.GB10966@csn.ul.ie> <20100416041412.GY2493@dastard> <20100416151403.GM19264@csn.ul.ie> <20100417203239.dda79e88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100417203239.dda79e88.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 08:32:39PM -0400, Andrew Morton wrote:
> The poor IO patterns thing is a regression.  Some time several years
> ago (around 2.6.16, perhaps), page reclaim started to do a LOT more
> dirty-page writeback than it used to.  AFAIK nobody attempted to work
> out why, nor attempted to try to fix it.

I just know that we XFS guys have been complaining about it a lot..

But that was mostly a tuning issue - before writeout mostly happened
from pdflush.  If we got into kswapd or direct reclaim we already
did get horrible I/O patterns - it just happened far less often.

> Regarding simply not doing any writeout in direct reclaim (Dave's
> initial proposal): the problem is that pageout() will clean a page in
> the target zone.  Normal writeout won't do that, so we could get into a
> situation where vast amounts of writeout is happening, but none of it
> is cleaning pages in the zone which we're trying to allocate from. 
> It's quite possibly livelockable, too.

As Chris mentioned currently btrfs and ext4 do not actually do delalloc
conversions from this path, so for typical workloads the amount of
writeout that can happen from this path is extremly limited.  And unless
we get things fixed we will have to do the same for XFS.  I'd be much
more happy if we could just sort it out at the VM level, because this
means we have one sane place for this kind of policy instead of three
or more hacks down inside the filesystems.  It's rather interesting
that all people on the modern fs side completely agree here what the
problem is, but it seems rather hard to convince the VM side to do
anything about it.

> To solve the stack-usage thing: dunno, really.  One could envisage code
> which skips pageout() if we're using more than X amount of stack, but
> that sucks.

And it doesn't solve other issues, like the whole lock taking problem.

> Another possibility might be to hand the target page over
> to another thread (I suppose kswapd will do) and then synchronise with
> that thread - get_page()+wait_on_page_locked() is one way.  The helper
> thread could of course do writearound.

Allowing the flusher threads to do targeted writeout would be the
best from the FS POV.  We'll still have one source of the I/O, just
with another know on how to select the exact region to write out.
We can still synchronously wait for the I/O for lumpy reclaim if really
nessecary.

