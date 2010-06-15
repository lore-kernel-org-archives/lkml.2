Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0FOLNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:13:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab0FOLNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:13:42 -0400
Date: Tue, 15 Jun 2010 21:13:37 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615111337.GK6138@laptop>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
 <20100615105341.GB31051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615105341.GB31051@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 06:53:41AM -0400, Christoph Hellwig wrote:
> > +	/*
> > +	 * XXX: This is the Holy Hand Grenade of PotentiallyInvalidMapping. As
> > +	 * the page lock has been dropped by ->writepage, that mapping could
> > +	 * be anything
> > +	 */
> 
> Why is this an XXX comment?

It's just a pretty simple use-after-free. Maybe people forget it because
->writepage is an asynchronous API.


> > + *
> > + * XXX: Is there a problem with holding multiple page locks like this?
> 
> I think there is.  There's quite a few places that do hold multiple
> pages locked, but they always lock pages in increasing page->inxex order.
> Given that this locks basically in random order it could cause problems
> for those places.

There shouldn't be a problem _holding_ the locks, but there is a problem
waiting for multiple locks out of page->index order.

But there is a problem with holding the lock of a lot of pages while
calling ->writepage on them. So yeah, you can't do that.

Hmm, I should rediff that lockdep page_lock patch and get it merged.
(although I don't know if that can catch these all these problems easily)

