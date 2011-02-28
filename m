Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1B1J2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:28:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56673 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab1B1J2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:28:43 -0500
Date: Mon, 28 Feb 2011 09:28:14 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are
	disabled while isolating pages for migration
Message-ID: <20110228092814.GC9548@csn.ul.ie>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie> <1298664299-10270-3-git-send-email-mel@csn.ul.ie> <20110228111746.34f3f3e0.kamezawa.hiroyu@jp.fujitsu.com> <20110228054818.GF22700@random.random> <20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110228145402.65e6f200.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:54:02PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 28 Feb 2011 06:48:18 +0100
> Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
> > On Mon, Feb 28, 2011 at 11:17:46AM +0900, KAMEZAWA Hiroyuki wrote:
> > > BTW, I forget why we always take zone->lru_lock with IRQ disabled....
> > 
> > To decrease lock contention in SMP to deliver overall better
> > performance (not sure how much it helps though). It was supposed to be
> > hold for a very short time (PAGEVEC_SIZE) to avoid giving irq latency
> > problems.
> > 
> 
> memory hotplug uses MIGRATE_ISOLATED migrate types for scanning pfn range
> without lru_lock. I wonder whether we can make use of it (the function
> which memory hotplug may need rework for the compaction but  migrate_type can
> be used, I think).
> 

I don't see how migrate_type would be of any benefit here particularly
as compaction does not directly affect the migratetype of a pageblock. I
have not checked closely which part of hotplug you are on about but if
you're talking about when pages actually get offlined, the zone lock is
not necessary there because the pages are not on the LRU. In compactions
case, they are. Did I misunderstand?

That said, a certain about of lockless scanning could be done here if the lock
hold times were shown to be still high. Specifically, scan until an LRU page
is found, take the lock and hold the lock for a maximum of SWAP_CLUSTER_MAX
scanned pages before releasing again. I don't think it would be a massive
improvement though.

-- 
Mel Gorman
SUSE Labs
