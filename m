Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1INPqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:46:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:25669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1INPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:46:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48390131"
Message-ID: <4E70CC3B.4000905@linux.intel.com>
Date: Wed, 14 Sep 2011 08:46:03 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
References: <20110914133034.687048806@chello.nl> <20110914133750.831707072@chello.nl>
In-Reply-To: <20110914133750.831707072@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/14/2011 06:30 AM, Peter Zijlstra wrote:
> Use the brand spanking new wake_list to delay the futex wakeups until
> after we've released the hash bucket locks. This avoids the newly
> woken tasks from immediately getting stuck on the hb lock.
> 
> This is esp. painful on -rt, where the hb lock is preemptible.

Nice!

Have you run this through the functional and performance tests from
futextest? Looks like I should also add a multiwake test to really
showcase this.

If you don't have it local I can setup a github repository for futextest
until korg is back.... or do the testing myself... right.

> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/futex.c |   23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/kernel/futex.c
> ===================================================================
> --- linux-2.6.orig/kernel/futex.c
> +++ linux-2.6/kernel/futex.c
> @@ -823,7 +823,7 @@ static void __unqueue_futex(struct futex
>   * The hash bucket lock must be held when this is called.
>   * Afterwards, the futex_q must not be accessed.
>   */
> -static void wake_futex(struct futex_q *q)
> +static void wake_futex(struct wake_list_head *wake_list, struct futex_q *q)

A good opportunity to add the proper kerneldoc to this function as well.

>  {
>  	struct task_struct *p = q->task;
>  
> @@ -834,7 +834,7 @@ static void wake_futex(struct futex_q *q
>  	 * struct. Prevent this by holding a reference on p across the
>  	 * wake up.
>  	 */
> -	get_task_struct(p);
> +	wake_list_add(wake_list, p);
>  
>  	__unqueue_futex(q);
>  	/*
> @@ -845,9 +845,6 @@ static void wake_futex(struct futex_q *q
>  	 */
>  	smp_wmb();
>  	q->lock_ptr = NULL;
> -
> -	wake_up_state(p, TASK_NORMAL);
> -	put_task_struct(p);
>  }
>  
>  static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
> @@ -964,6 +961,7 @@ futex_wake(u32 __user *uaddr, unsigned i
>  	struct futex_q *this, *next;
>  	struct plist_head *head;
>  	union futex_key key = FUTEX_KEY_INIT;
> +	WAKE_LIST(wake_list);
>  	int ret;
>  
>  	if (!bitset)
> @@ -988,7 +986,7 @@ futex_wake(u32 __user *uaddr, unsigned i
>  			if (!(this->bitset & bitset))
>  				continue;
>  
> -			wake_futex(this);
> +			wake_futex(&wake_list, this);


I guess this is OK. wake_futex_pi will always be one task I believe, so
the list syntax might confuse newcomers... Would it make sense to have a
wake_futex_list() call? Thinking outloud...

>  			if (++ret >= nr_wake)
>  				break;
>  		}
> @@ -996,6 +994,8 @@ futex_wake(u32 __user *uaddr, unsigned i
>  
>  	spin_unlock(&hb->lock);
>  	put_futex_key(&key);
> +
> +	wake_up_list(&wake_list, TASK_NORMAL);
>  out:
>  	return ret;
>  }
> @@ -1012,6 +1012,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
>  	struct futex_hash_bucket *hb1, *hb2;
>  	struct plist_head *head;
>  	struct futex_q *this, *next;
> +	WAKE_LIST(wake_list);
>  	int ret, op_ret;
>  
>  retry:
> @@ -1062,7 +1063,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
>  
>  	plist_for_each_entry_safe(this, next, head, list) {
>  		if (match_futex (&this->key, &key1)) {
> -			wake_futex(this);
> +			wake_futex(&wake_list, this);
>  			if (++ret >= nr_wake)
>  				break;
>  		}
> @@ -1074,7 +1075,7 @@ futex_wake_op(u32 __user *uaddr1, unsign
>  		op_ret = 0;
>  		plist_for_each_entry_safe(this, next, head, list) {
>  			if (match_futex (&this->key, &key2)) {
> -				wake_futex(this);
> +				wake_futex(&wake_list, this);
>  				if (++op_ret >= nr_wake2)
>  					break;
>  			}
> @@ -1087,6 +1088,8 @@ futex_wake_op(u32 __user *uaddr1, unsign
>  	put_futex_key(&key2);
>  out_put_key1:
>  	put_futex_key(&key1);
> +
> +	wake_up_list(&wake_list, TASK_NORMAL);
>  out:
>  	return ret;
>  }
> @@ -1239,6 +1242,7 @@ static int futex_requeue(u32 __user *uad
>  	struct futex_hash_bucket *hb1, *hb2;
>  	struct plist_head *head1;
>  	struct futex_q *this, *next;
> +	WAKE_LIST(wake_list);
>  	u32 curval2;
>  
>  	if (requeue_pi) {
> @@ -1384,7 +1388,7 @@ static int futex_requeue(u32 __user *uad
>  		 * woken by futex_unlock_pi().
>  		 */
>  		if (++task_count <= nr_wake && !requeue_pi) {
> -			wake_futex(this);
> +			wake_futex(&wake_list, this);
>  			continue;
>  		}
>  
> @@ -1437,6 +1441,7 @@ static int futex_requeue(u32 __user *uad
>  	put_futex_key(&key2);
>  out_put_key1:
>  	put_futex_key(&key1);
> +	wake_up_list(&wake_list, TASK_NORMAL);
>  out:
>  	if (pi_state != NULL)
>  		free_pi_state(pi_state);
> 
> 

I _think_ requeue_pi is in the clear here as it uses
requeue_pi_wake_futex, which calls wake_up_state directly. Still, some
testing with futextest functional/futex_requeue_pi is in order.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
