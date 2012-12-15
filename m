Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2LOATq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:19:46 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36369 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab2LOATp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:19:45 -0500
Date: Fri, 14 Dec 2012 19:18:51 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, Satoru Moriya <satoru.moriya@hds.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/8] mm: vmscan: disregard swappiness shortly before
 going OOM
Message-ID: <20121215001850.GA21353@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
 <20121213103420.GW1009@suse.de>
 <20121213152959.GE21644@dhcp22.suse.cz>
 <20121213160521.GG21644@dhcp22.suse.cz>
 <8631DC5930FA9E468F04F3FD3A5D007214AD2FA2@USINDEM103.corp.hds.com>
 <20121214045030.GE6317@cmpxchg.org>
 <20121214083738.GA6898@dhcp22.suse.cz>
 <50CB493B.8000900@redhat.com>
 <20121214161345.GA18780@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214161345.GA18780@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 05:13:45PM +0100, Michal Hocko wrote:
> On Fri 14-12-12 10:43:55, Rik van Riel wrote:
> > On 12/14/2012 03:37 AM, Michal Hocko wrote:
> > 
> > >I can answer the later. Because memsw comes with its price and
> > >swappiness is much cheaper. On the other hand it makes sense that
> > >swappiness==0 doesn't swap at all. Or do you think we should get back to
> > >_almost_ doesn't swap at all?
> > 
> > swappiness==0 will swap in emergencies, specifically when we have
> > almost no page cache left, we will still swap things out:
> > 
> >         if (global_reclaim(sc)) {
> >                 free  = zone_page_state(zone, NR_FREE_PAGES);
> >                 if (unlikely(file + free <= high_wmark_pages(zone))) {
> >                         /*
> >                          * If we have very few page cache pages, force-scan
> >                          * anon pages.
> >                          */
> >                         fraction[0] = 1;
> >                         fraction[1] = 0;
> >                         denominator = 1;
> >                         goto out;
> > 
> > This makes sense, because people who set swappiness==0 but
> > do have swap space available would probably prefer some
> > emergency swapping over an OOM kill.
> 
> Yes, but this is the global reclaim path. I was arguing about
> swappiness==0 & memcg. As this patch doesn't make a big difference for
> the global case (as both the changelog and you mentioned) then we should
> focus on whether this is desirable change for the memcg path. I think it
> makes sense to keep "no swapping at all for memcg semantic" as we have
> it currently.

I would prefer we could agree on one thing, though.  Having global
reclaim behave different from memcg reclaim violates the principle of
least surprise.  Having the code behave like that implicitely without
any mention of global_reclaim() and vm_swappiness() is unacceptable.
