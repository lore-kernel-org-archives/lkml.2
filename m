Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0CXOxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:53:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38689 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0CXOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:53:41 -0400
Date: Wed, 24 Mar 2010 07:54:49 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Neil Brown <neilb@suse.de>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
In-Reply-To: <20100324123723.43d24a42@notabene.brown>
Message-ID: <Pine.LNX.4.64.1003240747040.2126@cobra.newdream.net>
References: <20100317154145.bd9fca16.sfr@canb.auug.org.au>
 <20100317182136.0f2ab805@notabene.brown> <Pine.LNX.4.64.1003170847110.25675@cobra.newdream.net>
 <20100324123723.43d24a42@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Neil Brown wrote:
> Sage Weil <sage@newdream.net> wrote:
> > > It is a pity that this code cannot use mempool_t....
> > > What if mempool_t were changed to only re-alloc the vector of pointers when
> > > it grew, or when it shrank to less than 1/2 it's current size.  Would that
> > > reduce the frequency of allocations enough for you to be comfortable with it? 
> > > i.e. always make the vector a power-of-2 size (which is what is probably
> > > allocated anyway) while the pool size might be less.
> > > ??
> > 
> > That would improve the situation, but still mean potentially large 
> > allocations (the pools can grow pretty big) that aren't strictly 
> > necessary.  I can imagine a more modular mempool_t with an ops vector for 
> > adding/removing from the pool to cope with situations like this, but I'm 
> > not sure it's worth the effort?
> 
> How big?
> mempools (and equivalents) should just be large enough to get you through a
> tight spot.  The working assumption is that they will not normally be used.
> So 2 or 3 should normally be plenty.
> 
> (looks at code)
> 
> The only time you resize a ceph_mempool is in ceph_monc_do_statfs
> where you increment it, perform a synchronous statfs call on the 
> network, then decrement the size of the mempool.
> How many concurrent statfs calls does it even make sense to make.
> I'm probably missing something obvious, but wouldn't it make sense to
> put that all under a mutex so there was only ever one outstanding statfs (per
> filesystem) - or maybe under a counting semaphore to allow some small number,
> and make sure to prime the mempool to cover that number.
> Then you would never resize a mempool at all.

You're right.  In fact, after reviewing the code again, it looks like 
_none_ of the msgpools (current or planned) needs to get large anymore.  
A protocol change a month or two back made it possible to allocate space 
for the reply along with the request, which means the only remaining use 
for the pools is for low memory writeout and the handful of messages we 
might receive from servers without asking for them.  (There used to be 
more of the msgpool resizing going on for other types of requests, but 
it's been mostly fixed up.)

I'll work on cleaning up the request/reply instances to avoid pools 
altogether.  The remaining pools should be small enough to use the 
standard mempool_t.

Thanks for looking into this!
sage
