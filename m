Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1E3Qzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:55:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1E3Qzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:55:51 -0400
Date: Mon, 30 May 2011 17:55:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110530165546.GC5118@suse.de>
References: <20110530131300.GQ5044@csn.ul.ie>
 <20110530143109.GH19505@random.random>
 <20110530153748.GS5044@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110530153748.GS5044@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 04:37:49PM +0100, Mel Gorman wrote:
> > Or how do you explain this -1 value out of nr_isolated_file? Clearly
> > when that value goes to -1, compaction.c:too_many_isolated will hang,
> > I think we should fix the -1 value before worrying about the rest...
> > 
> > grep nr_isolated_file zoneinfo-khugepaged 
> >     nr_isolated_file 1
> >     nr_isolated_file 4294967295
> 
> Can you point me at the thread that this file appears on and what the
> conditions were? If vmstat is going to -1, it is indeed a problem
> because it implies an imbalance in increments and decrements to the
> isolated counters.

Even with drift issues, -1 there should be "impossible". Assuming this
is a zoneinfo file, that figure is based on global_page_state() which
looks like

static inline unsigned long global_page_state(enum zone_stat_item item)
{
        long x = atomic_long_read(&vm_stat[item]);
#ifdef CONFIG_SMP
        if (x < 0)
                x = 0;
#endif
        return x;
}

So even if isolated counts were going negative for short periods of
time, the returned value should be 0. As this is an inline returning
unsigned long, and callers are using unsigned long, is there any
possibility the "if (x < 0)" is being optimised out? If you aware
of users reporting this problem (like the users in thread "iotop:
khugepaged at 99.99% (2.6.38.3)"), do you know if they had a particular
compiler in common?

-- 
Mel Gorman
SUSE Labs
