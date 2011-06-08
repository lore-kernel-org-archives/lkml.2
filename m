Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1FHUHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:07:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1FHUH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:07:28 -0400
Date: Wed, 8 Jun 2011 16:07:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CFQ: use proper locking for cache of last hit cic
Message-ID: <20110608200717.GE1150@redhat.com>
References: <1307291201.8545.46.camel@t41.thuisdomein>
 <4DEC441C.9030009@kernel.dk>
 <1307557130.2783.5.camel@t41.thuisdomein>
 <20110608184254.GD1150@redhat.com>
 <1307561578.2783.23.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307561578.2783.23.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:32:52PM +0200, Paul Bolle wrote:
> On Wed, 2011-06-08 at 14:42 -0400, Vivek Goyal wrote:
> > On Wed, Jun 08, 2011 at 08:18:44PM +0200, Paul Bolle wrote:
> > > On Mon, 2011-06-06 at 05:06 +0200, Jens Axboe wrote:
> > > > On 2011-06-05 18:26, Paul Bolle wrote:
> > > > > @@ -2704,8 +2706,13 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
> > > > >  	smp_wmb();
> > > > >  	cic->key = cfqd_dead_key(cfqd);
> > > > >  
> > > > > -	if (ioc->last_cic == cic)
> > > > > +	spin_lock_irqsave(&ioc->lock, flags);
> > > > > +	rcu_read_lock();
> > > > > +	last_cic = rcu_dereference(ioc->last_cic);
> > > > > +	rcu_read_unlock();
> > > > > +	if (last_cic == cic)
> > > > >  		rcu_assign_pointer(ioc->last_cic, NULL);
> > > > > +	spin_unlock_irqrestore(&ioc->lock, flags);
> > > > 
> > > > We don't need the ioc->lock for checking the cache, it would in fact
> > > > defeat the purpose of using RCU.
> > > 
> > > Just to show that I'm RCU-challenged, is that because:
> > > 1) my use of locking on ioc->lock defends for a race that is not
> > > actually possible; or
> > > 2) the worst thing that could happen is that some new and correct value
> > > of ioc->last_cic will be replaced with NULL, which is simply not a big
> > > deal?
> > 
> > I don't understand this point.
> 
> That could be because I don't really get all the RCU voodoo, nor how
> this all interacts with the io_contect->lock here, so I probably asked
> an impossible question.
> 
> > All ioc->ioc_data updates are under
> > ioc->lock except the one __cfq_exit_single_io_context() and that's what
> > jens patch fixed. So clearly there was atleast one race where we were
> > doing a value update without taking appropriate lock. 
> > 
> > Why do you think that some new and correct value will be replaced
> > by NULL?
> 
> Jens updated the code to
> 	if (rcu_dereference(ioc->ioc_data) == cic) {
> 		spin_lock(&ioc->lock);
> 		rcu_assign_pointer(ioc->ioc_data, NULL);
> 		spin_unlock(&ioc->lock);
> 	}
> 
> I basically suggested (except for an apparently useless
> rcu_read_lock() / rcu_read_unlock() pair and using spin_lock_irqsave()
> etc.):
> 	spin_lock(&ioc->lock);
> 	if (rcu_dereference(ioc->ioc_data) == cic)
> 		rcu_assign_pointer(ioc->ioc_data, NULL);
> 	spin_unlock(&ioc->lock);
> 
> Ie, I thought that reads of and updates to ioc->ioc_data should be done
> with ioc->lock held. My reasoning was that in Jens code ioc->ioc_data
> might already be updated (by another thread, or whatever) and thus not
> be equal to cic by the time it's updated to NULL. See, in my
> understanding ioc->ioc_data could be equal to cic when it's
> rcu_dereference()'d, but unequal to cic by the time it's
> rcu_assign_pointer()'d to NULL.

Ok, I see it now. Yep theoritically this race is present. Jens must have
checked the value without taking lock so that if we cic is not the cached
one, we don't take ioc lock.

I would not worry too much about it as the side effect of this race is
only trashing the cache which will soon be filled again upon next
request.

Thanks
Vivek
