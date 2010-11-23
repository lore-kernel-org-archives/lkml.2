Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0KWUgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:36:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab0KWUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:36:32 -0500
Date: Tue, 23 Nov 2010 12:35:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Ben Gamari <bgamari@gmail.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
Message-Id: <20101123123535.438e9750.akpm@linux-foundation.org>
In-Reply-To: <20101123145856.GQ19571@csn.ul.ie>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<20101122141449.9de58a2c.akpm@linux-foundation.org>
	<AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
	<20101122210132.be9962c7.akpm@linux-foundation.org>
	<20101123093859.GE19571@csn.ul.ie>
	<87k4k49jii.fsf@gmail.com>
	<20101123145856.GQ19571@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 14:58:56 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Tue, Nov 23, 2010 at 09:55:49AM -0500, Ben Gamari wrote:
> > On Tue, 23 Nov 2010 09:38:59 +0000, Mel Gorman <mel@csn.ul.ie> wrote:
> > > > If it's mapped pagecache then the user was being a bit silly (or didn't
> > > > know that some other process had mapped the file).  In which case we
> > > > need to decide what to do - leave the page alone, deactivate it, or
> > > > half-deactivate it as this patch does.
> > > > 
> > > 
> > > What are the odds of an fadvise() user having used mincore() in advance
> > > to determine if the page was in use by another process? I would guess
> > > "low" so this half-deactivate gives a chance for the page to be promoted
> > > again as well as a chance for the flusher threads to clean the page if
> > > it really is to be reclaimed.
> > > 
> > Do we really want to make the user jump through such hoops as using
> > mincore() just to get the kernel to handle use-once pages properly?
> 
> I would think "no" which is why I support half-deactivating pages so they won't
> have to.

If the page is page_mapped() then we can assume that some other process
is using it and we leave it alone *altogether*.

If the page is dirty or under writeback (and !page_mapped()) then we
should assume that we should free it asap.  The PageReclaim() trick
might help with that.

I just don't see any argument for moving the page to the head of the
inactive LRU as a matter of policy.  We can park it there because we
can't think of anythnig else to do with it, but it's the wrong place
for it.


