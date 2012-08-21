Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2HUPlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:41:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab2HUPlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:41:01 -0400
Date: Tue, 21 Aug 2012 18:41:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120821154142.GA8268@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
 <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
 <20120821135223.GA7117@redhat.com>
 <1345562166.23018.109.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345562166.23018.109.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:16:06PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-08-21 at 16:52 +0300, Michael S. Tsirkin wrote:
> > > +             rcu_read_lock();
> > > +             mapping = rcu_dereference(page->mapping);
> > > +             if (mapping_balloon(mapping))
> > > +                     ret = true;
> > > +             rcu_read_unlock();
> > 
> > This looks suspicious: you drop rcu_read_unlock
> > so can't page switch from balloon to non balloon? 
> 
> RCU read lock is a non-exclusive lock, it cannot avoid anything like
> that.

You are right, of course. So even keeping rcu_read_lock across both test
and operation won't be enough - you need to make this function return
the mapping and pass it to isolate_page/putback_page so that it is only
dereferenced once.

-- 
MST
