Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1FHSSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 14:18:52 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38458 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1FHSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 14:18:51 -0400
Subject: Re: [PATCH 5/5] CFQ: use proper locking for cache of last hit cic
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Jun 2011 20:18:44 +0200
In-Reply-To: <4DEC441C.9030009@kernel.dk>
References: <1307291201.8545.46.camel@t41.thuisdomein>
	 <4DEC441C.9030009@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307557130.2783.5.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 05:06 +0200, Jens Axboe wrote:
> On 2011-06-05 18:26, Paul Bolle wrote:
> > @@ -2704,8 +2706,13 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
> >  	smp_wmb();
> >  	cic->key = cfqd_dead_key(cfqd);
> >  
> > -	if (ioc->last_cic == cic)
> > +	spin_lock_irqsave(&ioc->lock, flags);
> > +	rcu_read_lock();
> > +	last_cic = rcu_dereference(ioc->last_cic);
> > +	rcu_read_unlock();
> > +	if (last_cic == cic)
> >  		rcu_assign_pointer(ioc->last_cic, NULL);
> > +	spin_unlock_irqrestore(&ioc->lock, flags);
> 
> We don't need the ioc->lock for checking the cache, it would in fact
> defeat the purpose of using RCU.

Just to show that I'm RCU-challenged, is that because:
1) my use of locking on ioc->lock defends for a race that is not
actually possible; or
2) the worst thing that could happen is that some new and correct value
of ioc->last_cic will be replaced with NULL, which is simply not a big
deal?

> But this hunk will clash with the
> merged part anyway.

Looking at Paul's feedback I do have a feeling that in your commit
(9b50902db5eb8a220160fb89e95aa11967998d12, "cfq-iosched: fix locking
around ioc->ioc_data assignment") the line:
	if (rcu_dereference(ioc->ioc_data) == cic) {

could actually be replaced with:
	if (rcu_access_pointer(ioc->ioc_data) == cic) {

Is that correct?

> [...]
> See Pauls comment on this part.

You seem to be offline right now. When you're back online, could you
please say whether or not you accept the two renaming patches that you
have rejected a few days ago (and for which I gave some follow up
arguments)? After that I'll send an update to this patch (and its commit
message) to reflect Paul's review and your review.


Paul Bolle

