Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993188Ab2KOK15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:27:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992442Ab2KOK14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:27:56 -0500
Date: Thu, 15 Nov 2012 10:27:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Theurer <habanero@linux.vnet.ibm.com>
Cc: a.p.zijlstra@chello.nl, riel@redhat.com, aarcange@redhat.com,
        lee.schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/31] mm: sched: numa: Implement constant, per task
 Working Set Sampling (WSS) rate
Message-ID: <20121115102750.GT8218@suse.de>
References: <1352913882.7130.131.camel@oc2024037011.ibm.com>
 <20121114182826.GP8218@suse.de>
 <1352921993.7130.154.camel@oc2024037011.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1352921993.7130.154.camel@oc2024037011.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 01:39:53PM -0600, Andrew Theurer wrote:
> > > <SNIP>
> > >
> > > I am wondering if it would be better to shrink the scan period back to a
> > > much smaller fixed value,
> > 
> > I'll do that anyway.
> > 
> > > and instead of picking 256MB ranges of memory
> > > to mark completely, go back to using all of the address space, but mark
> > > only every Nth page. 
> > 
> > It'll still be necessary to do the full walk and I wonder if we'd lose on
> > the larger number of PTE locks that will have to be taken to do a scan if
> > we are only updating every 128 pages for example. It could be very expensive.
> 
> Yes, good point.  My other inclination was not doing a mass marking of
> pages at all (except just one time at some point after task init) and
> conditionally setting or clearing the prot_numa in the fault path itself
> to control the fault rate. 

That's a bit of a catch-22. You need faults to control the scan rate
which determines the fault rate.

One thing that could be done is that the PTE scanning-and-updating is
rate limited if there is an excessive number of migrations due to NUMA
hinting faults within a given window. I've prototyped something along
these lines. The problem is that it'll disrupt the accuracy of the
statistics gathered by the hinting faults.

> The problem I see is I am not sure how we
> "back-off" the fault rate per page. 

I went for a straight cutoff. If a node has migrated too much recently,
no PTEs are marked for update if the PTE points to a page on that node. I
know it's a big heavy hammer but it'll indicate if it's worthwhile.

> You could choose to not leave the
> page marked, but then you never get a fault on that page again, so
> there's no good way to mark it again in the fault path for that page
> unless you have the periodic marker. 

In my case, the throttle window expires and it goes back to scanning at
the normal rate. I've changed the details of how the scanning rate
increases and decreases but how exactly is not that important right now.

> However, maybe a certain number of
> pages are considered clustered together, and a fault from any page is
> considered a fault for the cluster of pages.  When handling the fault,
> the number of pages which are marked in the cluster is varied to achieve
> a target, reasonable fault rate.  Might be able to treat page migrations
> in clusters as well...  I probably need to think about this a bit
> more....
> 

FWIW, I'm wary of putting too many smarts into how the scanning rates are
adapted. It'll be too specific to workloads and machine sizes.

-- 
Mel Gorman
SUSE Labs
