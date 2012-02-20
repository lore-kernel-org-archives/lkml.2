Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2BTRok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:44:40 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44956 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2BTRoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:44:39 -0500
Date: Mon, 20 Feb 2012 09:44:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
Message-ID: <20120220174418.GI2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120213020951.GA12138@linux.vnet.ibm.com>
 <4F41F315.1040900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F41F315.1040900@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022017-5518-0000-0000-00000260E951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 03:15:33PM +0800, Lai Jiangshan wrote:
> On 02/13/2012 10:09 AM, Paul E. McKenney wrote:
> 
> >  /*
> >   * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
> >   */
> > -static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
> > +static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
> >  {
> >  	int idx;
> >  
> > @@ -178,90 +316,51 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
> >  			   !lock_is_held(&rcu_sched_lock_map),
> >  			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
> >  
> > -	idx = sp->completed;
> > +	idx = ACCESS_ONCE(sp->completed);
> >  	mutex_lock(&sp->mutex);
> >  
> >  	/*
> >  	 * Check to see if someone else did the work for us while we were
> > -	 * waiting to acquire the lock.  We need -two- advances of
> > +	 * waiting to acquire the lock.  We need -three- advances of
> >  	 * the counter, not just one.  If there was but one, we might have
> >  	 * shown up -after- our helper's first synchronize_sched(), thus
> >  	 * having failed to prevent CPU-reordering races with concurrent
> > -	 * srcu_read_unlock()s on other CPUs (see comment below).  So we
> > -	 * either (1) wait for two or (2) supply the second ourselves.
> > +	 * srcu_read_unlock()s on other CPUs (see comment below).  If there
> > +	 * was only two, we are guaranteed to have waited through only one
> > +	 * full index-flip phase.  So we either (1) wait for three or
> > +	 * (2) supply the additional ones we need.
> >  	 */
> >  
> > -	if ((sp->completed - idx) >= 2) {
> > +	if (sp->completed == idx + 2)
> > +		idx = 1;
> > +	else if (sp->completed == idx + 3) {
> >  		mutex_unlock(&sp->mutex);
> >  		return;
> > -	}
> > -
> > -	sync_func();  /* Force memory barrier on all CPUs. */
> > +	} else
> > +		idx = 0;
> 
> 
> Hi, Paul
> 
> I don't think this check-and-return path is needed since we will introduce call_srcu().
> 
> We just need a correct code to show how it works and to be used for a while,
> and new call_srcu() will be implemented based on this correct code which will be removed.

Hello, Lai!

Yep, this code will be replaced with a state machine driven by callbacks.

> And I think this unneeded check-and-return path is incorrect. See the following:
> 
> Reader			Updater						Helper thread
> 			old_ptr = rcu_ptr;
> 			/* rcu_ptr = NULL; but be reordered to (1) */
> 			start synchronize_srcu()
> 			idx = ACCESS_ONCE(sp->completed);(2)
> 									synchronize_srcu()
> 									synchronize_srcu()
> srcu_read_lock();
> old_ptr = rcu_ptr;
> 			rcu_ptr = NULL;(1)
> 			mutex_lock() and read sp->completed
> 			and return from synchronize_srcu()
> 			free(old_ptr);
> use freed old_ptr
> srcu_read_unlock();
> 
> 
> So, we need a smb_mb() between (1) and (2) to force the order.
> 
> __synchronize_srcu() {
> 	smp_mb(); /* F */
> 	idx = ACCESS_ONCE(sp->completed); /* (2) */

And one here as well because mutex_lock() allows code to bleed in from
outside the critical section.

> 	....
> }

Good catch!  And shows the limitations of testing -- I hit this pretty
hard and didn't get a failure.  I was focused so much on the complex
part of the patch that I failed to get the simple stuff right!!!

Shows the value of the Linux community's review processes, I guess.  ;-)

> And this smp_mb() F is paired with helper's smp_mb() D. So if Updater sees X advances of
> ->completed, Updater must sees X times of *full* flip_and_wait(). So We need see -two- advances of
> ->completed from Helper only, not -three-.

Hmmm...  Let's see...  The case I was worried about is where the updater
samples ->completed just before it is incremented, then samples it again
just after it is incremented a second time.  So you are arguing that this
cannot happen because the second sample occurs after acquiring the lock,
so that the second flip-and-wait cycle has to have already completed,
correct?

So waiting for three is appropriate for mutex_try_lock(), but is overly
conservative for mutex_lock().

>         if (sp->completed == idx + 1)
>                 idx = 1;
>         else if (sp->completed == idx + 2) {
>                 mutex_unlock(&sp->mutex);
>                 return;
>         } else
>                 idx = 0;
> 
> 
> Or simpler:
> 
> __synchronize_srcu() {
> 	unsigned int idx;   /* <-------- unsigned */
> 
> 	/* comments for smp_mb() F */
> 	smp_mb(); /* F */
> 	idx = ACCESS_ONCE(sp->completed);
> 
> 	mutex_lock(&sp->mutex);
> 	idx = sp->completed - idx;
> 
> 	/* original comments */
> 	for (; idx < 2; idx++)
>                 flip_idx_and_wait(sp, expedited);
>         mutex_unlock(&sp->mutex);
> }
> 
> At last, I can't understand the comments of this check-and-return path.
> So maybe the above reply and I are totally wrong.

I -think- you might be correct, but my approach is going to be to implement
call_srcu() which will eliminate this anyway.

> But the comments of this check-and-return path does not describe the code
> well(especially the order), and it contains the old "synchronize_sched()"
> which make me confuse.

The diffs are confusing -- I have to look at the actual code in this case.

> My conclusion, we can just remove the check-and-return path to reduce
> the complexity since we will introduce call_srcu().

If I actually submit the above upstream, that would be quite reasonable.
My thought is that patch remains RFC and the upstream version has
call_srcu().

> This new srcu is very great, especially the SRCU_USAGE_COUNT for every
> lock/unlock witch forces any increment/decrement pair changes the counter
> for me.

Glad you like it!  ;-)

And thank you for your review and feedback!

							Thanx, Paul

> Thanks,
> Lai
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

