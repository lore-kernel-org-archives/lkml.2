Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1LINlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:41:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:37916 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1LINlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:41:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94361203"
From: "Shi, Alex" <alex.shi@intel.com>
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 9 Dec 2011 21:40:39 +0800
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
Thread-Topic: [PATCH 1/3] slub: set a criteria for slub node partial adding
Thread-Index: Acy2WtpYBxu1ZE1KTbeFhuOQdOK8vwAGF8GA
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
 <alpine.DEB.2.00.1112020842280.10975@router.home>
 <1323419402.16790.6105.camel@debian>
 <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I did some experiments on add_partial judgment against rc4, like to put
> > the slub into node partial head or tail according to free objects, or
> > like Eric's suggest to combine the external parameter, like below:
> >
> >         n->nr_partial++;
> > -       if (tail == DEACTIVATE_TO_TAIL)
> > +       if (tail == DEACTIVATE_TO_TAIL ||
> > +               page->inuse > page->objects /2)
> >                 list_add_tail(&page->lru, &n->partial);
> >         else
> >                 list_add(&page->lru, &n->partial);
> >
> > But the result is out of my expectation before.
> 
> I don't think you'll get consistent results for all workloads with
> something like this, some things may appear better and other things may
> appear worse.  That's why I've always disagreed with determining whether
> it should be added to the head or to the tail at the time of deactivation:
> you know nothing about frees happening to that slab subsequent to the
> decision you've made.  The only thing that's guaranteed is that you've
> through cache hot objects out the window and potentially increased the
> amount of internally fragmented slabs and/or unnecessarily long partial
> lists.

I said it not my original expectation doesn't mean my data has problem. :) 
Of course any testing may have result variation. But it is benchmark accordingly, and there are lot technical to tuning your testing to make its stand division acceptable, like to sync your system in a clear status, to close unnecessary services, to use separate working disks for your testing etc. etc. For this data, like on my SNB-EP machine, (the following data is not stands for Intel, it is just my personal data). 
4 times result of hackbench on this patch are 5.59, 5.475, 5.47833, 5.504
And more results on original rc4 are from 5.54 to 5.61, the stand division of results show is stable and believable on my side. But since in our handreds benchmarks, only hackbench and loopback netperf is sensitive with slub change, and since it seems you did some testing on this. I thought you may like to do a double confirm with real data. 

In fact, I also collected the 'perf stat' for cache missing or reference data, but that wave too much not stabled like hackbench itself.
 
> Not sure what you're asking me to test, you would like this:
> 
> 	{
> 	        n->nr_partial++;
> 	-       if (tail == DEACTIVATE_TO_TAIL)
> 	-               list_add_tail(&page->lru, &n->partial);
> 	-       else
> 	-               list_add(&page->lru, &n->partial);
> 	+       list_add_tail(&page->lru, &n->partial);
> 	}
> 
> with the statistics patch above?  I typically run with CONFIG_SLUB_STATS
> disabled since it impacts performance so heavily and I'm not sure what
> information you're looking for with regards to those stats.

NO, when you collect data, please close SLUB_STAT in kernel config.  _to_head statistics collection patch just tell you, I collected the statistics not include add_partial in early_kmem_cache_node_alloc(). And other places of add_partial were covered. Of course, the kernel with statistic can not be used to measure performance. 
