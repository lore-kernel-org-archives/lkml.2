Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1LEJYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:24:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:12277 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1LEJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,298,1320652800"; 
   d="scan'208";a="82247025"
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <alpine.DEB.2.00.1112020842280.10975@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	 <alpine.DEB.2.00.1112020842280.10975@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 17:22:45 +0800
Message-ID: <1323076965.16790.670.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 22:43 +0800, Christoph Lameter wrote:
> On Fri, 2 Dec 2011, Alex Shi wrote:
> 
> > From: Alex Shi <alexs@intel.com>
> >
> > Times performance regression were due to slub add to node partial head
> > or tail. That inspired me to do tunning on the node partial adding, to
> > set a criteria for head or tail position selection when do partial
> > adding.
> > My experiment show, when used objects is less than 1/4 total objects
> > of slub performance will get about 1.5% improvement on netperf loopback
> > testing with 2048 clients, wherever on our 4 or 2 sockets platforms,
> > includes sandbridge or core2.
> 
> The number of free objects in a slab may have nothing to do with cache
> hotness of all objects in the slab. You can only be sure that one object
> (the one that was freed) is cache hot. Netperf may use them in sequence
> and therefore you are likely to get series of frees on the same slab
> page. How are other benchmarks affected by this change?

Previous testing depends on 3.2-rc1, that show hackbench performance has
no clear change, and netperf get some benefit. But seems after
irqsafe_cpu_cmpxchg patch, the result has some change. I am collecting
these results. 

As to the cache hot benefit, my understanding is that if the same object
was reused, it contents will be refilled from memory anyway. but it will
save a CPU cache line replace action. 

But think through the lock contention on node->list_lock, like
explanation of commit 130655ef0979. more free objects will reduce the
contentions of this lock. It is some tricks to do balance of them. :( 



