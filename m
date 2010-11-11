Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab0KKEUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:20:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60917 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0KKEUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:20:21 -0500
Date: Wed, 10 Nov 2010 20:20:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in
 synchronize_sched_expedited()
Message-ID: <20101111042014.GE3134@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101107020507.GA4974@linux.vnet.ibm.com>
 <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4CD94C0D.3030007@kernel.org>
 <4CDA5E40.3080205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDA5E40.3080205@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:56:32PM +0800, Lai Jiangshan wrote:
> On 11/09/2010 09:26 PM, Tejun Heo wrote:
> > Hello, Paul.
> > 
> > 
> > How about something like the following?  It's slightly bigger but I
> > think it's a bit easier to understand.  Thanks.
> 
> Hello, Paul, Tejun,
> 
> I think this approach is good and much better when several tasks
> call synchronize_sched_expedited() at the same time.

I am becoming more comfortable with it as well.  Tejun, what kind of
testing did you do?  Lai, could you please run it on your systems?

							Thanx, Paul

> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index aa14a56..0069be5 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9342,7 +9342,8 @@ EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
> > 
> >  #else /* #ifndef CONFIG_SMP */
> > 
> > -static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
> > +static atomic_t sync_sched_expedited_token = ATOMIC_INIT(0);
> > +static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
> > 
> >  static int synchronize_sched_expedited_cpu_stop(void *data)
> >  {
> > @@ -9373,11 +9374,18 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
> >   */
> >  void synchronize_sched_expedited(void)
> >  {
> > -	int snap, trycount = 0;
> > +	int my_tok, tok, t, trycount = 0;
> > +
> > +	smp_mb();  /* ensure prior mod happens before getting token. */
> > +
> > +	/*
> > +	 * Get a token.  This is used to coordinate with other
> > +	 * concurrent syncers and consolidate multiple syncs.
> > +	 */
> > +	my_tok = tok = atomic_inc_return(&sync_sched_expedited_token);
> > 
> > -	smp_mb();  /* ensure prior mod happens before capturing snap. */
> > -	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
> >  	get_online_cpus();
> > +
> >  	while (try_stop_cpus(cpu_online_mask,
> >  			     synchronize_sched_expedited_cpu_stop,
> >  			     NULL) == -EAGAIN) {
> > @@ -9388,13 +9396,34 @@ void synchronize_sched_expedited(void)
> >  			synchronize_sched();
> >  			return;
> >  		}
> > -		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
> > +
> > +		/*
> > +		 * If the done count reached @my_tok, we know at least
> > +		 * one synchronization happened since we entered this
> > +		 * function.
> > +		 */
> > +		if (atomic_read(&sync_sched_expedited_done) - my_tok >= 0) {
> >  			smp_mb(); /* ensure test happens before caller kfree */
> >  			return;
> >  		}
> > +
> >  		get_online_cpus();
> > +
> > +		/* about to retry, get the latest token value */
> > +		tok = atomic_read(&sync_sched_expedited_token);
> >  	}
> > -	atomic_inc(&synchronize_sched_expedited_count);
> > +
> > +	/*
> > +	 * We now know that everything upto @tok is synchronized.
> > +	 * Update done counter which should always monotonically
> > +	 * increase (with wrapping considered).
> > +	 */
> > +	do {
> > +		t = atomic_read(&sync_sched_expedited_done);
> > +		if (t - tok >= 0)
> > +			break;
> > +	} while (atomic_cmpxchg(&sync_sched_expedited_done, t, tok) != t);
> > +
> >  	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
> >  	put_online_cpus();
> >  }
> > 
> 
