Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0F1PcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:32:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0F1PcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:32:19 -0400
Date: Mon, 28 Jun 2010 17:32:14 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100628153214.GA24127@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
 <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
 <20100628144246.GA14201@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628144246.GA14201@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-06-10 16:42:46, Michal Hocko wrote:
> Hi Darren,

Hmm, I think that I've found the reason. I have used one additional
tracing patch (bellow) and we are getting ESRCH because cread and pcred
don't match:


version = 6
CPU 0 is empty
cpus=2
field->offset = 16 size=4
           <...>-22260 [001]   139.669672: bprint:               do_futex : futex_lock_pi start
           <...>-22260 [001]   139.669678: bprint:               do_futex : futex_lock_pi done ret=0
           <...>-22281 [001]   139.693690: bprint:               do_futex : futex_lock_pi start
           <...>-22281 [001]   139.693696: bprint:               lookup_pi_state : cred(1004,1004) != pcred(1003,1003)
           <...>-22281 [001]   139.693697: bprint:               lookup_pi_state : futex_find_get_task failed with -3
           <...>-22281 [001]   139.693697: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH for pid=22280
           <...>-22281 [001]   139.693698: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-22281 [001]   139.693698: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
           <...>-22281 [001]   139.693699: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-22281 [001]   139.693700: bprint:               do_futex : futex_lock_pi done ret=-3
           <...>-22280 [001]   139.694033: bprint:               do_futex : futex_unlock_pi start
           <...>-22280 [001]   139.694035: bprint:               do_futex : futex_unlock_pi: TID->0 transition 2147505928
           <...>-22280 [001]   139.694036: bprint:               do_futex : futex_unlock_pi: no waiters, unlock the futex ret=0 uval=-2147461368
           <...>-22280 [001]   139.694036: bprint:               do_futex : futex_unlock_pi done ret=0
           <...>-22488 [001]   139.874967: bprint:               do_futex : futex_lock_pi start
           <...>-22488 [001]   139.874972: bprint:               do_futex : futex_lock_pi done ret=0

This would answer why we cannot reproduce with a single user.
Btw. I guess that there is a typo in the condition and it should be
like this:
	if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid)
+ 		    cred->uid != pcred->uid)

--
>From f0743d2b2d2f81c40700c4d6816ad3abfd113c1b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 28 Jun 2010 17:08:56 +0200
Subject: [PATCH] more traces

---
 kernel/futex.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index d114fee..d1c2489 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -435,11 +435,16 @@ static struct task_struct * futex_find_get_task(pid_t pid)
 	p = find_task_by_vpid(pid);
 	if (!p) {
 		p = ERR_PTR(-ESRCH);
+		trace_printk("%u pid not found\n", pid);
 	} else {
 		pcred = __task_cred(p);
 		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid)
+		    cred->euid != pcred->uid) {
 			p = ERR_PTR(-ESRCH);
+			trace_printk("cred(%u,%u) != pcred(%u,%u)\n",
+					cred->euid, cred->uid,
+					pcred->euid, pcred->uid);
+		}
 		else
 			get_task_struct(p);
 	}
@@ -564,8 +569,11 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	if (!pid)
 		return -ESRCH;
 	p = futex_find_get_task(pid);
-	if (IS_ERR(p))
+	if (IS_ERR(p)) {
+		trace_printk("futex_find_get_task failed with %d\n",
+				PTR_ERR(p));
 		return PTR_ERR(p);
+	}
 
 	/*
 	 * We need to look at the task state flags to figure out,
@@ -581,6 +589,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 		 * cleanup:
 		 */
 		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
+		trace_printk("pid=%u is exiting ret=%d\n", pid, ret);
 
 		raw_spin_unlock_irq(&p->pi_lock);
 		put_task_struct(p);
-- 
1.7.1


