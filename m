Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0EGTMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:12:02 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53965 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab0EGTMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:12:00 -0400
Message-ID: <4BE465F8.2090607@us.ibm.com>
Date: Fri, 07 May 2010 12:11:52 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive spinning
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com> <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 5 May 2010, Darren Hart wrote:
> 
>> Add a non-pi TID value based futex locking mechanism. This enables the
>> use of adaptive spinning which was problematic with the basic FUTEX_WAIT
>> operation.
> 
> You still do way too much work in that spin code with way too much
> code lines.
> 
> Can you try the following (completely uncompiled/untested) patch ?

After some tweaking this patch results in very little change in the
results - but does cut down the complexity of the solution quite a bit.

Two questions inline (not included in the new patch) and a new version
of the patch below.

> 
> Thanks,
> 
> 	tglx
> Subject: futex-simplify.patch
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 07 May 2010 17:56:38 +0200
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/futex.c |   42 ++++++++++++------------------------
>  kernel/sched.c |   66 ---------------------------------------------------------
>  2 files changed, 14 insertions(+), 94 deletions(-)
> 
> Index: linux-2.6-tip/kernel/futex.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/futex.c
> +++ linux-2.6-tip/kernel/futex.c
> @@ -2406,11 +2406,10 @@ out:
>   *  1 - Futex lock acquired
>   * <0 - On error
>   */
> -static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
> +static int trylock_futex_adaptive(u32 __user *uaddr, struct hrtimer_sleeper *to)
>  {
>  	struct thread_info *owner = NULL;
>  	pid_t curtid, ownertid = 0;
> -	ktime_t now;
>  	int ret = 0;
>  	u32 curval;
> 
> @@ -2425,43 +2424,32 @@ static int trylock_futex_adaptive(u32 __
>  		/*
>  		 * Try to acquire the lock.
>  		 */
> -		if (curval == 0)
> +		if (curval == 0) {
>  			curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
> 
> -		if (curval == 0) {
> -			ret = 1;
> -			break;
> -		}
> +			if (curval == 0) {
> +				ret = 1;
> +				break;
> +			}
> 
> -		if (unlikely(curval == -EFAULT)) {
> -			ret = -EFAULT;
> -			break;
> +			if (unlikely(curval == -EFAULT)) {
> +				ret = -EFAULT;
> +				break;
> +			}
>  		}
> 
> -		/*
> -		 * Futex locks manage the owner atomically. We are not in
> -		 * danger of deadlock by preempting a pending owner. Abort the
> -		 * loop if our time slice has expired.  RT Threads can spin
> -		 * until they preempt the owner, at which point they will break
> -		 * out of the loop anyway.
> -		 */
> -		if (need_resched())
> +		if (to && !to->task) {
> +			ret = -ETIMEOUT;
>  			break;
> -
> -		if (timeout) {
> -			now = ktime_get();
> -			if (timeout->tv64 < now.tv64)
> -				break;
>  		}
> 
> -		cpu_relax();


Why remove this?


> -
>  		if ((curval & FUTEX_TID_MASK) != ownertid) {
>  			if (owner)
>  				put_task_struct(owner->task);
>  			owner = futex_owner(uaddr);
>  		}
> -		if (owner && !futex_spin_on_owner(uaddr, owner))
> +
> +		if (!owner->oncpu)
>  			break;
>  	}
> 
> @@ -2510,9 +2498,7 @@ static int futex_lock(u32 __user *uaddr,
>  retry:
>  #ifdef CONFIG_SMP
>  	if (flags & FLAGS_ADAPTIVE) {
> -		preempt_disable();
>  		ret = trylock_futex_adaptive(uaddr, time);
> -		preempt_enable();


Removing the preempt_disable() makes it more likely for a spinner to get
preempted while spinning. Putting these back and adding need_resched()
in trylock_futex_adaptive() will make it much more likely for a task to
queue up on the futex before getting descheduled.


> 
>  		/* We got the lock. */
>  		if (ret == 1) {
> Index: linux-2.6-tip/kernel/sched.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sched.c
> +++ linux-2.6-tip/kernel/sched.c
> @@ -3821,72 +3821,6 @@ out:
>  }
>  #endif
> 
> -#ifdef CONFIG_FUTEX
> -#include <linux/futex.h>
> -
> -int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
> -{
> -	u32 ownertid, uval;
> -	unsigned int cpu;
> -	struct rq *rq;
> -
> -	if (!sched_feat(OWNER_SPIN))
> -		return 0;
> -
> -#ifdef CONFIG_DEBUG_PAGEALLOC
> -	/*
> -	 * Need to access the cpu field knowing that
> -	 * DEBUG_PAGEALLOC could have unmapped it if
> -	 * the mutex owner just released it and exited.
> -	 */
> -	if (probe_kernel_address(&owner->cpu, cpu))
> -		goto out;
> -#else
> -	cpu = owner->cpu;
> -#endif
> -
> -	/*
> -	 * Even if the access succeeded (likely case),
> -	 * the cpu field may no longer be valid.
> -	 */
> -	if (cpu >= nr_cpumask_bits)
> -		goto out;
> -
> -	/*
> -	 * We need to validate that we can do a
> -	 * get_cpu() and that we have the percpu area.
> -	 */
> -	if (!cpu_online(cpu))
> -		goto out;
> -
> -	rq = cpu_rq(cpu);
> -
> -	if (get_user(ownertid, uaddr))
> -		return -EFAULT;
> -	ownertid &= FUTEX_TID_MASK;
> -
> -	for (;;) {
> -		/*
> -		 * Owner changed, break to re-assess state.
> -		 */
> -		if (get_user(uval, uaddr))
> -			return -EFAULT;
> -		if ((uval & FUTEX_TID_MASK) != ownertid)
> -			break;
> -
> -		/*
> -		 * Is that owner really running on that cpu?
> -		 */
> -		if (task_thread_info(rq->curr) != owner || need_resched())
> -			return 0;
> -
> -		cpu_relax();
> -	}
> -out:
> -	return 1;
> -}
> -#endif
> -
>  #ifdef CONFIG_PREEMPT
>  /*
>   * this is the entry point to schedule() from in-kernel preemption


Note: this version has been modified by Darren Hart to:
o remove the timeout handling changes as the timer is not yet armed.
o "owner" conversion from ti to task
o trylock_futex_adaptive owner null check

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 include/linux/futex.h |    1 -
 kernel/futex.c        |   66 ++++++++++++++++--------------------------------
 kernel/sched.c        |   66 -------------------------------------------------
 3 files changed, 22 insertions(+), 111 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 3ca93d1..ac374f2 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -182,7 +182,6 @@ union futex_key {
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
 extern int futex_cmpxchg_enabled;
-extern struct thread_info *futex_owner(u32 __user *uaddr);
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff --git a/kernel/futex.c b/kernel/futex.c
index f9e56b9..37f763f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -371,16 +371,15 @@ static int get_futex_value_locked(u32 *dest, u32 __user *from)
 
 #ifdef CONFIG_SMP
 /**
- * futex_owner() - Lookup the thread_info struct of ther futex owner
+ * futex_owner() - Lookup the task struct of ther futex owner
  * @uaddr: The user address containing the TID of the owner
  *
- * If a non-NULL ti is returned, the caller must call
- * put_task_struct(ti->task).
+ * If a non-NULL task is returned, the caller must call
+ * put_task_struct(task).
  * */
-struct thread_info *futex_owner(u32 __user *uaddr)
+struct task_struct *futex_owner(u32 __user *uaddr)
 {
-	struct thread_info *ti = NULL;
-	struct task_struct *p;
+	struct task_struct *p = NULL;
 	pid_t pid;
 	u32 uval;
 
@@ -389,20 +388,11 @@ struct thread_info *futex_owner(u32 __user *uaddr)
 
 	pid = uval & FUTEX_TID_MASK;
 	rcu_read_lock();
-	p = find_task_by_vpid(pid);
-	if (p) {
-		const struct cred *cred, *pcred;
-
-		cred = current_cred();
-		pcred = __task_cred(p);
-		if (cred->euid == pcred->euid || cred->euid == pcred->uid) {
-			ti = task_thread_info(p);
-			get_task_struct(ti->task);
-		}
-	}
+	if ((p = find_task_by_vpid(pid)))
+		get_task_struct(p);
 	rcu_read_unlock();
 
-	return ti;
+	return p;
 }
 #endif
 
@@ -2408,7 +2398,7 @@ out:
  */
 static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
 {
-	struct thread_info *owner = NULL;
+	struct task_struct *owner = NULL;
 	pid_t curtid, ownertid = 0;
 	ktime_t now;
 	int ret = 0;
@@ -2425,48 +2415,38 @@ static int trylock_futex_adaptive(u32 __user *uaddr, ktime_t *timeout)
 		/*
 		 * Try to acquire the lock.
 		 */
-		if (curval == 0)
+		if (curval == 0) {
 			curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
 
-		if (curval == 0) {
-			ret = 1;
-			break;
-		}
+			if (curval == 0) {
+				ret = 1;
+				break;
+			}
 
-		if (unlikely(curval == -EFAULT)) {
-			ret = -EFAULT;
-			break;
+			if (unlikely(curval == -EFAULT)) {
+				ret = -EFAULT;
+				break;
+			}
 		}
 
-		/*
-		 * Futex locks manage the owner atomically. We are not in
-		 * danger of deadlock by preempting a pending owner. Abort the
-		 * loop if our time slice has expired.  RT Threads can spin
-		 * until they preempt the owner, at which point they will break
-		 * out of the loop anyway.
-		 */
-		if (need_resched())
-			break;
-
 		if (timeout) {
 			now = ktime_get();
 			if (timeout->tv64 < now.tv64)
 				break;
 		}
 
-		cpu_relax();
-
 		if ((curval & FUTEX_TID_MASK) != ownertid) {
 			if (owner)
-				put_task_struct(owner->task);
+				put_task_struct(owner);
 			owner = futex_owner(uaddr);
 		}
-		if (owner && !futex_spin_on_owner(uaddr, owner))
+
+		if (owner && !owner->oncpu)
 			break;
 	}
 
 	if (owner)
-		put_task_struct(owner->task);
+		put_task_struct(owner);
 
 	return ret;
 }
@@ -2510,9 +2490,7 @@ static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
 retry:
 #ifdef CONFIG_SMP
 	if (flags & FLAGS_ADAPTIVE) {
-		preempt_disable();
 		ret = trylock_futex_adaptive(uaddr, time);
-		preempt_enable();
 
 		/* We got the lock. */
 		if (ret == 1) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 9915bdf..84424e6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3827,72 +3827,6 @@ out:
 }
 #endif
 
-#ifdef CONFIG_FUTEX
-#include <linux/futex.h>
-
-int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
-{
-	u32 ownertid, uval;
-	unsigned int cpu;
-	struct rq *rq;
-
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Need to access the cpu field knowing that
-	 * DEBUG_PAGEALLOC could have unmapped it if
-	 * the mutex owner just released it and exited.
-	 */
-	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
-#else
-	cpu = owner->cpu;
-#endif
-
-	/*
-	 * Even if the access succeeded (likely case),
-	 * the cpu field may no longer be valid.
-	 */
-	if (cpu >= nr_cpumask_bits)
-		goto out;
-
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
-		goto out;
-
-	rq = cpu_rq(cpu);
-
-	if (get_user(ownertid, uaddr))
-		return -EFAULT;
-	ownertid &= FUTEX_TID_MASK;
-
-	for (;;) {
-		/*
-		 * Owner changed, break to re-assess state.
-		 */
-		if (get_user(uval, uaddr))
-			return -EFAULT;
-		if ((uval & FUTEX_TID_MASK) != ownertid)
-			break;
-
-		/*
-		 * Is that owner really running on that cpu?
-		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
-			return 0;
-
-		cpu_relax();
-	}
-out:
-	return 1;
-}
-#endif
-
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
-- 
1.6.3.3


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
