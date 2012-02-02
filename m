Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2BBUoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:44:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2BBUoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:44:21 -0500
Date: Thu, 2 Feb 2012 15:43:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: axboe@kernel.dk, "Alasdair G. Kergon" <agk@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
In-Reply-To: <1328042063.2446.250.camel@twins>
Message-ID: <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
 <1328042063.2446.250.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jan 2012, Peter Zijlstra wrote:

> On Wed, 2011-07-20 at 20:29 -0400, Mikulas Patocka wrote:
> > Hi Jens
> > 
> > Please would you consider taking this into the block tree? It seems to 
> > speed up device deletion enormously.
> > 
> > Mikulas
> > 
> > ---
> > 
> > backing-dev: use synchronize_rcu_expedited instead of synchronize_rcu
> > 
> > synchronize_rcu sleeps several timer ticks. synchronize_rcu_expedited is 
> > much faster.
> > 
> > With 100Hz timer frequency, when we remove 10000 block devices with 
> > "dmsetup remove_all" command, it takes 27 minutes. With this patch, 
> > removing 10000 block devices takes only 15 seconds.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  mm/backing-dev.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-3.0-rc7-fast/mm/backing-dev.c
> > ===================================================================
> > --- linux-3.0-rc7-fast.orig/mm/backing-dev.c	2011-07-19 18:01:00.000000000 +0200
> > +++ linux-3.0-rc7-fast/mm/backing-dev.c	2011-07-19 18:01:07.000000000 +0200
> > @@ -505,7 +505,7 @@ static void bdi_remove_from_list(struct 
> >  	list_del_rcu(&bdi->bdi_list);
> >  	spin_unlock_bh(&bdi_lock);
> >  
> > -	synchronize_rcu();
> > +	synchronize_rcu_expedited();
> >  }
> >  
> 
> Urgh, I just noticed this crap in my tree.. You realize that what you're
> effectively hammering a global sync primitive this way? Depending on
> what RCU flavour you have any SMP variant will at least do a machine
> wide IPI broadcast for every sync_rcu_exp(), some do significantly more.
> 
> The much better solution would've been to batch your block-dev removals
> and use a single sync_rcu as barrier.
> 
> This is not cool.

Do you have some measurable use case where the user is removing block 
devices so heavily that this causes a problem?

Mikulas
