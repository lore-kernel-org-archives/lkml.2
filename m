Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0F1Om5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:42:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:42204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab0F1Omx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:42:53 -0400
Date: Mon, 28 Jun 2010 16:42:46 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
Message-ID: <20100628144246.GA14201@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
 <4C2417AA.4030306@us.ibm.com>
 <20100625082711.GA32765@tiehlicka.suse.cz>
 <4C24ED34.9040808@us.ibm.com>
 <4C253D32.6040304@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C253D32.6040304@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Fri 25-06-10 16:35:14, Darren Hart wrote:
[...]
> # trace-cmd record -p nop ./runSimple.sh 
> <snip>
> 
> # ps -eLo pid,comm,wchan | grep "simple "
> 20636 simple          pause
> 20876 simple          pause
> 
> # trace-cmd report
> version = 6
> CPU 0 is empty
> cpus=4
> field->offset = 24 size=8
>            <...>-20636 [003]  1778.965860: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH
>            <...>-20636 [003]  1778.965865: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
>            <...>-20636 [003]  1778.965866: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
> >>--->     <...>-20636 [003]  1778.965867: bprint:               futex_lock_pi : returning -ESRCH to userspace
>            <...>-20876 [001]  1780.199394: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying
>            <...>-20876 [001]  1780.199400: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH
>            <...>-20876 [001]  1780.199401: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
>            <...>-20876 [001]  1780.199402: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
> >>--->     <...>-20876 [001]  1780.199403: bprint:               futex_lock_pi : returning -ESRCH to userspace
>            <...>-21316 [002]  1782.300695: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying
>            <...>-21316 [002]  1782.300698: bprint:               futex_lock_pi_atomic : cmpxchg failed, retrying
> 
[...]

I have updated the test case slightly (reduced the number of lock/unlock
cycles to 1).

Then, I have used the additional patch (see bellow) on top of the one
you have posted and here is the log I am getting:

version = 6
cpus=2
field->offset = 16 size=4
           <...>-13232 [001]   226.693880: bprint:               do_futex : futex_lock_pi start
           <...>-13232 [001]   226.693886: bprint:               do_futex : futex_lock_pi done ret=0
           <...>-13235 [001]   226.700204: bprint:               do_futex : futex_lock_pi start
           <...>-13235 [001]   226.700210: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH for pid=13242
           <...>-13235 [001]   226.700211: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-13235 [001]   226.700211: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
           <...>-13235 [001]   226.700212: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-13235 [001]   226.700212: bprint:               do_futex : futex_lock_pi done ret=-3
           <...>-13240 [000]   226.705574: bprint:               do_futex : futex_lock_pi start
           <...>-13240 [000]   226.705580: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH for pid=13242
           <...>-13240 [000]   226.705581: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-13240 [000]   226.705582: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
           <...>-13240 [000]   226.705582: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-13240 [000]   226.705583: bprint:               do_futex : futex_lock_pi done ret=-3
           <...>-13231 [000]   226.708095: bprint:               do_futex : futex_lock_pi start
           <...>-13231 [000]   226.708101: bprint:               futex_lock_pi_atomic : lookup_pi_state: -ESRCH for pid=13242
           <...>-13231 [000]   226.708102: bprint:               futex_lock_pi_atomic : ownerdied not detected, returning -ESRCH
           <...>-13231 [000]   226.708102: bprint:               futex_lock_pi_atomic : lookup_pi_state: -3
           <...>-13231 [000]   226.708103: bprint:               futex_lock_pi : returning -ESRCH to userspace
           <...>-13231 [000]   226.708103: bprint:               do_futex : futex_lock_pi done ret=-3
           <...>-13242 [001]   226.709246: bprint:               do_futex : futex_unlock_pi start
           <...>-13242 [001]   226.709249: bprint:               do_futex : futex_unlock_pi: TID->0 transition 2147496890
           <...>-13242 [001]   226.709250: bprint:               do_futex : futex_unlock_pi: no waiters, unlock the futex ret=0 uval=-2147470406
           <...>-13242 [001]   226.709250: bprint:               do_futex : futex_unlock_pi done ret=0

As you can see lookup_pi_state fails for the pid (13242) which is at the very
bottom and that is unlocking the futex. This smells fishy to me. I can
see this pattern consistently for all failures. Maybe I am doing
something wrong or the timestamps are not precise enough but from what I
can see this looks like a bug in lookup_pi_state which doesn't find an
existing PID.

--
>From 733816347db91670f27d206382b8c2e57e5ef125 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 28 Jun 2010 13:42:29 +0200
Subject: [PATCH] futex pi unlock tracing added

