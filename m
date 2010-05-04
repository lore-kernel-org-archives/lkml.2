Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0EDGiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:38:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:51416 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0EDGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:38:07 -0400
Date: Tue, 4 May 2010 14:37:05 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, John Kacur <jkacur@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lockdep: reduce stack_trace usage
Message-ID: <20100504063705.GB10784@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
 <20100423134044.GA2777@zhy-desktop>
 <1272888689.5605.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1272888689.5605.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 May 2010 06:37:09.0351 (UTC) FILETIME=[38A3A770:01CAEB54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 02:11:29PM +0200, Peter Zijlstra wrote:
> OK, I like the idea, but I'm a little confused as to why you pull
> save_trace() up two functions,

I also want to avoid adding redundant trace in case of trylock.
On my machine, I catched about 150 trylock dependences.

> from what I can see we can now end up
> saving a trace where we previously would not have done one (the whole
> recursive lock mess.

Oh, Yes, this patch will not give result as expected. Thank you for pointing
it. I will respin it in V2.

> 
> So please respin this with save_trace() in check_prev_add() right before
> the first add_lock_to_list().

No problem. 
BTW, in case of trylock dependence, I will let check_prevs_add() carry a flag
to check_prev_add(). Thus, we can save more redundant trace. How do you
think about it?

Thanks,
Yong

> 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> >  kernel/lockdep.c |   20 ++++++++++++--------
> >  1 files changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> > index 2594e1c..097d5fb 100644
> > --- a/kernel/lockdep.c
> > +++ b/kernel/lockdep.c
> > @@ -818,7 +818,8 @@ static struct lock_list *alloc_list_entry(void)
> >   * Add a new dependency to the head of the list:
> >   */
> >  static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
> > -			    struct list_head *head, unsigned long ip, int distance)
> > +			    struct list_head *head, unsigned long ip,
> > +			    int distance, struct stack_trace *trace)
> >  {
> >  	struct lock_list *entry;
> >  	/*
> > @@ -829,11 +830,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
> >  	if (!entry)
> >  		return 0;
> >  
> > -	if (!save_trace(&entry->trace))
> > -		return 0;
> > -
> >  	entry->class = this;
> >  	entry->distance = distance;
> > +	entry->trace = *trace;
> >  	/*
> >  	 * Since we never remove from the dependency list, the list can
> >  	 * be walked lockless by other CPUs, it's only allocation
> > @@ -1635,7 +1634,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
> >   */
> >  static int
> >  check_prev_add(struct task_struct *curr, struct held_lock *prev,
> > -	       struct held_lock *next, int distance)
> > +	       struct held_lock *next, int distance, struct stack_trace *trace)
> >  {
> >  	struct lock_list *entry;
> >  	int ret;
> > @@ -1694,14 +1693,14 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
> >  	 */
> >  	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
> >  			       &hlock_class(prev)->locks_after,
> > -			       next->acquire_ip, distance);
> > +			       next->acquire_ip, distance, trace);
> >  
> >  	if (!ret)
> >  		return 0;
> >  
> >  	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
> >  			       &hlock_class(next)->locks_before,
> > -			       next->acquire_ip, distance);
> > +			       next->acquire_ip, distance, trace);
> >  	if (!ret)
> >  		return 0;
> >  
> > @@ -1732,6 +1731,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
> >  {
> >  	int depth = curr->lockdep_depth;
> >  	struct held_lock *hlock;
> > +	struct stack_trace trace;
> >  
> >  	/*
> >  	 * Debugging checks.
> > @@ -1748,6 +1748,9 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
> >  			curr->held_locks[depth-1].irq_context)
> >  		goto out_bug;
> >  
> > +	if (!save_trace(&trace))
> > +		return 0;
> > +
> >  	for (;;) {
> >  		int distance = curr->lockdep_depth - depth + 1;
> >  		hlock = curr->held_locks + depth-1;
> > @@ -1756,7 +1759,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
> >  		 * added:
> >  		 */
> >  		if (hlock->read != 2) {
> > -			if (!check_prev_add(curr, hlock, next, distance))
> > +			if (!check_prev_add(curr, hlock, next,
> > +						distance, &trace))
> >  				return 0;
> >  			/*
> >  			 * Stop after the first non-trylock entry,
