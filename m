Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0KOJXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:23:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44292 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab0KOJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:23:10 -0500
Date: Mon, 15 Nov 2010 09:22:56 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm,vmscan: Reclaim order-0 and compact instead of
	lumpy reclaim when under light pressure
Message-ID: <20101115092256.GE27362@csn.ul.ie>
References: <1289502424-12661-4-git-send-email-mel@csn.ul.ie> <20101112093742.GA3537@csn.ul.ie> <20101114150039.E028.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101114150039.E028.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 03:02:03PM +0900, KOSAKI Motohiro wrote:
> > On Thu, Nov 11, 2010 at 07:07:04PM +0000, Mel Gorman wrote:
> > > +	if (COMPACTION_BUILD)
> > > +		sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
> > > +	else
> > > +		sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
> > >  
> > 
> > Gack, I posted the slightly wrong version. This version prevents lumpy
> > reclaim ever being used. The figures I posted were for a patch where
> > this condition looked like
> > 
> >         if (COMPACTION_BUILD && priority > DEF_PRIORITY - 2)
> >                 sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
> >         else
> >                 sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
> 
> Can you please tell us your opinition which is better 1) automatically turn lumby on
> by priority (this approach) 2) introduce GFP_LUMPY (andrea proposed). I'm not
> sure which is better, then I'd like to hear both pros/cons concern.
> 

That's a very good question!

The main "pro" of using lumpy reclaim is that it has been tested. It's known
to be very heavy and disrupt the system but it's also known to work. Lumpy
reclaim is also less suspectible to allocation races than compaction is
i.e. if memory is low, compaction requires that X number of pages be free
where as lumpy frees the pages it requires.

GFP_LUMPY is something else and is only partially related. Transparent Huge
Pages (THP) does not want to hit lumpy reclaim no matter what the circumstances
are - It is always better for THP to not use lumpy reclaim. It's debatable
whether it should even reclaim order-0 pages for compaction so even with
this series, THP might still introduce GFP_LUMPY.

Does this answer your question?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
