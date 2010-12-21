Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0LUTNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:13:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:50839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0LUTNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:13:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,208,1291622400"; 
   d="scan'208";a="585915228"
Message-ID: <4D10FC40.6070808@linux.intel.com>
Date: Tue, 21 Dec 2010 11:13:04 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4 V2 ] futex,plist: pass the real head of the priority
 list to plist_del()
References: <4D107979.2020405@cn.fujitsu.com>
In-Reply-To: <4D107979.2020405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:55 AM, Lai Jiangshan wrote:

Hi Lai,

Looks about ready to me, only a couple of more nitpics from me.

>
> Some plist_del()s in kernel/futex.c are passed a faked head of the
> priority list.
>
> It can work because current code does not require the real head

Awkward, how about:
It does not fail because the current...

> in plist_del(). The code of plist_del() just uses the head for checking,
> so it will not cause bad result even when we use a faked head.

a bad result

>
> But it is an undocumented usage:

s/an//

>
> /**
>   * plist_del - Remove a @node from plist.
>   *
>   * @node:	&struct plist_node pointer - entry to be removed
>   * @head:	&struct plist_head pointer - list head
>   */
>
> The document said that @head is "list head" the head of the priority list.
>
> In futex code, several places use "plist_del(&q->list,&q->list.plist);",
> they passes faked head, we fix them all.
>
> Thank to Darren Hart for many suggests.

s/Thank/Thanks/
s/suggests/suggestions/

>
> Signed-off-by:  Lai Jiangshan<laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 3019b92..d901f40 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -740,6 +740,23 @@ retry:
>   	return ret;
>   }
>
> +/**
> + * __unqueue_futex() - Remove the futex_q from its futex_hash_bucket
> + * @q:	The futex_q to unqueue
> + *
> + * The q->lock_ptr must not be NULL and must be held by the caller.
> + */
> +static void __unqueue_futex(struct futex_q *q)
> +{
> +	struct futex_hash_bucket *hb;
> +
> +	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)))
> +		return;
> +
> +	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
> +	plist_del(&q->list,&hb->chain);
> +}

I like this approach better than the previous version.

> +
>   /*
>    * The hash bucket lock must be held when this is called.
>    * Afterwards, the futex_q must not be accessed.
> @@ -757,7 +774,7 @@ static void wake_futex(struct futex_q *q)
>   	 */
>   	get_task_struct(p);
>
> -	plist_del(&q->list,&q->list.plist);
> +	__unqueue_futex(q);
>   	/*
>   	 * The waiting task can free the futex_q as soon as
>   	 * q->lock_ptr = NULL is written, without taking any locks. A
> @@ -1067,7 +1084,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
>   	q->key = *key;
>
>   	WARN_ON(plist_node_empty(&q->list));
> -	plist_del(&q->list,&q->list.plist);
> +	__unqueue_futex(q);

The WARN_ON here is used several times, but there is no longer an 
explicit plist operation to follow. Suggest moving the WARN_ON into 
__unqueue_futex() and keep it together with the plist_del.


>   	WARN_ON(!q->rt_waiter);
>   	q->rt_waiter = NULL;
> @@ -1471,7 +1488,7 @@ retry:
>   			goto retry;
>   		}
>   		WARN_ON(plist_node_empty(&q->list));
> -		plist_del(&q->list,&q->list.plist);
> +		__unqueue_futex(q);

here too

>
>   		BUG_ON(q->pi_state);
>
> @@ -1492,7 +1509,7 @@ static void unqueue_me_pi(struct futex_q *q)
>   	__releases(q->lock_ptr)
>   {
>   	WARN_ON(plist_node_empty(&q->list));
> -	plist_del(&q->list,&q->list.plist);
> +	__unqueue_futex(q);

and here

>
>   	BUG_ON(!q->pi_state);
>   	free_pi_state(q->pi_state);
> @@ -2133,7 +2150,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
>   		 * We were woken prior to requeue by a timeout or a signal.
>   		 * Unqueue the futex_q and determine which it was.
>   		 */
> -		plist_del(&q->list,&q->list.plist);
> +		plist_del(&q->list,&hb->chain);
>
>   		/* Handle spurious wakeups gracefully */
>   		ret = -EWOULDBLOCK;

Thanks Lai!

-- 
Darren Hart
Yocto Linux Kernel