> 
> --
> From 733816347db91670f27d206382b8c2e57e5ef125 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 28 Jun 2010 13:42:29 +0200
> Subject: [PATCH] futex pi unlock tracing added
> 
> ---
>  kernel/futex.c |   24 +++++++++++++++++++-----
>  1 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 24ac437..d114fee 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -716,7 +716,8 @@ retry:
>  	if (unlikely(ret)) {
>  		switch (ret) {
>  		case -ESRCH:
> -			trace_printk("lookup_pi_state: -ESRCH\n");
> +			trace_printk("lookup_pi_state: -ESRCH for pid=%u\n",
> +					uval & FUTEX_TID_MASK);
>  			/*
>  			 * No owner found for this futex. Check if the
>  			 * OWNER_DIED bit is set to figure out whether
> @@ -2070,8 +2071,10 @@ retry:
>  	 * again. If it succeeds then we can return without waking
>  	 * anyone else up:
>  	 */
> -	if (!(uval & FUTEX_OWNER_DIED))
> +	if (!(uval & FUTEX_OWNER_DIED)) {
>  		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
> +		trace_printk("futex_unlock_pi: TID->0 transition %u\n", uval);
> +	}
>  
>  
>  	if (unlikely(uval == -EFAULT))
> @@ -2080,8 +2083,10 @@ retry:
>  	 * Rare case: we managed to release the lock atomically,
>  	 * no need to wake anyone else up:
>  	 */
> -	if (unlikely(uval == task_pid_vnr(current)))
> +	if (unlikely(uval == task_pid_vnr(current))) {
> +		trace_printk("futex_unlock_pi: release without wakeup\n");
>  		goto out_unlock;
> +	}
>  
>  	/*
>  	 * Ok, other tasks may need to be woken up - check waiters
> @@ -2093,6 +2098,7 @@ retry:
>  		if (!match_futex (&this->key, &key))
>  			continue;
>  		ret = wake_futex_pi(uaddr, uval, this);
> +		trace_printk("futex_unlock_pi: wake ret=%d uval=%u this=%p\n", ret, uval, this);
>  		/*
>  		 * The atomic access to the futex value
>  		 * generated a pagefault, so retry the
> @@ -2107,6 +2113,8 @@ retry:
>  	 */
>  	if (!(uval & FUTEX_OWNER_DIED)) {
>  		ret = unlock_futex_pi(uaddr, uval);
> +		trace_printk("futex_unlock_pi: no waiters, unlock the futex ret=%d uval=%d\n",
> +				ret, uval);
>  		if (ret == -EFAULT)
>  			goto pi_faulted;
>  	}
> @@ -2600,12 +2608,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
>  		break;
>  	case FUTEX_LOCK_PI:
> -		if (futex_cmpxchg_enabled)
> +		if (futex_cmpxchg_enabled) {
> +			trace_printk("futex_lock_pi start\n");
>  			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
> +			trace_printk("futex_lock_pi done ret=%d\n", ret);
> +		}
>  		break;
>  	case FUTEX_UNLOCK_PI:
> -		if (futex_cmpxchg_enabled)
> +		if (futex_cmpxchg_enabled) {
> +			trace_printk("futex_unlock_pi start\n");
>  			ret = futex_unlock_pi(uaddr, fshared);
> +			trace_printk("futex_unlock_pi done ret=%d\n", ret);
> +		}
>  		break;
>  	case FUTEX_TRYLOCK_PI:
>  		if (futex_cmpxchg_enabled)
> -- 
> 1.7.1
> 
> > 
> > --
> > Darren Hart
> > 
> > From 92014a07df73489460ff788274506255ff0f775d Mon Sep 17 00:00:00 2001
> > From: Darren Hart <dvhltc@us.ibm.com>
> > Date: Fri, 25 Jun 2010 13:54:25 -0700
> > Subject: [PATCH] robust pi futex tracing
> > 
> > ---
> >  kernel/futex.c |   24 ++++++++++++++++++++----
> >  1 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index e7a35f1..24ac437 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -683,6 +683,8 @@ retry:
> >  	 */
> >  	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
> >  		/* Keep the OWNER_DIED bit */
> > +		if (ownerdied)
> > +			trace_printk("ownerdied, taking over lock\n");
> >  		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
> >  		ownerdied = 0;
> >  		lock_taken = 1;
> > @@ -692,14 +694,18 @@ retry:
> >  
> >  	if (unlikely(curval == -EFAULT))
> >  		return -EFAULT;
> > -	if (unlikely(curval != uval))
> > +	if (unlikely(curval != uval)) {
> > +		trace_printk("cmpxchg failed, retrying\n");
> >  		goto retry;
> > +	}
> >  
> >  	/*
> >  	 * We took the lock due to owner died take over.
> >  	 */
> > -	if (unlikely(lock_taken))
> > +	if (unlikely(lock_taken)) {
> > +		trace_printk("ownerdied, lock acquired, return 1\n");
> >  		return 1;
> > +	}
> >  
> >  	/*
> >  	 * We dont have the lock. Look up the PI state (or create it if
> > @@ -710,13 +716,16 @@ retry:
> >  	if (unlikely(ret)) {
> >  		switch (ret) {
> >  		case -ESRCH:
> > +			trace_printk("lookup_pi_state: -ESRCH\n");
> >  			/*
> >  			 * No owner found for this futex. Check if the
> >  			 * OWNER_DIED bit is set to figure out whether
> >  			 * this is a robust futex or not.
> >  			 */
> > -			if (get_futex_value_locked(&curval, uaddr))
> > +			if (get_futex_value_locked(&curval, uaddr)) {
> > +				trace_printk("get_futex_value_locked: -EFAULT\n");
> >  				return -EFAULT;
> > +			}
> >  
> >  			/*
> >  			 * We simply start over in case of a robust
> > @@ -724,10 +733,13 @@ retry:
> >  			 * and return happy.
> >  			 */
> >  			if (curval & FUTEX_OWNER_DIED) {
> > +				trace_printk("ownerdied, goto retry\n");
> >  				ownerdied = 1;
> >  				goto retry;
> >  			}
> > +			trace_printk("ownerdied not detected, returning -ESRCH\n");
> >  		default:
> > +			trace_printk("lookup_pi_state: %d\n", ret);
> >  			break;
> >  		}
> >  	}
> > @@ -1950,6 +1962,8 @@ retry_private:
> >  			put_futex_key(fshared, &q.key);
> >  			cond_resched();
> >  			goto retry;
> > +		case -ESRCH:
> > +			trace_printk("returning -ESRCH to userspace\n");
> >  		default:
> >  			goto out_unlock_put_key;
> >  		}
> > @@ -2537,8 +2551,10 @@ void exit_robust_list(struct task_struct *curr)
> >  		/*
> >  		 * Avoid excessively long or circular lists:
> >  		 */
> > -		if (!--limit)
> > +		if (!--limit) {
> > +			trace_printk("excessively long list, aborting\n");
> >  			break;
> > +		}
> >  
> >  		cond_resched();
> >  	}
> > -- 
> > 1.7.0.4
> > 
> > -- 
> > Darren Hart
> > IBM Linux Technology Center
> > Real-Time Linux Team
> 
> -- 
> Michal Hocko
> L3 team 
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
