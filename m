Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0ETHBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:01:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51009 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0ETHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mwOun9CR+gRSOSKy/347zVhSE00nUA5EbZ9WTUQJSseTdfp0syn4rGM+kHE1EiuLYB
         Z88QPqWEOX83Ly8Ooum6/eQq74Z27IeNPqgjfI+VYw9+Q5tFiKZ3H58db9wR8AliruXq
         nCtpkn9ISRzb2PB85rPSB5IySlpVluQDQMhf8=
Date: Thu, 20 May 2010 09:01:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100520070121.GA5309@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com> <20100513190325.GB5377@nowhere> <20100513194605.GG2879@linux.vnet.ibm.com> <20100513204855.GD5377@nowhere> <20100513205925.GE5377@nowhere> <20100513234327.GP2879@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513234327.GP2879@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 04:43:27PM -0700, Paul E. McKenney wrote:
> On Thu, May 13, 2010 at 10:59:26PM +0200, Frederic Weisbecker wrote:
> > >  	hash = swevent_hash(type, event_id);
> > >  
> > > +	return &hlist->heads[hash];
> > > +}
> > > +
> > > +static inline struct hlist_head *
> > > +find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
> > > +{
> > > +	struct swevent_hlist *hlist;
> > > +
> > >  	hlist = rcu_dereference(ctx->swevent_hlist);
> 
> This is appropriate if find_swevent_head_rcu() is always invoked in an
> RCU read-side critical section.  (Which at first glance does appear to
> be the intent, just checking.)



Exactly!


 
> > > -	if (!hlist)
> > > -		return NULL;
> > >  
> > > -	return &hlist->heads[hash];
> > > +	return __find_swevent_head(hlist, type, event_id);
> > > +}
> > > +
> > > +static inline struct hlist_head *
> > > +find_swevent_head(struct perf_cpu_context *ctx, u64 type,
> > > +		  u32 event_id, struct perf_event *event)
> > > +{
> > > +	struct swevent_hlist *hlist;
> > > +
> > > +	hlist = rcu_dereference_check(ctx->swevent_hlist,
> > > +				      lockdep_is_held(&event->ctx->lock));
> 
> This could be invoked with either the event->ctx->lock held or in
> an RCU read-side critical section.  If this is always called with
> the update-side lock held, you can (but don't need to) instead say:
> 
> 	hlist = rcu_dereference_protected(ctx->swevent_hlist,
> 				          lockdep_is_held(&event->ctx->lock));
> 
> This is slightly faster, as it drops the volatile casts.  In many cases,
> you won't care, but in case this code path needs ultimate performance.
> 
> Also I thought it was event->ctx.lock, but at this point I trust your eyes
> more than my own.  ;-)
> 
> 							Thanx, Paul



This is indeed never called from the read side.

In fact the situation is a bit complicated.
The true update side is:

	creation_of_perf_event() {
		mutex_lock(ctx->mutex);
		alloc/rcu_assign_pointer the hlist
		mutex_unlock(ctx->mutex);
	}
	/* the event for which we've allocated the hlist
	   can be scheduled only once the above is
	   finished */

And, in a serialized way, we can have:

	schedule_perf_event() {
		spin_lock(ctx->lock);
		rcu_deref hlist
		spin_unlock(ctx->lock);
	}

Scheduling an event that derefs the hlist will not happen if we haven't
created and assigned the hlist before.
And also scheduling an event that derefs the hlist won't happen after
the hlist has been destroyed (released), it also can't be destroyed
concurrently with the scheduling.

This is why I consider the event scheduling as part of the update side,
since it is serialized with it, the ctx->lock guarantees that.

OTOH, we can have the read side concurrently anytime, hence the need
for rcu_read_lock() there.
	
So, I guess it's justified to use rcu_dereference_protected() here.

Thanks.

