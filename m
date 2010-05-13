Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab0EMXne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:43:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57966 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0EMXnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:43:32 -0400
Date: Thu, 13 May 2010 16:43:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
Message-ID: <20100513234327.GP2879@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100513182556.GA14326@linux.vnet.ibm.com>
 <20100513190325.GB5377@nowhere>
 <20100513194605.GG2879@linux.vnet.ibm.com>
 <20100513204855.GD5377@nowhere>
 <20100513205925.GE5377@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513205925.GE5377@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:59:26PM +0200, Frederic Weisbecker wrote:
> On Thu, May 13, 2010 at 10:48:58PM +0200, Frederic Weisbecker wrote:
> > Paul, does that look good to you?
> > I've only compile tested. But if it's fine for you, I'll test
> > it for real and provide you a sane patch.

That would be very good!!!  I believe that I have already more than proven
my ignorance of the perf_event code.  ;-)

> > This version won't use more parameters than necessary in the
> > off case.
> > 
> > 
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index a4fa381..d765e48 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -4066,19 +4066,36 @@ static inline u64 swevent_hash(u64 type, u32 event_id)
> >  	return hash_64(val, SWEVENT_HLIST_BITS);
> >  }
> >  
> > -static struct hlist_head *
> > -find_swevent_head(struct perf_cpu_context *ctx, u64 type, u32 event_id)
> > +static inline struct hlist_head *
> > +__find_swevent_head(struct swevent_hlist *hlist, u64 type, u32 event_id)
> >  {
> >  	u64 hash;
> > -	struct swevent_hlist *hlist;
> 
> 
> 
> +	if (!hlist)
> +		return NULL;
> 
> 
> 
> >  
> >  	hash = swevent_hash(type, event_id);
> >  
> > +	return &hlist->heads[hash];
> > +}
> > +
> > +static inline struct hlist_head *
> > +find_swevent_head_rcu(struct perf_cpu_context *ctx, u64 type, u32 event_id)
> > +{
> > +	struct swevent_hlist *hlist;
> > +
> >  	hlist = rcu_dereference(ctx->swevent_hlist);

This is appropriate if find_swevent_head_rcu() is always invoked in an
RCU read-side critical section.  (Which at first glance does appear to
be the intent, just checking.)

> > -	if (!hlist)
> > -		return NULL;
> >  
> > -	return &hlist->heads[hash];
> > +	return __find_swevent_head(hlist, type, event_id);
> > +}
> > +
> > +static inline struct hlist_head *
> > +find_swevent_head(struct perf_cpu_context *ctx, u64 type,
> > +		  u32 event_id, struct perf_event *event)
> > +{
> > +	struct swevent_hlist *hlist;
> > +
> > +	hlist = rcu_dereference_check(ctx->swevent_hlist,
> > +				      lockdep_is_held(&event->ctx->lock));

This could be invoked with either the event->ctx->lock held or in
an RCU read-side critical section.  If this is always called with
the update-side lock held, you can (but don't need to) instead say:

	hlist = rcu_dereference_protected(ctx->swevent_hlist,
				          lockdep_is_held(&event->ctx->lock));

This is slightly faster, as it drops the volatile casts.  In many cases,
you won't care, but in case this code path needs ultimate performance.

Also I thought it was event->ctx.lock, but at this point I trust your eyes
more than my own.  ;-)

							Thanx, Paul

> > +
> > +	return __find_swevent_head(hlist, type, event_id);
> >  }
> >  
> >  static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
> > @@ -4095,7 +4112,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
> >  
> >  	rcu_read_lock();
> >  
> > -	head = find_swevent_head(cpuctx, type, event_id);
> > +	head = find_swevent_head_rcu(cpuctx, type, event_id);
> >  
> >  	if (!head)
> >  		goto end;
> > @@ -4178,7 +4195,8 @@ static int perf_swevent_enable(struct perf_event *event)
> >  		perf_swevent_set_period(event);
> >  	}
> >  
> > -	head = find_swevent_head(cpuctx, event->attr.type, event->attr.config);
> > +	head = find_swevent_head(cpuctx, event->attr.type,
> > +				 event->attr.config, event);
> >  	if (WARN_ON_ONCE(!head))
> >  		return -EINVAL;
> >  
> > 
> > 
> 
