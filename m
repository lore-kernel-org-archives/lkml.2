Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KVOMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:12:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:3670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab1KVOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:11:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,553,1315206000"; 
   d="scan'208";a="77966404"
Date: Tue, 22 Nov 2011 22:11:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122141129.GC10545@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
 <20111122122157.GB8058@quack.suse.cz>
 <1321966662.5148.35.camel@twins>
 <20111122130750.GA19929@localhost>
 <20111122134155.GA23599@localhost>
 <1321969999.14799.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321969999.14799.10.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 09:53:19PM +0800, Peter Zijlstra wrote:
> On Tue, 2011-11-22 at 21:41 +0800, Wu Fengguang wrote:
> > On Tue, Nov 22, 2011 at 09:07:50PM +0800, Wu Fengguang wrote:
> > > On Tue, Nov 22, 2011 at 08:57:42PM +0800, Peter Zijlstra wrote:
> > > > On Tue, 2011-11-22 at 13:21 +0100, Jan Kara wrote:
> > > > > > +             __get_cpu_var(bdp_ratelimits)++;
> > > > >   I think you need preempt_disable() and preempt_enable() pair around
> > > > > __get_cpu_var(). Otherwise a process could get rescheduled in the middle of
> > > > > read-modify-write cycle... 
> > > > 
> > > > there's of course the this_cpu_inc(bdp_ratelimits); thing.
> > > > 
> > > > On x86 that'll turn into a single insn, on others it will add the
> > > > required preempt_disable/enable bits.
> > > 
> > > It's good to know that. But what if we don't really care which CPU
> > > data it's increasing, and can accept losing some increases due to the
> > > resulted race condition?
> > 
> > I just added a comment for it, hope it helps :)
> > 
> >                 /*
> >                  * This is racy, however bdp_ratelimits merely serves as a
> >                  * gross safeguard. We don't really care the exact CPU it's
> >                  * charging to and the resulted inaccuracy is acceptable.
> >                  */
> >                 __get_cpu_var(bdp_ratelimits)++;
> 
> Thing is, I'm not sure how much update you can effectively wreck by
> interleaving the RmW cycles of two CPUs like this.

Yeah there is the side effect of cache bouncing, which makes it not a
clear win...and pure lose on x86...

> Simply loosing a few increments would be fine, but what are the
> practical implications of actually relying on this behaviour and how do
> various architectures cope.

OK I'll give up the weird (mis-)use of the per-cpu data structure :)

Thanks,
Fengguang
---
Subject: writeback: fix dirtied pages accounting on sub-page writes
Date: Thu Apr 14 07:52:37 CST 2011

When dd in 512bytes, generic_perform_write() calls
balance_dirty_pages_ratelimited() 8 times for the same page, but
obviously the page is only dirtied once.

Fix it by accounting tsk->nr_dirtied and bdp_ratelimits at page dirty time.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-11-22 22:01:56.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-22 22:02:32.000000000 +0800
@@ -1246,8 +1246,6 @@ void balance_dirty_pages_ratelimited_nr(
 	if (bdi->dirty_exceeded)
 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
 
-	current->nr_dirtied += nr_pages_dirtied;
-
 	preempt_disable();
 	/*
 	 * This prevents one CPU to accumulate too many dirtied pages without
@@ -1258,12 +1256,9 @@ void balance_dirty_pages_ratelimited_nr(
 	p =  &__get_cpu_var(bdp_ratelimits);
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		*p = 0;
-	else {
-		*p += nr_pages_dirtied;
-		if (unlikely(*p >= ratelimit_pages)) {
-			*p = 0;
-			ratelimit = 0;
-		}
+	else if (unlikely(*p >= ratelimit_pages)) {
+		*p = 0;
+		ratelimit = 0;
 	}
 	/*
 	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
@@ -1758,6 +1753,8 @@ void account_page_dirtied(struct page *p
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
 		task_dirty_inc(current);
 		task_io_account_write(PAGE_CACHE_SIZE);
+		current->nr_dirtied++;
+		this_cpu_inc(bdp_ratelimits);
 	}
 }
 EXPORT_SYMBOL(account_page_dirtied);
