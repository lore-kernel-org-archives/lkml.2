Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1EPIpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:45:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1EPIpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:45:19 -0400
Date: Mon, 16 May 2011 09:45:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        colin.king@canonical.com, raghu.prabhu13@gmail.com, jack@suse.cz,
        chris.mason@oracle.com, cl@linux.com, penberg@kernel.org,
        riel@redhat.com, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] mm: vmscan: If kswapd has been running too long,
 allow it to sleep
Message-ID: <20110516084514.GD5279@suse.de>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de>
 <1305295404-12129-5-git-send-email-mgorman@suse.de>
 <4DCFAA80.7040109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4DCFAA80.7040109@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 07:27:12PM +0900, KOSAKI Motohiro wrote:
> (2011/05/13 23:03), Mel Gorman wrote:
> > Under constant allocation pressure, kswapd can be in the situation where
> > sleeping_prematurely() will always return true even if kswapd has been
> > running a long time. Check if kswapd needs to be scheduled.
> > 
> > Signed-off-by: Mel Gorman<mgorman@suse.de>
> > ---
> >   mm/vmscan.c |    4 ++++
> >   1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index af24d1e..4d24828 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
> >   	unsigned long balanced = 0;
> >   	bool all_zones_ok = true;
> > 
> > +	/* If kswapd has been running too long, just sleep */
> > +	if (need_resched())
> > +		return false;
> > +
> 
> Hmm... I don't like this patch so much. because this code does
> 
> - don't sleep if kswapd got context switch at shrink_inactive_list
> - sleep if kswapd didn't
> 
> It seems to be semi random behavior.
> 

It's possible to keep kswapd awake simply by allocating fast enough that
the watermarks are never balanced making kswapd appear to consume 100%
of CPU. This check causes kswapd to sleep in this case. The processes
doing the allocations will enter direct reclaim and probably stall while
processes that are not allocating will get some CPU time.

-- 
Mel Gorman
SUSE Labs
