Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab0D3SSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:18:48 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42495 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab0D3R3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:17 -0400
Date: Fri, 30 Apr 2010 13:20:00 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] padata: Use a timer to handle the reorder queues
Message-ID: <20100430112000.GM5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
 <20100429124337.GJ5275@secunet.com>
 <20100429160644.4dee414d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429160644.4dee414d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Apr 2010 11:14:53.0251 (UTC) FILETIME=[5B720130:01CAE856]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 04:06:44PM -0700, Andrew Morton wrote:
> On Thu, 29 Apr 2010 14:43:37 +0200
> Steffen Klassert <steffen.klassert@secunet.com> wrote:
> 
> > padata_get_next had a bogus check that returned always true,
> > so the try_again loop in padata_reorder was never taken.
> 
> A better changelog would have told us what this "bogus check" _is_.
> 
> > This can lead to object leaks in some rare cases.
> 
> And a better changelog would describe those leaks!

I'll try to write a better one and resent.

> 
> > This patch
> > implements a timer that processes the reorder queues if noone
> > else does it in appropriate time.
> 
> Under what circumstances would "noone else do it in appropriate time"? 
> Would that be a bug, or what?
> 

We need to ensure that only one cpu can work on dequeueing of the reorder
queue the time. Calculating in which percpu reorder queue the next object
will arrive takes some time. A spinlock would be highly contended. Also
it is not clear in which order the objects arrive to the reorder queues.
So a cpu could wait to get the lock just to notice that there is nothing to
do at the moment. Therefore we use a trylock and let the holder of the
lock care for all the objects enqueued during the holdtime of the lock.

The timer is to handle a race that appears with the trylock. If cpu1 queues
an object to the reorder queue while cpu2 holds the pd->lock but left the
while loop in padata_reorder already, cpu2 can't care for this object but cpu1
exits because it can't get the lock. Usually the next cpu that takes the
lock cares for this object too. We need the timer just if this object was the
last one that arrives to the reorder queues. The timer function sends it out
in this case.


> > @@ -273,13 +274,22 @@ try_again:
> >  
> >  	spin_unlock_bh(&pd->lock);
> >  
> > -	if (atomic_read(&pd->reorder_objects))
> > -		goto try_again;
> > +	if (atomic_read(&pd->reorder_objects)
> > +			&& !(pinst->flags & PADATA_RESET))
> > +		mod_timer(&pd->timer, jiffies + HZ);
> > +	else
> > +		del_timer(&pd->timer);
> >  
> > -out:
> >  	return;
> >  }
> 
> I'd feel more comfortable if the above was in the locked region.  Is
> there a race whereby another CPU can set pd->reorder_objects, but we
> forgot to arm the timer?
> 


We could hit the race that the timer handles, if we move this into the lock.

cpu1                            cpu2

spin_trylock_bh()
      |
      |
      |
test pd->reorder_objects == 0
delete timer
      |
hardinterrupt
      |                         set pd->reorder_objects == 1
      |                         enqueue object
      |                         spin_trylock_bh() busy
      |                         exit
      |
spin_unlock_bh()
