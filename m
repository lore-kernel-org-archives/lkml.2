Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab1ITPIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:08:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48687 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1ITPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:08:50 -0400
Date: Tue, 20 Sep 2011 07:57:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 41/55] rcu: Permit rt_mutex_unlock() with
 irqs disabled
Message-ID: <20110920145754.GB2380@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-41-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110918040923.GA2363@zhy>
 <20110919041459.GJ2333@linux.vnet.ibm.com>
 <CAM2zO=B3FM3QrTB7yCTEoUZ5tF2734s8VEzgBnXLJK1uWkZdFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM2zO=B3FM3QrTB7yCTEoUZ5tF2734s8VEzgBnXLJK1uWkZdFA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092014-6078-0000-0000-000000FB4A63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 01:49:33PM +0800, Yong Zhang wrote:
> On Mon, Sep 19, 2011 at 12:14 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sun, Sep 18, 2011 at 12:09:23PM +0800, Yong Zhang wrote:
> >> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >> > index d3127e8..f6c63ea 100644
> >> > --- a/kernel/rcutree_plugin.h
> >> > +++ b/kernel/rcutree_plugin.h
> >> > @@ -1149,6 +1149,8 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
> >> >
> >> >  #endif /* #else #ifdef CONFIG_RCU_TRACE */
> >> >
> >> > +static struct lock_class_key rcu_boost_class;
> >> > +
> >> >  /*
> >> >   * Carry out RCU priority boosting on the task indicated by ->exp_tasks
> >> >   * or ->boost_tasks, advancing the pointer to the next task in the
> >> > @@ -1211,10 +1213,14 @@ static int rcu_boost(struct rcu_node *rnp)
> >> >      */
> >> >     t = container_of(tb, struct task_struct, rcu_node_entry);
> >> >     rt_mutex_init_proxy_locked(&mtx, t);
> >> > +   /* Avoid lockdep false positives.  This rt_mutex is its own thing. */
> >> > +   lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
> >> > +                              "rcu_boost_mutex");
> >> >     t->rcu_boost_mutex = &mtx;
> >>
> >>       raw_spin_unlock_irqrestore(&rnp->lock, flags);  <====A
> >>
> >> >     rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> >> >     rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> >> > +   local_irq_restore(flags);
> >>
> >> Does it help here?
> >> irq is enabled at A. So we still call rt_mutex_lock() with irq enabled.
> >>
> >> Seems should s/raw_spin_unlock_irqrestore/raw_spin_unlock ?
> >
> > Hmmm...  The above works at least by accident, but I am clearly not
> > testing calling rt_mutex_lock(&mtx) and rt_mutex_unlock(&mtx) with
> > interrupts disabled anywhere near as heavily as I thought I was.
> >
> > I will fix this one way or the other.
> 
> Forget to mention: if we want to suppress the lockdep warning on
> overlapping usage of rcu_read_*()/local_irq_*() like below:
> 
> rcu_read_lock();
> ...
> local_irq_disable();
> ...
> rcu_read_unlock();
> ...
> local_irq_enable();
> 
> 'rt_mutex_unlock(rbmp);' must also be surrounded by
> local_irq_irqsave()/restore().
> 
> Untested patch is attached.

What I am doing for 3.2 (given that the merge window is likely very soon)
is removing the redundant local_irq_restore().  For 3.3, I will apply
something like your patch below to rcu_boost(), and will think about
what (if anything) to do about rcu_read_unlock_special().  With your
Signed-off-by either way, of course.

							Thanx, Paul

> Thanks,
> Yong
> 
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] rcu: Permit rt_mutex_unlock() with irqs disabled take#2
> 
> This make the below rcu usage really valid(AKA: lockdep
> will not warn on it):
> 
> rcu_read_lock();
> local_irq_disable();
> rcu_read_unlock();
> local_irq_enable();
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  kernel/rcutree_plugin.h |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index e7eea74..d41a9b0 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -398,8 +398,11 @@ static noinline void
> rcu_read_unlock_special(struct task_struct *t)
> 
>  #ifdef CONFIG_RCU_BOOST
>  		/* Unboost if we were boosted. */
> -		if (rbmp)
> +		if (rbmp) {
> +			local_irq_save(flags);
>  			rt_mutex_unlock(rbmp);
> +			local_irq_restore(flags);
> +		}
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> 
>  		/*
> @@ -1225,7 +1228,7 @@ static int rcu_boost(struct rcu_node *rnp)
>  	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
>  				   "rcu_boost_mutex");
>  	t->rcu_boost_mutex = &mtx;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	raw_spin_unlock(&rnp->lock);
>  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
>  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
>  	local_irq_restore(flags);
> -- 
> 1.7.4.1

> From 7d74d1b89a4cd4c03b30e47044b716913f68bd1d Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Mon, 19 Sep 2011 13:42:32 +0800
> Subject: [PATCH] rcu: Permit rt_mutex_unlock() with irqs disabled take#2
> 
> This make the below rcu usage really valid(AKA: lockdep
> will not warn on it):
> 
> rcu_read_lock();
> local_irq_disable();
> rcu_read_unlock();
> local_irq_enable();
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  kernel/rcutree_plugin.h |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index e7eea74..d41a9b0 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -398,8 +398,11 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  
>  #ifdef CONFIG_RCU_BOOST
>  		/* Unboost if we were boosted. */
> -		if (rbmp)
> +		if (rbmp) {
> +			local_irq_save(flags);
>  			rt_mutex_unlock(rbmp);
> +			local_irq_restore(flags);
> +		}
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  
>  		/*
> @@ -1225,7 +1228,7 @@ static int rcu_boost(struct rcu_node *rnp)
>  	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
>  				   "rcu_boost_mutex");
>  	t->rcu_boost_mutex = &mtx;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	raw_spin_unlock(&rnp->lock);
>  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
>  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
>  	local_irq_restore(flags);
> -- 
> 1.7.4.1
> 

