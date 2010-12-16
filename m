Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0LPVTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:19:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:4310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0LPVTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:19:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,356,1288594800"; 
   d="scan'208";a="687925617"
Message-ID: <4D0A825F.1010408@linux.intel.com>
Date: Thu, 16 Dec 2010 13:19:27 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] plist: pass the real plist_head to plist_del()
References: <4D09E897.7090406@cn.fujitsu.com>
In-Reply-To: <4D09E897.7090406@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 02:23 AM, Lai Jiangshan wrote:
> These patches shrink the struct plist_head. After it is shrinked
> plist_del() required a real plist_head passed into.
>
> My tests did not cover all paths.
>
> Subject: plist: pass the real plist_head to plist_del()
>
>
> Some plist_del()s in kernel/futex.c are passed a faked plist_head.

Can you explain what you mean by a "faked plist_head"? I'm looking at 
the existing source and q.list.plist is a "struct plist_head". Is it the 
required knowledge of the implementation of a plist_node that the 
current implementation depends on that you object to? Effectively a lack 
of encapsulation?

>
> It can work because current code does not require real plist_head
> in plist_del(). But it is an undocumented usage, it is not good.


Please compare the results of the futextest performance tests before and 
after your applied patch and report the results with the patch:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git


>
> Signed-off-by:  Lai Jiangshan<laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..6c4f67a 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -158,6 +158,15 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
>   }
>
>   /*
> + * find the bucket of a futex entry.
> + * the same as hash_futex(&q->key) but a little more effcient

efficient.

Please capitalize the first word in each sentence.

> + */


Please use proper kernel doc formatting for any new functions added to 
futex.c.


> +static struct futex_hash_bucket *futex_bucket(struct futex_q *q)
> +{
> +	return container_of(q->lock_ptr, struct futex_hash_bucket, lock);
> +}


Have you found the jhash2 to be a bottleneck in a particular path? Or 
was it an optimization to reduce the impact of the changes below (I'm 
assuming the latter).


> +
> +/*
>    * Take a reference to the resource addressed by a key.
>    * Can be called while holding spinlocks.
>    *
> @@ -744,7 +753,7 @@ static void wake_futex(struct futex_q *q)
>   	 */
>   	get_task_struct(p);
>
> -	plist_del(&q->list,&q->list.plist);
> +	plist_del(&q->list,&futex_bucket(q)->chain);


Space after the comma while you're at it.


>   	/*
>   	 * The waiting task can free the futex_q as soon as
>   	 * q->lock_ptr = NULL is written, without taking any locks. A
> @@ -1053,7 +1062,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
>   	q->key = *key;
>
>   	WARN_ON(plist_node_empty(&q->list));
> -	plist_del(&q->list,&q->list.plist);
> +	plist_del(&q->list,&futex_bucket(q)->chain);


Space after the comma while you're at it.


>
>   	WARN_ON(!q->rt_waiter);
>   	q->rt_waiter = NULL;
> @@ -1457,7 +1466,7 @@ retry:
>   			goto retry;
>   		}
>   		WARN_ON(plist_node_empty(&q->list));
> -		plist_del(&q->list,&q->list.plist);
> +		plist_del(&q->list,&futex_bucket(q)->chain);


Space after the comma while you're at it.


>   		BUG_ON(q->pi_state);
>
> @@ -1478,7 +1487,7 @@ static void unqueue_me_pi(struct futex_q *q)
>   	__releases(q->lock_ptr)
>   {
>   	WARN_ON(plist_node_empty(&q->list));
> -	plist_del(&q->list,&q->list.plist);
> +	plist_del(&q->list,&futex_bucket(q)->chain);


Space after the comma while you're at it.


>   	BUG_ON(!q->pi_state);
>   	free_pi_state(q->pi_state);
> @@ -2145,7 +2154,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
>   		 * We were woken prior to requeue by a timeout or a signal.
>   		 * Unqueue the futex_q and determine which it was.
>   		 */
> -		plist_del(&q->list,&q->list.plist);
> +		plist_del(&q->list,&hb->chain);


Space after the comma while you're at it.


>   		/* Handle spurious wakeups gracefully */
>   		ret = -EWOULDBLOCK;


-- 
Darren Hart
Yocto Linux Kernel
