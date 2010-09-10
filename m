Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0IJC5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:57:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38245 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0IJC5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:57:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct reclaim allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100909150558.GB340@csn.ul.ie>
References: <alpine.DEB.2.00.1009090931360.18975@router.home> <20100909150558.GB340@csn.ul.ie>
Message-Id: <20100910115503.C95E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Sep 2010 11:56:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Sep 09, 2010 at 09:32:52AM -0500, Christoph Lameter wrote:
> > On Thu, 9 Sep 2010, Mel Gorman wrote:
> > 
> > > > This will have the effect of never sending IPIs for slab allocations since
> > > > they do not do allocations for orders > PAGE_ALLOC_COSTLY_ORDER.
> > > >
> > >
> > > The question is how severe is that? There is somewhat of an expectation
> > > that the lower orders free naturally so it the IPI justified? That said,
> > > our historical behaviour would have looked like
> > >
> > > if (!page && !drained && order) {
> > > 	drain_all_pages();
> > > 	draiained = true;
> > > 	goto retry;
> > > }
> > >
> > > Play it safe for now and go with that?
> > 
> > I am fine with no IPIs for order <= COSTLY. Just be aware that this is
> > a change that may have some side effects.
> 
> I made the choice consciously. I felt that if slab or slub were depending on
> IPIs to make successful allocations in low-memory conditions that it would
> experience varying stalls on bigger machines due to increased interrupts that
> might be difficult to diagnose while not necessarily improving allocation
> success rates. I also considered that if the machine is under pressure then
> slab and slub may also be releasing pages of the same order and effectively
> recycling their pages without depending on IPIs.

+1.

In these days, average numbers of CPUs are increasing. So we need to be afraid
IPI storm than past.



