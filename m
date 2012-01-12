Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2ALIhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:37:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2ALIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:36:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 12 Jan 2012 17:35:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: Fix NULL ptr dereference in __count_immobile_pages
Message-Id: <20120112173536.db529713.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120112082722.GB1042@tiehlicka.suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
	<alpine.DEB.2.00.1201101326080.10821@chino.kir.corp.google.com>
	<20120111084802.GA16466@tiehlicka.suse.cz>
	<20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120112082722.GB1042@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 09:27:22 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 12-01-12 11:17:02, KAMEZAWA Hiroyuki wrote:
> > On Wed, 11 Jan 2012 09:48:02 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Tue 10-01-12 13:31:08, David Rientjes wrote:
> > > > On Tue, 10 Jan 2012, Michal Hocko wrote:
> > > [...]
> > > > >  mm/page_alloc.c |   11 +++++++++++
> > > > >  1 files changed, 11 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > index 2b8ba3a..485be89 100644
> > > > > --- a/mm/page_alloc.c
> > > > > +++ b/mm/page_alloc.c
> > > > > @@ -5608,6 +5608,17 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
> > > > >  bool is_pageblock_removable_nolock(struct page *page)
> > > > >  {
> > > > >  	struct zone *zone = page_zone(page);
> > > > > +	unsigned long pfn = page_to_pfn(page);
> > > > > +
> > 
> > Hmm, I don't like to use page_zone() when we know the page may not be initialized.
> > Shouldn't we add
> > 
> > 	if (!node_online(page_to_nid(page))
> > 		return false;
> > ?
> 
> How is this different? The node won't be initialized in page flags as
> well.
> 

page_zone(page) is
==
static inline struct zone *page_zone(const struct page *page)
{
        return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
}
==

Then, if the page is unitialized, 

   &(NODE_DATA(0)->node_zones[0])

If NODE_DATA(0) is NULL, node_zones[0] is NULL just because zone array is placed
on the top of struct pglist_data.

I never think someone may change the layout but...Hmm, just a nitpick.
please do as you like.


> > But...hmm. I think we should return 'true' here for removing a section with a hole
> > finally....(Now, false will be safe.)
> 
> Those pages are reserved (for BIOS I guess) in this particular case so I
> do not think it is safe to claim that the block is removable. Or am I
> missing something?
> 

We can't know it's reserved by BIOS or it's just a memory hole by the fact
the page wasn't initialized.


Thanks,
-Kame

