Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2GTQiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:38:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:7378 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab2GTQiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:38:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="168997373"
Subject: Re: [PATCH] Cgroup: Fix memory accounting scalability in
 shrink_page_list
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <5008CE38.2020300@jp.fujitsu.com>
References: <1342740866.13492.50.camel@schen9-DESK>
	 <5008CE38.2020300@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 09:38:18 -0700
Message-ID: <1342802298.13492.59.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 12:19 +0900, Kamezawa Hiroyuki wrote:

> 
> When I added batching, I didn't touch page-reclaim path because it delays
> res_counter_uncharge() and make more threads run into page reclaim.
> But, from above score, bactching seems required.
> 
> And because of current design of per-zone-per-memcg-LRU, batching
> works very very well....all lru pages shrink_page_list() scans are on
> the same memcg.
> 
> BTW, it's better to show 'how much improved' in patch description..

I didn't put the specific improvement in patch description as the
performance change is specific to my machine and benchmark and
improvement could be variable for others.  However, I did include the
specific number in the body of my message.  Hope that is enough.
 

> 
> 
> > ---
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 33dc256..aac5672 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -779,6 +779,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >
> >   	cond_resched();
> >
> > +	mem_cgroup_uncharge_start();
> >   	while (!list_empty(page_list)) {
> >   		enum page_references references;
> >   		struct address_space *mapping;
> > @@ -1026,6 +1027,7 @@ keep_lumpy:
> >
> >   	list_splice(&ret_pages, page_list);
> >   	count_vm_events(PGACTIVATE, pgactivate);
> > +	mem_cgroup_uncharge_end();
> 
> I guess placing mem_cgroup_uncharge_end() just after the loop may be better looking.

I initially though of doing that.  I later pushed the statement down to
after list_splice(&ret_pages, page_list) as that's when the page reclaim
is actually completed.  It probably doesn't matter one way or the other.
I can move it to just after the loop if people think that's better.

Thanks for reviewing the change.

Tim