---
 kernel/futex.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 24ac437..d114fee 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -716,7 +716,8 @@ retry:
 	if (unlikely(ret)) {
 		switch (ret) {
 		case -ESRCH:
-			trace_printk("lookup_pi_state: -ESRCH\n");
+			trace_printk("lookup_pi_state: -ESRCH for pid=%u\n",
+					uval & FUTEX_TID_MASK);
 			/*
 			 * No owner found for this futex. Check if the
 			 * OWNER_DIED bit is set to figure out whether
@@ -2070,8 +2071,10 @@ retry:
 	 * again. If it succeeds then we can return without waking
 	 * anyone else up:
 	 */
-	if (!(uval & FUTEX_OWNER_DIED))
+	if (!(uval & FUTEX_OWNER_DIED)) {
 		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
+		trace_printk("futex_unlock_pi: TID->0 transition %u\n", uval);
+	}
 
 
 	if (unlikely(uval == -EFAULT))
@@ -2080,8 +2083,10 @@ retry:
 	 * Rare case: we managed to release the lock atomically,
 	 * no need to wake anyone else up:
 	 */
-	if (unlikely(uval == task_pid_vnr(current)))
+	if (unlikely(uval == task_pid_vnr(current))) {
+		trace_printk("futex_unlock_pi: release without wakeup\n");
 		goto out_unlock;
+	}
 
 	/*
 	 * Ok, other tasks may need to be woken up - check waiters
@@ -2093,6 +2098,7 @@ retry:
 		if (!match_futex (&this->key, &key))
 			continue;
 		ret = wake_futex_pi(uaddr, uval, this);
+		trace_printk("futex_unlock_pi: wake ret=%d uval=%u this=%p\n", ret, uval, this);
 		/*
 		 * The atomic access to the futex value
 		 * generated a pagefault, so retry the
@@ -2107,6 +2113,8 @@ retry:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
 		ret = unlock_futex_pi(uaddr, uval);
+		trace_printk("futex_unlock_pi: no waiters, unlock the futex ret=%d uval=%d\n",
+				ret, uval);
 		if (ret == -EFAULT)
 			goto pi_faulted;
 	}
@@ -2600,12 +2608,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		if (futex_cmpxchg_enabled)
+		if (futex_cmpxchg_enabled) {
+			trace_printk("futex_lock_pi start\n");
 			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+			trace_printk("futex_lock_pi done ret=%d\n", ret);
+		}
 		break;
 	case FUTEX_UNLOCK_PI:
-		if (futex_cmpxchg_enabled)
+		if (futex_cmpxchg_enabled) {
+			trace_printk("futex_unlock_pi start\n");
 			ret = futex_unlock_pi(uaddr, fshared);
+			trace_printk("futex_unlock_pi done ret=%d\n", ret);
+		}
 		break;
 	case FUTEX_TRYLOCK_PI:
 		if (futex_cmpxchg_enabled)
-- 
1.7.1

> 
> --
> Darren Hart
> 
> From 92014a07df73489460ff788274506255ff0f775d Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Fri, 25 Jun 2010 13:54:25 -0700
> Subject: [PATCH] robust pi futex tracing
> 
> ---
>  kernel/futex.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e7a35f1..24ac437 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -683,6 +683,8 @@ retry:
>  	 */
>  	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
>  		/* Keep the OWNER_DIED bit */
> +		if (ownerdied)
> +			trace_printk("ownerdied, taking over lock\n");
>  		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
>  		ownerdied = 0;
>  		lock_taken = 1;
> @@ -692,14 +694,18 @@ retry:
>  
>  	if (unlikely(curval == -EFAULT))
>  		return -EFAULT;
> -	if (unlikely(curval != uval))
> +	if (unlikely(curval != uval)) {
> +		trace_printk("cmpxchg failed, retrying\n");
>  		goto retry;
> +	}
>  
>  	/*
>  	 * We took the lock due to owner died take over.
>  	 */
> -	if (unlikely(lock_taken))
> +	if (unlikely(lock_taken)) {
> +		trace_printk("ownerdied, lock acquired, return 1\n");
>  		return 1;
> +	}
>  
>  	/*
>  	 * We dont have the lock. Look up the PI state (or create it if
> @@ -710,13 +716,16 @@ retry:
>  	if (unlikely(ret)) {
>  		switch (ret) {
>  		case -ESRCH:
> +			trace_printk("lookup_pi_state: -ESRCH\n");
>  			/*
>  			 * No owner found for this futex. Check if the
>  			 * OWNER_DIED bit is set to figure out whether
>  			 * this is a robust futex or not.
>  			 */
> -			if (get_futex_value_locked(&curval, uaddr))
> +			if (get_futex_value_locked(&curval, uaddr)) {
> +				trace_printk("get_futex_value_locked: -EFAULT\n");
>  				return -EFAULT;
> +			}
>  
>  			/*
>  			 * We simply start over in case of a robust
> @@ -724,10 +733,13 @@ retry:
>  			 * and return happy.
>  			 */
>  			if (curval & FUTEX_OWNER_DIED) {
> +				trace_printk("ownerdied, goto retry\n");
>  				ownerdied = 1;
>  				goto retry;
>  			}
> +			trace_printk("ownerdied not detected, returning -ESRCH\n");
>  		default:
> +			trace_printk("lookup_pi_state: %d\n", ret);
>  			break;
>  		}
>  	}
> @@ -1950,6 +1962,8 @@ retry_private:
>  			put_futex_key(fshared, &q.key);
>  			cond_resched();
>  			goto retry;
> +		case -ESRCH:
> +			trace_printk("returning -ESRCH to userspace\n");
>  		default:
>  			goto out_unlock_put_key;
>  		}
> @@ -2537,8 +2551,10 @@ void exit_robust_list(struct task_struct *curr)
>  		/*
>  		 * Avoid excessively long or circular lists:
>  		 */
> -		if (!--limit)
> +		if (!--limit) {
> +			trace_printk("excessively long list, aborting\n");
>  			break;
> +		}
>  
>  		cond_resched();
>  	}
> -- 
> 1.7.0.4
> 
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
