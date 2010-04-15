Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0DOETj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:19:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:57529 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0DOETi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:19:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,209,1270450800"; 
   d="scan'208";a="265917459"
Date: Thu, 15 Apr 2010 12:19:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andreas Mohr <andi@lisas.de>, Jens Axboe <axboe@kernel.dk>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Message-ID: <20100415041931.GA14215@localhost>
References: <20100407070050.GA10527@localhost> <20100407070842.GA18215@localhost> <20100415122928.D168.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415122928.D168.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 11:31:52AM +0800, KOSAKI Motohiro wrote:
> > > Many applications (this one and below) are stuck in
> > > wait_on_page_writeback(). I guess this is why "heavy write to
> > > irrelevant partition stalls the whole system".  They are stuck on page
> > > allocation. Your 512MB system memory is a bit tight, so reclaim
> > > pressure is a bit high, which triggers the wait-on-writeback logic.
> > 
> > I wonder if this hacking patch may help.
> > 
> > When creating 300MB dirty file with dd, it is creating continuous
> > region of hard-to-reclaim pages in the LRU list. priority can easily
> > go low when irrelevant applications' direct reclaim run into these
> > regions..
> 
> Sorry I'm confused not. can you please tell us more detail explanation?
> Why did lumpy reclaim cause OOM? lumpy reclaim might cause
> direct reclaim slow down. but IIUC it's not cause OOM because OOM is
> only occur when priority-0 reclaim failure.

No I'm not talking OOM. Nor lumpy reclaim.

I mean the direct reclaim can get stuck for long time, when we do
wait_on_page_writeback() on lumpy_reclaim=1.

> IO get stcking also prevent priority reach to 0.

Sure. But we can wait for IO a bit later -- after scanning 1/64 LRU
(the below patch) instead of the current 1/1024.

In Andreas' case, 512MB/1024 = 512KB, this is way too low comparing to
the 22MB writeback pages. There can easily be a continuous range of
512KB dirty/writeback pages in the LRU, which will trigger the wait
logic.

Thanks,
Fengguang

> 
> 
> > 
> > Thanks,
> > Fengguang
> > ---
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index e0e5f15..f7179cf 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1149,7 +1149,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
> >  	 */
> >  	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
> >  		lumpy_reclaim = 1;
> > -	else if (sc->order && priority < DEF_PRIORITY - 2)
> > +	else if (sc->order && priority < DEF_PRIORITY / 2)
> >  		lumpy_reclaim = 1;
> >  
> >  	pagevec_init(&pvec, 1);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
